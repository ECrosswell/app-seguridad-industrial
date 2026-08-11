-- Correccion incremental posterior a 20260811183434_rondines_qr_offline.
--
-- 1. El verificador SHA-256 del QR deja de ser parte del catalogo visible.
-- 2. Ninguna señal producida por el telefono basta para auto-validar una ronda
--    mientras no exista firma de dispositivo + atestacion verificable.

revoke all privileges on table public.puntos_rondin
  from public, anon, authenticated;
revoke select (token_hash) on table public.puntos_rondin
  from public, anon, authenticated;

grant select (
  id,
  sitio_id,
  seccion_id,
  nombre,
  descripcion,
  lat,
  lng,
  radio_metros,
  wifi_ap_id,
  requiere_liveness,
  activo,
  qr_version,
  created_at,
  updated_at
) on public.puntos_rondin to authenticated;

-- Revision administrativa append-only. La evidencia tecnica permanece intacta;
-- la ultima fila por (created_at desc, id desc) es el veredicto vigente.
create table if not exists public.rondin_revisiones (
  id          uuid primary key default gen_random_uuid(),
  rondin_id   uuid not null references public.rondines(id) on delete restrict,
  actor_id    uuid not null references public.profiles(id) on delete restrict,
  decision    text not null check (decision in ('aprobado', 'rechazado')),
  motivo      text not null default '',
  created_at  timestamptz not null default now(),
  constraint rondin_revisiones_motivo_valido check (
    char_length(motivo) <= 2000
    and (decision = 'aprobado' or motivo ~ '[^[:space:]]')
  )
);

create index if not exists idx_rondin_revisiones_vigente
  on public.rondin_revisiones (rondin_id, created_at desc, id desc);
create index if not exists idx_rondin_revisiones_actor
  on public.rondin_revisiones (actor_id, created_at desc);

alter table public.rondin_revisiones enable row level security;

drop policy if exists rondin_revisiones_select_admin on public.rondin_revisiones;
create policy rondin_revisiones_select_admin on public.rondin_revisiones
  for select to authenticated
  using ((select public.es_admin()));

drop policy if exists password_temporal_gate on public.rondin_revisiones;
create policy password_temporal_gate on public.rondin_revisiones as restrictive
  for all to authenticated
  using ((select public.sesion_operativa_habilitada()))
  with check ((select public.sesion_operativa_habilitada()));

revoke all privileges on table public.rondin_revisiones
  from public, anon, authenticated, service_role;
grant select on table public.rondin_revisiones to authenticated;

drop trigger if exists rondin_revisiones_inmutables on public.rondin_revisiones;
create trigger rondin_revisiones_inmutables
  before update or delete on public.rondin_revisiones
  for each row execute function private.bloquear_mutacion_rondin();

alter table public.admin_rondin_auditoria
  drop constraint if exists admin_rondin_auditoria_accion_check;
alter table public.admin_rondin_auditoria
  add constraint admin_rondin_auditoria_accion_check
  check (accion in (
    'CREAR_PUNTO',
    'ACTUALIZAR_PUNTO',
    'ROTAR_CODIGO',
    'OBTENER_CODIGO',
    'CREAR_SECCION',
    'ACTUALIZAR_SECCION',
    'REVISAR_RONDIN'
  ));

