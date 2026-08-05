-- ─────────────────────────────────────────────────────────────────────────────
-- 006: Notificaciones, alertas y solicitudes del cliente.
--
-- Alertas que se disparan solas:
--   · armamento_novedad     → el elemento recibió el equipo con algún problema
--                              o no aceptó de conformidad          → admin
--   · relevo_no_llego       → pasó la tolerancia y no llegó el relevo → admin
--   · doblete               → el saliente se quedó a cubrir           → admin
--   · salida_no_registrada  → turno abierto más allá de lo razonable  → admin
--   · asistencia_revision   → un registro no validó por GPS ni WiFi   → supervisor + admin
--   · solicitud_cliente     → el cliente pidió algo                   → supervisor
--
-- La entrega es en dos capas: la fila en `notificaciones` con Realtime encendido
-- resuelve el aviso dentro de la app, y `dispositivos_push` guarda los tokens
-- para el envío por FCM cuando la app está cerrada (ver README de la migración 008).
-- ─────────────────────────────────────────────────────────────────────────────

-- ─── TABLA: notificaciones ───────────────────────────────────────────────────

create table if not exists public.notificaciones (
  id             uuid primary key default gen_random_uuid(),
  destinatario_id uuid not null references public.profiles(id) on delete cascade,
  sitio_id       uuid references public.sitios(id),

  tipo           text not null
                   check (tipo in ('armamento_novedad', 'relevo_no_llego', 'doblete',
                                   'salida_no_registrada', 'asistencia_revision',
                                   'solicitud_cliente', 'solicitud_respondida',
                                   'incidente_critico', 'aviso_general')),
  titulo         text not null,
  cuerpo         text not null default '',
  prioridad      text not null default 'normal'
                   check (prioridad in ('normal', 'alta', 'critica')),

  -- Referencia al registro que originó la alerta, para poder abrirlo con un
  -- toque desde la notificación.
  entidad_tipo   text not null default '',
  entidad_id     uuid,
  payload        jsonb not null default '{}'::jsonb,

  leida          boolean not null default false,
  leida_at       timestamptz,
  push_enviada   boolean not null default false,
  push_enviada_at timestamptz,

  created_at     timestamptz not null default now()
);

create index if not exists idx_notificaciones_destinatario
  on public.notificaciones (destinatario_id, created_at desc);
create index if not exists idx_notificaciones_no_leidas
  on public.notificaciones (destinatario_id) where leida = false;
create index if not exists idx_notificaciones_pendientes_push
  on public.notificaciones (created_at) where push_enviada = false;

-- ─── TABLA: dispositivos_push ────────────────────────────────────────────────

create table if not exists public.dispositivos_push (
  id           uuid primary key default gen_random_uuid(),
  usuario_id   uuid not null references public.profiles(id) on delete cascade,
  fcm_token    text not null,
  plataforma   text not null default 'android' check (plataforma in ('android', 'web')),
  device_id    text not null default '',
  activo       boolean not null default true,
  ultima_conexion timestamptz not null default now(),
  created_at   timestamptz not null default now(),
  unique (fcm_token)
);

create index if not exists idx_dispositivos_usuario
  on public.dispositivos_push (usuario_id) where activo = true;

-- ─── Helpers de notificación ─────────────────────────────────────────────────

create or replace function public.notificar_usuario(
  p_destinatario uuid,
  p_tipo         text,
  p_titulo       text,
  p_cuerpo       text default '',
  p_prioridad    text default 'normal',
  p_sitio_id     uuid default null,
  p_entidad_tipo text default '',
  p_entidad_id   uuid default null,
  p_payload      jsonb default '{}'::jsonb
)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_id uuid;
begin
  insert into public.notificaciones (
    destinatario_id, tipo, titulo, cuerpo, prioridad,
    sitio_id, entidad_tipo, entidad_id, payload
  ) values (
    p_destinatario, p_tipo, p_titulo, p_cuerpo, p_prioridad,
    p_sitio_id, p_entidad_tipo, p_entidad_id, p_payload
  )
  returning id into v_id;
  return v_id;
end;
$$;

-- Notifica a todos los usuarios activos de un rol. Si se pasa un sitio, a los
-- que tengan acceso a ese sitio (el admin siempre entra, aunque no tenga fila
-- en usuario_sitios).
create or replace function public.notificar_rol(
  p_rol          public.rol_usuario,
  p_tipo         text,
  p_titulo       text,
  p_cuerpo       text default '',
  p_prioridad    text default 'normal',
  p_sitio_id     uuid default null,
  p_entidad_tipo text default '',
  p_entidad_id   uuid default null,
  p_payload      jsonb default '{}'::jsonb
)
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_count integer := 0;
begin
  insert into public.notificaciones (
    destinatario_id, tipo, titulo, cuerpo, prioridad,
    sitio_id, entidad_tipo, entidad_id, payload
  )
  select p.id, p_tipo, p_titulo, p_cuerpo, p_prioridad,
         p_sitio_id, p_entidad_tipo, p_entidad_id, p_payload
    from public.profiles p
   where p.rol = p_rol
     and p.activo = true
     and p.estado_laboral <> 'baja'
     and (
       p_sitio_id is null
       or p.rol = 'admin'
       or exists (
         select 1 from public.usuario_sitios us
         where us.usuario_id = p.id and us.sitio_id = p_sitio_id
       )
     );

  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

