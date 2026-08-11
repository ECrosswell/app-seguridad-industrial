import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../../core/services/device_service.dart';
import '../../../data/local/app_database.dart';
import '../../asistencia/services/presence_service.dart';
import '../domain/qr_rondin_payload.dart';
import '../domain/validacion_rondin.dart';
import '../services/security_clock_service.dart';

class PasoRondinLocal {
  const PasoRondinLocal({required this.configuracion, required this.punto});

  final LocalRutaRondinPunto configuracion;
  final LocalPuntosRondinData punto;
}

class RutaRondinLocal {
  const RutaRondinLocal({required this.ruta, required this.pasos});

  final LocalRutasRondinData ruta;
  final List<PasoRondinLocal> pasos;
}

class RegistroLecturaResultado {
  const RegistroLecturaResultado({
    required this.lectura,
    required this.punto,
    required this.evaluacion,
    required this.rondinCompletado,
  });

  final LocalRondinLectura lectura;
  final LocalPuntosRondinData punto;
  final EvaluacionLocalRondin evaluacion;
  final bool rondinCompletado;
}

class RondinException implements Exception {
  const RondinException(this.mensaje);
  final String mensaje;

  @override
  String toString() => mensaje;
}

/// Persistencia offline de rondines. Ningún método necesita Supabase: iniciar,
/// leer y terminar una ruta funciona con el catálogo de la última conexión.
class RondinesRepository {
  const RondinesRepository(this._db);

  final AppDatabase _db;

