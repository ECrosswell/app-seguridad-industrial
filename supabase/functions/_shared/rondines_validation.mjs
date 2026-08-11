const UUID_RE = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const HASH_RE = /^[0-9a-f]{64}$/i;
const TOKEN_QR_RE = /^[A-Za-z0-9_-]{32,200}$/;

const ACCIONES_ADMIN = new Set([
  "listar",
  "listar_puntos",
  "crear_seccion",
  "actualizar_seccion",
  "revisar_rondin",
  "crear_punto",
  "actualizar_punto",
  "rotar_codigo",
  "obtener_codigo",
]);

function objeto(valor) {
  return valor !== null && typeof valor === "object" && !Array.isArray(valor);
}

function fallo(codigo, error) {
  return { ok: false, codigo, error };
}

function uuid(valor) {
  return typeof valor === "string" && UUID_RE.test(valor.trim());
}

function hash(valor) {
  return typeof valor === "string" && HASH_RE.test(valor.trim());
}

function entero(valor, minimo, maximo) {
  return Number.isSafeInteger(valor) && valor >= minimo && valor <= maximo;
}

function numero(valor, minimo, maximo) {
  return typeof valor === "number" && Number.isFinite(valor) &&
    valor >= minimo && valor <= maximo;
}

function fechaIso(valor) {
  return typeof valor === "string" && valor.length <= 50 &&
    Number.isFinite(Date.parse(valor));
}

function texto(valor, maximo, requerido = false) {
  if (typeof valor !== "string") return requerido ? null : "";
  const limpio = valor.trim();
  if ((requerido && limpio.length === 0) || limpio.length > maximo) return null;
  return limpio;
}

function booleano(valor, predeterminado) {
  return typeof valor === "boolean" ? valor : predeterminado;
}

function normalizarUuidOpcional(valor) {
  if (valor === null || valor === undefined || valor === "") return null;
  return uuid(valor) ? valor.trim().toLowerCase() : undefined;
}

