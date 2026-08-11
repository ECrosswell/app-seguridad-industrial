/// Modelos de lectura de la consola de rondines.
///
/// Las escrituras sensibles (crear, actualizar o rotar un QR) pasan por una
/// Edge Function. Estos modelos sólo traducen las filas que RLS permite ver.
class SeccionRondin {
  const SeccionRondin({
    required this.id,
    required this.sitioId,
    required this.nombre,
    this.descripcion = '',
    this.activo = true,
  });

  final String id;
  final String sitioId;
  final String nombre;
  final String descripcion;
  final bool activo;

  factory SeccionRondin.desdeJson(Map<String, dynamic> json) {
    return SeccionRondin(
      id: json['id'] as String,
      sitioId: json['sitio_id'] as String,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      activo: json['activo'] as bool? ?? true,
    );
  }
}

class PuntoRondin {
  const PuntoRondin({
    required this.id,
    required this.sitioId,
    required this.seccionId,
    required this.nombre,
    this.descripcion = '',
    this.lat,
    this.lng,
    this.radioMetros = 30,
    this.wifiApId,
    this.bssid = '',
    this.wifiNombre = '',
    this.requiereLiveness = false,
    this.activo = true,
    this.qrVersion = 1,
    this.orden = 1,
    this.segundosMinimosDesdeAnterior = 0,
    this.sitioNombre = '',
    this.seccionNombre = '',
  });

  final String id;
  final String sitioId;
  final String seccionId;
  final String nombre;
  final String descripcion;
  final double? lat;
  final double? lng;
  final int radioMetros;
  final String? wifiApId;
  final String bssid;
  final String wifiNombre;
  final bool requiereLiveness;
  final bool activo;
  final int qrVersion;
  final int orden;
  final int segundosMinimosDesdeAnterior;
  final String sitioNombre;
  final String seccionNombre;

  int get minutosMinimosDesdeAnterior =>
      (segundosMinimosDesdeAnterior / 60).ceil();

  PuntoRondin conContextoDe(PuntoRondin contexto) {
    return PuntoRondin(
      id: id,
      sitioId: sitioId,
      seccionId: seccionId,
      nombre: nombre,
      descripcion: descripcion,
      lat: lat,
      lng: lng,
      radioMetros: radioMetros,
      wifiApId: wifiApId,
      bssid: bssid.isEmpty ? contexto.bssid : bssid,
      wifiNombre: wifiNombre.isEmpty ? contexto.wifiNombre : wifiNombre,
      requiereLiveness: requiereLiveness,
      activo: activo,
      qrVersion: qrVersion,
      orden: orden,
      segundosMinimosDesdeAnterior: segundosMinimosDesdeAnterior,
      sitioNombre: sitioNombre.isEmpty ? contexto.sitioNombre : sitioNombre,
      seccionNombre: seccionNombre.isEmpty
          ? contexto.seccionNombre
          : seccionNombre,
    );
  }

  factory PuntoRondin.desdeJson(Map<String, dynamic> json) {
    final paso = _primerMapa(json['ruta_rondin_puntos']);
    final wifi = _mapa(json['sitio_wifi_aps']);
    final sitio = _mapa(json['sitios']);
    final seccion = _mapa(json['secciones_sitio']);

    return PuntoRondin(
      id: json['id'] as String,
      sitioId: json['sitio_id'] as String,
      seccionId: json['seccion_id'] as String,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      lat: _double(json['lat']),
      lng: _double(json['lng']),
      radioMetros: _entero(json['radio_metros']) ?? 30,
      wifiApId: json['wifi_ap_id'] as String?,
      bssid: wifi?['bssid'] as String? ?? '',
      wifiNombre: [wifi?['ssid'], wifi?['nombre_zona']]
          .whereType<String>()
          .where((valor) => valor.trim().isNotEmpty)
          .join(' · '),
      requiereLiveness: json['requiere_liveness'] as bool? ?? false,
      activo: json['activo'] as bool? ?? true,
      qrVersion: _entero(json['qr_version'] ?? json['token_version']) ?? 1,
      orden: _entero(json['orden'] ?? paso?['orden']) ?? 1,
      segundosMinimosDesdeAnterior:
          _entero(
            json['segundos_minimos_desde_anterior'] ??
                paso?['segundos_minimos_desde_anterior'],
          ) ??
          0,
      sitioNombre: sitio?['nombre'] as String? ?? '',
      seccionNombre: seccion?['nombre'] as String? ?? '',
    );
  }
}

