import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/sync/sync_engine.dart';
import '../services/device_service.dart';

/// Providers de infraestructura.
///
/// Los que dependen de Drift ([appDatabaseProvider], [syncEngineProvider])
/// **sólo existen en Android**. Referenciarlos desde una pantalla web tumba la
/// app: no hay SQLite en el navegador con esta configuración. Por eso el
/// enrutador web es un árbol aparte.

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  assert(!kIsWeb, 'La base local no existe en web. Revisa el árbol de rutas.');
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  assert(!kIsWeb, 'El motor de sincronización no corre en web.');
  final motor = SyncEngine(ref.watch(appDatabaseProvider));
  ref.onDispose(motor.dispose);
  return motor;
});

/// Estado de sincronización para el indicador de la barra superior.
final syncEstadoProvider = StreamProvider<SyncEstado>((ref) {
  return ref.watch(syncEngineProvider).estado;
});

/// Cuántos registros siguen esperando subir.
final pendientesSyncProvider = FutureProvider<int>((ref) {
  // Se recalcula cada vez que cambia el estado del motor.
  ref.watch(syncEstadoProvider);
  return ref.watch(appDatabaseProvider).pendientesDeSincronizar();
});

final deviceIdProvider = FutureProvider<String>((ref) {
  return DeviceService.instancia.deviceId();
});
