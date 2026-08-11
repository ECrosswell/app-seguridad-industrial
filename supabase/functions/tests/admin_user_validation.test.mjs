import assert from "node:assert/strict";
import test from "node:test";

import {
  errorPasswordTemporal,
  normalizarTelefono,
  validarAltaUsuario,
  validarCambioPropio,
  validarRestablecimiento,
} from "../_shared/admin_user_validation.mjs";

const sitioId = "11111111-1111-4111-8111-111111111111";
const usuarioId = "22222222-2222-4222-8222-222222222222";

test("normaliza y acepta un alta administrativa válida", () => {
  const resultado = validarAltaUsuario({
    nombre_completo: "  Erika Cruz  ",
    correo: "  ERIKA@EXAMPLE.COM ",
    telefono_whatsapp: "+52 (55) 1234-5678",
    rol: "supervisor",
    sitio_id: sitioId,
    password_temporal: "Temporal9",
  });

  assert.equal(resultado.ok, true);
  assert.deepEqual(resultado.valor, {
    nombreCompleto: "Erika Cruz",
    correo: "erika@example.com",
    telefonoWhatsapp: "525512345678",
    rol: "supervisor",
    sitioId,
    passwordTemporal: "Temporal9",
  });
});

test("el alta sólo admite cliente, supervisor o elemento", () => {
  const resultado = validarAltaUsuario({
    nombre_completo: "Administrador Segundo",
    correo: "admin@example.com",
    telefono_whatsapp: "",
    rol: "admin",
    sitio_id: sitioId,
    password_temporal: "Temporal9",
  });

  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "ROL_NO_PERMITIDO");
});

test("el alta exige un sitio UUID válido", () => {
  const resultado = validarAltaUsuario({
    nombre_completo: "Erika Cruz",
    correo: "erika@example.com",
    telefono_whatsapp: "",
    rol: "cliente",
    sitio_id: "no-es-uuid",
    password_temporal: "Temporal9",
  });

  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "SITIO_INVALIDO");
});

test("la contraseña temporal exige ocho caracteres y un número", () => {
  assert.equal(errorPasswordTemporal("corta1"), "Usa al menos 8 caracteres.");
  assert.equal(
    errorPasswordTemporal("sinNumeros"),
    "Incluye al menos un número.",
  );
  assert.equal(errorPasswordTemporal("Valida123"), null);
});

test("normaliza WhatsApp sin conservar símbolos", () => {
  assert.equal(normalizarTelefono("+52 55-1234-5678"), "525512345678");
});

test("acepta un restablecimiento válido", () => {
  const resultado = validarRestablecimiento({
    usuario_id: usuarioId,
    password_temporal: "NuevaClave7",
  });

  assert.equal(resultado.ok, true);
  assert.deepEqual(resultado.valor, {
    usuarioId,
    passwordTemporal: "NuevaClave7",
  });
});

test("rechaza un identificador de usuario inválido", () => {
  const resultado = validarRestablecimiento({
    usuario_id: "123",
    password_temporal: "NuevaClave7",
  });

  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "USUARIO_INVALIDO");
});

test("valida el cambio de contraseña propio", () => {
  const resultado = validarCambioPropio({
    password_nueva: "NuevaClave8",
  });

  assert.equal(resultado.ok, true);
  assert.deepEqual(resultado.valor, { passwordNueva: "NuevaClave8" });
});
