import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:seguridad_industrial/core/config/app_routes.dart';
import 'package:seguridad_industrial/core/constants/enums.dart';
import 'package:seguridad_industrial/core/providers/app_providers.dart';
import 'package:seguridad_industrial/core/theme/app_theme.dart';
import 'package:seguridad_industrial/data/local/app_database.dart';
import 'package:seguridad_industrial/data/models/perfil.dart';
import 'package:seguridad_industrial/data/models/sitio.dart';
import 'package:seguridad_industrial/data/sync/sync_engine.dart';
import 'package:seguridad_industrial/features/accesos/data/accesos_repository.dart';
import 'package:seguridad_industrial/features/accesos/presentation/accesos_screen.dart';
import 'package:seguridad_industrial/features/accesos/providers/accesos_provider.dart';
import 'package:seguridad_industrial/features/asistencia/presentation/asistencia_screen.dart';
import 'package:seguridad_industrial/features/asistencia/providers/asistencia_provider.dart';
import 'package:seguridad_industrial/features/auth/providers/auth_provider.dart';
import 'package:seguridad_industrial/features/bitacora/data/bitacora_repository.dart';
import 'package:seguridad_industrial/features/bitacora/presentation/bitacora_form_screen.dart';
import 'package:seguridad_industrial/features/bitacora/presentation/bitacora_screen.dart';
import 'package:seguridad_industrial/features/bitacora/providers/bitacora_provider.dart';

void main() {
  const sitio = Sitio(id: 'sitio-video', nombre: 'Planta del video');
  const perfil = Perfil(
    id: 'usuario-video',
    nombreCompleto: 'Elemento de prueba',
    correo: 'elemento@example.com',
    telefonoWhatsapp: '',
    rol: RolUsuario.elemento,
  );

  setUpAll(() => initializeDateFormatting('es_MX'));

  Future<AppDatabase> crearBase() async {
    final db = AppDatabase.paraPruebas(NativeDatabase.memory());
    await db
        .into(db.localSitios)
        .insert(
          LocalSitiosCompanion.insert(id: sitio.id, nombre: sitio.nombre),
        );
    addTearDown(db.close);
    return db;
  }

  Widget conProviders(AppDatabase db, Widget child) => ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      accesosRepositoryProvider.overrideWithValue(_AccesosRepositoryPrueba(db)),
      bitacoraRepositoryProvider.overrideWithValue(
        _BitacoraRepositoryPrueba(db),
      ),
      perfilActualProvider.overrideWithValue(perfil),
      sitiosDisponiblesProvider.overrideWithValue(
        const AsyncData<List<Sitio>>([sitio]),
      ),
      turnoAbiertoProvider.overrideWithValue(
        const AsyncData<LocalTurno?>(null),
      ),
      syncEstadoProvider.overrideWithValue(
        const AsyncData<SyncEstado>(SyncEstado.alDia),
      ),
      pendientesSyncProvider.overrideWithValue(const AsyncData<int>(0)),
    ],
    child: child,
  );

  Widget appConPantalla(AppDatabase db, Widget child) {
    return conProviders(
      db,
      MaterialApp(
        theme: AppTheme.claro,
        locale: const Locale('es', 'MX'),
        supportedLocales: const [Locale('es', 'MX'), Locale('es')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      ),
    );
  }

  Future<void> esperarDatosLocales(WidgetTester tester) async {
    // Evita pumpAndSettle: mientras una consulta esta cargando hay un
    // CircularProgressIndicator animado que, precisamente ante una regresion,
    // impediria que el test terminara y ocultaria el diagnostico.
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> desmontarPantalla(WidgetTester tester) async {
    // Cierra primero los listeners de Riverpod/Drift; la base se cierra en el
    // tearDown registrado por crearBase().
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  }

  testWidgets('Registrar entrada abre Asistencia en vez de quedar en blanco', (
    tester,
  ) async {
    final db = await crearBase();

    await tester.pumpWidget(appConPantalla(db, const AsistenciaScreen()));
    await esperarDatosLocales(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Asistencia'), findsOneWidget);
    expect(find.text('Registrar entrada'), findsOneWidget);
    expect(find.textContaining('ProviderException'), findsNothing);

    await desmontarPantalla(tester);
  });

  testWidgets('Visitantes muestra Dentro e Historial sin error de Riverpod', (
    tester,
  ) async {
    final db = await crearBase();

    await tester.pumpWidget(appConPantalla(db, const AccesosScreen()));
    await esperarDatosLocales(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Visitantes'), findsOneWidget);
    expect(find.text('Dentro (0)'), findsOneWidget);
    expect(find.text('No hay visitantes dentro de la planta'), findsOneWidget);

    await tester.tap(find.text('Historial'));
    await esperarDatosLocales(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Todavía no hay salidas registradas'), findsOneWidget);
    expect(find.textContaining('ProviderException'), findsNothing);

    await desmontarPantalla(tester);
  });

  testWidgets('Bitácora y Nuevo evento abren todas las vistas del video', (
    tester,
  ) async {
    final db = await crearBase();
    final router = GoRouter(
      initialLocation: Rutas.bitacora,
      routes: [
        GoRoute(
          path: Rutas.bitacora,
          builder: (_, _) => const BitacoraScreen(),
        ),
        GoRoute(
          path: Rutas.bitacoraNueva,
          builder: (_, _) => const BitacoraFormScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      conProviders(
        db,
        MaterialApp.router(
          theme: AppTheme.claro,
          locale: const Locale('es', 'MX'),
          supportedLocales: const [Locale('es', 'MX'), Locale('es')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
      ),
    );
    await esperarDatosLocales(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Sin eventos en este turno'), findsOneWidget);

    await tester.tap(find.text('Pendientes'));
    await esperarDatosLocales(tester);
    expect(find.text('Nada pendiente de resolver'), findsOneWidget);

    await tester.tap(find.text('Histórico'));
    await esperarDatosLocales(tester);
    expect(find.text('Sin histórico'), findsOneWidget);

    await tester.tap(find.text('Nuevo evento'));
    await esperarDatosLocales(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Nuevo evento'), findsOneWidget);
    expect(find.text('Descripción *'), findsOneWidget);
    expect(find.text('Guardar evento'), findsOneWidget);
    expect(find.textContaining('ProviderException'), findsNothing);

    await desmontarPantalla(tester);
  });
}

class _AccesosRepositoryPrueba extends AccesosRepository {
  const _AccesosRepositoryPrueba(super.db);

  @override
  Stream<List<LocalRegistrosAccesoData>> observarDentro(String sitioId) =>
      Stream.value(const []);

  @override
  Stream<List<LocalRegistrosAccesoData>> observarHistorial(
    String sitioId, {
    int limite = 100,
  }) => Stream.value(const []);

  @override
  Future<List<LocalPersonalClienteData>> personalDelSitio(String sitioId) =>
      Future.value(const []);
}

class _BitacoraRepositoryPrueba extends BitacoraRepository {
  const _BitacoraRepositoryPrueba(super.db);

  @override
  Stream<List<LocalBitacoraEvento>> observarDelTurno(
    String sitioId,
    DateTime turnoFecha,
  ) => Stream.value(const []);

  @override
  Stream<List<LocalBitacoraEvento>> observarHistorial(
    String sitioId, {
    int limite = 200,
  }) => Stream.value(const []);

  @override
  Stream<List<LocalBitacoraEvento>> observarPendientes(String sitioId) =>
      Stream.value(const []);
}
