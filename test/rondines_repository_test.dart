import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seguridad_industrial/data/local/app_database.dart';
import 'package:seguridad_industrial/data/sync/rondin_sync_payload.dart';
import 'package:seguridad_industrial/features/asistencia/services/presence_service.dart';
import 'package:seguridad_industrial/features/rondines/data/rondines_repository.dart';
import 'package:seguridad_industrial/features/rondines/services/security_clock_service.dart';

void main() {
  late AppDatabase db;
  late RondinesRepository repo;

  const sitioId = '223e4567-e89b-42d3-a456-426614174000';
  const puntoId = '123e4567-e89b-42d3-a456-426614174000';
  const rutaId = '323e4567-e89b-42d3-a456-426614174000';
  const usuarioId = '423e4567-e89b-42d3-a456-426614174000';
  const raw = 'SIQR1.$puntoId.1.abcdefghijklmnopqrstuvwxyzABCDEFGH';

  setUp(() async {
    db = AppDatabase.paraPruebas(NativeDatabase.memory());
    repo = RondinesRepository(db);

    await db
        .into(db.localSitios)
        .insert(
          LocalSitiosCompanion.insert(id: sitioId, nombre: 'Planta norte'),
        );
    await db
        .into(db.localPuntosRondin)
        .insert(
          LocalPuntosRondinCompanion.insert(
            id: puntoId,
            sitioId: sitioId,
            nombre: 'Almacén',
            seccionNombre: const Value('Producción'),
            lat: const Value(19.432608),
            lng: const Value(-99.133209),
            radioMetros: const Value(35),
          ),
        );
    await db
        .into(db.localRutasRondin)
        .insert(
          LocalRutasRondinCompanion.insert(
            id: rutaId,
            sitioId: sitioId,
            nombre: 'Rondín general',
          ),
        );
    await db
        .into(db.localRutaRondinPuntos)
        .insert(
          LocalRutaRondinPuntosCompanion.insert(
            rutaId: rutaId,
            puntoId: puntoId,
            orden: 1,
          ),
        );
    await db
        .into(db.localTurnos)
        .insert(
          LocalTurnosCompanion.insert(
            id: 'local:turno',
            usuarioId: usuarioId,
            sitioId: sitioId,
            turnoFecha: DateTime(2026, 8, 11),
            inicioAt: DateTime(2026, 8, 11, 8),
            estado: 'en_curso',
          ),
        );
  });

  tearDown(() => db.close());

  test('inicia, captura y completa una ruta sin usar red', () async {
    final ruta = (await repo.rutasParaSitio(sitioId)).single;
    final turno = await (db.select(db.localTurnos)).getSingle();
    final rondinLocalId = await repo.iniciar(
      usuarioId: usuarioId,
      turno: turno,
      ruta: ruta,
      senales: const SenalesSeguridadDispositivo(
        elapsedRealtimeMs: 100000,
        bootCount: 4,
        horaAutomatica: true,
        opcionesDesarrollador: false,
        adbActivo: false,
      ),
    );

    final resultado = await repo.registrarLectura(
      rondinLocalId: rondinLocalId,
      qrRaw: raw,
      presencia: Presencia(
        lat: 19.43261,
        lng: -99.13321,
        precisionM: 7,
        gpsAgeMs: 500,
        bssid: null,
      ),
      senales: const SenalesSeguridadDispositivo(
        elapsedRealtimeMs: 120000,
        bootCount: 4,
        horaAutomatica: true,
        opcionesDesarrollador: false,
        adbActivo: false,
      ),
    );

    expect(resultado.rondinCompletado, isTrue);
    expect(resultado.evaluacion.estado, 'capturado_con_evidencia');
    final ronda = await (db.select(db.localRondines)).getSingle();
    expect(ronda.estadoLocal, 'completado');
    expect(ronda.estadoValidacionServidor, isNull);
    expect(ronda.syncStatus, 'pendiente');
    final lectura = await (db.select(db.localRondinLecturas)).getSingle();
    expect(lectura.puntoId, puntoId);
    expect(lectura.qrPayloadRaw, raw);
    expect(lectura.hashEvento, hasLength(64));
    expect(lectura.estadoValidacionServidor, isNull);
    expect(lectura.validacionLocal, startsWith('capturado_'));
    expect(db.schemaVersion, 3);
  });

  test(
    'token con formato válido queda pendiente de autenticación remota',
    () async {
      final ruta = (await repo.rutasParaSitio(sitioId)).single;
      final turno = await (db.select(db.localTurnos)).getSingle();
      final id = await repo.iniciar(
        usuarioId: usuarioId,
        turno: turno,
        ruta: ruta,
        senales: const SenalesSeguridadDispositivo(
          elapsedRealtimeMs: 1,
          bootCount: 1,
          horaAutomatica: true,
          opcionesDesarrollador: false,
          adbActivo: false,
        ),
      );

      final rawNoAutenticado = raw.replaceFirst('ABCDEFGH', 'ABCDEFGI');
      final resultado = await repo.registrarLectura(
        rondinLocalId: id,
        qrRaw: rawNoAutenticado,
        presencia: const Presencia(),
        senales: const SenalesSeguridadDispositivo(
          elapsedRealtimeMs: 2,
          bootCount: 1,
          horaAutomatica: true,
          opcionesDesarrollador: false,
          adbActivo: false,
        ),
      );
      expect(resultado.lectura.qrPayloadRaw, rawNoAutenticado);
      expect(resultado.lectura.estadoValidacionServidor, isNull);
      expect(resultado.lectura.syncStatus, 'pendiente');
      final payloadSync = serializarLecturaRondin(resultado.lectura);
      expect(payloadSync['qr_payload'], rawNoAutenticado);
      expect(payloadSync['token_version'], 1);
      expect(payloadSync, isNot(contains('qr_payload_hash')));
    },
  );

  test('rechaza offline un punto con versión distinta al catálogo', () async {
    final ruta = (await repo.rutasParaSitio(sitioId)).single;
    final turno = await (db.select(db.localTurnos)).getSingle();
    final id = await repo.iniciar(
      usuarioId: usuarioId,
      turno: turno,
      ruta: ruta,
      senales: const SenalesSeguridadDispositivo(
        elapsedRealtimeMs: 1,
        bootCount: 1,
        horaAutomatica: true,
        opcionesDesarrollador: false,
        adbActivo: false,
      ),
    );

    await expectLater(
      repo.registrarLectura(
        rondinLocalId: id,
        qrRaw: raw.replaceFirst('.1.', '.2.'),
        presencia: const Presencia(),
        senales: const SenalesSeguridadDispositivo(
          elapsedRealtimeMs: 2,
          bootCount: 1,
          horaAutomatica: true,
          opcionesDesarrollador: false,
          adbActivo: false,
        ),
      ),
      throwsA(isA<RondinException>()),
    );
    expect(await db.select(db.localRondinLecturas).get(), isEmpty);
  });
}
