-- Gestion segura de altas y restablecimientos administrativos de usuarios.
--
-- Dos defensas son deliberadamente independientes:
--   1. Auth debe tener deshabilitado el registro publico.
--   2. Este trigger rechaza cualquier alta que no venga marcada por la Admin
--      API. Asi, una configuracion accidental de Auth no permite escalar rol
--      mediante raw_user_meta_data.

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

alter table public.profiles
  add column if not exists password_cambio_requerido_at timestamptz;

update public.profiles
set password_cambio_requerido_at = coalesce(password_cambio_requerido_at, now())
where debe_cambiar_password = true;

-- La bandera de cambio obligatorio es una frontera de autorizacion, no solo
-- una redireccion de la interfaz. Los helpers RLS niegan toda operacion hasta
-- que una sesion posterior al restablecimiento cambie la contrasena.
create or replace function public.sesion_operativa_habilitada()
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and activo = true
      and debe_cambiar_password = false
  );
$$;

create or replace function public.rol_actual()
returns public.rol_usuario
language sql
stable
security definer
set search_path = pg_catalog, public, pg_temp
as $$
  select rol
  from public.profiles
  where id = auth.uid()
    and activo = true
    and debe_cambiar_password = false;
$$;

create or replace function public.es_admin()
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and rol = 'admin'
      and activo = true
      and debe_cambiar_password = false
  );
$$;

create or replace function public.tiene_acceso_sitio(p_sitio_id uuid)
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public, pg_temp
as $$
  select public.sesion_operativa_habilitada()
    and (
      public.es_admin()
      or exists (
        select 1
        from public.usuario_sitios
        where usuario_id = auth.uid()
          and sitio_id = p_sitio_id
      )
    );
$$;

-- Solo una sesion creada despues del ultimo alta/restablecimiento puede
-- levantar la bandera. Esto invalida de inmediato los JWT de sesiones viejas
-- para este flujo, aunque aun no hayan llegado a su expiracion.
create or replace function public.sesion_actual_valida_para_cambio_password()
returns boolean
language sql
stable
security definer
set search_path = pg_catalog, public, auth, pg_temp
as $$
  select exists (
    select 1
    from public.profiles p
    join auth.sessions s
      on s.id = nullif(auth.jwt() ->> 'session_id', '')::uuid
     and s.user_id = p.id
    where p.id = auth.uid()
      and p.activo = true
      and (
        p.debe_cambiar_password = false
        or (
          p.password_cambio_requerido_at is not null
          and s.created_at >= p.password_cambio_requerido_at
        )
      )
  );
$$;

revoke all on function public.sesion_operativa_habilitada() from public, anon;
revoke all on function public.sesion_actual_valida_para_cambio_password()
  from public, anon;
grant execute on function public.sesion_operativa_habilitada()
  to authenticated;
grant execute on function public.sesion_actual_valida_para_cambio_password()
  to authenticated;

drop policy if exists profiles_update_self on public.profiles;
create policy profiles_update_self on public.profiles
  for update to authenticated
  using (
    id = auth.uid()
    and activo = true
    and debe_cambiar_password = false
  )
  with check (
    id = auth.uid()
    and activo = true
    and debe_cambiar_password = false
  );

create or replace function public.proteger_campos_perfil()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public, pg_temp
as $$
begin
  -- El service_role de las Edge Functions y un admin operativo son los unicos
  -- que pueden modificar campos de autorizacion.
  if auth.role() = 'service_role' or public.es_admin() then
    return new;
  end if;

  new.rol                         := old.rol;
  new.estado_laboral              := old.estado_laboral;
  new.activo                      := old.activo;
  new.fecha_alta                  := old.fecha_alta;
  new.fecha_baja                  := old.fecha_baja;
  new.motivo_baja                 := old.motivo_baja;
  new.debe_cambiar_password       := old.debe_cambiar_password;
  new.password_cambio_requerido_at := old.password_cambio_requerido_at;
  return new;
end;
$$;

