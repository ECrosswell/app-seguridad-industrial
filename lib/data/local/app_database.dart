import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

/// Base local del dispositivo (sólo Android).
///
/// La app del elemento es **offline-first**: toda escritura aterriza aquí
/// primero con `syncStatus = 'pendiente'` y el motor de sincronización la
/// empuja a Supabase después. En la caseta no puede pasar que el elemento no
/// registre una entrada de mercancía porque se cayó el WiFi.
///
/// La consola web NO usa este archivo — habla directo con Supabase.
///
/// ## Dos familias de tablas
///
/// - **De escritura** ([LocalAsistencias], [LocalRegistrosAcceso],
///   [LocalBitacoraEventos], …) — se crean en el dispositivo y suben. Llevan
///   [SyncColumns].
/// - **De referencia** ([LocalSitios], [LocalCatalogoEquipo], …) — se bajan de
///   Supabase y se leen sin red. No suben nunca.
const _uuid = Uuid();

/// Columnas que comparte toda tabla que se sincroniza hacia arriba.
///
/// `localId` es la clave: se genera en el dispositivo y viaja a Supabase como
/// `local_id`, donde tiene índice único. El upsert va contra esa columna, así
/// que reintentar una subida **nunca duplica** — que es exactamente lo que pasa
/// cuando el celular pierde señal justo después de que el servidor recibió el
/// insert pero antes de que llegara la respuesta.
mixin SyncColumns on Table {
  TextColumn get localId => text().clientDefault(() => _uuid.v4())();

  /// UUID que asignó Supabase. Nulo mientras no se haya sincronizado.
  TextColumn get remoteId => text().nullable()();

  /// pendiente | sincronizando | sincronizado | fallido
  TextColumn get syncStatus => text().withDefault(const Constant('pendiente'))();

  TextColumn get syncError => text().withDefault(const Constant(''))();

  /// Se pausan los reintentos al llegar al máximo para no quemar batería
  /// reintentando algo que falla por una razón que no se va a resolver sola
  /// (por ejemplo, violar un CHECK del servidor).
  IntColumn get syncIntentos => integer().withDefault(const Constant(0))();

  TextColumn get deviceId => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAtLocal =>
      dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAtLocal =>
      dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {localId};
}

// ─────────────────────────────────────────────────────────────────────────────
// TABLAS DE ESCRITURA
// ─────────────────────────────────────────────────────────────────────────────

/// Asistencias: entrada, salida, descansos y supervisión.
class LocalAsistencias extends Table with SyncColumns {
  TextColumn get usuarioId => text()();
  TextColumn get sitioId => text()();
  DateTimeColumn get turnoFecha => dateTime()();
  TextColumn get tipoEvento => text()();
  DateTimeColumn get ocurridoAt => dateTime()();

  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  RealColumn get gpsAccuracyM => real().nullable()();
  TextColumn get wifiBssid => text().nullable()();
  TextColumn get wifiSsid => text().nullable()();

  /// Ruta del archivo en el dispositivo. El motor la sube a Storage y llena
  /// [selfieUrl] antes de empujar la fila.
  TextColumn get selfieRutaLocal => text().nullable()();
  TextColumn get selfieUrl => text().nullable()();
  BoolColumn get livenessPassed =>
      boolean().withDefault(const Constant(false))();

  TextColumn get observaciones => text().withDefault(const Constant(''))();

  /// Lo que respondió el servidor. Se guarda para poder mostrarle al elemento
  /// si su registro quedó como retardo sin tener que volver a consultar.
  TextColumn get clasificacionServidor => text().nullable()();
  IntColumn get minutosRetardoServidor => integer().nullable()();
  TextColumn get estadoValidacionServidor => text().nullable()();
}

/// Registros de acceso de visitantes.
class LocalRegistrosAcceso extends Table with SyncColumns {
  TextColumn get sitioId => text()();
  TextColumn get registradoPor => text()();
  TextColumn get visitanteLocalId => text().nullable()();

  TextColumn get nombreCompleto => text()();
  TextColumn get empresaProcedencia =>
      text().withDefault(const Constant(''))();
  TextColumn get telefono => text().withDefault(const Constant(''))();

  TextColumn get personaVisitadaId => text().nullable()();
  TextColumn get personaVisitadaTexto =>
      text().withDefault(const Constant(''))();
  TextColumn get asunto => text()();

  BoolColumn get ingresaVehiculo =>
      boolean().withDefault(const Constant(false))();
  TextColumn get placas => text().withDefault(const Constant(''))();
  TextColumn get vehiculoMarca => text().withDefault(const Constant(''))();
  TextColumn get vehiculoModelo => text().withDefault(const Constant(''))();
  TextColumn get vehiculoColor => text().withDefault(const Constant(''))();

