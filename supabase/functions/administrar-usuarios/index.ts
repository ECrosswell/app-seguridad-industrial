import { createClient } from "jsr:@supabase/supabase-js@2";

import {
  ROLES_ADMINISTRABLES,
  validarAltaUsuario,
  validarCambioPropio,
  validarRestablecimiento,
} from "../_shared/admin_user_validation.mjs";

// El proyecto aún no genera tipos de Database; el cliente conserva el esquema
// dinámico de Supabase y se valida cada payload antes de usarlo.
// deno-lint-ignore no-explicit-any
type SupabaseAdmin = ReturnType<typeof createClient<any>>;

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

async function crearAuditoria(
  supabase: SupabaseAdmin,
  actorId: string,
  accion: "CREAR_USUARIO" | "RESTABLECER_PASSWORD",
  targetId?: string,
  rolObjetivo?: string,
): Promise<string | null> {
  const { data, error } = await supabase
    .from("admin_usuario_auditoria")
    .insert({
      actor_id: actorId,
      target_id: targetId ?? null,
      accion,
      estado: "pendiente",
      rol_objetivo: rolObjetivo ?? null,
    })
    .select("id")
    .single();

  if (error) return null;
  return data.id as string;
}

async function finalizarAuditoria(
  supabase: SupabaseAdmin,
  auditoriaId: string,
  estado: "exito" | "error",
  opciones: { targetId?: string; codigoError?: string } = {},
): Promise<void> {
  const cambios: Record<string, unknown> = {
    estado,
    completed_at: new Date().toISOString(),
  };
  if (opciones.targetId !== undefined) {
    cambios.target_id = opciones.targetId;
  }
  if (opciones.codigoError !== undefined) {
    cambios.codigo_error = opciones.codigoError;
  }

  const { error } = await supabase
    .from("admin_usuario_auditoria")
    .update(cambios)
    .eq("id", auditoriaId);

  if (error) {
    console.error("ADMIN_USERS_AUDIT_FINALIZE_FAILED", auditoriaId);
  }
}

function esCorreoDuplicado(
  error: { code?: string; message?: string },
): boolean {
  const codigo = error.code?.toLowerCase() ?? "";
  const mensaje = error.message?.toLowerCase() ?? "";
  return codigo === "email_exists" ||
    codigo === "user_already_exists" ||
    mensaje.includes("already registered") ||
    mensaje.includes("already exists");
}

