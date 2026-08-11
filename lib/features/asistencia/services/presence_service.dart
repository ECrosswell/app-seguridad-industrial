import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/app_logger.dart';

/// Resultado de comprobar dónde está el elemento.
class Presencia {
  const Presencia({
    this.lat,
    this.lng,
    this.precisionM,
    this.gpsCapturadoAt,
    this.gpsAgeMs,
    this.ubicacionSimulada = false,
    this.bssid,
    this.ssid,
    this.errorUbicacion,
    this.errorWifi,
  });

  final double? lat;
  final double? lng;
  final double? precisionM;
  final DateTime? gpsCapturadoAt;
  final int? gpsAgeMs;
  final bool ubicacionSimulada;
  final String? bssid;
  final String? ssid;

  /// Por qué no se pudo obtener cada dato. Se le muestra al elemento para que
  /// sepa si tiene que encender el GPS o conectarse al WiFi, en vez de dejarlo
  /// adivinando por qué su registro quedó "pendiente de revisión".
  final String? errorUbicacion;
  final String? errorWifi;

  bool get tieneUbicacion => lat != null && lng != null;
  bool get tieneWifi => bssid != null && bssid!.isNotEmpty;

  /// Sin ninguna de las dos señales el servidor marcará el registro como
  /// pendiente de revisión. No lo bloquea: el elemento igual puede registrar.
  bool get sinEvidenciaDePresencia => !tieneUbicacion && !tieneWifi;
}

/// Obtiene la evidencia de que el elemento está físicamente en el sitio.
///
/// Se recogen **dos** señales independientes:
///   · GPS, contra la geocerca del sitio.
///   · BSSID del WiFi al que está conectado. Es más específico que el nombre
///     de red y funciona bajo techo industrial, aunque se conserva como señal
///     de riesgo y no como prueba criptográfica porque también puede falsearse.
///
/// El servidor decide con ambas; aquí sólo se recolectan.
class PresenceService {
  const PresenceService._();

  static const _timeoutGps = Duration(seconds: 15);

  static Future<Presencia> obtener() async {
    final ubicacion = await _obtenerUbicacion();
    final wifi = await _obtenerWifi();

    return Presencia(
      lat: ubicacion.$1,
      lng: ubicacion.$2,
      precisionM: ubicacion.$3,
      gpsCapturadoAt: ubicacion.$4,
      gpsAgeMs: ubicacion.$5,
      ubicacionSimulada: ubicacion.$6,
      errorUbicacion: ubicacion.$7,
      bssid: wifi.$1,
      ssid: wifi.$2,
      errorWifi: wifi.$3,
    );
  }

  /// (lat, lng, precisión, capturada_en, edad_ms, simulada, error)
  static Future<(double?, double?, double?, DateTime?, int?, bool, String?)>
  _obtenerUbicacion() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return (
          null,
          null,
          null,
          null,
          null,
          false,
          'La ubicación del teléfono está apagada.',
        );
      }

      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }

      if (permiso == LocationPermission.deniedForever) {
        return (
          null,
          null,
          null,
          null,
          null,
          false,
          'Negaste el permiso de ubicación de forma permanente. '
              'Actívalo desde los ajustes del teléfono.',
        );
      }
      if (permiso == LocationPermission.denied) {
        return (
          null,
          null,
          null,
          null,
          null,
          false,
          'Se necesita permiso de ubicación.',
        );
      }

      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _timeoutGps,
        ),
      );

      final capturadaEn = posicion.timestamp;
      final edadMs = DateTime.now()
          .toUtc()
          .difference(capturadaEn.toUtc())
          .inMilliseconds
          .clamp(0, 86400000);
      return (
        posicion.latitude,
        posicion.longitude,
        posicion.accuracy,
        capturadaEn,
        edadMs,
        posicion.isMocked,
        null,
      );
    } catch (e) {
      AppLogger.w('No se pudo obtener ubicación: $e');
      return (
        null,
        null,
        null,
        null,
        null,
        false,
        'No se pudo obtener la ubicación. Sal a cielo abierto e intenta de nuevo.',
      );
    }
  }

  /// (bssid, ssid, error)
  static Future<(String?, String?, String?)> _obtenerWifi() async {
    try {
      // Android 10+ exige permiso de ubicación para leer datos de la red WiFi,
      // porque el BSSID permite inferir la posición del dispositivo.
      final estado = await Permission.locationWhenInUse.status;
      if (!estado.isGranted) {
        return (
          null,
          null,
          'Se necesita permiso de ubicación para leer el WiFi.',
        );
      }

      final info = NetworkInfo();
      final bssid = await info.getWifiBSSID();
      final ssid = await info.getWifiName();

      if (bssid == null || bssid.isEmpty || bssid == '02:00:00:00:00:00') {
        // Android devuelve esa MAC de relleno cuando no tiene permisos
        // suficientes o el equipo no está en WiFi.
        return (null, null, 'No estás conectado al WiFi de la planta.');
      }

      return (
        _normalizarBssid(bssid),
        // El SSID viene entre comillas en varias versiones de Android.
        ssid?.replaceAll('"', ''),
        null,
      );
    } catch (e) {
      AppLogger.w('No se pudo leer el WiFi: $e');
      return (null, null, 'No se pudo leer la red WiFi.');
    }
  }

  /// Normaliza a minúsculas con dos puntos. Los fabricantes devuelven el BSSID
  /// con mayúsculas, guiones o sin separador; el servidor compara en
  /// minúsculas, así que sin esto un AP válido no coincidiría.
  static String _normalizarBssid(String bruto) {
    final limpio = bruto.toLowerCase().replaceAll(RegExp(r'[^0-9a-f]'), '');
    if (limpio.length != 12) return bruto.toLowerCase();

    final partes = <String>[];
    for (var i = 0; i < 12; i += 2) {
      partes.add(limpio.substring(i, i + 2));
    }
    return partes.join(':');
  }

  /// Permisos que necesita el módulo de asistencia. Se piden juntos al entrar
  /// para no interrumpir al elemento a media captura.
  static Future<bool> solicitarPermisos() async {
    final resultados = await [
      Permission.locationWhenInUse,
      Permission.camera,
    ].request();

    return resultados.values.every((e) => e.isGranted || e.isLimited);
  }
}
