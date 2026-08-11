import 'package:flutter/services.dart';

class SenalesSeguridadDispositivo {
  const SenalesSeguridadDispositivo({
    required this.elapsedRealtimeMs,
    required this.bootCount,
    required this.horaAutomatica,
    required this.opcionesDesarrollador,
    required this.adbActivo,
  });

  final int elapsedRealtimeMs;
  final int bootCount;
  final bool horaAutomatica;
  final bool opcionesDesarrollador;
  final bool adbActivo;
}

/// Lee señales que el reloj de pared de Dart no ofrece. Son evidencia de
/// riesgo, no una prueba infalible: un teléfono comprometido puede falsearlas.
class SecurityClockService {
  const SecurityClockService._();

  static const _canal = MethodChannel(
    'com.tesnal.seguridad_industrial/security_signals',
  );

  static Future<SenalesSeguridadDispositivo> obtener() async {
    try {
      final datos = await _canal.invokeMapMethod<String, dynamic>('obtener');
      return SenalesSeguridadDispositivo(
        elapsedRealtimeMs:
            (datos?['elapsed_realtime_ms'] as num?)?.toInt() ??
            DateTime.now().millisecondsSinceEpoch,
        bootCount: _enteroNoNegativo(datos?['boot_count']),
        // Si Android omite una señal, se marca el escenario de mayor riesgo.
        // Estas banderas nunca deben fallar abierto como si el dispositivo
        // hubiera demostrado una configuración segura.
        horaAutomatica: datos?['hora_automatica'] as bool? ?? false,
        opcionesDesarrollador:
            datos?['opciones_desarrollador'] as bool? ?? true,
        adbActivo: datos?['adb_activo'] as bool? ?? true,
      );
    } on PlatformException {
      return SenalesSeguridadDispositivo(
        elapsedRealtimeMs: DateTime.now().millisecondsSinceEpoch,
        bootCount: 0,
        horaAutomatica: false,
        opcionesDesarrollador: true,
        adbActivo: true,
      );
    }
  }

  static int _enteroNoNegativo(Object? valor) {
    final entero = valor is num ? valor.toInt() : null;
    return entero != null && entero >= 0 ? entero : 0;
  }
}