  Future<List<RutaRondinLocal>> rutasParaSitio(String sitioId) async {
    final rutas =
        await (_db.select(_db.localRutasRondin)
              ..where((t) => t.sitioId.equals(sitioId) & t.activo.equals(true))
              ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
            .get();
    final resultado = <RutaRondinLocal>[];
    for (final ruta in rutas) {
      resultado.add(
        RutaRondinLocal(ruta: ruta, pasos: await pasosDeRuta(ruta.id)),
      );
    }
    return resultado;
  }

  Future<List<PasoRondinLocal>> pasosDeRuta(String rutaId) async {
    final relaciones =
        await (_db.select(_db.localRutaRondinPuntos)
              ..where((t) => t.rutaId.equals(rutaId))
              ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
            .get();
    final pasos = <PasoRondinLocal>[];
    for (final relacion in relaciones) {
      final punto =
          await (_db.select(_db.localPuntosRondin)..where(
                (t) => t.id.equals(relacion.puntoId) & t.activo.equals(true),
              ))
              .getSingleOrNull();
      if (punto != null) {
        pasos.add(PasoRondinLocal(configuracion: relacion, punto: punto));
      }
    }
    return pasos;
  }

  Future<LocalRondine?> rondinEnCurso(String usuarioId) {
    return (_db.select(_db.localRondines)
          ..where(
            (t) =>
                t.usuarioId.equals(usuarioId) &
                t.estadoLocal.equals('en_curso'),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.iniciadoAtDispositivo)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<LocalRondine>> observarRondines(String usuarioId) {
    return (_db.select(_db.localRondines)
          ..where((t) => t.usuarioId.equals(usuarioId))
          ..orderBy([(t) => OrderingTerm.desc(t.iniciadoAtDispositivo)]))
        .watch();
  }

  Stream<List<LocalRondinLectura>> observarLecturas(String rondinLocalId) {
    return (_db.select(_db.localRondinLecturas)
          ..where((t) => t.rondinLocalId.equals(rondinLocalId))
          ..orderBy([(t) => OrderingTerm.asc(t.secuencia)]))
        .watch();
  }

  Future<LocalPuntosRondinData> puntoConfiguradoParaQr(String qrRaw) async {
    final payload = QrRondinPayload.intentarParsear(qrRaw);
    if (payload == null) {
      throw const RondinException(
        'El código no pertenece a Seguridad Industrial.',
      );
    }
    final punto =
        await (_db.select(_db.localPuntosRondin)..where(
              (t) => t.id.equals(payload.puntoId) & t.activo.equals(true),
            ))
            .getSingleOrNull();
    if (punto == null || punto.tokenVersion != payload.version) {
      throw const RondinException(
        'El punto no está disponible o su versión ya no está vigente.',
      );
    }
    return punto;
  }

  Future<String> iniciar({
    required String usuarioId,
    required LocalTurno turno,
    required RutaRondinLocal ruta,
    required SenalesSeguridadDispositivo senales,
  }) async {
    if (await rondinEnCurso(usuarioId) != null) {
      throw const RondinException('Ya tienes un rondín en curso.');
    }
    if (ruta.pasos.isEmpty) {
      throw const RondinException('Esta ruta todavía no tiene puntos activos.');
    }
    if (ruta.ruta.sitioId != turno.sitioId) {
      throw const RondinException('La ruta no pertenece al sitio de tu turno.');
    }

    final deviceId = await DeviceService.instancia.deviceId();
    final fila = await _db
        .into(_db.localRondines)
        .insertReturning(
          LocalRondinesCompanion.insert(
            usuarioId: usuarioId,
            sitioId: turno.sitioId,
            rutaId: ruta.ruta.id,
            turnoId: Value(turno.id.startsWith('local:') ? null : turno.id),
            turnoFecha: turno.turnoFecha,
            iniciadoAtDispositivo: DateTime.now(),
            iniciadoMonotonicMs: senales.elapsedRealtimeMs,
            deviceId: Value(deviceId),
          ),
        );
    return fila.localId;
  }

  Future<RegistroLecturaResultado> registrarLectura({
    required String rondinLocalId,
    required String qrRaw,
    required Presencia presencia,
    required SenalesSeguridadDispositivo senales,
    bool livenessPassed = false,
  }) async {
    final rondin = await (_db.select(
      _db.localRondines,
    )..where((t) => t.localId.equals(rondinLocalId))).getSingleOrNull();
    if (rondin == null || rondin.estadoLocal != 'en_curso') {
      throw const RondinException('El rondín ya no está en curso.');
    }

    final payload = QrRondinPayload.intentarParsear(qrRaw);
    if (payload == null) {
      throw const RondinException(
        'El código no pertenece a Seguridad Industrial.',
      );
    }

    final punto =
        await (_db.select(_db.localPuntosRondin)..where(
              (t) =>
                  t.id.equals(payload.puntoId) &
                  t.sitioId.equals(rondin.sitioId) &
                  t.activo.equals(true),
            ))
            .getSingleOrNull();
    if (punto == null || punto.tokenVersion != payload.version) {
      throw const RondinException(
        'El punto no está vigente o pertenece a otro sitio.',
      );
    }

    final pasos = await pasosDeRuta(rondin.rutaId);
    final indicePaso = pasos.indexWhere((p) => p.punto.id == punto.id);
    if (indicePaso < 0) {
      throw const RondinException('Este punto no forma parte de la ruta.');
    }

    final existentes =
        await (_db.select(_db.localRondinLecturas)
              ..where((t) => t.rondinLocalId.equals(rondinLocalId))
              ..orderBy([(t) => OrderingTerm.asc(t.secuencia)]))
            .get();
    if (existentes.any((e) => e.puntoId == punto.id)) {
      throw const RondinException('Este punto ya fue registrado en el rondín.');
    }

    final paso = pasos[indicePaso];
    final anterior = existentes.isEmpty ? null : existentes.last;
    final secuencia = existentes.length + 1;
    int? segundosDesdeAnterior;
    if (anterior != null && anterior.bootCount == senales.bootCount) {
      segundosDesdeAnterior =
          ((senales.elapsedRealtimeMs - anterior.monotonicMs) / 1000).floor();
    }

    final evidencia = EvidenciaPuntoRondin(
      lat: presencia.lat,
      lng: presencia.lng,
      precisionM: presencia.precisionM,
      gpsAgeMs: presencia.gpsAgeMs,
      ubicacionSimulada: presencia.ubicacionSimulada,
      bssid: presencia.bssid,
      horaAutomatica: senales.horaAutomatica,
      opcionesDesarrollador: senales.opcionesDesarrollador,
      adbActivo: senales.adbActivo,
      segundosDesdeAnterior: segundosDesdeAnterior,
      secuenciaEsperada: indicePaso + 1,
      secuenciaReal: secuencia,
    );
    final evaluacion = evaluarEvidenciaLocal(
      punto: ConfiguracionPuntoRondin(
        lat: punto.lat,
        lng: punto.lng,
        radioMetros: punto.radioMetros,
        bssidRequerido: punto.bssidRequerido,
        segundosMinimosDesdeAnterior:
            paso.configuracion.segundosMinimosDesdeAnterior,
        segundosMaximosDesdeAnterior:
            paso.configuracion.segundosMaximosDesdeAnterior,
      ),
      evidencia: evidencia,
    );
    final riesgos = [...evaluacion.codigosRiesgo];
    if (anterior != null && anterior.bootCount != senales.bootCount) {
      riesgos.add('reinicio_durante_rondin');
    }

    final deviceId = await DeviceService.instancia.deviceId();
    final capturadoAt = DateTime.now();
    final hashAnterior = anterior?.hashEvento;
    final hashEvento = sha256
        .convert(
          utf8.encode(
            [
              rondinLocalId,
              punto.id,
              secuencia,
              capturadoAt.toUtc().toIso8601String(),
              senales.elapsedRealtimeMs,
              payload.sha256Hex,
              presencia.lat,
              presencia.lng,
              presencia.bssid,
              hashAnterior ?? '',
              deviceId,
            ].join('|'),
          ),
        )
        .toString();

    final lectura = await _db
        .into(_db.localRondinLecturas)
        .insertReturning(
          LocalRondinLecturasCompanion.insert(
            rondinLocalId: rondinLocalId,
            puntoId: punto.id,
            secuencia: secuencia,
            capturadoAtDispositivo: capturadoAt,
            monotonicMs: senales.elapsedRealtimeMs,
            bootCount: Value(senales.bootCount),
            lat: Value(presencia.lat),
            lng: Value(presencia.lng),
            gpsAccuracyM: Value(presencia.precisionM),
            gpsAgeMs: Value(presencia.gpsAgeMs),
            ubicacionSimulada: Value(presencia.ubicacionSimulada),
            wifiBssid: Value(presencia.bssid),
            wifiSsid: Value(presencia.ssid),
            tokenVersion: payload.version,
            qrPayloadRaw: Value(payload.raw),
            qrPayloadHash: payload.sha256Hex,
            livenessPassed: Value(livenessPassed),
            horaAutomatica: Value(senales.horaAutomatica),
            opcionesDesarrollador: Value(senales.opcionesDesarrollador),
            adbActivo: Value(senales.adbActivo),
            hashAnterior: Value(hashAnterior),
            hashEvento: hashEvento,
            validacionLocal: Value(evaluacion.estado),
            codigosRiesgoLocalJson: Value(jsonEncode(riesgos)),
            deviceId: Value(deviceId),
          ),
        );

    final obligatorios = pasos.where((p) => p.configuracion.obligatorio).length;
    final visitadosObligatorios =
        <String>{...existentes.map((e) => e.puntoId), punto.id}
            .where(
              (id) => pasos.any(
                (p) => p.punto.id == id && p.configuracion.obligatorio,
              ),
            )
            .length;
    final completado = visitadosObligatorios >= obligatorios;
    if (completado) {
      await (_db.update(
        _db.localRondines,
      )..where((t) => t.localId.equals(rondinLocalId))).write(
        LocalRondinesCompanion(
          estadoLocal: const Value('completado'),
          finalizadoAtDispositivo: Value(capturadoAt),
          syncStatus: const Value('pendiente'),
          updatedAtLocal: Value(capturadoAt),
        ),
      );
    }

    return RegistroLecturaResultado(
      lectura: lectura,
      punto: punto,
      evaluacion: EvaluacionLocalRondin(
        estado: evaluacion.estado,
        codigosRiesgo: riesgos,
        distanciaM: evaluacion.distanciaM,
      ),
      rondinCompletado: completado,
    );
  }
}
