import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/local/app_database.dart';
import '../../asistencia/providers/asistencia_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/rondines_repository.dart';

final rondinesRepositoryProvider = Provider<RondinesRepository>((ref) {
  return RondinesRepository(ref.watch(appDatabaseProvider));
});

final rutasRondinDisponiblesProvider = FutureProvider<List<RutaRondinLocal>>((
  ref,
) async {
  ref.watch(syncEstadoProvider);
  final turno = ref.watch(turnoAbiertoProvider).value;
  if (turno == null) return const [];
  return ref.watch(rondinesRepositoryProvider).rutasParaSitio(turno.sitioId);
});

final rondinEnCursoProvider = FutureProvider<LocalRondine?>((ref) async {
  final perfil = ref.watch(perfilActualProvider);
  if (perfil == null) return null;
  return ref.watch(rondinesRepositoryProvider).rondinEnCurso(perfil.id);
});

final historialRondinesProvider = StreamProvider<List<LocalRondine>>((ref) {
  final perfil = ref.watch(perfilActualProvider);
  if (perfil == null) return Stream.value(const []);
  return ref.watch(rondinesRepositoryProvider).observarRondines(perfil.id);
});

final lecturasRondinProvider =
    StreamProvider.family<List<LocalRondinLectura>, String>((ref, localId) {
      return ref.watch(rondinesRepositoryProvider).observarLecturas(localId);
    });

void refrescarRondines(WidgetRef ref) {
  ref.invalidate(rondinEnCursoProvider);
  ref.invalidate(rutasRondinDisponiblesProvider);
}
