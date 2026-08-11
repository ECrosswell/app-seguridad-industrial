import 'package:supabase_flutter/supabase_flutter.dart' show FunctionException;

import '../../../core/services/supabase_service.dart';
import '../../../data/models/perfil.dart';
import '../../../data/models/sitio.dart';
import 'rondin_admin_models.dart';

class UsuarioAdminException implements Exception {
  const UsuarioAdminException(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

class RondinAdminException implements Exception {
  const RondinAdminException(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

/// Rango de fechas para los filtros de consulta y reportes.
class RangoFechas {
  const RangoFechas(this.desde, this.hasta);

  final DateTime desde;
  final DateTime hasta;

  factory RangoFechas.ultimosDias(int dias) {
    final hasta = DateTime.now();
    return RangoFechas(hasta.subtract(Duration(days: dias)), hasta);
  }

  factory RangoFechas.mesActual() {
    final ahora = DateTime.now();
    return RangoFechas(DateTime(ahora.year, ahora.month), ahora);
  }

  String get desdeIso => desde.toUtc().toIso8601String();
  String get hastaIso => hasta.toUtc().toIso8601String();

  /// Sólo fecha, para columnas `date` como `turno_fecha`.
  String get desdeFecha => _fecha(desde);
  String get hastaFecha => _fecha(hasta);

  static String _fecha(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

/// Consultas de la consola (web y vista de administración).
///
/// Habla directo con Supabase, sin Drift: el admin y el cliente trabajan desde
/// un escritorio con conexión, y montar un motor de sincronización para ellos
/// sería complejidad sin beneficio.
///
/// Ninguna consulta filtra por sitio explícitamente salvo cuando se pide: el
/// RLS de Postgres ya limita cada fila a los sitios que le tocan al usuario.
class PanelRepository {
  const PanelRepository();

  // ─── Tiempo real ──────────────────────────────────────────────────────────

  /// Personal actualmente en turno. Es la pantalla que más consulta el cliente:
  /// quién llegó, a qué hora y cómo contactarlo.
  Future<List<PersonalEnSitio>> personalEnSitio({String? sitioId}) async {
    var consulta = SupabaseService.cliente.from('v_personal_en_sitio').select();
    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    final filas = await consulta;
    return filas.map(PersonalEnSitio.desdeJson).toList();
  }

  /// Visitantes dentro de la planta ahora mismo.
  Future<List<VisitanteDentro>> visitantesDentro({String? sitioId}) async {
    var consulta = SupabaseService.cliente.from('v_visitantes_dentro').select();
    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    final filas = await consulta.order('hora_entrada', ascending: false);
    return filas.map(VisitanteDentro.desdeJson).toList();
  }

  // ─── Consultas históricas ─────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> asistencias({
    required RangoFechas rango,
    String? sitioId,
    String? usuarioId,
  }) async {
    var consulta = SupabaseService.cliente
        .from('asistencias')
        .select(
          '*, profiles!asistencias_usuario_id_fkey(nombre_completo), '
          'sitios(nombre)',
        )
        .isFilter('deleted_at', null)
        .gte('turno_fecha', rango.desdeFecha)
        .lte('turno_fecha', rango.hastaFecha);

    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);
    if (usuarioId != null) consulta = consulta.eq('usuario_id', usuarioId);

    return (await consulta.order('ocurrido_at', ascending: false).limit(500))
        .cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> turnos({
    required RangoFechas rango,
    String? sitioId,
  }) async {
    var consulta = SupabaseService.cliente
        .from('turnos')
        .select(
          '*, profiles!turnos_usuario_id_fkey(nombre_completo, telefono_whatsapp), '
          'sitios(nombre)',
        )
        .gte('turno_fecha', rango.desdeFecha)
        .lte('turno_fecha', rango.hastaFecha);

    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    return (await consulta.order('inicio_at', ascending: false).limit(500))
        .cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> registrosAcceso({
    required RangoFechas rango,
    String? sitioId,
  }) async {
    var consulta = SupabaseService.cliente
        .from('registros_acceso')
        .select(
          '*, personal_cliente(nombre_completo, area), '
          'profiles!registros_acceso_registrado_por_fkey(nombre_completo)',
        )
        .isFilter('deleted_at', null)
        .gte('hora_entrada', rango.desdeIso)
        .lte('hora_entrada', rango.hastaIso);

    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    return (await consulta.order('hora_entrada', ascending: false).limit(500))
        .cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> bitacora({
    required RangoFechas rango,
    String? sitioId,
    String? tipo,
  }) async {
    var consulta = SupabaseService.cliente
        .from('bitacora_eventos')
        .select(
          '*, profiles!bitacora_eventos_registrado_por_fkey(nombre_completo), '
          'personal_cliente(nombre_completo), bitacora_fotos(foto_url)',
        )
        .isFilter('deleted_at', null)
        .gte('ocurrido_at', rango.desdeIso)
        .lte('ocurrido_at', rango.hastaIso);

    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);
    if (tipo != null) consulta = consulta.eq('tipo', tipo);

    return (await consulta.order('ocurrido_at', ascending: false).limit(500))
        .cast<Map<String, dynamic>>();
  }

  /// Estado actual del equipo de cada caseta.
  Future<List<Map<String, dynamic>>> estadoEquipo({String? sitioId}) async {
    var consulta = SupabaseService.cliente
        .from('v_estado_equipo_sitio')
        .select();
    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);
    return (await consulta).cast<Map<String, dynamic>>();
  }

  /// Recepciones con novedad pendientes de atender por el administrador.
  Future<List<Map<String, dynamic>>> recepcionesConNovedad({
    String? sitioId,
  }) async {
    var consulta = SupabaseService.cliente
        .from('recepciones_turno')
        .select(
          '*, profiles!recepciones_turno_recibe_id_fkey(nombre_completo), '
          'sitios(nombre), recepcion_turno_items(*, catalogo_equipo(nombre))',
        )
        .isFilter('deleted_at', null)
        .eq('tiene_novedades', true);

    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    return (await consulta.order('aceptado_at', ascending: false).limit(100))
        .cast<Map<String, dynamic>>();
  }

  Future<void> marcarRecepcionAtendida(String id, String nota) async {
    await SupabaseService.cliente
        .from('recepciones_turno')
        .update({
          'atendido': true,
          'atendido_por': SupabaseService.usuarioId,
          'atendido_at': DateTime.now().toUtc().toIso8601String(),
          'nota_atencion': nota,
        })
        .eq('id', id);
  }

  // ─── Turnos ───────────────────────────────────────────────────────────────

  /// Cierra a mano un turno que quedó abierto porque el elemento olvidó
  /// registrar su salida. Deliberadamente **no** se cierra solo: queda
  /// constancia de quién lo cerró y por qué.
  Future<void> cerrarTurnoManual({
    required String turnoId,
    required String motivo,
  }) async {
    await SupabaseService.cliente
        .from('turnos')
        .update({
          'estado': 'cerrado_por_admin',
          'fin_at': DateTime.now().toUtc().toIso8601String(),
          'cerrado_por': SupabaseService.usuarioId,
          'cerrado_at': DateTime.now().toUtc().toIso8601String(),
          'motivo_cierre': motivo,
        })
        .eq('id', turnoId);
  }

  /// Asistencias que no validaron ubicación y esperan revisión.
  Future<List<Map<String, dynamic>>> asistenciasPorRevisar({
    String? sitioId,
  }) async {
    var consulta = SupabaseService.cliente
        .from('asistencias')
        .select(
          '*, profiles!asistencias_usuario_id_fkey(nombre_completo), sitios(nombre)',
        )
        .isFilter('deleted_at', null)
        .eq('estado_validacion', 'pendiente_revision');

    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    return (await consulta.order('ocurrido_at', ascending: false).limit(200))
        .cast<Map<String, dynamic>>();
  }

  Future<void> resolverAsistencia({
    required String asistenciaId,
    required bool aprobar,
    String notas = '',
  }) async {
    await SupabaseService.cliente
        .from('asistencias')
        .update({
          'estado_validacion': aprobar ? 'validado' : 'rechazado',
          'revisado_por': SupabaseService.usuarioId,
          'revisado_at': DateTime.now().toUtc().toIso8601String(),
          'notas_revision': notas,
        })
        .eq('id', asistenciaId);
  }

  // ─── Solicitudes del cliente ──────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> solicitudes({
    String? sitioId,
    String? estado,
  }) async {
    var consulta = SupabaseService.cliente
        .from('solicitudes')
        .select('*, profiles!solicitudes_creada_por_fkey(nombre_completo)')
        .isFilter('deleted_at', null);

    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);
    if (estado != null) consulta = consulta.eq('estado', estado);

    return (await consulta.order('created_at', ascending: false).limit(200))
        .cast<Map<String, dynamic>>();
  }

  Future<void> crearSolicitud({
    required String sitioId,
    required String asunto,
    required String descripcion,
    required String prioridad,
    required String categoria,
  }) async {
    await SupabaseService.cliente.from('solicitudes').insert({
      'local_id': DateTime.now().microsecondsSinceEpoch.toString(),
      'sitio_id': sitioId,
      'creada_por': SupabaseService.usuarioId,
      'asunto': asunto,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'categoria': categoria,
    });
  }

  Future<void> responderSolicitud({
    required String id,
    required String respuesta,
    required String estado,
  }) async {
    await SupabaseService.cliente
        .from('solicitudes')
        .update({
          'respuesta': respuesta,
          'estado': estado,
          'respondida_por': SupabaseService.usuarioId,
          'respondida_at': DateTime.now().toUtc().toIso8601String(),
          if (estado == 'cerrada')
            'cerrada_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', id);
  }

  // ─── Administración ───────────────────────────────────────────────────────

  Future<List<Sitio>> sitios() async {
    final filas = await SupabaseService.cliente
        .from('sitios')
        .select()
        .order('nombre');
    return filas.map(Sitio.desdeJson).toList();
  }

  Future<void> guardarSitio(Map<String, dynamic> datos) async {
    if (datos['id'] != null) {
      await SupabaseService.cliente
          .from('sitios')
          .update(datos..remove('id'))
          .eq('id', datos['id'] as String);
    } else {
      await SupabaseService.cliente.from('sitios').insert(datos..remove('id'));
    }
  }

  Future<List<Perfil>> usuarios({String? rol}) async {
    var consulta = SupabaseService.cliente.from('profiles').select();
    if (rol != null) consulta = consulta.eq('rol', rol);

    final filas = await consulta.order('nombre_completo');
    return filas.map(Perfil.desdeJson).toList();
  }

  /// Crea la cuenta mediante una Edge Function autenticada. La llave
  /// administrativa permanece en Supabase y nunca viaja en el cliente.
  Future<String> crearUsuario({
    required String nombreCompleto,
    required String correo,
    required String telefonoWhatsapp,
    required String rol,
    required String sitioId,
    required String passwordTemporal,
  }) async {
    final respuesta = await _invocarAdministracionUsuarios({
      'accion': 'crear',
      'nombre_completo': nombreCompleto.trim(),
      'correo': correo.trim().toLowerCase(),
      'telefono_whatsapp': telefonoWhatsapp,
      'rol': rol,
      'sitio_id': sitioId,
      'password_temporal': passwordTemporal,
    });

    final usuarioId = respuesta['usuario_id'] as String?;
    if (usuarioId == null || usuarioId.isEmpty) {
      throw const UsuarioAdminException(
        'La cuenta se creó sin un identificador válido. Actualiza la lista.',
      );
    }
    return usuarioId;
  }

  /// Asigna una contraseña temporal a otra cuenta. La función vuelve a marcar
  /// el perfil para que el usuario defina una privada en su siguiente acceso.
  Future<void> restablecerPasswordUsuario({
    required String usuarioId,
    required String passwordTemporal,
  }) async {
    await _invocarAdministracionUsuarios({
      'accion': 'restablecer_password',
      'usuario_id': usuarioId,
      'password_temporal': passwordTemporal,
    });
  }

  Future<Map<String, dynamic>> _invocarAdministracionUsuarios(
    Map<String, dynamic> cuerpo,
  ) async {
    final sesion = SupabaseService.auth.currentSession;
    if (sesion == null) {
      throw const UsuarioAdminException(
        'Tu sesión terminó. Inicia sesión nuevamente.',
      );
    }

    try {
      final respuesta = await SupabaseService.cliente.functions.invoke(
        'administrar-usuarios',
        body: cuerpo,
        headers: {'Authorization': 'Bearer ${sesion.accessToken}'},
      );
      final datos = respuesta.data;
      if (datos is Map) return Map<String, dynamic>.from(datos);
      throw const UsuarioAdminException(
        'La respuesta del servidor no es válida.',
      );
    } on FunctionException catch (e) {
      throw UsuarioAdminException(_mensajeFuncion(e));
    } on UsuarioAdminException {
      rethrow;
    } catch (_) {
      throw const UsuarioAdminException(
        'No se pudo conectar con la administración de usuarios.',
      );
    }
  }

  String _mensajeFuncion(FunctionException error) {
    final detalle = error.details;
    if (detalle is Map) {
      final mensaje = detalle['error'];
      if (mensaje is String && mensaje.trim().isNotEmpty) return mensaje;
    }
    return switch (error.status) {
      401 => 'Tu sesión terminó. Inicia sesión nuevamente.',
      403 => 'No tienes permiso para administrar usuarios.',
      404 => 'El usuario ya no existe.',
      409 => 'La operación entra en conflicto con el estado actual.',
      _ => 'No se pudo completar la operación.',
    };
  }

  /// Da de baja o reingresa a un elemento. **No** se borra la cuenta de auth:
  /// borrarla desharía la referencia de todos sus registros históricos.
  Future<void> cambiarEstadoLaboral({
    required String usuarioId,
    required String estado,
    String motivo = '',
  }) async {
    await SupabaseService.cliente
        .from('profiles')
        .update({
          'estado_laboral': estado,
          'activo': estado != 'baja',
          if (estado == 'baja') ...{
            'fecha_baja': DateTime.now().toIso8601String().split('T').first,
            'motivo_baja': motivo,
          },
          if (estado == 'reingreso') ...{
            'fecha_alta': DateTime.now().toIso8601String().split('T').first,
            'fecha_baja': null,
            'motivo_baja': '',
          },
        })
        .eq('id', usuarioId);
  }

  Future<void> asignarSitio({
    required String usuarioId,
    required String sitioId,
  }) async {
    await SupabaseService.cliente.from('usuario_sitios').upsert({
      'usuario_id': usuarioId,
      'sitio_id': sitioId,
      'es_principal': true,
    });
  }

  Future<List<Map<String, dynamic>>> personalCliente(String sitioId) async {
    return (await SupabaseService.cliente
            .from('personal_cliente')
            .select()
            .eq('sitio_id', sitioId)
            .order('nombre_completo'))
        .cast<Map<String, dynamic>>();
  }

  Future<void> guardarPersonalCliente(Map<String, dynamic> datos) async {
    final id = datos['id'] as String?;
    if (id != null) {
      await SupabaseService.cliente
          .from('personal_cliente')
          .update(datos..remove('id'))
          .eq('id', id);
    } else {
      await SupabaseService.cliente
          .from('personal_cliente')
          .insert(datos..remove('id'));
    }
  }

  Future<List<Map<String, dynamic>>> catalogoEquipo(String sitioId) async {
    return (await SupabaseService.cliente
            .from('catalogo_equipo')
            .select()
            .eq('sitio_id', sitioId)
            .order('orden'))
        .cast<Map<String, dynamic>>();
  }

  Future<void> guardarEquipo(Map<String, dynamic> datos) async {
    final id = datos['id'] as String?;
    if (id != null) {
      await SupabaseService.cliente
          .from('catalogo_equipo')
          .update(datos..remove('id'))
          .eq('id', id);
    } else {
      await SupabaseService.cliente
          .from('catalogo_equipo')
          .insert(datos..remove('id'));
    }
  }

  Future<List<Map<String, dynamic>>> wifiAps(String sitioId) async {
    return (await SupabaseService.cliente
            .from('sitio_wifi_aps')
            .select()
            .eq('sitio_id', sitioId)
            .order('nombre_zona'))
        .cast<Map<String, dynamic>>();
  }

  Future<void> guardarWifiAp(Map<String, dynamic> datos) async {
    final id = datos['id'] as String?;
    if (id != null) {
      await SupabaseService.cliente
          .from('sitio_wifi_aps')
          .update(datos..remove('id'))
          .eq('id', id);
    } else {
      await SupabaseService.cliente
          .from('sitio_wifi_aps')
          .insert(datos..remove('id'));
    }
  }

  // ─── Rondines QR ─────────────────────────────────────────────────────

  Future<List<SeccionRondin>> seccionesRondin({String? sitioId}) async {
    var consulta = SupabaseService.cliente.from('secciones_sitio').select();
    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    final filas = await consulta.order('nombre');
    return filas.map(SeccionRondin.desdeJson).toList();
  }

  /// Toda escritura pasa por la Edge Function para revalidar al admin y dejar
  /// auditoría; el cliente autenticado no tiene INSERT/UPDATE directo.
  Future<SeccionRondin> guardarSeccionRondin(Map<String, dynamic> datos) async {
    final cuerpo = Map<String, dynamic>.from(datos);
    final id = cuerpo.remove('id') as String?;
    final respuesta = await _invocarAdministracionRondines({
      'accion': id == null ? 'crear_seccion' : 'actualizar_seccion',
      'seccion_id': ?id,
      ...cuerpo,
    });
    final seccion = respuesta['seccion'];
    if (seccion is! Map) {
      throw const RondinAdminException(
        'La respuesta del servidor no contiene la sección guardada.',
      );
    }
    return SeccionRondin.desdeJson(Map<String, dynamic>.from(seccion));
  }

  Future<List<PuntoRondin>> puntosRondin({String? sitioId}) async {
    var consulta = SupabaseService.cliente
        .from('puntos_rondin')
        .select(
          'id, sitio_id, seccion_id, nombre, descripcion, lat, lng, '
          'radio_metros, wifi_ap_id, requiere_liveness, activo, qr_version, '
          'created_at, updated_at, sitios(nombre), secciones_sitio(nombre), '
          'sitio_wifi_aps(bssid, ssid, nombre_zona), '
          'ruta_rondin_puntos(orden, segundos_minimos_desde_anterior, '
          'rutas_rondin(activo, nombre))',
        );
    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    final filas = await consulta.order('nombre');
    final puntos = filas.map(PuntoRondin.desdeJson).toList();
    puntos.sort((a, b) {
      final porSitio = a.sitioNombre.compareTo(b.sitioNombre);
      if (porSitio != 0) return porSitio;
      final porOrden = a.orden.compareTo(b.orden);
      return porOrden != 0 ? porOrden : a.nombre.compareTo(b.nombre);
    });
    return puntos;
  }

  Future<List<ResultadoRondin>> resultadosRondin({
    required RangoFechas rango,
    String? sitioId,
  }) async {
    var consulta = SupabaseService.cliente
        .from('rondines')
        .select(
          '*, profiles(nombre_completo), sitios(nombre), rutas_rondin(nombre), '
          'rondin_lecturas(*, puntos_rondin(nombre, '
          'secciones_sitio(nombre))), '
          'rondin_revisiones(*, profiles(nombre_completo))',
        );
    if (sitioId != null) consulta = consulta.eq('sitio_id', sitioId);

    final filas = await consulta
        .gte('iniciado_at_dispositivo', rango.desdeIso)
        .lte('iniciado_at_dispositivo', rango.hastaIso)
        .order(
          'created_at',
          referencedTable: 'rondin_revisiones',
          ascending: false,
        )
        .order('id', referencedTable: 'rondin_revisiones', ascending: false)
        .limit(1, referencedTable: 'rondin_revisiones')
        .order('iniciado_at_dispositivo', ascending: false)
        .limit(300);
    return filas.map(ResultadoRondin.desdeJson).toList();
  }

  Future<RevisionRondin> revisarRondin({
    required String rondinId,
    required String decision,
    required String motivo,
  }) async {
    if (decision != 'aprobado' && decision != 'rechazado') {
      throw const RondinAdminException('La decisión no es válida.');
    }
    final motivoLimpio = motivo.trim();
    if (decision == 'rechazado' && motivoLimpio.isEmpty) {
      throw const RondinAdminException(
        'Explica el motivo para rechazar el rondín.',
      );
    }

    final respuesta = await _invocarAdministracionRondines({
      'accion': 'revisar_rondin',
      'rondin_id': rondinId,
      'decision': decision,
      'motivo': motivoLimpio,
    });
    final revision = respuesta['revision'];
    if (revision is! Map) {
      throw const RondinAdminException(
        'El servidor no devolvió la revisión registrada.',
      );
    }
    return RevisionRondin.desdeJson(Map<String, dynamic>.from(revision));
  }

  Future<RespuestaPuntoRondin> guardarPuntoRondin({
    String? puntoId,
    required String sitioId,
    required String seccionId,
    required String nombre,
    required String descripcion,
    required double? lat,
    required double? lng,
    required int radioMetros,
    required String? wifiApId,
    required bool requiereLiveness,
    required bool activo,
    required int orden,
    required int segundosMinimosDesdeAnterior,
  }) async {
    final respuesta = await _invocarAdministracionRondines({
      'accion': puntoId == null ? 'crear_punto' : 'actualizar_punto',
      'punto_id': ?puntoId,
      'sitio_id': sitioId,
      'seccion_id': seccionId,
      'nombre': nombre.trim(),
      'descripcion': descripcion.trim(),
      'lat': lat,
      'lng': lng,
      'radio_metros': radioMetros,
      'wifi_ap_id': wifiApId,
      'requiere_liveness': requiereLiveness,
      'activo': activo,
      'orden': orden,
      'segundos_minimos_desde_anterior': segundosMinimosDesdeAnterior,
    });
    return _respuestaPunto(respuesta);
  }

  Future<CodigoQrPuntoRondin> obtenerCodigoPunto(String puntoId) async {
    final respuesta = await _invocarAdministracionRondines({
      'accion': 'obtener_codigo',
      'punto_id': puntoId,
    });
    final resultado = _respuestaPunto(respuesta);
    final payload = resultado.qrPayload;
    if (payload == null || payload.isEmpty) {
      throw const RondinAdminException(
        'El servidor no devolvió un código QR válido.',
      );
    }
    return CodigoQrPuntoRondin(punto: resultado.punto, payload: payload);
  }

  Future<CodigoQrPuntoRondin> rotarCodigoPunto(String puntoId) async {
    final respuesta = await _invocarAdministracionRondines({
      'accion': 'rotar_codigo',
      'punto_id': puntoId,
    });
    final resultado = _respuestaPunto(respuesta);
    final payload = resultado.qrPayload;
    if (payload == null || payload.isEmpty) {
      throw const RondinAdminException(
        'El servidor rotó el punto pero no devolvió el nuevo código.',
      );
    }
    return CodigoQrPuntoRondin(punto: resultado.punto, payload: payload);
  }

  RespuestaPuntoRondin _respuestaPunto(Map<String, dynamic> respuesta) {
    final puntoJson = respuesta['punto'];
    if (puntoJson is! Map) {
      throw const RondinAdminException(
        'La respuesta del servidor no contiene el punto solicitado.',
      );
    }
    return RespuestaPuntoRondin(
      punto: PuntoRondin.desdeJson(Map<String, dynamic>.from(puntoJson)),
      qrPayload: respuesta['qr_payload'] as String?,
    );
  }

  Future<Map<String, dynamic>> _invocarAdministracionRondines(
    Map<String, dynamic> cuerpo,
  ) async {
    final sesion = SupabaseService.auth.currentSession;
    if (sesion == null) {
      throw const RondinAdminException(
        'Tu sesión terminó. Inicia sesión nuevamente.',
      );
    }

    try {
      final respuesta = await SupabaseService.cliente.functions.invoke(
        'administrar-puntos-rondin',
        body: cuerpo,
        headers: {'Authorization': 'Bearer ${sesion.accessToken}'},
      );
      final datos = respuesta.data;
      if (datos is Map) return Map<String, dynamic>.from(datos);
      throw const RondinAdminException(
        'La respuesta del servidor no es válida.',
      );
    } on FunctionException catch (error) {
      final detalle = error.details;
      if (detalle is Map) {
        final mensaje = detalle['error'];
        if (mensaje is String && mensaje.trim().isNotEmpty) {
          throw RondinAdminException(mensaje);
        }
      }
      throw RondinAdminException(switch (error.status) {
        401 => 'Tu sesión terminó. Inicia sesión nuevamente.',
        403 => 'No tienes permiso para administrar puntos de rondín.',
        404 => 'El punto de rondín ya no existe.',
        409 => 'La operación entra en conflicto con el estado actual.',
        _ => 'No se pudo completar la operación de rondín.',
      });
    } on RondinAdminException {
      rethrow;
    } catch (_) {
      throw const RondinAdminException(
        'No se pudo conectar con la administración de rondines.',
      );
    }
  }

  /// URL firmada para ver una evidencia. Los buckets son privados, así que sin
  /// firmar la imagen no carga.
  Future<String?> urlEvidencia(String bucket, String ruta) async {
    try {
      return await SupabaseService.urlFirmada(bucket, ruta);
    } catch (_) {
      return null;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODELOS DE LAS VISTAS
// ─────────────────────────────────────────────────────────────────────────────

class PersonalEnSitio {
  const PersonalEnSitio({
    required this.turnoId,
    required this.usuarioId,
    required this.nombreCompleto,
    required this.rol,
    required this.sitioNombre,
    required this.inicioAt,
    required this.horasEnTurno,
    required this.clasificacionEntrada,
    this.telefonoWhatsapp = '',
    this.puesto = '',
    this.minutosRetardo = 0,
    this.esDoblete = false,
    this.esCobertura = false,
    this.selfieEntradaUrl,
    this.estadoValidacion = 'validado',
    this.dentroGeocerca = false,
  });

  final String turnoId;
  final String usuarioId;
  final String nombreCompleto;
  final String rol;
  final String sitioNombre;
  final DateTime inicioAt;
  final double horasEnTurno;
  final String clasificacionEntrada;
  final String telefonoWhatsapp;
  final String puesto;
  final int minutosRetardo;
  final bool esDoblete;
  final bool esCobertura;
  final String? selfieEntradaUrl;
  final String estadoValidacion;
  final bool dentroGeocerca;

  factory PersonalEnSitio.desdeJson(Map<String, dynamic> j) {
    return PersonalEnSitio(
      turnoId: j['turno_id'] as String,
      usuarioId: j['usuario_id'] as String,
      nombreCompleto: j['nombre_completo'] as String? ?? '',
      rol: j['rol'] as String? ?? 'elemento',
      sitioNombre: j['sitio_nombre'] as String? ?? '',
      inicioAt: DateTime.parse(j['inicio_at'] as String).toLocal(),
      horasEnTurno: _double(j['horas_en_turno']) ?? 0,
      clasificacionEntrada: j['clasificacion_entrada'] as String? ?? 'a_tiempo',
      telefonoWhatsapp: j['telefono_whatsapp'] as String? ?? '',
      puesto: j['puesto'] as String? ?? '',
      minutosRetardo: j['minutos_retardo'] as int? ?? 0,
      esDoblete: j['es_doblete'] as bool? ?? false,
      esCobertura: j['es_cobertura'] as bool? ?? false,
      selfieEntradaUrl: j['selfie_entrada_url'] as String?,
      estadoValidacion: j['estado_validacion'] as String? ?? 'validado',
      dentroGeocerca: j['dentro_geocerca'] as bool? ?? false,
    );
  }

  /// Enlace para contactar por WhatsApp. `wa.me` exige E.164 sin `+`.
  String? get enlaceWhatsapp {
    final limpio = telefonoWhatsapp.replaceAll(RegExp(r'[^0-9]'), '');
    return limpio.length < 10 ? null : 'https://wa.me/$limpio';
  }

  static double? _double(Object? v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

class VisitanteDentro {
  const VisitanteDentro({
    required this.id,
    required this.nombreCompleto,
    required this.asunto,
    required this.horaEntrada,
    required this.horasDentro,
    this.empresaProcedencia = '',
    this.personaVisitada = '',
    this.areaVisitada = '',
    this.placas = '',
    this.registradoPorNombre = '',
    this.tieneIdentificacion = false,
  });

  final String id;
  final String nombreCompleto;
  final String asunto;
  final DateTime horaEntrada;
  final double horasDentro;
  final String empresaProcedencia;
  final String personaVisitada;
  final String areaVisitada;
  final String placas;
  final String registradoPorNombre;
  final bool tieneIdentificacion;

  factory VisitanteDentro.desdeJson(Map<String, dynamic> j) {
    return VisitanteDentro(
      id: j['id'] as String,
      nombreCompleto: j['nombre_completo'] as String? ?? '',
      asunto: j['asunto'] as String? ?? '',
      horaEntrada: DateTime.parse(j['hora_entrada'] as String).toLocal(),
      horasDentro: PersonalEnSitio._double(j['horas_dentro']) ?? 0,
      empresaProcedencia: j['empresa_procedencia'] as String? ?? '',
      personaVisitada: j['persona_visitada'] as String? ?? '',
      areaVisitada: j['area_visitada'] as String? ?? '',
      placas: j['placas'] as String? ?? '',
      registradoPorNombre: j['registrado_por_nombre'] as String? ?? '',
      tieneIdentificacion: j['tiene_identificacion'] as bool? ?? false,
    );
  }
}
