class UsuarioAdminValidators {
  const UsuarioAdminValidators._();

  static final RegExp _correo = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? nombre(String? valor) {
    final limpio = valor?.trim() ?? '';
    if (limpio.length < 3) return 'Captura el nombre completo';
    if (limpio.length > 120) return 'El nombre es demasiado largo';
    return null;
  }

  static String? correo(String? valor) {
    final limpio = valor?.trim() ?? '';
    if (limpio.length > 254 || !_correo.hasMatch(limpio)) {
      return 'Captura un correo válido';
    }
    return null;
  }

  static String? telefono(String? valor) {
    final digitos = normalizarTelefono(valor ?? '');
    if (digitos.isEmpty) return null;
    if (digitos.length < 10 || digitos.length > 15) {
      return 'Usa entre 10 y 15 dígitos';
    }
    return null;
  }

  static String? passwordTemporal(String? valor) {
    final password = valor ?? '';
    if (password.length < 8) return 'Usa al menos 8 caracteres';
    if (password.length > 128) return 'La contraseña es demasiado larga';
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Incluye al menos un número';
    }
    return null;
  }

  static String? confirmacion(String? valor, String password) {
    return valor == password ? null : 'Las contraseñas no coinciden';
  }

  static String normalizarTelefono(String valor) {
    return valor.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
