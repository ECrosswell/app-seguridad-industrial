import '../../core/constants/enums.dart';

class Notificacion {
  const Notificacion({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.cuerpo,
    required this.prioridad,
    required this.creadaAt,
    this.sitioId,
    this.entidadTipo = '',
    this.entidadId,
    this.leida = false,
    this.payload = const {},
  });

  final String id;
  final TipoNotificacion tipo;
  final String titulo;
  final String cuerpo;
  final Prioridad prioridad;
  final DateTime creadaAt;
  final String? sitioId;
  final String entidadTipo;
  final String? entidadId;
  final bool leida;
  final Map<String, dynamic> payload;

  factory Notificacion.desdeJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'] as String,
      tipo: TipoNotificacion.desdeValor(json['tipo'] as String?),
      titulo: json['titulo'] as String? ?? '',
      cuerpo: json['cuerpo'] as String? ?? '',
      prioridad: Prioridad.desdeValor(json['prioridad'] as String?),
      creadaAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '')?.toLocal() ??
              DateTime.now(),
      sitioId: json['sitio_id'] as String?,
      entidadTipo: json['entidad_tipo'] as String? ?? '',
      entidadId: json['entidad_id'] as String?,
      leida: json['leida'] as bool? ?? false,
      payload: (json['payload'] as Map?)?.cast<String, dynamic>() ?? const {},
    );
  }
}
