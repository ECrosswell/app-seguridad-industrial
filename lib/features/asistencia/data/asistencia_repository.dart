import 'package:drift/drift.dart';

import '../../../core/constants/enums.dart';
import '../../../core/services/device_service.dart';
import '../../../data/local/app_database.dart';
import '../../../data/models/sitio.dart';
import '../services/presence_service.dart';

/// Escrituras y consultas de asistencia contra la base local.
///
/// Todo aterriza en Drift primero. El motor de sincronización se encarga de
/// subirlo. Desde el punto de vista del elemento, el registro queda guardado en
/// el instante en que toca el botón — aunque la caseta esté sin señal.
class AsistenciaRepository {
  const AsistenciaRepository(this._db);

  final AppDatabase _db;

  /// Registra un evento de asistencia.
  ///
  /// Devuelve el `localId` de la fila creada. La clasificación (a tiempo /
  /// retardo / falta) **no se calcula aquí**: la pone el servidor al recibirla.
  /// Si la calculara el cliente, una app modificada podría mandarse un
  /// "a tiempo" a cualquier hora.
  Future<String> registrarEvento({
    required String usuarioId,
    required String sitioId,
    required TipoEventoAsistencia tipo,
    required Presencia presencia,
    required DateTime fechaTurno,
    String? selfieRutaLocal,
    bool livenessPassed = false,
    String observaciones = '',
  }) async {
    final deviceId = await DeviceService.instancia.deviceId();
    final ahora = DateTime.now();

    final fila = LocalAsistenciasCompanion.insert(
      usuarioId: usuarioId,
      sitioId: sitioId,
      turnoFecha: fechaTurno,
      tipoEvento: tipo.valor,
      ocurridoAt: ahora,
      deviceId: Value(deviceId),
      lat: Value(presencia.lat),
      lng: Value(presencia.lng),
      gpsAccuracyM: Value(presencia.precisionM),
      wifiBssid: Value(presencia.bssid),
      wifiSsid: Value(presencia.ssid),
      selfieRutaLocal: Value(selfieRutaLocal),
      livenessPassed: Value(livenessPassed),
      observaciones: Value(observaciones),
    );

    final creada = await _db.into(_db.localAsistencias).insertReturning(fila);

    // Espejo optimista del turno: sin esto la pantalla seguiría ofreciendo
    // "Registrar entrada" hasta que sincronizara, y el elemento la marcaría dos
    // veces creyendo que no se guardó.
    if (tipo == TipoEventoAsistencia.entrada) {
      await _abrirTurnoLocal(
        usuarioId: usuarioId,
        sitioId: sitioId,
        fechaTurno: fechaTurno,
        inicioAt: ahora,
        localId: creada.localId,
      );
    } else if (tipo == TipoEventoAsistencia.salida) {
      await _cerrarTurnoLocal(usuarioId, ahora);
    }

    return creada.localId;
  }

  Future<void> _abrirTurnoLocal({
    required String usuarioId,
    required String sitioId,
    required DateTime fechaTurno,
    required DateTime inicioAt,
    required String localId,
  }) async {
    await _db.into(_db.localTurnos).insertOnConflictUpdate(
          LocalTurnosCompanion.insert(
            // Prefijo `local:` para distinguir el turno provisional del que
            // baje después del servidor con su uuid real.
            id: 'local:$localId',
            usuarioId: usuarioId,
            sitioId: sitioId,
            turnoFecha: fechaTurno,
            inicioAt: inicioAt,
            estado: EstadoTurno.enCurso.valor,
          ),
        );
  }

  Future<void> _cerrarTurnoLocal(String usuarioId, DateTime finAt) async {
    await (_db.update(_db.localTurnos)
          ..where((t) =>
              t.usuarioId.equals(usuarioId) &
              t.estado.equals(EstadoTurno.enCurso.valor)))
        .write(LocalTurnosCompanion(
      estado: Value(EstadoTurno.cerrado.valor),
      finAt: Value(finAt),
    ));
  }

  /// Turno abierto del usuario, si lo hay. Es lo que decide si la pantalla
  /// ofrece registrar entrada o salida.
  Future<LocalTurno?> turnoAbierto(String usuarioId) {
    return (_db.select(_db.localTurnos)
          ..where((t) =>
              t.usuarioId.equals(usuarioId) &
              t.estado.equals(EstadoTurno.enCurso.valor))
          ..orderBy([(t) => OrderingTerm.desc(t.inicioAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<LocalTurno?> observarTurnoAbierto(String usuarioId) {
    return (_db.select(_db.localTurnos)
          ..where((t) =>
              t.usuarioId.equals(usuarioId) &
              t.estado.equals(EstadoTurno.enCurso.valor))
          ..orderBy([(t) => OrderingTerm.desc(t.inicioAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Eventos del turno en curso, para la línea de tiempo de la pantalla.
  Stream<List<LocalAsistencia>> observarEventosDelTurno(
    String usuarioId,
    DateTime fechaTurno,
  ) {
    return (_db.select(_db.localAsistencias)
          ..where((t) =>
              t.usuarioId.equals(usuarioId) & t.turnoFecha.equals(fechaTurno))
          ..orderBy([(t) => OrderingTerm.desc(t.ocurridoAt)]))
        .watch();
  }

  /// ¿Está en descanso? Se deduce del último evento de descanso registrado.
  Future<bool> estaEnDescanso(String usuarioId, DateTime fechaTurno) async {
    final eventos = await (_db.select(_db.localAsistencias)
          ..where((t) =>
              t.usuarioId.equals(usuarioId) &
              t.turnoFecha.equals(fechaTurno) &
              (t.tipoEvento.equals(TipoEventoAsistencia.inicioDescanso.valor) |
                  t.tipoEvento.equals(TipoEventoAsistencia.finDescanso.valor)))
          ..orderBy([(t) => OrderingTerm.desc(t.ocurridoAt)])
          ..limit(1))
        .get();

    if (eventos.isEmpty) return false;
    return eventos.first.tipoEvento == TipoEventoAsistencia.inicioDescanso.valor;
  }

  /// Sitios disponibles. El elemento puede cubrir uno distinto al suyo, así que
  /// se listan todos los activos y no sólo el asignado.
  Future<List<Sitio>> sitiosActivos() async {
    final filas = await (_db.select(_db.localSitios)
          ..where((t) => t.activo.equals(true)))
        .get();

    return filas
        .map((f) => Sitio(
              id: f.id,
              nombre: f.nombre,
              lat: f.lat,
              lng: f.lng,
              radioMetros: f.radioMetros,
              horaInicioTurno: f.horaInicioTurno,
              minutosToleranciaRetardo: f.minutosToleranciaRetardo,
              minutosToleranciaFalta: f.minutosToleranciaFalta,
              husoHorarioOffsetH: f.husoHorarioOffsetH,
              activo: f.activo,
            ))
        .toList();
  }

  Future<Sitio?> sitioPorId(String id) async {
    final todos = await sitiosActivos();
    for (final s in todos) {
      if (s.id == id) return s;
    }
    return null;
  }
}