  TextColumn get identificacionTipo =>
      text().withDefault(const Constant(''))();
  TextColumn get identificacionRutaLocal => text().nullable()();
  TextColumn get identificacionUrl => text().nullable()();

  TextColumn get avisoPrivacidadId => text().nullable()();
  BoolColumn get avisoAceptado =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get avisoAceptadoAt => dateTime().nullable()();

  DateTimeColumn get horaEntrada => dateTime()();
  DateTimeColumn get horaSalida => dateTime().nullable()();
  TextColumn get salidaRegistradaPor => text().nullable()();

  TextColumn get observaciones => text().withDefault(const Constant(''))();
}

/// Visitantes recurrentes creados desde el dispositivo.
class LocalVisitantes extends Table with SyncColumns {
  TextColumn get nombreCompleto => text()();
  TextColumn get empresa => text().withDefault(const Constant(''))();
  TextColumn get telefono => text().withDefault(const Constant(''))();
  TextColumn get placasHabituales => text().withDefault(const Constant(''))();
  TextColumn get notas => text().withDefault(const Constant(''))();
  BoolColumn get esFrecuente => boolean().withDefault(const Constant(true))();
  BoolColumn get vetado => boolean().withDefault(const Constant(false))();
  TextColumn get motivoVeto => text().withDefault(const Constant(''))();
  IntColumn get vecesRegistrado => integer().withDefault(const Constant(0))();
  DateTimeColumn get ultimaVisitaAt => dateTime().nullable()();
}

/// Eventos de bitácora.
class LocalBitacoraEventos extends Table with SyncColumns {
  TextColumn get sitioId => text()();
  TextColumn get registradoPor => text()();
  DateTimeColumn get turnoFecha => dateTime()();
  TextColumn get tipo => text()();
  DateTimeColumn get ocurridoAt => dateTime()();
  TextColumn get descripcion => text()();

  TextColumn get placas => text().withDefault(const Constant(''))();
  TextColumn get transportista => text().withDefault(const Constant(''))();
  TextColumn get empresaTransporte => text().withDefault(const Constant(''))();
  TextColumn get numDocumento => text().withDefault(const Constant(''))();
  TextColumn get destino => text().withDefault(const Constant(''))();

  TextColumn get autorizadoPorId => text().nullable()();
  TextColumn get autorizadoPorTexto =>
      text().withDefault(const Constant(''))();

  TextColumn get prioridad => text().withDefault(const Constant('normal'))();
  BoolColumn get requiereSeguimiento =>
      boolean().withDefault(const Constant(false))();
}

/// Fotos de bitácora. Tabla aparte porque un evento admite varias y cada una
/// se sube por separado: si falla la tercera, las dos primeras no se repiten.
class LocalBitacoraFotos extends Table with SyncColumns {
  TextColumn get eventoLocalId => text()();
  TextColumn get rutaLocal => text().nullable()();
  TextColumn get fotoUrl => text().nullable()();
  TextColumn get descripcion => text().withDefault(const Constant(''))();
  IntColumn get orden => integer().withDefault(const Constant(0))();
}

/// Recepción de turno: la revisión del equipo de la caseta.
class LocalRecepcionesTurno extends Table with SyncColumns {
  TextColumn get sitioId => text()();
  DateTimeColumn get turnoFecha => dateTime()();
  TextColumn get recibeId => text()();
  TextColumn get entregaId => text().nullable()();
  BoolColumn get aceptaConformidad => boolean()();
  DateTimeColumn get aceptadoAt => dateTime()();
  TextColumn get observaciones => text().withDefault(const Constant(''))();
}

/// Estado de cada partida de equipo dentro de una recepción.
class LocalRecepcionItems extends Table with SyncColumns {
  TextColumn get recepcionLocalId => text()();
  TextColumn get equipoId => text()();
  TextColumn get estado => text()();
  IntColumn get cantidadEncontrada =>
      integer().withDefault(const Constant(1))();
  TextColumn get observaciones => text().withDefault(const Constant(''))();
  TextColumn get fotoRutaLocal => text().nullable()();
  TextColumn get fotoUrl => text().nullable()();
}

// ─────────────────────────────────────────────────────────────────────────────
// TABLAS DE REFERENCIA (se bajan de Supabase)
// ─────────────────────────────────────────────────────────────────────────────

