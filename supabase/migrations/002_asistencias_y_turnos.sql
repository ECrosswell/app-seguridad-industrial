-- ─────────────────────────────────────────────────────────────────────────────
-- 002: Asistencias con geo-referencia + selfie, y turnos de 24 h.
--
-- Reglas del negocio (sitio "Fábrica", configurables por sitio en `sitios`):
--   · El turno arranca a las 08:00 y dura 24 h.
--   · 08:01 en adelante  → RETARDO
--   · 09:30 en adelante  → FALTA (hora y media)
--   · 09:00 (1 h de tolerancia) → si no llegó el relevo, se alerta al admin y
--     el turno saliente se marca como DOBLETE.
--   · Si el elemento olvida registrar su salida NO se cierra solo: se le avisa
--     al admin y él la cierra a mano, dejando constancia de quién la cerró.
--
-- `asistencias` es el registro inmutable de eventos (entrada, salida, descansos,
-- supervisión). `turnos` es el estado operativo derivado que mantienen los
-- triggers: es lo que consulta el cliente para ver "quién está adentro ahora"
-- sin recorrer todo el historial de eventos.
-- ─────────────────────────────────────────────────────────────────────────────

-- ─── TABLA: asistencias ──────────────────────────────────────────────────────

create table if not exists public.asistencias (
  id                 uuid primary key default gen_random_uuid(),
  local_id           text not null unique,
  device_id          text not null default '',

  usuario_id         uuid not null references public.profiles(id),
  sitio_id           uuid not null references public.sitios(id),
  turno_fecha        date not null,

  tipo_evento        text not null
                       check (tipo_evento in ('entrada', 'salida',
                                              'inicio_descanso', 'fin_descanso',
                                              'supervision')),
  ocurrido_at        timestamptz not null default now(),

  -- Geo-referencia
  lat                numeric(10,7),
  lng                numeric(10,7),
  gps_accuracy_m     numeric(8,2),
  distancia_sitio_m  numeric(10,2),
  dentro_geocerca    boolean not null default false,

  -- Validación por red: el BSSID es la MAC del access point y no se clona
  -- fácil, así que un hotspot con el mismo SSID no pasa el filtro.
  wifi_bssid         text,
  wifi_ssid          text,
  wifi_reconocido    boolean not null default false,

  metodo_validacion  text not null default 'sin_validar'
                       check (metodo_validacion in ('gps', 'wifi', 'gps_y_wifi',
                                                    'manual_admin', 'sin_validar')),
  -- Nunca se le bloquea el registro al elemento: si la validación no cuadra
  -- entra como 'pendiente_revision' y el supervisor o el admin resuelve.
  estado_validacion  text not null default 'validado'
                       check (estado_validacion in ('validado', 'pendiente_revision', 'rechazado')),

  -- Evidencia fotográfica. Prueba de vida (que hay una persona real frente a la
  -- cámara y no una foto de una foto), NO reconocimiento facial: no comparamos
  -- contra un rostro registrado, así que no tratamos datos biométricos y no
  -- caemos en el régimen de dato sensible de la LFPDPPP.
  selfie_url         text,
  liveness_passed    boolean not null default false,

  -- Clasificación (sólo tiene sentido en 'entrada'; en el resto queda 'na')
  clasificacion      text not null default 'na'
                       check (clasificacion in ('a_tiempo', 'retardo', 'falta', 'na')),
  minutos_retardo    integer not null default 0,

  -- El elemento cubrió un sitio distinto al que tiene asignado
  es_cobertura       boolean not null default false,

  observaciones      text not null default '',

  -- Revisión / corrección manual
  revisado_por       uuid references public.profiles(id),
  revisado_at        timestamptz,
  notas_revision     text not null default '',

  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  deleted_at         timestamptz,
  updated_by         uuid references public.profiles(id)
);

create index if not exists idx_asistencias_usuario_fecha
  on public.asistencias (usuario_id, turno_fecha desc) where deleted_at is null;
