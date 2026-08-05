// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalAsistenciasTable extends LocalAsistencias
    with TableInfo<$LocalAsistenciasTable, LocalAsistencia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAsistenciasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncIntentosMeta = const VerificationMeta(
    'syncIntentos',
  );
  @override
  late final GeneratedColumn<int> syncIntentos = GeneratedColumn<int>(
    'sync_intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtLocalMeta = const VerificationMeta(
    'createdAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>(
        'created_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sitioIdMeta = const VerificationMeta(
    'sitioId',
  );
  @override
  late final GeneratedColumn<String> sitioId = GeneratedColumn<String>(
    'sitio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnoFechaMeta = const VerificationMeta(
    'turnoFecha',
  );
  @override
  late final GeneratedColumn<DateTime> turnoFecha = GeneratedColumn<DateTime>(
    'turno_fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoEventoMeta = const VerificationMeta(
    'tipoEvento',
  );
  @override
  late final GeneratedColumn<String> tipoEvento = GeneratedColumn<String>(
    'tipo_evento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ocurridoAtMeta = const VerificationMeta(
    'ocurridoAt',
  );
  @override
  late final GeneratedColumn<DateTime> ocurridoAt = GeneratedColumn<DateTime>(
    'ocurrido_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpsAccuracyMMeta = const VerificationMeta(
    'gpsAccuracyM',
  );
  @override
  late final GeneratedColumn<double> gpsAccuracyM = GeneratedColumn<double>(
    'gps_accuracy_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wifiBssidMeta = const VerificationMeta(
    'wifiBssid',
  );
  @override
  late final GeneratedColumn<String> wifiBssid = GeneratedColumn<String>(
    'wifi_bssid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wifiSsidMeta = const VerificationMeta(
    'wifiSsid',
  );
  @override
  late final GeneratedColumn<String> wifiSsid = GeneratedColumn<String>(
    'wifi_ssid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selfieRutaLocalMeta = const VerificationMeta(
    'selfieRutaLocal',
  );
  @override
  late final GeneratedColumn<String> selfieRutaLocal = GeneratedColumn<String>(
    'selfie_ruta_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selfieUrlMeta = const VerificationMeta(
    'selfieUrl',
  );
  @override
  late final GeneratedColumn<String> selfieUrl = GeneratedColumn<String>(
    'selfie_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _livenessPassedMeta = const VerificationMeta(
    'livenessPassed',
  );
  @override
  late final GeneratedColumn<bool> livenessPassed = GeneratedColumn<bool>(
    'liveness_passed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("liveness_passed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clasificacionServidorMeta =
      const VerificationMeta('clasificacionServidor');
  @override
  late final GeneratedColumn<String> clasificacionServidor =
      GeneratedColumn<String>(
        'clasificacion_servidor',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _minutosRetardoServidorMeta =
      const VerificationMeta('minutosRetardoServidor');
  @override
  late final GeneratedColumn<int> minutosRetardoServidor = GeneratedColumn<int>(
    'minutos_retardo_servidor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoValidacionServidorMeta =
      const VerificationMeta('estadoValidacionServidor');
  @override
  late final GeneratedColumn<String> estadoValidacionServidor =
      GeneratedColumn<String>(
        'estado_validacion_servidor',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    usuarioId,
    sitioId,
    turnoFecha,
    tipoEvento,
    ocurridoAt,
    lat,
    lng,
    gpsAccuracyM,
    wifiBssid,
    wifiSsid,
    selfieRutaLocal,
    selfieUrl,
    livenessPassed,
    observaciones,
    clasificacionServidor,
    minutosRetardoServidor,
    estadoValidacionServidor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_asistencias';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAsistencia> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('sync_intentos')) {
      context.handle(
        _syncIntentosMeta,
        syncIntentos.isAcceptableOrUnknown(
          data['sync_intentos']!,
          _syncIntentosMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
        _createdAtLocalMeta,
        createdAtLocal.isAcceptableOrUnknown(
          data['created_at_local']!,
          _createdAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('sitio_id')) {
      context.handle(
        _sitioIdMeta,
        sitioId.isAcceptableOrUnknown(data['sitio_id']!, _sitioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sitioIdMeta);
    }
    if (data.containsKey('turno_fecha')) {
      context.handle(
        _turnoFechaMeta,
        turnoFecha.isAcceptableOrUnknown(data['turno_fecha']!, _turnoFechaMeta),
      );
    } else if (isInserting) {
      context.missing(_turnoFechaMeta);
    }
    if (data.containsKey('tipo_evento')) {
      context.handle(
        _tipoEventoMeta,
        tipoEvento.isAcceptableOrUnknown(data['tipo_evento']!, _tipoEventoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoEventoMeta);
    }
    if (data.containsKey('ocurrido_at')) {
      context.handle(
        _ocurridoAtMeta,
        ocurridoAt.isAcceptableOrUnknown(data['ocurrido_at']!, _ocurridoAtMeta),
      );
    } else if (isInserting) {
      context.missing(_ocurridoAtMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('gps_accuracy_m')) {
      context.handle(
        _gpsAccuracyMMeta,
        gpsAccuracyM.isAcceptableOrUnknown(
          data['gps_accuracy_m']!,
          _gpsAccuracyMMeta,
        ),
      );
    }
    if (data.containsKey('wifi_bssid')) {
      context.handle(
        _wifiBssidMeta,
        wifiBssid.isAcceptableOrUnknown(data['wifi_bssid']!, _wifiBssidMeta),
      );
    }
    if (data.containsKey('wifi_ssid')) {
      context.handle(
        _wifiSsidMeta,
        wifiSsid.isAcceptableOrUnknown(data['wifi_ssid']!, _wifiSsidMeta),
      );
    }
    if (data.containsKey('selfie_ruta_local')) {
      context.handle(
        _selfieRutaLocalMeta,
        selfieRutaLocal.isAcceptableOrUnknown(
          data['selfie_ruta_local']!,
          _selfieRutaLocalMeta,
        ),
      );
    }
    if (data.containsKey('selfie_url')) {
      context.handle(
        _selfieUrlMeta,
        selfieUrl.isAcceptableOrUnknown(data['selfie_url']!, _selfieUrlMeta),
      );
    }
    if (data.containsKey('liveness_passed')) {
      context.handle(
        _livenessPassedMeta,
        livenessPassed.isAcceptableOrUnknown(
          data['liveness_passed']!,
          _livenessPassedMeta,
        ),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('clasificacion_servidor')) {
      context.handle(
        _clasificacionServidorMeta,
        clasificacionServidor.isAcceptableOrUnknown(
          data['clasificacion_servidor']!,
          _clasificacionServidorMeta,
        ),
      );
    }
    if (data.containsKey('minutos_retardo_servidor')) {
      context.handle(
        _minutosRetardoServidorMeta,
        minutosRetardoServidor.isAcceptableOrUnknown(
          data['minutos_retardo_servidor']!,
          _minutosRetardoServidorMeta,
        ),
      );
    }
    if (data.containsKey('estado_validacion_servidor')) {
      context.handle(
        _estadoValidacionServidorMeta,
        estadoValidacionServidor.isAcceptableOrUnknown(
          data['estado_validacion_servidor']!,
          _estadoValidacionServidorMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalAsistencia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAsistencia(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      )!,
      syncIntentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_intentos'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      sitioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sitio_id'],
      )!,
      turnoFecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}turno_fecha'],
      )!,
      tipoEvento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_evento'],
      )!,
      ocurridoAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ocurrido_at'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      gpsAccuracyM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gps_accuracy_m'],
      ),
      wifiBssid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wifi_bssid'],
      ),
      wifiSsid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wifi_ssid'],
      ),
      selfieRutaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selfie_ruta_local'],
      ),
      selfieUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selfie_url'],
      ),
      livenessPassed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}liveness_passed'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      )!,
      clasificacionServidor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clasificacion_servidor'],
      ),
      minutosRetardoServidor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutos_retardo_servidor'],
      ),
      estadoValidacionServidor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado_validacion_servidor'],
      ),
    );
  }

  @override
  $LocalAsistenciasTable createAlias(String alias) {
    return $LocalAsistenciasTable(attachedDatabase, alias);
  }
}

class LocalAsistencia extends DataClass implements Insertable<LocalAsistencia> {
  final String localId;

  /// UUID que asignó Supabase. Nulo mientras no se haya sincronizado.
  final String? remoteId;

  /// pendiente | sincronizando | sincronizado | fallido
  final String syncStatus;
  final String syncError;

  /// Se pausan los reintentos al llegar al máximo para no quemar batería
  /// reintentando algo que falla por una razón que no se va a resolver sola
  /// (por ejemplo, violar un CHECK del servidor).
  final int syncIntentos;
  final String deviceId;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? syncedAt;
  final String usuarioId;
  final String sitioId;
  final DateTime turnoFecha;
  final String tipoEvento;
  final DateTime ocurridoAt;
  final double? lat;
  final double? lng;
  final double? gpsAccuracyM;
  final String? wifiBssid;
  final String? wifiSsid;

  /// Ruta del archivo en el dispositivo. El motor la sube a Storage y llena
  /// [selfieUrl] antes de empujar la fila.
  final String? selfieRutaLocal;
  final String? selfieUrl;
  final bool livenessPassed;
  final String observaciones;

  /// Lo que respondió el servidor. Se guarda para poder mostrarle al elemento
  /// si su registro quedó como retardo sin tener que volver a consultar.
  final String? clasificacionServidor;
  final int? minutosRetardoServidor;
  final String? estadoValidacionServidor;
  const LocalAsistencia({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.syncError,
    required this.syncIntentos,
    required this.deviceId,
    required this.createdAtLocal,
    required this.updatedAtLocal,
    this.syncedAt,
    required this.usuarioId,
    required this.sitioId,
    required this.turnoFecha,
    required this.tipoEvento,
    required this.ocurridoAt,
    this.lat,
    this.lng,
    this.gpsAccuracyM,
    this.wifiBssid,
    this.wifiSsid,
    this.selfieRutaLocal,
    this.selfieUrl,
    required this.livenessPassed,
    required this.observaciones,
    this.clasificacionServidor,
    this.minutosRetardoServidor,
    this.estadoValidacionServidor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_error'] = Variable<String>(syncError);
    map['sync_intentos'] = Variable<int>(syncIntentos);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    map['sitio_id'] = Variable<String>(sitioId);
    map['turno_fecha'] = Variable<DateTime>(turnoFecha);
    map['tipo_evento'] = Variable<String>(tipoEvento);
    map['ocurrido_at'] = Variable<DateTime>(ocurridoAt);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || gpsAccuracyM != null) {
      map['gps_accuracy_m'] = Variable<double>(gpsAccuracyM);
    }
    if (!nullToAbsent || wifiBssid != null) {
      map['wifi_bssid'] = Variable<String>(wifiBssid);
    }
    if (!nullToAbsent || wifiSsid != null) {
      map['wifi_ssid'] = Variable<String>(wifiSsid);
    }
    if (!nullToAbsent || selfieRutaLocal != null) {
      map['selfie_ruta_local'] = Variable<String>(selfieRutaLocal);
    }
    if (!nullToAbsent || selfieUrl != null) {
      map['selfie_url'] = Variable<String>(selfieUrl);
    }
    map['liveness_passed'] = Variable<bool>(livenessPassed);
    map['observaciones'] = Variable<String>(observaciones);
    if (!nullToAbsent || clasificacionServidor != null) {
      map['clasificacion_servidor'] = Variable<String>(clasificacionServidor);
    }
    if (!nullToAbsent || minutosRetardoServidor != null) {
      map['minutos_retardo_servidor'] = Variable<int>(minutosRetardoServidor);
    }
    if (!nullToAbsent || estadoValidacionServidor != null) {
      map['estado_validacion_servidor'] = Variable<String>(
        estadoValidacionServidor,
      );
    }
    return map;
  }

  LocalAsistenciasCompanion toCompanion(bool nullToAbsent) {
    return LocalAsistenciasCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      syncError: Value(syncError),
      syncIntentos: Value(syncIntentos),
      deviceId: Value(deviceId),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      usuarioId: Value(usuarioId),
      sitioId: Value(sitioId),
      turnoFecha: Value(turnoFecha),
      tipoEvento: Value(tipoEvento),
      ocurridoAt: Value(ocurridoAt),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      gpsAccuracyM: gpsAccuracyM == null && nullToAbsent
          ? const Value.absent()
          : Value(gpsAccuracyM),
      wifiBssid: wifiBssid == null && nullToAbsent
          ? const Value.absent()
          : Value(wifiBssid),
      wifiSsid: wifiSsid == null && nullToAbsent
          ? const Value.absent()
          : Value(wifiSsid),
      selfieRutaLocal: selfieRutaLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(selfieRutaLocal),
      selfieUrl: selfieUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(selfieUrl),
      livenessPassed: Value(livenessPassed),
      observaciones: Value(observaciones),
      clasificacionServidor: clasificacionServidor == null && nullToAbsent
          ? const Value.absent()
          : Value(clasificacionServidor),
      minutosRetardoServidor: minutosRetardoServidor == null && nullToAbsent
          ? const Value.absent()
          : Value(minutosRetardoServidor),
      estadoValidacionServidor: estadoValidacionServidor == null && nullToAbsent
          ? const Value.absent()
          : Value(estadoValidacionServidor),
    );
  }

  factory LocalAsistencia.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAsistencia(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncError: serializer.fromJson<String>(json['syncError']),
      syncIntentos: serializer.fromJson<int>(json['syncIntentos']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAtLocal: serializer.fromJson<DateTime>(json['createdAtLocal']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updatedAtLocal']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      sitioId: serializer.fromJson<String>(json['sitioId']),
      turnoFecha: serializer.fromJson<DateTime>(json['turnoFecha']),
      tipoEvento: serializer.fromJson<String>(json['tipoEvento']),
      ocurridoAt: serializer.fromJson<DateTime>(json['ocurridoAt']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      gpsAccuracyM: serializer.fromJson<double?>(json['gpsAccuracyM']),
      wifiBssid: serializer.fromJson<String?>(json['wifiBssid']),
      wifiSsid: serializer.fromJson<String?>(json['wifiSsid']),
      selfieRutaLocal: serializer.fromJson<String?>(json['selfieRutaLocal']),
      selfieUrl: serializer.fromJson<String?>(json['selfieUrl']),
      livenessPassed: serializer.fromJson<bool>(json['livenessPassed']),
      observaciones: serializer.fromJson<String>(json['observaciones']),
      clasificacionServidor: serializer.fromJson<String?>(
        json['clasificacionServidor'],
      ),
      minutosRetardoServidor: serializer.fromJson<int?>(
        json['minutosRetardoServidor'],
      ),
      estadoValidacionServidor: serializer.fromJson<String?>(
        json['estadoValidacionServidor'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncError': serializer.toJson<String>(syncError),
      'syncIntentos': serializer.toJson<int>(syncIntentos),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAtLocal': serializer.toJson<DateTime>(createdAtLocal),
      'updatedAtLocal': serializer.toJson<DateTime>(updatedAtLocal),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'sitioId': serializer.toJson<String>(sitioId),
      'turnoFecha': serializer.toJson<DateTime>(turnoFecha),
      'tipoEvento': serializer.toJson<String>(tipoEvento),
      'ocurridoAt': serializer.toJson<DateTime>(ocurridoAt),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'gpsAccuracyM': serializer.toJson<double?>(gpsAccuracyM),
      'wifiBssid': serializer.toJson<String?>(wifiBssid),
      'wifiSsid': serializer.toJson<String?>(wifiSsid),
      'selfieRutaLocal': serializer.toJson<String?>(selfieRutaLocal),
      'selfieUrl': serializer.toJson<String?>(selfieUrl),
      'livenessPassed': serializer.toJson<bool>(livenessPassed),
      'observaciones': serializer.toJson<String>(observaciones),
      'clasificacionServidor': serializer.toJson<String?>(
        clasificacionServidor,
      ),
      'minutosRetardoServidor': serializer.toJson<int?>(minutosRetardoServidor),
      'estadoValidacionServidor': serializer.toJson<String?>(
        estadoValidacionServidor,
      ),
    };
  }

  LocalAsistencia copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    String? syncError,
    int? syncIntentos,
    String? deviceId,
    DateTime? createdAtLocal,
    DateTime? updatedAtLocal,
    Value<DateTime?> syncedAt = const Value.absent(),
    String? usuarioId,
    String? sitioId,
    DateTime? turnoFecha,
    String? tipoEvento,
    DateTime? ocurridoAt,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<double?> gpsAccuracyM = const Value.absent(),
    Value<String?> wifiBssid = const Value.absent(),
    Value<String?> wifiSsid = const Value.absent(),
    Value<String?> selfieRutaLocal = const Value.absent(),
    Value<String?> selfieUrl = const Value.absent(),
    bool? livenessPassed,
    String? observaciones,
    Value<String?> clasificacionServidor = const Value.absent(),
    Value<int?> minutosRetardoServidor = const Value.absent(),
    Value<String?> estadoValidacionServidor = const Value.absent(),
  }) => LocalAsistencia(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncError: syncError ?? this.syncError,
    syncIntentos: syncIntentos ?? this.syncIntentos,
    deviceId: deviceId ?? this.deviceId,
    createdAtLocal: createdAtLocal ?? this.createdAtLocal,
    updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    usuarioId: usuarioId ?? this.usuarioId,
    sitioId: sitioId ?? this.sitioId,
    turnoFecha: turnoFecha ?? this.turnoFecha,
    tipoEvento: tipoEvento ?? this.tipoEvento,
    ocurridoAt: ocurridoAt ?? this.ocurridoAt,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    gpsAccuracyM: gpsAccuracyM.present ? gpsAccuracyM.value : this.gpsAccuracyM,
    wifiBssid: wifiBssid.present ? wifiBssid.value : this.wifiBssid,
    wifiSsid: wifiSsid.present ? wifiSsid.value : this.wifiSsid,
    selfieRutaLocal: selfieRutaLocal.present
        ? selfieRutaLocal.value
        : this.selfieRutaLocal,
    selfieUrl: selfieUrl.present ? selfieUrl.value : this.selfieUrl,
    livenessPassed: livenessPassed ?? this.livenessPassed,
    observaciones: observaciones ?? this.observaciones,
    clasificacionServidor: clasificacionServidor.present
        ? clasificacionServidor.value
        : this.clasificacionServidor,
    minutosRetardoServidor: minutosRetardoServidor.present
        ? minutosRetardoServidor.value
        : this.minutosRetardoServidor,
    estadoValidacionServidor: estadoValidacionServidor.present
        ? estadoValidacionServidor.value
        : this.estadoValidacionServidor,
  );
  LocalAsistencia copyWithCompanion(LocalAsistenciasCompanion data) {
    return LocalAsistencia(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      syncIntentos: data.syncIntentos.present
          ? data.syncIntentos.value
          : this.syncIntentos,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      sitioId: data.sitioId.present ? data.sitioId.value : this.sitioId,
      turnoFecha: data.turnoFecha.present
          ? data.turnoFecha.value
          : this.turnoFecha,
      tipoEvento: data.tipoEvento.present
          ? data.tipoEvento.value
          : this.tipoEvento,
      ocurridoAt: data.ocurridoAt.present
          ? data.ocurridoAt.value
          : this.ocurridoAt,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      gpsAccuracyM: data.gpsAccuracyM.present
          ? data.gpsAccuracyM.value
          : this.gpsAccuracyM,
      wifiBssid: data.wifiBssid.present ? data.wifiBssid.value : this.wifiBssid,
      wifiSsid: data.wifiSsid.present ? data.wifiSsid.value : this.wifiSsid,
      selfieRutaLocal: data.selfieRutaLocal.present
          ? data.selfieRutaLocal.value
          : this.selfieRutaLocal,
      selfieUrl: data.selfieUrl.present ? data.selfieUrl.value : this.selfieUrl,
      livenessPassed: data.livenessPassed.present
          ? data.livenessPassed.value
          : this.livenessPassed,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      clasificacionServidor: data.clasificacionServidor.present
          ? data.clasificacionServidor.value
          : this.clasificacionServidor,
      minutosRetardoServidor: data.minutosRetardoServidor.present
          ? data.minutosRetardoServidor.value
          : this.minutosRetardoServidor,
      estadoValidacionServidor: data.estadoValidacionServidor.present
          ? data.estadoValidacionServidor.value
          : this.estadoValidacionServidor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAsistencia(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('sitioId: $sitioId, ')
          ..write('turnoFecha: $turnoFecha, ')
          ..write('tipoEvento: $tipoEvento, ')
          ..write('ocurridoAt: $ocurridoAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('gpsAccuracyM: $gpsAccuracyM, ')
          ..write('wifiBssid: $wifiBssid, ')
          ..write('wifiSsid: $wifiSsid, ')
          ..write('selfieRutaLocal: $selfieRutaLocal, ')
          ..write('selfieUrl: $selfieUrl, ')
          ..write('livenessPassed: $livenessPassed, ')
          ..write('observaciones: $observaciones, ')
          ..write('clasificacionServidor: $clasificacionServidor, ')
          ..write('minutosRetardoServidor: $minutosRetardoServidor, ')
          ..write('estadoValidacionServidor: $estadoValidacionServidor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    usuarioId,
    sitioId,
    turnoFecha,
    tipoEvento,
    ocurridoAt,
    lat,
    lng,
    gpsAccuracyM,
    wifiBssid,
    wifiSsid,
    selfieRutaLocal,
    selfieUrl,
    livenessPassed,
    observaciones,
    clasificacionServidor,
    minutosRetardoServidor,
    estadoValidacionServidor,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAsistencia &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.syncError == this.syncError &&
          other.syncIntentos == this.syncIntentos &&
          other.deviceId == this.deviceId &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.syncedAt == this.syncedAt &&
          other.usuarioId == this.usuarioId &&
          other.sitioId == this.sitioId &&
          other.turnoFecha == this.turnoFecha &&
          other.tipoEvento == this.tipoEvento &&
          other.ocurridoAt == this.ocurridoAt &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.gpsAccuracyM == this.gpsAccuracyM &&
          other.wifiBssid == this.wifiBssid &&
          other.wifiSsid == this.wifiSsid &&
          other.selfieRutaLocal == this.selfieRutaLocal &&
          other.selfieUrl == this.selfieUrl &&
          other.livenessPassed == this.livenessPassed &&
          other.observaciones == this.observaciones &&
          other.clasificacionServidor == this.clasificacionServidor &&
          other.minutosRetardoServidor == this.minutosRetardoServidor &&
          other.estadoValidacionServidor == this.estadoValidacionServidor);
}

class LocalAsistenciasCompanion extends UpdateCompanion<LocalAsistencia> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<String> syncError;
  final Value<int> syncIntentos;
  final Value<String> deviceId;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> syncedAt;
  final Value<String> usuarioId;
  final Value<String> sitioId;
  final Value<DateTime> turnoFecha;
  final Value<String> tipoEvento;
  final Value<DateTime> ocurridoAt;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<double?> gpsAccuracyM;
  final Value<String?> wifiBssid;
  final Value<String?> wifiSsid;
  final Value<String?> selfieRutaLocal;
  final Value<String?> selfieUrl;
  final Value<bool> livenessPassed;
  final Value<String> observaciones;
  final Value<String?> clasificacionServidor;
  final Value<int?> minutosRetardoServidor;
  final Value<String?> estadoValidacionServidor;
  final Value<int> rowid;
  const LocalAsistenciasCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.sitioId = const Value.absent(),
    this.turnoFecha = const Value.absent(),
    this.tipoEvento = const Value.absent(),
    this.ocurridoAt = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.gpsAccuracyM = const Value.absent(),
    this.wifiBssid = const Value.absent(),
    this.wifiSsid = const Value.absent(),
    this.selfieRutaLocal = const Value.absent(),
    this.selfieUrl = const Value.absent(),
    this.livenessPassed = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.clasificacionServidor = const Value.absent(),
    this.minutosRetardoServidor = const Value.absent(),
    this.estadoValidacionServidor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAsistenciasCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String usuarioId,
    required String sitioId,
    required DateTime turnoFecha,
    required String tipoEvento,
    required DateTime ocurridoAt,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.gpsAccuracyM = const Value.absent(),
    this.wifiBssid = const Value.absent(),
    this.wifiSsid = const Value.absent(),
    this.selfieRutaLocal = const Value.absent(),
    this.selfieUrl = const Value.absent(),
    this.livenessPassed = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.clasificacionServidor = const Value.absent(),
    this.minutosRetardoServidor = const Value.absent(),
    this.estadoValidacionServidor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : usuarioId = Value(usuarioId),
       sitioId = Value(sitioId),
       turnoFecha = Value(turnoFecha),
       tipoEvento = Value(tipoEvento),
       ocurridoAt = Value(ocurridoAt);
  static Insertable<LocalAsistencia> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<String>? syncError,
    Expression<int>? syncIntentos,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? syncedAt,
    Expression<String>? usuarioId,
    Expression<String>? sitioId,
    Expression<DateTime>? turnoFecha,
    Expression<String>? tipoEvento,
    Expression<DateTime>? ocurridoAt,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<double>? gpsAccuracyM,
    Expression<String>? wifiBssid,
    Expression<String>? wifiSsid,
    Expression<String>? selfieRutaLocal,
    Expression<String>? selfieUrl,
    Expression<bool>? livenessPassed,
    Expression<String>? observaciones,
    Expression<String>? clasificacionServidor,
    Expression<int>? minutosRetardoServidor,
    Expression<String>? estadoValidacionServidor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncError != null) 'sync_error': syncError,
      if (syncIntentos != null) 'sync_intentos': syncIntentos,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (sitioId != null) 'sitio_id': sitioId,
      if (turnoFecha != null) 'turno_fecha': turnoFecha,
      if (tipoEvento != null) 'tipo_evento': tipoEvento,
      if (ocurridoAt != null) 'ocurrido_at': ocurridoAt,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (gpsAccuracyM != null) 'gps_accuracy_m': gpsAccuracyM,
      if (wifiBssid != null) 'wifi_bssid': wifiBssid,
      if (wifiSsid != null) 'wifi_ssid': wifiSsid,
      if (selfieRutaLocal != null) 'selfie_ruta_local': selfieRutaLocal,
      if (selfieUrl != null) 'selfie_url': selfieUrl,
      if (livenessPassed != null) 'liveness_passed': livenessPassed,
      if (observaciones != null) 'observaciones': observaciones,
      if (clasificacionServidor != null)
        'clasificacion_servidor': clasificacionServidor,
      if (minutosRetardoServidor != null)
        'minutos_retardo_servidor': minutosRetardoServidor,
      if (estadoValidacionServidor != null)
        'estado_validacion_servidor': estadoValidacionServidor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAsistenciasCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<String>? syncError,
    Value<int>? syncIntentos,
    Value<String>? deviceId,
    Value<DateTime>? createdAtLocal,
    Value<DateTime>? updatedAtLocal,
    Value<DateTime?>? syncedAt,
    Value<String>? usuarioId,
    Value<String>? sitioId,
    Value<DateTime>? turnoFecha,
    Value<String>? tipoEvento,
    Value<DateTime>? ocurridoAt,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<double?>? gpsAccuracyM,
    Value<String?>? wifiBssid,
    Value<String?>? wifiSsid,
    Value<String?>? selfieRutaLocal,
    Value<String?>? selfieUrl,
    Value<bool>? livenessPassed,
    Value<String>? observaciones,
    Value<String?>? clasificacionServidor,
    Value<int?>? minutosRetardoServidor,
    Value<String?>? estadoValidacionServidor,
    Value<int>? rowid,
  }) {
    return LocalAsistenciasCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError ?? this.syncError,
      syncIntentos: syncIntentos ?? this.syncIntentos,
      deviceId: deviceId ?? this.deviceId,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      syncedAt: syncedAt ?? this.syncedAt,
      usuarioId: usuarioId ?? this.usuarioId,
      sitioId: sitioId ?? this.sitioId,
      turnoFecha: turnoFecha ?? this.turnoFecha,
      tipoEvento: tipoEvento ?? this.tipoEvento,
      ocurridoAt: ocurridoAt ?? this.ocurridoAt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      gpsAccuracyM: gpsAccuracyM ?? this.gpsAccuracyM,
      wifiBssid: wifiBssid ?? this.wifiBssid,
      wifiSsid: wifiSsid ?? this.wifiSsid,
      selfieRutaLocal: selfieRutaLocal ?? this.selfieRutaLocal,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      livenessPassed: livenessPassed ?? this.livenessPassed,
      observaciones: observaciones ?? this.observaciones,
      clasificacionServidor:
          clasificacionServidor ?? this.clasificacionServidor,
      minutosRetardoServidor:
          minutosRetardoServidor ?? this.minutosRetardoServidor,
      estadoValidacionServidor:
          estadoValidacionServidor ?? this.estadoValidacionServidor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (syncIntentos.present) {
      map['sync_intentos'] = Variable<int>(syncIntentos.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (sitioId.present) {
      map['sitio_id'] = Variable<String>(sitioId.value);
    }
    if (turnoFecha.present) {
      map['turno_fecha'] = Variable<DateTime>(turnoFecha.value);
    }
    if (tipoEvento.present) {
      map['tipo_evento'] = Variable<String>(tipoEvento.value);
    }
    if (ocurridoAt.present) {
      map['ocurrido_at'] = Variable<DateTime>(ocurridoAt.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (gpsAccuracyM.present) {
      map['gps_accuracy_m'] = Variable<double>(gpsAccuracyM.value);
    }
    if (wifiBssid.present) {
      map['wifi_bssid'] = Variable<String>(wifiBssid.value);
    }
    if (wifiSsid.present) {
      map['wifi_ssid'] = Variable<String>(wifiSsid.value);
    }
    if (selfieRutaLocal.present) {
      map['selfie_ruta_local'] = Variable<String>(selfieRutaLocal.value);
    }
    if (selfieUrl.present) {
      map['selfie_url'] = Variable<String>(selfieUrl.value);
    }
    if (livenessPassed.present) {
      map['liveness_passed'] = Variable<bool>(livenessPassed.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (clasificacionServidor.present) {
      map['clasificacion_servidor'] = Variable<String>(
        clasificacionServidor.value,
      );
    }
    if (minutosRetardoServidor.present) {
      map['minutos_retardo_servidor'] = Variable<int>(
        minutosRetardoServidor.value,
      );
    }
    if (estadoValidacionServidor.present) {
      map['estado_validacion_servidor'] = Variable<String>(
        estadoValidacionServidor.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAsistenciasCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('sitioId: $sitioId, ')
          ..write('turnoFecha: $turnoFecha, ')
          ..write('tipoEvento: $tipoEvento, ')
          ..write('ocurridoAt: $ocurridoAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('gpsAccuracyM: $gpsAccuracyM, ')
          ..write('wifiBssid: $wifiBssid, ')
          ..write('wifiSsid: $wifiSsid, ')
          ..write('selfieRutaLocal: $selfieRutaLocal, ')
          ..write('selfieUrl: $selfieUrl, ')
          ..write('livenessPassed: $livenessPassed, ')
          ..write('observaciones: $observaciones, ')
          ..write('clasificacionServidor: $clasificacionServidor, ')
          ..write('minutosRetardoServidor: $minutosRetardoServidor, ')
          ..write('estadoValidacionServidor: $estadoValidacionServidor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalRegistrosAccesoTable extends LocalRegistrosAcceso
    with TableInfo<$LocalRegistrosAccesoTable, LocalRegistrosAccesoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRegistrosAccesoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncIntentosMeta = const VerificationMeta(
    'syncIntentos',
  );
  @override
  late final GeneratedColumn<int> syncIntentos = GeneratedColumn<int>(
    'sync_intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtLocalMeta = const VerificationMeta(
    'createdAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>(
        'created_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sitioIdMeta = const VerificationMeta(
    'sitioId',
  );
  @override
  late final GeneratedColumn<String> sitioId = GeneratedColumn<String>(
    'sitio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registradoPorMeta = const VerificationMeta(
    'registradoPor',
  );
  @override
  late final GeneratedColumn<String> registradoPor = GeneratedColumn<String>(
    'registrado_por',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitanteLocalIdMeta = const VerificationMeta(
    'visitanteLocalId',
  );
  @override
  late final GeneratedColumn<String> visitanteLocalId = GeneratedColumn<String>(
    'visitante_local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreCompletoMeta = const VerificationMeta(
    'nombreCompleto',
  );
  @override
  late final GeneratedColumn<String> nombreCompleto = GeneratedColumn<String>(
    'nombre_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _empresaProcedenciaMeta =
      const VerificationMeta('empresaProcedencia');
  @override
  late final GeneratedColumn<String> empresaProcedencia =
      GeneratedColumn<String>(
        'empresa_procedencia',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _personaVisitadaIdMeta = const VerificationMeta(
    'personaVisitadaId',
  );
  @override
  late final GeneratedColumn<String> personaVisitadaId =
      GeneratedColumn<String>(
        'persona_visitada_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _personaVisitadaTextoMeta =
      const VerificationMeta('personaVisitadaTexto');
  @override
  late final GeneratedColumn<String> personaVisitadaTexto =
      GeneratedColumn<String>(
        'persona_visitada_texto',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _asuntoMeta = const VerificationMeta('asunto');
  @override
  late final GeneratedColumn<String> asunto = GeneratedColumn<String>(
    'asunto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingresaVehiculoMeta = const VerificationMeta(
    'ingresaVehiculo',
  );
  @override
  late final GeneratedColumn<bool> ingresaVehiculo = GeneratedColumn<bool>(
    'ingresa_vehiculo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ingresa_vehiculo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _placasMeta = const VerificationMeta('placas');
  @override
  late final GeneratedColumn<String> placas = GeneratedColumn<String>(
    'placas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _vehiculoMarcaMeta = const VerificationMeta(
    'vehiculoMarca',
  );
  @override
  late final GeneratedColumn<String> vehiculoMarca = GeneratedColumn<String>(
    'vehiculo_marca',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _vehiculoModeloMeta = const VerificationMeta(
    'vehiculoModelo',
  );
  @override
  late final GeneratedColumn<String> vehiculoModelo = GeneratedColumn<String>(
    'vehiculo_modelo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _vehiculoColorMeta = const VerificationMeta(
    'vehiculoColor',
  );
  @override
  late final GeneratedColumn<String> vehiculoColor = GeneratedColumn<String>(
    'vehiculo_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _identificacionTipoMeta =
      const VerificationMeta('identificacionTipo');
  @override
  late final GeneratedColumn<String> identificacionTipo =
      GeneratedColumn<String>(
        'identificacion_tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _identificacionRutaLocalMeta =
      const VerificationMeta('identificacionRutaLocal');
  @override
  late final GeneratedColumn<String> identificacionRutaLocal =
      GeneratedColumn<String>(
        'identificacion_ruta_local',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _identificacionUrlMeta = const VerificationMeta(
    'identificacionUrl',
  );
  @override
  late final GeneratedColumn<String> identificacionUrl =
      GeneratedColumn<String>(
        'identificacion_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _avisoPrivacidadIdMeta = const VerificationMeta(
    'avisoPrivacidadId',
  );
  @override
  late final GeneratedColumn<String> avisoPrivacidadId =
      GeneratedColumn<String>(
        'aviso_privacidad_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _avisoAceptadoMeta = const VerificationMeta(
    'avisoAceptado',
  );
  @override
  late final GeneratedColumn<bool> avisoAceptado = GeneratedColumn<bool>(
    'aviso_aceptado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aviso_aceptado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _avisoAceptadoAtMeta = const VerificationMeta(
    'avisoAceptadoAt',
  );
  @override
  late final GeneratedColumn<DateTime> avisoAceptadoAt =
      GeneratedColumn<DateTime>(
        'aviso_aceptado_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _horaEntradaMeta = const VerificationMeta(
    'horaEntrada',
  );
  @override
  late final GeneratedColumn<DateTime> horaEntrada = GeneratedColumn<DateTime>(
    'hora_entrada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _horaSalidaMeta = const VerificationMeta(
    'horaSalida',
  );
  @override
  late final GeneratedColumn<DateTime> horaSalida = GeneratedColumn<DateTime>(
    'hora_salida',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salidaRegistradaPorMeta =
      const VerificationMeta('salidaRegistradaPor');
  @override
  late final GeneratedColumn<String> salidaRegistradaPor =
      GeneratedColumn<String>(
        'salida_registrada_por',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    sitioId,
    registradoPor,
    visitanteLocalId,
    nombreCompleto,
    empresaProcedencia,
    telefono,
    personaVisitadaId,
    personaVisitadaTexto,
    asunto,
    ingresaVehiculo,
    placas,
    vehiculoMarca,
    vehiculoModelo,
    vehiculoColor,
    identificacionTipo,
    identificacionRutaLocal,
    identificacionUrl,
    avisoPrivacidadId,
    avisoAceptado,
    avisoAceptadoAt,
    horaEntrada,
    horaSalida,
    salidaRegistradaPor,
    observaciones,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_registros_acceso';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRegistrosAccesoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('sync_intentos')) {
      context.handle(
        _syncIntentosMeta,
        syncIntentos.isAcceptableOrUnknown(
          data['sync_intentos']!,
          _syncIntentosMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
        _createdAtLocalMeta,
        createdAtLocal.isAcceptableOrUnknown(
          data['created_at_local']!,
          _createdAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('sitio_id')) {
      context.handle(
        _sitioIdMeta,
        sitioId.isAcceptableOrUnknown(data['sitio_id']!, _sitioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sitioIdMeta);
    }
    if (data.containsKey('registrado_por')) {
      context.handle(
        _registradoPorMeta,
        registradoPor.isAcceptableOrUnknown(
          data['registrado_por']!,
          _registradoPorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registradoPorMeta);
    }
    if (data.containsKey('visitante_local_id')) {
      context.handle(
        _visitanteLocalIdMeta,
        visitanteLocalId.isAcceptableOrUnknown(
          data['visitante_local_id']!,
          _visitanteLocalIdMeta,
        ),
      );
    }
    if (data.containsKey('nombre_completo')) {
      context.handle(
        _nombreCompletoMeta,
        nombreCompleto.isAcceptableOrUnknown(
          data['nombre_completo']!,
          _nombreCompletoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreCompletoMeta);
    }
    if (data.containsKey('empresa_procedencia')) {
      context.handle(
        _empresaProcedenciaMeta,
        empresaProcedencia.isAcceptableOrUnknown(
          data['empresa_procedencia']!,
          _empresaProcedenciaMeta,
        ),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('persona_visitada_id')) {
      context.handle(
        _personaVisitadaIdMeta,
        personaVisitadaId.isAcceptableOrUnknown(
          data['persona_visitada_id']!,
          _personaVisitadaIdMeta,
        ),
      );
    }
    if (data.containsKey('persona_visitada_texto')) {
      context.handle(
        _personaVisitadaTextoMeta,
        personaVisitadaTexto.isAcceptableOrUnknown(
          data['persona_visitada_texto']!,
          _personaVisitadaTextoMeta,
        ),
      );
    }
    if (data.containsKey('asunto')) {
      context.handle(
        _asuntoMeta,
        asunto.isAcceptableOrUnknown(data['asunto']!, _asuntoMeta),
      );
    } else if (isInserting) {
      context.missing(_asuntoMeta);
    }
    if (data.containsKey('ingresa_vehiculo')) {
      context.handle(
        _ingresaVehiculoMeta,
        ingresaVehiculo.isAcceptableOrUnknown(
          data['ingresa_vehiculo']!,
          _ingresaVehiculoMeta,
        ),
      );
    }
    if (data.containsKey('placas')) {
      context.handle(
        _placasMeta,
        placas.isAcceptableOrUnknown(data['placas']!, _placasMeta),
      );
    }
    if (data.containsKey('vehiculo_marca')) {
      context.handle(
        _vehiculoMarcaMeta,
        vehiculoMarca.isAcceptableOrUnknown(
          data['vehiculo_marca']!,
          _vehiculoMarcaMeta,
        ),
      );
    }
    if (data.containsKey('vehiculo_modelo')) {
      context.handle(
        _vehiculoModeloMeta,
        vehiculoModelo.isAcceptableOrUnknown(
          data['vehiculo_modelo']!,
          _vehiculoModeloMeta,
        ),
      );
    }
    if (data.containsKey('vehiculo_color')) {
      context.handle(
        _vehiculoColorMeta,
        vehiculoColor.isAcceptableOrUnknown(
          data['vehiculo_color']!,
          _vehiculoColorMeta,
        ),
      );
    }
    if (data.containsKey('identificacion_tipo')) {
      context.handle(
        _identificacionTipoMeta,
        identificacionTipo.isAcceptableOrUnknown(
          data['identificacion_tipo']!,
          _identificacionTipoMeta,
        ),
      );
    }
    if (data.containsKey('identificacion_ruta_local')) {
      context.handle(
        _identificacionRutaLocalMeta,
        identificacionRutaLocal.isAcceptableOrUnknown(
          data['identificacion_ruta_local']!,
          _identificacionRutaLocalMeta,
        ),
      );
    }
    if (data.containsKey('identificacion_url')) {
      context.handle(
        _identificacionUrlMeta,
        identificacionUrl.isAcceptableOrUnknown(
          data['identificacion_url']!,
          _identificacionUrlMeta,
        ),
      );
    }
    if (data.containsKey('aviso_privacidad_id')) {
      context.handle(
        _avisoPrivacidadIdMeta,
        avisoPrivacidadId.isAcceptableOrUnknown(
          data['aviso_privacidad_id']!,
          _avisoPrivacidadIdMeta,
        ),
      );
    }
    if (data.containsKey('aviso_aceptado')) {
      context.handle(
        _avisoAceptadoMeta,
        avisoAceptado.isAcceptableOrUnknown(
          data['aviso_aceptado']!,
          _avisoAceptadoMeta,
        ),
      );
    }
    if (data.containsKey('aviso_aceptado_at')) {
      context.handle(
        _avisoAceptadoAtMeta,
        avisoAceptadoAt.isAcceptableOrUnknown(
          data['aviso_aceptado_at']!,
          _avisoAceptadoAtMeta,
        ),
      );
    }
    if (data.containsKey('hora_entrada')) {
      context.handle(
        _horaEntradaMeta,
        horaEntrada.isAcceptableOrUnknown(
          data['hora_entrada']!,
          _horaEntradaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_horaEntradaMeta);
    }
    if (data.containsKey('hora_salida')) {
      context.handle(
        _horaSalidaMeta,
        horaSalida.isAcceptableOrUnknown(data['hora_salida']!, _horaSalidaMeta),
      );
    }
    if (data.containsKey('salida_registrada_por')) {
      context.handle(
        _salidaRegistradaPorMeta,
        salidaRegistradaPor.isAcceptableOrUnknown(
          data['salida_registrada_por']!,
          _salidaRegistradaPorMeta,
        ),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalRegistrosAccesoData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRegistrosAccesoData(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      )!,
      syncIntentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_intentos'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      sitioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sitio_id'],
      )!,
      registradoPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registrado_por'],
      )!,
      visitanteLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visitante_local_id'],
      ),
      nombreCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_completo'],
      )!,
      empresaProcedencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_procedencia'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      personaVisitadaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}persona_visitada_id'],
      ),
      personaVisitadaTexto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}persona_visitada_texto'],
      )!,
      asunto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asunto'],
      )!,
      ingresaVehiculo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ingresa_vehiculo'],
      )!,
      placas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placas'],
      )!,
      vehiculoMarca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_marca'],
      )!,
      vehiculoModelo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_modelo'],
      )!,
      vehiculoColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehiculo_color'],
      )!,
      identificacionTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identificacion_tipo'],
      )!,
      identificacionRutaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identificacion_ruta_local'],
      ),
      identificacionUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identificacion_url'],
      ),
      avisoPrivacidadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aviso_privacidad_id'],
      ),
      avisoAceptado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aviso_aceptado'],
      )!,
      avisoAceptadoAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}aviso_aceptado_at'],
      ),
      horaEntrada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hora_entrada'],
      )!,
      horaSalida: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hora_salida'],
      ),
      salidaRegistradaPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salida_registrada_por'],
      ),
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      )!,
    );
  }

  @override
  $LocalRegistrosAccesoTable createAlias(String alias) {
    return $LocalRegistrosAccesoTable(attachedDatabase, alias);
  }
}

class LocalRegistrosAccesoData extends DataClass
    implements Insertable<LocalRegistrosAccesoData> {
  final String localId;

  /// UUID que asignó Supabase. Nulo mientras no se haya sincronizado.
  final String? remoteId;

  /// pendiente | sincronizando | sincronizado | fallido
  final String syncStatus;
  final String syncError;

  /// Se pausan los reintentos al llegar al máximo para no quemar batería
  /// reintentando algo que falla por una razón que no se va a resolver sola
  /// (por ejemplo, violar un CHECK del servidor).
  final int syncIntentos;
  final String deviceId;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? syncedAt;
  final String sitioId;
  final String registradoPor;
  final String? visitanteLocalId;
  final String nombreCompleto;
  final String empresaProcedencia;
  final String telefono;
  final String? personaVisitadaId;
  final String personaVisitadaTexto;
  final String asunto;
  final bool ingresaVehiculo;
  final String placas;
  final String vehiculoMarca;
  final String vehiculoModelo;
  final String vehiculoColor;
  final String identificacionTipo;
  final String? identificacionRutaLocal;
  final String? identificacionUrl;
  final String? avisoPrivacidadId;
  final bool avisoAceptado;
  final DateTime? avisoAceptadoAt;
  final DateTime horaEntrada;
  final DateTime? horaSalida;
  final String? salidaRegistradaPor;
  final String observaciones;
  const LocalRegistrosAccesoData({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.syncError,
    required this.syncIntentos,
    required this.deviceId,
    required this.createdAtLocal,
    required this.updatedAtLocal,
    this.syncedAt,
    required this.sitioId,
    required this.registradoPor,
    this.visitanteLocalId,
    required this.nombreCompleto,
    required this.empresaProcedencia,
    required this.telefono,
    this.personaVisitadaId,
    required this.personaVisitadaTexto,
    required this.asunto,
    required this.ingresaVehiculo,
    required this.placas,
    required this.vehiculoMarca,
    required this.vehiculoModelo,
    required this.vehiculoColor,
    required this.identificacionTipo,
    this.identificacionRutaLocal,
    this.identificacionUrl,
    this.avisoPrivacidadId,
    required this.avisoAceptado,
    this.avisoAceptadoAt,
    required this.horaEntrada,
    this.horaSalida,
    this.salidaRegistradaPor,
    required this.observaciones,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_error'] = Variable<String>(syncError);
    map['sync_intentos'] = Variable<int>(syncIntentos);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['sitio_id'] = Variable<String>(sitioId);
    map['registrado_por'] = Variable<String>(registradoPor);
    if (!nullToAbsent || visitanteLocalId != null) {
      map['visitante_local_id'] = Variable<String>(visitanteLocalId);
    }
    map['nombre_completo'] = Variable<String>(nombreCompleto);
    map['empresa_procedencia'] = Variable<String>(empresaProcedencia);
    map['telefono'] = Variable<String>(telefono);
    if (!nullToAbsent || personaVisitadaId != null) {
      map['persona_visitada_id'] = Variable<String>(personaVisitadaId);
    }
    map['persona_visitada_texto'] = Variable<String>(personaVisitadaTexto);
    map['asunto'] = Variable<String>(asunto);
    map['ingresa_vehiculo'] = Variable<bool>(ingresaVehiculo);
    map['placas'] = Variable<String>(placas);
    map['vehiculo_marca'] = Variable<String>(vehiculoMarca);
    map['vehiculo_modelo'] = Variable<String>(vehiculoModelo);
    map['vehiculo_color'] = Variable<String>(vehiculoColor);
    map['identificacion_tipo'] = Variable<String>(identificacionTipo);
    if (!nullToAbsent || identificacionRutaLocal != null) {
      map['identificacion_ruta_local'] = Variable<String>(
        identificacionRutaLocal,
      );
    }
    if (!nullToAbsent || identificacionUrl != null) {
      map['identificacion_url'] = Variable<String>(identificacionUrl);
    }
    if (!nullToAbsent || avisoPrivacidadId != null) {
      map['aviso_privacidad_id'] = Variable<String>(avisoPrivacidadId);
    }
    map['aviso_aceptado'] = Variable<bool>(avisoAceptado);
    if (!nullToAbsent || avisoAceptadoAt != null) {
      map['aviso_aceptado_at'] = Variable<DateTime>(avisoAceptadoAt);
    }
    map['hora_entrada'] = Variable<DateTime>(horaEntrada);
    if (!nullToAbsent || horaSalida != null) {
      map['hora_salida'] = Variable<DateTime>(horaSalida);
    }
    if (!nullToAbsent || salidaRegistradaPor != null) {
      map['salida_registrada_por'] = Variable<String>(salidaRegistradaPor);
    }
    map['observaciones'] = Variable<String>(observaciones);
    return map;
  }

  LocalRegistrosAccesoCompanion toCompanion(bool nullToAbsent) {
    return LocalRegistrosAccesoCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      syncError: Value(syncError),
      syncIntentos: Value(syncIntentos),
      deviceId: Value(deviceId),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      sitioId: Value(sitioId),
      registradoPor: Value(registradoPor),
      visitanteLocalId: visitanteLocalId == null && nullToAbsent
          ? const Value.absent()
          : Value(visitanteLocalId),
      nombreCompleto: Value(nombreCompleto),
      empresaProcedencia: Value(empresaProcedencia),
      telefono: Value(telefono),
      personaVisitadaId: personaVisitadaId == null && nullToAbsent
          ? const Value.absent()
          : Value(personaVisitadaId),
      personaVisitadaTexto: Value(personaVisitadaTexto),
      asunto: Value(asunto),
      ingresaVehiculo: Value(ingresaVehiculo),
      placas: Value(placas),
      vehiculoMarca: Value(vehiculoMarca),
      vehiculoModelo: Value(vehiculoModelo),
      vehiculoColor: Value(vehiculoColor),
      identificacionTipo: Value(identificacionTipo),
      identificacionRutaLocal: identificacionRutaLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(identificacionRutaLocal),
      identificacionUrl: identificacionUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(identificacionUrl),
      avisoPrivacidadId: avisoPrivacidadId == null && nullToAbsent
          ? const Value.absent()
          : Value(avisoPrivacidadId),
      avisoAceptado: Value(avisoAceptado),
      avisoAceptadoAt: avisoAceptadoAt == null && nullToAbsent
          ? const Value.absent()
          : Value(avisoAceptadoAt),
      horaEntrada: Value(horaEntrada),
      horaSalida: horaSalida == null && nullToAbsent
          ? const Value.absent()
          : Value(horaSalida),
      salidaRegistradaPor: salidaRegistradaPor == null && nullToAbsent
          ? const Value.absent()
          : Value(salidaRegistradaPor),
      observaciones: Value(observaciones),
    );
  }

  factory LocalRegistrosAccesoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRegistrosAccesoData(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncError: serializer.fromJson<String>(json['syncError']),
      syncIntentos: serializer.fromJson<int>(json['syncIntentos']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAtLocal: serializer.fromJson<DateTime>(json['createdAtLocal']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updatedAtLocal']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      sitioId: serializer.fromJson<String>(json['sitioId']),
      registradoPor: serializer.fromJson<String>(json['registradoPor']),
      visitanteLocalId: serializer.fromJson<String?>(json['visitanteLocalId']),
      nombreCompleto: serializer.fromJson<String>(json['nombreCompleto']),
      empresaProcedencia: serializer.fromJson<String>(
        json['empresaProcedencia'],
      ),
      telefono: serializer.fromJson<String>(json['telefono']),
      personaVisitadaId: serializer.fromJson<String?>(
        json['personaVisitadaId'],
      ),
      personaVisitadaTexto: serializer.fromJson<String>(
        json['personaVisitadaTexto'],
      ),
      asunto: serializer.fromJson<String>(json['asunto']),
      ingresaVehiculo: serializer.fromJson<bool>(json['ingresaVehiculo']),
      placas: serializer.fromJson<String>(json['placas']),
      vehiculoMarca: serializer.fromJson<String>(json['vehiculoMarca']),
      vehiculoModelo: serializer.fromJson<String>(json['vehiculoModelo']),
      vehiculoColor: serializer.fromJson<String>(json['vehiculoColor']),
      identificacionTipo: serializer.fromJson<String>(
        json['identificacionTipo'],
      ),
      identificacionRutaLocal: serializer.fromJson<String?>(
        json['identificacionRutaLocal'],
      ),
      identificacionUrl: serializer.fromJson<String?>(
        json['identificacionUrl'],
      ),
      avisoPrivacidadId: serializer.fromJson<String?>(
        json['avisoPrivacidadId'],
      ),
      avisoAceptado: serializer.fromJson<bool>(json['avisoAceptado']),
      avisoAceptadoAt: serializer.fromJson<DateTime?>(json['avisoAceptadoAt']),
      horaEntrada: serializer.fromJson<DateTime>(json['horaEntrada']),
      horaSalida: serializer.fromJson<DateTime?>(json['horaSalida']),
      salidaRegistradaPor: serializer.fromJson<String?>(
        json['salidaRegistradaPor'],
      ),
      observaciones: serializer.fromJson<String>(json['observaciones']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncError': serializer.toJson<String>(syncError),
      'syncIntentos': serializer.toJson<int>(syncIntentos),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAtLocal': serializer.toJson<DateTime>(createdAtLocal),
      'updatedAtLocal': serializer.toJson<DateTime>(updatedAtLocal),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'sitioId': serializer.toJson<String>(sitioId),
      'registradoPor': serializer.toJson<String>(registradoPor),
      'visitanteLocalId': serializer.toJson<String?>(visitanteLocalId),
      'nombreCompleto': serializer.toJson<String>(nombreCompleto),
      'empresaProcedencia': serializer.toJson<String>(empresaProcedencia),
      'telefono': serializer.toJson<String>(telefono),
      'personaVisitadaId': serializer.toJson<String?>(personaVisitadaId),
      'personaVisitadaTexto': serializer.toJson<String>(personaVisitadaTexto),
      'asunto': serializer.toJson<String>(asunto),
      'ingresaVehiculo': serializer.toJson<bool>(ingresaVehiculo),
      'placas': serializer.toJson<String>(placas),
      'vehiculoMarca': serializer.toJson<String>(vehiculoMarca),
      'vehiculoModelo': serializer.toJson<String>(vehiculoModelo),
      'vehiculoColor': serializer.toJson<String>(vehiculoColor),
      'identificacionTipo': serializer.toJson<String>(identificacionTipo),
      'identificacionRutaLocal': serializer.toJson<String?>(
        identificacionRutaLocal,
      ),
      'identificacionUrl': serializer.toJson<String?>(identificacionUrl),
      'avisoPrivacidadId': serializer.toJson<String?>(avisoPrivacidadId),
      'avisoAceptado': serializer.toJson<bool>(avisoAceptado),
      'avisoAceptadoAt': serializer.toJson<DateTime?>(avisoAceptadoAt),
      'horaEntrada': serializer.toJson<DateTime>(horaEntrada),
      'horaSalida': serializer.toJson<DateTime?>(horaSalida),
      'salidaRegistradaPor': serializer.toJson<String?>(salidaRegistradaPor),
      'observaciones': serializer.toJson<String>(observaciones),
    };
  }

  LocalRegistrosAccesoData copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    String? syncError,
    int? syncIntentos,
    String? deviceId,
    DateTime? createdAtLocal,
    DateTime? updatedAtLocal,
    Value<DateTime?> syncedAt = const Value.absent(),
    String? sitioId,
    String? registradoPor,
    Value<String?> visitanteLocalId = const Value.absent(),
    String? nombreCompleto,
    String? empresaProcedencia,
    String? telefono,
    Value<String?> personaVisitadaId = const Value.absent(),
    String? personaVisitadaTexto,
    String? asunto,
    bool? ingresaVehiculo,
    String? placas,
    String? vehiculoMarca,
    String? vehiculoModelo,
    String? vehiculoColor,
    String? identificacionTipo,
    Value<String?> identificacionRutaLocal = const Value.absent(),
    Value<String?> identificacionUrl = const Value.absent(),
    Value<String?> avisoPrivacidadId = const Value.absent(),
    bool? avisoAceptado,
    Value<DateTime?> avisoAceptadoAt = const Value.absent(),
    DateTime? horaEntrada,
    Value<DateTime?> horaSalida = const Value.absent(),
    Value<String?> salidaRegistradaPor = const Value.absent(),
    String? observaciones,
  }) => LocalRegistrosAccesoData(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncError: syncError ?? this.syncError,
    syncIntentos: syncIntentos ?? this.syncIntentos,
    deviceId: deviceId ?? this.deviceId,
    createdAtLocal: createdAtLocal ?? this.createdAtLocal,
    updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    sitioId: sitioId ?? this.sitioId,
    registradoPor: registradoPor ?? this.registradoPor,
    visitanteLocalId: visitanteLocalId.present
        ? visitanteLocalId.value
        : this.visitanteLocalId,
    nombreCompleto: nombreCompleto ?? this.nombreCompleto,
    empresaProcedencia: empresaProcedencia ?? this.empresaProcedencia,
    telefono: telefono ?? this.telefono,
    personaVisitadaId: personaVisitadaId.present
        ? personaVisitadaId.value
        : this.personaVisitadaId,
    personaVisitadaTexto: personaVisitadaTexto ?? this.personaVisitadaTexto,
    asunto: asunto ?? this.asunto,
    ingresaVehiculo: ingresaVehiculo ?? this.ingresaVehiculo,
    placas: placas ?? this.placas,
    vehiculoMarca: vehiculoMarca ?? this.vehiculoMarca,
    vehiculoModelo: vehiculoModelo ?? this.vehiculoModelo,
    vehiculoColor: vehiculoColor ?? this.vehiculoColor,
    identificacionTipo: identificacionTipo ?? this.identificacionTipo,
    identificacionRutaLocal: identificacionRutaLocal.present
        ? identificacionRutaLocal.value
        : this.identificacionRutaLocal,
    identificacionUrl: identificacionUrl.present
        ? identificacionUrl.value
        : this.identificacionUrl,
    avisoPrivacidadId: avisoPrivacidadId.present
        ? avisoPrivacidadId.value
        : this.avisoPrivacidadId,
    avisoAceptado: avisoAceptado ?? this.avisoAceptado,
    avisoAceptadoAt: avisoAceptadoAt.present
        ? avisoAceptadoAt.value
        : this.avisoAceptadoAt,
    horaEntrada: horaEntrada ?? this.horaEntrada,
    horaSalida: horaSalida.present ? horaSalida.value : this.horaSalida,
    salidaRegistradaPor: salidaRegistradaPor.present
        ? salidaRegistradaPor.value
        : this.salidaRegistradaPor,
    observaciones: observaciones ?? this.observaciones,
  );
  LocalRegistrosAccesoData copyWithCompanion(
    LocalRegistrosAccesoCompanion data,
  ) {
    return LocalRegistrosAccesoData(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      syncIntentos: data.syncIntentos.present
          ? data.syncIntentos.value
          : this.syncIntentos,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      sitioId: data.sitioId.present ? data.sitioId.value : this.sitioId,
      registradoPor: data.registradoPor.present
          ? data.registradoPor.value
          : this.registradoPor,
      visitanteLocalId: data.visitanteLocalId.present
          ? data.visitanteLocalId.value
          : this.visitanteLocalId,
      nombreCompleto: data.nombreCompleto.present
          ? data.nombreCompleto.value
          : this.nombreCompleto,
      empresaProcedencia: data.empresaProcedencia.present
          ? data.empresaProcedencia.value
          : this.empresaProcedencia,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      personaVisitadaId: data.personaVisitadaId.present
          ? data.personaVisitadaId.value
          : this.personaVisitadaId,
      personaVisitadaTexto: data.personaVisitadaTexto.present
          ? data.personaVisitadaTexto.value
          : this.personaVisitadaTexto,
      asunto: data.asunto.present ? data.asunto.value : this.asunto,
      ingresaVehiculo: data.ingresaVehiculo.present
          ? data.ingresaVehiculo.value
          : this.ingresaVehiculo,
      placas: data.placas.present ? data.placas.value : this.placas,
      vehiculoMarca: data.vehiculoMarca.present
          ? data.vehiculoMarca.value
          : this.vehiculoMarca,
      vehiculoModelo: data.vehiculoModelo.present
          ? data.vehiculoModelo.value
          : this.vehiculoModelo,
      vehiculoColor: data.vehiculoColor.present
          ? data.vehiculoColor.value
          : this.vehiculoColor,
      identificacionTipo: data.identificacionTipo.present
          ? data.identificacionTipo.value
          : this.identificacionTipo,
      identificacionRutaLocal: data.identificacionRutaLocal.present
          ? data.identificacionRutaLocal.value
          : this.identificacionRutaLocal,
      identificacionUrl: data.identificacionUrl.present
          ? data.identificacionUrl.value
          : this.identificacionUrl,
      avisoPrivacidadId: data.avisoPrivacidadId.present
          ? data.avisoPrivacidadId.value
          : this.avisoPrivacidadId,
      avisoAceptado: data.avisoAceptado.present
          ? data.avisoAceptado.value
          : this.avisoAceptado,
      avisoAceptadoAt: data.avisoAceptadoAt.present
          ? data.avisoAceptadoAt.value
          : this.avisoAceptadoAt,
      horaEntrada: data.horaEntrada.present
          ? data.horaEntrada.value
          : this.horaEntrada,
      horaSalida: data.horaSalida.present
          ? data.horaSalida.value
          : this.horaSalida,
      salidaRegistradaPor: data.salidaRegistradaPor.present
          ? data.salidaRegistradaPor.value
          : this.salidaRegistradaPor,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRegistrosAccesoData(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('sitioId: $sitioId, ')
          ..write('registradoPor: $registradoPor, ')
          ..write('visitanteLocalId: $visitanteLocalId, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('empresaProcedencia: $empresaProcedencia, ')
          ..write('telefono: $telefono, ')
          ..write('personaVisitadaId: $personaVisitadaId, ')
          ..write('personaVisitadaTexto: $personaVisitadaTexto, ')
          ..write('asunto: $asunto, ')
          ..write('ingresaVehiculo: $ingresaVehiculo, ')
          ..write('placas: $placas, ')
          ..write('vehiculoMarca: $vehiculoMarca, ')
          ..write('vehiculoModelo: $vehiculoModelo, ')
          ..write('vehiculoColor: $vehiculoColor, ')
          ..write('identificacionTipo: $identificacionTipo, ')
          ..write('identificacionRutaLocal: $identificacionRutaLocal, ')
          ..write('identificacionUrl: $identificacionUrl, ')
          ..write('avisoPrivacidadId: $avisoPrivacidadId, ')
          ..write('avisoAceptado: $avisoAceptado, ')
          ..write('avisoAceptadoAt: $avisoAceptadoAt, ')
          ..write('horaEntrada: $horaEntrada, ')
          ..write('horaSalida: $horaSalida, ')
          ..write('salidaRegistradaPor: $salidaRegistradaPor, ')
          ..write('observaciones: $observaciones')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    sitioId,
    registradoPor,
    visitanteLocalId,
    nombreCompleto,
    empresaProcedencia,
    telefono,
    personaVisitadaId,
    personaVisitadaTexto,
    asunto,
    ingresaVehiculo,
    placas,
    vehiculoMarca,
    vehiculoModelo,
    vehiculoColor,
    identificacionTipo,
    identificacionRutaLocal,
    identificacionUrl,
    avisoPrivacidadId,
    avisoAceptado,
    avisoAceptadoAt,
    horaEntrada,
    horaSalida,
    salidaRegistradaPor,
    observaciones,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRegistrosAccesoData &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.syncError == this.syncError &&
          other.syncIntentos == this.syncIntentos &&
          other.deviceId == this.deviceId &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.syncedAt == this.syncedAt &&
          other.sitioId == this.sitioId &&
          other.registradoPor == this.registradoPor &&
          other.visitanteLocalId == this.visitanteLocalId &&
          other.nombreCompleto == this.nombreCompleto &&
          other.empresaProcedencia == this.empresaProcedencia &&
          other.telefono == this.telefono &&
          other.personaVisitadaId == this.personaVisitadaId &&
          other.personaVisitadaTexto == this.personaVisitadaTexto &&
          other.asunto == this.asunto &&
          other.ingresaVehiculo == this.ingresaVehiculo &&
          other.placas == this.placas &&
          other.vehiculoMarca == this.vehiculoMarca &&
          other.vehiculoModelo == this.vehiculoModelo &&
          other.vehiculoColor == this.vehiculoColor &&
          other.identificacionTipo == this.identificacionTipo &&
          other.identificacionRutaLocal == this.identificacionRutaLocal &&
          other.identificacionUrl == this.identificacionUrl &&
          other.avisoPrivacidadId == this.avisoPrivacidadId &&
          other.avisoAceptado == this.avisoAceptado &&
          other.avisoAceptadoAt == this.avisoAceptadoAt &&
          other.horaEntrada == this.horaEntrada &&
          other.horaSalida == this.horaSalida &&
          other.salidaRegistradaPor == this.salidaRegistradaPor &&
          other.observaciones == this.observaciones);
}

class LocalRegistrosAccesoCompanion
    extends UpdateCompanion<LocalRegistrosAccesoData> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<String> syncError;
  final Value<int> syncIntentos;
  final Value<String> deviceId;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> syncedAt;
  final Value<String> sitioId;
  final Value<String> registradoPor;
  final Value<String?> visitanteLocalId;
  final Value<String> nombreCompleto;
  final Value<String> empresaProcedencia;
  final Value<String> telefono;
  final Value<String?> personaVisitadaId;
  final Value<String> personaVisitadaTexto;
  final Value<String> asunto;
  final Value<bool> ingresaVehiculo;
  final Value<String> placas;
  final Value<String> vehiculoMarca;
  final Value<String> vehiculoModelo;
  final Value<String> vehiculoColor;
  final Value<String> identificacionTipo;
  final Value<String?> identificacionRutaLocal;
  final Value<String?> identificacionUrl;
  final Value<String?> avisoPrivacidadId;
  final Value<bool> avisoAceptado;
  final Value<DateTime?> avisoAceptadoAt;
  final Value<DateTime> horaEntrada;
  final Value<DateTime?> horaSalida;
  final Value<String?> salidaRegistradaPor;
  final Value<String> observaciones;
  final Value<int> rowid;
  const LocalRegistrosAccesoCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.sitioId = const Value.absent(),
    this.registradoPor = const Value.absent(),
    this.visitanteLocalId = const Value.absent(),
    this.nombreCompleto = const Value.absent(),
    this.empresaProcedencia = const Value.absent(),
    this.telefono = const Value.absent(),
    this.personaVisitadaId = const Value.absent(),
    this.personaVisitadaTexto = const Value.absent(),
    this.asunto = const Value.absent(),
    this.ingresaVehiculo = const Value.absent(),
    this.placas = const Value.absent(),
    this.vehiculoMarca = const Value.absent(),
    this.vehiculoModelo = const Value.absent(),
    this.vehiculoColor = const Value.absent(),
    this.identificacionTipo = const Value.absent(),
    this.identificacionRutaLocal = const Value.absent(),
    this.identificacionUrl = const Value.absent(),
    this.avisoPrivacidadId = const Value.absent(),
    this.avisoAceptado = const Value.absent(),
    this.avisoAceptadoAt = const Value.absent(),
    this.horaEntrada = const Value.absent(),
    this.horaSalida = const Value.absent(),
    this.salidaRegistradaPor = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalRegistrosAccesoCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String sitioId,
    required String registradoPor,
    this.visitanteLocalId = const Value.absent(),
    required String nombreCompleto,
    this.empresaProcedencia = const Value.absent(),
    this.telefono = const Value.absent(),
    this.personaVisitadaId = const Value.absent(),
    this.personaVisitadaTexto = const Value.absent(),
    required String asunto,
    this.ingresaVehiculo = const Value.absent(),
    this.placas = const Value.absent(),
    this.vehiculoMarca = const Value.absent(),
    this.vehiculoModelo = const Value.absent(),
    this.vehiculoColor = const Value.absent(),
    this.identificacionTipo = const Value.absent(),
    this.identificacionRutaLocal = const Value.absent(),
    this.identificacionUrl = const Value.absent(),
    this.avisoPrivacidadId = const Value.absent(),
    this.avisoAceptado = const Value.absent(),
    this.avisoAceptadoAt = const Value.absent(),
    required DateTime horaEntrada,
    this.horaSalida = const Value.absent(),
    this.salidaRegistradaPor = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sitioId = Value(sitioId),
       registradoPor = Value(registradoPor),
       nombreCompleto = Value(nombreCompleto),
       asunto = Value(asunto),
       horaEntrada = Value(horaEntrada);
  static Insertable<LocalRegistrosAccesoData> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<String>? syncError,
    Expression<int>? syncIntentos,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? syncedAt,
    Expression<String>? sitioId,
    Expression<String>? registradoPor,
    Expression<String>? visitanteLocalId,
    Expression<String>? nombreCompleto,
    Expression<String>? empresaProcedencia,
    Expression<String>? telefono,
    Expression<String>? personaVisitadaId,
    Expression<String>? personaVisitadaTexto,
    Expression<String>? asunto,
    Expression<bool>? ingresaVehiculo,
    Expression<String>? placas,
    Expression<String>? vehiculoMarca,
    Expression<String>? vehiculoModelo,
    Expression<String>? vehiculoColor,
    Expression<String>? identificacionTipo,
    Expression<String>? identificacionRutaLocal,
    Expression<String>? identificacionUrl,
    Expression<String>? avisoPrivacidadId,
    Expression<bool>? avisoAceptado,
    Expression<DateTime>? avisoAceptadoAt,
    Expression<DateTime>? horaEntrada,
    Expression<DateTime>? horaSalida,
    Expression<String>? salidaRegistradaPor,
    Expression<String>? observaciones,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncError != null) 'sync_error': syncError,
      if (syncIntentos != null) 'sync_intentos': syncIntentos,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (sitioId != null) 'sitio_id': sitioId,
      if (registradoPor != null) 'registrado_por': registradoPor,
      if (visitanteLocalId != null) 'visitante_local_id': visitanteLocalId,
      if (nombreCompleto != null) 'nombre_completo': nombreCompleto,
      if (empresaProcedencia != null) 'empresa_procedencia': empresaProcedencia,
      if (telefono != null) 'telefono': telefono,
      if (personaVisitadaId != null) 'persona_visitada_id': personaVisitadaId,
      if (personaVisitadaTexto != null)
        'persona_visitada_texto': personaVisitadaTexto,
      if (asunto != null) 'asunto': asunto,
      if (ingresaVehiculo != null) 'ingresa_vehiculo': ingresaVehiculo,
      if (placas != null) 'placas': placas,
      if (vehiculoMarca != null) 'vehiculo_marca': vehiculoMarca,
      if (vehiculoModelo != null) 'vehiculo_modelo': vehiculoModelo,
      if (vehiculoColor != null) 'vehiculo_color': vehiculoColor,
      if (identificacionTipo != null) 'identificacion_tipo': identificacionTipo,
      if (identificacionRutaLocal != null)
        'identificacion_ruta_local': identificacionRutaLocal,
      if (identificacionUrl != null) 'identificacion_url': identificacionUrl,
      if (avisoPrivacidadId != null) 'aviso_privacidad_id': avisoPrivacidadId,
      if (avisoAceptado != null) 'aviso_aceptado': avisoAceptado,
      if (avisoAceptadoAt != null) 'aviso_aceptado_at': avisoAceptadoAt,
      if (horaEntrada != null) 'hora_entrada': horaEntrada,
      if (horaSalida != null) 'hora_salida': horaSalida,
      if (salidaRegistradaPor != null)
        'salida_registrada_por': salidaRegistradaPor,
      if (observaciones != null) 'observaciones': observaciones,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalRegistrosAccesoCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<String>? syncError,
    Value<int>? syncIntentos,
    Value<String>? deviceId,
    Value<DateTime>? createdAtLocal,
    Value<DateTime>? updatedAtLocal,
    Value<DateTime?>? syncedAt,
    Value<String>? sitioId,
    Value<String>? registradoPor,
    Value<String?>? visitanteLocalId,
    Value<String>? nombreCompleto,
    Value<String>? empresaProcedencia,
    Value<String>? telefono,
    Value<String?>? personaVisitadaId,
    Value<String>? personaVisitadaTexto,
    Value<String>? asunto,
    Value<bool>? ingresaVehiculo,
    Value<String>? placas,
    Value<String>? vehiculoMarca,
    Value<String>? vehiculoModelo,
    Value<String>? vehiculoColor,
    Value<String>? identificacionTipo,
    Value<String?>? identificacionRutaLocal,
    Value<String?>? identificacionUrl,
    Value<String?>? avisoPrivacidadId,
    Value<bool>? avisoAceptado,
    Value<DateTime?>? avisoAceptadoAt,
    Value<DateTime>? horaEntrada,
    Value<DateTime?>? horaSalida,
    Value<String?>? salidaRegistradaPor,
    Value<String>? observaciones,
    Value<int>? rowid,
  }) {
    return LocalRegistrosAccesoCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError ?? this.syncError,
      syncIntentos: syncIntentos ?? this.syncIntentos,
      deviceId: deviceId ?? this.deviceId,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      syncedAt: syncedAt ?? this.syncedAt,
      sitioId: sitioId ?? this.sitioId,
      registradoPor: registradoPor ?? this.registradoPor,
      visitanteLocalId: visitanteLocalId ?? this.visitanteLocalId,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      empresaProcedencia: empresaProcedencia ?? this.empresaProcedencia,
      telefono: telefono ?? this.telefono,
      personaVisitadaId: personaVisitadaId ?? this.personaVisitadaId,
      personaVisitadaTexto: personaVisitadaTexto ?? this.personaVisitadaTexto,
      asunto: asunto ?? this.asunto,
      ingresaVehiculo: ingresaVehiculo ?? this.ingresaVehiculo,
      placas: placas ?? this.placas,
      vehiculoMarca: vehiculoMarca ?? this.vehiculoMarca,
      vehiculoModelo: vehiculoModelo ?? this.vehiculoModelo,
      vehiculoColor: vehiculoColor ?? this.vehiculoColor,
      identificacionTipo: identificacionTipo ?? this.identificacionTipo,
      identificacionRutaLocal:
          identificacionRutaLocal ?? this.identificacionRutaLocal,
      identificacionUrl: identificacionUrl ?? this.identificacionUrl,
      avisoPrivacidadId: avisoPrivacidadId ?? this.avisoPrivacidadId,
      avisoAceptado: avisoAceptado ?? this.avisoAceptado,
      avisoAceptadoAt: avisoAceptadoAt ?? this.avisoAceptadoAt,
      horaEntrada: horaEntrada ?? this.horaEntrada,
      horaSalida: horaSalida ?? this.horaSalida,
      salidaRegistradaPor: salidaRegistradaPor ?? this.salidaRegistradaPor,
      observaciones: observaciones ?? this.observaciones,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (syncIntentos.present) {
      map['sync_intentos'] = Variable<int>(syncIntentos.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (sitioId.present) {
      map['sitio_id'] = Variable<String>(sitioId.value);
    }
    if (registradoPor.present) {
      map['registrado_por'] = Variable<String>(registradoPor.value);
    }
    if (visitanteLocalId.present) {
      map['visitante_local_id'] = Variable<String>(visitanteLocalId.value);
    }
    if (nombreCompleto.present) {
      map['nombre_completo'] = Variable<String>(nombreCompleto.value);
    }
    if (empresaProcedencia.present) {
      map['empresa_procedencia'] = Variable<String>(empresaProcedencia.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (personaVisitadaId.present) {
      map['persona_visitada_id'] = Variable<String>(personaVisitadaId.value);
    }
    if (personaVisitadaTexto.present) {
      map['persona_visitada_texto'] = Variable<String>(
        personaVisitadaTexto.value,
      );
    }
    if (asunto.present) {
      map['asunto'] = Variable<String>(asunto.value);
    }
    if (ingresaVehiculo.present) {
      map['ingresa_vehiculo'] = Variable<bool>(ingresaVehiculo.value);
    }
    if (placas.present) {
      map['placas'] = Variable<String>(placas.value);
    }
    if (vehiculoMarca.present) {
      map['vehiculo_marca'] = Variable<String>(vehiculoMarca.value);
    }
    if (vehiculoModelo.present) {
      map['vehiculo_modelo'] = Variable<String>(vehiculoModelo.value);
    }
    if (vehiculoColor.present) {
      map['vehiculo_color'] = Variable<String>(vehiculoColor.value);
    }
    if (identificacionTipo.present) {
      map['identificacion_tipo'] = Variable<String>(identificacionTipo.value);
    }
    if (identificacionRutaLocal.present) {
      map['identificacion_ruta_local'] = Variable<String>(
        identificacionRutaLocal.value,
      );
    }
    if (identificacionUrl.present) {
      map['identificacion_url'] = Variable<String>(identificacionUrl.value);
    }
    if (avisoPrivacidadId.present) {
      map['aviso_privacidad_id'] = Variable<String>(avisoPrivacidadId.value);
    }
    if (avisoAceptado.present) {
      map['aviso_aceptado'] = Variable<bool>(avisoAceptado.value);
    }
    if (avisoAceptadoAt.present) {
      map['aviso_aceptado_at'] = Variable<DateTime>(avisoAceptadoAt.value);
    }
    if (horaEntrada.present) {
      map['hora_entrada'] = Variable<DateTime>(horaEntrada.value);
    }
    if (horaSalida.present) {
      map['hora_salida'] = Variable<DateTime>(horaSalida.value);
    }
    if (salidaRegistradaPor.present) {
      map['salida_registrada_por'] = Variable<String>(
        salidaRegistradaPor.value,
      );
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRegistrosAccesoCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('sitioId: $sitioId, ')
          ..write('registradoPor: $registradoPor, ')
          ..write('visitanteLocalId: $visitanteLocalId, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('empresaProcedencia: $empresaProcedencia, ')
          ..write('telefono: $telefono, ')
          ..write('personaVisitadaId: $personaVisitadaId, ')
          ..write('personaVisitadaTexto: $personaVisitadaTexto, ')
          ..write('asunto: $asunto, ')
          ..write('ingresaVehiculo: $ingresaVehiculo, ')
          ..write('placas: $placas, ')
          ..write('vehiculoMarca: $vehiculoMarca, ')
          ..write('vehiculoModelo: $vehiculoModelo, ')
          ..write('vehiculoColor: $vehiculoColor, ')
          ..write('identificacionTipo: $identificacionTipo, ')
          ..write('identificacionRutaLocal: $identificacionRutaLocal, ')
          ..write('identificacionUrl: $identificacionUrl, ')
          ..write('avisoPrivacidadId: $avisoPrivacidadId, ')
          ..write('avisoAceptado: $avisoAceptado, ')
          ..write('avisoAceptadoAt: $avisoAceptadoAt, ')
          ..write('horaEntrada: $horaEntrada, ')
          ..write('horaSalida: $horaSalida, ')
          ..write('salidaRegistradaPor: $salidaRegistradaPor, ')
          ..write('observaciones: $observaciones, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVisitantesTable extends LocalVisitantes
    with TableInfo<$LocalVisitantesTable, LocalVisitante> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVisitantesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncIntentosMeta = const VerificationMeta(
    'syncIntentos',
  );
  @override
  late final GeneratedColumn<int> syncIntentos = GeneratedColumn<int>(
    'sync_intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtLocalMeta = const VerificationMeta(
    'createdAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>(
        'created_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreCompletoMeta = const VerificationMeta(
    'nombreCompleto',
  );
  @override
  late final GeneratedColumn<String> nombreCompleto = GeneratedColumn<String>(
    'nombre_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _empresaMeta = const VerificationMeta(
    'empresa',
  );
  @override
  late final GeneratedColumn<String> empresa = GeneratedColumn<String>(
    'empresa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _placasHabitualesMeta = const VerificationMeta(
    'placasHabituales',
  );
  @override
  late final GeneratedColumn<String> placasHabituales = GeneratedColumn<String>(
    'placas_habituales',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _esFrecuenteMeta = const VerificationMeta(
    'esFrecuente',
  );
  @override
  late final GeneratedColumn<bool> esFrecuente = GeneratedColumn<bool>(
    'es_frecuente',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_frecuente" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _vetadoMeta = const VerificationMeta('vetado');
  @override
  late final GeneratedColumn<bool> vetado = GeneratedColumn<bool>(
    'vetado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vetado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _motivoVetoMeta = const VerificationMeta(
    'motivoVeto',
  );
  @override
  late final GeneratedColumn<String> motivoVeto = GeneratedColumn<String>(
    'motivo_veto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _vecesRegistradoMeta = const VerificationMeta(
    'vecesRegistrado',
  );
  @override
  late final GeneratedColumn<int> vecesRegistrado = GeneratedColumn<int>(
    'veces_registrado',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ultimaVisitaAtMeta = const VerificationMeta(
    'ultimaVisitaAt',
  );
  @override
  late final GeneratedColumn<DateTime> ultimaVisitaAt =
      GeneratedColumn<DateTime>(
        'ultima_visita_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    nombreCompleto,
    empresa,
    telefono,
    placasHabituales,
    notas,
    esFrecuente,
    vetado,
    motivoVeto,
    vecesRegistrado,
    ultimaVisitaAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_visitantes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVisitante> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('sync_intentos')) {
      context.handle(
        _syncIntentosMeta,
        syncIntentos.isAcceptableOrUnknown(
          data['sync_intentos']!,
          _syncIntentosMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
        _createdAtLocalMeta,
        createdAtLocal.isAcceptableOrUnknown(
          data['created_at_local']!,
          _createdAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('nombre_completo')) {
      context.handle(
        _nombreCompletoMeta,
        nombreCompleto.isAcceptableOrUnknown(
          data['nombre_completo']!,
          _nombreCompletoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreCompletoMeta);
    }
    if (data.containsKey('empresa')) {
      context.handle(
        _empresaMeta,
        empresa.isAcceptableOrUnknown(data['empresa']!, _empresaMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('placas_habituales')) {
      context.handle(
        _placasHabitualesMeta,
        placasHabituales.isAcceptableOrUnknown(
          data['placas_habituales']!,
          _placasHabitualesMeta,
        ),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('es_frecuente')) {
      context.handle(
        _esFrecuenteMeta,
        esFrecuente.isAcceptableOrUnknown(
          data['es_frecuente']!,
          _esFrecuenteMeta,
        ),
      );
    }
    if (data.containsKey('vetado')) {
      context.handle(
        _vetadoMeta,
        vetado.isAcceptableOrUnknown(data['vetado']!, _vetadoMeta),
      );
    }
    if (data.containsKey('motivo_veto')) {
      context.handle(
        _motivoVetoMeta,
        motivoVeto.isAcceptableOrUnknown(data['motivo_veto']!, _motivoVetoMeta),
      );
    }
    if (data.containsKey('veces_registrado')) {
      context.handle(
        _vecesRegistradoMeta,
        vecesRegistrado.isAcceptableOrUnknown(
          data['veces_registrado']!,
          _vecesRegistradoMeta,
        ),
      );
    }
    if (data.containsKey('ultima_visita_at')) {
      context.handle(
        _ultimaVisitaAtMeta,
        ultimaVisitaAt.isAcceptableOrUnknown(
          data['ultima_visita_at']!,
          _ultimaVisitaAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalVisitante map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVisitante(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      )!,
      syncIntentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_intentos'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      nombreCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_completo'],
      )!,
      empresa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
      placasHabituales: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placas_habituales'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      )!,
      esFrecuente: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_frecuente'],
      )!,
      vetado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vetado'],
      )!,
      motivoVeto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo_veto'],
      )!,
      vecesRegistrado: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}veces_registrado'],
      )!,
      ultimaVisitaAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ultima_visita_at'],
      ),
    );
  }

  @override
  $LocalVisitantesTable createAlias(String alias) {
    return $LocalVisitantesTable(attachedDatabase, alias);
  }
}

class LocalVisitante extends DataClass implements Insertable<LocalVisitante> {
  final String localId;

  /// UUID que asignó Supabase. Nulo mientras no se haya sincronizado.
  final String? remoteId;

  /// pendiente | sincronizando | sincronizado | fallido
  final String syncStatus;
  final String syncError;

  /// Se pausan los reintentos al llegar al máximo para no quemar batería
  /// reintentando algo que falla por una razón que no se va a resolver sola
  /// (por ejemplo, violar un CHECK del servidor).
  final int syncIntentos;
  final String deviceId;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? syncedAt;
  final String nombreCompleto;
  final String empresa;
  final String telefono;
  final String placasHabituales;
  final String notas;
  final bool esFrecuente;
  final bool vetado;
  final String motivoVeto;
  final int vecesRegistrado;
  final DateTime? ultimaVisitaAt;
  const LocalVisitante({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.syncError,
    required this.syncIntentos,
    required this.deviceId,
    required this.createdAtLocal,
    required this.updatedAtLocal,
    this.syncedAt,
    required this.nombreCompleto,
    required this.empresa,
    required this.telefono,
    required this.placasHabituales,
    required this.notas,
    required this.esFrecuente,
    required this.vetado,
    required this.motivoVeto,
    required this.vecesRegistrado,
    this.ultimaVisitaAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_error'] = Variable<String>(syncError);
    map['sync_intentos'] = Variable<int>(syncIntentos);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['nombre_completo'] = Variable<String>(nombreCompleto);
    map['empresa'] = Variable<String>(empresa);
    map['telefono'] = Variable<String>(telefono);
    map['placas_habituales'] = Variable<String>(placasHabituales);
    map['notas'] = Variable<String>(notas);
    map['es_frecuente'] = Variable<bool>(esFrecuente);
    map['vetado'] = Variable<bool>(vetado);
    map['motivo_veto'] = Variable<String>(motivoVeto);
    map['veces_registrado'] = Variable<int>(vecesRegistrado);
    if (!nullToAbsent || ultimaVisitaAt != null) {
      map['ultima_visita_at'] = Variable<DateTime>(ultimaVisitaAt);
    }
    return map;
  }

  LocalVisitantesCompanion toCompanion(bool nullToAbsent) {
    return LocalVisitantesCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      syncError: Value(syncError),
      syncIntentos: Value(syncIntentos),
      deviceId: Value(deviceId),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      nombreCompleto: Value(nombreCompleto),
      empresa: Value(empresa),
      telefono: Value(telefono),
      placasHabituales: Value(placasHabituales),
      notas: Value(notas),
      esFrecuente: Value(esFrecuente),
      vetado: Value(vetado),
      motivoVeto: Value(motivoVeto),
      vecesRegistrado: Value(vecesRegistrado),
      ultimaVisitaAt: ultimaVisitaAt == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimaVisitaAt),
    );
  }

  factory LocalVisitante.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVisitante(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncError: serializer.fromJson<String>(json['syncError']),
      syncIntentos: serializer.fromJson<int>(json['syncIntentos']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAtLocal: serializer.fromJson<DateTime>(json['createdAtLocal']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updatedAtLocal']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      nombreCompleto: serializer.fromJson<String>(json['nombreCompleto']),
      empresa: serializer.fromJson<String>(json['empresa']),
      telefono: serializer.fromJson<String>(json['telefono']),
      placasHabituales: serializer.fromJson<String>(json['placasHabituales']),
      notas: serializer.fromJson<String>(json['notas']),
      esFrecuente: serializer.fromJson<bool>(json['esFrecuente']),
      vetado: serializer.fromJson<bool>(json['vetado']),
      motivoVeto: serializer.fromJson<String>(json['motivoVeto']),
      vecesRegistrado: serializer.fromJson<int>(json['vecesRegistrado']),
      ultimaVisitaAt: serializer.fromJson<DateTime?>(json['ultimaVisitaAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncError': serializer.toJson<String>(syncError),
      'syncIntentos': serializer.toJson<int>(syncIntentos),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAtLocal': serializer.toJson<DateTime>(createdAtLocal),
      'updatedAtLocal': serializer.toJson<DateTime>(updatedAtLocal),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'nombreCompleto': serializer.toJson<String>(nombreCompleto),
      'empresa': serializer.toJson<String>(empresa),
      'telefono': serializer.toJson<String>(telefono),
      'placasHabituales': serializer.toJson<String>(placasHabituales),
      'notas': serializer.toJson<String>(notas),
      'esFrecuente': serializer.toJson<bool>(esFrecuente),
      'vetado': serializer.toJson<bool>(vetado),
      'motivoVeto': serializer.toJson<String>(motivoVeto),
      'vecesRegistrado': serializer.toJson<int>(vecesRegistrado),
      'ultimaVisitaAt': serializer.toJson<DateTime?>(ultimaVisitaAt),
    };
  }

  LocalVisitante copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    String? syncError,
    int? syncIntentos,
    String? deviceId,
    DateTime? createdAtLocal,
    DateTime? updatedAtLocal,
    Value<DateTime?> syncedAt = const Value.absent(),
    String? nombreCompleto,
    String? empresa,
    String? telefono,
    String? placasHabituales,
    String? notas,
    bool? esFrecuente,
    bool? vetado,
    String? motivoVeto,
    int? vecesRegistrado,
    Value<DateTime?> ultimaVisitaAt = const Value.absent(),
  }) => LocalVisitante(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncError: syncError ?? this.syncError,
    syncIntentos: syncIntentos ?? this.syncIntentos,
    deviceId: deviceId ?? this.deviceId,
    createdAtLocal: createdAtLocal ?? this.createdAtLocal,
    updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    nombreCompleto: nombreCompleto ?? this.nombreCompleto,
    empresa: empresa ?? this.empresa,
    telefono: telefono ?? this.telefono,
    placasHabituales: placasHabituales ?? this.placasHabituales,
    notas: notas ?? this.notas,
    esFrecuente: esFrecuente ?? this.esFrecuente,
    vetado: vetado ?? this.vetado,
    motivoVeto: motivoVeto ?? this.motivoVeto,
    vecesRegistrado: vecesRegistrado ?? this.vecesRegistrado,
    ultimaVisitaAt: ultimaVisitaAt.present
        ? ultimaVisitaAt.value
        : this.ultimaVisitaAt,
  );
  LocalVisitante copyWithCompanion(LocalVisitantesCompanion data) {
    return LocalVisitante(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      syncIntentos: data.syncIntentos.present
          ? data.syncIntentos.value
          : this.syncIntentos,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      nombreCompleto: data.nombreCompleto.present
          ? data.nombreCompleto.value
          : this.nombreCompleto,
      empresa: data.empresa.present ? data.empresa.value : this.empresa,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      placasHabituales: data.placasHabituales.present
          ? data.placasHabituales.value
          : this.placasHabituales,
      notas: data.notas.present ? data.notas.value : this.notas,
      esFrecuente: data.esFrecuente.present
          ? data.esFrecuente.value
          : this.esFrecuente,
      vetado: data.vetado.present ? data.vetado.value : this.vetado,
      motivoVeto: data.motivoVeto.present
          ? data.motivoVeto.value
          : this.motivoVeto,
      vecesRegistrado: data.vecesRegistrado.present
          ? data.vecesRegistrado.value
          : this.vecesRegistrado,
      ultimaVisitaAt: data.ultimaVisitaAt.present
          ? data.ultimaVisitaAt.value
          : this.ultimaVisitaAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitante(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('empresa: $empresa, ')
          ..write('telefono: $telefono, ')
          ..write('placasHabituales: $placasHabituales, ')
          ..write('notas: $notas, ')
          ..write('esFrecuente: $esFrecuente, ')
          ..write('vetado: $vetado, ')
          ..write('motivoVeto: $motivoVeto, ')
          ..write('vecesRegistrado: $vecesRegistrado, ')
          ..write('ultimaVisitaAt: $ultimaVisitaAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    nombreCompleto,
    empresa,
    telefono,
    placasHabituales,
    notas,
    esFrecuente,
    vetado,
    motivoVeto,
    vecesRegistrado,
    ultimaVisitaAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVisitante &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.syncError == this.syncError &&
          other.syncIntentos == this.syncIntentos &&
          other.deviceId == this.deviceId &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.syncedAt == this.syncedAt &&
          other.nombreCompleto == this.nombreCompleto &&
          other.empresa == this.empresa &&
          other.telefono == this.telefono &&
          other.placasHabituales == this.placasHabituales &&
          other.notas == this.notas &&
          other.esFrecuente == this.esFrecuente &&
          other.vetado == this.vetado &&
          other.motivoVeto == this.motivoVeto &&
          other.vecesRegistrado == this.vecesRegistrado &&
          other.ultimaVisitaAt == this.ultimaVisitaAt);
}

class LocalVisitantesCompanion extends UpdateCompanion<LocalVisitante> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<String> syncError;
  final Value<int> syncIntentos;
  final Value<String> deviceId;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> syncedAt;
  final Value<String> nombreCompleto;
  final Value<String> empresa;
  final Value<String> telefono;
  final Value<String> placasHabituales;
  final Value<String> notas;
  final Value<bool> esFrecuente;
  final Value<bool> vetado;
  final Value<String> motivoVeto;
  final Value<int> vecesRegistrado;
  final Value<DateTime?> ultimaVisitaAt;
  final Value<int> rowid;
  const LocalVisitantesCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.nombreCompleto = const Value.absent(),
    this.empresa = const Value.absent(),
    this.telefono = const Value.absent(),
    this.placasHabituales = const Value.absent(),
    this.notas = const Value.absent(),
    this.esFrecuente = const Value.absent(),
    this.vetado = const Value.absent(),
    this.motivoVeto = const Value.absent(),
    this.vecesRegistrado = const Value.absent(),
    this.ultimaVisitaAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVisitantesCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String nombreCompleto,
    this.empresa = const Value.absent(),
    this.telefono = const Value.absent(),
    this.placasHabituales = const Value.absent(),
    this.notas = const Value.absent(),
    this.esFrecuente = const Value.absent(),
    this.vetado = const Value.absent(),
    this.motivoVeto = const Value.absent(),
    this.vecesRegistrado = const Value.absent(),
    this.ultimaVisitaAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : nombreCompleto = Value(nombreCompleto);
  static Insertable<LocalVisitante> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<String>? syncError,
    Expression<int>? syncIntentos,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? syncedAt,
    Expression<String>? nombreCompleto,
    Expression<String>? empresa,
    Expression<String>? telefono,
    Expression<String>? placasHabituales,
    Expression<String>? notas,
    Expression<bool>? esFrecuente,
    Expression<bool>? vetado,
    Expression<String>? motivoVeto,
    Expression<int>? vecesRegistrado,
    Expression<DateTime>? ultimaVisitaAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncError != null) 'sync_error': syncError,
      if (syncIntentos != null) 'sync_intentos': syncIntentos,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (nombreCompleto != null) 'nombre_completo': nombreCompleto,
      if (empresa != null) 'empresa': empresa,
      if (telefono != null) 'telefono': telefono,
      if (placasHabituales != null) 'placas_habituales': placasHabituales,
      if (notas != null) 'notas': notas,
      if (esFrecuente != null) 'es_frecuente': esFrecuente,
      if (vetado != null) 'vetado': vetado,
      if (motivoVeto != null) 'motivo_veto': motivoVeto,
      if (vecesRegistrado != null) 'veces_registrado': vecesRegistrado,
      if (ultimaVisitaAt != null) 'ultima_visita_at': ultimaVisitaAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVisitantesCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<String>? syncError,
    Value<int>? syncIntentos,
    Value<String>? deviceId,
    Value<DateTime>? createdAtLocal,
    Value<DateTime>? updatedAtLocal,
    Value<DateTime?>? syncedAt,
    Value<String>? nombreCompleto,
    Value<String>? empresa,
    Value<String>? telefono,
    Value<String>? placasHabituales,
    Value<String>? notas,
    Value<bool>? esFrecuente,
    Value<bool>? vetado,
    Value<String>? motivoVeto,
    Value<int>? vecesRegistrado,
    Value<DateTime?>? ultimaVisitaAt,
    Value<int>? rowid,
  }) {
    return LocalVisitantesCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError ?? this.syncError,
      syncIntentos: syncIntentos ?? this.syncIntentos,
      deviceId: deviceId ?? this.deviceId,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      syncedAt: syncedAt ?? this.syncedAt,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      empresa: empresa ?? this.empresa,
      telefono: telefono ?? this.telefono,
      placasHabituales: placasHabituales ?? this.placasHabituales,
      notas: notas ?? this.notas,
      esFrecuente: esFrecuente ?? this.esFrecuente,
      vetado: vetado ?? this.vetado,
      motivoVeto: motivoVeto ?? this.motivoVeto,
      vecesRegistrado: vecesRegistrado ?? this.vecesRegistrado,
      ultimaVisitaAt: ultimaVisitaAt ?? this.ultimaVisitaAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (syncIntentos.present) {
      map['sync_intentos'] = Variable<int>(syncIntentos.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (nombreCompleto.present) {
      map['nombre_completo'] = Variable<String>(nombreCompleto.value);
    }
    if (empresa.present) {
      map['empresa'] = Variable<String>(empresa.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (placasHabituales.present) {
      map['placas_habituales'] = Variable<String>(placasHabituales.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (esFrecuente.present) {
      map['es_frecuente'] = Variable<bool>(esFrecuente.value);
    }
    if (vetado.present) {
      map['vetado'] = Variable<bool>(vetado.value);
    }
    if (motivoVeto.present) {
      map['motivo_veto'] = Variable<String>(motivoVeto.value);
    }
    if (vecesRegistrado.present) {
      map['veces_registrado'] = Variable<int>(vecesRegistrado.value);
    }
    if (ultimaVisitaAt.present) {
      map['ultima_visita_at'] = Variable<DateTime>(ultimaVisitaAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitantesCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('empresa: $empresa, ')
          ..write('telefono: $telefono, ')
          ..write('placasHabituales: $placasHabituales, ')
          ..write('notas: $notas, ')
          ..write('esFrecuente: $esFrecuente, ')
          ..write('vetado: $vetado, ')
          ..write('motivoVeto: $motivoVeto, ')
          ..write('vecesRegistrado: $vecesRegistrado, ')
          ..write('ultimaVisitaAt: $ultimaVisitaAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalBitacoraEventosTable extends LocalBitacoraEventos
    with TableInfo<$LocalBitacoraEventosTable, LocalBitacoraEvento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalBitacoraEventosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncIntentosMeta = const VerificationMeta(
    'syncIntentos',
  );
  @override
  late final GeneratedColumn<int> syncIntentos = GeneratedColumn<int>(
    'sync_intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtLocalMeta = const VerificationMeta(
    'createdAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>(
        'created_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sitioIdMeta = const VerificationMeta(
    'sitioId',
  );
  @override
  late final GeneratedColumn<String> sitioId = GeneratedColumn<String>(
    'sitio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registradoPorMeta = const VerificationMeta(
    'registradoPor',
  );
  @override
  late final GeneratedColumn<String> registradoPor = GeneratedColumn<String>(
    'registrado_por',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnoFechaMeta = const VerificationMeta(
    'turnoFecha',
  );
  @override
  late final GeneratedColumn<DateTime> turnoFecha = GeneratedColumn<DateTime>(
    'turno_fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ocurridoAtMeta = const VerificationMeta(
    'ocurridoAt',
  );
  @override
  late final GeneratedColumn<DateTime> ocurridoAt = GeneratedColumn<DateTime>(
    'ocurrido_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placasMeta = const VerificationMeta('placas');
  @override
  late final GeneratedColumn<String> placas = GeneratedColumn<String>(
    'placas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _transportistaMeta = const VerificationMeta(
    'transportista',
  );
  @override
  late final GeneratedColumn<String> transportista = GeneratedColumn<String>(
    'transportista',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _empresaTransporteMeta = const VerificationMeta(
    'empresaTransporte',
  );
  @override
  late final GeneratedColumn<String> empresaTransporte =
      GeneratedColumn<String>(
        'empresa_transporte',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _numDocumentoMeta = const VerificationMeta(
    'numDocumento',
  );
  @override
  late final GeneratedColumn<String> numDocumento = GeneratedColumn<String>(
    'num_documento',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _destinoMeta = const VerificationMeta(
    'destino',
  );
  @override
  late final GeneratedColumn<String> destino = GeneratedColumn<String>(
    'destino',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _autorizadoPorIdMeta = const VerificationMeta(
    'autorizadoPorId',
  );
  @override
  late final GeneratedColumn<String> autorizadoPorId = GeneratedColumn<String>(
    'autorizado_por_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autorizadoPorTextoMeta =
      const VerificationMeta('autorizadoPorTexto');
  @override
  late final GeneratedColumn<String> autorizadoPorTexto =
      GeneratedColumn<String>(
        'autorizado_por_texto',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _prioridadMeta = const VerificationMeta(
    'prioridad',
  );
  @override
  late final GeneratedColumn<String> prioridad = GeneratedColumn<String>(
    'prioridad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _requiereSeguimientoMeta =
      const VerificationMeta('requiereSeguimiento');
  @override
  late final GeneratedColumn<bool> requiereSeguimiento = GeneratedColumn<bool>(
    'requiere_seguimiento',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requiere_seguimiento" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    sitioId,
    registradoPor,
    turnoFecha,
    tipo,
    ocurridoAt,
    descripcion,
    placas,
    transportista,
    empresaTransporte,
    numDocumento,
    destino,
    autorizadoPorId,
    autorizadoPorTexto,
    prioridad,
    requiereSeguimiento,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_bitacora_eventos';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalBitacoraEvento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('sync_intentos')) {
      context.handle(
        _syncIntentosMeta,
        syncIntentos.isAcceptableOrUnknown(
          data['sync_intentos']!,
          _syncIntentosMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
        _createdAtLocalMeta,
        createdAtLocal.isAcceptableOrUnknown(
          data['created_at_local']!,
          _createdAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('sitio_id')) {
      context.handle(
        _sitioIdMeta,
        sitioId.isAcceptableOrUnknown(data['sitio_id']!, _sitioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sitioIdMeta);
    }
    if (data.containsKey('registrado_por')) {
      context.handle(
        _registradoPorMeta,
        registradoPor.isAcceptableOrUnknown(
          data['registrado_por']!,
          _registradoPorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registradoPorMeta);
    }
    if (data.containsKey('turno_fecha')) {
      context.handle(
        _turnoFechaMeta,
        turnoFecha.isAcceptableOrUnknown(data['turno_fecha']!, _turnoFechaMeta),
      );
    } else if (isInserting) {
      context.missing(_turnoFechaMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('ocurrido_at')) {
      context.handle(
        _ocurridoAtMeta,
        ocurridoAt.isAcceptableOrUnknown(data['ocurrido_at']!, _ocurridoAtMeta),
      );
    } else if (isInserting) {
      context.missing(_ocurridoAtMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('placas')) {
      context.handle(
        _placasMeta,
        placas.isAcceptableOrUnknown(data['placas']!, _placasMeta),
      );
    }
    if (data.containsKey('transportista')) {
      context.handle(
        _transportistaMeta,
        transportista.isAcceptableOrUnknown(
          data['transportista']!,
          _transportistaMeta,
        ),
      );
    }
    if (data.containsKey('empresa_transporte')) {
      context.handle(
        _empresaTransporteMeta,
        empresaTransporte.isAcceptableOrUnknown(
          data['empresa_transporte']!,
          _empresaTransporteMeta,
        ),
      );
    }
    if (data.containsKey('num_documento')) {
      context.handle(
        _numDocumentoMeta,
        numDocumento.isAcceptableOrUnknown(
          data['num_documento']!,
          _numDocumentoMeta,
        ),
      );
    }
    if (data.containsKey('destino')) {
      context.handle(
        _destinoMeta,
        destino.isAcceptableOrUnknown(data['destino']!, _destinoMeta),
      );
    }
    if (data.containsKey('autorizado_por_id')) {
      context.handle(
        _autorizadoPorIdMeta,
        autorizadoPorId.isAcceptableOrUnknown(
          data['autorizado_por_id']!,
          _autorizadoPorIdMeta,
        ),
      );
    }
    if (data.containsKey('autorizado_por_texto')) {
      context.handle(
        _autorizadoPorTextoMeta,
        autorizadoPorTexto.isAcceptableOrUnknown(
          data['autorizado_por_texto']!,
          _autorizadoPorTextoMeta,
        ),
      );
    }
    if (data.containsKey('prioridad')) {
      context.handle(
        _prioridadMeta,
        prioridad.isAcceptableOrUnknown(data['prioridad']!, _prioridadMeta),
      );
    }
    if (data.containsKey('requiere_seguimiento')) {
      context.handle(
        _requiereSeguimientoMeta,
        requiereSeguimiento.isAcceptableOrUnknown(
          data['requiere_seguimiento']!,
          _requiereSeguimientoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalBitacoraEvento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBitacoraEvento(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      )!,
      syncIntentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_intentos'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      sitioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sitio_id'],
      )!,
      registradoPor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registrado_por'],
      )!,
      turnoFecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}turno_fecha'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      ocurridoAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ocurrido_at'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      placas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placas'],
      )!,
      transportista: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transportista'],
      )!,
      empresaTransporte: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa_transporte'],
      )!,
      numDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}num_documento'],
      )!,
      destino: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destino'],
      )!,
      autorizadoPorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}autorizado_por_id'],
      ),
      autorizadoPorTexto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}autorizado_por_texto'],
      )!,
      prioridad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prioridad'],
      )!,
      requiereSeguimiento: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requiere_seguimiento'],
      )!,
    );
  }

  @override
  $LocalBitacoraEventosTable createAlias(String alias) {
    return $LocalBitacoraEventosTable(attachedDatabase, alias);
  }
}

class LocalBitacoraEvento extends DataClass
    implements Insertable<LocalBitacoraEvento> {
  final String localId;

  /// UUID que asignó Supabase. Nulo mientras no se haya sincronizado.
  final String? remoteId;

  /// pendiente | sincronizando | sincronizado | fallido
  final String syncStatus;
  final String syncError;

  /// Se pausan los reintentos al llegar al máximo para no quemar batería
  /// reintentando algo que falla por una razón que no se va a resolver sola
  /// (por ejemplo, violar un CHECK del servidor).
  final int syncIntentos;
  final String deviceId;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? syncedAt;
  final String sitioId;
  final String registradoPor;
  final DateTime turnoFecha;
  final String tipo;
  final DateTime ocurridoAt;
  final String descripcion;
  final String placas;
  final String transportista;
  final String empresaTransporte;
  final String numDocumento;
  final String destino;
  final String? autorizadoPorId;
  final String autorizadoPorTexto;
  final String prioridad;
  final bool requiereSeguimiento;
  const LocalBitacoraEvento({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.syncError,
    required this.syncIntentos,
    required this.deviceId,
    required this.createdAtLocal,
    required this.updatedAtLocal,
    this.syncedAt,
    required this.sitioId,
    required this.registradoPor,
    required this.turnoFecha,
    required this.tipo,
    required this.ocurridoAt,
    required this.descripcion,
    required this.placas,
    required this.transportista,
    required this.empresaTransporte,
    required this.numDocumento,
    required this.destino,
    this.autorizadoPorId,
    required this.autorizadoPorTexto,
    required this.prioridad,
    required this.requiereSeguimiento,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_error'] = Variable<String>(syncError);
    map['sync_intentos'] = Variable<int>(syncIntentos);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['sitio_id'] = Variable<String>(sitioId);
    map['registrado_por'] = Variable<String>(registradoPor);
    map['turno_fecha'] = Variable<DateTime>(turnoFecha);
    map['tipo'] = Variable<String>(tipo);
    map['ocurrido_at'] = Variable<DateTime>(ocurridoAt);
    map['descripcion'] = Variable<String>(descripcion);
    map['placas'] = Variable<String>(placas);
    map['transportista'] = Variable<String>(transportista);
    map['empresa_transporte'] = Variable<String>(empresaTransporte);
    map['num_documento'] = Variable<String>(numDocumento);
    map['destino'] = Variable<String>(destino);
    if (!nullToAbsent || autorizadoPorId != null) {
      map['autorizado_por_id'] = Variable<String>(autorizadoPorId);
    }
    map['autorizado_por_texto'] = Variable<String>(autorizadoPorTexto);
    map['prioridad'] = Variable<String>(prioridad);
    map['requiere_seguimiento'] = Variable<bool>(requiereSeguimiento);
    return map;
  }

  LocalBitacoraEventosCompanion toCompanion(bool nullToAbsent) {
    return LocalBitacoraEventosCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      syncError: Value(syncError),
      syncIntentos: Value(syncIntentos),
      deviceId: Value(deviceId),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      sitioId: Value(sitioId),
      registradoPor: Value(registradoPor),
      turnoFecha: Value(turnoFecha),
      tipo: Value(tipo),
      ocurridoAt: Value(ocurridoAt),
      descripcion: Value(descripcion),
      placas: Value(placas),
      transportista: Value(transportista),
      empresaTransporte: Value(empresaTransporte),
      numDocumento: Value(numDocumento),
      destino: Value(destino),
      autorizadoPorId: autorizadoPorId == null && nullToAbsent
          ? const Value.absent()
          : Value(autorizadoPorId),
      autorizadoPorTexto: Value(autorizadoPorTexto),
      prioridad: Value(prioridad),
      requiereSeguimiento: Value(requiereSeguimiento),
    );
  }

  factory LocalBitacoraEvento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBitacoraEvento(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncError: serializer.fromJson<String>(json['syncError']),
      syncIntentos: serializer.fromJson<int>(json['syncIntentos']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAtLocal: serializer.fromJson<DateTime>(json['createdAtLocal']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updatedAtLocal']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      sitioId: serializer.fromJson<String>(json['sitioId']),
      registradoPor: serializer.fromJson<String>(json['registradoPor']),
      turnoFecha: serializer.fromJson<DateTime>(json['turnoFecha']),
      tipo: serializer.fromJson<String>(json['tipo']),
      ocurridoAt: serializer.fromJson<DateTime>(json['ocurridoAt']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      placas: serializer.fromJson<String>(json['placas']),
      transportista: serializer.fromJson<String>(json['transportista']),
      empresaTransporte: serializer.fromJson<String>(json['empresaTransporte']),
      numDocumento: serializer.fromJson<String>(json['numDocumento']),
      destino: serializer.fromJson<String>(json['destino']),
      autorizadoPorId: serializer.fromJson<String?>(json['autorizadoPorId']),
      autorizadoPorTexto: serializer.fromJson<String>(
        json['autorizadoPorTexto'],
      ),
      prioridad: serializer.fromJson<String>(json['prioridad']),
      requiereSeguimiento: serializer.fromJson<bool>(
        json['requiereSeguimiento'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncError': serializer.toJson<String>(syncError),
      'syncIntentos': serializer.toJson<int>(syncIntentos),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAtLocal': serializer.toJson<DateTime>(createdAtLocal),
      'updatedAtLocal': serializer.toJson<DateTime>(updatedAtLocal),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'sitioId': serializer.toJson<String>(sitioId),
      'registradoPor': serializer.toJson<String>(registradoPor),
      'turnoFecha': serializer.toJson<DateTime>(turnoFecha),
      'tipo': serializer.toJson<String>(tipo),
      'ocurridoAt': serializer.toJson<DateTime>(ocurridoAt),
      'descripcion': serializer.toJson<String>(descripcion),
      'placas': serializer.toJson<String>(placas),
      'transportista': serializer.toJson<String>(transportista),
      'empresaTransporte': serializer.toJson<String>(empresaTransporte),
      'numDocumento': serializer.toJson<String>(numDocumento),
      'destino': serializer.toJson<String>(destino),
      'autorizadoPorId': serializer.toJson<String?>(autorizadoPorId),
      'autorizadoPorTexto': serializer.toJson<String>(autorizadoPorTexto),
      'prioridad': serializer.toJson<String>(prioridad),
      'requiereSeguimiento': serializer.toJson<bool>(requiereSeguimiento),
    };
  }

  LocalBitacoraEvento copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    String? syncError,
    int? syncIntentos,
    String? deviceId,
    DateTime? createdAtLocal,
    DateTime? updatedAtLocal,
    Value<DateTime?> syncedAt = const Value.absent(),
    String? sitioId,
    String? registradoPor,
    DateTime? turnoFecha,
    String? tipo,
    DateTime? ocurridoAt,
    String? descripcion,
    String? placas,
    String? transportista,
    String? empresaTransporte,
    String? numDocumento,
    String? destino,
    Value<String?> autorizadoPorId = const Value.absent(),
    String? autorizadoPorTexto,
    String? prioridad,
    bool? requiereSeguimiento,
  }) => LocalBitacoraEvento(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncError: syncError ?? this.syncError,
    syncIntentos: syncIntentos ?? this.syncIntentos,
    deviceId: deviceId ?? this.deviceId,
    createdAtLocal: createdAtLocal ?? this.createdAtLocal,
    updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    sitioId: sitioId ?? this.sitioId,
    registradoPor: registradoPor ?? this.registradoPor,
    turnoFecha: turnoFecha ?? this.turnoFecha,
    tipo: tipo ?? this.tipo,
    ocurridoAt: ocurridoAt ?? this.ocurridoAt,
    descripcion: descripcion ?? this.descripcion,
    placas: placas ?? this.placas,
    transportista: transportista ?? this.transportista,
    empresaTransporte: empresaTransporte ?? this.empresaTransporte,
    numDocumento: numDocumento ?? this.numDocumento,
    destino: destino ?? this.destino,
    autorizadoPorId: autorizadoPorId.present
        ? autorizadoPorId.value
        : this.autorizadoPorId,
    autorizadoPorTexto: autorizadoPorTexto ?? this.autorizadoPorTexto,
    prioridad: prioridad ?? this.prioridad,
    requiereSeguimiento: requiereSeguimiento ?? this.requiereSeguimiento,
  );
  LocalBitacoraEvento copyWithCompanion(LocalBitacoraEventosCompanion data) {
    return LocalBitacoraEvento(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      syncIntentos: data.syncIntentos.present
          ? data.syncIntentos.value
          : this.syncIntentos,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      sitioId: data.sitioId.present ? data.sitioId.value : this.sitioId,
      registradoPor: data.registradoPor.present
          ? data.registradoPor.value
          : this.registradoPor,
      turnoFecha: data.turnoFecha.present
          ? data.turnoFecha.value
          : this.turnoFecha,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      ocurridoAt: data.ocurridoAt.present
          ? data.ocurridoAt.value
          : this.ocurridoAt,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      placas: data.placas.present ? data.placas.value : this.placas,
      transportista: data.transportista.present
          ? data.transportista.value
          : this.transportista,
      empresaTransporte: data.empresaTransporte.present
          ? data.empresaTransporte.value
          : this.empresaTransporte,
      numDocumento: data.numDocumento.present
          ? data.numDocumento.value
          : this.numDocumento,
      destino: data.destino.present ? data.destino.value : this.destino,
      autorizadoPorId: data.autorizadoPorId.present
          ? data.autorizadoPorId.value
          : this.autorizadoPorId,
      autorizadoPorTexto: data.autorizadoPorTexto.present
          ? data.autorizadoPorTexto.value
          : this.autorizadoPorTexto,
      prioridad: data.prioridad.present ? data.prioridad.value : this.prioridad,
      requiereSeguimiento: data.requiereSeguimiento.present
          ? data.requiereSeguimiento.value
          : this.requiereSeguimiento,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBitacoraEvento(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('sitioId: $sitioId, ')
          ..write('registradoPor: $registradoPor, ')
          ..write('turnoFecha: $turnoFecha, ')
          ..write('tipo: $tipo, ')
          ..write('ocurridoAt: $ocurridoAt, ')
          ..write('descripcion: $descripcion, ')
          ..write('placas: $placas, ')
          ..write('transportista: $transportista, ')
          ..write('empresaTransporte: $empresaTransporte, ')
          ..write('numDocumento: $numDocumento, ')
          ..write('destino: $destino, ')
          ..write('autorizadoPorId: $autorizadoPorId, ')
          ..write('autorizadoPorTexto: $autorizadoPorTexto, ')
          ..write('prioridad: $prioridad, ')
          ..write('requiereSeguimiento: $requiereSeguimiento')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    sitioId,
    registradoPor,
    turnoFecha,
    tipo,
    ocurridoAt,
    descripcion,
    placas,
    transportista,
    empresaTransporte,
    numDocumento,
    destino,
    autorizadoPorId,
    autorizadoPorTexto,
    prioridad,
    requiereSeguimiento,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBitacoraEvento &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.syncError == this.syncError &&
          other.syncIntentos == this.syncIntentos &&
          other.deviceId == this.deviceId &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.syncedAt == this.syncedAt &&
          other.sitioId == this.sitioId &&
          other.registradoPor == this.registradoPor &&
          other.turnoFecha == this.turnoFecha &&
          other.tipo == this.tipo &&
          other.ocurridoAt == this.ocurridoAt &&
          other.descripcion == this.descripcion &&
          other.placas == this.placas &&
          other.transportista == this.transportista &&
          other.empresaTransporte == this.empresaTransporte &&
          other.numDocumento == this.numDocumento &&
          other.destino == this.destino &&
          other.autorizadoPorId == this.autorizadoPorId &&
          other.autorizadoPorTexto == this.autorizadoPorTexto &&
          other.prioridad == this.prioridad &&
          other.requiereSeguimiento == this.requiereSeguimiento);
}

class LocalBitacoraEventosCompanion
    extends UpdateCompanion<LocalBitacoraEvento> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<String> syncError;
  final Value<int> syncIntentos;
  final Value<String> deviceId;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> syncedAt;
  final Value<String> sitioId;
  final Value<String> registradoPor;
  final Value<DateTime> turnoFecha;
  final Value<String> tipo;
  final Value<DateTime> ocurridoAt;
  final Value<String> descripcion;
  final Value<String> placas;
  final Value<String> transportista;
  final Value<String> empresaTransporte;
  final Value<String> numDocumento;
  final Value<String> destino;
  final Value<String?> autorizadoPorId;
  final Value<String> autorizadoPorTexto;
  final Value<String> prioridad;
  final Value<bool> requiereSeguimiento;
  final Value<int> rowid;
  const LocalBitacoraEventosCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.sitioId = const Value.absent(),
    this.registradoPor = const Value.absent(),
    this.turnoFecha = const Value.absent(),
    this.tipo = const Value.absent(),
    this.ocurridoAt = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.placas = const Value.absent(),
    this.transportista = const Value.absent(),
    this.empresaTransporte = const Value.absent(),
    this.numDocumento = const Value.absent(),
    this.destino = const Value.absent(),
    this.autorizadoPorId = const Value.absent(),
    this.autorizadoPorTexto = const Value.absent(),
    this.prioridad = const Value.absent(),
    this.requiereSeguimiento = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalBitacoraEventosCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String sitioId,
    required String registradoPor,
    required DateTime turnoFecha,
    required String tipo,
    required DateTime ocurridoAt,
    required String descripcion,
    this.placas = const Value.absent(),
    this.transportista = const Value.absent(),
    this.empresaTransporte = const Value.absent(),
    this.numDocumento = const Value.absent(),
    this.destino = const Value.absent(),
    this.autorizadoPorId = const Value.absent(),
    this.autorizadoPorTexto = const Value.absent(),
    this.prioridad = const Value.absent(),
    this.requiereSeguimiento = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sitioId = Value(sitioId),
       registradoPor = Value(registradoPor),
       turnoFecha = Value(turnoFecha),
       tipo = Value(tipo),
       ocurridoAt = Value(ocurridoAt),
       descripcion = Value(descripcion);
  static Insertable<LocalBitacoraEvento> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<String>? syncError,
    Expression<int>? syncIntentos,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? syncedAt,
    Expression<String>? sitioId,
    Expression<String>? registradoPor,
    Expression<DateTime>? turnoFecha,
    Expression<String>? tipo,
    Expression<DateTime>? ocurridoAt,
    Expression<String>? descripcion,
    Expression<String>? placas,
    Expression<String>? transportista,
    Expression<String>? empresaTransporte,
    Expression<String>? numDocumento,
    Expression<String>? destino,
    Expression<String>? autorizadoPorId,
    Expression<String>? autorizadoPorTexto,
    Expression<String>? prioridad,
    Expression<bool>? requiereSeguimiento,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncError != null) 'sync_error': syncError,
      if (syncIntentos != null) 'sync_intentos': syncIntentos,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (sitioId != null) 'sitio_id': sitioId,
      if (registradoPor != null) 'registrado_por': registradoPor,
      if (turnoFecha != null) 'turno_fecha': turnoFecha,
      if (tipo != null) 'tipo': tipo,
      if (ocurridoAt != null) 'ocurrido_at': ocurridoAt,
      if (descripcion != null) 'descripcion': descripcion,
      if (placas != null) 'placas': placas,
      if (transportista != null) 'transportista': transportista,
      if (empresaTransporte != null) 'empresa_transporte': empresaTransporte,
      if (numDocumento != null) 'num_documento': numDocumento,
      if (destino != null) 'destino': destino,
      if (autorizadoPorId != null) 'autorizado_por_id': autorizadoPorId,
      if (autorizadoPorTexto != null)
        'autorizado_por_texto': autorizadoPorTexto,
      if (prioridad != null) 'prioridad': prioridad,
      if (requiereSeguimiento != null)
        'requiere_seguimiento': requiereSeguimiento,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalBitacoraEventosCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<String>? syncError,
    Value<int>? syncIntentos,
    Value<String>? deviceId,
    Value<DateTime>? createdAtLocal,
    Value<DateTime>? updatedAtLocal,
    Value<DateTime?>? syncedAt,
    Value<String>? sitioId,
    Value<String>? registradoPor,
    Value<DateTime>? turnoFecha,
    Value<String>? tipo,
    Value<DateTime>? ocurridoAt,
    Value<String>? descripcion,
    Value<String>? placas,
    Value<String>? transportista,
    Value<String>? empresaTransporte,
    Value<String>? numDocumento,
    Value<String>? destino,
    Value<String?>? autorizadoPorId,
    Value<String>? autorizadoPorTexto,
    Value<String>? prioridad,
    Value<bool>? requiereSeguimiento,
    Value<int>? rowid,
  }) {
    return LocalBitacoraEventosCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError ?? this.syncError,
      syncIntentos: syncIntentos ?? this.syncIntentos,
      deviceId: deviceId ?? this.deviceId,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      syncedAt: syncedAt ?? this.syncedAt,
      sitioId: sitioId ?? this.sitioId,
      registradoPor: registradoPor ?? this.registradoPor,
      turnoFecha: turnoFecha ?? this.turnoFecha,
      tipo: tipo ?? this.tipo,
      ocurridoAt: ocurridoAt ?? this.ocurridoAt,
      descripcion: descripcion ?? this.descripcion,
      placas: placas ?? this.placas,
      transportista: transportista ?? this.transportista,
      empresaTransporte: empresaTransporte ?? this.empresaTransporte,
      numDocumento: numDocumento ?? this.numDocumento,
      destino: destino ?? this.destino,
      autorizadoPorId: autorizadoPorId ?? this.autorizadoPorId,
      autorizadoPorTexto: autorizadoPorTexto ?? this.autorizadoPorTexto,
      prioridad: prioridad ?? this.prioridad,
      requiereSeguimiento: requiereSeguimiento ?? this.requiereSeguimiento,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (syncIntentos.present) {
      map['sync_intentos'] = Variable<int>(syncIntentos.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (sitioId.present) {
      map['sitio_id'] = Variable<String>(sitioId.value);
    }
    if (registradoPor.present) {
      map['registrado_por'] = Variable<String>(registradoPor.value);
    }
    if (turnoFecha.present) {
      map['turno_fecha'] = Variable<DateTime>(turnoFecha.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (ocurridoAt.present) {
      map['ocurrido_at'] = Variable<DateTime>(ocurridoAt.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (placas.present) {
      map['placas'] = Variable<String>(placas.value);
    }
    if (transportista.present) {
      map['transportista'] = Variable<String>(transportista.value);
    }
    if (empresaTransporte.present) {
      map['empresa_transporte'] = Variable<String>(empresaTransporte.value);
    }
    if (numDocumento.present) {
      map['num_documento'] = Variable<String>(numDocumento.value);
    }
    if (destino.present) {
      map['destino'] = Variable<String>(destino.value);
    }
    if (autorizadoPorId.present) {
      map['autorizado_por_id'] = Variable<String>(autorizadoPorId.value);
    }
    if (autorizadoPorTexto.present) {
      map['autorizado_por_texto'] = Variable<String>(autorizadoPorTexto.value);
    }
    if (prioridad.present) {
      map['prioridad'] = Variable<String>(prioridad.value);
    }
    if (requiereSeguimiento.present) {
      map['requiere_seguimiento'] = Variable<bool>(requiereSeguimiento.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalBitacoraEventosCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('sitioId: $sitioId, ')
          ..write('registradoPor: $registradoPor, ')
          ..write('turnoFecha: $turnoFecha, ')
          ..write('tipo: $tipo, ')
          ..write('ocurridoAt: $ocurridoAt, ')
          ..write('descripcion: $descripcion, ')
          ..write('placas: $placas, ')
          ..write('transportista: $transportista, ')
          ..write('empresaTransporte: $empresaTransporte, ')
          ..write('numDocumento: $numDocumento, ')
          ..write('destino: $destino, ')
          ..write('autorizadoPorId: $autorizadoPorId, ')
          ..write('autorizadoPorTexto: $autorizadoPorTexto, ')
          ..write('prioridad: $prioridad, ')
          ..write('requiereSeguimiento: $requiereSeguimiento, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalBitacoraFotosTable extends LocalBitacoraFotos
    with TableInfo<$LocalBitacoraFotosTable, LocalBitacoraFoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalBitacoraFotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncIntentosMeta = const VerificationMeta(
    'syncIntentos',
  );
  @override
  late final GeneratedColumn<int> syncIntentos = GeneratedColumn<int>(
    'sync_intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtLocalMeta = const VerificationMeta(
    'createdAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>(
        'created_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventoLocalIdMeta = const VerificationMeta(
    'eventoLocalId',
  );
  @override
  late final GeneratedColumn<String> eventoLocalId = GeneratedColumn<String>(
    'evento_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutaLocalMeta = const VerificationMeta(
    'rutaLocal',
  );
  @override
  late final GeneratedColumn<String> rutaLocal = GeneratedColumn<String>(
    'ruta_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fotoUrlMeta = const VerificationMeta(
    'fotoUrl',
  );
  @override
  late final GeneratedColumn<String> fotoUrl = GeneratedColumn<String>(
    'foto_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    eventoLocalId,
    rutaLocal,
    fotoUrl,
    descripcion,
    orden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_bitacora_fotos';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalBitacoraFoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('sync_intentos')) {
      context.handle(
        _syncIntentosMeta,
        syncIntentos.isAcceptableOrUnknown(
          data['sync_intentos']!,
          _syncIntentosMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
        _createdAtLocalMeta,
        createdAtLocal.isAcceptableOrUnknown(
          data['created_at_local']!,
          _createdAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('evento_local_id')) {
      context.handle(
        _eventoLocalIdMeta,
        eventoLocalId.isAcceptableOrUnknown(
          data['evento_local_id']!,
          _eventoLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eventoLocalIdMeta);
    }
    if (data.containsKey('ruta_local')) {
      context.handle(
        _rutaLocalMeta,
        rutaLocal.isAcceptableOrUnknown(data['ruta_local']!, _rutaLocalMeta),
      );
    }
    if (data.containsKey('foto_url')) {
      context.handle(
        _fotoUrlMeta,
        fotoUrl.isAcceptableOrUnknown(data['foto_url']!, _fotoUrlMeta),
      );
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalBitacoraFoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBitacoraFoto(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      )!,
      syncIntentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_intentos'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      eventoLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evento_local_id'],
      )!,
      rutaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruta_local'],
      ),
      fotoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_url'],
      ),
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
    );
  }

  @override
  $LocalBitacoraFotosTable createAlias(String alias) {
    return $LocalBitacoraFotosTable(attachedDatabase, alias);
  }
}

class LocalBitacoraFoto extends DataClass
    implements Insertable<LocalBitacoraFoto> {
  final String localId;

  /// UUID que asignó Supabase. Nulo mientras no se haya sincronizado.
  final String? remoteId;

  /// pendiente | sincronizando | sincronizado | fallido
  final String syncStatus;
  final String syncError;

  /// Se pausan los reintentos al llegar al máximo para no quemar batería
  /// reintentando algo que falla por una razón que no se va a resolver sola
  /// (por ejemplo, violar un CHECK del servidor).
  final int syncIntentos;
  final String deviceId;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? syncedAt;
  final String eventoLocalId;
  final String? rutaLocal;
  final String? fotoUrl;
  final String descripcion;
  final int orden;
  const LocalBitacoraFoto({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.syncError,
    required this.syncIntentos,
    required this.deviceId,
    required this.createdAtLocal,
    required this.updatedAtLocal,
    this.syncedAt,
    required this.eventoLocalId,
    this.rutaLocal,
    this.fotoUrl,
    required this.descripcion,
    required this.orden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_error'] = Variable<String>(syncError);
    map['sync_intentos'] = Variable<int>(syncIntentos);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['evento_local_id'] = Variable<String>(eventoLocalId);
    if (!nullToAbsent || rutaLocal != null) {
      map['ruta_local'] = Variable<String>(rutaLocal);
    }
    if (!nullToAbsent || fotoUrl != null) {
      map['foto_url'] = Variable<String>(fotoUrl);
    }
    map['descripcion'] = Variable<String>(descripcion);
    map['orden'] = Variable<int>(orden);
    return map;
  }

  LocalBitacoraFotosCompanion toCompanion(bool nullToAbsent) {
    return LocalBitacoraFotosCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      syncError: Value(syncError),
      syncIntentos: Value(syncIntentos),
      deviceId: Value(deviceId),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      eventoLocalId: Value(eventoLocalId),
      rutaLocal: rutaLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(rutaLocal),
      fotoUrl: fotoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoUrl),
      descripcion: Value(descripcion),
      orden: Value(orden),
    );
  }

  factory LocalBitacoraFoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBitacoraFoto(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncError: serializer.fromJson<String>(json['syncError']),
      syncIntentos: serializer.fromJson<int>(json['syncIntentos']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAtLocal: serializer.fromJson<DateTime>(json['createdAtLocal']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updatedAtLocal']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      eventoLocalId: serializer.fromJson<String>(json['eventoLocalId']),
      rutaLocal: serializer.fromJson<String?>(json['rutaLocal']),
      fotoUrl: serializer.fromJson<String?>(json['fotoUrl']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      orden: serializer.fromJson<int>(json['orden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncError': serializer.toJson<String>(syncError),
      'syncIntentos': serializer.toJson<int>(syncIntentos),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAtLocal': serializer.toJson<DateTime>(createdAtLocal),
      'updatedAtLocal': serializer.toJson<DateTime>(updatedAtLocal),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'eventoLocalId': serializer.toJson<String>(eventoLocalId),
      'rutaLocal': serializer.toJson<String?>(rutaLocal),
      'fotoUrl': serializer.toJson<String?>(fotoUrl),
      'descripcion': serializer.toJson<String>(descripcion),
      'orden': serializer.toJson<int>(orden),
    };
  }

  LocalBitacoraFoto copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    String? syncError,
    int? syncIntentos,
    String? deviceId,
    DateTime? createdAtLocal,
    DateTime? updatedAtLocal,
    Value<DateTime?> syncedAt = const Value.absent(),
    String? eventoLocalId,
    Value<String?> rutaLocal = const Value.absent(),
    Value<String?> fotoUrl = const Value.absent(),
    String? descripcion,
    int? orden,
  }) => LocalBitacoraFoto(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncError: syncError ?? this.syncError,
    syncIntentos: syncIntentos ?? this.syncIntentos,
    deviceId: deviceId ?? this.deviceId,
    createdAtLocal: createdAtLocal ?? this.createdAtLocal,
    updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    eventoLocalId: eventoLocalId ?? this.eventoLocalId,
    rutaLocal: rutaLocal.present ? rutaLocal.value : this.rutaLocal,
    fotoUrl: fotoUrl.present ? fotoUrl.value : this.fotoUrl,
    descripcion: descripcion ?? this.descripcion,
    orden: orden ?? this.orden,
  );
  LocalBitacoraFoto copyWithCompanion(LocalBitacoraFotosCompanion data) {
    return LocalBitacoraFoto(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      syncIntentos: data.syncIntentos.present
          ? data.syncIntentos.value
          : this.syncIntentos,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      eventoLocalId: data.eventoLocalId.present
          ? data.eventoLocalId.value
          : this.eventoLocalId,
      rutaLocal: data.rutaLocal.present ? data.rutaLocal.value : this.rutaLocal,
      fotoUrl: data.fotoUrl.present ? data.fotoUrl.value : this.fotoUrl,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      orden: data.orden.present ? data.orden.value : this.orden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBitacoraFoto(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('eventoLocalId: $eventoLocalId, ')
          ..write('rutaLocal: $rutaLocal, ')
          ..write('fotoUrl: $fotoUrl, ')
          ..write('descripcion: $descripcion, ')
          ..write('orden: $orden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    eventoLocalId,
    rutaLocal,
    fotoUrl,
    descripcion,
    orden,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBitacoraFoto &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.syncError == this.syncError &&
          other.syncIntentos == this.syncIntentos &&
          other.deviceId == this.deviceId &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.syncedAt == this.syncedAt &&
          other.eventoLocalId == this.eventoLocalId &&
          other.rutaLocal == this.rutaLocal &&
          other.fotoUrl == this.fotoUrl &&
          other.descripcion == this.descripcion &&
          other.orden == this.orden);
}

class LocalBitacoraFotosCompanion extends UpdateCompanion<LocalBitacoraFoto> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<String> syncError;
  final Value<int> syncIntentos;
  final Value<String> deviceId;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> syncedAt;
  final Value<String> eventoLocalId;
  final Value<String?> rutaLocal;
  final Value<String?> fotoUrl;
  final Value<String> descripcion;
  final Value<int> orden;
  final Value<int> rowid;
  const LocalBitacoraFotosCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.eventoLocalId = const Value.absent(),
    this.rutaLocal = const Value.absent(),
    this.fotoUrl = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.orden = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalBitacoraFotosCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String eventoLocalId,
    this.rutaLocal = const Value.absent(),
    this.fotoUrl = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.orden = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventoLocalId = Value(eventoLocalId);
  static Insertable<LocalBitacoraFoto> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<String>? syncError,
    Expression<int>? syncIntentos,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? syncedAt,
    Expression<String>? eventoLocalId,
    Expression<String>? rutaLocal,
    Expression<String>? fotoUrl,
    Expression<String>? descripcion,
    Expression<int>? orden,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncError != null) 'sync_error': syncError,
      if (syncIntentos != null) 'sync_intentos': syncIntentos,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (eventoLocalId != null) 'evento_local_id': eventoLocalId,
      if (rutaLocal != null) 'ruta_local': rutaLocal,
      if (fotoUrl != null) 'foto_url': fotoUrl,
      if (descripcion != null) 'descripcion': descripcion,
      if (orden != null) 'orden': orden,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalBitacoraFotosCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<String>? syncError,
    Value<int>? syncIntentos,
    Value<String>? deviceId,
    Value<DateTime>? createdAtLocal,
    Value<DateTime>? updatedAtLocal,
    Value<DateTime?>? syncedAt,
    Value<String>? eventoLocalId,
    Value<String?>? rutaLocal,
    Value<String?>? fotoUrl,
    Value<String>? descripcion,
    Value<int>? orden,
    Value<int>? rowid,
  }) {
    return LocalBitacoraFotosCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError ?? this.syncError,
      syncIntentos: syncIntentos ?? this.syncIntentos,
      deviceId: deviceId ?? this.deviceId,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      syncedAt: syncedAt ?? this.syncedAt,
      eventoLocalId: eventoLocalId ?? this.eventoLocalId,
      rutaLocal: rutaLocal ?? this.rutaLocal,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      descripcion: descripcion ?? this.descripcion,
      orden: orden ?? this.orden,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (syncIntentos.present) {
      map['sync_intentos'] = Variable<int>(syncIntentos.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (eventoLocalId.present) {
      map['evento_local_id'] = Variable<String>(eventoLocalId.value);
    }
    if (rutaLocal.present) {
      map['ruta_local'] = Variable<String>(rutaLocal.value);
    }
    if (fotoUrl.present) {
      map['foto_url'] = Variable<String>(fotoUrl.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalBitacoraFotosCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('eventoLocalId: $eventoLocalId, ')
          ..write('rutaLocal: $rutaLocal, ')
          ..write('fotoUrl: $fotoUrl, ')
          ..write('descripcion: $descripcion, ')
          ..write('orden: $orden, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalRecepcionesTurnoTable extends LocalRecepcionesTurno
    with TableInfo<$LocalRecepcionesTurnoTable, LocalRecepcionesTurnoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRecepcionesTurnoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncIntentosMeta = const VerificationMeta(
    'syncIntentos',
  );
  @override
  late final GeneratedColumn<int> syncIntentos = GeneratedColumn<int>(
    'sync_intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtLocalMeta = const VerificationMeta(
    'createdAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>(
        'created_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sitioIdMeta = const VerificationMeta(
    'sitioId',
  );
  @override
  late final GeneratedColumn<String> sitioId = GeneratedColumn<String>(
    'sitio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnoFechaMeta = const VerificationMeta(
    'turnoFecha',
  );
  @override
  late final GeneratedColumn<DateTime> turnoFecha = GeneratedColumn<DateTime>(
    'turno_fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recibeIdMeta = const VerificationMeta(
    'recibeId',
  );
  @override
  late final GeneratedColumn<String> recibeId = GeneratedColumn<String>(
    'recibe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entregaIdMeta = const VerificationMeta(
    'entregaId',
  );
  @override
  late final GeneratedColumn<String> entregaId = GeneratedColumn<String>(
    'entrega_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aceptaConformidadMeta = const VerificationMeta(
    'aceptaConformidad',
  );
  @override
  late final GeneratedColumn<bool> aceptaConformidad = GeneratedColumn<bool>(
    'acepta_conformidad',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("acepta_conformidad" IN (0, 1))',
    ),
  );
  static const VerificationMeta _aceptadoAtMeta = const VerificationMeta(
    'aceptadoAt',
  );
  @override
  late final GeneratedColumn<DateTime> aceptadoAt = GeneratedColumn<DateTime>(
    'aceptado_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    sitioId,
    turnoFecha,
    recibeId,
    entregaId,
    aceptaConformidad,
    aceptadoAt,
    observaciones,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_recepciones_turno';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRecepcionesTurnoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('sync_intentos')) {
      context.handle(
        _syncIntentosMeta,
        syncIntentos.isAcceptableOrUnknown(
          data['sync_intentos']!,
          _syncIntentosMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
        _createdAtLocalMeta,
        createdAtLocal.isAcceptableOrUnknown(
          data['created_at_local']!,
          _createdAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('sitio_id')) {
      context.handle(
        _sitioIdMeta,
        sitioId.isAcceptableOrUnknown(data['sitio_id']!, _sitioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sitioIdMeta);
    }
    if (data.containsKey('turno_fecha')) {
      context.handle(
        _turnoFechaMeta,
        turnoFecha.isAcceptableOrUnknown(data['turno_fecha']!, _turnoFechaMeta),
      );
    } else if (isInserting) {
      context.missing(_turnoFechaMeta);
    }
    if (data.containsKey('recibe_id')) {
      context.handle(
        _recibeIdMeta,
        recibeId.isAcceptableOrUnknown(data['recibe_id']!, _recibeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recibeIdMeta);
    }
    if (data.containsKey('entrega_id')) {
      context.handle(
        _entregaIdMeta,
        entregaId.isAcceptableOrUnknown(data['entrega_id']!, _entregaIdMeta),
      );
    }
    if (data.containsKey('acepta_conformidad')) {
      context.handle(
        _aceptaConformidadMeta,
        aceptaConformidad.isAcceptableOrUnknown(
          data['acepta_conformidad']!,
          _aceptaConformidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_aceptaConformidadMeta);
    }
    if (data.containsKey('aceptado_at')) {
      context.handle(
        _aceptadoAtMeta,
        aceptadoAt.isAcceptableOrUnknown(data['aceptado_at']!, _aceptadoAtMeta),
      );
    } else if (isInserting) {
      context.missing(_aceptadoAtMeta);
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalRecepcionesTurnoData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRecepcionesTurnoData(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      )!,
      syncIntentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_intentos'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      sitioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sitio_id'],
      )!,
      turnoFecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}turno_fecha'],
      )!,
      recibeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recibe_id'],
      )!,
      entregaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entrega_id'],
      ),
      aceptaConformidad: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}acepta_conformidad'],
      )!,
      aceptadoAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}aceptado_at'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      )!,
    );
  }

  @override
  $LocalRecepcionesTurnoTable createAlias(String alias) {
    return $LocalRecepcionesTurnoTable(attachedDatabase, alias);
  }
}

class LocalRecepcionesTurnoData extends DataClass
    implements Insertable<LocalRecepcionesTurnoData> {
  final String localId;

  /// UUID que asignó Supabase. Nulo mientras no se haya sincronizado.
  final String? remoteId;

  /// pendiente | sincronizando | sincronizado | fallido
  final String syncStatus;
  final String syncError;

  /// Se pausan los reintentos al llegar al máximo para no quemar batería
  /// reintentando algo que falla por una razón que no se va a resolver sola
  /// (por ejemplo, violar un CHECK del servidor).
  final int syncIntentos;
  final String deviceId;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? syncedAt;
  final String sitioId;
  final DateTime turnoFecha;
  final String recibeId;
  final String? entregaId;
  final bool aceptaConformidad;
  final DateTime aceptadoAt;
  final String observaciones;
  const LocalRecepcionesTurnoData({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.syncError,
    required this.syncIntentos,
    required this.deviceId,
    required this.createdAtLocal,
    required this.updatedAtLocal,
    this.syncedAt,
    required this.sitioId,
    required this.turnoFecha,
    required this.recibeId,
    this.entregaId,
    required this.aceptaConformidad,
    required this.aceptadoAt,
    required this.observaciones,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_error'] = Variable<String>(syncError);
    map['sync_intentos'] = Variable<int>(syncIntentos);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['sitio_id'] = Variable<String>(sitioId);
    map['turno_fecha'] = Variable<DateTime>(turnoFecha);
    map['recibe_id'] = Variable<String>(recibeId);
    if (!nullToAbsent || entregaId != null) {
      map['entrega_id'] = Variable<String>(entregaId);
    }
    map['acepta_conformidad'] = Variable<bool>(aceptaConformidad);
    map['aceptado_at'] = Variable<DateTime>(aceptadoAt);
    map['observaciones'] = Variable<String>(observaciones);
    return map;
  }

  LocalRecepcionesTurnoCompanion toCompanion(bool nullToAbsent) {
    return LocalRecepcionesTurnoCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      syncError: Value(syncError),
      syncIntentos: Value(syncIntentos),
      deviceId: Value(deviceId),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      sitioId: Value(sitioId),
      turnoFecha: Value(turnoFecha),
      recibeId: Value(recibeId),
      entregaId: entregaId == null && nullToAbsent
          ? const Value.absent()
          : Value(entregaId),
      aceptaConformidad: Value(aceptaConformidad),
      aceptadoAt: Value(aceptadoAt),
      observaciones: Value(observaciones),
    );
  }

  factory LocalRecepcionesTurnoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRecepcionesTurnoData(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncError: serializer.fromJson<String>(json['syncError']),
      syncIntentos: serializer.fromJson<int>(json['syncIntentos']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAtLocal: serializer.fromJson<DateTime>(json['createdAtLocal']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updatedAtLocal']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      sitioId: serializer.fromJson<String>(json['sitioId']),
      turnoFecha: serializer.fromJson<DateTime>(json['turnoFecha']),
      recibeId: serializer.fromJson<String>(json['recibeId']),
      entregaId: serializer.fromJson<String?>(json['entregaId']),
      aceptaConformidad: serializer.fromJson<bool>(json['aceptaConformidad']),
      aceptadoAt: serializer.fromJson<DateTime>(json['aceptadoAt']),
      observaciones: serializer.fromJson<String>(json['observaciones']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncError': serializer.toJson<String>(syncError),
      'syncIntentos': serializer.toJson<int>(syncIntentos),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAtLocal': serializer.toJson<DateTime>(createdAtLocal),
      'updatedAtLocal': serializer.toJson<DateTime>(updatedAtLocal),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'sitioId': serializer.toJson<String>(sitioId),
      'turnoFecha': serializer.toJson<DateTime>(turnoFecha),
      'recibeId': serializer.toJson<String>(recibeId),
      'entregaId': serializer.toJson<String?>(entregaId),
      'aceptaConformidad': serializer.toJson<bool>(aceptaConformidad),
      'aceptadoAt': serializer.toJson<DateTime>(aceptadoAt),
      'observaciones': serializer.toJson<String>(observaciones),
    };
  }

  LocalRecepcionesTurnoData copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    String? syncError,
    int? syncIntentos,
    String? deviceId,
    DateTime? createdAtLocal,
    DateTime? updatedAtLocal,
    Value<DateTime?> syncedAt = const Value.absent(),
    String? sitioId,
    DateTime? turnoFecha,
    String? recibeId,
    Value<String?> entregaId = const Value.absent(),
    bool? aceptaConformidad,
    DateTime? aceptadoAt,
    String? observaciones,
  }) => LocalRecepcionesTurnoData(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncError: syncError ?? this.syncError,
    syncIntentos: syncIntentos ?? this.syncIntentos,
    deviceId: deviceId ?? this.deviceId,
    createdAtLocal: createdAtLocal ?? this.createdAtLocal,
    updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    sitioId: sitioId ?? this.sitioId,
    turnoFecha: turnoFecha ?? this.turnoFecha,
    recibeId: recibeId ?? this.recibeId,
    entregaId: entregaId.present ? entregaId.value : this.entregaId,
    aceptaConformidad: aceptaConformidad ?? this.aceptaConformidad,
    aceptadoAt: aceptadoAt ?? this.aceptadoAt,
    observaciones: observaciones ?? this.observaciones,
  );
  LocalRecepcionesTurnoData copyWithCompanion(
    LocalRecepcionesTurnoCompanion data,
  ) {
    return LocalRecepcionesTurnoData(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      syncIntentos: data.syncIntentos.present
          ? data.syncIntentos.value
          : this.syncIntentos,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      sitioId: data.sitioId.present ? data.sitioId.value : this.sitioId,
      turnoFecha: data.turnoFecha.present
          ? data.turnoFecha.value
          : this.turnoFecha,
      recibeId: data.recibeId.present ? data.recibeId.value : this.recibeId,
      entregaId: data.entregaId.present ? data.entregaId.value : this.entregaId,
      aceptaConformidad: data.aceptaConformidad.present
          ? data.aceptaConformidad.value
          : this.aceptaConformidad,
      aceptadoAt: data.aceptadoAt.present
          ? data.aceptadoAt.value
          : this.aceptadoAt,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecepcionesTurnoData(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('sitioId: $sitioId, ')
          ..write('turnoFecha: $turnoFecha, ')
          ..write('recibeId: $recibeId, ')
          ..write('entregaId: $entregaId, ')
          ..write('aceptaConformidad: $aceptaConformidad, ')
          ..write('aceptadoAt: $aceptadoAt, ')
          ..write('observaciones: $observaciones')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    sitioId,
    turnoFecha,
    recibeId,
    entregaId,
    aceptaConformidad,
    aceptadoAt,
    observaciones,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRecepcionesTurnoData &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.syncError == this.syncError &&
          other.syncIntentos == this.syncIntentos &&
          other.deviceId == this.deviceId &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.syncedAt == this.syncedAt &&
          other.sitioId == this.sitioId &&
          other.turnoFecha == this.turnoFecha &&
          other.recibeId == this.recibeId &&
          other.entregaId == this.entregaId &&
          other.aceptaConformidad == this.aceptaConformidad &&
          other.aceptadoAt == this.aceptadoAt &&
          other.observaciones == this.observaciones);
}

class LocalRecepcionesTurnoCompanion
    extends UpdateCompanion<LocalRecepcionesTurnoData> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<String> syncError;
  final Value<int> syncIntentos;
  final Value<String> deviceId;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> syncedAt;
  final Value<String> sitioId;
  final Value<DateTime> turnoFecha;
  final Value<String> recibeId;
  final Value<String?> entregaId;
  final Value<bool> aceptaConformidad;
  final Value<DateTime> aceptadoAt;
  final Value<String> observaciones;
  final Value<int> rowid;
  const LocalRecepcionesTurnoCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.sitioId = const Value.absent(),
    this.turnoFecha = const Value.absent(),
    this.recibeId = const Value.absent(),
    this.entregaId = const Value.absent(),
    this.aceptaConformidad = const Value.absent(),
    this.aceptadoAt = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalRecepcionesTurnoCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String sitioId,
    required DateTime turnoFecha,
    required String recibeId,
    this.entregaId = const Value.absent(),
    required bool aceptaConformidad,
    required DateTime aceptadoAt,
    this.observaciones = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sitioId = Value(sitioId),
       turnoFecha = Value(turnoFecha),
       recibeId = Value(recibeId),
       aceptaConformidad = Value(aceptaConformidad),
       aceptadoAt = Value(aceptadoAt);
  static Insertable<LocalRecepcionesTurnoData> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<String>? syncError,
    Expression<int>? syncIntentos,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? syncedAt,
    Expression<String>? sitioId,
    Expression<DateTime>? turnoFecha,
    Expression<String>? recibeId,
    Expression<String>? entregaId,
    Expression<bool>? aceptaConformidad,
    Expression<DateTime>? aceptadoAt,
    Expression<String>? observaciones,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncError != null) 'sync_error': syncError,
      if (syncIntentos != null) 'sync_intentos': syncIntentos,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (sitioId != null) 'sitio_id': sitioId,
      if (turnoFecha != null) 'turno_fecha': turnoFecha,
      if (recibeId != null) 'recibe_id': recibeId,
      if (entregaId != null) 'entrega_id': entregaId,
      if (aceptaConformidad != null) 'acepta_conformidad': aceptaConformidad,
      if (aceptadoAt != null) 'aceptado_at': aceptadoAt,
      if (observaciones != null) 'observaciones': observaciones,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalRecepcionesTurnoCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<String>? syncError,
    Value<int>? syncIntentos,
    Value<String>? deviceId,
    Value<DateTime>? createdAtLocal,
    Value<DateTime>? updatedAtLocal,
    Value<DateTime?>? syncedAt,
    Value<String>? sitioId,
    Value<DateTime>? turnoFecha,
    Value<String>? recibeId,
    Value<String?>? entregaId,
    Value<bool>? aceptaConformidad,
    Value<DateTime>? aceptadoAt,
    Value<String>? observaciones,
    Value<int>? rowid,
  }) {
    return LocalRecepcionesTurnoCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError ?? this.syncError,
      syncIntentos: syncIntentos ?? this.syncIntentos,
      deviceId: deviceId ?? this.deviceId,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      syncedAt: syncedAt ?? this.syncedAt,
      sitioId: sitioId ?? this.sitioId,
      turnoFecha: turnoFecha ?? this.turnoFecha,
      recibeId: recibeId ?? this.recibeId,
      entregaId: entregaId ?? this.entregaId,
      aceptaConformidad: aceptaConformidad ?? this.aceptaConformidad,
      aceptadoAt: aceptadoAt ?? this.aceptadoAt,
      observaciones: observaciones ?? this.observaciones,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (syncIntentos.present) {
      map['sync_intentos'] = Variable<int>(syncIntentos.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (sitioId.present) {
      map['sitio_id'] = Variable<String>(sitioId.value);
    }
    if (turnoFecha.present) {
      map['turno_fecha'] = Variable<DateTime>(turnoFecha.value);
    }
    if (recibeId.present) {
      map['recibe_id'] = Variable<String>(recibeId.value);
    }
    if (entregaId.present) {
      map['entrega_id'] = Variable<String>(entregaId.value);
    }
    if (aceptaConformidad.present) {
      map['acepta_conformidad'] = Variable<bool>(aceptaConformidad.value);
    }
    if (aceptadoAt.present) {
      map['aceptado_at'] = Variable<DateTime>(aceptadoAt.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecepcionesTurnoCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('sitioId: $sitioId, ')
          ..write('turnoFecha: $turnoFecha, ')
          ..write('recibeId: $recibeId, ')
          ..write('entregaId: $entregaId, ')
          ..write('aceptaConformidad: $aceptaConformidad, ')
          ..write('aceptadoAt: $aceptadoAt, ')
          ..write('observaciones: $observaciones, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalRecepcionItemsTable extends LocalRecepcionItems
    with TableInfo<$LocalRecepcionItemsTable, LocalRecepcionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRecepcionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncIntentosMeta = const VerificationMeta(
    'syncIntentos',
  );
  @override
  late final GeneratedColumn<int> syncIntentos = GeneratedColumn<int>(
    'sync_intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtLocalMeta = const VerificationMeta(
    'createdAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtLocal =
      GeneratedColumn<DateTime>(
        'created_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _updatedAtLocalMeta = const VerificationMeta(
    'updatedAtLocal',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtLocal =
      GeneratedColumn<DateTime>(
        'updated_at_local',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: DateTime.now,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recepcionLocalIdMeta = const VerificationMeta(
    'recepcionLocalId',
  );
  @override
  late final GeneratedColumn<String> recepcionLocalId = GeneratedColumn<String>(
    'recepcion_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipoIdMeta = const VerificationMeta(
    'equipoId',
  );
  @override
  late final GeneratedColumn<String> equipoId = GeneratedColumn<String>(
    'equipo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadEncontradaMeta =
      const VerificationMeta('cantidadEncontrada');
  @override
  late final GeneratedColumn<int> cantidadEncontrada = GeneratedColumn<int>(
    'cantidad_encontrada',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _observacionesMeta = const VerificationMeta(
    'observaciones',
  );
  @override
  late final GeneratedColumn<String> observaciones = GeneratedColumn<String>(
    'observaciones',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fotoRutaLocalMeta = const VerificationMeta(
    'fotoRutaLocal',
  );
  @override
  late final GeneratedColumn<String> fotoRutaLocal = GeneratedColumn<String>(
    'foto_ruta_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fotoUrlMeta = const VerificationMeta(
    'fotoUrl',
  );
  @override
  late final GeneratedColumn<String> fotoUrl = GeneratedColumn<String>(
    'foto_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    recepcionLocalId,
    equipoId,
    estado,
    cantidadEncontrada,
    observaciones,
    fotoRutaLocal,
    fotoUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_recepcion_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRecepcionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('sync_intentos')) {
      context.handle(
        _syncIntentosMeta,
        syncIntentos.isAcceptableOrUnknown(
          data['sync_intentos']!,
          _syncIntentosMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('created_at_local')) {
      context.handle(
        _createdAtLocalMeta,
        createdAtLocal.isAcceptableOrUnknown(
          data['created_at_local']!,
          _createdAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_local')) {
      context.handle(
        _updatedAtLocalMeta,
        updatedAtLocal.isAcceptableOrUnknown(
          data['updated_at_local']!,
          _updatedAtLocalMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('recepcion_local_id')) {
      context.handle(
        _recepcionLocalIdMeta,
        recepcionLocalId.isAcceptableOrUnknown(
          data['recepcion_local_id']!,
          _recepcionLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recepcionLocalIdMeta);
    }
    if (data.containsKey('equipo_id')) {
      context.handle(
        _equipoIdMeta,
        equipoId.isAcceptableOrUnknown(data['equipo_id']!, _equipoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_equipoIdMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('cantidad_encontrada')) {
      context.handle(
        _cantidadEncontradaMeta,
        cantidadEncontrada.isAcceptableOrUnknown(
          data['cantidad_encontrada']!,
          _cantidadEncontradaMeta,
        ),
      );
    }
    if (data.containsKey('observaciones')) {
      context.handle(
        _observacionesMeta,
        observaciones.isAcceptableOrUnknown(
          data['observaciones']!,
          _observacionesMeta,
        ),
      );
    }
    if (data.containsKey('foto_ruta_local')) {
      context.handle(
        _fotoRutaLocalMeta,
        fotoRutaLocal.isAcceptableOrUnknown(
          data['foto_ruta_local']!,
          _fotoRutaLocalMeta,
        ),
      );
    }
    if (data.containsKey('foto_url')) {
      context.handle(
        _fotoUrlMeta,
        fotoUrl.isAcceptableOrUnknown(data['foto_url']!, _fotoUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LocalRecepcionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRecepcionItem(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      )!,
      syncIntentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_intentos'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_local'],
      )!,
      updatedAtLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_local'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      recepcionLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recepcion_local_id'],
      )!,
      equipoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipo_id'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      cantidadEncontrada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_encontrada'],
      )!,
      observaciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observaciones'],
      )!,
      fotoRutaLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_ruta_local'],
      ),
      fotoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_url'],
      ),
    );
  }

  @override
  $LocalRecepcionItemsTable createAlias(String alias) {
    return $LocalRecepcionItemsTable(attachedDatabase, alias);
  }
}

class LocalRecepcionItem extends DataClass
    implements Insertable<LocalRecepcionItem> {
  final String localId;

  /// UUID que asignó Supabase. Nulo mientras no se haya sincronizado.
  final String? remoteId;

  /// pendiente | sincronizando | sincronizado | fallido
  final String syncStatus;
  final String syncError;

  /// Se pausan los reintentos al llegar al máximo para no quemar batería
  /// reintentando algo que falla por una razón que no se va a resolver sola
  /// (por ejemplo, violar un CHECK del servidor).
  final int syncIntentos;
  final String deviceId;
  final DateTime createdAtLocal;
  final DateTime updatedAtLocal;
  final DateTime? syncedAt;
  final String recepcionLocalId;
  final String equipoId;
  final String estado;
  final int cantidadEncontrada;
  final String observaciones;
  final String? fotoRutaLocal;
  final String? fotoUrl;
  const LocalRecepcionItem({
    required this.localId,
    this.remoteId,
    required this.syncStatus,
    required this.syncError,
    required this.syncIntentos,
    required this.deviceId,
    required this.createdAtLocal,
    required this.updatedAtLocal,
    this.syncedAt,
    required this.recepcionLocalId,
    required this.equipoId,
    required this.estado,
    required this.cantidadEncontrada,
    required this.observaciones,
    this.fotoRutaLocal,
    this.fotoUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    map['sync_error'] = Variable<String>(syncError);
    map['sync_intentos'] = Variable<int>(syncIntentos);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at_local'] = Variable<DateTime>(createdAtLocal);
    map['updated_at_local'] = Variable<DateTime>(updatedAtLocal);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['recepcion_local_id'] = Variable<String>(recepcionLocalId);
    map['equipo_id'] = Variable<String>(equipoId);
    map['estado'] = Variable<String>(estado);
    map['cantidad_encontrada'] = Variable<int>(cantidadEncontrada);
    map['observaciones'] = Variable<String>(observaciones);
    if (!nullToAbsent || fotoRutaLocal != null) {
      map['foto_ruta_local'] = Variable<String>(fotoRutaLocal);
    }
    if (!nullToAbsent || fotoUrl != null) {
      map['foto_url'] = Variable<String>(fotoUrl);
    }
    return map;
  }

  LocalRecepcionItemsCompanion toCompanion(bool nullToAbsent) {
    return LocalRecepcionItemsCompanion(
      localId: Value(localId),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      syncStatus: Value(syncStatus),
      syncError: Value(syncError),
      syncIntentos: Value(syncIntentos),
      deviceId: Value(deviceId),
      createdAtLocal: Value(createdAtLocal),
      updatedAtLocal: Value(updatedAtLocal),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      recepcionLocalId: Value(recepcionLocalId),
      equipoId: Value(equipoId),
      estado: Value(estado),
      cantidadEncontrada: Value(cantidadEncontrada),
      observaciones: Value(observaciones),
      fotoRutaLocal: fotoRutaLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoRutaLocal),
      fotoUrl: fotoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoUrl),
    );
  }

  factory LocalRecepcionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRecepcionItem(
      localId: serializer.fromJson<String>(json['localId']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      syncError: serializer.fromJson<String>(json['syncError']),
      syncIntentos: serializer.fromJson<int>(json['syncIntentos']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAtLocal: serializer.fromJson<DateTime>(json['createdAtLocal']),
      updatedAtLocal: serializer.fromJson<DateTime>(json['updatedAtLocal']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      recepcionLocalId: serializer.fromJson<String>(json['recepcionLocalId']),
      equipoId: serializer.fromJson<String>(json['equipoId']),
      estado: serializer.fromJson<String>(json['estado']),
      cantidadEncontrada: serializer.fromJson<int>(json['cantidadEncontrada']),
      observaciones: serializer.fromJson<String>(json['observaciones']),
      fotoRutaLocal: serializer.fromJson<String?>(json['fotoRutaLocal']),
      fotoUrl: serializer.fromJson<String?>(json['fotoUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'remoteId': serializer.toJson<String?>(remoteId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'syncError': serializer.toJson<String>(syncError),
      'syncIntentos': serializer.toJson<int>(syncIntentos),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAtLocal': serializer.toJson<DateTime>(createdAtLocal),
      'updatedAtLocal': serializer.toJson<DateTime>(updatedAtLocal),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'recepcionLocalId': serializer.toJson<String>(recepcionLocalId),
      'equipoId': serializer.toJson<String>(equipoId),
      'estado': serializer.toJson<String>(estado),
      'cantidadEncontrada': serializer.toJson<int>(cantidadEncontrada),
      'observaciones': serializer.toJson<String>(observaciones),
      'fotoRutaLocal': serializer.toJson<String?>(fotoRutaLocal),
      'fotoUrl': serializer.toJson<String?>(fotoUrl),
    };
  }

  LocalRecepcionItem copyWith({
    String? localId,
    Value<String?> remoteId = const Value.absent(),
    String? syncStatus,
    String? syncError,
    int? syncIntentos,
    String? deviceId,
    DateTime? createdAtLocal,
    DateTime? updatedAtLocal,
    Value<DateTime?> syncedAt = const Value.absent(),
    String? recepcionLocalId,
    String? equipoId,
    String? estado,
    int? cantidadEncontrada,
    String? observaciones,
    Value<String?> fotoRutaLocal = const Value.absent(),
    Value<String?> fotoUrl = const Value.absent(),
  }) => LocalRecepcionItem(
    localId: localId ?? this.localId,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    syncStatus: syncStatus ?? this.syncStatus,
    syncError: syncError ?? this.syncError,
    syncIntentos: syncIntentos ?? this.syncIntentos,
    deviceId: deviceId ?? this.deviceId,
    createdAtLocal: createdAtLocal ?? this.createdAtLocal,
    updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    recepcionLocalId: recepcionLocalId ?? this.recepcionLocalId,
    equipoId: equipoId ?? this.equipoId,
    estado: estado ?? this.estado,
    cantidadEncontrada: cantidadEncontrada ?? this.cantidadEncontrada,
    observaciones: observaciones ?? this.observaciones,
    fotoRutaLocal: fotoRutaLocal.present
        ? fotoRutaLocal.value
        : this.fotoRutaLocal,
    fotoUrl: fotoUrl.present ? fotoUrl.value : this.fotoUrl,
  );
  LocalRecepcionItem copyWithCompanion(LocalRecepcionItemsCompanion data) {
    return LocalRecepcionItem(
      localId: data.localId.present ? data.localId.value : this.localId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      syncIntentos: data.syncIntentos.present
          ? data.syncIntentos.value
          : this.syncIntentos,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAtLocal: data.createdAtLocal.present
          ? data.createdAtLocal.value
          : this.createdAtLocal,
      updatedAtLocal: data.updatedAtLocal.present
          ? data.updatedAtLocal.value
          : this.updatedAtLocal,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      recepcionLocalId: data.recepcionLocalId.present
          ? data.recepcionLocalId.value
          : this.recepcionLocalId,
      equipoId: data.equipoId.present ? data.equipoId.value : this.equipoId,
      estado: data.estado.present ? data.estado.value : this.estado,
      cantidadEncontrada: data.cantidadEncontrada.present
          ? data.cantidadEncontrada.value
          : this.cantidadEncontrada,
      observaciones: data.observaciones.present
          ? data.observaciones.value
          : this.observaciones,
      fotoRutaLocal: data.fotoRutaLocal.present
          ? data.fotoRutaLocal.value
          : this.fotoRutaLocal,
      fotoUrl: data.fotoUrl.present ? data.fotoUrl.value : this.fotoUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecepcionItem(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('recepcionLocalId: $recepcionLocalId, ')
          ..write('equipoId: $equipoId, ')
          ..write('estado: $estado, ')
          ..write('cantidadEncontrada: $cantidadEncontrada, ')
          ..write('observaciones: $observaciones, ')
          ..write('fotoRutaLocal: $fotoRutaLocal, ')
          ..write('fotoUrl: $fotoUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    remoteId,
    syncStatus,
    syncError,
    syncIntentos,
    deviceId,
    createdAtLocal,
    updatedAtLocal,
    syncedAt,
    recepcionLocalId,
    equipoId,
    estado,
    cantidadEncontrada,
    observaciones,
    fotoRutaLocal,
    fotoUrl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRecepcionItem &&
          other.localId == this.localId &&
          other.remoteId == this.remoteId &&
          other.syncStatus == this.syncStatus &&
          other.syncError == this.syncError &&
          other.syncIntentos == this.syncIntentos &&
          other.deviceId == this.deviceId &&
          other.createdAtLocal == this.createdAtLocal &&
          other.updatedAtLocal == this.updatedAtLocal &&
          other.syncedAt == this.syncedAt &&
          other.recepcionLocalId == this.recepcionLocalId &&
          other.equipoId == this.equipoId &&
          other.estado == this.estado &&
          other.cantidadEncontrada == this.cantidadEncontrada &&
          other.observaciones == this.observaciones &&
          other.fotoRutaLocal == this.fotoRutaLocal &&
          other.fotoUrl == this.fotoUrl);
}

class LocalRecepcionItemsCompanion extends UpdateCompanion<LocalRecepcionItem> {
  final Value<String> localId;
  final Value<String?> remoteId;
  final Value<String> syncStatus;
  final Value<String> syncError;
  final Value<int> syncIntentos;
  final Value<String> deviceId;
  final Value<DateTime> createdAtLocal;
  final Value<DateTime> updatedAtLocal;
  final Value<DateTime?> syncedAt;
  final Value<String> recepcionLocalId;
  final Value<String> equipoId;
  final Value<String> estado;
  final Value<int> cantidadEncontrada;
  final Value<String> observaciones;
  final Value<String?> fotoRutaLocal;
  final Value<String?> fotoUrl;
  final Value<int> rowid;
  const LocalRecepcionItemsCompanion({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.recepcionLocalId = const Value.absent(),
    this.equipoId = const Value.absent(),
    this.estado = const Value.absent(),
    this.cantidadEncontrada = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.fotoRutaLocal = const Value.absent(),
    this.fotoUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalRecepcionItemsCompanion.insert({
    this.localId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.syncError = const Value.absent(),
    this.syncIntentos = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtLocal = const Value.absent(),
    this.updatedAtLocal = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String recepcionLocalId,
    required String equipoId,
    required String estado,
    this.cantidadEncontrada = const Value.absent(),
    this.observaciones = const Value.absent(),
    this.fotoRutaLocal = const Value.absent(),
    this.fotoUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : recepcionLocalId = Value(recepcionLocalId),
       equipoId = Value(equipoId),
       estado = Value(estado);
  static Insertable<LocalRecepcionItem> custom({
    Expression<String>? localId,
    Expression<String>? remoteId,
    Expression<String>? syncStatus,
    Expression<String>? syncError,
    Expression<int>? syncIntentos,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAtLocal,
    Expression<DateTime>? updatedAtLocal,
    Expression<DateTime>? syncedAt,
    Expression<String>? recepcionLocalId,
    Expression<String>? equipoId,
    Expression<String>? estado,
    Expression<int>? cantidadEncontrada,
    Expression<String>? observaciones,
    Expression<String>? fotoRutaLocal,
    Expression<String>? fotoUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (remoteId != null) 'remote_id': remoteId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (syncError != null) 'sync_error': syncError,
      if (syncIntentos != null) 'sync_intentos': syncIntentos,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAtLocal != null) 'created_at_local': createdAtLocal,
      if (updatedAtLocal != null) 'updated_at_local': updatedAtLocal,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (recepcionLocalId != null) 'recepcion_local_id': recepcionLocalId,
      if (equipoId != null) 'equipo_id': equipoId,
      if (estado != null) 'estado': estado,
      if (cantidadEncontrada != null) 'cantidad_encontrada': cantidadEncontrada,
      if (observaciones != null) 'observaciones': observaciones,
      if (fotoRutaLocal != null) 'foto_ruta_local': fotoRutaLocal,
      if (fotoUrl != null) 'foto_url': fotoUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalRecepcionItemsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? remoteId,
    Value<String>? syncStatus,
    Value<String>? syncError,
    Value<int>? syncIntentos,
    Value<String>? deviceId,
    Value<DateTime>? createdAtLocal,
    Value<DateTime>? updatedAtLocal,
    Value<DateTime?>? syncedAt,
    Value<String>? recepcionLocalId,
    Value<String>? equipoId,
    Value<String>? estado,
    Value<int>? cantidadEncontrada,
    Value<String>? observaciones,
    Value<String?>? fotoRutaLocal,
    Value<String?>? fotoUrl,
    Value<int>? rowid,
  }) {
    return LocalRecepcionItemsCompanion(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncError: syncError ?? this.syncError,
      syncIntentos: syncIntentos ?? this.syncIntentos,
      deviceId: deviceId ?? this.deviceId,
      createdAtLocal: createdAtLocal ?? this.createdAtLocal,
      updatedAtLocal: updatedAtLocal ?? this.updatedAtLocal,
      syncedAt: syncedAt ?? this.syncedAt,
      recepcionLocalId: recepcionLocalId ?? this.recepcionLocalId,
      equipoId: equipoId ?? this.equipoId,
      estado: estado ?? this.estado,
      cantidadEncontrada: cantidadEncontrada ?? this.cantidadEncontrada,
      observaciones: observaciones ?? this.observaciones,
      fotoRutaLocal: fotoRutaLocal ?? this.fotoRutaLocal,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (syncIntentos.present) {
      map['sync_intentos'] = Variable<int>(syncIntentos.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAtLocal.present) {
      map['created_at_local'] = Variable<DateTime>(createdAtLocal.value);
    }
    if (updatedAtLocal.present) {
      map['updated_at_local'] = Variable<DateTime>(updatedAtLocal.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (recepcionLocalId.present) {
      map['recepcion_local_id'] = Variable<String>(recepcionLocalId.value);
    }
    if (equipoId.present) {
      map['equipo_id'] = Variable<String>(equipoId.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (cantidadEncontrada.present) {
      map['cantidad_encontrada'] = Variable<int>(cantidadEncontrada.value);
    }
    if (observaciones.present) {
      map['observaciones'] = Variable<String>(observaciones.value);
    }
    if (fotoRutaLocal.present) {
      map['foto_ruta_local'] = Variable<String>(fotoRutaLocal.value);
    }
    if (fotoUrl.present) {
      map['foto_url'] = Variable<String>(fotoUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecepcionItemsCompanion(')
          ..write('localId: $localId, ')
          ..write('remoteId: $remoteId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('syncError: $syncError, ')
          ..write('syncIntentos: $syncIntentos, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtLocal: $createdAtLocal, ')
          ..write('updatedAtLocal: $updatedAtLocal, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('recepcionLocalId: $recepcionLocalId, ')
          ..write('equipoId: $equipoId, ')
          ..write('estado: $estado, ')
          ..write('cantidadEncontrada: $cantidadEncontrada, ')
          ..write('observaciones: $observaciones, ')
          ..write('fotoRutaLocal: $fotoRutaLocal, ')
          ..write('fotoUrl: $fotoUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSitiosTable extends LocalSitios
    with TableInfo<$LocalSitiosTable, LocalSitio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSitiosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _radioMetrosMeta = const VerificationMeta(
    'radioMetros',
  );
  @override
  late final GeneratedColumn<int> radioMetros = GeneratedColumn<int>(
    'radio_metros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(150),
  );
  static const VerificationMeta _horaInicioTurnoMeta = const VerificationMeta(
    'horaInicioTurno',
  );
  @override
  late final GeneratedColumn<String> horaInicioTurno = GeneratedColumn<String>(
    'hora_inicio_turno',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('08:00'),
  );
  static const VerificationMeta _minutosToleranciaRetardoMeta =
      const VerificationMeta('minutosToleranciaRetardo');
  @override
  late final GeneratedColumn<int> minutosToleranciaRetardo =
      GeneratedColumn<int>(
        'minutos_tolerancia_retardo',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      );
  static const VerificationMeta _minutosToleranciaFaltaMeta =
      const VerificationMeta('minutosToleranciaFalta');
  @override
  late final GeneratedColumn<int> minutosToleranciaFalta = GeneratedColumn<int>(
    'minutos_tolerancia_falta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _husoHorarioOffsetHMeta =
      const VerificationMeta('husoHorarioOffsetH');
  @override
  late final GeneratedColumn<int> husoHorarioOffsetH = GeneratedColumn<int>(
    'huso_horario_offset_h',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-6),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    lat,
    lng,
    radioMetros,
    horaInicioTurno,
    minutosToleranciaRetardo,
    minutosToleranciaFalta,
    husoHorarioOffsetH,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sitios';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSitio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('radio_metros')) {
      context.handle(
        _radioMetrosMeta,
        radioMetros.isAcceptableOrUnknown(
          data['radio_metros']!,
          _radioMetrosMeta,
        ),
      );
    }
    if (data.containsKey('hora_inicio_turno')) {
      context.handle(
        _horaInicioTurnoMeta,
        horaInicioTurno.isAcceptableOrUnknown(
          data['hora_inicio_turno']!,
          _horaInicioTurnoMeta,
        ),
      );
    }
    if (data.containsKey('minutos_tolerancia_retardo')) {
      context.handle(
        _minutosToleranciaRetardoMeta,
        minutosToleranciaRetardo.isAcceptableOrUnknown(
          data['minutos_tolerancia_retardo']!,
          _minutosToleranciaRetardoMeta,
        ),
      );
    }
    if (data.containsKey('minutos_tolerancia_falta')) {
      context.handle(
        _minutosToleranciaFaltaMeta,
        minutosToleranciaFalta.isAcceptableOrUnknown(
          data['minutos_tolerancia_falta']!,
          _minutosToleranciaFaltaMeta,
        ),
      );
    }
    if (data.containsKey('huso_horario_offset_h')) {
      context.handle(
        _husoHorarioOffsetHMeta,
        husoHorarioOffsetH.isAcceptableOrUnknown(
          data['huso_horario_offset_h']!,
          _husoHorarioOffsetHMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSitio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSitio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      radioMetros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}radio_metros'],
      )!,
      horaInicioTurno: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hora_inicio_turno'],
      )!,
      minutosToleranciaRetardo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutos_tolerancia_retardo'],
      )!,
      minutosToleranciaFalta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutos_tolerancia_falta'],
      )!,
      husoHorarioOffsetH: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}huso_horario_offset_h'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $LocalSitiosTable createAlias(String alias) {
    return $LocalSitiosTable(attachedDatabase, alias);
  }
}

class LocalSitio extends DataClass implements Insertable<LocalSitio> {
  final String id;
  final String nombre;
  final double? lat;
  final double? lng;
  final int radioMetros;
  final String horaInicioTurno;
  final int minutosToleranciaRetardo;
  final int minutosToleranciaFalta;
  final int husoHorarioOffsetH;
  final bool activo;
  const LocalSitio({
    required this.id,
    required this.nombre,
    this.lat,
    this.lng,
    required this.radioMetros,
    required this.horaInicioTurno,
    required this.minutosToleranciaRetardo,
    required this.minutosToleranciaFalta,
    required this.husoHorarioOffsetH,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['radio_metros'] = Variable<int>(radioMetros);
    map['hora_inicio_turno'] = Variable<String>(horaInicioTurno);
    map['minutos_tolerancia_retardo'] = Variable<int>(minutosToleranciaRetardo);
    map['minutos_tolerancia_falta'] = Variable<int>(minutosToleranciaFalta);
    map['huso_horario_offset_h'] = Variable<int>(husoHorarioOffsetH);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  LocalSitiosCompanion toCompanion(bool nullToAbsent) {
    return LocalSitiosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      radioMetros: Value(radioMetros),
      horaInicioTurno: Value(horaInicioTurno),
      minutosToleranciaRetardo: Value(minutosToleranciaRetardo),
      minutosToleranciaFalta: Value(minutosToleranciaFalta),
      husoHorarioOffsetH: Value(husoHorarioOffsetH),
      activo: Value(activo),
    );
  }

  factory LocalSitio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSitio(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      radioMetros: serializer.fromJson<int>(json['radioMetros']),
      horaInicioTurno: serializer.fromJson<String>(json['horaInicioTurno']),
      minutosToleranciaRetardo: serializer.fromJson<int>(
        json['minutosToleranciaRetardo'],
      ),
      minutosToleranciaFalta: serializer.fromJson<int>(
        json['minutosToleranciaFalta'],
      ),
      husoHorarioOffsetH: serializer.fromJson<int>(json['husoHorarioOffsetH']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'radioMetros': serializer.toJson<int>(radioMetros),
      'horaInicioTurno': serializer.toJson<String>(horaInicioTurno),
      'minutosToleranciaRetardo': serializer.toJson<int>(
        minutosToleranciaRetardo,
      ),
      'minutosToleranciaFalta': serializer.toJson<int>(minutosToleranciaFalta),
      'husoHorarioOffsetH': serializer.toJson<int>(husoHorarioOffsetH),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  LocalSitio copyWith({
    String? id,
    String? nombre,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    int? radioMetros,
    String? horaInicioTurno,
    int? minutosToleranciaRetardo,
    int? minutosToleranciaFalta,
    int? husoHorarioOffsetH,
    bool? activo,
  }) => LocalSitio(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    radioMetros: radioMetros ?? this.radioMetros,
    horaInicioTurno: horaInicioTurno ?? this.horaInicioTurno,
    minutosToleranciaRetardo:
        minutosToleranciaRetardo ?? this.minutosToleranciaRetardo,
    minutosToleranciaFalta:
        minutosToleranciaFalta ?? this.minutosToleranciaFalta,
    husoHorarioOffsetH: husoHorarioOffsetH ?? this.husoHorarioOffsetH,
    activo: activo ?? this.activo,
  );
  LocalSitio copyWithCompanion(LocalSitiosCompanion data) {
    return LocalSitio(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      radioMetros: data.radioMetros.present
          ? data.radioMetros.value
          : this.radioMetros,
      horaInicioTurno: data.horaInicioTurno.present
          ? data.horaInicioTurno.value
          : this.horaInicioTurno,
      minutosToleranciaRetardo: data.minutosToleranciaRetardo.present
          ? data.minutosToleranciaRetardo.value
          : this.minutosToleranciaRetardo,
      minutosToleranciaFalta: data.minutosToleranciaFalta.present
          ? data.minutosToleranciaFalta.value
          : this.minutosToleranciaFalta,
      husoHorarioOffsetH: data.husoHorarioOffsetH.present
          ? data.husoHorarioOffsetH.value
          : this.husoHorarioOffsetH,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSitio(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('radioMetros: $radioMetros, ')
          ..write('horaInicioTurno: $horaInicioTurno, ')
          ..write('minutosToleranciaRetardo: $minutosToleranciaRetardo, ')
          ..write('minutosToleranciaFalta: $minutosToleranciaFalta, ')
          ..write('husoHorarioOffsetH: $husoHorarioOffsetH, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    lat,
    lng,
    radioMetros,
    horaInicioTurno,
    minutosToleranciaRetardo,
    minutosToleranciaFalta,
    husoHorarioOffsetH,
    activo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSitio &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.radioMetros == this.radioMetros &&
          other.horaInicioTurno == this.horaInicioTurno &&
          other.minutosToleranciaRetardo == this.minutosToleranciaRetardo &&
          other.minutosToleranciaFalta == this.minutosToleranciaFalta &&
          other.husoHorarioOffsetH == this.husoHorarioOffsetH &&
          other.activo == this.activo);
}

class LocalSitiosCompanion extends UpdateCompanion<LocalSitio> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<int> radioMetros;
  final Value<String> horaInicioTurno;
  final Value<int> minutosToleranciaRetardo;
  final Value<int> minutosToleranciaFalta;
  final Value<int> husoHorarioOffsetH;
  final Value<bool> activo;
  final Value<int> rowid;
  const LocalSitiosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.radioMetros = const Value.absent(),
    this.horaInicioTurno = const Value.absent(),
    this.minutosToleranciaRetardo = const Value.absent(),
    this.minutosToleranciaFalta = const Value.absent(),
    this.husoHorarioOffsetH = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSitiosCompanion.insert({
    required String id,
    required String nombre,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.radioMetros = const Value.absent(),
    this.horaInicioTurno = const Value.absent(),
    this.minutosToleranciaRetardo = const Value.absent(),
    this.minutosToleranciaFalta = const Value.absent(),
    this.husoHorarioOffsetH = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre);
  static Insertable<LocalSitio> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<int>? radioMetros,
    Expression<String>? horaInicioTurno,
    Expression<int>? minutosToleranciaRetardo,
    Expression<int>? minutosToleranciaFalta,
    Expression<int>? husoHorarioOffsetH,
    Expression<bool>? activo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (radioMetros != null) 'radio_metros': radioMetros,
      if (horaInicioTurno != null) 'hora_inicio_turno': horaInicioTurno,
      if (minutosToleranciaRetardo != null)
        'minutos_tolerancia_retardo': minutosToleranciaRetardo,
      if (minutosToleranciaFalta != null)
        'minutos_tolerancia_falta': minutosToleranciaFalta,
      if (husoHorarioOffsetH != null)
        'huso_horario_offset_h': husoHorarioOffsetH,
      if (activo != null) 'activo': activo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSitiosCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<int>? radioMetros,
    Value<String>? horaInicioTurno,
    Value<int>? minutosToleranciaRetardo,
    Value<int>? minutosToleranciaFalta,
    Value<int>? husoHorarioOffsetH,
    Value<bool>? activo,
    Value<int>? rowid,
  }) {
    return LocalSitiosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      radioMetros: radioMetros ?? this.radioMetros,
      horaInicioTurno: horaInicioTurno ?? this.horaInicioTurno,
      minutosToleranciaRetardo:
          minutosToleranciaRetardo ?? this.minutosToleranciaRetardo,
      minutosToleranciaFalta:
          minutosToleranciaFalta ?? this.minutosToleranciaFalta,
      husoHorarioOffsetH: husoHorarioOffsetH ?? this.husoHorarioOffsetH,
      activo: activo ?? this.activo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (radioMetros.present) {
      map['radio_metros'] = Variable<int>(radioMetros.value);
    }
    if (horaInicioTurno.present) {
      map['hora_inicio_turno'] = Variable<String>(horaInicioTurno.value);
    }
    if (minutosToleranciaRetardo.present) {
      map['minutos_tolerancia_retardo'] = Variable<int>(
        minutosToleranciaRetardo.value,
      );
    }
    if (minutosToleranciaFalta.present) {
      map['minutos_tolerancia_falta'] = Variable<int>(
        minutosToleranciaFalta.value,
      );
    }
    if (husoHorarioOffsetH.present) {
      map['huso_horario_offset_h'] = Variable<int>(husoHorarioOffsetH.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSitiosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('radioMetros: $radioMetros, ')
          ..write('horaInicioTurno: $horaInicioTurno, ')
          ..write('minutosToleranciaRetardo: $minutosToleranciaRetardo, ')
          ..write('minutosToleranciaFalta: $minutosToleranciaFalta, ')
          ..write('husoHorarioOffsetH: $husoHorarioOffsetH, ')
          ..write('activo: $activo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWifiApsTable extends LocalWifiAps
    with TableInfo<$LocalWifiApsTable, LocalWifiAp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWifiApsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sitioIdMeta = const VerificationMeta(
    'sitioId',
  );
  @override
  late final GeneratedColumn<String> sitioId = GeneratedColumn<String>(
    'sitio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bssidMeta = const VerificationMeta('bssid');
  @override
  late final GeneratedColumn<String> bssid = GeneratedColumn<String>(
    'bssid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ssidMeta = const VerificationMeta('ssid');
  @override
  late final GeneratedColumn<String> ssid = GeneratedColumn<String>(
    'ssid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nombreZonaMeta = const VerificationMeta(
    'nombreZona',
  );
  @override
  late final GeneratedColumn<String> nombreZona = GeneratedColumn<String>(
    'nombre_zona',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sitioId,
    bssid,
    ssid,
    nombreZona,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_wifi_aps';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWifiAp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sitio_id')) {
      context.handle(
        _sitioIdMeta,
        sitioId.isAcceptableOrUnknown(data['sitio_id']!, _sitioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sitioIdMeta);
    }
    if (data.containsKey('bssid')) {
      context.handle(
        _bssidMeta,
        bssid.isAcceptableOrUnknown(data['bssid']!, _bssidMeta),
      );
    } else if (isInserting) {
      context.missing(_bssidMeta);
    }
    if (data.containsKey('ssid')) {
      context.handle(
        _ssidMeta,
        ssid.isAcceptableOrUnknown(data['ssid']!, _ssidMeta),
      );
    }
    if (data.containsKey('nombre_zona')) {
      context.handle(
        _nombreZonaMeta,
        nombreZona.isAcceptableOrUnknown(data['nombre_zona']!, _nombreZonaMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWifiAp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWifiAp(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sitioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sitio_id'],
      )!,
      bssid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bssid'],
      )!,
      ssid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ssid'],
      )!,
      nombreZona: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_zona'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $LocalWifiApsTable createAlias(String alias) {
    return $LocalWifiApsTable(attachedDatabase, alias);
  }
}

class LocalWifiAp extends DataClass implements Insertable<LocalWifiAp> {
  final String id;
  final String sitioId;
  final String bssid;
  final String ssid;
  final String nombreZona;
  final bool activo;
  const LocalWifiAp({
    required this.id,
    required this.sitioId,
    required this.bssid,
    required this.ssid,
    required this.nombreZona,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sitio_id'] = Variable<String>(sitioId);
    map['bssid'] = Variable<String>(bssid);
    map['ssid'] = Variable<String>(ssid);
    map['nombre_zona'] = Variable<String>(nombreZona);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  LocalWifiApsCompanion toCompanion(bool nullToAbsent) {
    return LocalWifiApsCompanion(
      id: Value(id),
      sitioId: Value(sitioId),
      bssid: Value(bssid),
      ssid: Value(ssid),
      nombreZona: Value(nombreZona),
      activo: Value(activo),
    );
  }

  factory LocalWifiAp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWifiAp(
      id: serializer.fromJson<String>(json['id']),
      sitioId: serializer.fromJson<String>(json['sitioId']),
      bssid: serializer.fromJson<String>(json['bssid']),
      ssid: serializer.fromJson<String>(json['ssid']),
      nombreZona: serializer.fromJson<String>(json['nombreZona']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sitioId': serializer.toJson<String>(sitioId),
      'bssid': serializer.toJson<String>(bssid),
      'ssid': serializer.toJson<String>(ssid),
      'nombreZona': serializer.toJson<String>(nombreZona),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  LocalWifiAp copyWith({
    String? id,
    String? sitioId,
    String? bssid,
    String? ssid,
    String? nombreZona,
    bool? activo,
  }) => LocalWifiAp(
    id: id ?? this.id,
    sitioId: sitioId ?? this.sitioId,
    bssid: bssid ?? this.bssid,
    ssid: ssid ?? this.ssid,
    nombreZona: nombreZona ?? this.nombreZona,
    activo: activo ?? this.activo,
  );
  LocalWifiAp copyWithCompanion(LocalWifiApsCompanion data) {
    return LocalWifiAp(
      id: data.id.present ? data.id.value : this.id,
      sitioId: data.sitioId.present ? data.sitioId.value : this.sitioId,
      bssid: data.bssid.present ? data.bssid.value : this.bssid,
      ssid: data.ssid.present ? data.ssid.value : this.ssid,
      nombreZona: data.nombreZona.present
          ? data.nombreZona.value
          : this.nombreZona,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWifiAp(')
          ..write('id: $id, ')
          ..write('sitioId: $sitioId, ')
          ..write('bssid: $bssid, ')
          ..write('ssid: $ssid, ')
          ..write('nombreZona: $nombreZona, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sitioId, bssid, ssid, nombreZona, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWifiAp &&
          other.id == this.id &&
          other.sitioId == this.sitioId &&
          other.bssid == this.bssid &&
          other.ssid == this.ssid &&
          other.nombreZona == this.nombreZona &&
          other.activo == this.activo);
}

class LocalWifiApsCompanion extends UpdateCompanion<LocalWifiAp> {
  final Value<String> id;
  final Value<String> sitioId;
  final Value<String> bssid;
  final Value<String> ssid;
  final Value<String> nombreZona;
  final Value<bool> activo;
  final Value<int> rowid;
  const LocalWifiApsCompanion({
    this.id = const Value.absent(),
    this.sitioId = const Value.absent(),
    this.bssid = const Value.absent(),
    this.ssid = const Value.absent(),
    this.nombreZona = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWifiApsCompanion.insert({
    required String id,
    required String sitioId,
    required String bssid,
    this.ssid = const Value.absent(),
    this.nombreZona = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sitioId = Value(sitioId),
       bssid = Value(bssid);
  static Insertable<LocalWifiAp> custom({
    Expression<String>? id,
    Expression<String>? sitioId,
    Expression<String>? bssid,
    Expression<String>? ssid,
    Expression<String>? nombreZona,
    Expression<bool>? activo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sitioId != null) 'sitio_id': sitioId,
      if (bssid != null) 'bssid': bssid,
      if (ssid != null) 'ssid': ssid,
      if (nombreZona != null) 'nombre_zona': nombreZona,
      if (activo != null) 'activo': activo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWifiApsCompanion copyWith({
    Value<String>? id,
    Value<String>? sitioId,
    Value<String>? bssid,
    Value<String>? ssid,
    Value<String>? nombreZona,
    Value<bool>? activo,
    Value<int>? rowid,
  }) {
    return LocalWifiApsCompanion(
      id: id ?? this.id,
      sitioId: sitioId ?? this.sitioId,
      bssid: bssid ?? this.bssid,
      ssid: ssid ?? this.ssid,
      nombreZona: nombreZona ?? this.nombreZona,
      activo: activo ?? this.activo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sitioId.present) {
      map['sitio_id'] = Variable<String>(sitioId.value);
    }
    if (bssid.present) {
      map['bssid'] = Variable<String>(bssid.value);
    }
    if (ssid.present) {
      map['ssid'] = Variable<String>(ssid.value);
    }
    if (nombreZona.present) {
      map['nombre_zona'] = Variable<String>(nombreZona.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWifiApsCompanion(')
          ..write('id: $id, ')
          ..write('sitioId: $sitioId, ')
          ..write('bssid: $bssid, ')
          ..write('ssid: $ssid, ')
          ..write('nombreZona: $nombreZona, ')
          ..write('activo: $activo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCatalogoEquipoTable extends LocalCatalogoEquipo
    with TableInfo<$LocalCatalogoEquipoTable, LocalCatalogoEquipoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCatalogoEquipoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sitioIdMeta = const VerificationMeta(
    'sitioId',
  );
  @override
  late final GeneratedColumn<String> sitioId = GeneratedColumn<String>(
    'sitio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _cantidadEsperadaMeta = const VerificationMeta(
    'cantidadEsperada',
  );
  @override
  late final GeneratedColumn<int> cantidadEsperada = GeneratedColumn<int>(
    'cantidad_esperada',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _requiereFotoMeta = const VerificationMeta(
    'requiereFoto',
  );
  @override
  late final GeneratedColumn<bool> requiereFoto = GeneratedColumn<bool>(
    'requiere_foto',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requiere_foto" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _debeEstarSinUsarMeta = const VerificationMeta(
    'debeEstarSinUsar',
  );
  @override
  late final GeneratedColumn<bool> debeEstarSinUsar = GeneratedColumn<bool>(
    'debe_estar_sin_usar',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("debe_estar_sin_usar" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sitioId,
    nombre,
    descripcion,
    categoria,
    cantidadEsperada,
    requiereFoto,
    debeEstarSinUsar,
    orden,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_catalogo_equipo';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCatalogoEquipoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sitio_id')) {
      context.handle(
        _sitioIdMeta,
        sitioId.isAcceptableOrUnknown(data['sitio_id']!, _sitioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sitioIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('cantidad_esperada')) {
      context.handle(
        _cantidadEsperadaMeta,
        cantidadEsperada.isAcceptableOrUnknown(
          data['cantidad_esperada']!,
          _cantidadEsperadaMeta,
        ),
      );
    }
    if (data.containsKey('requiere_foto')) {
      context.handle(
        _requiereFotoMeta,
        requiereFoto.isAcceptableOrUnknown(
          data['requiere_foto']!,
          _requiereFotoMeta,
        ),
      );
    }
    if (data.containsKey('debe_estar_sin_usar')) {
      context.handle(
        _debeEstarSinUsarMeta,
        debeEstarSinUsar.isAcceptableOrUnknown(
          data['debe_estar_sin_usar']!,
          _debeEstarSinUsarMeta,
        ),
      );
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCatalogoEquipoData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCatalogoEquipoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sitioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sitio_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      )!,
      cantidadEsperada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_esperada'],
      )!,
      requiereFoto: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requiere_foto'],
      )!,
      debeEstarSinUsar: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}debe_estar_sin_usar'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $LocalCatalogoEquipoTable createAlias(String alias) {
    return $LocalCatalogoEquipoTable(attachedDatabase, alias);
  }
}

class LocalCatalogoEquipoData extends DataClass
    implements Insertable<LocalCatalogoEquipoData> {
  final String id;
  final String sitioId;
  final String nombre;
  final String descripcion;
  final String categoria;
  final int cantidadEsperada;
  final bool requiereFoto;
  final bool debeEstarSinUsar;
  final int orden;
  final bool activo;
  const LocalCatalogoEquipoData({
    required this.id,
    required this.sitioId,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.cantidadEsperada,
    required this.requiereFoto,
    required this.debeEstarSinUsar,
    required this.orden,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sitio_id'] = Variable<String>(sitioId);
    map['nombre'] = Variable<String>(nombre);
    map['descripcion'] = Variable<String>(descripcion);
    map['categoria'] = Variable<String>(categoria);
    map['cantidad_esperada'] = Variable<int>(cantidadEsperada);
    map['requiere_foto'] = Variable<bool>(requiereFoto);
    map['debe_estar_sin_usar'] = Variable<bool>(debeEstarSinUsar);
    map['orden'] = Variable<int>(orden);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  LocalCatalogoEquipoCompanion toCompanion(bool nullToAbsent) {
    return LocalCatalogoEquipoCompanion(
      id: Value(id),
      sitioId: Value(sitioId),
      nombre: Value(nombre),
      descripcion: Value(descripcion),
      categoria: Value(categoria),
      cantidadEsperada: Value(cantidadEsperada),
      requiereFoto: Value(requiereFoto),
      debeEstarSinUsar: Value(debeEstarSinUsar),
      orden: Value(orden),
      activo: Value(activo),
    );
  }

  factory LocalCatalogoEquipoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCatalogoEquipoData(
      id: serializer.fromJson<String>(json['id']),
      sitioId: serializer.fromJson<String>(json['sitioId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      categoria: serializer.fromJson<String>(json['categoria']),
      cantidadEsperada: serializer.fromJson<int>(json['cantidadEsperada']),
      requiereFoto: serializer.fromJson<bool>(json['requiereFoto']),
      debeEstarSinUsar: serializer.fromJson<bool>(json['debeEstarSinUsar']),
      orden: serializer.fromJson<int>(json['orden']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sitioId': serializer.toJson<String>(sitioId),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String>(descripcion),
      'categoria': serializer.toJson<String>(categoria),
      'cantidadEsperada': serializer.toJson<int>(cantidadEsperada),
      'requiereFoto': serializer.toJson<bool>(requiereFoto),
      'debeEstarSinUsar': serializer.toJson<bool>(debeEstarSinUsar),
      'orden': serializer.toJson<int>(orden),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  LocalCatalogoEquipoData copyWith({
    String? id,
    String? sitioId,
    String? nombre,
    String? descripcion,
    String? categoria,
    int? cantidadEsperada,
    bool? requiereFoto,
    bool? debeEstarSinUsar,
    int? orden,
    bool? activo,
  }) => LocalCatalogoEquipoData(
    id: id ?? this.id,
    sitioId: sitioId ?? this.sitioId,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    categoria: categoria ?? this.categoria,
    cantidadEsperada: cantidadEsperada ?? this.cantidadEsperada,
    requiereFoto: requiereFoto ?? this.requiereFoto,
    debeEstarSinUsar: debeEstarSinUsar ?? this.debeEstarSinUsar,
    orden: orden ?? this.orden,
    activo: activo ?? this.activo,
  );
  LocalCatalogoEquipoData copyWithCompanion(LocalCatalogoEquipoCompanion data) {
    return LocalCatalogoEquipoData(
      id: data.id.present ? data.id.value : this.id,
      sitioId: data.sitioId.present ? data.sitioId.value : this.sitioId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      cantidadEsperada: data.cantidadEsperada.present
          ? data.cantidadEsperada.value
          : this.cantidadEsperada,
      requiereFoto: data.requiereFoto.present
          ? data.requiereFoto.value
          : this.requiereFoto,
      debeEstarSinUsar: data.debeEstarSinUsar.present
          ? data.debeEstarSinUsar.value
          : this.debeEstarSinUsar,
      orden: data.orden.present ? data.orden.value : this.orden,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCatalogoEquipoData(')
          ..write('id: $id, ')
          ..write('sitioId: $sitioId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoria: $categoria, ')
          ..write('cantidadEsperada: $cantidadEsperada, ')
          ..write('requiereFoto: $requiereFoto, ')
          ..write('debeEstarSinUsar: $debeEstarSinUsar, ')
          ..write('orden: $orden, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sitioId,
    nombre,
    descripcion,
    categoria,
    cantidadEsperada,
    requiereFoto,
    debeEstarSinUsar,
    orden,
    activo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCatalogoEquipoData &&
          other.id == this.id &&
          other.sitioId == this.sitioId &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.categoria == this.categoria &&
          other.cantidadEsperada == this.cantidadEsperada &&
          other.requiereFoto == this.requiereFoto &&
          other.debeEstarSinUsar == this.debeEstarSinUsar &&
          other.orden == this.orden &&
          other.activo == this.activo);
}

class LocalCatalogoEquipoCompanion
    extends UpdateCompanion<LocalCatalogoEquipoData> {
  final Value<String> id;
  final Value<String> sitioId;
  final Value<String> nombre;
  final Value<String> descripcion;
  final Value<String> categoria;
  final Value<int> cantidadEsperada;
  final Value<bool> requiereFoto;
  final Value<bool> debeEstarSinUsar;
  final Value<int> orden;
  final Value<bool> activo;
  final Value<int> rowid;
  const LocalCatalogoEquipoCompanion({
    this.id = const Value.absent(),
    this.sitioId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.categoria = const Value.absent(),
    this.cantidadEsperada = const Value.absent(),
    this.requiereFoto = const Value.absent(),
    this.debeEstarSinUsar = const Value.absent(),
    this.orden = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCatalogoEquipoCompanion.insert({
    required String id,
    required String sitioId,
    required String nombre,
    this.descripcion = const Value.absent(),
    this.categoria = const Value.absent(),
    this.cantidadEsperada = const Value.absent(),
    this.requiereFoto = const Value.absent(),
    this.debeEstarSinUsar = const Value.absent(),
    this.orden = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sitioId = Value(sitioId),
       nombre = Value(nombre);
  static Insertable<LocalCatalogoEquipoData> custom({
    Expression<String>? id,
    Expression<String>? sitioId,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? categoria,
    Expression<int>? cantidadEsperada,
    Expression<bool>? requiereFoto,
    Expression<bool>? debeEstarSinUsar,
    Expression<int>? orden,
    Expression<bool>? activo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sitioId != null) 'sitio_id': sitioId,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (categoria != null) 'categoria': categoria,
      if (cantidadEsperada != null) 'cantidad_esperada': cantidadEsperada,
      if (requiereFoto != null) 'requiere_foto': requiereFoto,
      if (debeEstarSinUsar != null) 'debe_estar_sin_usar': debeEstarSinUsar,
      if (orden != null) 'orden': orden,
      if (activo != null) 'activo': activo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCatalogoEquipoCompanion copyWith({
    Value<String>? id,
    Value<String>? sitioId,
    Value<String>? nombre,
    Value<String>? descripcion,
    Value<String>? categoria,
    Value<int>? cantidadEsperada,
    Value<bool>? requiereFoto,
    Value<bool>? debeEstarSinUsar,
    Value<int>? orden,
    Value<bool>? activo,
    Value<int>? rowid,
  }) {
    return LocalCatalogoEquipoCompanion(
      id: id ?? this.id,
      sitioId: sitioId ?? this.sitioId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      cantidadEsperada: cantidadEsperada ?? this.cantidadEsperada,
      requiereFoto: requiereFoto ?? this.requiereFoto,
      debeEstarSinUsar: debeEstarSinUsar ?? this.debeEstarSinUsar,
      orden: orden ?? this.orden,
      activo: activo ?? this.activo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sitioId.present) {
      map['sitio_id'] = Variable<String>(sitioId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (cantidadEsperada.present) {
      map['cantidad_esperada'] = Variable<int>(cantidadEsperada.value);
    }
    if (requiereFoto.present) {
      map['requiere_foto'] = Variable<bool>(requiereFoto.value);
    }
    if (debeEstarSinUsar.present) {
      map['debe_estar_sin_usar'] = Variable<bool>(debeEstarSinUsar.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCatalogoEquipoCompanion(')
          ..write('id: $id, ')
          ..write('sitioId: $sitioId, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('categoria: $categoria, ')
          ..write('cantidadEsperada: $cantidadEsperada, ')
          ..write('requiereFoto: $requiereFoto, ')
          ..write('debeEstarSinUsar: $debeEstarSinUsar, ')
          ..write('orden: $orden, ')
          ..write('activo: $activo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPersonalClienteTable extends LocalPersonalCliente
    with TableInfo<$LocalPersonalClienteTable, LocalPersonalClienteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPersonalClienteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sitioIdMeta = const VerificationMeta(
    'sitioId',
  );
  @override
  late final GeneratedColumn<String> sitioId = GeneratedColumn<String>(
    'sitio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreCompletoMeta = const VerificationMeta(
    'nombreCompleto',
  );
  @override
  late final GeneratedColumn<String> nombreCompleto = GeneratedColumn<String>(
    'nombre_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _puestoMeta = const VerificationMeta('puesto');
  @override
  late final GeneratedColumn<String> puesto = GeneratedColumn<String>(
    'puesto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _extensionMeta = const VerificationMeta(
    'extension',
  );
  @override
  late final GeneratedColumn<String> extension = GeneratedColumn<String>(
    'extension',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sitioId,
    nombreCompleto,
    area,
    puesto,
    extension,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_personal_cliente';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPersonalClienteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sitio_id')) {
      context.handle(
        _sitioIdMeta,
        sitioId.isAcceptableOrUnknown(data['sitio_id']!, _sitioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sitioIdMeta);
    }
    if (data.containsKey('nombre_completo')) {
      context.handle(
        _nombreCompletoMeta,
        nombreCompleto.isAcceptableOrUnknown(
          data['nombre_completo']!,
          _nombreCompletoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreCompletoMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    }
    if (data.containsKey('puesto')) {
      context.handle(
        _puestoMeta,
        puesto.isAcceptableOrUnknown(data['puesto']!, _puestoMeta),
      );
    }
    if (data.containsKey('extension')) {
      context.handle(
        _extensionMeta,
        extension.isAcceptableOrUnknown(data['extension']!, _extensionMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPersonalClienteData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPersonalClienteData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sitioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sitio_id'],
      )!,
      nombreCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_completo'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      )!,
      puesto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}puesto'],
      )!,
      extension: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extension'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $LocalPersonalClienteTable createAlias(String alias) {
    return $LocalPersonalClienteTable(attachedDatabase, alias);
  }
}

class LocalPersonalClienteData extends DataClass
    implements Insertable<LocalPersonalClienteData> {
  final String id;
  final String sitioId;
  final String nombreCompleto;
  final String area;
  final String puesto;
  final String extension;
  final bool activo;
  const LocalPersonalClienteData({
    required this.id,
    required this.sitioId,
    required this.nombreCompleto,
    required this.area,
    required this.puesto,
    required this.extension,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sitio_id'] = Variable<String>(sitioId);
    map['nombre_completo'] = Variable<String>(nombreCompleto);
    map['area'] = Variable<String>(area);
    map['puesto'] = Variable<String>(puesto);
    map['extension'] = Variable<String>(extension);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  LocalPersonalClienteCompanion toCompanion(bool nullToAbsent) {
    return LocalPersonalClienteCompanion(
      id: Value(id),
      sitioId: Value(sitioId),
      nombreCompleto: Value(nombreCompleto),
      area: Value(area),
      puesto: Value(puesto),
      extension: Value(extension),
      activo: Value(activo),
    );
  }

  factory LocalPersonalClienteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPersonalClienteData(
      id: serializer.fromJson<String>(json['id']),
      sitioId: serializer.fromJson<String>(json['sitioId']),
      nombreCompleto: serializer.fromJson<String>(json['nombreCompleto']),
      area: serializer.fromJson<String>(json['area']),
      puesto: serializer.fromJson<String>(json['puesto']),
      extension: serializer.fromJson<String>(json['extension']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sitioId': serializer.toJson<String>(sitioId),
      'nombreCompleto': serializer.toJson<String>(nombreCompleto),
      'area': serializer.toJson<String>(area),
      'puesto': serializer.toJson<String>(puesto),
      'extension': serializer.toJson<String>(extension),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  LocalPersonalClienteData copyWith({
    String? id,
    String? sitioId,
    String? nombreCompleto,
    String? area,
    String? puesto,
    String? extension,
    bool? activo,
  }) => LocalPersonalClienteData(
    id: id ?? this.id,
    sitioId: sitioId ?? this.sitioId,
    nombreCompleto: nombreCompleto ?? this.nombreCompleto,
    area: area ?? this.area,
    puesto: puesto ?? this.puesto,
    extension: extension ?? this.extension,
    activo: activo ?? this.activo,
  );
  LocalPersonalClienteData copyWithCompanion(
    LocalPersonalClienteCompanion data,
  ) {
    return LocalPersonalClienteData(
      id: data.id.present ? data.id.value : this.id,
      sitioId: data.sitioId.present ? data.sitioId.value : this.sitioId,
      nombreCompleto: data.nombreCompleto.present
          ? data.nombreCompleto.value
          : this.nombreCompleto,
      area: data.area.present ? data.area.value : this.area,
      puesto: data.puesto.present ? data.puesto.value : this.puesto,
      extension: data.extension.present ? data.extension.value : this.extension,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPersonalClienteData(')
          ..write('id: $id, ')
          ..write('sitioId: $sitioId, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('area: $area, ')
          ..write('puesto: $puesto, ')
          ..write('extension: $extension, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sitioId, nombreCompleto, area, puesto, extension, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPersonalClienteData &&
          other.id == this.id &&
          other.sitioId == this.sitioId &&
          other.nombreCompleto == this.nombreCompleto &&
          other.area == this.area &&
          other.puesto == this.puesto &&
          other.extension == this.extension &&
          other.activo == this.activo);
}

class LocalPersonalClienteCompanion
    extends UpdateCompanion<LocalPersonalClienteData> {
  final Value<String> id;
  final Value<String> sitioId;
  final Value<String> nombreCompleto;
  final Value<String> area;
  final Value<String> puesto;
  final Value<String> extension;
  final Value<bool> activo;
  final Value<int> rowid;
  const LocalPersonalClienteCompanion({
    this.id = const Value.absent(),
    this.sitioId = const Value.absent(),
    this.nombreCompleto = const Value.absent(),
    this.area = const Value.absent(),
    this.puesto = const Value.absent(),
    this.extension = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPersonalClienteCompanion.insert({
    required String id,
    required String sitioId,
    required String nombreCompleto,
    this.area = const Value.absent(),
    this.puesto = const Value.absent(),
    this.extension = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sitioId = Value(sitioId),
       nombreCompleto = Value(nombreCompleto);
  static Insertable<LocalPersonalClienteData> custom({
    Expression<String>? id,
    Expression<String>? sitioId,
    Expression<String>? nombreCompleto,
    Expression<String>? area,
    Expression<String>? puesto,
    Expression<String>? extension,
    Expression<bool>? activo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sitioId != null) 'sitio_id': sitioId,
      if (nombreCompleto != null) 'nombre_completo': nombreCompleto,
      if (area != null) 'area': area,
      if (puesto != null) 'puesto': puesto,
      if (extension != null) 'extension': extension,
      if (activo != null) 'activo': activo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPersonalClienteCompanion copyWith({
    Value<String>? id,
    Value<String>? sitioId,
    Value<String>? nombreCompleto,
    Value<String>? area,
    Value<String>? puesto,
    Value<String>? extension,
    Value<bool>? activo,
    Value<int>? rowid,
  }) {
    return LocalPersonalClienteCompanion(
      id: id ?? this.id,
      sitioId: sitioId ?? this.sitioId,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      area: area ?? this.area,
      puesto: puesto ?? this.puesto,
      extension: extension ?? this.extension,
      activo: activo ?? this.activo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sitioId.present) {
      map['sitio_id'] = Variable<String>(sitioId.value);
    }
    if (nombreCompleto.present) {
      map['nombre_completo'] = Variable<String>(nombreCompleto.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (puesto.present) {
      map['puesto'] = Variable<String>(puesto.value);
    }
    if (extension.present) {
      map['extension'] = Variable<String>(extension.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPersonalClienteCompanion(')
          ..write('id: $id, ')
          ..write('sitioId: $sitioId, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('area: $area, ')
          ..write('puesto: $puesto, ')
          ..write('extension: $extension, ')
          ..write('activo: $activo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProfilesTable extends LocalProfiles
    with TableInfo<$LocalProfilesTable, LocalProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreCompletoMeta = const VerificationMeta(
    'nombreCompleto',
  );
  @override
  late final GeneratedColumn<String> nombreCompleto = GeneratedColumn<String>(
    'nombre_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correoMeta = const VerificationMeta('correo');
  @override
  late final GeneratedColumn<String> correo = GeneratedColumn<String>(
    'correo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _telefonoWhatsappMeta = const VerificationMeta(
    'telefonoWhatsapp',
  );
  @override
  late final GeneratedColumn<String> telefonoWhatsapp = GeneratedColumn<String>(
    'telefono_whatsapp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rolMeta = const VerificationMeta('rol');
  @override
  late final GeneratedColumn<String> rol = GeneratedColumn<String>(
    'rol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _puestoMeta = const VerificationMeta('puesto');
  @override
  late final GeneratedColumn<String> puesto = GeneratedColumn<String>(
    'puesto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fotoPerfilUrlMeta = const VerificationMeta(
    'fotoPerfilUrl',
  );
  @override
  late final GeneratedColumn<String> fotoPerfilUrl = GeneratedColumn<String>(
    'foto_perfil_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoLaboralMeta = const VerificationMeta(
    'estadoLaboral',
  );
  @override
  late final GeneratedColumn<String> estadoLaboral = GeneratedColumn<String>(
    'estado_laboral',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('activo'),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombreCompleto,
    correo,
    telefonoWhatsapp,
    rol,
    puesto,
    fotoPerfilUrl,
    estadoLaboral,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre_completo')) {
      context.handle(
        _nombreCompletoMeta,
        nombreCompleto.isAcceptableOrUnknown(
          data['nombre_completo']!,
          _nombreCompletoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreCompletoMeta);
    }
    if (data.containsKey('correo')) {
      context.handle(
        _correoMeta,
        correo.isAcceptableOrUnknown(data['correo']!, _correoMeta),
      );
    }
    if (data.containsKey('telefono_whatsapp')) {
      context.handle(
        _telefonoWhatsappMeta,
        telefonoWhatsapp.isAcceptableOrUnknown(
          data['telefono_whatsapp']!,
          _telefonoWhatsappMeta,
        ),
      );
    }
    if (data.containsKey('rol')) {
      context.handle(
        _rolMeta,
        rol.isAcceptableOrUnknown(data['rol']!, _rolMeta),
      );
    } else if (isInserting) {
      context.missing(_rolMeta);
    }
    if (data.containsKey('puesto')) {
      context.handle(
        _puestoMeta,
        puesto.isAcceptableOrUnknown(data['puesto']!, _puestoMeta),
      );
    }
    if (data.containsKey('foto_perfil_url')) {
      context.handle(
        _fotoPerfilUrlMeta,
        fotoPerfilUrl.isAcceptableOrUnknown(
          data['foto_perfil_url']!,
          _fotoPerfilUrlMeta,
        ),
      );
    }
    if (data.containsKey('estado_laboral')) {
      context.handle(
        _estadoLaboralMeta,
        estadoLaboral.isAcceptableOrUnknown(
          data['estado_laboral']!,
          _estadoLaboralMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombreCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_completo'],
      )!,
      correo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correo'],
      )!,
      telefonoWhatsapp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono_whatsapp'],
      )!,
      rol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol'],
      )!,
      puesto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}puesto'],
      )!,
      fotoPerfilUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_perfil_url'],
      ),
      estadoLaboral: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado_laboral'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $LocalProfilesTable createAlias(String alias) {
    return $LocalProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfile extends DataClass implements Insertable<LocalProfile> {
  final String id;
  final String nombreCompleto;
  final String correo;
  final String telefonoWhatsapp;
  final String rol;
  final String puesto;
  final String? fotoPerfilUrl;
  final String estadoLaboral;
  final bool activo;
  const LocalProfile({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.telefonoWhatsapp,
    required this.rol,
    required this.puesto,
    this.fotoPerfilUrl,
    required this.estadoLaboral,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre_completo'] = Variable<String>(nombreCompleto);
    map['correo'] = Variable<String>(correo);
    map['telefono_whatsapp'] = Variable<String>(telefonoWhatsapp);
    map['rol'] = Variable<String>(rol);
    map['puesto'] = Variable<String>(puesto);
    if (!nullToAbsent || fotoPerfilUrl != null) {
      map['foto_perfil_url'] = Variable<String>(fotoPerfilUrl);
    }
    map['estado_laboral'] = Variable<String>(estadoLaboral);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  LocalProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalProfilesCompanion(
      id: Value(id),
      nombreCompleto: Value(nombreCompleto),
      correo: Value(correo),
      telefonoWhatsapp: Value(telefonoWhatsapp),
      rol: Value(rol),
      puesto: Value(puesto),
      fotoPerfilUrl: fotoPerfilUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fotoPerfilUrl),
      estadoLaboral: Value(estadoLaboral),
      activo: Value(activo),
    );
  }

  factory LocalProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfile(
      id: serializer.fromJson<String>(json['id']),
      nombreCompleto: serializer.fromJson<String>(json['nombreCompleto']),
      correo: serializer.fromJson<String>(json['correo']),
      telefonoWhatsapp: serializer.fromJson<String>(json['telefonoWhatsapp']),
      rol: serializer.fromJson<String>(json['rol']),
      puesto: serializer.fromJson<String>(json['puesto']),
      fotoPerfilUrl: serializer.fromJson<String?>(json['fotoPerfilUrl']),
      estadoLaboral: serializer.fromJson<String>(json['estadoLaboral']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombreCompleto': serializer.toJson<String>(nombreCompleto),
      'correo': serializer.toJson<String>(correo),
      'telefonoWhatsapp': serializer.toJson<String>(telefonoWhatsapp),
      'rol': serializer.toJson<String>(rol),
      'puesto': serializer.toJson<String>(puesto),
      'fotoPerfilUrl': serializer.toJson<String?>(fotoPerfilUrl),
      'estadoLaboral': serializer.toJson<String>(estadoLaboral),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  LocalProfile copyWith({
    String? id,
    String? nombreCompleto,
    String? correo,
    String? telefonoWhatsapp,
    String? rol,
    String? puesto,
    Value<String?> fotoPerfilUrl = const Value.absent(),
    String? estadoLaboral,
    bool? activo,
  }) => LocalProfile(
    id: id ?? this.id,
    nombreCompleto: nombreCompleto ?? this.nombreCompleto,
    correo: correo ?? this.correo,
    telefonoWhatsapp: telefonoWhatsapp ?? this.telefonoWhatsapp,
    rol: rol ?? this.rol,
    puesto: puesto ?? this.puesto,
    fotoPerfilUrl: fotoPerfilUrl.present
        ? fotoPerfilUrl.value
        : this.fotoPerfilUrl,
    estadoLaboral: estadoLaboral ?? this.estadoLaboral,
    activo: activo ?? this.activo,
  );
  LocalProfile copyWithCompanion(LocalProfilesCompanion data) {
    return LocalProfile(
      id: data.id.present ? data.id.value : this.id,
      nombreCompleto: data.nombreCompleto.present
          ? data.nombreCompleto.value
          : this.nombreCompleto,
      correo: data.correo.present ? data.correo.value : this.correo,
      telefonoWhatsapp: data.telefonoWhatsapp.present
          ? data.telefonoWhatsapp.value
          : this.telefonoWhatsapp,
      rol: data.rol.present ? data.rol.value : this.rol,
      puesto: data.puesto.present ? data.puesto.value : this.puesto,
      fotoPerfilUrl: data.fotoPerfilUrl.present
          ? data.fotoPerfilUrl.value
          : this.fotoPerfilUrl,
      estadoLaboral: data.estadoLaboral.present
          ? data.estadoLaboral.value
          : this.estadoLaboral,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfile(')
          ..write('id: $id, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('correo: $correo, ')
          ..write('telefonoWhatsapp: $telefonoWhatsapp, ')
          ..write('rol: $rol, ')
          ..write('puesto: $puesto, ')
          ..write('fotoPerfilUrl: $fotoPerfilUrl, ')
          ..write('estadoLaboral: $estadoLaboral, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombreCompleto,
    correo,
    telefonoWhatsapp,
    rol,
    puesto,
    fotoPerfilUrl,
    estadoLaboral,
    activo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfile &&
          other.id == this.id &&
          other.nombreCompleto == this.nombreCompleto &&
          other.correo == this.correo &&
          other.telefonoWhatsapp == this.telefonoWhatsapp &&
          other.rol == this.rol &&
          other.puesto == this.puesto &&
          other.fotoPerfilUrl == this.fotoPerfilUrl &&
          other.estadoLaboral == this.estadoLaboral &&
          other.activo == this.activo);
}

class LocalProfilesCompanion extends UpdateCompanion<LocalProfile> {
  final Value<String> id;
  final Value<String> nombreCompleto;
  final Value<String> correo;
  final Value<String> telefonoWhatsapp;
  final Value<String> rol;
  final Value<String> puesto;
  final Value<String?> fotoPerfilUrl;
  final Value<String> estadoLaboral;
  final Value<bool> activo;
  final Value<int> rowid;
  const LocalProfilesCompanion({
    this.id = const Value.absent(),
    this.nombreCompleto = const Value.absent(),
    this.correo = const Value.absent(),
    this.telefonoWhatsapp = const Value.absent(),
    this.rol = const Value.absent(),
    this.puesto = const Value.absent(),
    this.fotoPerfilUrl = const Value.absent(),
    this.estadoLaboral = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProfilesCompanion.insert({
    required String id,
    required String nombreCompleto,
    this.correo = const Value.absent(),
    this.telefonoWhatsapp = const Value.absent(),
    required String rol,
    this.puesto = const Value.absent(),
    this.fotoPerfilUrl = const Value.absent(),
    this.estadoLaboral = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombreCompleto = Value(nombreCompleto),
       rol = Value(rol);
  static Insertable<LocalProfile> custom({
    Expression<String>? id,
    Expression<String>? nombreCompleto,
    Expression<String>? correo,
    Expression<String>? telefonoWhatsapp,
    Expression<String>? rol,
    Expression<String>? puesto,
    Expression<String>? fotoPerfilUrl,
    Expression<String>? estadoLaboral,
    Expression<bool>? activo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreCompleto != null) 'nombre_completo': nombreCompleto,
      if (correo != null) 'correo': correo,
      if (telefonoWhatsapp != null) 'telefono_whatsapp': telefonoWhatsapp,
      if (rol != null) 'rol': rol,
      if (puesto != null) 'puesto': puesto,
      if (fotoPerfilUrl != null) 'foto_perfil_url': fotoPerfilUrl,
      if (estadoLaboral != null) 'estado_laboral': estadoLaboral,
      if (activo != null) 'activo': activo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombreCompleto,
    Value<String>? correo,
    Value<String>? telefonoWhatsapp,
    Value<String>? rol,
    Value<String>? puesto,
    Value<String?>? fotoPerfilUrl,
    Value<String>? estadoLaboral,
    Value<bool>? activo,
    Value<int>? rowid,
  }) {
    return LocalProfilesCompanion(
      id: id ?? this.id,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      correo: correo ?? this.correo,
      telefonoWhatsapp: telefonoWhatsapp ?? this.telefonoWhatsapp,
      rol: rol ?? this.rol,
      puesto: puesto ?? this.puesto,
      fotoPerfilUrl: fotoPerfilUrl ?? this.fotoPerfilUrl,
      estadoLaboral: estadoLaboral ?? this.estadoLaboral,
      activo: activo ?? this.activo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombreCompleto.present) {
      map['nombre_completo'] = Variable<String>(nombreCompleto.value);
    }
    if (correo.present) {
      map['correo'] = Variable<String>(correo.value);
    }
    if (telefonoWhatsapp.present) {
      map['telefono_whatsapp'] = Variable<String>(telefonoWhatsapp.value);
    }
    if (rol.present) {
      map['rol'] = Variable<String>(rol.value);
    }
    if (puesto.present) {
      map['puesto'] = Variable<String>(puesto.value);
    }
    if (fotoPerfilUrl.present) {
      map['foto_perfil_url'] = Variable<String>(fotoPerfilUrl.value);
    }
    if (estadoLaboral.present) {
      map['estado_laboral'] = Variable<String>(estadoLaboral.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfilesCompanion(')
          ..write('id: $id, ')
          ..write('nombreCompleto: $nombreCompleto, ')
          ..write('correo: $correo, ')
          ..write('telefonoWhatsapp: $telefonoWhatsapp, ')
          ..write('rol: $rol, ')
          ..write('puesto: $puesto, ')
          ..write('fotoPerfilUrl: $fotoPerfilUrl, ')
          ..write('estadoLaboral: $estadoLaboral, ')
          ..write('activo: $activo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAvisosPrivacidadTable extends LocalAvisosPrivacidad
    with TableInfo<$LocalAvisosPrivacidadTable, LocalAvisosPrivacidadData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAvisosPrivacidadTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resumenMeta = const VerificationMeta(
    'resumen',
  );
  @override
  late final GeneratedColumn<String> resumen = GeneratedColumn<String>(
    'resumen',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlCompletoMeta = const VerificationMeta(
    'urlCompleto',
  );
  @override
  late final GeneratedColumn<String> urlCompleto = GeneratedColumn<String>(
    'url_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    version,
    titulo,
    resumen,
    urlCompleto,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_avisos_privacidad';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAvisosPrivacidadData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('resumen')) {
      context.handle(
        _resumenMeta,
        resumen.isAcceptableOrUnknown(data['resumen']!, _resumenMeta),
      );
    } else if (isInserting) {
      context.missing(_resumenMeta);
    }
    if (data.containsKey('url_completo')) {
      context.handle(
        _urlCompletoMeta,
        urlCompleto.isAcceptableOrUnknown(
          data['url_completo']!,
          _urlCompletoMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAvisosPrivacidadData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAvisosPrivacidadData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      resumen: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resumen'],
      )!,
      urlCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url_completo'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $LocalAvisosPrivacidadTable createAlias(String alias) {
    return $LocalAvisosPrivacidadTable(attachedDatabase, alias);
  }
}

class LocalAvisosPrivacidadData extends DataClass
    implements Insertable<LocalAvisosPrivacidadData> {
  final String id;
  final String version;
  final String titulo;
  final String resumen;
  final String urlCompleto;
  final bool activo;
  const LocalAvisosPrivacidadData({
    required this.id,
    required this.version,
    required this.titulo,
    required this.resumen,
    required this.urlCompleto,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['version'] = Variable<String>(version);
    map['titulo'] = Variable<String>(titulo);
    map['resumen'] = Variable<String>(resumen);
    map['url_completo'] = Variable<String>(urlCompleto);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  LocalAvisosPrivacidadCompanion toCompanion(bool nullToAbsent) {
    return LocalAvisosPrivacidadCompanion(
      id: Value(id),
      version: Value(version),
      titulo: Value(titulo),
      resumen: Value(resumen),
      urlCompleto: Value(urlCompleto),
      activo: Value(activo),
    );
  }

  factory LocalAvisosPrivacidadData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAvisosPrivacidadData(
      id: serializer.fromJson<String>(json['id']),
      version: serializer.fromJson<String>(json['version']),
      titulo: serializer.fromJson<String>(json['titulo']),
      resumen: serializer.fromJson<String>(json['resumen']),
      urlCompleto: serializer.fromJson<String>(json['urlCompleto']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'version': serializer.toJson<String>(version),
      'titulo': serializer.toJson<String>(titulo),
      'resumen': serializer.toJson<String>(resumen),
      'urlCompleto': serializer.toJson<String>(urlCompleto),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  LocalAvisosPrivacidadData copyWith({
    String? id,
    String? version,
    String? titulo,
    String? resumen,
    String? urlCompleto,
    bool? activo,
  }) => LocalAvisosPrivacidadData(
    id: id ?? this.id,
    version: version ?? this.version,
    titulo: titulo ?? this.titulo,
    resumen: resumen ?? this.resumen,
    urlCompleto: urlCompleto ?? this.urlCompleto,
    activo: activo ?? this.activo,
  );
  LocalAvisosPrivacidadData copyWithCompanion(
    LocalAvisosPrivacidadCompanion data,
  ) {
    return LocalAvisosPrivacidadData(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      resumen: data.resumen.present ? data.resumen.value : this.resumen,
      urlCompleto: data.urlCompleto.present
          ? data.urlCompleto.value
          : this.urlCompleto,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAvisosPrivacidadData(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('titulo: $titulo, ')
          ..write('resumen: $resumen, ')
          ..write('urlCompleto: $urlCompleto, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, version, titulo, resumen, urlCompleto, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAvisosPrivacidadData &&
          other.id == this.id &&
          other.version == this.version &&
          other.titulo == this.titulo &&
          other.resumen == this.resumen &&
          other.urlCompleto == this.urlCompleto &&
          other.activo == this.activo);
}

class LocalAvisosPrivacidadCompanion
    extends UpdateCompanion<LocalAvisosPrivacidadData> {
  final Value<String> id;
  final Value<String> version;
  final Value<String> titulo;
  final Value<String> resumen;
  final Value<String> urlCompleto;
  final Value<bool> activo;
  final Value<int> rowid;
  const LocalAvisosPrivacidadCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.titulo = const Value.absent(),
    this.resumen = const Value.absent(),
    this.urlCompleto = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAvisosPrivacidadCompanion.insert({
    required String id,
    required String version,
    required String titulo,
    required String resumen,
    this.urlCompleto = const Value.absent(),
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       version = Value(version),
       titulo = Value(titulo),
       resumen = Value(resumen);
  static Insertable<LocalAvisosPrivacidadData> custom({
    Expression<String>? id,
    Expression<String>? version,
    Expression<String>? titulo,
    Expression<String>? resumen,
    Expression<String>? urlCompleto,
    Expression<bool>? activo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (titulo != null) 'titulo': titulo,
      if (resumen != null) 'resumen': resumen,
      if (urlCompleto != null) 'url_completo': urlCompleto,
      if (activo != null) 'activo': activo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAvisosPrivacidadCompanion copyWith({
    Value<String>? id,
    Value<String>? version,
    Value<String>? titulo,
    Value<String>? resumen,
    Value<String>? urlCompleto,
    Value<bool>? activo,
    Value<int>? rowid,
  }) {
    return LocalAvisosPrivacidadCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      titulo: titulo ?? this.titulo,
      resumen: resumen ?? this.resumen,
      urlCompleto: urlCompleto ?? this.urlCompleto,
      activo: activo ?? this.activo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (resumen.present) {
      map['resumen'] = Variable<String>(resumen.value);
    }
    if (urlCompleto.present) {
      map['url_completo'] = Variable<String>(urlCompleto.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAvisosPrivacidadCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('titulo: $titulo, ')
          ..write('resumen: $resumen, ')
          ..write('urlCompleto: $urlCompleto, ')
          ..write('activo: $activo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalTurnosTable extends LocalTurnos
    with TableInfo<$LocalTurnosTable, LocalTurno> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTurnosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sitioIdMeta = const VerificationMeta(
    'sitioId',
  );
  @override
  late final GeneratedColumn<String> sitioId = GeneratedColumn<String>(
    'sitio_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnoFechaMeta = const VerificationMeta(
    'turnoFecha',
  );
  @override
  late final GeneratedColumn<DateTime> turnoFecha = GeneratedColumn<DateTime>(
    'turno_fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inicioAtMeta = const VerificationMeta(
    'inicioAt',
  );
  @override
  late final GeneratedColumn<DateTime> inicioAt = GeneratedColumn<DateTime>(
    'inicio_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finAtMeta = const VerificationMeta('finAt');
  @override
  late final GeneratedColumn<DateTime> finAt = GeneratedColumn<DateTime>(
    'fin_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clasificacionEntradaMeta =
      const VerificationMeta('clasificacionEntrada');
  @override
  late final GeneratedColumn<String> clasificacionEntrada =
      GeneratedColumn<String>(
        'clasificacion_entrada',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('a_tiempo'),
      );
  static const VerificationMeta _minutosRetardoMeta = const VerificationMeta(
    'minutosRetardo',
  );
  @override
  late final GeneratedColumn<int> minutosRetardo = GeneratedColumn<int>(
    'minutos_retardo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _esDobleteMeta = const VerificationMeta(
    'esDoblete',
  );
  @override
  late final GeneratedColumn<bool> esDoblete = GeneratedColumn<bool>(
    'es_doblete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_doblete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    usuarioId,
    sitioId,
    turnoFecha,
    inicioAt,
    finAt,
    estado,
    clasificacionEntrada,
    minutosRetardo,
    esDoblete,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_turnos';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTurno> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('sitio_id')) {
      context.handle(
        _sitioIdMeta,
        sitioId.isAcceptableOrUnknown(data['sitio_id']!, _sitioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sitioIdMeta);
    }
    if (data.containsKey('turno_fecha')) {
      context.handle(
        _turnoFechaMeta,
        turnoFecha.isAcceptableOrUnknown(data['turno_fecha']!, _turnoFechaMeta),
      );
    } else if (isInserting) {
      context.missing(_turnoFechaMeta);
    }
    if (data.containsKey('inicio_at')) {
      context.handle(
        _inicioAtMeta,
        inicioAt.isAcceptableOrUnknown(data['inicio_at']!, _inicioAtMeta),
      );
    } else if (isInserting) {
      context.missing(_inicioAtMeta);
    }
    if (data.containsKey('fin_at')) {
      context.handle(
        _finAtMeta,
        finAt.isAcceptableOrUnknown(data['fin_at']!, _finAtMeta),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('clasificacion_entrada')) {
      context.handle(
        _clasificacionEntradaMeta,
        clasificacionEntrada.isAcceptableOrUnknown(
          data['clasificacion_entrada']!,
          _clasificacionEntradaMeta,
        ),
      );
    }
    if (data.containsKey('minutos_retardo')) {
      context.handle(
        _minutosRetardoMeta,
        minutosRetardo.isAcceptableOrUnknown(
          data['minutos_retardo']!,
          _minutosRetardoMeta,
        ),
      );
    }
    if (data.containsKey('es_doblete')) {
      context.handle(
        _esDobleteMeta,
        esDoblete.isAcceptableOrUnknown(data['es_doblete']!, _esDobleteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTurno map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTurno(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}usuario_id'],
      )!,
      sitioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sitio_id'],
      )!,
      turnoFecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}turno_fecha'],
      )!,
      inicioAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}inicio_at'],
      )!,
      finAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fin_at'],
      ),
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      clasificacionEntrada: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clasificacion_entrada'],
      )!,
      minutosRetardo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutos_retardo'],
      )!,
      esDoblete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_doblete'],
      )!,
    );
  }

  @override
  $LocalTurnosTable createAlias(String alias) {
    return $LocalTurnosTable(attachedDatabase, alias);
  }
}

class LocalTurno extends DataClass implements Insertable<LocalTurno> {
  final String id;
  final String usuarioId;
  final String sitioId;
  final DateTime turnoFecha;
  final DateTime inicioAt;
  final DateTime? finAt;
  final String estado;
  final String clasificacionEntrada;
  final int minutosRetardo;
  final bool esDoblete;
  const LocalTurno({
    required this.id,
    required this.usuarioId,
    required this.sitioId,
    required this.turnoFecha,
    required this.inicioAt,
    this.finAt,
    required this.estado,
    required this.clasificacionEntrada,
    required this.minutosRetardo,
    required this.esDoblete,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['sitio_id'] = Variable<String>(sitioId);
    map['turno_fecha'] = Variable<DateTime>(turnoFecha);
    map['inicio_at'] = Variable<DateTime>(inicioAt);
    if (!nullToAbsent || finAt != null) {
      map['fin_at'] = Variable<DateTime>(finAt);
    }
    map['estado'] = Variable<String>(estado);
    map['clasificacion_entrada'] = Variable<String>(clasificacionEntrada);
    map['minutos_retardo'] = Variable<int>(minutosRetardo);
    map['es_doblete'] = Variable<bool>(esDoblete);
    return map;
  }

  LocalTurnosCompanion toCompanion(bool nullToAbsent) {
    return LocalTurnosCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      sitioId: Value(sitioId),
      turnoFecha: Value(turnoFecha),
      inicioAt: Value(inicioAt),
      finAt: finAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finAt),
      estado: Value(estado),
      clasificacionEntrada: Value(clasificacionEntrada),
      minutosRetardo: Value(minutosRetardo),
      esDoblete: Value(esDoblete),
    );
  }

  factory LocalTurno.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTurno(
      id: serializer.fromJson<String>(json['id']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      sitioId: serializer.fromJson<String>(json['sitioId']),
      turnoFecha: serializer.fromJson<DateTime>(json['turnoFecha']),
      inicioAt: serializer.fromJson<DateTime>(json['inicioAt']),
      finAt: serializer.fromJson<DateTime?>(json['finAt']),
      estado: serializer.fromJson<String>(json['estado']),
      clasificacionEntrada: serializer.fromJson<String>(
        json['clasificacionEntrada'],
      ),
      minutosRetardo: serializer.fromJson<int>(json['minutosRetardo']),
      esDoblete: serializer.fromJson<bool>(json['esDoblete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'sitioId': serializer.toJson<String>(sitioId),
      'turnoFecha': serializer.toJson<DateTime>(turnoFecha),
      'inicioAt': serializer.toJson<DateTime>(inicioAt),
      'finAt': serializer.toJson<DateTime?>(finAt),
      'estado': serializer.toJson<String>(estado),
      'clasificacionEntrada': serializer.toJson<String>(clasificacionEntrada),
      'minutosRetardo': serializer.toJson<int>(minutosRetardo),
      'esDoblete': serializer.toJson<bool>(esDoblete),
    };
  }

  LocalTurno copyWith({
    String? id,
    String? usuarioId,
    String? sitioId,
    DateTime? turnoFecha,
    DateTime? inicioAt,
    Value<DateTime?> finAt = const Value.absent(),
    String? estado,
    String? clasificacionEntrada,
    int? minutosRetardo,
    bool? esDoblete,
  }) => LocalTurno(
    id: id ?? this.id,
    usuarioId: usuarioId ?? this.usuarioId,
    sitioId: sitioId ?? this.sitioId,
    turnoFecha: turnoFecha ?? this.turnoFecha,
    inicioAt: inicioAt ?? this.inicioAt,
    finAt: finAt.present ? finAt.value : this.finAt,
    estado: estado ?? this.estado,
    clasificacionEntrada: clasificacionEntrada ?? this.clasificacionEntrada,
    minutosRetardo: minutosRetardo ?? this.minutosRetardo,
    esDoblete: esDoblete ?? this.esDoblete,
  );
  LocalTurno copyWithCompanion(LocalTurnosCompanion data) {
    return LocalTurno(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      sitioId: data.sitioId.present ? data.sitioId.value : this.sitioId,
      turnoFecha: data.turnoFecha.present
          ? data.turnoFecha.value
          : this.turnoFecha,
      inicioAt: data.inicioAt.present ? data.inicioAt.value : this.inicioAt,
      finAt: data.finAt.present ? data.finAt.value : this.finAt,
      estado: data.estado.present ? data.estado.value : this.estado,
      clasificacionEntrada: data.clasificacionEntrada.present
          ? data.clasificacionEntrada.value
          : this.clasificacionEntrada,
      minutosRetardo: data.minutosRetardo.present
          ? data.minutosRetardo.value
          : this.minutosRetardo,
      esDoblete: data.esDoblete.present ? data.esDoblete.value : this.esDoblete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTurno(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('sitioId: $sitioId, ')
          ..write('turnoFecha: $turnoFecha, ')
          ..write('inicioAt: $inicioAt, ')
          ..write('finAt: $finAt, ')
          ..write('estado: $estado, ')
          ..write('clasificacionEntrada: $clasificacionEntrada, ')
          ..write('minutosRetardo: $minutosRetardo, ')
          ..write('esDoblete: $esDoblete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    sitioId,
    turnoFecha,
    inicioAt,
    finAt,
    estado,
    clasificacionEntrada,
    minutosRetardo,
    esDoblete,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTurno &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.sitioId == this.sitioId &&
          other.turnoFecha == this.turnoFecha &&
          other.inicioAt == this.inicioAt &&
          other.finAt == this.finAt &&
          other.estado == this.estado &&
          other.clasificacionEntrada == this.clasificacionEntrada &&
          other.minutosRetardo == this.minutosRetardo &&
          other.esDoblete == this.esDoblete);
}

class LocalTurnosCompanion extends UpdateCompanion<LocalTurno> {
  final Value<String> id;
  final Value<String> usuarioId;
  final Value<String> sitioId;
  final Value<DateTime> turnoFecha;
  final Value<DateTime> inicioAt;
  final Value<DateTime?> finAt;
  final Value<String> estado;
  final Value<String> clasificacionEntrada;
  final Value<int> minutosRetardo;
  final Value<bool> esDoblete;
  final Value<int> rowid;
  const LocalTurnosCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.sitioId = const Value.absent(),
    this.turnoFecha = const Value.absent(),
    this.inicioAt = const Value.absent(),
    this.finAt = const Value.absent(),
    this.estado = const Value.absent(),
    this.clasificacionEntrada = const Value.absent(),
    this.minutosRetardo = const Value.absent(),
    this.esDoblete = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTurnosCompanion.insert({
    required String id,
    required String usuarioId,
    required String sitioId,
    required DateTime turnoFecha,
    required DateTime inicioAt,
    this.finAt = const Value.absent(),
    required String estado,
    this.clasificacionEntrada = const Value.absent(),
    this.minutosRetardo = const Value.absent(),
    this.esDoblete = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       usuarioId = Value(usuarioId),
       sitioId = Value(sitioId),
       turnoFecha = Value(turnoFecha),
       inicioAt = Value(inicioAt),
       estado = Value(estado);
  static Insertable<LocalTurno> custom({
    Expression<String>? id,
    Expression<String>? usuarioId,
    Expression<String>? sitioId,
    Expression<DateTime>? turnoFecha,
    Expression<DateTime>? inicioAt,
    Expression<DateTime>? finAt,
    Expression<String>? estado,
    Expression<String>? clasificacionEntrada,
    Expression<int>? minutosRetardo,
    Expression<bool>? esDoblete,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (sitioId != null) 'sitio_id': sitioId,
      if (turnoFecha != null) 'turno_fecha': turnoFecha,
      if (inicioAt != null) 'inicio_at': inicioAt,
      if (finAt != null) 'fin_at': finAt,
      if (estado != null) 'estado': estado,
      if (clasificacionEntrada != null)
        'clasificacion_entrada': clasificacionEntrada,
      if (minutosRetardo != null) 'minutos_retardo': minutosRetardo,
      if (esDoblete != null) 'es_doblete': esDoblete,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTurnosCompanion copyWith({
    Value<String>? id,
    Value<String>? usuarioId,
    Value<String>? sitioId,
    Value<DateTime>? turnoFecha,
    Value<DateTime>? inicioAt,
    Value<DateTime?>? finAt,
    Value<String>? estado,
    Value<String>? clasificacionEntrada,
    Value<int>? minutosRetardo,
    Value<bool>? esDoblete,
    Value<int>? rowid,
  }) {
    return LocalTurnosCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      sitioId: sitioId ?? this.sitioId,
      turnoFecha: turnoFecha ?? this.turnoFecha,
      inicioAt: inicioAt ?? this.inicioAt,
      finAt: finAt ?? this.finAt,
      estado: estado ?? this.estado,
      clasificacionEntrada: clasificacionEntrada ?? this.clasificacionEntrada,
      minutosRetardo: minutosRetardo ?? this.minutosRetardo,
      esDoblete: esDoblete ?? this.esDoblete,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (sitioId.present) {
      map['sitio_id'] = Variable<String>(sitioId.value);
    }
    if (turnoFecha.present) {
      map['turno_fecha'] = Variable<DateTime>(turnoFecha.value);
    }
    if (inicioAt.present) {
      map['inicio_at'] = Variable<DateTime>(inicioAt.value);
    }
    if (finAt.present) {
      map['fin_at'] = Variable<DateTime>(finAt.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (clasificacionEntrada.present) {
      map['clasificacion_entrada'] = Variable<String>(
        clasificacionEntrada.value,
      );
    }
    if (minutosRetardo.present) {
      map['minutos_retardo'] = Variable<int>(minutosRetardo.value);
    }
    if (esDoblete.present) {
      map['es_doblete'] = Variable<bool>(esDoblete.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTurnosCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('sitioId: $sitioId, ')
          ..write('turnoFecha: $turnoFecha, ')
          ..write('inicioAt: $inicioAt, ')
          ..write('finAt: $finAt, ')
          ..write('estado: $estado, ')
          ..write('clasificacionEntrada: $clasificacionEntrada, ')
          ..write('minutosRetardo: $minutosRetardo, ')
          ..write('esDoblete: $esDoblete, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalAsistenciasTable localAsistencias = $LocalAsistenciasTable(
    this,
  );
  late final $LocalRegistrosAccesoTable localRegistrosAcceso =
      $LocalRegistrosAccesoTable(this);
  late final $LocalVisitantesTable localVisitantes = $LocalVisitantesTable(
    this,
  );
  late final $LocalBitacoraEventosTable localBitacoraEventos =
      $LocalBitacoraEventosTable(this);
  late final $LocalBitacoraFotosTable localBitacoraFotos =
      $LocalBitacoraFotosTable(this);
  late final $LocalRecepcionesTurnoTable localRecepcionesTurno =
      $LocalRecepcionesTurnoTable(this);
  late final $LocalRecepcionItemsTable localRecepcionItems =
      $LocalRecepcionItemsTable(this);
  late final $LocalSitiosTable localSitios = $LocalSitiosTable(this);
  late final $LocalWifiApsTable localWifiAps = $LocalWifiApsTable(this);
  late final $LocalCatalogoEquipoTable localCatalogoEquipo =
      $LocalCatalogoEquipoTable(this);
  late final $LocalPersonalClienteTable localPersonalCliente =
      $LocalPersonalClienteTable(this);
  late final $LocalProfilesTable localProfiles = $LocalProfilesTable(this);
  late final $LocalAvisosPrivacidadTable localAvisosPrivacidad =
      $LocalAvisosPrivacidadTable(this);
  late final $LocalTurnosTable localTurnos = $LocalTurnosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localAsistencias,
    localRegistrosAcceso,
    localVisitantes,
    localBitacoraEventos,
    localBitacoraFotos,
    localRecepcionesTurno,
    localRecepcionItems,
    localSitios,
    localWifiAps,
    localCatalogoEquipo,
    localPersonalCliente,
    localProfiles,
    localAvisosPrivacidad,
    localTurnos,
  ];
}

typedef $$LocalAsistenciasTableCreateCompanionBuilder =
    LocalAsistenciasCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      required String usuarioId,
      required String sitioId,
      required DateTime turnoFecha,
      required String tipoEvento,
      required DateTime ocurridoAt,
      Value<double?> lat,
      Value<double?> lng,
      Value<double?> gpsAccuracyM,
      Value<String?> wifiBssid,
      Value<String?> wifiSsid,
      Value<String?> selfieRutaLocal,
      Value<String?> selfieUrl,
      Value<bool> livenessPassed,
      Value<String> observaciones,
      Value<String?> clasificacionServidor,
      Value<int?> minutosRetardoServidor,
      Value<String?> estadoValidacionServidor,
      Value<int> rowid,
    });
typedef $$LocalAsistenciasTableUpdateCompanionBuilder =
    LocalAsistenciasCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      Value<String> usuarioId,
      Value<String> sitioId,
      Value<DateTime> turnoFecha,
      Value<String> tipoEvento,
      Value<DateTime> ocurridoAt,
      Value<double?> lat,
      Value<double?> lng,
      Value<double?> gpsAccuracyM,
      Value<String?> wifiBssid,
      Value<String?> wifiSsid,
      Value<String?> selfieRutaLocal,
      Value<String?> selfieUrl,
      Value<bool> livenessPassed,
      Value<String> observaciones,
      Value<String?> clasificacionServidor,
      Value<int?> minutosRetardoServidor,
      Value<String?> estadoValidacionServidor,
      Value<int> rowid,
    });

class $$LocalAsistenciasTableFilterComposer
    extends Composer<_$AppDatabase, $LocalAsistenciasTable> {
  $$LocalAsistenciasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoEvento => $composableBuilder(
    column: $table.tipoEvento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ocurridoAt => $composableBuilder(
    column: $table.ocurridoAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gpsAccuracyM => $composableBuilder(
    column: $table.gpsAccuracyM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wifiBssid => $composableBuilder(
    column: $table.wifiBssid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wifiSsid => $composableBuilder(
    column: $table.wifiSsid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selfieRutaLocal => $composableBuilder(
    column: $table.selfieRutaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selfieUrl => $composableBuilder(
    column: $table.selfieUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get livenessPassed => $composableBuilder(
    column: $table.livenessPassed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clasificacionServidor => $composableBuilder(
    column: $table.clasificacionServidor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutosRetardoServidor => $composableBuilder(
    column: $table.minutosRetardoServidor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoValidacionServidor => $composableBuilder(
    column: $table.estadoValidacionServidor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAsistenciasTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalAsistenciasTable> {
  $$LocalAsistenciasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoEvento => $composableBuilder(
    column: $table.tipoEvento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ocurridoAt => $composableBuilder(
    column: $table.ocurridoAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gpsAccuracyM => $composableBuilder(
    column: $table.gpsAccuracyM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wifiBssid => $composableBuilder(
    column: $table.wifiBssid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wifiSsid => $composableBuilder(
    column: $table.wifiSsid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selfieRutaLocal => $composableBuilder(
    column: $table.selfieRutaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selfieUrl => $composableBuilder(
    column: $table.selfieUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get livenessPassed => $composableBuilder(
    column: $table.livenessPassed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clasificacionServidor => $composableBuilder(
    column: $table.clasificacionServidor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutosRetardoServidor => $composableBuilder(
    column: $table.minutosRetardoServidor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoValidacionServidor => $composableBuilder(
    column: $table.estadoValidacionServidor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAsistenciasTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalAsistenciasTable> {
  $$LocalAsistenciasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get sitioId =>
      $composableBuilder(column: $table.sitioId, builder: (column) => column);

  GeneratedColumn<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipoEvento => $composableBuilder(
    column: $table.tipoEvento,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ocurridoAt => $composableBuilder(
    column: $table.ocurridoAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<double> get gpsAccuracyM => $composableBuilder(
    column: $table.gpsAccuracyM,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wifiBssid =>
      $composableBuilder(column: $table.wifiBssid, builder: (column) => column);

  GeneratedColumn<String> get wifiSsid =>
      $composableBuilder(column: $table.wifiSsid, builder: (column) => column);

  GeneratedColumn<String> get selfieRutaLocal => $composableBuilder(
    column: $table.selfieRutaLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selfieUrl =>
      $composableBuilder(column: $table.selfieUrl, builder: (column) => column);

  GeneratedColumn<bool> get livenessPassed => $composableBuilder(
    column: $table.livenessPassed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clasificacionServidor => $composableBuilder(
    column: $table.clasificacionServidor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutosRetardoServidor => $composableBuilder(
    column: $table.minutosRetardoServidor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estadoValidacionServidor => $composableBuilder(
    column: $table.estadoValidacionServidor,
    builder: (column) => column,
  );
}

class $$LocalAsistenciasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalAsistenciasTable,
          LocalAsistencia,
          $$LocalAsistenciasTableFilterComposer,
          $$LocalAsistenciasTableOrderingComposer,
          $$LocalAsistenciasTableAnnotationComposer,
          $$LocalAsistenciasTableCreateCompanionBuilder,
          $$LocalAsistenciasTableUpdateCompanionBuilder,
          (
            LocalAsistencia,
            BaseReferences<
              _$AppDatabase,
              $LocalAsistenciasTable,
              LocalAsistencia
            >,
          ),
          LocalAsistencia,
          PrefetchHooks Function()
        > {
  $$LocalAsistenciasTableTableManager(
    _$AppDatabase db,
    $LocalAsistenciasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAsistenciasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAsistenciasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAsistenciasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<String> sitioId = const Value.absent(),
                Value<DateTime> turnoFecha = const Value.absent(),
                Value<String> tipoEvento = const Value.absent(),
                Value<DateTime> ocurridoAt = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<double?> gpsAccuracyM = const Value.absent(),
                Value<String?> wifiBssid = const Value.absent(),
                Value<String?> wifiSsid = const Value.absent(),
                Value<String?> selfieRutaLocal = const Value.absent(),
                Value<String?> selfieUrl = const Value.absent(),
                Value<bool> livenessPassed = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<String?> clasificacionServidor = const Value.absent(),
                Value<int?> minutosRetardoServidor = const Value.absent(),
                Value<String?> estadoValidacionServidor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAsistenciasCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                usuarioId: usuarioId,
                sitioId: sitioId,
                turnoFecha: turnoFecha,
                tipoEvento: tipoEvento,
                ocurridoAt: ocurridoAt,
                lat: lat,
                lng: lng,
                gpsAccuracyM: gpsAccuracyM,
                wifiBssid: wifiBssid,
                wifiSsid: wifiSsid,
                selfieRutaLocal: selfieRutaLocal,
                selfieUrl: selfieUrl,
                livenessPassed: livenessPassed,
                observaciones: observaciones,
                clasificacionServidor: clasificacionServidor,
                minutosRetardoServidor: minutosRetardoServidor,
                estadoValidacionServidor: estadoValidacionServidor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String usuarioId,
                required String sitioId,
                required DateTime turnoFecha,
                required String tipoEvento,
                required DateTime ocurridoAt,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<double?> gpsAccuracyM = const Value.absent(),
                Value<String?> wifiBssid = const Value.absent(),
                Value<String?> wifiSsid = const Value.absent(),
                Value<String?> selfieRutaLocal = const Value.absent(),
                Value<String?> selfieUrl = const Value.absent(),
                Value<bool> livenessPassed = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<String?> clasificacionServidor = const Value.absent(),
                Value<int?> minutosRetardoServidor = const Value.absent(),
                Value<String?> estadoValidacionServidor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAsistenciasCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                usuarioId: usuarioId,
                sitioId: sitioId,
                turnoFecha: turnoFecha,
                tipoEvento: tipoEvento,
                ocurridoAt: ocurridoAt,
                lat: lat,
                lng: lng,
                gpsAccuracyM: gpsAccuracyM,
                wifiBssid: wifiBssid,
                wifiSsid: wifiSsid,
                selfieRutaLocal: selfieRutaLocal,
                selfieUrl: selfieUrl,
                livenessPassed: livenessPassed,
                observaciones: observaciones,
                clasificacionServidor: clasificacionServidor,
                minutosRetardoServidor: minutosRetardoServidor,
                estadoValidacionServidor: estadoValidacionServidor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAsistenciasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalAsistenciasTable,
      LocalAsistencia,
      $$LocalAsistenciasTableFilterComposer,
      $$LocalAsistenciasTableOrderingComposer,
      $$LocalAsistenciasTableAnnotationComposer,
      $$LocalAsistenciasTableCreateCompanionBuilder,
      $$LocalAsistenciasTableUpdateCompanionBuilder,
      (
        LocalAsistencia,
        BaseReferences<_$AppDatabase, $LocalAsistenciasTable, LocalAsistencia>,
      ),
      LocalAsistencia,
      PrefetchHooks Function()
    >;
typedef $$LocalRegistrosAccesoTableCreateCompanionBuilder =
    LocalRegistrosAccesoCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      required String sitioId,
      required String registradoPor,
      Value<String?> visitanteLocalId,
      required String nombreCompleto,
      Value<String> empresaProcedencia,
      Value<String> telefono,
      Value<String?> personaVisitadaId,
      Value<String> personaVisitadaTexto,
      required String asunto,
      Value<bool> ingresaVehiculo,
      Value<String> placas,
      Value<String> vehiculoMarca,
      Value<String> vehiculoModelo,
      Value<String> vehiculoColor,
      Value<String> identificacionTipo,
      Value<String?> identificacionRutaLocal,
      Value<String?> identificacionUrl,
      Value<String?> avisoPrivacidadId,
      Value<bool> avisoAceptado,
      Value<DateTime?> avisoAceptadoAt,
      required DateTime horaEntrada,
      Value<DateTime?> horaSalida,
      Value<String?> salidaRegistradaPor,
      Value<String> observaciones,
      Value<int> rowid,
    });
typedef $$LocalRegistrosAccesoTableUpdateCompanionBuilder =
    LocalRegistrosAccesoCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      Value<String> sitioId,
      Value<String> registradoPor,
      Value<String?> visitanteLocalId,
      Value<String> nombreCompleto,
      Value<String> empresaProcedencia,
      Value<String> telefono,
      Value<String?> personaVisitadaId,
      Value<String> personaVisitadaTexto,
      Value<String> asunto,
      Value<bool> ingresaVehiculo,
      Value<String> placas,
      Value<String> vehiculoMarca,
      Value<String> vehiculoModelo,
      Value<String> vehiculoColor,
      Value<String> identificacionTipo,
      Value<String?> identificacionRutaLocal,
      Value<String?> identificacionUrl,
      Value<String?> avisoPrivacidadId,
      Value<bool> avisoAceptado,
      Value<DateTime?> avisoAceptadoAt,
      Value<DateTime> horaEntrada,
      Value<DateTime?> horaSalida,
      Value<String?> salidaRegistradaPor,
      Value<String> observaciones,
      Value<int> rowid,
    });

class $$LocalRegistrosAccesoTableFilterComposer
    extends Composer<_$AppDatabase, $LocalRegistrosAccesoTable> {
  $$LocalRegistrosAccesoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitanteLocalId => $composableBuilder(
    column: $table.visitanteLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaProcedencia => $composableBuilder(
    column: $table.empresaProcedencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personaVisitadaId => $composableBuilder(
    column: $table.personaVisitadaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personaVisitadaTexto => $composableBuilder(
    column: $table.personaVisitadaTexto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get asunto => $composableBuilder(
    column: $table.asunto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ingresaVehiculo => $composableBuilder(
    column: $table.ingresaVehiculo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placas => $composableBuilder(
    column: $table.placas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehiculoMarca => $composableBuilder(
    column: $table.vehiculoMarca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehiculoModelo => $composableBuilder(
    column: $table.vehiculoModelo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehiculoColor => $composableBuilder(
    column: $table.vehiculoColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identificacionTipo => $composableBuilder(
    column: $table.identificacionTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identificacionRutaLocal => $composableBuilder(
    column: $table.identificacionRutaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identificacionUrl => $composableBuilder(
    column: $table.identificacionUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avisoPrivacidadId => $composableBuilder(
    column: $table.avisoPrivacidadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get avisoAceptado => $composableBuilder(
    column: $table.avisoAceptado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get avisoAceptadoAt => $composableBuilder(
    column: $table.avisoAceptadoAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get horaEntrada => $composableBuilder(
    column: $table.horaEntrada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get horaSalida => $composableBuilder(
    column: $table.horaSalida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salidaRegistradaPor => $composableBuilder(
    column: $table.salidaRegistradaPor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalRegistrosAccesoTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalRegistrosAccesoTable> {
  $$LocalRegistrosAccesoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitanteLocalId => $composableBuilder(
    column: $table.visitanteLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaProcedencia => $composableBuilder(
    column: $table.empresaProcedencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personaVisitadaId => $composableBuilder(
    column: $table.personaVisitadaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personaVisitadaTexto => $composableBuilder(
    column: $table.personaVisitadaTexto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get asunto => $composableBuilder(
    column: $table.asunto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ingresaVehiculo => $composableBuilder(
    column: $table.ingresaVehiculo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placas => $composableBuilder(
    column: $table.placas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehiculoMarca => $composableBuilder(
    column: $table.vehiculoMarca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehiculoModelo => $composableBuilder(
    column: $table.vehiculoModelo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehiculoColor => $composableBuilder(
    column: $table.vehiculoColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identificacionTipo => $composableBuilder(
    column: $table.identificacionTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identificacionRutaLocal => $composableBuilder(
    column: $table.identificacionRutaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identificacionUrl => $composableBuilder(
    column: $table.identificacionUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avisoPrivacidadId => $composableBuilder(
    column: $table.avisoPrivacidadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get avisoAceptado => $composableBuilder(
    column: $table.avisoAceptado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get avisoAceptadoAt => $composableBuilder(
    column: $table.avisoAceptadoAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get horaEntrada => $composableBuilder(
    column: $table.horaEntrada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get horaSalida => $composableBuilder(
    column: $table.horaSalida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salidaRegistradaPor => $composableBuilder(
    column: $table.salidaRegistradaPor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalRegistrosAccesoTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalRegistrosAccesoTable> {
  $$LocalRegistrosAccesoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get sitioId =>
      $composableBuilder(column: $table.sitioId, builder: (column) => column);

  GeneratedColumn<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get visitanteLocalId => $composableBuilder(
    column: $table.visitanteLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaProcedencia => $composableBuilder(
    column: $table.empresaProcedencia,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get personaVisitadaId => $composableBuilder(
    column: $table.personaVisitadaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personaVisitadaTexto => $composableBuilder(
    column: $table.personaVisitadaTexto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get asunto =>
      $composableBuilder(column: $table.asunto, builder: (column) => column);

  GeneratedColumn<bool> get ingresaVehiculo => $composableBuilder(
    column: $table.ingresaVehiculo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placas =>
      $composableBuilder(column: $table.placas, builder: (column) => column);

  GeneratedColumn<String> get vehiculoMarca => $composableBuilder(
    column: $table.vehiculoMarca,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehiculoModelo => $composableBuilder(
    column: $table.vehiculoModelo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vehiculoColor => $composableBuilder(
    column: $table.vehiculoColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identificacionTipo => $composableBuilder(
    column: $table.identificacionTipo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identificacionRutaLocal => $composableBuilder(
    column: $table.identificacionRutaLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identificacionUrl => $composableBuilder(
    column: $table.identificacionUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avisoPrivacidadId => $composableBuilder(
    column: $table.avisoPrivacidadId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get avisoAceptado => $composableBuilder(
    column: $table.avisoAceptado,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get avisoAceptadoAt => $composableBuilder(
    column: $table.avisoAceptadoAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get horaEntrada => $composableBuilder(
    column: $table.horaEntrada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get horaSalida => $composableBuilder(
    column: $table.horaSalida,
    builder: (column) => column,
  );

  GeneratedColumn<String> get salidaRegistradaPor => $composableBuilder(
    column: $table.salidaRegistradaPor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );
}

class $$LocalRegistrosAccesoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalRegistrosAccesoTable,
          LocalRegistrosAccesoData,
          $$LocalRegistrosAccesoTableFilterComposer,
          $$LocalRegistrosAccesoTableOrderingComposer,
          $$LocalRegistrosAccesoTableAnnotationComposer,
          $$LocalRegistrosAccesoTableCreateCompanionBuilder,
          $$LocalRegistrosAccesoTableUpdateCompanionBuilder,
          (
            LocalRegistrosAccesoData,
            BaseReferences<
              _$AppDatabase,
              $LocalRegistrosAccesoTable,
              LocalRegistrosAccesoData
            >,
          ),
          LocalRegistrosAccesoData,
          PrefetchHooks Function()
        > {
  $$LocalRegistrosAccesoTableTableManager(
    _$AppDatabase db,
    $LocalRegistrosAccesoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalRegistrosAccesoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalRegistrosAccesoTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalRegistrosAccesoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> sitioId = const Value.absent(),
                Value<String> registradoPor = const Value.absent(),
                Value<String?> visitanteLocalId = const Value.absent(),
                Value<String> nombreCompleto = const Value.absent(),
                Value<String> empresaProcedencia = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String?> personaVisitadaId = const Value.absent(),
                Value<String> personaVisitadaTexto = const Value.absent(),
                Value<String> asunto = const Value.absent(),
                Value<bool> ingresaVehiculo = const Value.absent(),
                Value<String> placas = const Value.absent(),
                Value<String> vehiculoMarca = const Value.absent(),
                Value<String> vehiculoModelo = const Value.absent(),
                Value<String> vehiculoColor = const Value.absent(),
                Value<String> identificacionTipo = const Value.absent(),
                Value<String?> identificacionRutaLocal = const Value.absent(),
                Value<String?> identificacionUrl = const Value.absent(),
                Value<String?> avisoPrivacidadId = const Value.absent(),
                Value<bool> avisoAceptado = const Value.absent(),
                Value<DateTime?> avisoAceptadoAt = const Value.absent(),
                Value<DateTime> horaEntrada = const Value.absent(),
                Value<DateTime?> horaSalida = const Value.absent(),
                Value<String?> salidaRegistradaPor = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRegistrosAccesoCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                sitioId: sitioId,
                registradoPor: registradoPor,
                visitanteLocalId: visitanteLocalId,
                nombreCompleto: nombreCompleto,
                empresaProcedencia: empresaProcedencia,
                telefono: telefono,
                personaVisitadaId: personaVisitadaId,
                personaVisitadaTexto: personaVisitadaTexto,
                asunto: asunto,
                ingresaVehiculo: ingresaVehiculo,
                placas: placas,
                vehiculoMarca: vehiculoMarca,
                vehiculoModelo: vehiculoModelo,
                vehiculoColor: vehiculoColor,
                identificacionTipo: identificacionTipo,
                identificacionRutaLocal: identificacionRutaLocal,
                identificacionUrl: identificacionUrl,
                avisoPrivacidadId: avisoPrivacidadId,
                avisoAceptado: avisoAceptado,
                avisoAceptadoAt: avisoAceptadoAt,
                horaEntrada: horaEntrada,
                horaSalida: horaSalida,
                salidaRegistradaPor: salidaRegistradaPor,
                observaciones: observaciones,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String sitioId,
                required String registradoPor,
                Value<String?> visitanteLocalId = const Value.absent(),
                required String nombreCompleto,
                Value<String> empresaProcedencia = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String?> personaVisitadaId = const Value.absent(),
                Value<String> personaVisitadaTexto = const Value.absent(),
                required String asunto,
                Value<bool> ingresaVehiculo = const Value.absent(),
                Value<String> placas = const Value.absent(),
                Value<String> vehiculoMarca = const Value.absent(),
                Value<String> vehiculoModelo = const Value.absent(),
                Value<String> vehiculoColor = const Value.absent(),
                Value<String> identificacionTipo = const Value.absent(),
                Value<String?> identificacionRutaLocal = const Value.absent(),
                Value<String?> identificacionUrl = const Value.absent(),
                Value<String?> avisoPrivacidadId = const Value.absent(),
                Value<bool> avisoAceptado = const Value.absent(),
                Value<DateTime?> avisoAceptadoAt = const Value.absent(),
                required DateTime horaEntrada,
                Value<DateTime?> horaSalida = const Value.absent(),
                Value<String?> salidaRegistradaPor = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRegistrosAccesoCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                sitioId: sitioId,
                registradoPor: registradoPor,
                visitanteLocalId: visitanteLocalId,
                nombreCompleto: nombreCompleto,
                empresaProcedencia: empresaProcedencia,
                telefono: telefono,
                personaVisitadaId: personaVisitadaId,
                personaVisitadaTexto: personaVisitadaTexto,
                asunto: asunto,
                ingresaVehiculo: ingresaVehiculo,
                placas: placas,
                vehiculoMarca: vehiculoMarca,
                vehiculoModelo: vehiculoModelo,
                vehiculoColor: vehiculoColor,
                identificacionTipo: identificacionTipo,
                identificacionRutaLocal: identificacionRutaLocal,
                identificacionUrl: identificacionUrl,
                avisoPrivacidadId: avisoPrivacidadId,
                avisoAceptado: avisoAceptado,
                avisoAceptadoAt: avisoAceptadoAt,
                horaEntrada: horaEntrada,
                horaSalida: horaSalida,
                salidaRegistradaPor: salidaRegistradaPor,
                observaciones: observaciones,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalRegistrosAccesoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalRegistrosAccesoTable,
      LocalRegistrosAccesoData,
      $$LocalRegistrosAccesoTableFilterComposer,
      $$LocalRegistrosAccesoTableOrderingComposer,
      $$LocalRegistrosAccesoTableAnnotationComposer,
      $$LocalRegistrosAccesoTableCreateCompanionBuilder,
      $$LocalRegistrosAccesoTableUpdateCompanionBuilder,
      (
        LocalRegistrosAccesoData,
        BaseReferences<
          _$AppDatabase,
          $LocalRegistrosAccesoTable,
          LocalRegistrosAccesoData
        >,
      ),
      LocalRegistrosAccesoData,
      PrefetchHooks Function()
    >;
typedef $$LocalVisitantesTableCreateCompanionBuilder =
    LocalVisitantesCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      required String nombreCompleto,
      Value<String> empresa,
      Value<String> telefono,
      Value<String> placasHabituales,
      Value<String> notas,
      Value<bool> esFrecuente,
      Value<bool> vetado,
      Value<String> motivoVeto,
      Value<int> vecesRegistrado,
      Value<DateTime?> ultimaVisitaAt,
      Value<int> rowid,
    });
typedef $$LocalVisitantesTableUpdateCompanionBuilder =
    LocalVisitantesCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      Value<String> nombreCompleto,
      Value<String> empresa,
      Value<String> telefono,
      Value<String> placasHabituales,
      Value<String> notas,
      Value<bool> esFrecuente,
      Value<bool> vetado,
      Value<String> motivoVeto,
      Value<int> vecesRegistrado,
      Value<DateTime?> ultimaVisitaAt,
      Value<int> rowid,
    });

class $$LocalVisitantesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVisitantesTable> {
  $$LocalVisitantesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresa => $composableBuilder(
    column: $table.empresa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placasHabituales => $composableBuilder(
    column: $table.placasHabituales,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esFrecuente => $composableBuilder(
    column: $table.esFrecuente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vetado => $composableBuilder(
    column: $table.vetado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivoVeto => $composableBuilder(
    column: $table.motivoVeto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vecesRegistrado => $composableBuilder(
    column: $table.vecesRegistrado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ultimaVisitaAt => $composableBuilder(
    column: $table.ultimaVisitaAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVisitantesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVisitantesTable> {
  $$LocalVisitantesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresa => $composableBuilder(
    column: $table.empresa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placasHabituales => $composableBuilder(
    column: $table.placasHabituales,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esFrecuente => $composableBuilder(
    column: $table.esFrecuente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vetado => $composableBuilder(
    column: $table.vetado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivoVeto => $composableBuilder(
    column: $table.motivoVeto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vecesRegistrado => $composableBuilder(
    column: $table.vecesRegistrado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ultimaVisitaAt => $composableBuilder(
    column: $table.ultimaVisitaAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVisitantesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVisitantesTable> {
  $$LocalVisitantesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresa =>
      $composableBuilder(column: $table.empresa, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get placasHabituales => $composableBuilder(
    column: $table.placasHabituales,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<bool> get esFrecuente => $composableBuilder(
    column: $table.esFrecuente,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vetado =>
      $composableBuilder(column: $table.vetado, builder: (column) => column);

  GeneratedColumn<String> get motivoVeto => $composableBuilder(
    column: $table.motivoVeto,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vecesRegistrado => $composableBuilder(
    column: $table.vecesRegistrado,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ultimaVisitaAt => $composableBuilder(
    column: $table.ultimaVisitaAt,
    builder: (column) => column,
  );
}

class $$LocalVisitantesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVisitantesTable,
          LocalVisitante,
          $$LocalVisitantesTableFilterComposer,
          $$LocalVisitantesTableOrderingComposer,
          $$LocalVisitantesTableAnnotationComposer,
          $$LocalVisitantesTableCreateCompanionBuilder,
          $$LocalVisitantesTableUpdateCompanionBuilder,
          (
            LocalVisitante,
            BaseReferences<
              _$AppDatabase,
              $LocalVisitantesTable,
              LocalVisitante
            >,
          ),
          LocalVisitante,
          PrefetchHooks Function()
        > {
  $$LocalVisitantesTableTableManager(
    _$AppDatabase db,
    $LocalVisitantesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVisitantesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVisitantesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVisitantesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> nombreCompleto = const Value.absent(),
                Value<String> empresa = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> placasHabituales = const Value.absent(),
                Value<String> notas = const Value.absent(),
                Value<bool> esFrecuente = const Value.absent(),
                Value<bool> vetado = const Value.absent(),
                Value<String> motivoVeto = const Value.absent(),
                Value<int> vecesRegistrado = const Value.absent(),
                Value<DateTime?> ultimaVisitaAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitantesCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                nombreCompleto: nombreCompleto,
                empresa: empresa,
                telefono: telefono,
                placasHabituales: placasHabituales,
                notas: notas,
                esFrecuente: esFrecuente,
                vetado: vetado,
                motivoVeto: motivoVeto,
                vecesRegistrado: vecesRegistrado,
                ultimaVisitaAt: ultimaVisitaAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String nombreCompleto,
                Value<String> empresa = const Value.absent(),
                Value<String> telefono = const Value.absent(),
                Value<String> placasHabituales = const Value.absent(),
                Value<String> notas = const Value.absent(),
                Value<bool> esFrecuente = const Value.absent(),
                Value<bool> vetado = const Value.absent(),
                Value<String> motivoVeto = const Value.absent(),
                Value<int> vecesRegistrado = const Value.absent(),
                Value<DateTime?> ultimaVisitaAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitantesCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                nombreCompleto: nombreCompleto,
                empresa: empresa,
                telefono: telefono,
                placasHabituales: placasHabituales,
                notas: notas,
                esFrecuente: esFrecuente,
                vetado: vetado,
                motivoVeto: motivoVeto,
                vecesRegistrado: vecesRegistrado,
                ultimaVisitaAt: ultimaVisitaAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVisitantesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVisitantesTable,
      LocalVisitante,
      $$LocalVisitantesTableFilterComposer,
      $$LocalVisitantesTableOrderingComposer,
      $$LocalVisitantesTableAnnotationComposer,
      $$LocalVisitantesTableCreateCompanionBuilder,
      $$LocalVisitantesTableUpdateCompanionBuilder,
      (
        LocalVisitante,
        BaseReferences<_$AppDatabase, $LocalVisitantesTable, LocalVisitante>,
      ),
      LocalVisitante,
      PrefetchHooks Function()
    >;
typedef $$LocalBitacoraEventosTableCreateCompanionBuilder =
    LocalBitacoraEventosCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      required String sitioId,
      required String registradoPor,
      required DateTime turnoFecha,
      required String tipo,
      required DateTime ocurridoAt,
      required String descripcion,
      Value<String> placas,
      Value<String> transportista,
      Value<String> empresaTransporte,
      Value<String> numDocumento,
      Value<String> destino,
      Value<String?> autorizadoPorId,
      Value<String> autorizadoPorTexto,
      Value<String> prioridad,
      Value<bool> requiereSeguimiento,
      Value<int> rowid,
    });
typedef $$LocalBitacoraEventosTableUpdateCompanionBuilder =
    LocalBitacoraEventosCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      Value<String> sitioId,
      Value<String> registradoPor,
      Value<DateTime> turnoFecha,
      Value<String> tipo,
      Value<DateTime> ocurridoAt,
      Value<String> descripcion,
      Value<String> placas,
      Value<String> transportista,
      Value<String> empresaTransporte,
      Value<String> numDocumento,
      Value<String> destino,
      Value<String?> autorizadoPorId,
      Value<String> autorizadoPorTexto,
      Value<String> prioridad,
      Value<bool> requiereSeguimiento,
      Value<int> rowid,
    });

class $$LocalBitacoraEventosTableFilterComposer
    extends Composer<_$AppDatabase, $LocalBitacoraEventosTable> {
  $$LocalBitacoraEventosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ocurridoAt => $composableBuilder(
    column: $table.ocurridoAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placas => $composableBuilder(
    column: $table.placas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportista => $composableBuilder(
    column: $table.transportista,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresaTransporte => $composableBuilder(
    column: $table.empresaTransporte,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numDocumento => $composableBuilder(
    column: $table.numDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destino => $composableBuilder(
    column: $table.destino,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get autorizadoPorId => $composableBuilder(
    column: $table.autorizadoPorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get autorizadoPorTexto => $composableBuilder(
    column: $table.autorizadoPorTexto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiereSeguimiento => $composableBuilder(
    column: $table.requiereSeguimiento,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalBitacoraEventosTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalBitacoraEventosTable> {
  $$LocalBitacoraEventosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ocurridoAt => $composableBuilder(
    column: $table.ocurridoAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placas => $composableBuilder(
    column: $table.placas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportista => $composableBuilder(
    column: $table.transportista,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresaTransporte => $composableBuilder(
    column: $table.empresaTransporte,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numDocumento => $composableBuilder(
    column: $table.numDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destino => $composableBuilder(
    column: $table.destino,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autorizadoPorId => $composableBuilder(
    column: $table.autorizadoPorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autorizadoPorTexto => $composableBuilder(
    column: $table.autorizadoPorTexto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiereSeguimiento => $composableBuilder(
    column: $table.requiereSeguimiento,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalBitacoraEventosTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalBitacoraEventosTable> {
  $$LocalBitacoraEventosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get sitioId =>
      $composableBuilder(column: $table.sitioId, builder: (column) => column);

  GeneratedColumn<String> get registradoPor => $composableBuilder(
    column: $table.registradoPor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<DateTime> get ocurridoAt => $composableBuilder(
    column: $table.ocurridoAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placas =>
      $composableBuilder(column: $table.placas, builder: (column) => column);

  GeneratedColumn<String> get transportista => $composableBuilder(
    column: $table.transportista,
    builder: (column) => column,
  );

  GeneratedColumn<String> get empresaTransporte => $composableBuilder(
    column: $table.empresaTransporte,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numDocumento => $composableBuilder(
    column: $table.numDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destino =>
      $composableBuilder(column: $table.destino, builder: (column) => column);

  GeneratedColumn<String> get autorizadoPorId => $composableBuilder(
    column: $table.autorizadoPorId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get autorizadoPorTexto => $composableBuilder(
    column: $table.autorizadoPorTexto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prioridad =>
      $composableBuilder(column: $table.prioridad, builder: (column) => column);

  GeneratedColumn<bool> get requiereSeguimiento => $composableBuilder(
    column: $table.requiereSeguimiento,
    builder: (column) => column,
  );
}

class $$LocalBitacoraEventosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalBitacoraEventosTable,
          LocalBitacoraEvento,
          $$LocalBitacoraEventosTableFilterComposer,
          $$LocalBitacoraEventosTableOrderingComposer,
          $$LocalBitacoraEventosTableAnnotationComposer,
          $$LocalBitacoraEventosTableCreateCompanionBuilder,
          $$LocalBitacoraEventosTableUpdateCompanionBuilder,
          (
            LocalBitacoraEvento,
            BaseReferences<
              _$AppDatabase,
              $LocalBitacoraEventosTable,
              LocalBitacoraEvento
            >,
          ),
          LocalBitacoraEvento,
          PrefetchHooks Function()
        > {
  $$LocalBitacoraEventosTableTableManager(
    _$AppDatabase db,
    $LocalBitacoraEventosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalBitacoraEventosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalBitacoraEventosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalBitacoraEventosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> sitioId = const Value.absent(),
                Value<String> registradoPor = const Value.absent(),
                Value<DateTime> turnoFecha = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<DateTime> ocurridoAt = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> placas = const Value.absent(),
                Value<String> transportista = const Value.absent(),
                Value<String> empresaTransporte = const Value.absent(),
                Value<String> numDocumento = const Value.absent(),
                Value<String> destino = const Value.absent(),
                Value<String?> autorizadoPorId = const Value.absent(),
                Value<String> autorizadoPorTexto = const Value.absent(),
                Value<String> prioridad = const Value.absent(),
                Value<bool> requiereSeguimiento = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBitacoraEventosCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                sitioId: sitioId,
                registradoPor: registradoPor,
                turnoFecha: turnoFecha,
                tipo: tipo,
                ocurridoAt: ocurridoAt,
                descripcion: descripcion,
                placas: placas,
                transportista: transportista,
                empresaTransporte: empresaTransporte,
                numDocumento: numDocumento,
                destino: destino,
                autorizadoPorId: autorizadoPorId,
                autorizadoPorTexto: autorizadoPorTexto,
                prioridad: prioridad,
                requiereSeguimiento: requiereSeguimiento,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String sitioId,
                required String registradoPor,
                required DateTime turnoFecha,
                required String tipo,
                required DateTime ocurridoAt,
                required String descripcion,
                Value<String> placas = const Value.absent(),
                Value<String> transportista = const Value.absent(),
                Value<String> empresaTransporte = const Value.absent(),
                Value<String> numDocumento = const Value.absent(),
                Value<String> destino = const Value.absent(),
                Value<String?> autorizadoPorId = const Value.absent(),
                Value<String> autorizadoPorTexto = const Value.absent(),
                Value<String> prioridad = const Value.absent(),
                Value<bool> requiereSeguimiento = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBitacoraEventosCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                sitioId: sitioId,
                registradoPor: registradoPor,
                turnoFecha: turnoFecha,
                tipo: tipo,
                ocurridoAt: ocurridoAt,
                descripcion: descripcion,
                placas: placas,
                transportista: transportista,
                empresaTransporte: empresaTransporte,
                numDocumento: numDocumento,
                destino: destino,
                autorizadoPorId: autorizadoPorId,
                autorizadoPorTexto: autorizadoPorTexto,
                prioridad: prioridad,
                requiereSeguimiento: requiereSeguimiento,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalBitacoraEventosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalBitacoraEventosTable,
      LocalBitacoraEvento,
      $$LocalBitacoraEventosTableFilterComposer,
      $$LocalBitacoraEventosTableOrderingComposer,
      $$LocalBitacoraEventosTableAnnotationComposer,
      $$LocalBitacoraEventosTableCreateCompanionBuilder,
      $$LocalBitacoraEventosTableUpdateCompanionBuilder,
      (
        LocalBitacoraEvento,
        BaseReferences<
          _$AppDatabase,
          $LocalBitacoraEventosTable,
          LocalBitacoraEvento
        >,
      ),
      LocalBitacoraEvento,
      PrefetchHooks Function()
    >;
typedef $$LocalBitacoraFotosTableCreateCompanionBuilder =
    LocalBitacoraFotosCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      required String eventoLocalId,
      Value<String?> rutaLocal,
      Value<String?> fotoUrl,
      Value<String> descripcion,
      Value<int> orden,
      Value<int> rowid,
    });
typedef $$LocalBitacoraFotosTableUpdateCompanionBuilder =
    LocalBitacoraFotosCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      Value<String> eventoLocalId,
      Value<String?> rutaLocal,
      Value<String?> fotoUrl,
      Value<String> descripcion,
      Value<int> orden,
      Value<int> rowid,
    });

class $$LocalBitacoraFotosTableFilterComposer
    extends Composer<_$AppDatabase, $LocalBitacoraFotosTable> {
  $$LocalBitacoraFotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventoLocalId => $composableBuilder(
    column: $table.eventoLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutaLocal => $composableBuilder(
    column: $table.rutaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoUrl => $composableBuilder(
    column: $table.fotoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalBitacoraFotosTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalBitacoraFotosTable> {
  $$LocalBitacoraFotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventoLocalId => $composableBuilder(
    column: $table.eventoLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutaLocal => $composableBuilder(
    column: $table.rutaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoUrl => $composableBuilder(
    column: $table.fotoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalBitacoraFotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalBitacoraFotosTable> {
  $$LocalBitacoraFotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get eventoLocalId => $composableBuilder(
    column: $table.eventoLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rutaLocal =>
      $composableBuilder(column: $table.rutaLocal, builder: (column) => column);

  GeneratedColumn<String> get fotoUrl =>
      $composableBuilder(column: $table.fotoUrl, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);
}

class $$LocalBitacoraFotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalBitacoraFotosTable,
          LocalBitacoraFoto,
          $$LocalBitacoraFotosTableFilterComposer,
          $$LocalBitacoraFotosTableOrderingComposer,
          $$LocalBitacoraFotosTableAnnotationComposer,
          $$LocalBitacoraFotosTableCreateCompanionBuilder,
          $$LocalBitacoraFotosTableUpdateCompanionBuilder,
          (
            LocalBitacoraFoto,
            BaseReferences<
              _$AppDatabase,
              $LocalBitacoraFotosTable,
              LocalBitacoraFoto
            >,
          ),
          LocalBitacoraFoto,
          PrefetchHooks Function()
        > {
  $$LocalBitacoraFotosTableTableManager(
    _$AppDatabase db,
    $LocalBitacoraFotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalBitacoraFotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalBitacoraFotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalBitacoraFotosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> eventoLocalId = const Value.absent(),
                Value<String?> rutaLocal = const Value.absent(),
                Value<String?> fotoUrl = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBitacoraFotosCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                eventoLocalId: eventoLocalId,
                rutaLocal: rutaLocal,
                fotoUrl: fotoUrl,
                descripcion: descripcion,
                orden: orden,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String eventoLocalId,
                Value<String?> rutaLocal = const Value.absent(),
                Value<String?> fotoUrl = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalBitacoraFotosCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                eventoLocalId: eventoLocalId,
                rutaLocal: rutaLocal,
                fotoUrl: fotoUrl,
                descripcion: descripcion,
                orden: orden,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalBitacoraFotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalBitacoraFotosTable,
      LocalBitacoraFoto,
      $$LocalBitacoraFotosTableFilterComposer,
      $$LocalBitacoraFotosTableOrderingComposer,
      $$LocalBitacoraFotosTableAnnotationComposer,
      $$LocalBitacoraFotosTableCreateCompanionBuilder,
      $$LocalBitacoraFotosTableUpdateCompanionBuilder,
      (
        LocalBitacoraFoto,
        BaseReferences<
          _$AppDatabase,
          $LocalBitacoraFotosTable,
          LocalBitacoraFoto
        >,
      ),
      LocalBitacoraFoto,
      PrefetchHooks Function()
    >;
typedef $$LocalRecepcionesTurnoTableCreateCompanionBuilder =
    LocalRecepcionesTurnoCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      required String sitioId,
      required DateTime turnoFecha,
      required String recibeId,
      Value<String?> entregaId,
      required bool aceptaConformidad,
      required DateTime aceptadoAt,
      Value<String> observaciones,
      Value<int> rowid,
    });
typedef $$LocalRecepcionesTurnoTableUpdateCompanionBuilder =
    LocalRecepcionesTurnoCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      Value<String> sitioId,
      Value<DateTime> turnoFecha,
      Value<String> recibeId,
      Value<String?> entregaId,
      Value<bool> aceptaConformidad,
      Value<DateTime> aceptadoAt,
      Value<String> observaciones,
      Value<int> rowid,
    });

class $$LocalRecepcionesTurnoTableFilterComposer
    extends Composer<_$AppDatabase, $LocalRecepcionesTurnoTable> {
  $$LocalRecepcionesTurnoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recibeId => $composableBuilder(
    column: $table.recibeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entregaId => $composableBuilder(
    column: $table.entregaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aceptaConformidad => $composableBuilder(
    column: $table.aceptaConformidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get aceptadoAt => $composableBuilder(
    column: $table.aceptadoAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalRecepcionesTurnoTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalRecepcionesTurnoTable> {
  $$LocalRecepcionesTurnoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recibeId => $composableBuilder(
    column: $table.recibeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entregaId => $composableBuilder(
    column: $table.entregaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aceptaConformidad => $composableBuilder(
    column: $table.aceptaConformidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get aceptadoAt => $composableBuilder(
    column: $table.aceptadoAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalRecepcionesTurnoTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalRecepcionesTurnoTable> {
  $$LocalRecepcionesTurnoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get sitioId =>
      $composableBuilder(column: $table.sitioId, builder: (column) => column);

  GeneratedColumn<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recibeId =>
      $composableBuilder(column: $table.recibeId, builder: (column) => column);

  GeneratedColumn<String> get entregaId =>
      $composableBuilder(column: $table.entregaId, builder: (column) => column);

  GeneratedColumn<bool> get aceptaConformidad => $composableBuilder(
    column: $table.aceptaConformidad,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get aceptadoAt => $composableBuilder(
    column: $table.aceptadoAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );
}

class $$LocalRecepcionesTurnoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalRecepcionesTurnoTable,
          LocalRecepcionesTurnoData,
          $$LocalRecepcionesTurnoTableFilterComposer,
          $$LocalRecepcionesTurnoTableOrderingComposer,
          $$LocalRecepcionesTurnoTableAnnotationComposer,
          $$LocalRecepcionesTurnoTableCreateCompanionBuilder,
          $$LocalRecepcionesTurnoTableUpdateCompanionBuilder,
          (
            LocalRecepcionesTurnoData,
            BaseReferences<
              _$AppDatabase,
              $LocalRecepcionesTurnoTable,
              LocalRecepcionesTurnoData
            >,
          ),
          LocalRecepcionesTurnoData,
          PrefetchHooks Function()
        > {
  $$LocalRecepcionesTurnoTableTableManager(
    _$AppDatabase db,
    $LocalRecepcionesTurnoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalRecepcionesTurnoTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalRecepcionesTurnoTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalRecepcionesTurnoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> sitioId = const Value.absent(),
                Value<DateTime> turnoFecha = const Value.absent(),
                Value<String> recibeId = const Value.absent(),
                Value<String?> entregaId = const Value.absent(),
                Value<bool> aceptaConformidad = const Value.absent(),
                Value<DateTime> aceptadoAt = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRecepcionesTurnoCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                sitioId: sitioId,
                turnoFecha: turnoFecha,
                recibeId: recibeId,
                entregaId: entregaId,
                aceptaConformidad: aceptaConformidad,
                aceptadoAt: aceptadoAt,
                observaciones: observaciones,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String sitioId,
                required DateTime turnoFecha,
                required String recibeId,
                Value<String?> entregaId = const Value.absent(),
                required bool aceptaConformidad,
                required DateTime aceptadoAt,
                Value<String> observaciones = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRecepcionesTurnoCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                sitioId: sitioId,
                turnoFecha: turnoFecha,
                recibeId: recibeId,
                entregaId: entregaId,
                aceptaConformidad: aceptaConformidad,
                aceptadoAt: aceptadoAt,
                observaciones: observaciones,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalRecepcionesTurnoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalRecepcionesTurnoTable,
      LocalRecepcionesTurnoData,
      $$LocalRecepcionesTurnoTableFilterComposer,
      $$LocalRecepcionesTurnoTableOrderingComposer,
      $$LocalRecepcionesTurnoTableAnnotationComposer,
      $$LocalRecepcionesTurnoTableCreateCompanionBuilder,
      $$LocalRecepcionesTurnoTableUpdateCompanionBuilder,
      (
        LocalRecepcionesTurnoData,
        BaseReferences<
          _$AppDatabase,
          $LocalRecepcionesTurnoTable,
          LocalRecepcionesTurnoData
        >,
      ),
      LocalRecepcionesTurnoData,
      PrefetchHooks Function()
    >;
typedef $$LocalRecepcionItemsTableCreateCompanionBuilder =
    LocalRecepcionItemsCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      required String recepcionLocalId,
      required String equipoId,
      required String estado,
      Value<int> cantidadEncontrada,
      Value<String> observaciones,
      Value<String?> fotoRutaLocal,
      Value<String?> fotoUrl,
      Value<int> rowid,
    });
typedef $$LocalRecepcionItemsTableUpdateCompanionBuilder =
    LocalRecepcionItemsCompanion Function({
      Value<String> localId,
      Value<String?> remoteId,
      Value<String> syncStatus,
      Value<String> syncError,
      Value<int> syncIntentos,
      Value<String> deviceId,
      Value<DateTime> createdAtLocal,
      Value<DateTime> updatedAtLocal,
      Value<DateTime?> syncedAt,
      Value<String> recepcionLocalId,
      Value<String> equipoId,
      Value<String> estado,
      Value<int> cantidadEncontrada,
      Value<String> observaciones,
      Value<String?> fotoRutaLocal,
      Value<String?> fotoUrl,
      Value<int> rowid,
    });

class $$LocalRecepcionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalRecepcionItemsTable> {
  $$LocalRecepcionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recepcionLocalId => $composableBuilder(
    column: $table.recepcionLocalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipoId => $composableBuilder(
    column: $table.equipoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadEncontrada => $composableBuilder(
    column: $table.cantidadEncontrada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoRutaLocal => $composableBuilder(
    column: $table.fotoRutaLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoUrl => $composableBuilder(
    column: $table.fotoUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalRecepcionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalRecepcionItemsTable> {
  $$LocalRecepcionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recepcionLocalId => $composableBuilder(
    column: $table.recepcionLocalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipoId => $composableBuilder(
    column: $table.equipoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadEncontrada => $composableBuilder(
    column: $table.cantidadEncontrada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoRutaLocal => $composableBuilder(
    column: $table.fotoRutaLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoUrl => $composableBuilder(
    column: $table.fotoUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalRecepcionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalRecepcionItemsTable> {
  $$LocalRecepcionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<int> get syncIntentos => $composableBuilder(
    column: $table.syncIntentos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtLocal => $composableBuilder(
    column: $table.createdAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAtLocal => $composableBuilder(
    column: $table.updatedAtLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get recepcionLocalId => $composableBuilder(
    column: $table.recepcionLocalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipoId =>
      $composableBuilder(column: $table.equipoId, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<int> get cantidadEncontrada => $composableBuilder(
    column: $table.cantidadEncontrada,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observaciones => $composableBuilder(
    column: $table.observaciones,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fotoRutaLocal => $composableBuilder(
    column: $table.fotoRutaLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fotoUrl =>
      $composableBuilder(column: $table.fotoUrl, builder: (column) => column);
}

class $$LocalRecepcionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalRecepcionItemsTable,
          LocalRecepcionItem,
          $$LocalRecepcionItemsTableFilterComposer,
          $$LocalRecepcionItemsTableOrderingComposer,
          $$LocalRecepcionItemsTableAnnotationComposer,
          $$LocalRecepcionItemsTableCreateCompanionBuilder,
          $$LocalRecepcionItemsTableUpdateCompanionBuilder,
          (
            LocalRecepcionItem,
            BaseReferences<
              _$AppDatabase,
              $LocalRecepcionItemsTable,
              LocalRecepcionItem
            >,
          ),
          LocalRecepcionItem,
          PrefetchHooks Function()
        > {
  $$LocalRecepcionItemsTableTableManager(
    _$AppDatabase db,
    $LocalRecepcionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalRecepcionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalRecepcionItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalRecepcionItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> recepcionLocalId = const Value.absent(),
                Value<String> equipoId = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int> cantidadEncontrada = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<String?> fotoRutaLocal = const Value.absent(),
                Value<String?> fotoUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRecepcionItemsCompanion(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                recepcionLocalId: recepcionLocalId,
                equipoId: equipoId,
                estado: estado,
                cantidadEncontrada: cantidadEncontrada,
                observaciones: observaciones,
                fotoRutaLocal: fotoRutaLocal,
                fotoUrl: fotoUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String> syncError = const Value.absent(),
                Value<int> syncIntentos = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAtLocal = const Value.absent(),
                Value<DateTime> updatedAtLocal = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String recepcionLocalId,
                required String equipoId,
                required String estado,
                Value<int> cantidadEncontrada = const Value.absent(),
                Value<String> observaciones = const Value.absent(),
                Value<String?> fotoRutaLocal = const Value.absent(),
                Value<String?> fotoUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRecepcionItemsCompanion.insert(
                localId: localId,
                remoteId: remoteId,
                syncStatus: syncStatus,
                syncError: syncError,
                syncIntentos: syncIntentos,
                deviceId: deviceId,
                createdAtLocal: createdAtLocal,
                updatedAtLocal: updatedAtLocal,
                syncedAt: syncedAt,
                recepcionLocalId: recepcionLocalId,
                equipoId: equipoId,
                estado: estado,
                cantidadEncontrada: cantidadEncontrada,
                observaciones: observaciones,
                fotoRutaLocal: fotoRutaLocal,
                fotoUrl: fotoUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalRecepcionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalRecepcionItemsTable,
      LocalRecepcionItem,
      $$LocalRecepcionItemsTableFilterComposer,
      $$LocalRecepcionItemsTableOrderingComposer,
      $$LocalRecepcionItemsTableAnnotationComposer,
      $$LocalRecepcionItemsTableCreateCompanionBuilder,
      $$LocalRecepcionItemsTableUpdateCompanionBuilder,
      (
        LocalRecepcionItem,
        BaseReferences<
          _$AppDatabase,
          $LocalRecepcionItemsTable,
          LocalRecepcionItem
        >,
      ),
      LocalRecepcionItem,
      PrefetchHooks Function()
    >;
typedef $$LocalSitiosTableCreateCompanionBuilder =
    LocalSitiosCompanion Function({
      required String id,
      required String nombre,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> radioMetros,
      Value<String> horaInicioTurno,
      Value<int> minutosToleranciaRetardo,
      Value<int> minutosToleranciaFalta,
      Value<int> husoHorarioOffsetH,
      Value<bool> activo,
      Value<int> rowid,
    });
typedef $$LocalSitiosTableUpdateCompanionBuilder =
    LocalSitiosCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<double?> lat,
      Value<double?> lng,
      Value<int> radioMetros,
      Value<String> horaInicioTurno,
      Value<int> minutosToleranciaRetardo,
      Value<int> minutosToleranciaFalta,
      Value<int> husoHorarioOffsetH,
      Value<bool> activo,
      Value<int> rowid,
    });

class $$LocalSitiosTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSitiosTable> {
  $$LocalSitiosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get radioMetros => $composableBuilder(
    column: $table.radioMetros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get horaInicioTurno => $composableBuilder(
    column: $table.horaInicioTurno,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutosToleranciaRetardo => $composableBuilder(
    column: $table.minutosToleranciaRetardo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutosToleranciaFalta => $composableBuilder(
    column: $table.minutosToleranciaFalta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get husoHorarioOffsetH => $composableBuilder(
    column: $table.husoHorarioOffsetH,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSitiosTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSitiosTable> {
  $$LocalSitiosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get radioMetros => $composableBuilder(
    column: $table.radioMetros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get horaInicioTurno => $composableBuilder(
    column: $table.horaInicioTurno,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutosToleranciaRetardo => $composableBuilder(
    column: $table.minutosToleranciaRetardo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutosToleranciaFalta => $composableBuilder(
    column: $table.minutosToleranciaFalta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get husoHorarioOffsetH => $composableBuilder(
    column: $table.husoHorarioOffsetH,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSitiosTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSitiosTable> {
  $$LocalSitiosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<int> get radioMetros => $composableBuilder(
    column: $table.radioMetros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get horaInicioTurno => $composableBuilder(
    column: $table.horaInicioTurno,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutosToleranciaRetardo => $composableBuilder(
    column: $table.minutosToleranciaRetardo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutosToleranciaFalta => $composableBuilder(
    column: $table.minutosToleranciaFalta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get husoHorarioOffsetH => $composableBuilder(
    column: $table.husoHorarioOffsetH,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$LocalSitiosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSitiosTable,
          LocalSitio,
          $$LocalSitiosTableFilterComposer,
          $$LocalSitiosTableOrderingComposer,
          $$LocalSitiosTableAnnotationComposer,
          $$LocalSitiosTableCreateCompanionBuilder,
          $$LocalSitiosTableUpdateCompanionBuilder,
          (
            LocalSitio,
            BaseReferences<_$AppDatabase, $LocalSitiosTable, LocalSitio>,
          ),
          LocalSitio,
          PrefetchHooks Function()
        > {
  $$LocalSitiosTableTableManager(_$AppDatabase db, $LocalSitiosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSitiosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSitiosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSitiosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> radioMetros = const Value.absent(),
                Value<String> horaInicioTurno = const Value.absent(),
                Value<int> minutosToleranciaRetardo = const Value.absent(),
                Value<int> minutosToleranciaFalta = const Value.absent(),
                Value<int> husoHorarioOffsetH = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSitiosCompanion(
                id: id,
                nombre: nombre,
                lat: lat,
                lng: lng,
                radioMetros: radioMetros,
                horaInicioTurno: horaInicioTurno,
                minutosToleranciaRetardo: minutosToleranciaRetardo,
                minutosToleranciaFalta: minutosToleranciaFalta,
                husoHorarioOffsetH: husoHorarioOffsetH,
                activo: activo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<int> radioMetros = const Value.absent(),
                Value<String> horaInicioTurno = const Value.absent(),
                Value<int> minutosToleranciaRetardo = const Value.absent(),
                Value<int> minutosToleranciaFalta = const Value.absent(),
                Value<int> husoHorarioOffsetH = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSitiosCompanion.insert(
                id: id,
                nombre: nombre,
                lat: lat,
                lng: lng,
                radioMetros: radioMetros,
                horaInicioTurno: horaInicioTurno,
                minutosToleranciaRetardo: minutosToleranciaRetardo,
                minutosToleranciaFalta: minutosToleranciaFalta,
                husoHorarioOffsetH: husoHorarioOffsetH,
                activo: activo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSitiosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSitiosTable,
      LocalSitio,
      $$LocalSitiosTableFilterComposer,
      $$LocalSitiosTableOrderingComposer,
      $$LocalSitiosTableAnnotationComposer,
      $$LocalSitiosTableCreateCompanionBuilder,
      $$LocalSitiosTableUpdateCompanionBuilder,
      (
        LocalSitio,
        BaseReferences<_$AppDatabase, $LocalSitiosTable, LocalSitio>,
      ),
      LocalSitio,
      PrefetchHooks Function()
    >;
typedef $$LocalWifiApsTableCreateCompanionBuilder =
    LocalWifiApsCompanion Function({
      required String id,
      required String sitioId,
      required String bssid,
      Value<String> ssid,
      Value<String> nombreZona,
      Value<bool> activo,
      Value<int> rowid,
    });
typedef $$LocalWifiApsTableUpdateCompanionBuilder =
    LocalWifiApsCompanion Function({
      Value<String> id,
      Value<String> sitioId,
      Value<String> bssid,
      Value<String> ssid,
      Value<String> nombreZona,
      Value<bool> activo,
      Value<int> rowid,
    });

class $$LocalWifiApsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWifiApsTable> {
  $$LocalWifiApsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bssid => $composableBuilder(
    column: $table.bssid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ssid => $composableBuilder(
    column: $table.ssid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreZona => $composableBuilder(
    column: $table.nombreZona,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWifiApsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWifiApsTable> {
  $$LocalWifiApsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bssid => $composableBuilder(
    column: $table.bssid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ssid => $composableBuilder(
    column: $table.ssid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreZona => $composableBuilder(
    column: $table.nombreZona,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWifiApsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWifiApsTable> {
  $$LocalWifiApsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sitioId =>
      $composableBuilder(column: $table.sitioId, builder: (column) => column);

  GeneratedColumn<String> get bssid =>
      $composableBuilder(column: $table.bssid, builder: (column) => column);

  GeneratedColumn<String> get ssid =>
      $composableBuilder(column: $table.ssid, builder: (column) => column);

  GeneratedColumn<String> get nombreZona => $composableBuilder(
    column: $table.nombreZona,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$LocalWifiApsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWifiApsTable,
          LocalWifiAp,
          $$LocalWifiApsTableFilterComposer,
          $$LocalWifiApsTableOrderingComposer,
          $$LocalWifiApsTableAnnotationComposer,
          $$LocalWifiApsTableCreateCompanionBuilder,
          $$LocalWifiApsTableUpdateCompanionBuilder,
          (
            LocalWifiAp,
            BaseReferences<_$AppDatabase, $LocalWifiApsTable, LocalWifiAp>,
          ),
          LocalWifiAp,
          PrefetchHooks Function()
        > {
  $$LocalWifiApsTableTableManager(_$AppDatabase db, $LocalWifiApsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWifiApsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWifiApsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWifiApsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sitioId = const Value.absent(),
                Value<String> bssid = const Value.absent(),
                Value<String> ssid = const Value.absent(),
                Value<String> nombreZona = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWifiApsCompanion(
                id: id,
                sitioId: sitioId,
                bssid: bssid,
                ssid: ssid,
                nombreZona: nombreZona,
                activo: activo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sitioId,
                required String bssid,
                Value<String> ssid = const Value.absent(),
                Value<String> nombreZona = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWifiApsCompanion.insert(
                id: id,
                sitioId: sitioId,
                bssid: bssid,
                ssid: ssid,
                nombreZona: nombreZona,
                activo: activo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWifiApsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWifiApsTable,
      LocalWifiAp,
      $$LocalWifiApsTableFilterComposer,
      $$LocalWifiApsTableOrderingComposer,
      $$LocalWifiApsTableAnnotationComposer,
      $$LocalWifiApsTableCreateCompanionBuilder,
      $$LocalWifiApsTableUpdateCompanionBuilder,
      (
        LocalWifiAp,
        BaseReferences<_$AppDatabase, $LocalWifiApsTable, LocalWifiAp>,
      ),
      LocalWifiAp,
      PrefetchHooks Function()
    >;
typedef $$LocalCatalogoEquipoTableCreateCompanionBuilder =
    LocalCatalogoEquipoCompanion Function({
      required String id,
      required String sitioId,
      required String nombre,
      Value<String> descripcion,
      Value<String> categoria,
      Value<int> cantidadEsperada,
      Value<bool> requiereFoto,
      Value<bool> debeEstarSinUsar,
      Value<int> orden,
      Value<bool> activo,
      Value<int> rowid,
    });
typedef $$LocalCatalogoEquipoTableUpdateCompanionBuilder =
    LocalCatalogoEquipoCompanion Function({
      Value<String> id,
      Value<String> sitioId,
      Value<String> nombre,
      Value<String> descripcion,
      Value<String> categoria,
      Value<int> cantidadEsperada,
      Value<bool> requiereFoto,
      Value<bool> debeEstarSinUsar,
      Value<int> orden,
      Value<bool> activo,
      Value<int> rowid,
    });

class $$LocalCatalogoEquipoTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCatalogoEquipoTable> {
  $$LocalCatalogoEquipoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidadEsperada => $composableBuilder(
    column: $table.cantidadEsperada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiereFoto => $composableBuilder(
    column: $table.requiereFoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get debeEstarSinUsar => $composableBuilder(
    column: $table.debeEstarSinUsar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCatalogoEquipoTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCatalogoEquipoTable> {
  $$LocalCatalogoEquipoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidadEsperada => $composableBuilder(
    column: $table.cantidadEsperada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiereFoto => $composableBuilder(
    column: $table.requiereFoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get debeEstarSinUsar => $composableBuilder(
    column: $table.debeEstarSinUsar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCatalogoEquipoTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCatalogoEquipoTable> {
  $$LocalCatalogoEquipoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sitioId =>
      $composableBuilder(column: $table.sitioId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<int> get cantidadEsperada => $composableBuilder(
    column: $table.cantidadEsperada,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiereFoto => $composableBuilder(
    column: $table.requiereFoto,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get debeEstarSinUsar => $composableBuilder(
    column: $table.debeEstarSinUsar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$LocalCatalogoEquipoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCatalogoEquipoTable,
          LocalCatalogoEquipoData,
          $$LocalCatalogoEquipoTableFilterComposer,
          $$LocalCatalogoEquipoTableOrderingComposer,
          $$LocalCatalogoEquipoTableAnnotationComposer,
          $$LocalCatalogoEquipoTableCreateCompanionBuilder,
          $$LocalCatalogoEquipoTableUpdateCompanionBuilder,
          (
            LocalCatalogoEquipoData,
            BaseReferences<
              _$AppDatabase,
              $LocalCatalogoEquipoTable,
              LocalCatalogoEquipoData
            >,
          ),
          LocalCatalogoEquipoData,
          PrefetchHooks Function()
        > {
  $$LocalCatalogoEquipoTableTableManager(
    _$AppDatabase db,
    $LocalCatalogoEquipoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCatalogoEquipoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCatalogoEquipoTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalCatalogoEquipoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sitioId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<int> cantidadEsperada = const Value.absent(),
                Value<bool> requiereFoto = const Value.absent(),
                Value<bool> debeEstarSinUsar = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCatalogoEquipoCompanion(
                id: id,
                sitioId: sitioId,
                nombre: nombre,
                descripcion: descripcion,
                categoria: categoria,
                cantidadEsperada: cantidadEsperada,
                requiereFoto: requiereFoto,
                debeEstarSinUsar: debeEstarSinUsar,
                orden: orden,
                activo: activo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sitioId,
                required String nombre,
                Value<String> descripcion = const Value.absent(),
                Value<String> categoria = const Value.absent(),
                Value<int> cantidadEsperada = const Value.absent(),
                Value<bool> requiereFoto = const Value.absent(),
                Value<bool> debeEstarSinUsar = const Value.absent(),
                Value<int> orden = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCatalogoEquipoCompanion.insert(
                id: id,
                sitioId: sitioId,
                nombre: nombre,
                descripcion: descripcion,
                categoria: categoria,
                cantidadEsperada: cantidadEsperada,
                requiereFoto: requiereFoto,
                debeEstarSinUsar: debeEstarSinUsar,
                orden: orden,
                activo: activo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCatalogoEquipoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCatalogoEquipoTable,
      LocalCatalogoEquipoData,
      $$LocalCatalogoEquipoTableFilterComposer,
      $$LocalCatalogoEquipoTableOrderingComposer,
      $$LocalCatalogoEquipoTableAnnotationComposer,
      $$LocalCatalogoEquipoTableCreateCompanionBuilder,
      $$LocalCatalogoEquipoTableUpdateCompanionBuilder,
      (
        LocalCatalogoEquipoData,
        BaseReferences<
          _$AppDatabase,
          $LocalCatalogoEquipoTable,
          LocalCatalogoEquipoData
        >,
      ),
      LocalCatalogoEquipoData,
      PrefetchHooks Function()
    >;
typedef $$LocalPersonalClienteTableCreateCompanionBuilder =
    LocalPersonalClienteCompanion Function({
      required String id,
      required String sitioId,
      required String nombreCompleto,
      Value<String> area,
      Value<String> puesto,
      Value<String> extension,
      Value<bool> activo,
      Value<int> rowid,
    });
typedef $$LocalPersonalClienteTableUpdateCompanionBuilder =
    LocalPersonalClienteCompanion Function({
      Value<String> id,
      Value<String> sitioId,
      Value<String> nombreCompleto,
      Value<String> area,
      Value<String> puesto,
      Value<String> extension,
      Value<bool> activo,
      Value<int> rowid,
    });

class $$LocalPersonalClienteTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPersonalClienteTable> {
  $$LocalPersonalClienteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get puesto => $composableBuilder(
    column: $table.puesto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extension => $composableBuilder(
    column: $table.extension,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPersonalClienteTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPersonalClienteTable> {
  $$LocalPersonalClienteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get puesto => $composableBuilder(
    column: $table.puesto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extension => $composableBuilder(
    column: $table.extension,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPersonalClienteTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPersonalClienteTable> {
  $$LocalPersonalClienteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sitioId =>
      $composableBuilder(column: $table.sitioId, builder: (column) => column);

  GeneratedColumn<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get puesto =>
      $composableBuilder(column: $table.puesto, builder: (column) => column);

  GeneratedColumn<String> get extension =>
      $composableBuilder(column: $table.extension, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$LocalPersonalClienteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPersonalClienteTable,
          LocalPersonalClienteData,
          $$LocalPersonalClienteTableFilterComposer,
          $$LocalPersonalClienteTableOrderingComposer,
          $$LocalPersonalClienteTableAnnotationComposer,
          $$LocalPersonalClienteTableCreateCompanionBuilder,
          $$LocalPersonalClienteTableUpdateCompanionBuilder,
          (
            LocalPersonalClienteData,
            BaseReferences<
              _$AppDatabase,
              $LocalPersonalClienteTable,
              LocalPersonalClienteData
            >,
          ),
          LocalPersonalClienteData,
          PrefetchHooks Function()
        > {
  $$LocalPersonalClienteTableTableManager(
    _$AppDatabase db,
    $LocalPersonalClienteTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPersonalClienteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPersonalClienteTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPersonalClienteTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sitioId = const Value.absent(),
                Value<String> nombreCompleto = const Value.absent(),
                Value<String> area = const Value.absent(),
                Value<String> puesto = const Value.absent(),
                Value<String> extension = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPersonalClienteCompanion(
                id: id,
                sitioId: sitioId,
                nombreCompleto: nombreCompleto,
                area: area,
                puesto: puesto,
                extension: extension,
                activo: activo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sitioId,
                required String nombreCompleto,
                Value<String> area = const Value.absent(),
                Value<String> puesto = const Value.absent(),
                Value<String> extension = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPersonalClienteCompanion.insert(
                id: id,
                sitioId: sitioId,
                nombreCompleto: nombreCompleto,
                area: area,
                puesto: puesto,
                extension: extension,
                activo: activo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPersonalClienteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPersonalClienteTable,
      LocalPersonalClienteData,
      $$LocalPersonalClienteTableFilterComposer,
      $$LocalPersonalClienteTableOrderingComposer,
      $$LocalPersonalClienteTableAnnotationComposer,
      $$LocalPersonalClienteTableCreateCompanionBuilder,
      $$LocalPersonalClienteTableUpdateCompanionBuilder,
      (
        LocalPersonalClienteData,
        BaseReferences<
          _$AppDatabase,
          $LocalPersonalClienteTable,
          LocalPersonalClienteData
        >,
      ),
      LocalPersonalClienteData,
      PrefetchHooks Function()
    >;
typedef $$LocalProfilesTableCreateCompanionBuilder =
    LocalProfilesCompanion Function({
      required String id,
      required String nombreCompleto,
      Value<String> correo,
      Value<String> telefonoWhatsapp,
      required String rol,
      Value<String> puesto,
      Value<String?> fotoPerfilUrl,
      Value<String> estadoLaboral,
      Value<bool> activo,
      Value<int> rowid,
    });
typedef $$LocalProfilesTableUpdateCompanionBuilder =
    LocalProfilesCompanion Function({
      Value<String> id,
      Value<String> nombreCompleto,
      Value<String> correo,
      Value<String> telefonoWhatsapp,
      Value<String> rol,
      Value<String> puesto,
      Value<String?> fotoPerfilUrl,
      Value<String> estadoLaboral,
      Value<bool> activo,
      Value<int> rowid,
    });

class $$LocalProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefonoWhatsapp => $composableBuilder(
    column: $table.telefonoWhatsapp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get puesto => $composableBuilder(
    column: $table.puesto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoPerfilUrl => $composableBuilder(
    column: $table.fotoPerfilUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoLaboral => $composableBuilder(
    column: $table.estadoLaboral,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefonoWhatsapp => $composableBuilder(
    column: $table.telefonoWhatsapp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get puesto => $composableBuilder(
    column: $table.puesto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoPerfilUrl => $composableBuilder(
    column: $table.fotoPerfilUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoLaboral => $composableBuilder(
    column: $table.estadoLaboral,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreCompleto => $composableBuilder(
    column: $table.nombreCompleto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get correo =>
      $composableBuilder(column: $table.correo, builder: (column) => column);

  GeneratedColumn<String> get telefonoWhatsapp => $composableBuilder(
    column: $table.telefonoWhatsapp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<String> get puesto =>
      $composableBuilder(column: $table.puesto, builder: (column) => column);

  GeneratedColumn<String> get fotoPerfilUrl => $composableBuilder(
    column: $table.fotoPerfilUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estadoLaboral => $composableBuilder(
    column: $table.estadoLaboral,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$LocalProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalProfilesTable,
          LocalProfile,
          $$LocalProfilesTableFilterComposer,
          $$LocalProfilesTableOrderingComposer,
          $$LocalProfilesTableAnnotationComposer,
          $$LocalProfilesTableCreateCompanionBuilder,
          $$LocalProfilesTableUpdateCompanionBuilder,
          (
            LocalProfile,
            BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>,
          ),
          LocalProfile,
          PrefetchHooks Function()
        > {
  $$LocalProfilesTableTableManager(_$AppDatabase db, $LocalProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombreCompleto = const Value.absent(),
                Value<String> correo = const Value.absent(),
                Value<String> telefonoWhatsapp = const Value.absent(),
                Value<String> rol = const Value.absent(),
                Value<String> puesto = const Value.absent(),
                Value<String?> fotoPerfilUrl = const Value.absent(),
                Value<String> estadoLaboral = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProfilesCompanion(
                id: id,
                nombreCompleto: nombreCompleto,
                correo: correo,
                telefonoWhatsapp: telefonoWhatsapp,
                rol: rol,
                puesto: puesto,
                fotoPerfilUrl: fotoPerfilUrl,
                estadoLaboral: estadoLaboral,
                activo: activo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombreCompleto,
                Value<String> correo = const Value.absent(),
                Value<String> telefonoWhatsapp = const Value.absent(),
                required String rol,
                Value<String> puesto = const Value.absent(),
                Value<String?> fotoPerfilUrl = const Value.absent(),
                Value<String> estadoLaboral = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProfilesCompanion.insert(
                id: id,
                nombreCompleto: nombreCompleto,
                correo: correo,
                telefonoWhatsapp: telefonoWhatsapp,
                rol: rol,
                puesto: puesto,
                fotoPerfilUrl: fotoPerfilUrl,
                estadoLaboral: estadoLaboral,
                activo: activo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalProfilesTable,
      LocalProfile,
      $$LocalProfilesTableFilterComposer,
      $$LocalProfilesTableOrderingComposer,
      $$LocalProfilesTableAnnotationComposer,
      $$LocalProfilesTableCreateCompanionBuilder,
      $$LocalProfilesTableUpdateCompanionBuilder,
      (
        LocalProfile,
        BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>,
      ),
      LocalProfile,
      PrefetchHooks Function()
    >;
typedef $$LocalAvisosPrivacidadTableCreateCompanionBuilder =
    LocalAvisosPrivacidadCompanion Function({
      required String id,
      required String version,
      required String titulo,
      required String resumen,
      Value<String> urlCompleto,
      Value<bool> activo,
      Value<int> rowid,
    });
typedef $$LocalAvisosPrivacidadTableUpdateCompanionBuilder =
    LocalAvisosPrivacidadCompanion Function({
      Value<String> id,
      Value<String> version,
      Value<String> titulo,
      Value<String> resumen,
      Value<String> urlCompleto,
      Value<bool> activo,
      Value<int> rowid,
    });

class $$LocalAvisosPrivacidadTableFilterComposer
    extends Composer<_$AppDatabase, $LocalAvisosPrivacidadTable> {
  $$LocalAvisosPrivacidadTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resumen => $composableBuilder(
    column: $table.resumen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urlCompleto => $composableBuilder(
    column: $table.urlCompleto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAvisosPrivacidadTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalAvisosPrivacidadTable> {
  $$LocalAvisosPrivacidadTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resumen => $composableBuilder(
    column: $table.resumen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urlCompleto => $composableBuilder(
    column: $table.urlCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAvisosPrivacidadTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalAvisosPrivacidadTable> {
  $$LocalAvisosPrivacidadTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get resumen =>
      $composableBuilder(column: $table.resumen, builder: (column) => column);

  GeneratedColumn<String> get urlCompleto => $composableBuilder(
    column: $table.urlCompleto,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $$LocalAvisosPrivacidadTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalAvisosPrivacidadTable,
          LocalAvisosPrivacidadData,
          $$LocalAvisosPrivacidadTableFilterComposer,
          $$LocalAvisosPrivacidadTableOrderingComposer,
          $$LocalAvisosPrivacidadTableAnnotationComposer,
          $$LocalAvisosPrivacidadTableCreateCompanionBuilder,
          $$LocalAvisosPrivacidadTableUpdateCompanionBuilder,
          (
            LocalAvisosPrivacidadData,
            BaseReferences<
              _$AppDatabase,
              $LocalAvisosPrivacidadTable,
              LocalAvisosPrivacidadData
            >,
          ),
          LocalAvisosPrivacidadData,
          PrefetchHooks Function()
        > {
  $$LocalAvisosPrivacidadTableTableManager(
    _$AppDatabase db,
    $LocalAvisosPrivacidadTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAvisosPrivacidadTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalAvisosPrivacidadTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalAvisosPrivacidadTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> resumen = const Value.absent(),
                Value<String> urlCompleto = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAvisosPrivacidadCompanion(
                id: id,
                version: version,
                titulo: titulo,
                resumen: resumen,
                urlCompleto: urlCompleto,
                activo: activo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String version,
                required String titulo,
                required String resumen,
                Value<String> urlCompleto = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAvisosPrivacidadCompanion.insert(
                id: id,
                version: version,
                titulo: titulo,
                resumen: resumen,
                urlCompleto: urlCompleto,
                activo: activo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAvisosPrivacidadTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalAvisosPrivacidadTable,
      LocalAvisosPrivacidadData,
      $$LocalAvisosPrivacidadTableFilterComposer,
      $$LocalAvisosPrivacidadTableOrderingComposer,
      $$LocalAvisosPrivacidadTableAnnotationComposer,
      $$LocalAvisosPrivacidadTableCreateCompanionBuilder,
      $$LocalAvisosPrivacidadTableUpdateCompanionBuilder,
      (
        LocalAvisosPrivacidadData,
        BaseReferences<
          _$AppDatabase,
          $LocalAvisosPrivacidadTable,
          LocalAvisosPrivacidadData
        >,
      ),
      LocalAvisosPrivacidadData,
      PrefetchHooks Function()
    >;
typedef $$LocalTurnosTableCreateCompanionBuilder =
    LocalTurnosCompanion Function({
      required String id,
      required String usuarioId,
      required String sitioId,
      required DateTime turnoFecha,
      required DateTime inicioAt,
      Value<DateTime?> finAt,
      required String estado,
      Value<String> clasificacionEntrada,
      Value<int> minutosRetardo,
      Value<bool> esDoblete,
      Value<int> rowid,
    });
typedef $$LocalTurnosTableUpdateCompanionBuilder =
    LocalTurnosCompanion Function({
      Value<String> id,
      Value<String> usuarioId,
      Value<String> sitioId,
      Value<DateTime> turnoFecha,
      Value<DateTime> inicioAt,
      Value<DateTime?> finAt,
      Value<String> estado,
      Value<String> clasificacionEntrada,
      Value<int> minutosRetardo,
      Value<bool> esDoblete,
      Value<int> rowid,
    });

class $$LocalTurnosTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTurnosTable> {
  $$LocalTurnosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inicioAt => $composableBuilder(
    column: $table.inicioAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finAt => $composableBuilder(
    column: $table.finAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clasificacionEntrada => $composableBuilder(
    column: $table.clasificacionEntrada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutosRetardo => $composableBuilder(
    column: $table.minutosRetardo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esDoblete => $composableBuilder(
    column: $table.esDoblete,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTurnosTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTurnosTable> {
  $$LocalTurnosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get usuarioId => $composableBuilder(
    column: $table.usuarioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sitioId => $composableBuilder(
    column: $table.sitioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inicioAt => $composableBuilder(
    column: $table.inicioAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finAt => $composableBuilder(
    column: $table.finAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clasificacionEntrada => $composableBuilder(
    column: $table.clasificacionEntrada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutosRetardo => $composableBuilder(
    column: $table.minutosRetardo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esDoblete => $composableBuilder(
    column: $table.esDoblete,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTurnosTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTurnosTable> {
  $$LocalTurnosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get sitioId =>
      $composableBuilder(column: $table.sitioId, builder: (column) => column);

  GeneratedColumn<DateTime> get turnoFecha => $composableBuilder(
    column: $table.turnoFecha,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get inicioAt =>
      $composableBuilder(column: $table.inicioAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finAt =>
      $composableBuilder(column: $table.finAt, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get clasificacionEntrada => $composableBuilder(
    column: $table.clasificacionEntrada,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutosRetardo => $composableBuilder(
    column: $table.minutosRetardo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esDoblete =>
      $composableBuilder(column: $table.esDoblete, builder: (column) => column);
}

class $$LocalTurnosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTurnosTable,
          LocalTurno,
          $$LocalTurnosTableFilterComposer,
          $$LocalTurnosTableOrderingComposer,
          $$LocalTurnosTableAnnotationComposer,
          $$LocalTurnosTableCreateCompanionBuilder,
          $$LocalTurnosTableUpdateCompanionBuilder,
          (
            LocalTurno,
            BaseReferences<_$AppDatabase, $LocalTurnosTable, LocalTurno>,
          ),
          LocalTurno,
          PrefetchHooks Function()
        > {
  $$LocalTurnosTableTableManager(_$AppDatabase db, $LocalTurnosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTurnosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTurnosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTurnosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> usuarioId = const Value.absent(),
                Value<String> sitioId = const Value.absent(),
                Value<DateTime> turnoFecha = const Value.absent(),
                Value<DateTime> inicioAt = const Value.absent(),
                Value<DateTime?> finAt = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String> clasificacionEntrada = const Value.absent(),
                Value<int> minutosRetardo = const Value.absent(),
                Value<bool> esDoblete = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTurnosCompanion(
                id: id,
                usuarioId: usuarioId,
                sitioId: sitioId,
                turnoFecha: turnoFecha,
                inicioAt: inicioAt,
                finAt: finAt,
                estado: estado,
                clasificacionEntrada: clasificacionEntrada,
                minutosRetardo: minutosRetardo,
                esDoblete: esDoblete,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String usuarioId,
                required String sitioId,
                required DateTime turnoFecha,
                required DateTime inicioAt,
                Value<DateTime?> finAt = const Value.absent(),
                required String estado,
                Value<String> clasificacionEntrada = const Value.absent(),
                Value<int> minutosRetardo = const Value.absent(),
                Value<bool> esDoblete = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTurnosCompanion.insert(
                id: id,
                usuarioId: usuarioId,
                sitioId: sitioId,
                turnoFecha: turnoFecha,
                inicioAt: inicioAt,
                finAt: finAt,
                estado: estado,
                clasificacionEntrada: clasificacionEntrada,
                minutosRetardo: minutosRetardo,
                esDoblete: esDoblete,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTurnosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTurnosTable,
      LocalTurno,
      $$LocalTurnosTableFilterComposer,
      $$LocalTurnosTableOrderingComposer,
      $$LocalTurnosTableAnnotationComposer,
      $$LocalTurnosTableCreateCompanionBuilder,
      $$LocalTurnosTableUpdateCompanionBuilder,
      (
        LocalTurno,
        BaseReferences<_$AppDatabase, $LocalTurnosTable, LocalTurno>,
      ),
      LocalTurno,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalAsistenciasTableTableManager get localAsistencias =>
      $$LocalAsistenciasTableTableManager(_db, _db.localAsistencias);
  $$LocalRegistrosAccesoTableTableManager get localRegistrosAcceso =>
      $$LocalRegistrosAccesoTableTableManager(_db, _db.localRegistrosAcceso);
  $$LocalVisitantesTableTableManager get localVisitantes =>
      $$LocalVisitantesTableTableManager(_db, _db.localVisitantes);
  $$LocalBitacoraEventosTableTableManager get localBitacoraEventos =>
      $$LocalBitacoraEventosTableTableManager(_db, _db.localBitacoraEventos);
  $$LocalBitacoraFotosTableTableManager get localBitacoraFotos =>
      $$LocalBitacoraFotosTableTableManager(_db, _db.localBitacoraFotos);
  $$LocalRecepcionesTurnoTableTableManager get localRecepcionesTurno =>
      $$LocalRecepcionesTurnoTableTableManager(_db, _db.localRecepcionesTurno);
  $$LocalRecepcionItemsTableTableManager get localRecepcionItems =>
      $$LocalRecepcionItemsTableTableManager(_db, _db.localRecepcionItems);
  $$LocalSitiosTableTableManager get localSitios =>
      $$LocalSitiosTableTableManager(_db, _db.localSitios);
  $$LocalWifiApsTableTableManager get localWifiAps =>
      $$LocalWifiApsTableTableManager(_db, _db.localWifiAps);
  $$LocalCatalogoEquipoTableTableManager get localCatalogoEquipo =>
      $$LocalCatalogoEquipoTableTableManager(_db, _db.localCatalogoEquipo);
  $$LocalPersonalClienteTableTableManager get localPersonalCliente =>
      $$LocalPersonalClienteTableTableManager(_db, _db.localPersonalCliente);
  $$LocalProfilesTableTableManager get localProfiles =>
      $$LocalProfilesTableTableManager(_db, _db.localProfiles);
  $$LocalAvisosPrivacidadTableTableManager get localAvisosPrivacidad =>
      $$LocalAvisosPrivacidadTableTableManager(_db, _db.localAvisosPrivacidad);
  $$LocalTurnosTableTableManager get localTurnos =>
      $$LocalTurnosTableTableManager(_db, _db.localTurnos);
}