class LocalSitios extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  IntColumn get radioMetros => integer().withDefault(const Constant(150))();
  TextColumn get horaInicioTurno =>
      text().withDefault(const Constant('08:00'))();
  IntColumn get minutosToleranciaRetardo =>
      integer().withDefault(const Constant(1))();
  IntColumn get minutosToleranciaFalta =>
      integer().withDefault(const Constant(90))();
  IntColumn get husoHorarioOffsetH =>
      integer().withDefault(const Constant(-6))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalWifiAps extends Table {
  TextColumn get id => text()();
  TextColumn get sitioId => text()();
  TextColumn get bssid => text()();
  TextColumn get ssid => text().withDefault(const Constant(''))();
  TextColumn get nombreZona => text().withDefault(const Constant(''))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalCatalogoEquipo extends Table {
  TextColumn get id => text()();
  TextColumn get sitioId => text()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text().withDefault(const Constant(''))();
  TextColumn get categoria => text().withDefault(const Constant('general'))();
  IntColumn get cantidadEsperada => integer().withDefault(const Constant(1))();
  BoolColumn get requiereFoto => boolean().withDefault(const Constant(false))();
  BoolColumn get debeEstarSinUsar =>
      boolean().withDefault(const Constant(false))();
  IntColumn get orden => integer().withDefault(const Constant(0))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalPersonalCliente extends Table {
  TextColumn get id => text()();
  TextColumn get sitioId => text()();
  TextColumn get nombreCompleto => text()();
  TextColumn get area => text().withDefault(const Constant(''))();
  TextColumn get puesto => text().withDefault(const Constant(''))();
  TextColumn get extension => text().withDefault(const Constant(''))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Directorio de personal. Lo usa la entrega de turno (a quién le entrego) y
/// la pantalla de contacto por WhatsApp.
class LocalProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get nombreCompleto => text()();
  TextColumn get correo => text().withDefault(const Constant(''))();
  TextColumn get telefonoWhatsapp => text().withDefault(const Constant(''))();
  TextColumn get rol => text()();
  TextColumn get puesto => text().withDefault(const Constant(''))();
  TextColumn get fotoPerfilUrl => text().nullable()();
  TextColumn get estadoLaboral => text().withDefault(const Constant('activo'))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalAvisosPrivacidad extends Table {
  TextColumn get id => text()();
  TextColumn get version => text()();
  TextColumn get titulo => text()();
  TextColumn get resumen => text()();
  TextColumn get urlCompleto => text().withDefault(const Constant(''))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Espejo del turno abierto. Permite saber sin red si el elemento ya registró
/// entrada, para decidir si mostrarle "Registrar entrada" o "Registrar salida".
class LocalTurnos extends Table {
  TextColumn get id => text()();
  TextColumn get usuarioId => text()();
  TextColumn get sitioId => text()();
  DateTimeColumn get turnoFecha => dateTime()();
  DateTimeColumn get inicioAt => dateTime()();
  DateTimeColumn get finAt => dateTime().nullable()();
  TextColumn get estado => text()();
  TextColumn get clasificacionEntrada =>
      text().withDefault(const Constant('a_tiempo'))();
  IntColumn get minutosRetardo => integer().withDefault(const Constant(0))();
  BoolColumn get esDoblete => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    LocalAsistencias,
    LocalRegistrosAcceso,
    LocalVisitantes,
    LocalBitacoraEventos,
    LocalBitacoraFotos,
    LocalRecepcionesTurno,
    LocalRecepcionItems,
    LocalSitios,
    LocalWifiAps,
    LocalCatalogoEquipo,
    LocalPersonalCliente,
    LocalProfiles,
    LocalAvisosPrivacidad,
    LocalTurnos,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_abrirConexion());

  AppDatabase.paraPruebas(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        beforeOpen: (details) async {
          // Sin esto SQLite ignora las llaves foráneas declaradas.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Borra todo lo local. Se usa al cerrar sesión: el siguiente elemento que
  /// use el equipo no debe ver los datos del anterior.
  Future<void> limpiarTodo() async {
    await transaction(() async {
      for (final tabla in allTables) {
        await delete(tabla).go();
      }
    });
  }

  /// Cuántos registros están esperando subir. Alimenta el indicador de la
  /// barra superior, que es lo que le dice al elemento si ya se guardó "de
  /// verdad" o sigue nada más en el teléfono.
  Future<int> pendientesDeSincronizar() async {
    final consultas = <Future<int>>[
      _contarPendientes(localAsistencias),
      _contarPendientes(localRegistrosAcceso),
      _contarPendientes(localVisitantes),
      _contarPendientes(localBitacoraEventos),
      _contarPendientes(localBitacoraFotos),
      _contarPendientes(localRecepcionesTurno),
      _contarPendientes(localRecepcionItems),
    ];
    final resultados = await Future.wait(consultas);
    var total = 0;
    for (final n in resultados) {
      total += n;
    }
    return total;
  }

  Future<int> _contarPendientes(TableInfo tabla) async {
    final estado = tabla.columnsByName['sync_status']!;
    final consulta = selectOnly(tabla)
      ..addColumns([estado.count()])
      ..where(estado.equals('pendiente') | estado.equals('fallido'));
    final fila = await consulta.getSingle();
    return fila.read(estado.count()) ?? 0;
  }
}

QueryExecutor _abrirConexion() {
  return driftDatabase(name: 'seguridad_industrial');
}
