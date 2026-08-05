import 'dart:async';

import 'package:drift/drift.dart';

import '../../core/config/env_config.dart';
import '../../core/services/app_logger.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/supabase_service.dart';
import '../local/app_database.dart';
import '../remote/foto_service.dart';

/// Motor de sincronización offline → Supabase.
///
/// Corre sólo en Android. Cada ciclo:
///   1. Comprueba que haya internet **real** (no sólo interfaz de red: el WiFi
///      de una planta puede estar levantado y sin salida).
///   2. Sube las fotos pendientes y luego empuja las filas.
///   3. Baja los catálogos de referencia.
///
/// El orden de subida respeta las dependencias: un visitante antes que el
/// registro de acceso que lo referencia, el evento de bitácora antes que sus
/// fotos, la recepción de turno antes que sus partidas.
class SyncEngine {
  SyncEngine(this._db);

  final AppDatabase _db;

  static const _intervalo = Duration(seconds: 30);
  static const _timeoutOperacion = Duration(seconds: 20);
  static const _maxIntentosPorFila = 8;
  static const _maxErroresConsecutivos = 3;

  Timer? _timer;
  bool _ciclando = false;
  int _erroresConsecutivos = 0;

  final _estado = StreamController<SyncEstado>.broadcast();
  Stream<SyncEstado> get estado => _estado.stream;

  void iniciar() {
    if (_timer != null) return;
    AppLogger.i('Motor de sincronización iniciado');
    _timer = Timer.periodic(_intervalo, (_) => sincronizarAhora());
    unawaited(sincronizarAhora());
  }

  void detener() {
    _timer?.cancel();
    _timer = null;
    AppLogger.i('Motor de sincronización detenido');
  }

  Future<void> dispose() async {
    detener();
    await _estado.close();
  }

  /// Dispara un ciclo fuera de tiempo. La app lo llama al guardar algo, para
  /// que el elemento vea el registro sincronizado sin esperar 30 s.
  Future<void> sincronizarAhora() async {
    if (_ciclando) return;
    if (!SupabaseService.haySesion) return;

    _ciclando = true;
    _emitir(SyncEstado.sincronizando);

    try {
      final hayRed = await ConnectivityService.instancia.hayInternetReal(
        sonda: () => SupabaseService.cliente
            .from('sitios')
            .select('id')
            .limit(1)
            .then((_) {}),
      );

      if (!hayRed) {
        _emitir(SyncEstado.sinConexion);
        return;
      }

      // Cortacircuitos: tras varios fallos seguidos dejamos de intentar en este
      // ciclo. Sin esto, una caída del backend hace que cada ciclo de 30 s
      // gaste batería reintentando decenas de filas contra un servidor caído.
      _erroresConsecutivos = 0;

      await _empujarVisitantes();
      await _empujarAsistencias();
      await _empujarRegistrosAcceso();
      await _empujarBitacoraEventos();
      await _empujarBitacoraFotos();
      await _empujarRecepciones();
      await _empujarRecepcionItems();

      await _bajarReferencias();

      final pendientes = await _db.pendientesDeSincronizar();
      _emitir(pendientes > 0 ? SyncEstado.conPendientes : SyncEstado.alDia);
    } catch (e, s) {
      AppLogger.e('Ciclo de sincronización falló', e, s);
      _emitir(SyncEstado.error);
    } finally {
      _ciclando = false;
    }
  }

  void _emitir(SyncEstado e) {
    if (!_estado.isClosed) _estado.add(e);
  }

  bool get _cortocircuitado => _erroresConsecutivos >= _maxErroresConsecutivos;