create or replace function private.revisar_rondin_servidor(
  p_actor_id uuid,
  p_datos jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, public, private, pg_temp
as $$
declare
  v_rondin_id uuid;
  v_decision text;
  v_motivo text;
  v_revision jsonb;
  v_revision_id uuid;
begin
  if not exists (
    select 1
    from public.profiles p
    where p.id = p_actor_id
      and p.rol = 'admin'
      and p.activo = true
      and p.debe_cambiar_password = false
  ) then
    raise exception using errcode = '42501', message = 'ADMIN_NO_AUTORIZADO';
  end if;
  if jsonb_typeof(coalesce(p_datos, '{}'::jsonb)) <> 'object' then
    raise exception using errcode = '22023', message = 'DATOS_INVALIDOS';
  end if;
  if jsonb_typeof(p_datos -> 'decision') is distinct from 'string' then
    raise exception using errcode = '22023', message = 'DECISION_INVALIDA';
  end if;
  if p_datos ? 'motivo'
     and jsonb_typeof(p_datos -> 'motivo') not in ('string', 'null') then
    raise exception using errcode = '22023', message = 'MOTIVO_INVALIDO';
  end if;

  v_rondin_id := public.uuid_seguro(p_datos ->> 'rondin_id');
  v_decision := coalesce(p_datos ->> 'decision', '');
  v_motivo := regexp_replace(
    coalesce(p_datos ->> 'motivo', ''),
    '^[[:space:]]+|[[:space:]]+$',
    '',
    'g'
  );
  if v_rondin_id is null then
    raise exception using errcode = '22023', message = 'RONDIN_INVALIDO';
  end if;
  if v_decision not in ('aprobado', 'rechazado') then
    raise exception using errcode = '22023', message = 'DECISION_INVALIDA';
  end if;
  if char_length(v_motivo) > 2000 then
    raise exception using errcode = '22023', message = 'MOTIVO_DEMASIADO_LARGO';
  end if;
  if v_decision = 'rechazado' and v_motivo = '' then
    raise exception using errcode = '22023', message = 'MOTIVO_REQUERIDO';
  end if;
  if not exists (select 1 from public.rondines where id = v_rondin_id) then
    raise exception using errcode = 'P0002', message = 'RONDIN_NO_ENCONTRADO';
  end if;

  insert into public.rondin_revisiones (
    rondin_id,
    actor_id,
    decision,
    motivo
  ) values (
    v_rondin_id,
    p_actor_id,
    v_decision,
    v_motivo
  )
  returning id, to_jsonb(rondin_revisiones.*)
    into v_revision_id, v_revision;

  insert into public.admin_rondin_auditoria (
    actor_id,
    accion,
    metadata
  ) values (
    p_actor_id,
    'REVISAR_RONDIN',
    jsonb_build_object(
      'rondin_id', v_rondin_id,
      'revision_id', v_revision_id,
      'decision', v_decision
    )
  );

  return jsonb_build_object('revision', v_revision);
end;
$$;

revoke all on function private.revisar_rondin_servidor(uuid, jsonb)
  from public, anon, authenticated, service_role;
grant execute on function private.revisar_rondin_servidor(uuid, jsonb)
  to service_role;

-- Defensa adicional: incluso las respuestas administrativas omiten el hash.
-- El payload RAW solo se devuelve al admin en crear/rotar/obtener para poder
-- imprimir la placa; nunca aparece al listar el catalogo.
create or replace function public.administrar_punto_rondin_servidor(
  p_actor_id uuid,
  p_accion text,
  p_datos jsonb default '{}'::jsonb
)
returns jsonb
language sql
set search_path = pg_catalog, private, pg_temp
as $$
  with resultado as (
    select case
      when p_accion = 'revisar_rondin' then
        private.revisar_rondin_servidor(p_actor_id, p_datos)
      else private.administrar_punto_rondin_servidor(
        p_actor_id,
        p_accion,
        p_datos
      )
    end as valor
  )
  select case
    when valor ? 'punto' then jsonb_set(
      valor,
      '{punto}',
      coalesce(valor -> 'punto', '{}'::jsonb) - 'token_hash'
    )
    when valor ? 'puntos' then jsonb_set(
      valor,
      '{puntos}',
      coalesce((
        select jsonb_agg(item - 'token_hash')
        from jsonb_array_elements(valor -> 'puntos') item
      ), '[]'::jsonb)
    )
    else valor
  end
  from resultado;
$$;

revoke all on function public.administrar_punto_rondin_servidor(uuid, text, jsonb)
  from public, anon, authenticated;
grant execute on function public.administrar_punto_rondin_servidor(uuid, text, jsonb)
  to service_role;

create or replace function private.forzar_revision_dispositivo_no_atestado()
returns trigger
language plpgsql
set search_path = pg_catalog, private, pg_temp
as $$
begin
  if not coalesce(
    'DISPOSITIVO_NO_ATESTADO' = any(coalesce(new.codigos_riesgo, '{}'::text[])),
    false
  ) then
    new.codigos_riesgo := array_append(
      coalesce(new.codigos_riesgo, '{}'::text[]),
      'DISPOSITIVO_NO_ATESTADO'
    );
  end if;
  new.puntaje_riesgo := greatest(coalesce(new.puntaje_riesgo, 0), 35);
  if new.estado_validacion = 'validado' then
    new.estado_validacion := 'pendiente_revision';
  end if;
  return new;
end;
$$;

drop trigger if exists rondines_exigir_atestacion on public.rondines;
create trigger rondines_exigir_atestacion
  before insert on public.rondines
  for each row execute function private.forzar_revision_dispositivo_no_atestado();

drop trigger if exists rondin_lecturas_exigir_atestacion on public.rondin_lecturas;
create trigger rondin_lecturas_exigir_atestacion
  before insert on public.rondin_lecturas
  for each row execute function private.forzar_revision_dispositivo_no_atestado();

revoke all on function private.forzar_revision_dispositivo_no_atestado()
  from public, anon, authenticated, service_role;

-- Corrige filas creadas en la ventana entre ambas migraciones. Se deshabilita
-- unicamente el guard de inmutabilidad y todo ocurre dentro de la transaccion
-- de migracion; ante cualquier error los triggers y datos hacen rollback.
alter table public.rondines disable trigger rondines_inmutables;
update public.rondines
set estado_validacion = case
      when estado_validacion = 'validado' then 'pendiente_revision'
      else estado_validacion
    end,
    puntaje_riesgo = greatest(puntaje_riesgo, 35),
    codigos_riesgo = case
      when 'DISPOSITIVO_NO_ATESTADO' = any(codigos_riesgo) then codigos_riesgo
      else array_append(codigos_riesgo, 'DISPOSITIVO_NO_ATESTADO')
    end
where estado_validacion = 'validado'
   or puntaje_riesgo < 35
   or not coalesce('DISPOSITIVO_NO_ATESTADO' = any(codigos_riesgo), false);
alter table public.rondines enable trigger rondines_inmutables;

alter table public.rondin_lecturas disable trigger rondin_lecturas_inmutables;
update public.rondin_lecturas
set estado_validacion = case
      when estado_validacion = 'validado' then 'pendiente_revision'
      else estado_validacion
    end,
    puntaje_riesgo = greatest(puntaje_riesgo, 35),
    codigos_riesgo = case
      when 'DISPOSITIVO_NO_ATESTADO' = any(codigos_riesgo) then codigos_riesgo
      else array_append(codigos_riesgo, 'DISPOSITIVO_NO_ATESTADO')
    end
where estado_validacion = 'validado'
   or puntaje_riesgo < 35
   or not coalesce('DISPOSITIVO_NO_ATESTADO' = any(codigos_riesgo), false);
alter table public.rondin_lecturas enable trigger rondin_lecturas_inmutables;
