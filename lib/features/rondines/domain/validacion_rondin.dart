import 'dart:math' as math;

/// Resultado local orientativo. El teléfono nunca usa la palabra "validado":
/// el veredicto definitivo pertenece al servidor después de sincronizar.
class EvaluacionLocalRondin {
  const EvaluacionLocalRondin({
    required this.estado,
    required this.codigosRiesgo,
    this.distanciaM,
  });

  final String estado;
  final List<String> codigosRiesgo;
  final double? distanciaM;

  bool get requiereRevision => codigosRiesgo.isNotEmpty;
}

class EvidenciaPuntoRondin {
  const EvidenciaPuntoRondin({
    this.lat,
    this.lng,
    this.precisionM,
    this.gpsAgeMs,
    this.ubicacionSimulada = false,
    this.bssid,
    this.horaAutomatica = true,
    this.opcionesDesarrollador = false,
    this.adbActivo = false,
    this.segundosDesdeAnterior,
    this.secuenciaEsperada,
    this.secuenciaReal,
  });

  final double? lat;
  final double? lng;
  final double? precisionM;
  final int? gpsAgeMs;
  final bool ubicacionSimulada;
  final String? bssid;
  final bool horaAutomatica;
  final bool opcionesDesarrollador;
  final bool adbActivo;
  final int? segundosDesdeAnterior;
  final int? secuenciaEsperada;
  final int? secuenciaReal;
}

class ConfiguracionPuntoRondin {
  const ConfiguracionPuntoRondin({
    this.lat,
    this.lng,
    this.radioMetros = 35,
    this.bssidRequerido,
    this.segundosMinimosDesdeAnterior = 0,
    this.segundosMaximosDesdeAnterior = 3600,
  });

  final double? lat;
  final double? lng;
  final int radioMetros;
  final String? bssidRequerido;
  final int segundosMinimosDesdeAnterior;
  final int segundosMaximosDesdeAnterior;
}

EvaluacionLocalRondin evaluarEvidenciaLocal({
  required ConfiguracionPuntoRondin punto,
  required EvidenciaPuntoRondin evidencia,
}) {
  final riesgos = <String>[];
  double? distancia;

  if (evidencia.ubicacionSimulada) riesgos.add('ubicacion_simulada');
  if (!evidencia.horaAutomatica) riesgos.add('hora_manual');
  if (evidencia.opcionesDesarrollador) riesgos.add('opciones_desarrollador');
  if (evidencia.adbActivo) riesgos.add('adb_activo');

  final tieneGps = evidencia.lat != null && evidencia.lng != null;
  if (!tieneGps) {
    riesgos.add('gps_no_disponible');
  } else {
    if ((evidencia.precisionM ?? 9999) > 80) {
      riesgos.add('gps_impreciso');
    }
    if ((evidencia.gpsAgeMs ?? 999999) > 30000) {
      riesgos.add('gps_antiguo');
    }
    if (punto.lat != null && punto.lng != null) {
      distancia = distanciaHaversineM(
        evidencia.lat!,
        evidencia.lng!,
        punto.lat!,
        punto.lng!,
      );
      final margenPrecision = math.min(evidencia.precisionM ?? 0, 50);
      if (distancia > punto.radioMetros + margenPrecision) {
        riesgos.add('fuera_del_punto');
      }
    } else {
      riesgos.add('punto_sin_geocerca');
    }
  }

  final bssidEsperado = _normalizarBssid(punto.bssidRequerido);
  if (bssidEsperado != null &&
      _normalizarBssid(evidencia.bssid) != bssidEsperado) {
    riesgos.add('wifi_zona_no_coincide');
  }

  final segundos = evidencia.segundosDesdeAnterior;
  if (segundos != null && segundos < punto.segundosMinimosDesdeAnterior) {
    riesgos.add('traslado_demasiado_rapido');
  }
  if (segundos != null &&
      punto.segundosMaximosDesdeAnterior > 0 &&
      segundos > punto.segundosMaximosDesdeAnterior) {
    riesgos.add('traslado_demasiado_lento');
  }
  if (evidencia.secuenciaEsperada != null &&
      evidencia.secuenciaReal != evidencia.secuenciaEsperada) {
    riesgos.add('orden_incorrecto');
  }

  final estado =
      riesgos.contains('ubicacion_simulada') ||
          riesgos.contains('fuera_del_punto') ||
          riesgos.contains('traslado_demasiado_rapido')
      ? 'capturado_sospechoso'
      : (riesgos.isEmpty ? 'capturado_con_evidencia' : 'capturado_por_revisar');

  return EvaluacionLocalRondin(
    estado: estado,
    codigosRiesgo: List.unmodifiable(riesgos),
    distanciaM: distancia,
  );
}

double distanciaHaversineM(double lat1, double lng1, double lat2, double lng2) {
  const radioTierra = 6371000.0;
  double rad(double grados) => grados * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  return radioTierra * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

String? _normalizarBssid(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value.trim().toLowerCase().replaceAll('-', ':');
}
