import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/accesos/presentation/acceso_form_screen.dart';
import '../../features/accesos/presentation/accesos_screen.dart';
import '../../features/asistencia/presentation/asistencia_screen.dart';
import '../../features/auth/presentation/cambiar_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/bitacora/presentation/bitacora_form_screen.dart';
import '../../features/bitacora/presentation/bitacora_screen.dart';
import '../../features/inicio/presentation/inicio_screen.dart';
import '../../features/inicio/presentation/shell_operativo.dart';
import '../../features/notificaciones/presentation/notificaciones_screen.dart';
import '../../features/perfil/presentation/perfil_screen.dart';
import '../../features/recepcion_turno/presentation/recepcion_turno_screen.dart';
import 'app_routes.dart';

/// Enrutador de la app Android (elemento y supervisor).
///
/// La consola web usa `app_router_web.dart`, que es un árbol distinto: las
/// pantallas de aquí dependen de Drift y no compilan para navegador.
final routerProvider = Provider<GoRouter>((ref) {
  // `refreshListenable` reevalúa las redirecciones cuando cambia la sesión.
  final notificador = _NotificadorAuth(ref);
  ref.onDispose(notificador.dispose);

  return GoRouter(
    initialLocation: Rutas.inicio,
    refreshListenable: notificador,
    redirect: (context, estadoRuta) {
      final auth = ref.read(authControllerProvider);
      final ruta = estadoRuta.matchedLocation;

      if (auth is AuthCargando) return null;

      if (auth is AuthSinSesion) {
        return ruta == Rutas.login ? null : Rutas.login;
      }

      if (auth is AuthAutenticado) {
        // Cuenta con contraseña temporal: no se sale de aquí hasta cambiarla.
        // Si se le dejara entrar, la contraseña que el admin conoce seguiría
        // sirviendo indefinidamente.
        if (auth.debeCambiarPassword) {
          return ruta == Rutas.cambiarPassword ? null : Rutas.cambiarPassword;
        }
        if (ruta == Rutas.login || ruta == Rutas.cambiarPassword) {
          return Rutas.inicio;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Rutas.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: Rutas.cambiarPassword,
        builder: (_, _) => const CambiarPasswordScreen(forzada: true),
      ),
      GoRoute(
        path: Rutas.perfil,
        builder: (_, _) => const PerfilScreen(),
      ),
      GoRoute(
        path: Rutas.notificaciones,
        builder: (_, _) => const NotificacionesScreen(),
      ),
      GoRoute(
        path: Rutas.recepcionTurno,
        builder: (_, _) => const RecepcionTurnoScreen(),
      ),
      GoRoute(
        path: Rutas.accesoNuevo,
        builder: (_, _) => const AccesoFormScreen(),
      ),
      GoRoute(
        path: Rutas.bitacoraNueva,
        builder: (_, _) => const BitacoraFormScreen(),
      ),

      // Pestañas principales. ShellRoute mantiene la barra inferior fija y
      // conserva el estado de cada pestaña al cambiar entre ellas.
      ShellRoute(
        builder: (context, state, hijo) => ShellOperativo(child: hijo),
        routes: [
          GoRoute(
            path: Rutas.inicio,
            pageBuilder: (_, estado) =>
                NoTransitionPage(key: estado.pageKey, child: const InicioScreen()),
          ),
          GoRoute(
            path: Rutas.asistencia,
            pageBuilder: (_, estado) => NoTransitionPage(
                key: estado.pageKey, child: const AsistenciaScreen()),
          ),
          GoRoute(
            path: Rutas.accesos,
            pageBuilder: (_, estado) =>
                NoTransitionPage(key: estado.pageKey, child: const AccesosScreen()),
          ),
          GoRoute(
            path: Rutas.bitacora,
            pageBuilder: (_, estado) => NoTransitionPage(
                key: estado.pageKey, child: const BitacoraScreen()),
          ),
        ],
      ),
    ],
    errorBuilder: (context, estado) => Scaffold(
      appBar: AppBar(title: const Text('Ruta no encontrada')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore_off_outlined, size: 56),
            const SizedBox(height: 16),
            Text('No existe la pantalla ${estado.uri}'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(Rutas.inicio),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Puente entre Riverpod y GoRouter: convierte los cambios del estado de
/// autenticación en notificaciones que disparan la reevaluación de rutas.
class _NotificadorAuth extends ChangeNotifier {
  _NotificadorAuth(this._ref) {
    _quitar = _ref.listen<EstadoAuth>(
      authControllerProvider,
      (_, _) => notifyListeners(),
    ).close;
  }

  final Ref _ref;
  late final VoidCallback _quitar;

  @override
  void dispose() {
    _quitar();
    super.dispose();
  }
}