  // ───────────────────────────────────────────────────────────────────────────
  // SUBIDA
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _empujarAsistencias() async {
    final filas = await (_db.select(_db.localAsistencias)
          ..where((t) => _esPendiente(t.syncStatus, t.syncIntentos)))
        .get();

    for (final fila in filas) {
      if (_cortocircuitado) return;
      try {
        // La selfie tiene que existir en Storage antes de que la fila la
        // referencie; si no, quedaría apuntando a una URL inexistente.
        var selfieUrl = fila.selfieUrl;
        if (selfieUrl == null && fila.selfieRutaLocal != null) {
          selfieUrl = await FotoService.subir(
            rutaLocal: fila.selfieRutaLocal!,
            bucket: EnvConfig.bucketEvidencias,
            sitioId: fila.sitioId,
          );
          if (selfieUrl != null) {
            await (_db.update(_db.localAsistencias)
                  ..where((t) => t.localId.equals(fila.localId)))
                .write(LocalAsistenciasCompanion(selfieUrl: Value(selfieUrl)));
          }
        }

        final respuesta = await SupabaseService.cliente
            .from('asistencias')
            .upsert({
              'local_id': fila.localId,
              'device_id': fila.deviceId,
              'usuario_id': fila.usuarioId,
              'sitio_id': fila.sitioId,
              'turno_fecha': _soloFecha(fila.turnoFecha),
              'tipo_evento': fila.tipoEvento,
              'ocurrido_at': fila.ocurridoAt.toUtc().toIso8601String(),
              'lat': fila.lat,
              'lng': fila.lng,
              'gps_accuracy_m': fila.gpsAccuracyM,
              'wifi_bssid': fila.wifiBssid,
              'wifi_ssid': fila.wifiSsid,
              'selfie_url': selfieUrl,
              'liveness_passed': fila.livenessPassed,
              'observaciones': fila.observaciones,
            }, onConflict: 'local_id')
            .select()
            .single()
            .timeout(_timeoutOperacion);

        // El servidor es quien clasifica la puntualidad. Guardamos su veredicto
        // para poder mostrárselo al elemento sin volver a consultar.
        await (_db.update(_db.localAsistencias)
              ..where((t) => t.localId.equals(fila.localId)))
            .write(LocalAsistenciasCompanion(
          remoteId: Value(respuesta['id'] as String?),
          syncStatus: const Value('sincronizado'),
          syncError: const Value(''),
          syncedAt: Value(DateTime.now()),
          clasificacionServidor: Value(respuesta['clasificacion'] as String?),
          minutosRetardoServidor: Value(respuesta['minutos_retardo'] as int?),
          estadoValidacionServidor:
              Value(respuesta['estado_validacion'] as String?),
        ));

        await FotoService.borrarLocal(fila.selfieRutaLocal);
      } catch (e) {
        await _marcarFallo(_db.localAsistencias, fila.localId,
            fila.syncIntentos, e);
      }
    }
  }

  Future<void> _empujarVisitantes() async {
    final filas = await (_db.select(_db.localVisitantes)
          ..where((t) => _esPendiente(t.syncStatus, t.syncIntentos)))
        .get();

    for (final fila in filas) {
      if (_cortocircuitado) return;
      try {
        final respuesta = await SupabaseService.cliente
            .from('visitantes')
            .upsert({
              'local_id': fila.localId,
              'device_id': fila.deviceId,
              'nombre_completo': fila.nombreCompleto,
              'empresa': fila.empresa,
              'telefono': fila.telefono,
              'placas_habituales': fila.placasHabituales,
              'notas': fila.notas,
              'es_frecuente': fila.esFrecuente,
              'vetado': fila.vetado,
              'motivo_veto': fila.motivoVeto,
            }, onConflict: 'local_id')
            .select('id')
            .single()
            .timeout(_timeoutOperacion);

        await _marcarExito(
            _db.localVisitantes, fila.localId, respuesta['id'] as String?);
      } catch (e) {
        await _marcarFallo(
            _db.localVisitantes, fila.localId, fila.syncIntentos, e);
      }
    }
  }

