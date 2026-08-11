import test from "node:test";
import assert from "node:assert/strict";
import { createHash } from "node:crypto";

import {
  validarAccionAdmin,
  validarLoteRondines,
} from "../_shared/rondines_validation.mjs";

const sitioId = "11111111-1111-4111-8111-111111111111";
const seccionId = "22222222-2222-4222-8222-222222222222";
const puntoId = "33333333-3333-4333-8333-333333333333";
const rutaId = "44444444-4444-4444-8444-444444444444";
const turnoId = "55555555-5555-4555-8555-555555555555";
const rondinId = "66666666-6666-4666-8666-666666666666";
const lecturaId = "77777777-7777-4777-8777-777777777777";
const hashB = "b".repeat(64);
const qrRaw = `SIQR1.${puntoId}.1.${"t".repeat(64)}`;

function puntoAdmin(extra = {}) {
  return {
    accion: "crear_punto",
    sitio_id: sitioId,
    seccion_id: seccionId,
    nombre: "  Puerta norte  ",
    descripcion: "Acceso a producción",
    lat: 19.4326,
    lng: -99.1332,
    radio_metros: 35,
    wifi_ap_id: null,
    requiere_liveness: false,
    activo: true,
    orden: 1,
    segundos_minimos_desde_anterior: 90,
    ...extra,
  };
}

function lectura(extra = {}) {
  return {
    local_id: lecturaId,
    punto_id: puntoId,
    secuencia: 1,
    capturado_at_dispositivo: "2026-08-11T18:00:30.000Z",
    monotonic_ms: 1030000,
    boot_count: 7,
    lat: 19.4326,
    lng: -99.1332,
    gps_accuracy_m: 8.5,
    gps_age_ms: 1200,
    ubicacion_simulada: false,
    wifi_bssid: "AA:BB:CC:DD:EE:FF",
    wifi_ssid: "Planta",
    token_version: 1,
    qr_payload: qrRaw,
    hora_automatica: true,
    opciones_desarrollador: false,
    adb_activo: false,
    hash_anterior: null,
    hash_evento: hashB,
    validacion_local: "validado",
    estado_validacion: "validado",
    puntaje_riesgo: 0,
    codigos_riesgo: [],
    ...extra,
  };
}

function lote(extraRondin = {}) {
  return {
    rondines: [{
      local_id: rondinId,
      sitio_id: sitioId,
      ruta_id: rutaId,
      turno_id: turnoId,
      turno_fecha: "2026-08-11",
      device_id: "installation-123",
      iniciado_at_dispositivo: "2026-08-11T18:00:00.000Z",
      iniciado_monotonic_ms: 1000000,
      finalizado_at_dispositivo: "2026-08-11T18:01:00.000Z",
      estado_validacion: "validado",
      puntaje_riesgo: 0,
      lecturas: [lectura()],
      ...extraRondin,
    }],
  };
}

test("normaliza la creación de un punto y completa el máximo", () => {
  const resultado = validarAccionAdmin(puntoAdmin());
  assert.equal(resultado.ok, true);
  assert.equal(resultado.accion, "crear_punto");
  assert.equal(resultado.datos.nombre, "Puerta norte");
  assert.equal(resultado.datos.segundos_maximos_desde_anterior, 3600);
});

test("el máximo nunca queda debajo del mínimo configurado", () => {
  const resultado = validarAccionAdmin(puntoAdmin({
    segundos_minimos_desde_anterior: 7200,
  }));
  assert.equal(resultado.ok, true);
  assert.equal(resultado.datos.segundos_maximos_desde_anterior, 7200);
});

test("rechaza coordenadas incompletas", () => {
  const resultado = validarAccionAdmin(puntoAdmin({ lng: null }));
  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "COORDENADAS_INVALIDAS");
});

test("obtener código sólo conserva el UUID del punto", () => {
  const resultado = validarAccionAdmin({
    accion: "obtener_codigo",
    punto_id: puntoId,
    token: "no-debe-pasar",
  });
  assert.deepEqual(resultado, {
    ok: true,
    accion: "obtener_codigo",
    datos: { punto_id: puntoId },
  });
});

