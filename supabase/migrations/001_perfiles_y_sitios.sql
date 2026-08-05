-- ─────────────────────────────────────────────────────────────────────────────
-- 001: Perfiles, roles, sitios y geocercas.
--
-- Base de todo el sistema. Define los 4 roles (elemento, supervisor, admin,
-- cliente), el ciclo de vida laboral del elemento (alta/baja/reingreso) y los
-- sitios con su geocerca + puntos de acceso WiFi autorizados.
--
-- Convenciones que siguen TODAS las tablas operativas del proyecto:
--   id          uuid  PK generada en servidor
--   local_id    text  UUID generado por el cliente. Es la clave de idempotencia
--                     del motor de sincronización offline: el upsert va contra
--                     local_id, así reintentar nunca duplica.
--   device_id   text  dispositivo que originó el registro (auditoría)
--   deleted_at        borrado lógico, nunca DELETE físico
--   updated_by        quién tocó la fila por última vez
-- ─────────────────────────────────────────────────────────────────────────────

create extension if not exists "pgcrypto" with schema extensions;

-- ─── Enum de roles ───────────────────────────────────────────────────────────

do $$ begin
  create type public.rol_usuario as enum ('elemento', 'supervisor', 'admin', 'cliente');
exception when duplicate_object then null;
end $$;

-- ─── Helper: updated_at automático ───────────────────────────────────────────

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- ─── TABLA: sitios ───────────────────────────────────────────────────────────
-- Cada sitio es una fábrica/planta con su propia geocerca. Arrancamos con una,
-- el modelo admite N sin migración.

