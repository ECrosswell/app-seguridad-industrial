import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

import '../../../data/models/perfil.dart';

class PerfilCacheado {
  const PerfilCacheado({required this.perfil, required this.guardadoAt});

  final Perfil perfil;
  final DateTime guardadoAt;
}

/// Bootstrap offline limitado. La primera sesión siempre necesita internet;
/// después se conserva el último perfil verificado por hasta 48 horas y sólo
/// durante el mismo arranque del teléfono. La vigencia usa el reloj monotónico
/// de Android, por lo que atrasar la hora de pared no la extiende. El backend
/// vuelve a comprobar cuenta, rol y sitio al sincronizar cualquier captura;
/// este caché no concede permisos en el servidor.
class PerfilLocalCache {
  const PerfilLocalCache._();

  static const _storage = FlutterSecureStorage();
  static const _canal = MethodChannel(
    'com.tesnal.seguridad_industrial/security_signals',
  );
  static const _clave = 'perfil_operativo_cache_v1';
  static const vigencia = Duration(hours: 48);

  static Future<void> guardar(
    Perfil perfil, {
    required String sessionId,
  }) async {
    if (sessionId.isEmpty) {
      await limpiar();
      return;
    }
    final marca = await _marcaMonotonica();
    if (marca == null) {
      // Sin una fuente monotónica no se habilita el bootstrap offline.
      await limpiar();
      return;
    }
    final contenido = jsonEncode({
      'guardado_at': DateTime.now().toUtc().toIso8601String(),
      'boot_count': marca.bootCount,
      'elapsed_realtime_ms': marca.elapsedRealtimeMs,
      'session_id': sessionId,
      'perfil': perfil.aJson(),
    });
    await _storage.write(key: _clave, value: contenido);
  }

  static Future<PerfilCacheado?> cargar({
    required String usuarioId,
    required String sessionId,
  }) async {
    try {
      final raw = await _storage.read(key: _clave);
      if (raw == null || raw.isEmpty) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final guardadoAt = DateTime.parse(json['guardado_at'] as String).toUtc();
      final bootGuardado = (json['boot_count'] as num?)?.toInt();
      final elapsedGuardado = (json['elapsed_realtime_ms'] as num?)?.toInt();
      final sessionGuardada = json['session_id'] as String?;
      final marcaActual = await _marcaMonotonica();
      if (bootGuardado == null ||
          elapsedGuardado == null ||
          sessionId.isEmpty ||
          sessionGuardada != sessionId ||
          marcaActual == null ||
          marcaActual.bootCount != bootGuardado ||
          marcaActual.elapsedRealtimeMs < elapsedGuardado ||
          marcaActual.elapsedRealtimeMs - elapsedGuardado >
              vigencia.inMilliseconds) {
        return null;
      }
      final perfil = Perfil.desdeJson(
        Map<String, dynamic>.from(json['perfil'] as Map),
      );
      if (perfil.id != usuarioId) return null;
      if (!perfil.activo || perfil.debeCambiarPassword) return null;
      return PerfilCacheado(perfil: perfil, guardadoAt: guardadoAt);
    } catch (_) {
      return null;
    }
  }

  static Future<({int bootCount, int elapsedRealtimeMs})?>
  _marcaMonotonica() async {
    try {
      final datos = await _canal.invokeMapMethod<String, dynamic>('obtener');
      final bootCount = (datos?['boot_count'] as num?)?.toInt();
      final elapsedRealtimeMs = (datos?['elapsed_realtime_ms'] as num?)
          ?.toInt();
      if (bootCount == null ||
          bootCount < 0 ||
          elapsedRealtimeMs == null ||
          elapsedRealtimeMs < 0) {
        return null;
      }
      return (bootCount: bootCount, elapsedRealtimeMs: elapsedRealtimeMs);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  static Future<void> limpiar() => _storage.delete(key: _clave);
}