  Future<void> _empujarRegistrosAcceso() async {
    final filas = await (_db.select(_db.localRegistrosAcceso)
          ..where((t) => _esPendiente(t.syncStatus, t.syncIntentos)))
        .get();

    for (final fila in filas) {
      if (_cortocircuitado) return;
      try {
        // Si el visitante recurrente aún no ha subido, esperamos al próximo
        // ciclo: sin su uuid remoto la referencia quedaría rota.
        String? visitanteRemoto;
        if (fila.visitanteLocalId != null) {
          visitanteRemoto = await _remoteIdDe(
              _db.localVisitantes, fila.visitanteLocalId!);
          if (visitanteRemoto == null) continue;
        }

        var identificacionUrl = fila.identificacionUrl;
        if (identificacionUrl == null && fila.identificacionRutaLocal != null) {
          identificacionUrl = await FotoService.subir(
            rutaLocal: fila.identificacionRutaLocal!,
            // Bucket aparte: las identificaciones se purgan a los 90 días y
            // sólo las ve el personal de seguridad, no el cliente.
            bucket: EnvConfig.bucketIdentificaciones,
            sitioId: fila.sitioId,
          );
        }

        final respuesta = await SupabaseService.cliente
            .from('registros_acceso')
            .upsert({
              'local_id': fila.localId,
              'device_id': fila.deviceId,
              'sitio_id': fila.sitioId,
              'registrado_por': fila.registradoPor,
              'visitante_id': visitanteRemoto,
              'nombre_completo': fila.nombreCompleto,
              'empresa_procedencia': fila.empresaProcedencia,
              'telefono': fila.telefono,
              'persona_visitada_id': fila.personaVisitadaId,
              'persona_visitada_texto': fila.personaVisitadaTexto,
              'asunto': fila.asunto,
              'ingresa_vehiculo': fila.ingresaVehiculo,
              'placas': fila.placas,
              'vehiculo_marca': fila.vehiculoMarca,
              'vehiculo_modelo': fila.vehiculoModelo,
              'vehiculo_color': fila.vehiculoColor,
              'identificacion_tipo': fila.identificacionTipo,
              'identificacion_foto_url': identificacionUrl,
              'aviso_privacidad_id': fila.avisoPrivacidadId,
              'aviso_aceptado': fila.avisoAceptado,
              'aviso_aceptado_at': fila.avisoAceptadoAt?.toUtc().toIso8601String(),
              'hora_entrada': fila.horaEntrada.toUtc().toIso8601String(),
              'hora_salida': fila.horaSalida?.toUtc().toIso8601String(),
              'salida_registrada_por': fila.salidaRegistradaPor,
              'observaciones': fila.observaciones,
            }, onConflict: 'local_id')
            .select('id')
            .single()
            .timeout(_timeoutOperacion);

        await (_db.update(_db.localRegistrosAcceso)
              ..where((t) => t.localId.equals(fila.localId)))
            .write(LocalRegistrosAccesoCompanion(
          remoteId: Value(respuesta['id'] as String?),
          identificacionUrl: Value(identificacionUrl),
          syncStatus: const Value('sincronizado'),
          syncError: const Value(''),
          syncedAt: Value(DateTime.now()),
        ));

        await FotoService.borrarLocal(fila.identificacionRutaLocal);
      } catch (e) {
        await _marcarFallo(
            _db.localRegistrosAcceso, fila.localId, fila.syncIntentos, e);
      }
    }
  }

  Future<void> _empujarBitacoraEventos() async {
    final filas = await (_db.select(_db.localBitacoraEventos)
          ..where((t) => _esPendiente(t.syncStatus, t.syncIntentos)))
        .get();

    for (final fila in filas) {
      if (_cortocircuitado) return;
      try {
        final respuesta = await SupabaseService.cliente
            .from('bitacora_eventos')
            .upsert({
              'local_id': fila.localId,
              'device_id': fila.deviceId,
              'sitio_id': fila.sitioId,
              'registrado_por': fila.registradoPor,
              'turno_fecha': _soloFecha(fila.turnoFecha),
              'tipo': fila.tipo,
              'ocurrido_at': fila.ocurridoAt.toUtc().toIso8601String(),
              'descripcion': fila.descripcion,
              'placas': fila.placas,
              'transportista': fila.transportista,
              'empresa_transporte': fila.empresaTransporte,
              'num_documento': fila.numDocumento,
              'destino': fila.destino,
              'autorizado_por_id': fila.autorizadoPorId,
              'autorizado_por_texto': fila.autorizadoPorTexto,
              'prioridad': fila.prioridad,
            }, onConflict: 'local_id')
            .select('id')
            .single()
            .timeout(_timeoutOperacion);

        await _marcarExito(
            _db.localBitacoraEventos, fila.localId, respuesta['id'] as String?);
      } catch (e) {
        await _marcarFallo(
            _db.localBitacoraEventos, fila.localId, fila.syncIntentos, e);
      }
    }
  }