export async function sha256Hex(valor) {
  const bytes = new TextEncoder().encode(valor);
  const digest = await globalThis.crypto.subtle.digest("SHA-256", bytes);
  return [...new Uint8Array(digest)]
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

export function parsearQrRondin(valor) {
  if (typeof valor !== "string" || valor.length > 500 || valor.trim() !== valor) {
    return null;
  }
  const partes = valor.split(".");
  if (partes.length !== 4 || partes[0] !== "SIQR1" ||
    !uuid(partes[1]) || !TOKEN_QR_RE.test(partes[3])) {
    return null;
  }
  const version = Number(partes[2]);
  if (!entero(version, 1, 2147483647) || partes[2] !== String(version)) {
    return null;
  }
  return {
    puntoId: partes[1].toLowerCase(),
    version,
  };
}

export function validarAccionAdmin(cuerpo) {
  if (!objeto(cuerpo)) return fallo("JSON_INVALIDO", "Envía un objeto JSON.");
  const accion = typeof cuerpo.accion === "string" ? cuerpo.accion.trim() : "";
  if (!ACCIONES_ADMIN.has(accion)) {
    return fallo("ACCION_NO_PERMITIDA", "La acción no está permitida.");
  }

  if (accion === "listar" || accion === "listar_puntos") {
    const sitioId = normalizarUuidOpcional(cuerpo.sitio_id);
    if (sitioId === undefined) {
      return fallo("SITIO_INVALIDO", "El sitio no es válido.");
    }
    return { ok: true, accion, datos: sitioId ? { sitio_id: sitioId } : {} };
  }

  if (accion === "crear_seccion" || accion === "actualizar_seccion") {
    const nombre = texto(cuerpo.nombre, 120, true);
    if (!uuid(cuerpo.sitio_id)) {
      return fallo("SITIO_INVALIDO", "Selecciona un sitio válido.");
    }
    if (nombre === null) {
      return fallo("NOMBRE_INVALIDO", "Escribe un nombre de hasta 120 caracteres.");
    }
    const descripcion = texto(cuerpo.descripcion ?? "", 1000);
    if (descripcion === null) {
      return fallo("DESCRIPCION_INVALIDA", "La descripción es demasiado larga.");
    }
    if (accion === "actualizar_seccion" && !uuid(cuerpo.seccion_id)) {
      return fallo("SECCION_INVALIDA", "La sección no es válida.");
    }
    return {
      ok: true,
      accion,
      datos: {
        ...(accion === "actualizar_seccion"
          ? { seccion_id: cuerpo.seccion_id.trim().toLowerCase() }
          : {}),
        sitio_id: cuerpo.sitio_id.trim().toLowerCase(),
        nombre,
        descripcion,
        activo: booleano(cuerpo.activo, true),
      },
    };
  }

  if (accion === "revisar_rondin") {
    if (!uuid(cuerpo.rondin_id)) {
      return fallo("RONDIN_INVALIDO", "El rondín no es válido.");
    }
    if (cuerpo.decision !== "aprobado" && cuerpo.decision !== "rechazado") {
      return fallo(
        "DECISION_INVALIDA",
        "La decisión debe ser aprobado o rechazado.",
      );
    }
    if (cuerpo.motivo !== undefined && cuerpo.motivo !== null &&
      typeof cuerpo.motivo !== "string") {
      return fallo("MOTIVO_INVALIDO", "El motivo no es válido.");
    }
    const motivo = (cuerpo.motivo ?? "").trim();
    if (motivo.length > 2000) {
      return fallo(
        "MOTIVO_DEMASIADO_LARGO",
        "El motivo no puede exceder 2000 caracteres.",
      );
    }
    if (cuerpo.decision === "rechazado" && motivo.length === 0) {
      return fallo("MOTIVO_REQUERIDO", "Escribe el motivo del rechazo.");
    }
    return {
      ok: true,
      accion,
      datos: {
        rondin_id: cuerpo.rondin_id.trim().toLowerCase(),
        decision: cuerpo.decision,
        motivo,
      },
    };
  }

  if (["actualizar_punto", "rotar_codigo", "obtener_codigo"].includes(accion) &&
    !uuid(cuerpo.punto_id)) {
    return fallo("PUNTO_INVALIDO", "El punto no es válido.");
  }
  if (accion === "rotar_codigo" || accion === "obtener_codigo") {
    return {
      ok: true,
      accion,
      datos: { punto_id: cuerpo.punto_id.trim().toLowerCase() },
    };
  }

  if (!uuid(cuerpo.sitio_id)) {
    return fallo("SITIO_INVALIDO", "Selecciona un sitio válido.");
  }
  if (!uuid(cuerpo.seccion_id)) {
    return fallo("SECCION_INVALIDA", "Selecciona una sección válida.");
  }
  const nombre = texto(cuerpo.nombre, 120, true);
  const descripcion = texto(cuerpo.descripcion ?? "", 1000);
  if (nombre === null) {
    return fallo("NOMBRE_INVALIDO", "Escribe un nombre de hasta 120 caracteres.");
  }
  if (descripcion === null) {
    return fallo("DESCRIPCION_INVALIDA", "La descripción es demasiado larga.");
  }

  const lat = cuerpo.lat === null || cuerpo.lat === undefined ? null : cuerpo.lat;
  const lng = cuerpo.lng === null || cuerpo.lng === undefined ? null : cuerpo.lng;
  if ((lat === null) !== (lng === null) ||
    (lat !== null && (!numero(lat, -90, 90) || !numero(lng, -180, 180)))) {
    return fallo("COORDENADAS_INVALIDAS", "Latitud y longitud deben ser válidas.");
  }
  if (!entero(cuerpo.radio_metros, 5, 1000)) {
    return fallo("RADIO_INVALIDO", "El radio debe estar entre 5 y 1000 metros.");
  }
  const wifiApId = normalizarUuidOpcional(cuerpo.wifi_ap_id);
  if (wifiApId === undefined) {
    return fallo("WIFI_INVALIDO", "El punto de acceso WiFi no es válido.");
  }
  if (!entero(cuerpo.orden, 1, 1000)) {
    return fallo("ORDEN_INVALIDO", "El orden debe estar entre 1 y 1000.");
  }
  if (!entero(cuerpo.segundos_minimos_desde_anterior, 0, 86400)) {
    return fallo(
      "TIEMPO_MINIMO_INVALIDO",
      "El tiempo mínimo debe estar entre 0 y 86400 segundos.",
    );
  }
  const maximo = cuerpo.segundos_maximos_desde_anterior ?? Math.max(
    3600,
    cuerpo.segundos_minimos_desde_anterior,
  );
  if (!entero(maximo, 1, 172800) ||
    maximo < cuerpo.segundos_minimos_desde_anterior) {
    return fallo("TIEMPO_MAXIMO_INVALIDO", "El tiempo máximo no es válido.");
  }

  return {
    ok: true,
    accion,
    datos: {
      ...(accion === "actualizar_punto"
        ? { punto_id: cuerpo.punto_id.trim().toLowerCase() }
        : {}),
      sitio_id: cuerpo.sitio_id.trim().toLowerCase(),
      seccion_id: cuerpo.seccion_id.trim().toLowerCase(),
      nombre,
      descripcion,
      lat,
      lng,
      radio_metros: cuerpo.radio_metros,
      wifi_ap_id: wifiApId,
      requiere_liveness: booleano(cuerpo.requiere_liveness, false),
      activo: booleano(cuerpo.activo, true),
      orden: cuerpo.orden,
      segundos_minimos_desde_anterior: cuerpo.segundos_minimos_desde_anterior,
      segundos_maximos_desde_anterior: maximo,
    },
  };
}

async function validarLectura(lectura) {
  if (!objeto(lectura)) return fallo("LECTURA_INVALIDA", "Una lectura no es un objeto.");
  if (!uuid(lectura.local_id)) {
    return fallo("LECTURA_LOCAL_ID", "Una lectura tiene local_id inválido.");
  }
  if (!uuid(lectura.punto_id)) {
    return fallo("LECTURA_PUNTO", "Una lectura tiene punto_id inválido.");
  }
  if (!entero(lectura.secuencia, 1, 1000)) {
    return fallo("LECTURA_SECUENCIA", "Una lectura tiene secuencia inválida.");
  }
  if (!fechaIso(lectura.capturado_at_dispositivo)) {
    return fallo("LECTURA_FECHA", "Una lectura tiene fecha inválida.");
  }
  if (!entero(lectura.monotonic_ms, 0, Number.MAX_SAFE_INTEGER)) {
    return fallo("LECTURA_MONOTONIC", "Una lectura tiene reloj monotónico inválido.");
  }
  if (!entero(lectura.boot_count ?? 0, 0, 2147483647)) {
    return fallo("LECTURA_BOOT", "Una lectura tiene boot_count inválido.");
  }
  const lat = lectura.lat === null || lectura.lat === undefined ? null : lectura.lat;
  const lng = lectura.lng === null || lectura.lng === undefined ? null : lectura.lng;
  if ((lat === null) !== (lng === null) ||
    (lat !== null && (!numero(lat, -90, 90) || !numero(lng, -180, 180)))) {
    return fallo("LECTURA_GPS", "Una lectura tiene coordenadas inválidas.");
  }
  const accuracy = lectura.gps_accuracy_m === null ||
      lectura.gps_accuracy_m === undefined
    ? null
    : lectura.gps_accuracy_m;
  if (accuracy !== null && !numero(accuracy, 0, 100000)) {
    return fallo("LECTURA_PRECISION", "Una lectura tiene precisión GPS inválida.");
  }
  const gpsAge = lectura.gps_age_ms === null || lectura.gps_age_ms === undefined
    ? null
    : lectura.gps_age_ms;
  if (gpsAge !== null && !entero(gpsAge, 0, 2147483647)) {
    return fallo("LECTURA_GPS_AGE", "Una lectura tiene antigüedad GPS inválida.");
  }
  if (!entero(lectura.token_version, 1, 2147483647)) {
    return fallo("LECTURA_QR", "Una lectura tiene evidencia QR inválida.");
  }
  const qrParseado = parsearQrRondin(lectura.qr_payload);
  if (qrParseado === null || qrParseado.puntoId !== lectura.punto_id.trim().toLowerCase() ||
    qrParseado.version !== lectura.token_version) {
    return fallo(
      "LECTURA_QR_INCOHERENTE",
      "El QR no corresponde al punto y versión declarados.",
    );
  }
  const qrPayloadHash = await sha256Hex(lectura.qr_payload);
  const hashAnterior = lectura.hash_anterior === null ||
      lectura.hash_anterior === undefined || lectura.hash_anterior === ""
    ? null
    : lectura.hash_anterior.trim().toLowerCase();
  if (hashAnterior !== null && !hash(hashAnterior)) {
    return fallo("LECTURA_CADENA", "Una lectura tiene hash_anterior inválido.");
  }
  if (!hash(lectura.hash_evento)) {
    return fallo("LECTURA_HASH", "Una lectura tiene hash_evento inválido.");
  }
  const wifiBssid = texto(lectura.wifi_bssid ?? "", 100);
  const wifiSsid = texto(lectura.wifi_ssid ?? "", 200);
  if (wifiBssid === null || wifiSsid === null) {
    return fallo("LECTURA_WIFI", "Una lectura tiene datos WiFi inválidos.");
  }
  if (lectura.liveness_passed !== undefined && lectura.liveness_passed !== null &&
    typeof lectura.liveness_passed !== "boolean") {
    return fallo("LECTURA_LIVENESS", "Una lectura tiene liveness inválido.");
  }

  return {
    ok: true,
    valor: {
      local_id: lectura.local_id.trim().toLowerCase(),
      punto_id: lectura.punto_id.trim().toLowerCase(),
      secuencia: lectura.secuencia,
      capturado_at_dispositivo: lectura.capturado_at_dispositivo,
      monotonic_ms: lectura.monotonic_ms,
      boot_count: lectura.boot_count ?? 0,
      lat,
      lng,
      gps_accuracy_m: accuracy,
      gps_age_ms: gpsAge,
      ubicacion_simulada: booleano(
        lectura.ubicacion_simulada ?? lectura.gps_is_mocked,
        false,
      ),
      wifi_bssid: wifiBssid || null,
      wifi_ssid: wifiSsid || null,
      token_version: lectura.token_version,
      // El RAW no sale de este validador: solamente el digest cruza hacia la RPC.
      qr_payload_hash: qrPayloadHash,
      hora_automatica: booleano(lectura.hora_automatica, true),
      opciones_desarrollador: booleano(lectura.opciones_desarrollador, false),
      adb_activo: booleano(lectura.adb_activo, false),
      hash_anterior: hashAnterior,
      hash_evento: lectura.hash_evento.trim().toLowerCase(),
      ...(typeof lectura.liveness_passed === "boolean"
        ? { liveness_passed: lectura.liveness_passed }
        : {}),
    },
  };
}

async function validarRondin(rondin) {
  if (!objeto(rondin)) return fallo("RONDIN_INVALIDO", "Un rondín no es un objeto.");
  if (!uuid(rondin.local_id)) {
    return fallo("RONDIN_LOCAL_ID", "Un rondín tiene local_id inválido.");
  }
  if (!uuid(rondin.sitio_id) || !uuid(rondin.ruta_id)) {
    return fallo("RONDIN_CATALOGO", "Un rondín tiene sitio o ruta inválidos.");
  }
  const turnoId = normalizarUuidOpcional(rondin.turno_id);
  if (turnoId === undefined) {
    return fallo("RONDIN_TURNO", "Un rondín tiene turno_id inválido.");
  }
  const deviceId = texto(rondin.device_id, 200, true);
  if (deviceId === null) {
    return fallo("RONDIN_DEVICE", "Un rondín tiene device_id inválido.");
  }
  if (!fechaIso(rondin.iniciado_at_dispositivo) ||
    !entero(rondin.iniciado_monotonic_ms, 0, Number.MAX_SAFE_INTEGER)) {
    return fallo("RONDIN_INICIO", "Un rondín tiene inicio inválido.");
  }
  if (rondin.finalizado_at_dispositivo !== null &&
    rondin.finalizado_at_dispositivo !== undefined &&
    !fechaIso(rondin.finalizado_at_dispositivo)) {
    return fallo("RONDIN_FIN", "Un rondín tiene fin inválido.");
  }
  if (rondin.finalizado_monotonic_ms !== null &&
    rondin.finalizado_monotonic_ms !== undefined &&
    !entero(rondin.finalizado_monotonic_ms, 0, Number.MAX_SAFE_INTEGER)) {
    return fallo("RONDIN_FIN_MONOTONIC", "Un rondín tiene fin monotónico inválido.");
  }
  if (!Array.isArray(rondin.lecturas) || rondin.lecturas.length < 1 ||
    rondin.lecturas.length > 200) {
    return fallo("RONDIN_LECTURAS", "Cada rondín requiere de 1 a 200 lecturas.");
  }

  const lecturas = [];
  const locales = new Set();
  const puntos = new Set();
  const secuencias = new Set();
  for (const lectura of rondin.lecturas) {
    const validacion = await validarLectura(lectura);
    if (!validacion.ok) return validacion;
    const valor = validacion.valor;
    if (locales.has(valor.local_id) || puntos.has(valor.punto_id) ||
      secuencias.has(valor.secuencia)) {
      return fallo(
        "LECTURA_DUPLICADA",
        "No se admiten local_id, punto o secuencia repetidos en un rondín.",
      );
    }
    locales.add(valor.local_id);
    puntos.add(valor.punto_id);
    secuencias.add(valor.secuencia);
    lecturas.push(valor);
  }
  lecturas.sort((a, b) => a.secuencia - b.secuencia);

  return {
    ok: true,
    valor: {
      local_id: rondin.local_id.trim().toLowerCase(),
      sitio_id: rondin.sitio_id.trim().toLowerCase(),
      ruta_id: rondin.ruta_id.trim().toLowerCase(),
      turno_id: turnoId,
      ...(rondin.turno_fecha ? { turno_fecha: rondin.turno_fecha } : {}),
      device_id: deviceId,
      iniciado_at_dispositivo: rondin.iniciado_at_dispositivo,
      iniciado_monotonic_ms: rondin.iniciado_monotonic_ms,
      finalizado_at_dispositivo: rondin.finalizado_at_dispositivo ?? null,
      ...(rondin.finalizado_monotonic_ms !== undefined &&
          rondin.finalizado_monotonic_ms !== null
        ? { finalizado_monotonic_ms: rondin.finalizado_monotonic_ms }
        : {}),
      lecturas,
    },
  };
}

export async function validarLoteRondines(cuerpo) {
  if (!objeto(cuerpo) || !Array.isArray(cuerpo.rondines)) {
    return fallo("JSON_INVALIDO", "Envía un arreglo rondines.");
  }
  if (cuerpo.rondines.length < 1 || cuerpo.rondines.length > 20) {
    return fallo("LOTE_INVALIDO", "El lote debe contener de 1 a 20 rondines.");
  }

  const rondines = [];
  const locales = new Set();
  let totalLecturas = 0;
  for (const rondin of cuerpo.rondines) {
    const validacion = await validarRondin(rondin);
    if (!validacion.ok) return validacion;
    if (locales.has(validacion.valor.local_id)) {
      return fallo("RONDIN_DUPLICADO", "El lote repite un local_id de rondín.");
    }
    locales.add(validacion.valor.local_id);
    totalLecturas += validacion.valor.lecturas.length;
    if (totalLecturas > 500) {
      return fallo("LOTE_MUY_GRANDE", "El lote supera 500 lecturas.");
    }
    rondines.push(validacion.valor);
  }
  return { ok: true, rondines };
}

export const patronesRondin = Object.freeze({ UUID_RE, HASH_RE, TOKEN_QR_RE });
