import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/config/app_router.dart';
import 'core/providers/app_providers.dart';
import 'core/services/app_logger.dart';
import 'core/services/notificaciones_service.dart';
import 'core/services/push_service.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';

/// Punto de entrada de la app **Android** (elemento y supervisor).
///
/// La consola web arranca en `main_web.dart`, que no toca Drift ni el motor de
/// sincronización. Correr esta entrada en navegador falla: no hay SQLite.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es_MX');
  await SupabaseService.inicializar();

  // El canal de notificaciones se crea al arrancar y no al iniciar sesión: si
  // llega un push antes de que el usuario haya entrado alguna vez, Android
  // necesita el canal ya declarado para no mandarlo al genérico silenciado.
  await NotificacionesService.instancia.inicializar();

  runApp(const ProviderScope(child: AppSeguridadIndustrial()));
}

class AppSeguridadIndustrial extends ConsumerStatefulWidget {
  const AppSeguridadIndustrial({super.key});

  @override
  ConsumerState<AppSeguridadIndustrial> createState() =>
      _AppSeguridadIndustrialState();
}

class _AppSeguridadIndustrialState
    extends ConsumerState<AppSeguridadIndustrial> {
  @override
  void initState() {
    super.initState();

    // El motor arranca después del primer frame: iniciarlo durante el build
    // haría que escriba estado de providers mientras el árbol se está montando.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual<EstadoAuth>(
        authControllerProvider,
        (anterior, actual) {
          final motor = ref.read(syncEngineProvider);
          if (actual is AuthAutenticado) {
            motor.iniciar();
            // Dos canales de alerta que se complementan: Realtime cubre la app
            // abierta, FCM cubre la app cerrada.
            NotificacionesService.instancia.escuchar();
            PushService.instancia.registrarDispositivo();
          } else {
            motor.detener();
            NotificacionesService.instancia.dejarDeEscuchar();
            PushService.instancia.darDeBajaDispositivo();
          }
        },
        fireImmediately: true,
      );

      AppLogger.i('App iniciada');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Seguridad Industrial',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      darkTheme: AppTheme.oscuro,
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('es', 'MX'),
      supportedLocales: const [Locale('es', 'MX'), Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