  Future<void> _empujarBitacoraFotos() async {
    final filas = await (_db.select(_db.localBitacoraFotos)
          ..where((t) => _esPendiente(t.syncStatus, t.syncIntentos)))
        .get();

    for (final fila in filas) {
      if (_cortocircuitado) return;
      try {
        final eventoRemoto =
            await _remoteIdDe(_db.localBitacoraEventos, fila.eventoLocalId);
        if (eventoRemoto == null) continue; // el evento aún no sube

        final sitioId = await _sitioDelEvento(fila.eventoLocalId);
        if (sitioId == null) continue;

        var url = fila.fotoUrl;
        if (url == null && fila.rutaLocal != null) {
          url = await FotoService.subir(
            rutaLocal: fila.rutaLocal!,
            bucket: EnvConfig.bucketEvidencias,
            sitioId: sitioId,
          );
        }
        if (url == null) continue;

        final respuesta = await SupabaseService.cliente
            .from('bitacora_fotos')
            .upsert({
              'local_id': fila.localId,
              'evento_id': eventoRemoto,
              'foto_url': url,
              'descripcion': fila.descripcion,
              'orden': fila.orden,
            }, onConflict: 'local_id')
            .select('id')
            .single()
            .timeout(_timeoutOperacion);

        await (_db.update(_db.localBitacoraFotos)
              ..where((t) => t.localId.equals(fila.localId)))
            .write(LocalBitacoraFotosCompanion(
          remoteId: Value(respuesta['id'] as String?),
          fotoUrl: Value(url),
          syncStatus: const Value('sincronizado'),
          syncError: const Value(''),
          syncedAt: Value(DateTime.now()),
        ));

        await FotoService.borrarLocal(fila.rutaLocal);
      } catch (e) {
        await _marcarFallo(
            _db.localBitacoraFotos, fila.localId, fila.syncIntentos, e);
      }
    }
  }

  Future<void> _empujarRecepciones() async {
    final filas = await (_db.select(_db.localRecepcionesTurno)
          ..where((t) => _esPendiente(t.syncStatus, t.syncIntentos)))
        .get();

    for (final fila in filas) {
      if (_cortocircuitado) return;
      try {
        final respuesta = await SupabaseService.cliente
            .from('recepciones_turno')
            .upsert({
              'local_id': fila.localId,
              'device_id': fila.deviceId,
              'sitio_id': fila.sitioId,
              'turno_fecha': _soloFecha(fila.turnoFecha),
              'recibe_id': fila.recibeId,
              'entrega_id': fila.entregaId,
              'acepta_conformidad': fila.aceptaConformidad,
              'aceptado_at': fila.aceptadoAt.toUtc().toIso8601String(),
              'observaciones': fila.observaciones,
            }, onConflict: 'local_id')
            .select('id')
            .single()
            .timeout(_timeoutOperacion);

        await _marcarExito(_db.localRecepcionesTurno, fila.localId,
            respuesta['id'] as String?);
      } catch (e) {
        await _marcarFallo(
            _db.localRecepcionesTurno, fila.localId, fila.syncIntentos, e);
      }
    }
  }

