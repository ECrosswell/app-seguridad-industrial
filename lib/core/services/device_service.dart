import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Identidad del dispositivo.
///
/// Cada registro operativo guarda el `device_id` de origen. Sirve para auditar
/// desde qué teléfono se capturó una asistencia o un acceso: si un elemento
/// alega que no fue él, el device_id es la primera pista.
///
/// Se genera un UUID propio en lugar de usar el ANDROID_ID del sistema: el
/// identificador del fabricante cambia entre versiones de Android, no es
/// estable tras un restablecimiento de fábrica, y en algunos equipos es
/// compartido entre apps del mismo firmante. Uno propio en almacenamiento
/// seguro es estable mientras la app siga instalada, que es justo la ventana
/// que nos interesa.
class DeviceService {
  DeviceService._();

  static final DeviceService instancia = DeviceService._();

  static const _claveDeviceId = 'device_id';

  // Sin `AndroidOptions`: `encryptedSharedPreferences` quedó obsoleto porque
  // Google descontinuó Jetpack Security. El paquete ya cifra con sus propios
  // algoritmos y migra los datos existentes en el primer acceso.
  final _almacen = const FlutterSecureStorage();

  String? _deviceIdCache;
  String? _modeloCache;

  /// Identificador estable del dispositivo. Se crea la primera vez y persiste.
  Future<String> deviceId() async {
    if (_deviceIdCache != null) return _deviceIdCache!;

    try {
      final guardado = await _almacen.read(key: _claveDeviceId);
      if (guardado != null && guardado.isNotEmpty) {
        _deviceIdCache = guardado;
        return guardado;
      }
    } catch (_) {
      // El almacén seguro puede fallar en algunos equipos con el keystore
      // dañado. No es motivo para tumbar la app: seguimos con uno efímero.
    }

    final nuevo = const Uuid().v4();
    try {
      await _almacen.write(key: _claveDeviceId, value: nuevo);
    } catch (_) {
      // Efímero: cambiará al reiniciar, pero la app sigue operando.
    }
    _deviceIdCache = nuevo;
    return nuevo;
  }

  /// Marca y modelo legibles, para mostrarlos en el panel de auditoría.
  Future<String> modelo() async {
    if (_modeloCache != null) return _modeloCache!;

    if (kIsWeb) {
      final info = await DeviceInfoPlugin().webBrowserInfo;
      _modeloCache = '${info.browserName.name} (web)';
      return _modeloCache!;
    }

    try {
      final info = await DeviceInfoPlugin().androidInfo;
      _modeloCache = '${info.manufacturer} ${info.model} (Android ${info.version.release})';
    } catch (_) {
      _modeloCache = 'desconocido';
    }
    return _modeloCache!;
  }
}
