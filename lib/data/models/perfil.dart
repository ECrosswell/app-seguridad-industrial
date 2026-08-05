import '../../core/constants/enums.dart';

/// Perfil de un usuario del sistema.
///
/// Sin `freezed`: el proyecto ya carga el generador de Drift y agregar un
/// segundo generador multiplica las oportunidades de que un choque de versiones
/// tumbe el build — que es justo lo que le pasó a App Plaza Encuentro con
/// `drift_dev` y `analyzer`.
class Perfil {
  const Perfil({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.telefonoWhatsapp,
    required this.rol,
    this.puesto = '',
    this.fotoPerfilUrl,
    this.estadoLaboral = EstadoLaboral.activo,
    this.debeCambiarPassword = false,
    this.activo = true,
    this.fechaAlta,
    this.fechaBaja,
    this.motivoBaja = '',
  });

  final String id;
  final String nombreCompleto;
  final String correo;
  final String telefonoWhatsapp;
  final RolUsuario rol;
  final String puesto;
  final String? fotoPerfilUrl;
  final EstadoLaboral estadoLaboral;
  final bool debeCambiarPassword;
  final bool activo;
  final DateTime? fechaAlta;
  final DateTime? fechaBaja;
  final String motivoBaja;

  factory Perfil.desdeJson(Map<String, dynamic> json) {
    return Perfil(
      id: json['id'] as String,
      nombreCompleto: json['nombre_completo'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      telefonoWhatsapp: json['telefono_whatsapp'] as String? ?? '',
      rol: RolUsuario.desdeValor(json['rol'] as String?),
      puesto: json['puesto'] as String? ?? '',
      fotoPerfilUrl: json['foto_perfil_url'] as String?,
      estadoLaboral: EstadoLaboral.desdeValor(json['estado_laboral'] as String?),
      debeCambiarPassword: json['debe_cambiar_password'] as bool? ?? false,
      activo: json['activo'] as bool? ?? true,
      fechaAlta: _fecha(json['fecha_alta']),
      fechaBaja: _fecha(json['fecha_baja']),
      motivoBaja: json['motivo_baja'] as String? ?? '',
    );
  }

  Map<String, dynamic> aJson() => {
        'id': id,
        'nombre_completo': nombreCompleto,
        'correo': correo,
        'telefono_whatsapp': telefonoWhatsapp,
        'rol': rol.valor,
        'puesto': puesto,
        'foto_perfil_url': fotoPerfilUrl,
        'estado_laboral': estadoLaboral.valor,
        'activo': activo,
      };

  /// Iniciales para el avatar cuando no hay foto.
  String get iniciales {
    final partes = nombreCompleto.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes[0][0] + partes[1][0]).toUpperCase();
  }

  /// Enlace para abrir WhatsApp con este usuario.
  ///
  /// `wa.me` espera el número en E.164 **sin** el `+` ni separadores. Se limpia
  /// aquí y no al capturar para tolerar que el admin lo escriba con espacios,
  /// guiones o paréntesis, que es como viene en la práctica.
  String? get enlaceWhatsapp {
    final limpio = telefonoWhatsapp.replaceAll(RegExp(r'[^0-9]'), '');
    if (limpio.length < 10) return null;
    return 'https://wa.me/$limpio';
  }

  bool get tieneWhatsapp => enlaceWhatsapp != null;

  static DateTime? _fecha(Object? v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  Perfil copiarCon({
    String? nombreCompleto,
    String? telefonoWhatsapp,
    String? puesto,
    bool? debeCambiarPassword,
  }) {
    return Perfil(
      id: id,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      correo: correo,
      telefonoWhatsapp: telefonoWhatsapp ?? this.telefonoWhatsapp,
      rol: rol,
      puesto: puesto ?? this.puesto,
      fotoPerfilUrl: fotoPerfilUrl,
      estadoLaboral: estadoLaboral,
      debeCambiarPassword: debeCambiarPassword ?? this.debeCambiarPassword,
      activo: activo,
      fechaAlta: fechaAlta,
      fechaBaja: fechaBaja,
      motivoBaja: motivoBaja,
    );
  }
}