-- ─── TABLA: solicitudes ──────────────────────────────────────────────────────
-- El cliente levanta un requerimiento y le llega notificación al supervisor.

create table if not exists public.solicitudes (
  id             uuid primary key default gen_random_uuid(),
  local_id       text not null unique,
  device_id      text not null default '',

  sitio_id       uuid not null references public.sitios(id),
  creada_por     uuid not null references public.profiles(id),

  asunto         text not null,
  descripcion    text not null default '',
  prioridad      text not null default 'normal'
                   check (prioridad in ('normal', 'alta', 'critica')),
  categoria      text not null default 'general'
                   check (categoria in ('general', 'personal', 'equipo',
                                        'procedimiento', 'queja', 'felicitacion')),

  estado         text not null default 'abierta'
                   check (estado in ('abierta', 'en_proceso', 'resuelta', 'cerrada')),
  asignada_a     uuid references public.profiles(id),
  respuesta      text not null default '',
  respondida_por uuid references public.profiles(id),
  respondida_at  timestamptz,
  cerrada_at     timestamptz,

  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  deleted_at     timestamptz,
  updated_by     uuid references public.profiles(id)
);

create index if not exists idx_solicitudes_sitio_estado
  on public.solicitudes (sitio_id, estado, created_at desc) where deleted_at is null;
create index if not exists idx_solicitudes_asignada
  on public.solicitudes (asignada_a) where deleted_at is null and estado in ('abierta', 'en_proceso');

create trigger solicitudes_set_updated_at
  before update on public.solicitudes
  for each row execute function public.set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
-- TRIGGERS DE ALERTA
-- ─────────────────────────────────────────────────────────────────────────────

-- Armamento / equipo recibido con novedad → admin.
-- Ojo: el turno NO se bloquea. La operación sigue, la alerta viaja.
create or replace function public.alertar_novedad_equipo()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_sitio  text;
  v_quien  text;
  v_detalle text;
begin
  if new.tiene_novedades = false then
    return new;
  end if;
  -- Sólo alertamos en el alta o cuando la fila pasa de "sin novedades" a "con
  -- novedades" (las partidas se insertan después de la cabecera).
  if tg_op = 'UPDATE' and old.tiene_novedades = true then
    return new;
  end if;

  select s.nombre into v_sitio from public.sitios   s where s.id = new.sitio_id;
  select p.nombre_completo into v_quien from public.profiles p where p.id = new.recibe_id;

  select string_agg(ce.nombre || ': ' || i.estado, ', ')
    into v_detalle
    from public.recepcion_turno_items i
    join public.catalogo_equipo ce on ce.id = i.equipo_id
   where i.recepcion_id = new.id and i.estado <> 'perfecto';

  perform public.notificar_rol(
    'admin',
    'armamento_novedad',
    'Novedad en recepción de turno — ' || coalesce(v_sitio, 'sitio'),
    coalesce(v_quien, 'El elemento') || ' reportó novedades al recibir el equipo. '
      || coalesce(v_detalle, 'No aceptó de conformidad.'),
    'alta',
    new.sitio_id,
    'recepcion_turno',
    new.id,
    jsonb_build_object(
      'acepta_conformidad', new.acepta_conformidad,
      'observaciones',      new.observaciones
    )
  );

  return new;
end;
$$;

drop trigger if exists recepciones_alertar on public.recepciones_turno;
create trigger recepciones_alertar
  after insert or update of tiene_novedades on public.recepciones_turno
  for each row execute function public.alertar_novedad_equipo();

-- Solicitud del cliente → supervisor (y admin, para que tenga visibilidad).
create or replace function public.alertar_solicitud_cliente()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_sitio text;
  v_quien text;
begin
  select s.nombre into v_sitio from public.sitios   s where s.id = new.sitio_id;
  select p.nombre_completo into v_quien from public.profiles p where p.id = new.creada_por;

  perform public.notificar_rol(
    'supervisor', 'solicitud_cliente',
    'Nueva solicitud del cliente — ' || coalesce(v_sitio, 'sitio'),
    coalesce(v_quien, 'El cliente') || ': ' || new.asunto,
    case when new.prioridad = 'critica' then 'critica' else 'alta' end,
    new.sitio_id, 'solicitud', new.id,
    jsonb_build_object('categoria', new.categoria, 'prioridad', new.prioridad)
  );

  perform public.notificar_rol(
    'admin', 'solicitud_cliente',
    'Nueva solicitud del cliente — ' || coalesce(v_sitio, 'sitio'),
    coalesce(v_quien, 'El cliente') || ': ' || new.asunto,
    'normal',
    new.sitio_id, 'solicitud', new.id,
    jsonb_build_object('categoria', new.categoria, 'prioridad', new.prioridad)
  );

  return new;