create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public, private, pg_temp
as $$
declare
  v_rol_text text;
  v_rol public.rol_usuario;
begin
  if coalesce(new.raw_app_meta_data ->> 'provisionado_por_admin', '') <> 'true' then
    raise exception using
      errcode = '28000',
      message = 'El registro publico de usuarios no esta permitido.';
  end if;

  v_rol_text := new.raw_app_meta_data ->> 'rol';
  if v_rol_text is null
     or v_rol_text not in ('elemento', 'supervisor', 'cliente') then
    raise exception using
      errcode = '22023',
      message = 'Rol de usuario no permitido para provisionamiento.';
  end if;
  v_rol := v_rol_text::public.rol_usuario;

  insert into public.profiles (
    id,
    correo,
    nombre_completo,
    rol,
    telefono_whatsapp,
    estado_laboral,
    fecha_alta,
    debe_cambiar_password,
    password_cambio_requerido_at,
    activo
  )
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'nombre_completo', ''),
    v_rol,
    coalesce(new.raw_user_meta_data ->> 'telefono_whatsapp', ''),
    'activo',
    current_date,
    true,
    now(),
    false
  );

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function private.handle_new_user();

drop function if exists public.handle_new_user();
revoke all on function private.handle_new_user() from public, anon, authenticated;

-- Auditoria minima de operaciones sensibles. Nunca se almacena correo,
-- telefono ni contrasena, y el cliente no tiene permisos de escritura.
create table if not exists public.admin_usuario_auditoria (
  id            uuid primary key default gen_random_uuid(),
  actor_id      uuid references public.profiles(id) on delete set null,
  -- Sin FK: una baja o rollback debe conservar el UUID auditado aunque el
  -- perfil objetivo ya no exista.
  target_id     uuid,
  accion        text not null
                  check (accion in ('CREAR_USUARIO', 'RESTABLECER_PASSWORD')),
  estado        text not null default 'pendiente'
                  check (estado in ('pendiente', 'exito', 'error')),
  rol_objetivo  public.rol_usuario,
  codigo_error  text,
  created_at    timestamptz not null default now(),
  completed_at  timestamptz
);

create index if not exists idx_admin_usuario_auditoria_created
  on public.admin_usuario_auditoria (created_at desc);
create index if not exists idx_admin_usuario_auditoria_actor
  on public.admin_usuario_auditoria (actor_id, created_at desc);

alter table public.admin_usuario_auditoria enable row level security;

drop policy if exists admin_usuario_auditoria_select on public.admin_usuario_auditoria;
create policy admin_usuario_auditoria_select on public.admin_usuario_auditoria
  for select to authenticated
  using (public.es_admin());

revoke all on table public.admin_usuario_auditoria from public, anon, authenticated;
grant select on table public.admin_usuario_auditoria to authenticated;

-- Politicas restrictivas: se combinan con las politicas existentes mediante
-- AND y bloquean todas las tablas operativas mientras la contrasena sea
-- temporal. `profiles` queda fuera para que cada persona pueda leer su bandera.
do $$
declare
  v_tabla text;
begin
  foreach v_tabla in array array[
    'sitios',
    'usuario_sitios',
    'sitio_wifi_aps',
    'asistencias',
    'turnos',
    'avisos_privacidad',
    'personal_cliente',
    'visitantes',
    'registros_acceso',
    'bitacora_eventos',
    'bitacora_fotos',
    'catalogo_equipo',
    'recepciones_turno',
    'recepcion_turno_items',
    'notificaciones',
    'dispositivos_push',
    'solicitudes',
    'alertas_emitidas'
  ]
  loop
    execute format(
      'drop policy if exists password_temporal_gate on public.%I',
      v_tabla
    );
    execute format(
      'create policy password_temporal_gate on public.%I as restrictive '
      'for all to authenticated using (public.sesion_operativa_habilitada()) '
      'with check (public.sesion_operativa_habilitada())',
      v_tabla
    );
  end loop;
end;
$$;