test("actualizar sección exige UUID y conserva sólo campos permitidos", () => {
  const resultado = validarAccionAdmin({
    accion: "actualizar_seccion",
    seccion_id: seccionId,
    sitio_id: sitioId,
    nombre: "  Almacén  ",
    descripcion: "Zona de materiales",
    activo: true,
    token: "no-debe-pasar",
  });
  assert.equal(resultado.ok, true);
  assert.deepEqual(resultado.datos, {
    seccion_id: seccionId,
    sitio_id: sitioId,
    nombre: "Almacén",
    descripcion: "Zona de materiales",
    activo: true,
  });
});

test("aprueba un rondín sin exigir motivo y elimina campos extra", () => {
  const resultado = validarAccionAdmin({
    accion: "revisar_rondin",
    rondin_id: rondinId,
    decision: "aprobado",
    motivo: "  ",
    qr_payload: "no-debe-pasar",
  });
  assert.deepEqual(resultado, {
    ok: true,
    accion: "revisar_rondin",
    datos: {
      rondin_id: rondinId,
      decision: "aprobado",
      motivo: "",
    },
  });
});

test("rechazar un rondín exige y normaliza el motivo", () => {
  const valido = validarAccionAdmin({
    accion: "revisar_rondin",
    rondin_id: rondinId,
    decision: "rechazado",
    motivo: "  Secuencia imposible  ",
  });
  assert.equal(valido.ok, true);
  assert.equal(valido.datos.motivo, "Secuencia imposible");

  const invalido = validarAccionAdmin({
    accion: "revisar_rondin",
    rondin_id: rondinId,
    decision: "rechazado",
    motivo: " \t\n ",
  });
  assert.equal(invalido.ok, false);
  assert.equal(invalido.codigo, "MOTIVO_REQUERIDO");
});

test("la decisión de revisión sólo admite valores exactos", () => {
  const resultado = validarAccionAdmin({
    accion: "revisar_rondin",
    rondin_id: rondinId,
    decision: "APROBADO",
    motivo: "",
  });
  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "DECISION_INVALIDA");
});

test("el motivo de revisión no acepta valores que no sean texto", () => {
  const resultado = validarAccionAdmin({
    accion: "revisar_rondin",
    rondin_id: rondinId,
    decision: "rechazado",
    motivo: 123,
  });
  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "MOTIVO_INVALIDO");
});

test("normaliza el lote, calcula el hash y elimina RAW y veredicto del cliente", async () => {
  const resultado = await validarLoteRondines(lote());
  assert.equal(resultado.ok, true);
  const rondin = resultado.rondines[0];
  assert.equal("estado_validacion" in rondin, false);
  assert.equal("puntaje_riesgo" in rondin, false);
  assert.equal("estado_validacion" in rondin.lecturas[0], false);
  assert.equal("validacion_local" in rondin.lecturas[0], false);
  assert.equal("qr_payload" in rondin.lecturas[0], false);
  assert.equal(
    rondin.lecturas[0].qr_payload_hash,
    createHash("sha256").update(qrRaw, "utf8").digest("hex"),
  );
});

test("rechaza un RAW que no tenga el formato canónico", async () => {
  const resultado = await validarLoteRondines(lote({
    lecturas: [lectura({ qr_payload: "fotografia" })],
  }));
  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "LECTURA_QR_INCOHERENTE");
});

test("rechaza un QR cuyo punto declarado no coincide con el RAW", async () => {
  const otroPunto = "99999999-9999-4999-8999-999999999999";
  const resultado = await validarLoteRondines(lote({
    lecturas: [lectura({ punto_id: otroPunto })],
  }));
  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "LECTURA_QR_INCOHERENTE");
});

test("rechaza un QR cuya versión declarada no coincide con el RAW", async () => {
  const resultado = await validarLoteRondines(lote({
    lecturas: [lectura({ token_version: 2 })],
  }));
  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "LECTURA_QR_INCOHERENTE");
});

test("rechaza puntos repetidos aunque cambie el local_id", async () => {
  const resultado = await validarLoteRondines(lote({
    lecturas: [
      lectura(),
      lectura({
        local_id: "88888888-8888-4888-8888-888888888888",
        secuencia: 2,
        hash_anterior: hashB,
      }),
    ],
  }));
  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "LECTURA_DUPLICADA");
});

test("rechaza un lote que repite el local_id del rondín", async () => {
  const primero = lote().rondines[0];
  const resultado = await validarLoteRondines({ rondines: [primero, primero] });
  assert.equal(resultado.ok, false);
  assert.equal(resultado.codigo, "RONDIN_DUPLICADO");
});