  Future<void> _empujarRecepcionItems() async {
    final filas = await (_db.select(_db.localRecepcionItems)
          ..where((t) => _esPendiente(t.syncStatus, t.syncIntentos)))
        .get();

    for (final fila in filas) {
      if (_cortocircuitado) return;
      try {
        final recepcionRemota = await _remoteIdDe(
            _db.localRecepcionesTurno, fila.recepcionLocalId);
        if (recepcionRemota == null) continue;

        var url = fila.fotoUrl;
        if (url == null && fila.fotoRutaLocal != null) {
          final sitioId = await _sitioDeRecepcion(fila.recepcionLocalId);
          if (sitioId != null) {
            url = await FotoService.subir(
              rutaLocal: fila.fotoRutaLocal!,
              bucket: EnvConfig.bucketEvidencias,
              sitioId: sitioId,
            );
          }
        }

        final respuesta = await SupabaseService.cliente
            .from('recepcion_turno_items')
            .upsert({
              'local_id': fila.localId,
              'recepcion_id': recepcionRemota,
              'equipo_id': fila.equipoId,
              'estado': fila.estado,
              'cantidad_encontrada': fila.cantidadEncontrada,
              'observaciones': fila.observaciones,
              'foto_url': url,
            }, onConflict: 'local_id')
            .select('id')
            .single()
            .timeout(_timeoutOperacion);

        await (_db.update(_db.localRecepcionItems)
              ..where((t) => t.localId.equals(fila.localId)))
            .write(LocalRecepcionItemsCompanion(
          remoteId: Value(respuesta['id'] as String?),
          fotoUrl: Value(url),
          syncStatus: const Value('sincronizado'),
          syncError: const Value(''),
          syncedAt: Value(DateTime.now()),
        ));

        await FotoService.borrarLocal(fila.fotoRutaLocal);
      } catch (e) {
        await _marcarFallo(
            _db.localRecepcionItems, fila.localId, fila.syncIntentos, e);
      }
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // BAJADA DE CATÁLOGOS
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _bajarReferencias() async {
    try {
      final cliente = SupabaseService.cliente;

      final sitios = await cliente.from('sitios').select().timeout(_timeoutOperacion);
      await _db.batch((b) {
        for (final s in sitios) {
          b.insert(
            _db.localSitios,
            LocalSitiosCompanion.insert(
              id: s['id'] as String,
              nombre: s['nombre'] as String,
              lat: Value(_aDouble(s['lat'])),
              lng: Value(_aDouble(s['lng'])),
              radioMetros: Value(s['radio_metros'] as int? ?? 150),
              horaInicioTurno: Value(s['hora_inicio_turno'] as String? ?? '08:00'),
              minutosToleranciaRetardo:
                  Value(s['minutos_tolerancia_retardo'] as int? ?? 1),
              minutosToleranciaFalta:
                  Value(s['minutos_tolerancia_falta'] as int? ?? 90),
              husoHorarioOffsetH: Value(s['huso_horario_offset_h'] as int? ?? -6),
              activo: Value(s['activo'] as bool? ?? true),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      final aps = await cliente.from('sitio_wifi_aps').select().timeout(_timeoutOperacion);
      await _db.batch((b) {
        for (final a in aps) {
          b.insert(
            _db.localWifiAps,
            LocalWifiApsCompanion.insert(
              id: a['id'] as String,
              sitioId: a['sitio_id'] as String,
              bssid: a['bssid'] as String,
              ssid: Value(a['ssid'] as String? ?? ''),
              nombreZona: Value(a['nombre_zona'] as String? ?? ''),
              activo: Value(a['activo'] as bool? ?? true),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      final equipo = await cliente.from('catalogo_equipo').select().timeout(_timeoutOperacion);
      await _db.batch((b) {
        for (final e in equipo) {
          b.insert(
            _db.localCatalogoEquipo,
            LocalCatalogoEquipoCompanion.insert(
              id: e['id'] as String,
              sitioId: e['sitio_id'] as String,
              nombre: e['nombre'] as String,
              descripcion: Value(e['descripcion'] as String? ?? ''),
              categoria: Value(e['categoria'] as String? ?? 'general'),
              cantidadEsperada: Value(e['cantidad_esperada'] as int? ?? 1),
              requiereFoto: Value(e['requiere_foto'] as bool? ?? false),
              debeEstarSinUsar: Value(e['debe_estar_sin_usar'] as bool? ?? false),
              orden: Value(e['orden'] as int? ?? 0),
              activo: Value(e['activo'] as bool? ?? true),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      final personal = await cliente.from('personal_cliente').select().timeout(_timeoutOperacion);
      await _db.batch((b) {
        for (final p in personal) {
          b.insert(
            _db.localPersonalCliente,
            LocalPersonalClienteCompanion.insert(
              id: p['id'] as String,
              sitioId: p['sitio_id'] as String,
              nombreCompleto: p['nombre_completo'] as String,
              area: Value(p['area'] as String? ?? ''),
              puesto: Value(p['puesto'] as String? ?? ''),
              extension: Value(p['extension'] as String? ?? ''),
              activo: Value(p['activo'] as bool? ?? true),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      final perfiles = await cliente.from('profiles').select().timeout(_timeoutOperacion);
      await _db.batch((b) {
        for (final p in perfiles) {
          b.insert(
            _db.localProfiles,
            LocalProfilesCompanion.insert(
              id: p['id'] as String,
              nombreCompleto: p['nombre_completo'] as String? ?? '',
              rol: p['rol'] as String? ?? 'elemento',
              correo: Value(p['correo'] as String? ?? ''),
              telefonoWhatsapp: Value(p['telefono_whatsapp'] as String? ?? ''),
              puesto: Value(p['puesto'] as String? ?? ''),
              fotoPerfilUrl: Value(p['foto_perfil_url'] as String?),
              estadoLaboral: Value(p['estado_laboral'] as String? ?? 'activo'),
              activo: Value(p['activo'] as bool? ?? true),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      final avisos = await cliente
          .from('avisos_privacidad')
          .select()
          .eq('activo', true)
          .timeout(_timeoutOperacion);
      await _db.batch((b) {
        for (final a in avisos) {
          b.insert(
            _db.localAvisosPrivacidad,
            LocalAvisosPrivacidadCompanion.insert(
              id: a['id'] as String,
              version: a['version'] as String,
              titulo: a['titulo'] as String,
              resumen: a['resumen'] as String,
              urlCompleto: Value(a['url_completo'] as String? ?? ''),
              activo: Value(a['activo'] as bool? ?? true),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      final miId = SupabaseService.usuarioId;
      if (miId != null) {
        final turnos = await cliente
            .from('turnos')
            .select()
            .eq('usuario_id', miId)
            .order('inicio_at', ascending: false)
            .limit(20)
            .timeout(_timeoutOperacion);
        await _db.batch((b) {
          for (final t in turnos) {
            b.insert(
              _db.localTurnos,
              LocalTurnosCompanion.insert(
                id: t['id'] as String,
                usuarioId: t['usuario_id'] as String,
                sitioId: t['sitio_id'] as String,
                turnoFecha: DateTime.parse(t['turno_fecha'] as String),
                inicioAt: DateTime.parse(t['inicio_at'] as String).toLocal(),
                finAt: Value(t['fin_at'] == null
                    ? null
                    : DateTime.parse(t['fin_at'] as String).toLocal()),
                estado: t['estado'] as String,
                clasificacionEntrada:
                    Value(t['clasificacion_entrada'] as String? ?? 'a_tiempo'),
                minutosRetardo: Value(t['minutos_retardo'] as int? ?? 0),
                esDoblete: Value(t['es_doblete'] as bool? ?? false),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
      }

      AppLogger.sync('Catálogos actualizados');
    } catch (e) {
      AppLogger.w('No se pudieron bajar los catálogos: $e');
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // AUXILIARES
  // ───────────────────────────────────────────────────────────────────────────

  Expression<bool> _esPendiente(
    GeneratedColumn<String> estado,
    GeneratedColumn<int> intentos,
  ) {
    return (estado.equals('pendiente') | estado.equals('fallido')) &
        intentos.isSmallerThanValue(_maxIntentosPorFila);
  }

  Future<void> _marcarExito(
      TableInfo tabla, String localId, String? remoteId) async {
    await _db.customStatement(
      'UPDATE ${tabla.actualTableName} '
      'SET remote_id = ?, sync_status = ?, sync_error = ?, synced_at = ? '
      'WHERE local_id = ?',
      [
        remoteId,
        'sincronizado',
        '',
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        localId,
      ],
    );
  }

  Future<void> _marcarFallo(
      TableInfo tabla, String localId, int intentos, Object error) async {
    _erroresConsecutivos++;
    final mensaje = error.toString();
    AppLogger.w('Fila $localId de ${tabla.actualTableName} falló: $mensaje');

    await _db.customStatement(
      'UPDATE ${tabla.actualTableName} '
      'SET sync_status = ?, sync_error = ?, sync_intentos = ? '
      'WHERE local_id = ?',
      [
        'fallido',
        mensaje.length > 500 ? mensaje.substring(0, 500) : mensaje,
        intentos + 1,
        localId,
      ],
    );
  }

  Future<String?> _remoteIdDe(TableInfo tabla, String localId) async {
    final filas = await _db.customSelect(
      'SELECT remote_id FROM ${tabla.actualTableName} WHERE local_id = ?',
      variables: [Variable<String>(localId)],
    ).get();
    if (filas.isEmpty) return null;
    return filas.first.data['remote_id'] as String?;
  }

  Future<String?> _sitioDelEvento(String eventoLocalId) async {
    final fila = await (_db.select(_db.localBitacoraEventos)
          ..where((t) => t.localId.equals(eventoLocalId)))
        .getSingleOrNull();
    return fila?.sitioId;
  }

  Future<String?> _sitioDeRecepcion(String recepcionLocalId) async {
    final fila = await (_db.select(_db.localRecepcionesTurno)
          ..where((t) => t.localId.equals(recepcionLocalId)))
        .getSingleOrNull();
    return fila?.sitioId;
  }

  static String _soloFecha(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static double? _aDouble(Object? v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

/// Estado que se muestra en la barra superior de la app.
enum SyncEstado {
  alDia('Sincronizado'),
  conPendientes('Pendiente de subir'),
  sincronizando('Sincronizando…'),
  sinConexion('Sin conexión'),
  error('Error de sincronización');

  const SyncEstado(this.etiqueta);

  final String etiqueta;
}