end;
$$;

drop trigger if exists solicitudes_alertar on public.solicitudes;
create trigger solicitudes_alertar
  after insert on public.solicitudes
  for each row execute function public.alertar_solicitud_cliente();

-- Respuesta del supervisor → de vuelta al cliente que la levantó.
create or replace function public.alertar_solicitud_respondida()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if new.estado in ('resuelta', 'cerrada') and old.estado not in ('resuelta', 'cerrada') then
    perform public.notificar_usuario(
      new.creada_por, 'solicitud_respondida',
      'Tu solicitud fue atendida',
      new.asunto || ' — ' || left(new.respuesta, 180),
      'normal', new.sitio_id, 'solicitud', new.id
    );
  end if;
  return new;
end;
$$;

drop trigger if exists solicitudes_alertar_respuesta on public.solicitudes;
create trigger solicitudes_alertar_respuesta
  after update of estado on public.solicitudes
  for each row execute function public.alertar_solicitud_respondida();

-- Asistencia que no validó ni por GPS ni por WiFi → supervisor y admin.
create or replace function public.alertar_asistencia_revision()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_quien text;
  v_sitio text;
begin
  if new.estado_validacion <> 'pendiente_revision' then
    return new;
  end if;

  select p.nombre_completo into v_quien from public.profiles p where p.id = new.usuario_id;
  select s.nombre          into v_sitio from public.sitios   s where s.id = new.sitio_id;

  perform public.notificar_rol(
    'supervisor', 'asistencia_revision',
    'Asistencia requiere revisión — ' || coalesce(v_sitio, 'sitio'),
    coalesce(v_quien, 'Un elemento') || ' registró ' || new.tipo_evento
      || ' sin validar ubicación (GPS ni WiFi de la planta).',
    'normal', new.sitio_id, 'asistencia', new.id,
    jsonb_build_object(
      'distancia_m',    new.distancia_sitio_m,
      'gps_accuracy_m', new.gps_accuracy_m,
      'wifi_ssid',      new.wifi_ssid
    )
  );

  return new;
end;
$$;

drop trigger if exists asistencias_alertar_revision on public.asistencias;
create trigger asistencias_alertar_revision
  after insert on public.asistencias
  for each row execute function public.alertar_asistencia_revision();

-- ─────────────────────────────────────────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.notificaciones    enable row level security;
alter table public.dispositivos_push enable row level security;
alter table public.solicitudes       enable row level security;

-- Cada quien ve sólo sus notificaciones.
drop policy if exists notificaciones_select on public.notificaciones;
create policy notificaciones_select on public.notificaciones
  for select to authenticated using (destinatario_id = auth.uid());

-- El único UPDATE legítimo desde la app es marcarla como leída.
drop policy if exists notificaciones_update on public.notificaciones;
create policy notificaciones_update on public.notificaciones
  for update to authenticated
  using (destinatario_id = auth.uid())
  with check (destinatario_id = auth.uid());

drop policy if exists dispositivos_push_propio on public.dispositivos_push;
create policy dispositivos_push_propio on public.dispositivos_push
  for all to authenticated
  using (usuario_id = auth.uid()) with check (usuario_id = auth.uid());

drop policy if exists solicitudes_select on public.solicitudes;
create policy solicitudes_select on public.solicitudes
  for select to authenticated using (public.tiene_acceso_sitio(sitio_id));

-- Sólo el cliente (y el admin) levantan solicitudes.
drop policy if exists solicitudes_insert on public.solicitudes;
create policy solicitudes_insert on public.solicitudes
  for insert to authenticated
  with check (
    creada_por = auth.uid()
    and public.rol_actual() in ('cliente', 'admin')
    and public.tiene_acceso_sitio(sitio_id)
  );

-- Las responde el supervisor o el admin; el cliente puede editar la suya
-- mientras siga abierta.
drop policy if exists solicitudes_update on public.solicitudes;
create policy solicitudes_update on public.solicitudes
  for update to authenticated
  using (
    public.rol_actual() in ('supervisor', 'admin')
    or (creada_por = auth.uid() and estado = 'abierta')
  )
  with check (
    public.rol_actual() in ('supervisor', 'admin')
    or (creada_por = auth.uid() and estado = 'abierta')
  );

-- Realtime: la campanita de la app se alimenta de aquí.
alter publication supabase_realtime add table public.notificaciones;
