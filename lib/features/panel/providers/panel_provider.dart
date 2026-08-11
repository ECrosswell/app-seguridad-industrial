import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/perfil.dart';
import '../../../data/models/sitio.dart';
import '../data/panel_repository.dart';
import '../data/rondin_admin_models.dart';

final panelRepositoryProvider = Provider<PanelRepository>(
  (ref) => const PanelRepository(),
);

/// Sitios que el usuario puede consultar. El RLS ya filtra: el cliente ve sólo
/// el suyo, el admin todos.
final sitiosPanelProvider = FutureProvider<List<Sitio>>((ref) {
  return ref.watch(panelRepositoryProvider).sitios();
});

/// Sitio activo del panel. `null` = todos los que el usuario alcance.
final sitioFiltroProvider = NotifierProvider<SitioFiltro, String?>(
  SitioFiltro.new,
);

class SitioFiltro extends Notifier<String?> {
  @override
  String? build() => null;

  void seleccionar(String? sitioId) => state = sitioId;
}

final rangoFiltroProvider = NotifierProvider<RangoFiltro, RangoFechas>(
  RangoFiltro.new,
);

class RangoFiltro extends Notifier<RangoFechas> {
  @override
  RangoFechas build() => RangoFechas.ultimosDias(7);

  void seleccionar(RangoFechas rango) => state = rango;
}

/// Refresca las vistas en vivo cada 30 s.
///
/// Se usa un temporizador y no Realtime porque `v_personal_en_sitio` es una
/// vista, y Supabase Realtime sólo emite cambios de tablas. Suscribirse a las
/// tablas base obligaría a recomponer la vista en el cliente.
final _tickProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 30), (i) => i);
});

final personalEnSitioProvider = FutureProvider<List<PersonalEnSitio>>((
  ref,
) async {
  ref.watch(_tickProvider);
  return ref
      .watch(panelRepositoryProvider)
      .personalEnSitio(sitioId: ref.watch(sitioFiltroProvider));
});

final visitantesDentroPanelProvider = FutureProvider<List<VisitanteDentro>>((
  ref,
) async {
  ref.watch(_tickProvider);
  return ref
      .watch(panelRepositoryProvider)
      .visitantesDentro(sitioId: ref.watch(sitioFiltroProvider));
});

final asistenciasPanelProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) {
  return ref
      .watch(panelRepositoryProvider)
      .asistencias(
        rango: ref.watch(rangoFiltroProvider),
        sitioId: ref.watch(sitioFiltroProvider),
      );
});

final turnosPanelProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref
      .watch(panelRepositoryProvider)
      .turnos(
        rango: ref.watch(rangoFiltroProvider),
        sitioId: ref.watch(sitioFiltroProvider),
      );
});

final accesosPanelProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref
      .watch(panelRepositoryProvider)
      .registrosAcceso(
        rango: ref.watch(rangoFiltroProvider),
        sitioId: ref.watch(sitioFiltroProvider),
      );
});

final bitacoraPanelProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref
      .watch(panelRepositoryProvider)
      .bitacora(
        rango: ref.watch(rangoFiltroProvider),
        sitioId: ref.watch(sitioFiltroProvider),
      );
});

final estadoEquipoProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref
      .watch(panelRepositoryProvider)
      .estadoEquipo(sitioId: ref.watch(sitioFiltroProvider));
});

final recepcionesConNovedadProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
      return ref
          .watch(panelRepositoryProvider)
          .recepcionesConNovedad(sitioId: ref.watch(sitioFiltroProvider));
    });

final asistenciasPorRevisarProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
      return ref
          .watch(panelRepositoryProvider)
          .asistenciasPorRevisar(sitioId: ref.watch(sitioFiltroProvider));
    });

final solicitudesPanelProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) {
  return ref
      .watch(panelRepositoryProvider)
      .solicitudes(sitioId: ref.watch(sitioFiltroProvider));
});

final usuariosPanelProvider = FutureProvider<List<Perfil>>((ref) {
  return ref.watch(panelRepositoryProvider).usuarios();
});

final personalClientePanelProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, sitioId) {
      return ref.watch(panelRepositoryProvider).personalCliente(sitioId);
    });

final catalogoEquipoPanelProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, sitioId) {
      return ref.watch(panelRepositoryProvider).catalogoEquipo(sitioId);
    });

final wifiApsPanelProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, sitioId) {
      return ref.watch(panelRepositoryProvider).wifiAps(sitioId);
    });

final seccionesRondinPanelProvider =
    FutureProvider.family<List<SeccionRondin>, String?>((ref, sitioId) {
      return ref
          .watch(panelRepositoryProvider)
          .seccionesRondin(sitioId: sitioId);
    });

final puntosRondinPanelProvider = FutureProvider<List<PuntoRondin>>((ref) {
  return ref
      .watch(panelRepositoryProvider)
      .puntosRondin(sitioId: ref.watch(sitioFiltroProvider));
});

final resultadosRondinPanelProvider = FutureProvider<List<ResultadoRondin>>((
  ref,
) {
  return ref
      .watch(panelRepositoryProvider)
      .resultadosRondin(
        rango: ref.watch(rangoFiltroProvider),
        sitioId: ref.watch(sitioFiltroProvider),
      );
});

/// Recarga todo lo que muestra el panel. Se llama tras cualquier escritura.
void refrescarPanel(WidgetRef ref) {
  ref.invalidate(personalEnSitioProvider);
  ref.invalidate(visitantesDentroPanelProvider);
  ref.invalidate(asistenciasPanelProvider);
  ref.invalidate(turnosPanelProvider);
  ref.invalidate(accesosPanelProvider);
  ref.invalidate(bitacoraPanelProvider);
  ref.invalidate(estadoEquipoProvider);
  ref.invalidate(recepcionesConNovedadProvider);
  ref.invalidate(asistenciasPorRevisarProvider);
  ref.invalidate(solicitudesPanelProvider);
  ref.invalidate(puntosRondinPanelProvider);
  ref.invalidate(resultadosRondinPanelProvider);
}