create index if not exists idx_asistencias_sitio_fecha
  on public.asistencias (sitio_id, turno_fecha desc) where deleted_at is null;
create index if not exists idx_asistencias_tipo
  on public.asistencias (tipo_evento, ocurrido_at desc) where deleted_at is null;
create index if not exists idx_asistencias_pendientes
  on public.asistencias (sitio_id, ocurrido_at desc)
  where deleted_at is null and estado_validacion = 'pendiente_revision';

create trigger asistencias_set_updated_at
  before update on public.asistencias
  for each row execute function public.set_updated_at();

-- ─── TABLA: turnos ───────────────────────────────────────────────────────────
-- Estado operativo derivado. Lo mantienen los triggers de `asistencias`.

create table if not exists public.turnos (
  id                    uuid primary key default gen_random_uuid(),
  usuario_id            uuid not null references public.profiles(id),
  sitio_id              uuid not null references public.sitios(id),
  turno_fecha           date not null,

  entrada_asistencia_id uuid references public.asistencias(id),
  salida_asistencia_id  uuid references public.asistencias(id),
  inicio_at             timestamptz not null,
  fin_at                timestamptz,

  estado                text not null default 'en_curso'
                          check (estado in ('en_curso', 'cerrado',
                                            'cerrado_por_admin', 'anomalia')),

  clasificacion_entrada text not null default 'a_tiempo'
                          check (clasificacion_entrada in ('a_tiempo', 'retardo', 'falta')),
  minutos_retardo       integer not null default 0,

  -- Se marca cuando el relevo no llegó dentro de la tolerancia y este elemento
  -- se quedó a cubrir el turno siguiente.
  es_doblete            boolean not null default false,
  es_cobertura          boolean not null default false,

  -- Cierre manual por el admin cuando el elemento olvidó registrar su salida.
  cerrado_por           uuid references public.profiles(id),
  cerrado_at            timestamptz,
  motivo_cierre         text not null default '',

  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

-- Un elemento no puede tener dos turnos abiertos a la vez, en ningún sitio.
create unique index if not exists uidx_turnos_usuario_abierto
  on public.turnos (usuario_id) where estado = 'en_curso';

create index if not exists idx_turnos_sitio_estado
  on public.turnos (sitio_id, estado, inicio_at desc);
create index if not exists idx_turnos_fecha
  on public.turnos (turno_fecha desc);

create trigger turnos_set_updated_at
  before update on public.turnos
  for each row execute function public.set_updated_at();

-- ─────────────────────────────────────────────────────────────────────────────
-- LÓGICA DE NEGOCIO
-- ─────────────────────────────────────────────────────────────────────────────

-- Rellena turno_fecha, clasifica retardo/falta y decide el método y estado de
-- validación a partir de la geocerca y del WiFi. Corre ANTES de insertar, así
-- que el cliente puede mandar sólo los datos crudos (lat/lng/bssid) y el
-- servidor es la única autoridad sobre la clasificación — el elemento no puede
-- mandarse a sí mismo un 'a_tiempo' desde una app modificada.
create or replace function public.procesar_asistencia()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp, extensions
as $$
declare
  v_sitio          public.sitios%rowtype;
  v_inicio_turno   timestamptz;
  v_minutos        integer;
  v_wifi_ok        boolean := false;
  v_local          timestamptz;
begin
  select * into v_sitio from public.sitios where id = new.sitio_id;
  if not found then
    raise exception 'Sitio % no existe', new.sitio_id;
  end if;

  -- Hora local del sitio (offset fijo, sin horario de verano)
  v_local := new.ocurrido_at + make_interval(hours => v_sitio.huso_horario_offset_h);

  -- Fecha operativa del turno: un evento a las 03:00 pertenece al turno que
  -- arrancó a las 08:00 del día anterior.
  if new.turno_fecha is null then
    new.turno_fecha := (v_local - v_sitio.hora_inicio_turno)::date;
  end if;

  -- ¿El BSSID reportado es de un AP autorizado del sitio?
  if new.wifi_bssid is not null and new.wifi_bssid <> '' then
    select exists (
      select 1 from public.sitio_wifi_aps
      where sitio_id = new.sitio_id
        and lower(bssid) = lower(new.wifi_bssid)
        and activo = true
    ) into v_wifi_ok;
  end if;
  new.wifi_reconocido := v_wifi_ok;

  -- Distancia a la geocerca. Si el sitio aún no tiene coordenadas capturadas,
  -- no podemos validar por GPS y la distancia queda nula.
  if new.lat is not null and new.lng is not null
     and v_sitio.lat is not null and v_sitio.lng is not null then
    -- Haversine en metros (radio terrestre 6 371 000 m)
    new.distancia_sitio_m := 6371000 * 2 * asin(sqrt(
        power(sin(radians(new.lat - v_sitio.lat) / 2), 2)
      + cos(radians(v_sitio.lat)) * cos(radians(new.lat))
      * power(sin(radians(new.lng - v_sitio.lng) / 2), 2)
    ));
    new.dentro_geocerca := new.distancia_sitio_m <= v_sitio.radio_metros;
  else
    new.dentro_geocerca := false;
  end if;

  -- Método y estado de validación
  if new.dentro_geocerca and v_wifi_ok then
    new.metodo_validacion := 'gps_y_wifi';
    new.estado_validacion := 'validado';
  elsif new.dentro_geocerca then
    new.metodo_validacion := 'gps';
    new.estado_validacion := 'validado';
  elsif v_wifi_ok then
    -- Dentro de la planta pero con GPS malo (naves industriales, techo metálico).
    new.metodo_validacion := 'wifi';
    new.estado_validacion := 'validado';
  else
    new.metodo_validacion := 'sin_validar';
    new.estado_validacion := 'pendiente_revision';
  end if;

  -- Clasificación de puntualidad, sólo en la entrada.
  if new.tipo_evento = 'entrada' then
    -- `date + time` da un timestamp SIN zona que representa hora local del
    -- sitio. Le restamos el offset para llevarlo a UTC y lo anclamos con
    -- `at time zone 'UTC'` en lugar de confiar en el TimeZone de la sesión.
    v_inicio_turno := ((new.turno_fecha + v_sitio.hora_inicio_turno)
                        - make_interval(hours => v_sitio.huso_horario_offset_h))
                      at time zone 'UTC';
    v_minutos := greatest(0, floor(extract(epoch from (new.ocurrido_at - v_inicio_turno)) / 60)::integer);
    new.minutos_retardo := v_minutos;

    if v_minutos >= v_sitio.minutos_tolerancia_falta then
      new.clasificacion := 'falta';
    elsif v_minutos >= v_sitio.minutos_tolerancia_retardo then
      new.clasificacion := 'retardo';
    else
      new.clasificacion := 'a_tiempo';
    end if;

    -- ¿Está cubriendo un sitio que no es el suyo?
    new.es_cobertura := not exists (
      select 1 from public.usuario_sitios
      where usuario_id = new.usuario_id and sitio_id = new.sitio_id
    );
  else
    new.clasificacion   := 'na';
    new.minutos_retardo := 0;
  end if;

  return new;
end;
$$;

drop trigger if exists asistencias_procesar on public.asistencias;
create trigger asistencias_procesar
  before insert on public.asistencias
  for each row execute function public.procesar_asistencia();

-- Mantiene `turnos` en sincronía con los eventos de asistencia.
create or replace function public.sincronizar_turno()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_turno_id uuid;
begin
  if new.tipo_evento = 'entrada' then
    -- Si ya tenía un turno abierto (olvidó marcar salida), no abrimos otro: el
    -- índice único lo impediría. Se marca como anomalía para que el admin lo
    -- cierre y se registra el nuevo turno.
    update public.turnos
       set estado        = 'anomalia',
           motivo_cierre = 'Entrada nueva sin salida registrada del turno anterior'
     where usuario_id = new.usuario_id and estado = 'en_curso';

    insert into public.turnos (
      usuario_id, sitio_id, turno_fecha, entrada_asistencia_id, inicio_at,
      estado, clasificacion_entrada, minutos_retardo, es_cobertura
    ) values (
      new.usuario_id, new.sitio_id, new.turno_fecha, new.id, new.ocurrido_at,
      'en_curso', new.clasificacion, new.minutos_retardo, new.es_cobertura
    );

  elsif new.tipo_evento = 'salida' then
    select id into v_turno_id
      from public.turnos
     where usuario_id = new.usuario_id and estado = 'en_curso'
     order by inicio_at desc
     limit 1;

    if v_turno_id is not null then
      update public.turnos
         set salida_asistencia_id = new.id,
             fin_at               = new.ocurrido_at,
             estado               = 'cerrado'
       where id = v_turno_id;
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists asistencias_sincronizar_turno on public.asistencias;
create trigger asistencias_sincronizar_turno
  after insert on public.asistencias
  for each row execute function public.sincronizar_turno();

-- ─── VISTA: quién está adentro ahora ─────────────────────────────────────────
-- Es lo que abre el cliente para ver el personal en planta y contactarlo.
-- security_invoker: la vista respeta el RLS del que consulta, no el del dueño.

create or replace view public.v_personal_en_sitio
with (security_invoker = true)
as
select
  t.id                as turno_id,
  t.sitio_id,
  s.nombre            as sitio_nombre,
  t.usuario_id,
  p.nombre_completo,
  p.rol,
  p.puesto,
  p.telefono_whatsapp,
  p.foto_perfil_url,
  t.inicio_at,
  t.turno_fecha,
  t.clasificacion_entrada,
  t.minutos_retardo,
  t.es_doblete,
  t.es_cobertura,
  a.selfie_url        as selfie_entrada_url,
  a.dentro_geocerca,
  a.metodo_validacion,
  a.estado_validacion,
  -- Horas transcurridas del turno de 24 h
  round(extract(epoch from (now() - t.inicio_at)) / 3600.0, 1) as horas_en_turno
from public.turnos t
join public.profiles p on p.id = t.usuario_id
join public.sitios   s on s.id = t.sitio_id
left join public.asistencias a on a.id = t.entrada_asistencia_id
where t.estado = 'en_curso';

-- ─────────────────────────────────────────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.asistencias enable row level security;
alter table public.turnos      enable row level security;

-- El elemento registra SU propia asistencia y nada más. La clasificación la
-- pone el trigger, así que no puede falsearla desde el cliente.
drop policy if exists asistencias_insert_propia on public.asistencias;
create policy asistencias_insert_propia on public.asistencias
  for insert to authenticated
  with check (usuario_id = auth.uid());

drop policy if exists asistencias_select on public.asistencias;
create policy asistencias_select on public.asistencias
  for select to authenticated
  using (usuario_id = auth.uid() or public.tiene_acceso_sitio(sitio_id));

-- Corregir/validar una asistencia es cosa de admin y supervisor.
drop policy if exists asistencias_update_supervision on public.asistencias;
create policy asistencias_update_supervision on public.asistencias
  for update to authenticated
  using (public.rol_actual() in ('admin', 'supervisor'))
  with check (public.rol_actual() in ('admin', 'supervisor'));

drop policy if exists turnos_select on public.turnos;
create policy turnos_select on public.turnos
  for select to authenticated
  using (usuario_id = auth.uid() or public.tiene_acceso_sitio(sitio_id));

-- Sólo admin y supervisor cierran turnos a mano.
drop policy if exists turnos_update on public.turnos;
create policy turnos_update on public.turnos
  for update to authenticated
  using (public.rol_actual() in ('admin', 'supervisor'))
  with check (public.rol_actual() in ('admin', 'supervisor'));
