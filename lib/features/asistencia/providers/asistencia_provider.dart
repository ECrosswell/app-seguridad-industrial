import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/local/app_database.dart';
import '../../../data/models/sitio.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/asistencia_repository.dart';

final asistenciaRepositoryProvider = Provider<AsistenciaRepository>((ref) {
  return AsistenciaRepository(ref.watch(appDatabaseProvider));
});

/// Sitios activos que se bajaron del servidor.
final sitiosDisponiblesProvider = FutureProvider<List<Sitio>>((ref) {
  // Se refresca cuando el motor termina un ciclo, por si el admin acaba de
  // capturar la geocerca desde el panel.
  ref.watch(syncEstadoProvider);
  return ref.watch(asistenciaRepositoryProvider).sitiosActivos();
});

/// Sitio con el que se va a registrar. Arranca en el primero disponible; el
/// elemento lo puede cambiar si va a cubrir otro.
final sitioSeleccionadoProvider =
    NotifierProvider<SitioSeleccionado, String?>(SitioSeleccionado.new);

class SitioSeleccionado extends Notifier<String?> {
  @override
  String? build() {
    final sitios = ref.watch(sitiosDisponiblesProvider).value;
    if (sitios == null || sitios.isEmpty) return null;
    return state ?? sitios.first.id;
  }

  void seleccionar(String sitioId) => state = sitioId;
}

/// Turno abierto del usuario en sesión. Es lo que decide si la pantalla ofrece
/// "Registrar entrada" o "Registrar salida".
final turnoAbiertoProvider = StreamProvider<LocalTurno?>((ref) {
  final perfil = ref.watch(perfilActualProvider);
  if (perfil == null) return Stream.value(null);
  return ref.watch(asistenciaRepositoryProvider).observarTurnoAbierto(perfil.id);
});

/// Eventos del turno en curso, para la línea de tiempo.
final eventosDelTurnoProvider =
    StreamProvider.family<List<LocalAsistencia>, DateTime>((ref, fechaTurno) {
  final perfil = ref.watch(perfilActualProvider);
  if (perfil == null) return Stream.value(const []);
  return ref
      .watch(asistenciaRepositoryProvider)
      .observarEventosDelTurno(perfil.id, fechaTurno);
});

/// ¿El elemento está en descanso ahora mismo?
final enDescansoProvider =
    FutureProvider.family<bool, DateTime>((ref, fechaTurno) {
  final perfil = ref.watch(perfilActualProvider);
  if (perfil == null) return Future.value(false);
  // Depende de la lista de eventos para recalcularse al registrar uno nuevo.
  ref.watch(eventosDelTurnoProvider(fechaTurno));
  return ref
      .watch(asistenciaRepositoryProvider)
      .estaEnDescanso(perfil.id, fechaTurno);
});
