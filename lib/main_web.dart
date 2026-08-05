import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/config/app_router_web.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';

/// Punto de entrada de la **consola web** (administrador y cliente).
///
/// Hay que arrancarlo explícitamente con `-t lib/main_web.dart`. Sin ese
/// argumento Flutter usa `lib/main.dart`, que depende de Drift y del motor de
/// sincronización — ninguno de los dos existe en navegador.
///
/// Esta entrada NO inicia el motor de sincronización: la consola habla directo
/// con Supabase.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es_MX');
  await SupabaseService.inicializar();

  runApp(const ProviderScope(child: ConsolaSeguridadIndustrial()));
}

class ConsolaSeguridadIndustrial extends ConsumerWidget {
  const ConsolaSeguridadIndustrial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Seguridad Industrial — Consola',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      darkTheme: AppTheme.oscuro,
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(routerWebProvider),
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
