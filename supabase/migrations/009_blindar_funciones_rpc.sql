-- ─────────────────────────────────────────────────────────────────────────────
-- 009: Blindaje de funciones expuestas como RPC.
--
-- Supabase publica automáticamente TODA función del esquema `public` como
-- endpoint REST en `/rest/v1/rpc/<nombre>`. Las migraciones 001–008 dejaron
-- expuestas funciones `SECURITY DEFINER` que corren con privilegios elevados.
--
-- El agujero concreto que esto cierra:
--   · `notificar_rol` / `notificar_usuario` insertan notificaciones con
--     privilegios de superusuario y no validan quién las llama — se escribieron
--     asumiendo que sólo las invocarían los triggers. Expuestas, cualquiera
--     (incluso sin sesión) podía falsificarle al administrador una alerta de
--     "relevo no llegó" o mandar notificaciones de phishing.
--   · `marcar_identificaciones_vencidas` purga datos. Expuesta, cualquiera
--     podía forzar el borrado anticipado de las identificaciones.
--
-- Revocar EXECUTE no rompe nada: Postgres NO verifica ese privilegio al
-- disparar un trigger, y pg_cron ejecuta sus jobs como el dueño del job.
-- ─────────────────────────────────────────────────────────────────────────────

-- ─── 1. search_path fijo ─────────────────────────────────────────────────────
-- Una función sin `search_path` fijo puede ser secuestrada: quien controle el
-- search_path de la sesión hace que resuelva a otra función con el mismo nombre.

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create or replace function public.uuid_seguro(p_texto text)
returns uuid
language plpgsql
immutable
set search_path = public, pg_temp
as $$
begin
  return p_texto::uuid;
exception when others then
  return null;
end;
$$;

-- ─── 2. Cerrar todo lo que no debe ser invocable desde el cliente ────────────

do $$
declare
  v_fn text;
  v_privadas text[] := array[
    -- Funciones de trigger
    'public.set_updated_at()',
    'public.handle_new_user()',
    'public.proteger_campos_perfil()',
    'public.procesar_asistencia()',
    'public.sincronizar_turno()',
    'public.preparar_registro_acceso()',
    'public.actualizar_visitante_recurrente()',
    'public.preparar_evento_bitacora()',
    'public.preparar_recepcion_turno()',
    'public.evaluar_novedades_recepcion()',
    'public.alertar_novedad_equipo()',
    'public.alertar_solicitud_cliente()',
    'public.alertar_solicitud_respondida()',
    'public.alertar_asistencia_revision()',
    -- Emisores de notificaciones
    'public.notificar_usuario(uuid, text, text, text, text, uuid, text, uuid, jsonb)',
    'public.notificar_rol(public.rol_usuario, text, text, text, text, uuid, text, uuid, jsonb)',
    -- Rutinas de cron
    'public.detectar_relevo_no_llego()',
    'public.detectar_salidas_pendientes()',
    'public.marcar_identificaciones_vencidas()',
    -- Utilitaria interna
    'public.uuid_seguro(text)'
  ];
begin
  foreach v_fn in array v_privadas loop
    execute format('revoke all on function %s from public, anon, authenticated', v_fn);
  end loop;
end $$;

-- ─── 3. Helpers de RLS ───────────────────────────────────────────────────────
-- Estos se quedan disponibles para `authenticated`: las policies los invocan al
-- evaluarse. Sólo revelan información del propio llamante (su rol, sus sitios),
-- así que exponerlos no filtra nada. Al rol `anon` no le sirven de nada.

revoke all on function public.rol_actual()                   from public, anon;
revoke all on function public.es_admin()                     from public, anon;
revoke all on function public.tiene_acceso_sitio(uuid)       from public, anon;
revoke all on function public.fecha_turno(timestamptz, uuid) from public, anon;

grant execute on function public.rol_actual()                   to authenticated;
grant execute on function public.es_admin()                     to authenticated;
grant execute on function public.tiene_acceso_sitio(uuid)       to authenticated;
grant execute on function public.fecha_turno(timestamptz, uuid) to authenticated;
