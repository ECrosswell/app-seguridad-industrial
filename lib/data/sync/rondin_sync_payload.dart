import '../local/app_database.dart';

/// Serializa una lectura para la Edge Function sin convertir el QR RAW en una
/// supuesta prueba local. El servidor autentica el payload y calcula su hash.
Map<String, dynamic> serializarLecturaRondin(LocalRondinLectura lectura) {
  return {
    'local_id': lectura.localId,
    'punto_id': lectura.puntoId,
    'secuencia': lectura.secuencia,
    'capturado_at_dispositivo': lectura.capturadoAtDispositivo
        .toUtc()
        .toIso8601String(),
    'monotonic_ms': lectura.monotonicMs,
    'boot_count': lectura.bootCount,
    'lat': lectura.lat,
    'lng': lectura.lng,
    'gps_accuracy_m': lectura.gpsAccuracyM,
    'gps_age_ms': lectura.gpsAgeMs,
    'ubicacion_simulada': lectura.ubicacionSimulada,
    'wifi_bssid': lectura.wifiBssid,
    'wifi_ssid': lectura.wifiSsid,
    'token_version': lectura.tokenVersion,
    'qr_payload': lectura.qrPayloadRaw,
    'liveness_passed': lectura.livenessPassed,
    'hora_automatica': lectura.horaAutomatica,
    'opciones_desarrollador': lectura.opcionesDesarrollador,
    'adb_activo': lectura.adbActivo,
    'hash_anterior': lectura.hashAnterior,
    'hash_evento': lectura.hashEvento,
  };
}
