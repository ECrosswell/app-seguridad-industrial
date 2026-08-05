import 'dart:math' as math;

/// Un sitio es una planta con su geocerca y su configuración de turno.
class Sitio {
  const Sitio({
    required this.id,
    required this.nombre,
    this.razonSocial = '',
    this.direccion = '',
    this.lat,
    this.lng,
    this.radioMetros = 150,
    this.horaInicioTurno = '08:00',
    this.minutosToleranciaRetardo = 1,
    this.minutosToleranciaFalta = 90,
    this.minutosAlertaRelevo = 60,
    this.husoHorarioOffsetH = -6,
    this.activo = true,
  });

  final String id;
  final String nombre;
  final String razonSocial;
  final String direccion;
  final double? lat;
  final double? lng;
  final int radioMetros;
  final String horaInicioTurno;
  final int minutosToleranciaRetardo;
  final int minutosToleranciaFalta;
  final int minutosAlertaRelevo;
  final int husoHorarioOffsetH;
  final bool activo;

  factory Sitio.desdeJson(Map<String, dynamic> json) {
    return Sitio(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      razonSocial: json['razon_social'] as String? ?? '',
      direccion: json['direccion'] as String? ?? '',
      lat: _aDouble(json['lat']),
      lng: _aDouble(json['lng']),
      radioMetros: json['radio_metros'] as int? ?? 150,
      horaInicioTurno: (json['hora_inicio_turno'] as String? ?? '08:00')
          .substring(0, 5),
      minutosToleranciaRetardo: json['minutos_tolerancia_retardo'] as int? ?? 1,
      minutosToleranciaFalta: json['minutos_tolerancia_falta'] as int? ?? 90,
      minutosAlertaRelevo: json['minutos_alerta_relevo'] as int? ?? 60,
      husoHorarioOffsetH: json['huso_horario_offset_h'] as int? ?? -6,
      activo: json['activo'] as bool? ?? true,
    );
  }

  /// ¿Ya se capturó la geocerca? Mientras no, la validación de asistencia se
  /// apoya sólo en el BSSID del WiFi.
  bool get tieneGeocerca => lat != null && lng != null;

  /// Distancia en metros entre el sitio y un punto, por la fórmula de
  /// Haversine. Es la misma que corre el servidor al clasificar la asistencia;
  /// aquí sirve para dar retroalimentación inmediata al elemento antes de
  /// enviar ("estás a 340 m de la planta").
  double? distanciaA(double otraLat, double otraLng) {
    if (!tieneGeocerca) return null;

    const radioTierraM = 6371000.0;
    final dLat = _aRadianes(otraLat - lat!);
    final dLng = _aRadianes(otraLng - lng!);

    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_aRadianes(lat!)) *
            math.cos(_aRadianes(otraLat)) *
            math.pow(math.sin(dLng / 2), 2);

    return radioTierraM * 2 * math.asin(math.sqrt(a));
  }

  bool estaDentro(double otraLat, double otraLng) {
    final d = distanciaA(otraLat, otraLng);
    return d != null && d <= radioMetros;
  }

  /// Fecha operativa del turno para un instante dado.
  ///
  /// Un evento a las 03:00 pertenece al turno que arrancó a las 08:00 del día
  /// anterior, así que se resta el offset del huso y la hora de inicio antes de
  /// quedarse con la fecha.
  DateTime fechaTurnoDe(DateTime instante) {
    final local = instante.toUtc().add(Duration(hours: husoHorarioOffsetH));
    final partes = horaInicioTurno.split(':');
    final horas = int.tryParse(partes[0]) ?? 8;
    final minutos = partes.length > 1 ? int.tryParse(partes[1]) ?? 0 : 0;
    final ajustado = local.subtract(Duration(hours: horas, minutes: minutos));
    return DateTime(ajustado.year, ajustado.month, ajustado.day);
  }

  /// Instante en que arranca el turno de una fecha operativa dada.
  DateTime inicioDelTurno(DateTime fechaTurno) {
    final partes = horaInicioTurno.split(':');
    final horas = int.tryParse(partes[0]) ?? 8;
    final minutos = partes.length > 1 ? int.tryParse(partes[1]) ?? 0 : 0;
    return DateTime.utc(
      fechaTurno.year,
      fechaTurno.month,
      fechaTurno.day,
      horas,
      minutos,
    ).subtract(Duration(hours: husoHorarioOffsetH));
  }

  static double _aRadianes(double grados) => grados * math.pi / 180.0;

  static double? _aDouble(Object? v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }
}
