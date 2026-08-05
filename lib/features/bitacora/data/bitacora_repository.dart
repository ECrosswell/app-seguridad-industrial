import 'package:drift/drift.dart';

import '../../../core/constants/enums.dart';
import '../../../core/services/device_service.dart';
import '../../../data/local/app_database.dart';

class BitacoraRepository {
  const BitacoraRepository(this._db);

  final AppDatabase _db;

  /// Eventos del turno en curso. La bitácora "se cierra" por turno, pero las
  /// filas se conservan: el histórico se consulta por rango de fechas.
  Stream<List<LocalBitacoraEvento>> observarDelTurno(
    String sitioId,
    DateTime turnoFecha,
  ) {
    return (_db.select(_db.localBitacoraEventos)
          ..where((t) =>
              t.sitioId.equals(sitioId) & t.turnoFecha.equals(turnoFecha))
          ..orderBy([(t) => OrderingTerm.desc(t.ocurridoAt)]))
        .watch();
  }

  /// Histórico completo del sitio.
  Stream<List<LocalBitacoraEvento>> observarHistorial(
    String sitioId, {
    int limite = 200,
  }) {
    return (_db.select(_db.localBitacoraEventos)
          ..where((t) => t.sitioId.equals(sitioId))
          ..orderBy([(t) => OrderingTerm.desc(t.ocurridoAt)])
          ..limit(limite))
        .watch();
  }

  /// Pendientes que cruzan de turno: fallas e incidentes sin resolver. Es lo
  /// que el elemento entrante tiene que saber al recibir.
  Stream<List<LocalBitacoraEvento>> observarPendientes(String sitioId) {
    return (_db.select(_db.localBitacoraEventos)
          ..where((t) =>
              t.sitioId.equals(sitioId) & t.requiereSeguimiento.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.ocurridoAt)]))
        .watch();
  }

  Future<String> registrarEvento({
    required String sitioId,
    required String registradoPor,
    required DateTime turnoFecha,
    required TipoEventoBitacora tipo,
    required String descripcion,
    String placas = '',
    String transportista = '',
    String empresaTransporte = '',
    String numDocumento = '',
    String destino = '',
    String? autorizadoPorId,
    String autorizadoPorTexto = '',
    Prioridad prioridad = Prioridad.normal,
    List<String> fotosRutasLocales = const [],
  }) async {
    final deviceId = await DeviceService.instancia.deviceId();

    final creado = await _db.into(_db.localBitacoraEventos).insertReturning(
          LocalBitacoraEventosCompanion.insert(
            sitioId: sitioId,
            registradoPor: registradoPor,
            turnoFecha: turnoFecha,
            tipo: tipo.valor,
            ocurridoAt: DateTime.now(),
            descripcion: descripcion,
            deviceId: Value(deviceId),
            placas: Value(placas.toUpperCase().trim()),
            transportista: Value(transportista),
            empresaTransporte: Value(empresaTransporte),
            numDocumento: Value(numDocumento),
            destino: Value(destino),
            autorizadoPorId: Value(autorizadoPorId),
            autorizadoPorTexto: Value(autorizadoPorTexto),
            prioridad: Value(prioridad.valor),
            // Fallas e incidentes arrastran seguimiento por defecto. El servidor
            // hace lo mismo; se replica aquí para que la lista local lo refleje
            // antes de sincronizar.
            requiereSeguimiento: Value(tipo.abrePendiente),
          ),
        );

    // Cada foto va en su propia fila para que el motor las suba por separado:
    // si falla la tercera, las dos primeras no se vuelven a subir.
    for (var i = 0; i < fotosRutasLocales.length; i++) {
      await _db.into(_db.localBitacoraFotos).insert(
            LocalBitacoraFotosCompanion.insert(
              eventoLocalId: creado.localId,
              deviceId: Value(deviceId),
              rutaLocal: Value(fotosRutasLocales[i]),
              orden: Value(i),
            ),
          );
    }

    return creado.localId;
  }

  Stream<List<LocalBitacoraFoto>> observarFotos(String eventoLocalId) {
    return (_db.select(_db.localBitacoraFotos)
          ..where((t) => t.eventoLocalId.equals(eventoLocalId))
          ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
        .watch();
  }

  /// Marca un pendiente como resuelto.
  Future<void> resolver(String localId) async {
    await (_db.update(_db.localBitacoraEventos)
          ..where((t) => t.localId.equals(localId)))
        .write(LocalBitacoraEventosCompanion(
      requiereSeguimiento: const Value(false),
      syncStatus: const Value('pendiente'),
      syncIntentos: const Value(0),
      updatedAtLocal: Value(DateTime.now()),
    ));
  }
}