class ResultadoRondin {
  const ResultadoRondin({
    required this.id,
    required this.usuarioId,
    required this.sitioId,
    required this.estadoValidacion,
    required this.iniciadoAt,
    this.finalizadoAt,
    this.usuarioNombre = '',
    this.sitioNombre = '',
    this.rutaNombre = '',
    this.puntajeRiesgo = 0,
    this.puntosEsperados = 0,
    this.puntosRecibidos = 0,
    this.codigosRiesgo = const [],
    this.lecturas = const [],
    this.revisionAdministrativa,
  });

  final String id;
  final String usuarioId;
  final String sitioId;
  final String usuarioNombre;
  final String sitioNombre;
  final String rutaNombre;
  final String estadoValidacion;
  final int puntajeRiesgo;
  final int puntosEsperados;
  final int puntosRecibidos;
  final List<String> codigosRiesgo;
  final DateTime iniciadoAt;
  final DateTime? finalizadoAt;
  final List<LecturaResultadoRondin> lecturas;
  final RevisionRondin? revisionAdministrativa;

  int get lecturasValidas => lecturas
      .where((lectura) => lectura.estadoValidacion == 'validado')
      .length;

  int get lecturasConAlerta => lecturas
      .where((lectura) => lectura.estadoValidacion != 'validado')
      .length;

  factory ResultadoRondin.desdeJson(Map<String, dynamic> json) {
    final perfil = _mapa(json['profiles']);
    final sitio = _mapa(json['sitios']);
    final ruta = _mapa(json['rutas_rondin']);
    final lecturasJson = json['rondin_lecturas'];
    final revisionesJson = json['rondin_revisiones'];
    final revisiones = revisionesJson is List
        ? revisionesJson
              .whereType<Map>()
              .map(
                (fila) =>
                    RevisionRondin.desdeJson(Map<String, dynamic>.from(fila)),
              )
              .toList()
        : <RevisionRondin>[];
    revisiones.sort((a, b) {
      final porFecha = a.createdAt.compareTo(b.createdAt);
      return porFecha != 0 ? porFecha : a.id.compareTo(b.id);
    });

    return ResultadoRondin(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String? ?? '',
      sitioId: json['sitio_id'] as String? ?? '',
      usuarioNombre: perfil?['nombre_completo'] as String? ?? '',
      sitioNombre: sitio?['nombre'] as String? ?? '',
      rutaNombre: ruta?['nombre'] as String? ?? '',
      estadoValidacion:
          json['estado_validacion'] as String? ?? 'pendiente_revision',
      puntajeRiesgo: _entero(json['puntaje_riesgo']) ?? 0,
      puntosEsperados: _entero(json['puntos_esperados']) ?? 0,
      puntosRecibidos: _entero(json['puntos_recibidos']) ?? 0,
      codigosRiesgo: _listaTexto(json['codigos_riesgo']),
      iniciadoAt: _fecha(json['iniciado_at_dispositivo'] ?? json['created_at']),
      finalizadoAt: _fechaOpcional(json['finalizado_at_dispositivo']),
      lecturas: lecturasJson is List
          ? lecturasJson
                .whereType<Map>()
                .map(
                  (fila) => LecturaResultadoRondin.desdeJson(
                    Map<String, dynamic>.from(fila),
                  ),
                )
                .toList()
          : const [],
      revisionAdministrativa: revisiones.isEmpty ? null : revisiones.last,
    );
  }
}

class RevisionRondin {
  const RevisionRondin({
    required this.id,
    required this.rondinId,
    required this.actorId,
    required this.decision,
    required this.createdAt,
    this.motivo = '',
    this.actorNombre = '',
  });

  final String id;
  final String rondinId;
  final String actorId;
  final String actorNombre;
  final String decision;
  final String motivo;
  final DateTime createdAt;

