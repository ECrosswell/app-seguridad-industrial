import 'package:drift/drift.dart';

import '../../../core/constants/enums.dart';
import '../../../core/services/device_service.dart';
import '../../../data/local/app_database.dart';

/// Estado que declara el elemento para una partida del catálogo.
class PartidaRevisada {
  const PartidaRevisada({
    required this.equipoId,
    required this.estado,
    this.cantidadEncontrada = 1,
    this.observaciones = '',
    this.fotoRutaLocal,
  });

  final String equipoId;
  final EstadoEquipo estado;
  final int cantidadEncontrada;
  final String observaciones;
  final String? fotoRutaLocal;

  PartidaRevisada copiarCon({
    EstadoEquipo? estado,
    int? cantidadEncontrada,
    String? observaciones,
    String? fotoRutaLocal,
  }) {
    return PartidaRevisada(
      equipoId: equipoId,
      estado: estado ?? this.estado,
      cantidadEncontrada: cantidadEncontrada ?? this.cantidadEncontrada,
      observaciones: observaciones ?? this.observaciones,
      fotoRutaLocal: fotoRutaLocal ?? this.fotoRutaLocal,
    );
  }
}

class RecepcionRepository {
  const RecepcionRepository(this._db);

  final AppDatabase _db;

  /// Catálogo de equipo de la caseta. Está asignado al **sitio**, no al
  /// elemento: la misma escopeta la usan ambos turnos.
  Future<List<LocalCatalogoEquipoData>> catalogoDelSitio(String sitioId) {
    return (_db.select(_db.localCatalogoEquipo)
          ..where((t) => t.sitioId.equals(sitioId) & t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
        .get();
  }

  /// Recepciones recientes del sitio, para consultar qué reportó el turno
  /// anterior.
  Stream<List<LocalRecepcionesTurnoData>> observarRecientes(
    String sitioId, {
    int limite = 30,
  }) {
    return (_db.select(_db.localRecepcionesTurno)
          ..where((t) => t.sitioId.equals(sitioId))
          ..orderBy([(t) => OrderingTerm.desc(t.aceptadoAt)])
          ..limit(limite))
        .watch();
  }

  Stream<List<LocalRecepcionItem>> observarPartidas(String recepcionLocalId) {
    return (_db.select(_db.localRecepcionItems)
          ..where((t) => t.recepcionLocalId.equals(recepcionLocalId)))
        .watch();
  }

  /// ¿Ya se recibió el turno de esta fecha? Evita duplicar la revisión.
  Future<LocalRecepcionesTurnoData?> recepcionDelTurno({
    required String sitioId,
    required DateTime turnoFecha,
    required String recibeId,
  }) {
    return (_db.select(_db.localRecepcionesTurno)
          ..where((t) =>
              t.sitioId.equals(sitioId) &
              t.turnoFecha.equals(turnoFecha) &
              t.recibeId.equals(recibeId))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Guarda la recepción con su detalle.
  ///
  /// Si alguna partida no está en perfectas condiciones, o si el elemento no
  /// acepta de conformidad, el servidor dispara la alerta al administrador.
  /// **El turno no se bloquea** — la operación sigue y la alerta viaja aparte.
  Future<String> guardar({
    required String sitioId,
    required DateTime turnoFecha,
    required String recibeId,
    required bool aceptaConformidad,
    required List<PartidaRevisada> partidas,
    String? entregaId,
    String observaciones = '',
  }) async {
    final deviceId = await DeviceService.instancia.deviceId();

    return _db.transaction(() async {
      final recepcion = await _db.into(_db.localRecepcionesTurno).insertReturning(
            LocalRecepcionesTurnoCompanion.insert(
              sitioId: sitioId,
              turnoFecha: turnoFecha,
              recibeId: recibeId,
              aceptaConformidad: aceptaConformidad,
              aceptadoAt: DateTime.now(),
              deviceId: Value(deviceId),
              entregaId: Value(entregaId),
              observaciones: Value(observaciones),
            ),
          );

      for (final p in partidas) {
        await _db.into(_db.localRecepcionItems).insert(
              LocalRecepcionItemsCompanion.insert(
                recepcionLocalId: recepcion.localId,
                equipoId: p.equipoId,
                estado: p.estado.valor,
                deviceId: Value(deviceId),
                cantidadEncontrada: Value(p.cantidadEncontrada),
                observaciones: Value(p.observaciones),
                fotoRutaLocal: Value(p.fotoRutaLocal),
              ),
            );
      }

      return recepcion.localId;
    });
  }

  /// Personal que puede figurar como quien entrega el turno.
  Future<List<LocalProfile>> elementosDisponibles() {
    return (_db.select(_db.localProfiles)
          ..where((t) =>
              t.activo.equals(true) &
              (t.rol.equals('elemento') | t.rol.equals('supervisor')))
          ..orderBy([(t) => OrderingTerm.asc(t.nombreCompleto)]))
        .get();
  }
}