Deno.serve(async (peticion) => {
  if (peticion.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }
  if (peticion.method !== "POST") {
    return json({
      error: "Método no permitido.",
      codigo: "METODO_NO_PERMITIDO",
    }, 405);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !anonKey || !serviceRoleKey) {
    return json({
      error: "La función no está configurada.",
      codigo: "CONFIGURACION_INCOMPLETA",
    }, 500);
  }

  const authorization = peticion.headers.get("Authorization") ?? "";
  if (!authorization.startsWith("Bearer ")) {
    return json(
      { error: "Inicia sesión nuevamente.", codigo: "SIN_SESION" },
      401,
    );
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const token = authorization.slice("Bearer ".length).trim();
  const { data: authData, error: authError } = await supabase.auth.getUser(
    token,
  );
  if (authError || !authData.user) {
    return json(
      { error: "La sesión no es válida.", codigo: "SESION_INVALIDA" },
      401,
    );
  }

  const actorId = authData.user.id;
  const { data: actor, error: actorError } = await supabase
    .from("profiles")
    .select("id, rol, activo, debe_cambiar_password")
    .eq("id", actorId)
    .maybeSingle();

  if (actorError) {
    return json({
      error: "No se pudo validar la cuenta.",
      codigo: "VALIDACION_USUARIO",
    }, 500);
  }
  if (!actor || actor.activo !== true) {
    return json({
      error: "La cuenta no está disponible.",
      codigo: "CUENTA_NO_DISPONIBLE",
    }, 403);
  }

  let cuerpo: Record<string, unknown>;
  try {
    cuerpo = await peticion.json();
  } catch (_error) {
    return json({
      error: "La solicitud no contiene JSON válido.",
      codigo: "JSON_INVALIDO",
    }, 400);
  }

  try {
    if (cuerpo.accion === "cambiar_password_propio") {
      const validacion = validarCambioPropio(cuerpo);
      if (!("valor" in validacion)) {
        return json(
          { error: validacion.error, codigo: validacion.codigo },
          400,
        );
      }

      const supabaseUsuario = createClient(supabaseUrl, anonKey, {
        auth: { autoRefreshToken: false, persistSession: false },
        global: { headers: { Authorization: authorization } },
      });
      const { data: sesionValida, error: sesionError } = await supabaseUsuario
        .rpc("sesion_actual_valida_para_cambio_password");
      if (sesionError || sesionValida !== true) {
        return json({
          error:
            "Cierra sesión e ingresa con la contraseña temporal más reciente.",
          codigo: "SESION_ANTERIOR_AL_RESTABLECIMIENTO",
        }, 403);
      }

      const { error: passwordError } = await supabase.auth.admin.updateUserById(
        actorId,
        { password: validacion.valor.passwordNueva },
      );
      if (passwordError) {
        return json({
          error: "No se pudo cambiar la contraseña.",
          codigo: "AUTH_PASSWORD",
        }, 500);
      }

      const { error: perfilError } = await supabase
        .from("profiles")
        .update({
          debe_cambiar_password: false,
          password_cambio_requerido_at: null,
        })
        .eq("id", actorId);
      if (perfilError) {
        return json({
          error:
            "La contraseña cambió, pero debes intentar confirmar el acceso otra vez.",
          codigo: "PERFIL_PASSWORD",
        }, 500);
      }

      return json({ ok: true });
    }

    if (
      actor.rol !== "admin" ||
      actor.debe_cambiar_password === true
    ) {
      return json({
        error: "No tienes permiso para administrar usuarios.",
        codigo: "NO_AUTORIZADO",
      }, 403);
    }

    if (cuerpo.accion === "crear") {
      const validacion = validarAltaUsuario(cuerpo);
      if (!("valor" in validacion)) {
        return json(
          { error: validacion.error, codigo: validacion.codigo },
          400,
        );
      }
      const datos = validacion.valor;

      const { data: sitio, error: sitioError } = await supabase
        .from("sitios")
        .select("id")
        .eq("id", datos.sitioId)
        .eq("activo", true)
        .maybeSingle();
      if (sitioError) {
        return json({
          error: "No se pudo validar el sitio.",
          codigo: "VALIDACION_SITIO",
        }, 500);
      }
      if (!sitio) {
        return json({
          error: "El sitio no existe o está inactivo.",
          codigo: "SITIO_NO_DISPONIBLE",
        }, 409);
      }

      const auditoriaId = await crearAuditoria(
        supabase,
        actorId,
        "CREAR_USUARIO",
        undefined,
        datos.rol,
      );
      if (!auditoriaId) {
        return json({
          error: "No se pudo iniciar la auditoría.",
          codigo: "AUDITORIA_NO_DISPONIBLE",
        }, 500);
      }

      const { data: usuarioCreado, error: crearError } = await supabase.auth
        .admin.createUser({
          email: datos.correo,
          password: datos.passwordTemporal,
          email_confirm: true,
          user_metadata: {
            nombre_completo: datos.nombreCompleto,
            telefono_whatsapp: datos.telefonoWhatsapp,
          },
          app_metadata: {
            rol: datos.rol,
            provisionado_por_admin: true,
          },
        });

      if (crearError || !usuarioCreado.user) {
        const codigo = crearError && esCorreoDuplicado(crearError)
          ? "CORREO_DUPLICADO"
          : "AUTH_CREAR_USUARIO";
        await finalizarAuditoria(supabase, auditoriaId, "error", {
          codigoError: codigo,
        });
        return json({
          error: codigo === "CORREO_DUPLICADO"
            ? "Ya existe una cuenta con ese correo."
            : "No se pudo crear la cuenta.",
          codigo,
        }, codigo === "CORREO_DUPLICADO" ? 409 : 500);
      }

      const usuarioId = usuarioCreado.user.id;
      const { data: perfilCreado, error: perfilError } = await supabase
        .from("profiles")
        .select("id")
        .eq("id", usuarioId)
        .maybeSingle();

      const { error: sitioUsuarioError } = perfilError || !perfilCreado
        ? { error: null }
        : await supabase.from("usuario_sitios").upsert({
          usuario_id: usuarioId,
          sitio_id: datos.sitioId,
          es_principal: true,
        });

      const { error: activarError } = perfilError || !perfilCreado ||
          sitioUsuarioError
        ? { error: null }
        : await supabase
          .from("profiles")
          .update({ activo: true })
          .eq("id", usuarioId);

      if (perfilError || !perfilCreado || sitioUsuarioError || activarError) {
        const { error: rollbackError } = await supabase.auth.admin.deleteUser(
          usuarioId,
        );
        const codigoFallo = perfilError || !perfilCreado
          ? "PERFIL_NO_CREADO"
          : sitioUsuarioError
          ? "SITIO_NO_ASIGNADO"
          : "PERFIL_NO_ACTIVADO";
        if (rollbackError) {
          console.error("ADMIN_USERS_CREATE_ROLLBACK_FAILED", usuarioId);
          await finalizarAuditoria(supabase, auditoriaId, "error", {
            targetId: usuarioId,
            codigoError: "ALTA_ROLLBACK_FALLIDO",
          });
          return json({
            error:
              "No se completó el alta. La cuenta quedó bloqueada y requiere revisión.",
            codigo: "ALTA_ROLLBACK_FALLIDO",
          }, 500);
        }
        await finalizarAuditoria(supabase, auditoriaId, "error", {
          targetId: usuarioId,
          codigoError: codigoFallo,
        });
        return json({
          error: "No se pudo completar el alta; los cambios se revirtieron.",
          codigo: "ALTA_INCOMPLETA",
        }, 500);
      }

      await finalizarAuditoria(supabase, auditoriaId, "exito", {
        targetId: usuarioId,
      });
      return json({ ok: true, usuario_id: usuarioId }, 201);
    }

    if (cuerpo.accion === "restablecer_password") {
      const validacion = validarRestablecimiento(cuerpo);
      if (!("valor" in validacion)) {
        return json(
          { error: validacion.error, codigo: validacion.codigo },
          400,
        );
      }
      const datos = validacion.valor;
      if (datos.usuarioId === actorId) {
        return json({
          error:
            "Usa la opción de tu perfil para cambiar tu propia contraseña.",
          codigo: "USUARIO_ACTUAL",
        }, 403);
      }

      const { data: objetivo, error: objetivoError } = await supabase
        .from("profiles")
        .select(
          "id, rol, activo, debe_cambiar_password, password_cambio_requerido_at",
        )
        .eq("id", datos.usuarioId)
        .maybeSingle();
      if (objetivoError) {
        return json({
          error: "No se pudo consultar el usuario.",
          codigo: "VALIDACION_USUARIO",
        }, 500);
      }
      if (!objetivo) {
        return json({
          error: "El usuario no existe.",
          codigo: "USUARIO_NO_ENCONTRADO",
        }, 404);
      }
      if (!ROLES_ADMINISTRABLES.includes(objetivo.rol)) {
        return json({
          error: "No se puede modificar una cuenta administradora.",
          codigo: "ROL_PROTEGIDO",
        }, 403);
      }
      if (objetivo.activo !== true) {
        return json({
          error: "Reingresa al usuario antes de cambiar su contraseña.",
          codigo: "USUARIO_INACTIVO",
        }, 409);
      }

      const auditoriaId = await crearAuditoria(
        supabase,
        actorId,
        "RESTABLECER_PASSWORD",
        datos.usuarioId,
        objetivo.rol,
      );
      if (!auditoriaId) {
        return json({
          error: "No se pudo iniciar la auditoría.",
          codigo: "AUDITORIA_NO_DISPONIBLE",
        }, 500);
      }

      const banderaAnterior = objetivo.debe_cambiar_password === true;
      const marcadorAnterior = objetivo.password_cambio_requerido_at ?? null;
      const { error: banderaError } = await supabase
        .from("profiles")
        .update({
          debe_cambiar_password: true,
          password_cambio_requerido_at: new Date().toISOString(),
        })
        .eq("id", datos.usuarioId);
      if (banderaError) {
        await finalizarAuditoria(supabase, auditoriaId, "error", {
          codigoError: "BANDERA_PASSWORD",
        });
        return json({
          error: "No se pudo preparar el cambio de contraseña.",
          codigo: "BANDERA_PASSWORD",
        }, 500);
      }

      const { error: passwordError } = await supabase.auth.admin.updateUserById(
        datos.usuarioId,
        { password: datos.passwordTemporal },
      );
      if (passwordError) {
        await supabase
          .from("profiles")
          .update({
            debe_cambiar_password: banderaAnterior,
            password_cambio_requerido_at: marcadorAnterior,
          })
          .eq("id", datos.usuarioId);
        await finalizarAuditoria(supabase, auditoriaId, "error", {
          codigoError: "AUTH_PASSWORD",
        });
        return json({
          error: "No se pudo restablecer la contraseña.",
          codigo: "AUTH_PASSWORD",
        }, 500);
      }

      await finalizarAuditoria(supabase, auditoriaId, "exito");
      return json({ ok: true });
    }

    return json({
      error: "Acción no permitida.",
      codigo: "ACCION_NO_PERMITIDA",
    }, 400);
  } catch (_error) {
    return json({
      error: "No se pudo completar la operación.",
      codigo: "ERROR_INTERNO",
    }, 500);
  }
});