  factory RevisionRondin.desdeJson(Map<String, dynamic> json) {
    final actor = _mapa(json['profiles']);
    return RevisionRondin(
      id: json['id'] as String,
      rondinId: json['rondin_id'] as String? ?? '',
      actorId: json['actor_id'] as String? ?? '',
      actorNombre: actor?['nombre_completo'] as String? ?? '',
      decision: json['decision'] as String? ?? '',
      motivo: json['motivo'] as String? ?? '',
      createdAt: _fecha(json['created_at']),
    );
  }
}

class LecturaResultadoRondin {
  const LecturaResultadoRondin({
    required this.id,
    required this.puntoNombre,
    required this.estadoValidacion,
    required this.capturadoAt,
    this.seccionNombre = '',
    this.secuencia = 0,
    this.puntajeRiesgo = 0,
    this.codigosRiesgo = const [],
    this.distanciaPuntoM,
    this.wifiReconocido = false,
    this.qrValido = false,
    this.gpsIsMocked = false,
    this.gpsAccuracyM,
  });

  final String id;
  final String puntoNombre;
  final String seccionNombre;
  final int secuencia;
  final String estadoValidacion;
  final int puntajeRiesgo;
  final List<String> codigosRiesgo;
  final DateTime capturadoAt;
  final double? distanciaPuntoM;
  final bool wifiReconocido;
  final bool qrValido;
  final bool gpsIsMocked;
  final double? gpsAccuracyM;

  factory LecturaResultadoRondin.desdeJson(Map<String, dynamic> json) {
    final punto = _mapa(json['puntos_rondin']);
    final seccion = punto == null ? null : _mapa(punto['secciones_sitio']);

    return LecturaResultadoRondin(
      id: json['id'] as String,
      puntoNombre: punto?['nombre'] as String? ?? 'Punto sin nombre',
      seccionNombre: seccion?['nombre'] as String? ?? '',
      secuencia: _entero(json['secuencia']) ?? 0,
      estadoValidacion:
          json['estado_validacion'] as String? ?? 'pendiente_revision',
      puntajeRiesgo: _entero(json['puntaje_riesgo']) ?? 0,
      codigosRiesgo: _listaTexto(json['codigos_riesgo']),
      capturadoAt: _fecha(
        json['capturado_at_dispositivo'] ?? json['created_at'],
      ),
      distanciaPuntoM: _double(json['distancia_punto_m']),
      wifiReconocido: json['wifi_reconocido'] as bool? ?? false,
      qrValido: json['qr_valido'] as bool? ?? false,
      gpsIsMocked: json['gps_is_mocked'] as bool? ?? false,
      gpsAccuracyM: _double(json['gps_accuracy_m']),
    );
  }
}

class CodigoQrPuntoRondin {
  const CodigoQrPuntoRondin({required this.punto, required this.payload});

  final PuntoRondin punto;
  final String payload;
}

class RespuestaPuntoRondin {
  const RespuestaPuntoRondin({required this.punto, this.qrPayload});

  final PuntoRondin punto;
  final String? qrPayload;
}

Map<String, dynamic>? _mapa(Object? valor) {
  if (valor is Map) return Map<String, dynamic>.from(valor);
  return null;
}

Map<String, dynamic>? _primerMapa(Object? valor) {
  if (valor is List && valor.isNotEmpty) return _mapa(valor.first);
  return _mapa(valor);
}

int? _entero(Object? valor) {
  if (valor is int) return valor;
  if (valor is num) return valor.toInt();
  return int.tryParse(valor?.toString() ?? '');
}

double? _double(Object? valor) {
  if (valor is num) return valor.toDouble();
  return double.tryParse(valor?.toString() ?? '');
}

DateTime _fecha(Object? valor) {
  return _fechaOpcional(valor)?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime? _fechaOpcional(Object? valor) {
  if (valor is DateTime) return valor;
  if (valor is String) return DateTime.tryParse(valor);
  return null;
}

List<String> _listaTexto(Object? valor) {
  if (valor is! List) return const [];
  return valor.map((item) => item.toString()).toList(growable: false);
}
