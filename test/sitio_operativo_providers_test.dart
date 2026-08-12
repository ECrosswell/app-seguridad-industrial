import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seguridad_industrial/core/providers/app_providers.dart';
import 'package:seguridad_industrial/data/local/app_database.dart';
import 'package:seguridad_industrial/data/models/sitio.dart';
import 'package:seguridad_industrial/features/accesos/providers/accesos_provider.dart';
import 'package:seguridad_industrial/features/asistencia/providers/asistencia_provider.dart';
import 'package:seguridad_industrial/features/bitacora/providers/bitacora_provider.dart';

void main() {
  const plantaNorte = Sitio(id: 'sitio-norte', nombre: 'Planta norte');
  const plantaSur = Sitio(id: 'sitio-sur', nombre: 'Planta sur');

  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase.paraPruebas(NativeDatabase.memory());
    // Abre el executor y crea el esquema antes de observar queries de Drift.
    await db
        .into(db.localSitios)
        .insert(
          LocalSitiosCompanion.insert(
            id: plantaNorte.id,
            nombre: plantaNorte.nombre,
          ),
        );
    container = ProviderContainer.test(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sitiosDisponiblesProvider.overrideWithValue(
          const AsyncData([plantaNorte, plantaSur]),
        ),
        turnoAbiertoProvider.overrideWithValue(const AsyncData(null)),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('elige un sitio sin leer el estado antes de inicializarlo', () {
    expect(container.read(sitioSeleccionadoProvider), plantaNorte.id);
    expect(container.read(sitioOperativoProvider), plantaNorte.id);

    container
        .read(sitioSeleccionadoProvider.notifier)
        .seleccionar(plantaSur.id);

    expect(container.read(sitioSeleccionadoProvider), plantaSur.id);
    expect(container.read(sitioOperativoProvider), plantaSur.id);
  });

  test('nuevo evento obtiene sitio y fecha operativa sin ciclos', () {
    expect(container.read(sitioOperativoProvider), plantaNorte.id);
    expect(container.read(turnoFechaActualProvider), isNotNull);
  });

  test('ignora una seleccion que ya no pertenece a los sitios disponibles', () {
    container
        .read(sitioSeleccionadoProvider.notifier)
        .seleccionar('sitio-dado-de-baja');

    expect(container.read(sitioOperativoProvider), plantaNorte.id);
  });

  test('las consultas de visitantes y bitacora arrancan sin ciclos', () {
    expect(container.read(visitantesDentroProvider).hasError, isFalse);
    expect(container.read(historialAccesosProvider).hasError, isFalse);
    expect(container.read(bitacoraDelTurnoProvider).hasError, isFalse);
    expect(container.read(pendientesBitacoraProvider).hasError, isFalse);
    expect(container.read(historialBitacoraProvider).hasError, isFalse);
    expect(container.read(personalClienteProvider).hasError, isFalse);
  });
}
