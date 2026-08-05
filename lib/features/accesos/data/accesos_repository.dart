import 'package:drift/drift.dart';

import '../../../core/services/device_service.dart';
import '../../../data/local/app_database.dart';

/// Escrituras y consultas de control de acceso contra la base local.
class AccesosRepository {
  const AccesosRepository(this._db);

  final AppDatabase _db;

  /// Visitantes dentro de la planta ahora mismo (sin hora de salida).
  ///
  /// Es la pantalla que más se usa: el elemento la abre para dar salida con un
  /// toque cuando alguien se va.
  Stream<List<LocalRegistrosAccesoData>> observarDentro(String sitioId) {
    return (_db.select(_db.localRegistrosAcceso)
          ..where((t) => t.sitioId.equals(sitioId) & t.horaSalida.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.horaEntrada)]))
        .watch();
  }

  /// Historial del turno, ya con salida registrada.
  Stream<List<LocalRegistrosAccesoData>> observarHistorial(
    String sitioId, {
    int limite = 100,
  }) {
    return (_db.select(_db.localRegistrosAcceso)
          ..where((t) => t.sitioId.equals(sitioId) & t.horaSalida.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.horaSalida)])
          ..limit(limite))
        .watch();
  }

  Future<String> registrarEntrada({
    required String sitioId,
    required String registradoPor,
    required String nombreCompleto,
    required String asunto,
    String empresaProcedencia = '',
    String telefono = '',
    String? personaVisitadaId,
    String personaVisitadaTexto = '',
    bool ingresaVehiculo = false,
    String placas = '',
    String vehiculoMarca = '',
    String vehiculoModelo = '',
    String vehiculoColor = '',
    String identificacionTipo = '',
    String? identificacionRutaLocal,
    String? avisoPrivacidadId,
    bool avisoAceptado = false,
    String? visitanteLocalId,
    String observaciones = '',
  }) async {
    final deviceId = await DeviceService.instancia.deviceId();

    final creada = await _db.into(_db.localRegistrosAcceso).insertReturning(
          LocalRegistrosAccesoCompanion.insert(
            sitioId: sitioId,
            registradoPor: registradoPor,
            nombreCompleto: nombreCompleto,
            asunto: asunto,
            horaEntrada: DateTime.now(),
            deviceId: Value(deviceId),
            empresaProcedencia: Value(empresaProcedencia),
            telefono: Value(telefono),
            personaVisitadaId: Value(personaVisitadaId),
            personaVisitadaTexto: Value(personaVisitadaTexto),
            ingresaVehiculo: Value(ingresaVehiculo),
            placas: Value(placas.toUpperCase().trim()),
            vehiculoMarca: Value(vehiculoMarca),
            vehiculoModelo: Value(vehiculoModelo),
            vehiculoColor: Value(vehiculoColor),
            identificacionTipo: Value(identificacionTipo),
            identificacionRutaLocal: Value(identificacionRutaLocal),
            avisoPrivacidadId: Value(avisoPrivacidadId),
            avisoAceptado: Value(avisoAceptado),
            avisoAceptadoAt: Value(avisoAceptado ? DateTime.now() : null),
            visitanteLocalId: Value(visitanteLocalId),
            observaciones: Value(observaciones),
          ),
        );

    return creada.localId;
  }

  /// Registra la salida. Vuelve a marcar la fila como pendiente para que el
  /// motor la re-suba con la hora de salida: el upsert va contra `local_id`,
  /// así que actualiza en lugar de duplicar.
  Future<void> registrarSalida({
    required String localId,
    required String salidaRegistradaPor,
  }) async {
    await (_db.update(_db.localRegistrosAcceso)
          ..where((t) => t.localId.equals(localId)))
        .write(LocalRegistrosAccesoCompanion(
      horaSalida: Value(DateTime.now()),
      salidaRegistradaPor: Value(salidaRegistradaPor),
      syncStatus: const Value('pendiente'),
      syncIntentos: const Value(0),
      updatedAtLocal: Value(DateTime.now()),
    ));
  }

  /// Alta de un visitante recurrente para no recapturar sus datos cada visita.
  Future<String> guardarVisitanteFrecuente({
    required String nombreCompleto,
    String empresa = '',
    String telefono = '',
    String placasHabituales = '',
  }) async {
    final deviceId = await DeviceService.instancia.deviceId();

    final creado = await _db.into(_db.localVisitantes).insertReturning(
          LocalVisitantesCompanion.insert(
            nombreCompleto: nombreCompleto,
            deviceId: Value(deviceId),
            empresa: Value(empresa),
            telefono: Value(telefono),
            placasHabituales: Value(placasHabituales.toUpperCase().trim()),
          ),
        );

    return creado.localId;
  }

  /// Busca entre los visitantes recurrentes para precargar el formulario.
  Future<List<LocalVisitante>> buscarVisitantes(String texto) async {
    if (texto.trim().length < 2) return const [];
    final patron = '%${texto.trim().toLowerCase()}%';

    return (_db.select(_db.localVisitantes)
          ..where((t) =>
              t.nombreCompleto.lower().like(patron) |
              t.empresa.lower().like(patron) |
              t.placasHabituales.lower().like(patron))
          ..limit(10))
        .get();
  }

  /// Catálogo de personal de la fábrica al que se puede visitar. Lo mantiene el
  /// cliente; mientras esté vacío el formulario cae al campo de texto libre.
  Future<List<LocalPersonalClienteData>> personalDelSitio(String sitioId) {
    return (_db.select(_db.localPersonalCliente)
          ..where((t) => t.sitioId.equals(sitioId) & t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nombreCompleto)]))
        .get();
  }

  /// Aviso de privacidad vigente que se le muestra al visitante.
  Future<LocalAvisosPrivacidadData?> avisoVigente() {
    return (_db.select(_db.localAvisosPrivacidad)
          ..where((t) => t.activo.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }
}
