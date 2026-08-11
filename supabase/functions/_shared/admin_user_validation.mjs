export const ROLES_ADMINISTRABLES = Object.freeze([
  "elemento",
  "supervisor",
  "cliente",
]);

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const UUID =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

function texto(valor) {
  return typeof valor === "string" ? valor.trim() : "";
}

export function normalizarTelefono(valor) {
  return texto(valor).replace(/[^0-9]/g, "");
}

export function errorPasswordTemporal(valor) {
  const password = typeof valor === "string" ? valor : "";
  if (password.length < 8) return "Usa al menos 8 caracteres.";
  if (password.length > 128) return "La contraseña es demasiado larga.";
  if (!/[0-9]/.test(password)) return "Incluye al menos un número.";
  return null;
}

export function validarAltaUsuario(cuerpo) {
  if (!cuerpo || typeof cuerpo !== "object" || Array.isArray(cuerpo)) {
    return fallo("SOLICITUD_INVALIDA", "La solicitud no es válida.");
  }

  const nombreCompleto = texto(cuerpo.nombre_completo);
  const correo = texto(cuerpo.correo).toLowerCase();
  const telefonoWhatsapp = normalizarTelefono(cuerpo.telefono_whatsapp);
  const rol = texto(cuerpo.rol);
  const sitioId = texto(cuerpo.sitio_id);
  const passwordTemporal = typeof cuerpo.password_temporal === "string"
    ? cuerpo.password_temporal
    : "";

  if (nombreCompleto.length < 3 || nombreCompleto.length > 120) {
    return fallo(
      "NOMBRE_INVALIDO",
      "Captura un nombre completo de entre 3 y 120 caracteres.",
    );
  }
  if (correo.length > 254 || !EMAIL.test(correo)) {
    return fallo("CORREO_INVALIDO", "Captura un correo válido.");
  }
  if (
    telefonoWhatsapp &&
    (telefonoWhatsapp.length < 10 || telefonoWhatsapp.length > 15)
  ) {
    return fallo(
      "TELEFONO_INVALIDO",
      "El WhatsApp debe tener entre 10 y 15 dígitos.",
    );
  }
  if (!ROLES_ADMINISTRABLES.includes(rol)) {
    return fallo("ROL_NO_PERMITIDO", "El rol seleccionado no está permitido.");
  }
  if (!UUID.test(sitioId)) {
    return fallo("SITIO_INVALIDO", "Selecciona un sitio válido.");
  }

  const passwordError = errorPasswordTemporal(passwordTemporal);
  if (passwordError) {
    return fallo("PASSWORD_INVALIDO", passwordError);
  }

  return {
    ok: true,
    valor: {
      nombreCompleto,
      correo,
      telefonoWhatsapp,
      rol,
      sitioId,
      passwordTemporal,
    },
  };
}

export function validarRestablecimiento(cuerpo) {
  if (!cuerpo || typeof cuerpo !== "object" || Array.isArray(cuerpo)) {
    return fallo("SOLICITUD_INVALIDA", "La solicitud no es válida.");
  }

  const usuarioId = texto(cuerpo.usuario_id);
  const passwordTemporal = typeof cuerpo.password_temporal === "string"
    ? cuerpo.password_temporal
    : "";

  if (!UUID.test(usuarioId)) {
    return fallo("USUARIO_INVALIDO", "El usuario seleccionado no es válido.");
  }

  const passwordError = errorPasswordTemporal(passwordTemporal);
  if (passwordError) {
    return fallo("PASSWORD_INVALIDO", passwordError);
  }

  return { ok: true, valor: { usuarioId, passwordTemporal } };
}

export function validarCambioPropio(cuerpo) {
  if (!cuerpo || typeof cuerpo !== "object" || Array.isArray(cuerpo)) {
    return fallo("SOLICITUD_INVALIDA", "La solicitud no es válida.");
  }

  const passwordNueva = typeof cuerpo.password_nueva === "string"
    ? cuerpo.password_nueva
    : "";
  const passwordError = errorPasswordTemporal(passwordNueva);
  if (passwordError) {
    return fallo("PASSWORD_INVALIDO", passwordError);
  }

  return { ok: true, valor: { passwordNueva } };
}

function fallo(codigo, error) {
  return { ok: false, codigo, error };
}
