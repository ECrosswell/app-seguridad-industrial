import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cambiar_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/panel/presentation/panel_bitacora_screen.dart';
import '../../features/panel/presentation/panel_equipo_screen.dart';
import '../../features/panel/presentation/panel_inicio_screen.dart';
import '../../features/panel/presentation/panel_personal_screen.dart';
import '../../features/panel/presentation/panel_reportes_screen.dart';
import '../../features/panel/presentation/panel_rondines_screen.dart';
import '../../features/panel/presentation/panel_shell.dart';
import '../../features/panel/presentation/panel_sitios_screen.dart';
import '../../features/panel/presentation/panel_solicitudes_screen.dart';
import '../../features/panel/presentation/panel_usuarios_screen.dart';
import '../../features/panel/presentation/panel_visitantes_screen.dart';
import '../constants/enums.dart' show RolUsuario;
import 'app_routes.dart';

/// Enrutador de la consola web (administrador y cliente).
///
/// Árbol distinto al de Android a propósito: ninguna pantalla de aquí toca
/// Drift ni el motor de sincronización, que no compilan para navegador.
final routerWebProvider = Provider<GoRouter>((ref) {
  final notificador = _NotificadorAuthWeb(ref);
  ref.onDispose(notificador.dispose);

  return GoRouter(
    initialLocation: Rutas.panel,
    refreshListenable: notificador,
    redirect: (context, estadoRuta) {
      final auth = ref.read(authControllerProvider);
      final ruta = estadoRuta.matchedLocation;

      if (auth is AuthCargando) return null;

      if (auth is AuthSinSesion) {
        return ruta == Rutas.login ? null : Rutas.login;
      }

      if (auth is AuthAutenticado) {
        if (auth.debeCambiarPassword) {
          return ruta == Rutas.cambiarPassword ? null : Rutas.cambiarPassword;
        }
        if (ruta == Rutas.login) {
          return Rutas.panel;
        }
        // La administración de sitios y usuarios es sólo del admin. Sin este
        // corte, un cliente que escriba la URL a mano entraría (el RLS lo
        // frenaría al escribir, pero no debe ni ver la pantalla).
        final soloAdmin =
            ruta == Rutas.panelSitios ||
            ruta == Rutas.panelUsuarios ||
            ruta == Rutas.panelRondines;
        if (soloAdmin && auth.perfil.rol != RolUsuario.admin) {
          return Rutas.panel;
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: Rutas.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: Rutas.cambiarPassword,
        builder: (_, _) {
          final auth = ref.read(authControllerProvider);
          return CambiarPasswordScreen(
            forzada: auth is AuthAutenticado && auth.debeCambiarPassword,
            destinoAlGuardar: Rutas.panel,
          );
        },
      ),
      ShellRoute(
        builder: (context, state, hijo) => PanelShell(child: hijo),
        routes: [
          GoRoute(
            path: Rutas.panel,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelInicioScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelPersonal,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelPersonalScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelVisitantes,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelVisitantesScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelBitacora,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelBitacoraScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelEquipo,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelEquipoScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelSolicitudes,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelSolicitudesScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelReportes,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelReportesScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelRondines,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelRondinesScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelSitios,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelSitiosScreen(),
            ),
          ),
          GoRoute(
            path: Rutas.panelUsuarios,
            pageBuilder: (_, e) => NoTransitionPage(
              key: e.pageKey,
              child: const PanelUsuariosScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, estado) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore_off_outlined, size: 56),
            const SizedBox(height: 16),
            Text('No existe la pantalla ${estado.uri}'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(Rutas.panel),
              child: const Text('Ir al tablero'),
            ),
          ],
        ),
      ),
    ),
  );
});

class _NotificadorAuthWeb extends ChangeNotifier {
  _NotificadorAuthWeb(this._ref) {
    _quitar = _ref
        .listen<EstadoAuth>(authControllerProvider, (_, _) => notifyListeners())
        .close;
  }

  final Ref _ref;
  late final VoidCallback _quitar;

  @override
  void dispose() {
    _quitar();
    super.dispose();
  }
}
