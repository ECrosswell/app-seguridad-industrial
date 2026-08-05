import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/local/app_database.dart';
import '../../accesos/providers/accesos_provider.dart';
import '../../asistencia/providers/asistencia_provider.dart';
import '../data/bitacora_repository.dart';

final bitacoraRepositoryProvider = Provider<BitacoraRepository>((ref) {
  return BitacoraRepository(ref.watch(appDatabaseProvider));
});

/// Fecha operativa del turno en curso. Se usa para agrupar los eventos.
final turnoFechaActualProvider = Provider<DateTime?>((ref) {
  final turno = ref.watch(turnoAbiertoProvider).value;
  if (turno != null) return turno.turnoFecha;

  // Sin turno abierto se calcula con la configuración del sitio, para que el
  // elemento pueda consultar la bitácora antes de registrar su entrada.
  final sitios = ref.watch(sitiosDisponiblesProvider).value;
  final sitioId = ref.watch(sitioOperativoProvider);
  if (sitios == null || sitioId == null) return null;

  final sitio = sitios.where((s) => s.id == sitioId);
  if (sitio.isEmpty) return null;
  return sitio.first.fechaTurnoDe(DateTime.now());
});

final bitacoraDelTurnoProvider =
    StreamProvider<List<LocalBitacoraEvento>>((ref) {
  final sitioId = ref.watch(sitioOperativoProvider);
  final fecha = ref.watch(turnoFechaActualProvider);
  if (sitioId == null || fecha == null) return Stream.value(const []);
  return ref.watch(bitacoraRepositoryProvider).observarDelTurno(sitioId, fecha);
});

final historialBitacoraProvider =
    StreamProvider<List<LocalBitacoraEvento>>((ref) {
  final sitioId = ref.watch(sitioOperativoProvider);
  if (sitioId == null) return Stream.value(const []);
  return ref.watch(bitacoraRepositoryProvider).observarHistorial(sitioId);
});

/// Fallas e incidentes sin resolver que cruzan de turno.
final pendientesBitacoraProvider =
    StreamProvider<List<LocalBitacoraEvento>>((ref) {
  final sitioId = ref.watch(sitioOperativoProvider);
  if (sitioId == null) return Stream.value(const []);
  return ref.watch(bitacoraRepositoryProvider).observarPendientes(sitioId);
});
