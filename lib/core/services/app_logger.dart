import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Registro de eventos de la app.
///
/// En release sólo emite advertencias y errores: los logs de depuración en un
/// dispositivo de producción cuestan batería y pueden filtrar datos operativos
/// a `logcat`, que cualquier app con permisos puede leer.
class AppLogger {
  const AppLogger._();

  static final Logger _logger = Logger(
    filter: _FiltroPorEntorno(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 100,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void d(String mensaje) => _logger.d(mensaje);

  static void i(String mensaje) => _logger.i(mensaje);

  static void w(String mensaje, [Object? error]) => _logger.w(mensaje, error: error);

  static void e(String mensaje, [Object? error, StackTrace? stack]) =>
      _logger.e(mensaje, error: error, stackTrace: stack);

  /// Eventos del motor de sincronización. Se separan porque son de alto
  /// volumen (un ciclo cada 30 s) y conviene poder silenciarlos aparte.
  static void sync(String mensaje) {
    if (kDebugMode) _logger.d('[sync] $mensaje');
  }
}

class _FiltroPorEntorno extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) return true;
    return event.level.index >= Level.warning.index;
  }
}
