import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'app_logger.dart';

/// Estado de conectividad.
///
/// Importante: `connectivity_plus` sólo dice si hay una **interfaz** de red
/// activa, no si hay internet real. En una caseta con WiFi de planta sin salida
/// a internet, o con datos móviles en cero, reportaría "conectado" y el motor
/// de sincronización se quedaría reintentando contra la nada.
///
/// Por eso el motor de sync usa [hayInternetReal], que sí toca la red.
class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService instancia = ConnectivityService._();

  final _connectivity = Connectivity();

  Stream<bool> get cambios => _connectivity.onConnectivityChanged
      .map((resultados) => _hayInterfaz(resultados))
      .distinct();

  Future<bool> hayInterfazDeRed() async {
    final resultados = await _connectivity.checkConnectivity();
    return _hayInterfaz(resultados);
  }

  static bool _hayInterfaz(List<ConnectivityResult> resultados) {
    return resultados.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);
  }

  /// Comprobación real contra el backend. Es lo que decide si vale la pena
  /// intentar sincronizar.
  Future<bool> hayInternetReal({
    required Future<void> Function() sonda,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (!await hayInterfazDeRed()) return false;
    try {
      await sonda().timeout(timeout);
      return true;
    } catch (e) {
      AppLogger.sync('Sonda de red falló: $e');
      return false;
    }
  }
}
