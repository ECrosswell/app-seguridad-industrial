import { createClient } from "jsr:@supabase/supabase-js@2";

import { validarLoteRondines } from "../_shared/rondines_validation.mjs";

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

function statusRpc(codigo?: string): number {
  if (codigo === "42501") return 403;
  if (codigo === "23505") return 409;
  if (codigo === "22023") return 400;
  return 500;
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

  const usuarioId = authData.user.id;
  const { data: perfil, error: perfilError } = await supabase
    .from("profiles")
    .select("id, rol, activo, estado_laboral, debe_cambiar_password")
    .eq("id", usuarioId)
    .maybeSingle();
  if (perfilError) {
    return json(
      { error: "No se pudo validar la cuenta.", codigo: "VALIDACION_USUARIO" },
      500,
    );
  }
  const rolesOperativos = new Set(["elemento", "supervisor", "admin"]);
  if (!perfil || perfil.activo !== true ||
    !["activo", "reingreso"].includes(perfil.estado_laboral) ||
    !rolesOperativos.has(perfil.rol) || perfil.debe_cambiar_password === true) {
    return json(
      { error: "La cuenta no puede sincronizar rondines.", codigo: "NO_AUTORIZADO" },
      403,
    );
  }

  let cuerpo: unknown;
  try {
    cuerpo = await peticion.json();
  } catch (_error) {
    return json({ error: "El JSON no es válido.", codigo: "JSON_INVALIDO" }, 400);
  }
  const validacion = await validarLoteRondines(cuerpo);
  if (!validacion.ok) {
    return json({ error: validacion.error, codigo: validacion.codigo }, 400);
  }

  const resultados: unknown[] = [];
  for (const rondin of validacion.rondines) {
    const { data, error } = await supabase.rpc("sincronizar_rondin_servidor", {
      p_usuario_id: usuarioId,
      p_rondin: rondin,
    });
    if (error) {
      // No se devuelve SQL ni datos parciales. Si una ronda anterior del lote ya
      // quedó guardada, el reintento completo es seguro por local_id + payload.
      const conocidos = new Set([
        "PERFIL_NO_AUTORIZADO",
        "SITIO_NO_AUTORIZADO",
        "SITIO_INVALIDO",
        "IDEMPOTENCIA_CONFLICTO",
        "LECTURA_DUPLICADA",
        "LECTURA_MALFORMADA",
      ]);
      const mensaje = conocidos.has(error.message ?? "")
        ? error.message
        : "No se pudo sincronizar el rondín.";
      return json({
        error: mensaje,
        codigo: error.code ?? "SINCRONIZACION_FALLIDA",
        local_id: rondin.local_id,
      }, statusRpc(error.code));
    }
    resultados.push(data);
  }

  return json({ resultados });
});
