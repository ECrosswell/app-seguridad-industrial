import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/local/app_database.dart';
import '../../asistencia/providers/asistencia_provider.dart';
import '../data/accesos_repository.dart';

final accesosRepositoryProvider = Provider<AccesosRepository>((ref) {
  return AccesosRepository(ref.watch(appDatabaseProvider));
});

/// Sitio sobre el que opera la pantalla de accesos.
///
/// Si el elemento tiene turno abierto se usa ese sitio; si no, el que tenga
/// seleccionado. Evita que registre un visitante en un sitio distinto al que
/// está cubriendo.
final sitioOperativoProvider = Provider<String?>((ref) {
  final turno = ref.watch(turnoAbiertoProvider).value;
  if (turno != null) return turno.sitioId;
  return ref.watch(sitioSeleccionadoProvider);
});

final visitantesDentroProvider =
    StreamProvider<List<LocalRegistrosAccesoData>>((ref) {
  final sitioId = ref.watch(sitioOperativoProvider);
  if (sitioId == null) return Stream.value(const []);
  return ref.watch(accesosRepositoryProvider).observarDentro(sitioId);
});

final historialAccesosProvider =
    StreamProvider<List<LocalRegistrosAccesoData>>((ref) {
  final sitioId = ref.watch(sitioOperativoProvider);
  if (sitioId == null) return Stream.value(const []);
  return ref.watch(accesosRepositoryProvider).observarHistorial(sitioId);
});

final personalClienteProvider =
    FutureProvider<List<LocalPersonalClienteData>>((ref) {
  final sitioId = ref.watch(sitioOperativoProvider);
  if (sitioId == null) return Future.value(const []);
  // Se refresca al terminar un ciclo de sincronización, por si el cliente acaba
  // de dar de alta gente en su catálogo.
  ref.watch(syncEstadoProvider);
  return ref.watch(accesosRepositoryProvider).personalDelSitio(sitioId);
});

final avisoVigenteProvider =
    FutureProvider<LocalAvisosPrivacidadData?>((ref) {
  ref.watch(syncEstadoProvider);
  return ref.watch(accesosRepositoryProvider).avisoVigente();
});

/// Búsqueda de visitantes recurrentes para precargar el formulario.
final busquedaVisitantesProvider =
    FutureProvider.family<List<LocalVisitante>, String>((ref, texto) {
  return ref.watch(accesosRepositoryProvider).buscarVisitantes(texto);
});
