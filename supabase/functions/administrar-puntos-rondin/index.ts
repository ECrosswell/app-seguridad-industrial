import { createClient } from "jsr:@supabase/supabase-js@2";

import { validarAccionAdmin } from "../_shared/rondines_validation.mjs";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Max-Age": "86400",
  Vary: "Origin",
};

function json(cuerpo: unknown, status = 200): Response {
  return new Response(JSON.stringify(cuerpo), {
    status,
    headers: {
      ...corsHeaders,
      "Cache-Control": "no-store",
      "Content-Type": "application/json; charset=utf-8",
    },
  });
}

function errorRpc(error: { code?: string; message?: string }): Response {
  const codigo = error.code ?? "ERROR_ADMIN_RONDIN";
  const mensajesPermitidos = new Set([
    "ADMIN_NO_AUTORIZADO",
    "DATOS_INVALIDOS",
    "SITIO_INVALIDO",
    "SECCION_INVALIDA",
    "SECCION_NO_ENCONTRADA",
    "WIFI_INVALIDO",
    "PUNTO_NO_ENCONTRADO",
    "CODIGO_NO_ENCONTRADO",
    "CODIGO_INCONSISTENTE",
    "NO_SE_PUEDE_MOVER_EL_PUNTO_DE_SITIO",
    "ORDEN_O_NOMBRE_DUPLICADO",
    "ACCION_NO_PERMITIDA",
    "RONDIN_INVALIDO",
    "RONDIN_NO_ENCONTRADO",
    "DECISION_INVALIDA",
    "MOTIVO_INVALIDO",
    "MOTIVO_REQUERIDO",
    "MOTIVO_DEMASIADO_LARGO",
  ]);
  const mensaje = mensajesPermitidos.has(error.message ?? "")
    ? error.message
    : "No se pudo completar la operación de rondines.";
  const status = codigo === "42501"
    ? 403
    : codigo === "P0002"
    ? 404
    : codigo === "23505"
    ? 409
    : codigo === "22023"
    ? 400
    : 500;
  return json({ error: mensaje, codigo }, status);
}

Deno.serve(async (peticion) => {
  if (peticion.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }
  if (peticion.method !== "POST") {
    return json({ error: "Método no permitido.", codigo: "METODO_NO_PERMITIDO" }, 405);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return json(
      { error: "La función no está configurada.", codigo: "CONFIGURACION_INCOMPLETA" },
      500,
    );
  }

  const authorization = peticion.headers.get("Authorization") ?? "";
  if (!authorization.startsWith("Bearer ")) {
    return json({ error: "Inicia sesión nuevamente.", codigo: "SIN_SESION" }, 401);
  }
  const token = authorization.slice("Bearer ".length).trim();
  const supabase = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
  const { data: authData, error: authError } = await supabase.auth.getUser(token);
  if (authError || !authData.user) {
    return json({ error: "La sesión no es válida.", codigo: "SESION_INVALIDA" }, 401);
  }

  const actorId = authData.user.id;
  const { data: perfil, error: perfilError } = await supabase
    .from("profiles")
    .select("id, rol, activo, debe_cambiar_password")
    .eq("id", actorId)
    .maybeSingle();
  if (perfilError) {
    return json(
      { error: "No se pudo validar la cuenta.", codigo: "VALIDACION_USUARIO" },
      500,
    );
  }
  if (!perfil || perfil.activo !== true || perfil.rol !== "admin" ||
    perfil.debe_cambiar_password === true) {
    return json(
      { error: "No tienes autorización administrativa.", codigo: "NO_AUTORIZADO" },
      403,
    );
  }

  let cuerpo: unknown;
  try {
    cuerpo = await peticion.json();
  } catch (_error) {
    return json({ error: "El JSON no es válido.", codigo: "JSON_INVALIDO" }, 400);
  }
  const validacion = validarAccionAdmin(cuerpo);
  if (!validacion.ok) {
    return json({ error: validacion.error, codigo: validacion.codigo }, 400);
  }

  const { data, error } = await supabase.rpc("administrar_punto_rondin_servidor", {
    p_actor_id: actorId,
    p_accion: validacion.accion,
    p_datos: validacion.datos,
  });
  if (error) return errorRpc(error);
  return json(data, validacion.accion === "crear_punto" ? 201 : 200);
});