create table if not exists public.sitios (
  id                 uuid primary key default gen_random_uuid(),
  nombre             text not null,
  razon_social       text not null default '',
  direccion          text not null default '',

  -- Geocerca. Nulas al inicio: se capturan desde el panel de admin parándose
  -- físicamente en la puerta ("usar mi ubicación actual").
  lat                numeric(10,7),
  lng                numeric(10,7),
  radio_metros       integer not null default 150
                       check (radio_metros > 0 and radio_metros <= 5000),

  -- Turno de 24 h. Configurable por sitio por si un cliente futuro opera otro horario.
  hora_inicio_turno  time not null default '08:00',
  minutos_tolerancia_retardo integer not null default 1   check (minutos_tolerancia_retardo >= 0),
  minutos_tolerancia_falta   integer not null default 90  check (minutos_tolerancia_falta   >= 0),
  -- A los cuántos minutos del inicio de turno se alerta al admin si no llegó el relevo.
  minutos_alerta_relevo      integer not null default 60  check (minutos_alerta_relevo      >= 0),

  -- Mexico City = UTC-6 fijo (sin horario de verano desde 2022). Se guarda como
  -- número y no como nombre de zona para poder usarlo en columnas generadas:
  -- `timestamptz at time zone 'texto'` es STABLE, no IMMUTABLE, y Postgres lo rechaza ahí.
  huso_horario_offset_h integer not null default -6,

  activo             boolean not null default true,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

create trigger sitios_set_updated_at
  before update on public.sitios
  for each row execute function public.set_updated_at();

-- ─── TABLA: profiles ─────────────────────────────────────────────────────────
-- Espejo de auth.users con el rol y los datos operativos.

create table if not exists public.profiles (
  id                    uuid primary key references auth.users(id) on delete cascade,
  nombre_completo       text not null default '',
  correo                text not null default '',

  -- El cliente ve este número para contactar por WhatsApp con un toque.
  -- Formato E.164 sin '+' (ej. 5215512345678) para armar el link wa.me/.
  telefono_whatsapp     text not null default '',

  rol                   public.rol_usuario not null default 'elemento',
  puesto                text not null default '',
  foto_perfil_url       text,

  -- Ciclo de vida laboral. El admin da de alta, de baja y reingresa.
  estado_laboral        text not null default 'activo'
                          check (estado_laboral in ('activo', 'baja', 'reingreso')),
  fecha_alta            date,
  fecha_baja            date,
  motivo_baja           text not null default '',

  -- El admin crea la cuenta con contraseña temporal; la app fuerza el cambio
  -- en el primer ingreso antes de dejar entrar a cualquier pantalla.
  debe_cambiar_password boolean not null default true,

  activo                boolean not null default true,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create index if not exists idx_profiles_rol    on public.profiles (rol) where activo = true;
create index if not exists idx_profiles_estado on public.profiles (estado_laboral);

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- ─── TABLA: usuario_sitios ───────────────────────────────────────────────────
-- Qué sitios le tocan a cada usuario.
--   elemento   → su sitio asignado (puede cubrir otro: la asistencia registra
--                el sitio real, no el asignado)
--   supervisor → los sitios que supervisa
--   cliente    → el/los sitio(s) de su empresa
--   admin      → no necesita filas aquí, ve todo

create table if not exists public.usuario_sitios (
  usuario_id  uuid not null references public.profiles(id) on delete cascade,
  sitio_id    uuid not null references public.sitios(id)   on delete cascade,
  es_principal boolean not null default false,
  created_at  timestamptz not null default now(),
  primary key (usuario_id, sitio_id)
);

create index if not exists idx_usuario_sitios_sitio on public.usuario_sitios (sitio_id);

-- ─── TABLA: sitio_wifi_aps ───────────────────────────────────────────────────
-- BSSIDs de los access points de la planta. Validar contra el BSSID (y no sólo
-- el SSID) es lo que impide que alguien levante un hotspot llamado igual desde
-- su casa: el BSSID es la MAC del AP y no se puede clonar trivialmente.

create table if not exists public.sitio_wifi_aps (
  id          uuid primary key default gen_random_uuid(),
  sitio_id    uuid not null references public.sitios(id) on delete cascade,
  bssid       text not null,
  ssid        text not null default '',
  nombre_zona text not null default '',
  activo      boolean not null default true,
  created_by  uuid references public.profiles(id),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (sitio_id, bssid)
);

create index if not exists idx_wifi_aps_bssid on public.sitio_wifi_aps (bssid) where activo = true;

create trigger sitio_wifi_aps_set_updated_at
  before update on public.sitio_wifi_aps
  for each row execute function public.set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
-- FUNCIONES HELPER PARA RLS
--
-- SECURITY DEFINER + search_path fijo: sin esto, una policy sobre `profiles`
-- que consulte `profiles` entra en recursión infinita. El definer salta RLS.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.rol_actual()
returns public.rol_usuario
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select rol from public.profiles where id = auth.uid();
$$;

create or replace function public.es_admin()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and rol = 'admin' and activo = true
  );
$$;

-- ¿El usuario actual tiene acceso a este sitio? Admin siempre; el resto sólo
-- los sitios que tenga asignados en usuario_sitios.
create or replace function public.tiene_acceso_sitio(p_sitio_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    public.es_admin()
    or exists (
      select 1 from public.usuario_sitios
      where usuario_id = auth.uid() and sitio_id = p_sitio_id
    );
$$;

-- Fecha operativa del turno. Un evento a las 03:00 del 4-ago pertenece al turno
-- que arrancó el 3-ago a las 08:00, así que restamos el offset del huso y la
-- hora de inicio antes de quedarnos con la fecha.
create or replace function public.fecha_turno(p_ts timestamptz, p_sitio_id uuid)
returns date
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select ((p_ts + make_interval(hours => s.huso_horario_offset_h)) - s.hora_inicio_turno)::date
  from public.sitios s
  where s.id = p_sitio_id;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- BOOTSTRAP DE PERFIL
-- Cada usuario de auth.users obtiene su fila en profiles automáticamente.
-- El rol y los datos reales los define el admin al crear la cuenta y viajan en
-- raw_user_meta_data.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  insert into public.profiles (id, correo, nombre_completo, rol, telefono_whatsapp, fecha_alta)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'nombre_completo', ''),
    coalesce((new.raw_user_meta_data ->> 'rol')::public.rol_usuario, 'elemento'),
    coalesce(new.raw_user_meta_data ->> 'telefono_whatsapp', ''),
    current_date
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ─────────────────────────────────────────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.sitios          enable row level security;
alter table public.profiles        enable row level security;
alter table public.usuario_sitios  enable row level security;
alter table public.sitio_wifi_aps  enable row level security;

-- profiles: cada quien se ve a sí mismo; admin y supervisor ven al personal;
-- el cliente ve a los elementos para poder contactarlos por WhatsApp.
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select to authenticated
  using (
    id = auth.uid()
    or public.es_admin()
    or public.rol_actual() in ('supervisor', 'cliente')
  );

-- El usuario edita su propio perfil (contraseña y WhatsApp), pero NO su rol ni
-- su estado laboral: eso se blinda con el trigger de abajo, porque una policy
-- por sí sola no puede comparar columna vieja contra nueva.
drop policy if exists profiles_update_self on public.profiles;
create policy profiles_update_self on public.profiles
  for update to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

drop policy if exists profiles_admin_all on public.profiles;
create policy profiles_admin_all on public.profiles
  for all to authenticated
  using (public.es_admin())
  with check (public.es_admin());

create or replace function public.proteger_campos_perfil()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  -- El admin puede cambiar lo que sea.
  if public.es_admin() then
    return new;
  end if;
  -- Cualquier otro: se le revierten los campos sensibles a su valor anterior.
  new.rol            := old.rol;
  new.estado_laboral := old.estado_laboral;
  new.activo         := old.activo;
  new.fecha_alta     := old.fecha_alta;
  new.fecha_baja     := old.fecha_baja;
  new.motivo_baja    := old.motivo_baja;
  return new;
end;
$$;

drop trigger if exists profiles_proteger_campos on public.profiles;
create trigger profiles_proteger_campos
  before update on public.profiles
  for each row execute function public.proteger_campos_perfil();

-- sitios: los ve quien tenga acceso; sólo admin escribe.
drop policy if exists sitios_select on public.sitios;
create policy sitios_select on public.sitios
  for select to authenticated
  using (public.tiene_acceso_sitio(id));

drop policy if exists sitios_admin_all on public.sitios;
create policy sitios_admin_all on public.sitios
  for all to authenticated
  using (public.es_admin())
  with check (public.es_admin());

-- usuario_sitios: cada quien ve sus asignaciones; sólo admin las cambia.
drop policy if exists usuario_sitios_select on public.usuario_sitios;
create policy usuario_sitios_select on public.usuario_sitios
  for select to authenticated
  using (usuario_id = auth.uid() or public.tiene_acceso_sitio(sitio_id));

drop policy if exists usuario_sitios_admin_all on public.usuario_sitios;
create policy usuario_sitios_admin_all on public.usuario_sitios
  for all to authenticated
  using (public.es_admin())
  with check (public.es_admin());

-- wifi_aps: los lee quien tenga acceso al sitio (la app necesita la lista para
-- validar la asistencia contra el BSSID); sólo admin los administra.
drop policy if exists wifi_aps_select on public.sitio_wifi_aps;
create policy wifi_aps_select on public.sitio_wifi_aps
  for select to authenticated
  using (public.tiene_acceso_sitio(sitio_id));

drop policy if exists wifi_aps_admin_all on public.sitio_wifi_aps;
create policy wifi_aps_admin_all on public.sitio_wifi_aps
  for all to authenticated
  using (public.es_admin())
  with check (public.es_admin());
