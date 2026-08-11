-- Rondines QR offline con validacion por capas.
--
-- Un QR impreso es fotografiable. Por eso el QR solamente identifica el punto:
-- el servidor decide el veredicto usando ademas turno, ruta, orden, tiempos,
-- reloj monotono, GPS, deteccion de ubicacion simulada, WiFi y cadena de hashes.
-- Los clientes nunca escriben ni actualizan los resultados directamente.

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;
-- Los wrappers públicos son SECURITY INVOKER y sólo service_role puede
-- ejecutarlos; necesita resolver las funciones internas del esquema privado.
grant usage on schema private to service_role;

-- Permiten FKs compuestas que garanticen que seccion, WiFi, ruta y punto
-- pertenecen al mismo sitio, no solo que sus UUID existen.
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'sitio_wifi_aps_id_sitio_unique'
      and conrelid = 'public.sitio_wifi_aps'::regclass
  ) then
    alter table public.sitio_wifi_aps
      add constraint sitio_wifi_aps_id_sitio_unique unique (id, sitio_id);
  end if;
end
$$;

create table public.secciones_sitio (
  id          uuid primary key default gen_random_uuid(),
  sitio_id    uuid not null references public.sitios(id) on delete cascade,
  nombre      text not null check (char_length(btrim(nombre)) between 1 and 120),
  descripcion text not null default '' check (char_length(descripcion) <= 1000),
  activo      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (id, sitio_id)
);

create unique index uidx_secciones_sitio_nombre
  on public.secciones_sitio (sitio_id, lower(btrim(nombre)));
create index idx_secciones_sitio_activas
  on public.secciones_sitio (sitio_id, nombre) where activo = true;

create table public.puntos_rondin (
  id                   uuid primary key default gen_random_uuid(),
  sitio_id             uuid not null references public.sitios(id) on delete cascade,
  seccion_id           uuid not null,
  nombre               text not null check (char_length(btrim(nombre)) between 1 and 120),
  descripcion          text not null default '' check (char_length(descripcion) <= 1000),
  lat                  numeric(10,7),
  lng                  numeric(10,7),
  radio_metros         integer not null default 35
                         check (radio_metros between 5 and 1000),
  wifi_ap_id           uuid,
  requiere_liveness    boolean not null default false,
  activo               boolean not null default true,
  qr_version           integer not null default 1 check (qr_version >= 1),
  -- SHA-256 hex del payload RAW completo SIQR1.<uuid>.<version>.<token>.
  -- Permite validar offline; no permite recuperar el token aleatorio.
  token_hash           text not null
                         check (token_hash ~ '^[0-9a-f]{64}$'),
  created_by           uuid references public.profiles(id) on delete set null,
  updated_by           uuid references public.profiles(id) on delete set null,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  unique (id, sitio_id),
  constraint puntos_rondin_coordenadas_completas check (
    (lat is null and lng is null)
    or (lat between -90 and 90 and lng between -180 and 180)
  ),
  constraint puntos_rondin_seccion_mismo_sitio
    foreign key (seccion_id, sitio_id)
    references public.secciones_sitio(id, sitio_id),
  constraint puntos_rondin_wifi_mismo_sitio
    foreign key (wifi_ap_id, sitio_id)
    references public.sitio_wifi_aps(id, sitio_id)
);

create unique index uidx_puntos_rondin_nombre
  on public.puntos_rondin (sitio_id, seccion_id, lower(btrim(nombre)));
create index idx_puntos_rondin_catalogo
  on public.puntos_rondin (sitio_id, activo, updated_at desc);
create index idx_puntos_rondin_seccion
  on public.puntos_rondin (seccion_id);
create index idx_puntos_rondin_wifi
  on public.puntos_rondin (wifi_ap_id) where wifi_ap_id is not null;

create table public.rutas_rondin (
  id               uuid primary key default gen_random_uuid(),
  sitio_id         uuid not null references public.sitios(id) on delete cascade,
  nombre           text not null check (char_length(btrim(nombre)) between 1 and 120),
  descripcion      text not null default '' check (char_length(descripcion) <= 1000),
  orden_aleatorio  boolean not null default false,
  minutos_minimos  integer not null default 0 check (minutos_minimos between 0 and 1440),
  minutos_maximos  integer not null default 180 check (minutos_maximos between 1 and 2880),
  activo           boolean not null default true,
  created_by       uuid references public.profiles(id) on delete set null,
  updated_by       uuid references public.profiles(id) on delete set null,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  unique (id, sitio_id),
  constraint rutas_rondin_duracion_valida
    check (minutos_maximos >= minutos_minimos)
);

create unique index uidx_rutas_rondin_nombre_activo
  on public.rutas_rondin (sitio_id, lower(btrim(nombre))) where activo = true;
create index idx_rutas_rondin_catalogo
  on public.rutas_rondin (sitio_id, activo, updated_at desc);

create table public.ruta_rondin_puntos (
  id                                uuid primary key default gen_random_uuid(),
  sitio_id                          uuid not null references public.sitios(id) on delete cascade,
  ruta_id                           uuid not null,
  punto_id                          uuid not null,
  orden                             integer not null check (orden between 1 and 1000),
  obligatorio                       boolean not null default true,
  segundos_minimos_desde_anterior   integer not null default 0
                                      check (segundos_minimos_desde_anterior between 0 and 86400),
  segundos_maximos_desde_anterior   integer not null default 3600
                                      check (segundos_maximos_desde_anterior between 1 and 172800),
  created_at                        timestamptz not null default now(),
  updated_at                        timestamptz not null default now(),
  constraint ruta_rondin_puntos_tiempos_validos check (
    segundos_maximos_desde_anterior >= segundos_minimos_desde_anterior
  ),
  constraint ruta_rondin_puntos_ruta_mismo_sitio
    foreign key (ruta_id, sitio_id)
    references public.rutas_rondin(id, sitio_id) on delete cascade,
  constraint ruta_rondin_puntos_punto_mismo_sitio
    foreign key (punto_id, sitio_id)
    references public.puntos_rondin(id, sitio_id),
  unique (ruta_id, punto_id),
  unique (ruta_id, orden)
);

create index idx_ruta_rondin_puntos_punto on public.ruta_rondin_puntos (punto_id);
create index idx_ruta_rondin_puntos_sitio on public.ruta_rondin_puntos (sitio_id);

-- El token imprimible vive en private y no tiene grants ni siquiera para
-- service_role. Solo lo toca la RPC SECURITY DEFINER restringida al servidor.
create table private.puntos_rondin_secretos (
  punto_id     uuid not null references public.puntos_rondin(id) on delete cascade,
  qr_version   integer not null check (qr_version >= 1),
  token        text not null check (char_length(token) between 32 and 200),
  payload_hash text not null check (payload_hash ~ '^[0-9a-f]{64}$'),
  activo       boolean not null default true,
  created_by   uuid references public.profiles(id) on delete set null,
  created_at   timestamptz not null default now(),
  rotated_at   timestamptz,
  primary key (punto_id, qr_version)
);

create unique index uidx_puntos_rondin_secreto_activo
  on private.puntos_rondin_secretos (punto_id) where activo = true;
revoke all on table private.puntos_rondin_secretos
  from public, anon, authenticated, service_role;

create table public.rondines (
  id                          uuid primary key default gen_random_uuid(),
  local_id                    text not null,
  usuario_id                  uuid not null references public.profiles(id),
  sitio_id                    uuid not null references public.sitios(id),
  turno_id                    uuid references public.turnos(id),
  ruta_id                     uuid references public.rutas_rondin(id),
  ruta_reportada_id           uuid not null,
  device_id                   text not null check (char_length(device_id) between 1 and 200),
  turno_fecha                 date,
  iniciado_at_dispositivo     timestamptz not null,
  iniciado_monotonic_ms       bigint not null check (iniciado_monotonic_ms >= 0),
  finalizado_at_dispositivo   timestamptz,
  finalizado_monotonic_ms     bigint check (finalizado_monotonic_ms is null or finalizado_monotonic_ms >= 0),
  recibido_at                 timestamptz not null default now(),
  estado_validacion           text not null
                                check (estado_validacion in ('validado', 'pendiente_revision', 'rechazado')),
  puntaje_riesgo              integer not null check (puntaje_riesgo between 0 and 100),
  codigos_riesgo              text[] not null default '{}',
  puntos_esperados            integer not null default 0 check (puntos_esperados >= 0),
  puntos_recibidos            integer not null default 0 check (puntos_recibidos >= 0),
  payload_hash                text not null check (payload_hash ~ '^[0-9a-f]{64}$'),
  created_at                  timestamptz not null default now(),
  unique (usuario_id, local_id),
  constraint rondines_local_id_valido check (char_length(local_id) between 8 and 100),
  constraint rondines_fechas_validas check (
    finalizado_at_dispositivo is null
    or finalizado_at_dispositivo >= iniciado_at_dispositivo - interval '5 minutes'
  )
);

create index idx_rondines_sitio_fecha
  on public.rondines (sitio_id, iniciado_at_dispositivo desc);
create index idx_rondines_usuario_fecha
  on public.rondines (usuario_id, iniciado_at_dispositivo desc);
create index idx_rondines_revision
  on public.rondines (sitio_id, created_at desc)
  where estado_validacion <> 'validado';
create index idx_rondines_turno on public.rondines (turno_id) where turno_id is not null;
create index idx_rondines_ruta on public.rondines (ruta_id) where ruta_id is not null;

create table public.rondin_lecturas (
  id                          uuid primary key default gen_random_uuid(),
  rondin_id                   uuid not null references public.rondines(id) on delete restrict,
  local_id                    text not null,
  punto_id                    uuid references public.puntos_rondin(id),
  punto_reportado_id          uuid not null,
  secuencia                   integer not null check (secuencia between 1 and 1000),
  capturado_at_dispositivo    timestamptz not null,
  monotonic_ms                bigint not null check (monotonic_ms >= 0),
  boot_count                  integer not null default 0 check (boot_count >= 0),
  lat                         numeric(10,7),
  lng                         numeric(10,7),
  gps_accuracy_m              numeric(10,2) check (gps_accuracy_m is null or gps_accuracy_m >= 0),
  gps_age_ms                  integer check (gps_age_ms is null or gps_age_ms >= 0),
  gps_is_mocked               boolean not null default false,
  wifi_bssid                  text,
  wifi_ssid                   text,
  token_version               integer not null check (token_version >= 1),
  qr_payload_hash             text not null check (qr_payload_hash ~ '^[0-9a-f]{64}$'),
  hora_automatica             boolean not null default true,
  opciones_desarrollador      boolean not null default false,
  adb_activo                  boolean not null default false,
  hash_anterior               text,
  hash_evento                 text not null check (hash_evento ~ '^[0-9a-f]{64}$'),
  liveness_passed             boolean,
  qr_valido                   boolean not null,
  distancia_punto_m           numeric(12,2),
  dentro_geocerca             boolean not null default false,
  wifi_reconocido             boolean not null default false,
  estado_validacion           text not null
                                check (estado_validacion in ('validado', 'pendiente_revision', 'rechazado')),
  puntaje_riesgo              integer not null check (puntaje_riesgo between 0 and 100),
  codigos_riesgo              text[] not null default '{}',
  created_at                  timestamptz not null default now(),
  unique (rondin_id, local_id),
  unique (rondin_id, secuencia),
  unique (rondin_id, punto_reportado_id),
  constraint rondin_lecturas_local_id_valido check (char_length(local_id) between 8 and 100),
  constraint rondin_lecturas_coordenadas_completas check (
    (lat is null and lng is null)
    or (lat between -90 and 90 and lng between -180 and 180)
  ),
  constraint rondin_lecturas_hash_anterior_valido check (
    hash_anterior is null or hash_anterior ~ '^[0-9a-f]{64}$'
  )
);

create index idx_rondin_lecturas_rondin
  on public.rondin_lecturas (rondin_id, secuencia);
create index idx_rondin_lecturas_punto_fecha
  on public.rondin_lecturas (punto_id, capturado_at_dispositivo desc)
  where punto_id is not null;
create index idx_rondin_lecturas_revision
  on public.rondin_lecturas (created_at desc)
  where estado_validacion <> 'validado';

-- Historial append-only de decisiones humanas. No se modifica el veredicto
-- tecnico ni se pisa una revision anterior: la fila mas reciente por
-- (created_at desc, id desc) es el veredicto administrativo vigente.
create table public.rondin_revisiones (
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

create index idx_rondin_revisiones_vigente
  on public.rondin_revisiones (rondin_id, created_at desc, id desc);
create index idx_rondin_revisiones_actor
  on public.rondin_revisiones (actor_id, created_at desc);

-- Auditoria separada de la evidencia operativa. Tampoco admite escrituras del
-- cliente; el admin solo puede consultarla.
create table public.admin_rondin_auditoria (
  id          uuid primary key default gen_random_uuid(),
  actor_id    uuid references public.profiles(id) on delete set null,
  punto_id    uuid references public.puntos_rondin(id) on delete set null,
  accion      text not null
                check (accion in ('CREAR_PUNTO', 'ACTUALIZAR_PUNTO', 'ROTAR_CODIGO',
                                  'OBTENER_CODIGO', 'CREAR_SECCION',
                                  'ACTUALIZAR_SECCION', 'REVISAR_RONDIN')),
  metadata    jsonb not null default '{}',
  created_at  timestamptz not null default now()
);

create index idx_admin_rondin_auditoria_fecha
  on public.admin_rondin_auditoria (created_at desc);
create index idx_admin_rondin_auditoria_actor
  on public.admin_rondin_auditoria (actor_id, created_at desc);

-- updated_at para catalogos mutables.
create trigger secciones_sitio_set_updated_at
  before update on public.secciones_sitio
  for each row execute function public.set_updated_at();
create trigger puntos_rondin_set_updated_at
  before update on public.puntos_rondin
  for each row execute function public.set_updated_at();
create trigger rutas_rondin_set_updated_at
  before update on public.rutas_rondin
  for each row execute function public.set_updated_at();
create trigger ruta_rondin_puntos_set_updated_at
  before update on public.ruta_rondin_puntos
  for each row execute function public.set_updated_at();

-- Evidencia append-only. Ni service_role puede reescribir el historial por
-- accidente; una correccion futura debe vivir en una tabla de revision aparte.
create or replace function private.bloquear_mutacion_rondin()
returns trigger
language plpgsql
set search_path = pg_catalog, private, pg_temp
as $$
begin
  raise exception using
    errcode = '55000',
    message = 'La evidencia de rondin es inmutable.';
end;
$$;

create trigger rondines_inmutables
  before update or delete on public.rondines
  for each row execute function private.bloquear_mutacion_rondin();
create trigger rondin_lecturas_inmutables
  before update or delete on public.rondin_lecturas
  for each row execute function private.bloquear_mutacion_rondin();
create trigger rondin_revisiones_inmutables
  before update or delete on public.rondin_revisiones
  for each row execute function private.bloquear_mutacion_rondin();
create trigger admin_rondin_auditoria_inmutable
  before update or delete on public.admin_rondin_auditoria
  for each row execute function private.bloquear_mutacion_rondin();

revoke all on function private.bloquear_mutacion_rondin()
  from public, anon, authenticated, service_role;

create or replace function private.rondin_agregar_codigo(
  p_codigos text[],
  p_codigo text
)
returns text[]
language sql
immutable
set search_path = pg_catalog, pg_temp
as $$
  select case
    when p_codigo = any(coalesce(p_codigos, '{}'::text[]))
      then coalesce(p_codigos, '{}'::text[])
    else array_append(coalesce(p_codigos, '{}'::text[]), p_codigo)
  end;
$$;

create or replace function private.rondin_distancia_m(
  p_lat_1 numeric,
  p_lng_1 numeric,
  p_lat_2 numeric,
  p_lng_2 numeric
)
returns numeric
language sql
immutable
strict
set search_path = pg_catalog, pg_temp
as $$
  select 6371000 * 2 * asin(sqrt(
      power(sin(radians(p_lat_1 - p_lat_2) / 2), 2)
    + cos(radians(p_lat_2)) * cos(radians(p_lat_1))
    * power(sin(radians(p_lng_1 - p_lng_2) / 2), 2)
  ));
$$;

create or replace function private.resultado_rondin_json(p_rondin_id uuid)
returns jsonb
language sql
stable
security definer
set search_path = pg_catalog, public, private, pg_temp
as $$
  select jsonb_build_object(
    'local_id', r.local_id,
    'id', r.id,
    'estado_validacion', r.estado_validacion,
    'puntaje_riesgo', r.puntaje_riesgo,
    'codigos_riesgo', to_jsonb(r.codigos_riesgo),
    'lecturas', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'local_id', l.local_id,
          'id', l.id,
          'estado_validacion', l.estado_validacion,
          'puntaje_riesgo', l.puntaje_riesgo,
          'codigos_riesgo', to_jsonb(l.codigos_riesgo)
        ) order by l.secuencia
      )
      from public.rondin_lecturas l
      where l.rondin_id = r.id
    ), '[]'::jsonb)
  )
  from public.rondines r
  where r.id = p_rondin_id;
$$;

revoke all on function private.rondin_agregar_codigo(text[], text)
  from public, anon, authenticated, service_role;
revoke all on function private.rondin_distancia_m(numeric, numeric, numeric, numeric)
  from public, anon, authenticated, service_role;
revoke all on function private.resultado_rondin_json(uuid)
  from public, anon, authenticated, service_role;

-- Hasta contar con una llave de dispositivo en Android Keystore y atestacion
-- verificada por servidor, GPS/WiFi/reloj son señales no confiables. Este
-- trigger hace imposible que una lectura o ronda nueva termine validada de
-- forma automatica. Los rechazos duros se conservan.
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

create trigger rondines_exigir_atestacion
  before insert on public.rondines
  for each row execute function private.forzar_revision_dispositivo_no_atestado();
create trigger rondin_lecturas_exigir_atestacion
  before insert on public.rondin_lecturas
  for each row execute function private.forzar_revision_dispositivo_no_atestado();

revoke all on function private.forzar_revision_dispositivo_no_atestado()
  from public, anon, authenticated, service_role;

-- Una sola transaccion crea/edita el punto, conserva la ruta general y rota el
-- secreto. La Edge Function autentica el JWT y esta RPC vuelve a comprobar que
-- el actor siga siendo admin operativo.
create or replace function private.administrar_punto_rondin_servidor(
  p_actor_id uuid,
  p_accion text,
  p_datos jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, public, private, extensions, pg_temp
as $$
declare
  v_punto_id uuid;
  v_sitio_id uuid;
  v_seccion_id uuid;
  v_wifi_ap_id uuid;
  v_ruta_id uuid;
  v_version integer;
  v_token text;
  v_payload text;
  v_payload_hash text;
  v_orden integer;
  v_min_segundos integer;
  v_max_segundos integer;
  v_punto jsonb;
  v_resultado jsonb;
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

  if p_accion in ('listar', 'listar_puntos') then
    v_sitio_id := nullif(p_datos ->> 'sitio_id', '')::uuid;
    select coalesce(
      jsonb_agg(to_jsonb(q) - 'token_hash' order by q.nombre),
      '[]'::jsonb
    )
      into v_resultado
    from (
      select p.*,
             rp.orden,
             rp.segundos_minimos_desde_anterior
      from public.puntos_rondin p
      left join public.ruta_rondin_puntos rp
        on rp.punto_id = p.id
      left join public.rutas_rondin r
        on r.id = rp.ruta_id and r.activo = true
      where v_sitio_id is null or p.sitio_id = v_sitio_id
    ) q;
    return jsonb_build_object('puntos', v_resultado);
  end if;

  if p_accion in ('crear_seccion', 'actualizar_seccion') then
    v_sitio_id := nullif(p_datos ->> 'sitio_id', '')::uuid;
    if not exists (select 1 from public.sitios where id = v_sitio_id and activo = true) then
      raise exception using errcode = '22023', message = 'SITIO_INVALIDO';
    end if;

    if p_accion = 'crear_seccion' then
      insert into public.secciones_sitio (sitio_id, nombre, descripcion, activo)
      values (
        v_sitio_id,
        btrim(coalesce(p_datos ->> 'nombre', '')),
        btrim(coalesce(p_datos ->> 'descripcion', '')),
        coalesce((p_datos ->> 'activo')::boolean, true)
      )
      returning to_jsonb(secciones_sitio.*) into v_resultado;
    else
      v_seccion_id := nullif(p_datos ->> 'seccion_id', '')::uuid;
      update public.secciones_sitio
      set nombre = btrim(coalesce(p_datos ->> 'nombre', nombre)),
          descripcion = btrim(coalesce(p_datos ->> 'descripcion', descripcion)),
          activo = coalesce((p_datos ->> 'activo')::boolean, activo)
      where id = v_seccion_id and sitio_id = v_sitio_id
      returning to_jsonb(secciones_sitio.*) into v_resultado;
      if not found then
        raise exception using errcode = 'P0002', message = 'SECCION_NO_ENCONTRADA';
      end if;
    end if;

    insert into public.admin_rondin_auditoria (actor_id, accion, metadata)
    values (
      p_actor_id,
      case when p_accion = 'crear_seccion'
        then 'CREAR_SECCION' else 'ACTUALIZAR_SECCION' end,
      jsonb_build_object('sitio_id', v_sitio_id, 'seccion_id', v_seccion_id)
    );
    return jsonb_build_object('seccion', v_resultado);
  end if;

  if p_accion = 'crear_punto' then
    v_punto_id := gen_random_uuid();
    v_sitio_id := nullif(p_datos ->> 'sitio_id', '')::uuid;
    v_seccion_id := nullif(p_datos ->> 'seccion_id', '')::uuid;
    v_wifi_ap_id := nullif(p_datos ->> 'wifi_ap_id', '')::uuid;
    v_version := 1;
    v_token := replace(gen_random_uuid()::text, '-', '')
               || replace(gen_random_uuid()::text, '-', '');
    v_payload := 'SIQR1.' || v_punto_id::text || '.' || v_version::text || '.' || v_token;
    v_payload_hash := encode(extensions.digest(convert_to(v_payload, 'UTF8'), 'sha256'), 'hex');
  elsif p_accion in ('actualizar_punto', 'rotar_codigo', 'obtener_codigo') then
    v_punto_id := nullif(p_datos ->> 'punto_id', '')::uuid;
    select p.sitio_id, p.seccion_id, p.wifi_ap_id, p.qr_version
      into v_sitio_id, v_seccion_id, v_wifi_ap_id, v_version
    from public.puntos_rondin p
    where p.id = v_punto_id
    for update;
    if not found then
      raise exception using errcode = 'P0002', message = 'PUNTO_NO_ENCONTRADO';
    end if;
  else
    raise exception using errcode = '22023', message = 'ACCION_NO_PERMITIDA';
  end if;

  if p_accion in ('crear_punto', 'actualizar_punto') then
    if p_accion = 'actualizar_punto' then
      if nullif(p_datos ->> 'sitio_id', '')::uuid is distinct from v_sitio_id then
        raise exception using errcode = '22023', message = 'NO_SE_PUEDE_MOVER_EL_PUNTO_DE_SITIO';
      end if;
      v_seccion_id := nullif(p_datos ->> 'seccion_id', '')::uuid;
      v_wifi_ap_id := nullif(p_datos ->> 'wifi_ap_id', '')::uuid;
    end if;

    if not exists (select 1 from public.sitios where id = v_sitio_id and activo = true) then
      raise exception using errcode = '22023', message = 'SITIO_INVALIDO';
    end if;
    if not exists (
      select 1 from public.secciones_sitio
      where id = v_seccion_id and sitio_id = v_sitio_id and activo = true
    ) then
      raise exception using errcode = '22023', message = 'SECCION_INVALIDA';
    end if;
    if v_wifi_ap_id is not null and not exists (
      select 1 from public.sitio_wifi_aps
      where id = v_wifi_ap_id and sitio_id = v_sitio_id and activo = true
    ) then
      raise exception using errcode = '22023', message = 'WIFI_INVALIDO';
    end if;

    v_orden := coalesce((p_datos ->> 'orden')::integer, 1);
    v_min_segundos := coalesce(
      (p_datos ->> 'segundos_minimos_desde_anterior')::integer, 0
    );
    v_max_segundos := greatest(
      coalesce((p_datos ->> 'segundos_maximos_desde_anterior')::integer, 3600),
      v_min_segundos
    );

    if p_accion = 'crear_punto' then
      insert into public.puntos_rondin (
        id, sitio_id, seccion_id, nombre, descripcion, lat, lng, radio_metros,
        wifi_ap_id, requiere_liveness, activo, qr_version, token_hash,
        created_by, updated_by
      ) values (
        v_punto_id,
        v_sitio_id,
        v_seccion_id,
        btrim(coalesce(p_datos ->> 'nombre', '')),
        btrim(coalesce(p_datos ->> 'descripcion', '')),
        nullif(p_datos ->> 'lat', '')::numeric,
        nullif(p_datos ->> 'lng', '')::numeric,
        coalesce((p_datos ->> 'radio_metros')::integer, 35),
        v_wifi_ap_id,
        coalesce((p_datos ->> 'requiere_liveness')::boolean, false),
        coalesce((p_datos ->> 'activo')::boolean, true),
        v_version,
        v_payload_hash,
        p_actor_id,
        p_actor_id
      );

      insert into private.puntos_rondin_secretos (
        punto_id, qr_version, token, payload_hash, activo, created_by
      ) values (
        v_punto_id, v_version, v_token, v_payload_hash, true, p_actor_id
      );
    else
      update public.puntos_rondin
      set seccion_id = v_seccion_id,
          nombre = btrim(coalesce(p_datos ->> 'nombre', nombre)),
          descripcion = btrim(coalesce(p_datos ->> 'descripcion', descripcion)),
          lat = nullif(p_datos ->> 'lat', '')::numeric,
          lng = nullif(p_datos ->> 'lng', '')::numeric,
          radio_metros = coalesce((p_datos ->> 'radio_metros')::integer, radio_metros),
          wifi_ap_id = v_wifi_ap_id,
          requiere_liveness = coalesce(
            (p_datos ->> 'requiere_liveness')::boolean,
            requiere_liveness
          ),
          activo = coalesce((p_datos ->> 'activo')::boolean, activo),
          updated_by = p_actor_id
      where id = v_punto_id;
    end if;

    select id into v_ruta_id
    from public.rutas_rondin
    where sitio_id = v_sitio_id
      and activo = true
      and lower(btrim(nombre)) = lower('Rondin general')
    limit 1
    for update;

    if v_ruta_id is null then
      begin
        insert into public.rutas_rondin (
          sitio_id, nombre, descripcion, orden_aleatorio, activo,
          created_by, updated_by
        ) values (
          v_sitio_id,
          'Rondin general',
          'Ruta creada automaticamente desde el panel de puntos QR.',
          false,
          true,
          p_actor_id,
          p_actor_id
        ) returning id into v_ruta_id;
      exception when unique_violation then
        select id into v_ruta_id
        from public.rutas_rondin
        where sitio_id = v_sitio_id
          and activo = true
          and lower(btrim(nombre)) = lower('Rondin general')
        limit 1;
      end;
    end if;

    insert into public.ruta_rondin_puntos (
      sitio_id, ruta_id, punto_id, orden, obligatorio,
      segundos_minimos_desde_anterior, segundos_maximos_desde_anterior
    ) values (
      v_sitio_id,
      v_ruta_id,
      v_punto_id,
      v_orden,
      true,
      v_min_segundos,
      v_max_segundos
    )
    on conflict (ruta_id, punto_id) do update
      set orden = excluded.orden,
          segundos_minimos_desde_anterior = excluded.segundos_minimos_desde_anterior,
          segundos_maximos_desde_anterior = excluded.segundos_maximos_desde_anterior,
          updated_at = now();

    select (to_jsonb(p) - 'token_hash') || jsonb_build_object(
             'orden', rp.orden,
             'segundos_minimos_desde_anterior', rp.segundos_minimos_desde_anterior,
             'segundos_maximos_desde_anterior', rp.segundos_maximos_desde_anterior
           )
      into v_punto
    from public.puntos_rondin p
    join public.ruta_rondin_puntos rp
      on rp.punto_id = p.id and rp.ruta_id = v_ruta_id
    where p.id = v_punto_id;

    insert into public.admin_rondin_auditoria (actor_id, punto_id, accion, metadata)
    values (
      p_actor_id,
      v_punto_id,
      case when p_accion = 'crear_punto' then 'CREAR_PUNTO' else 'ACTUALIZAR_PUNTO' end,
      jsonb_build_object('sitio_id', v_sitio_id, 'ruta_id', v_ruta_id)
    );

    return jsonb_build_object(
      'punto', v_punto,
      'qr_payload', case when p_accion = 'crear_punto' then v_payload else null end
    );
  end if;

  if p_accion = 'rotar_codigo' then
    update private.puntos_rondin_secretos
    set activo = false, rotated_at = now()
    where punto_id = v_punto_id and activo = true;

    v_version := v_version + 1;
    v_token := replace(gen_random_uuid()::text, '-', '')
               || replace(gen_random_uuid()::text, '-', '');
    v_payload := 'SIQR1.' || v_punto_id::text || '.' || v_version::text || '.' || v_token;
    v_payload_hash := encode(extensions.digest(convert_to(v_payload, 'UTF8'), 'sha256'), 'hex');

    insert into private.puntos_rondin_secretos (
      punto_id, qr_version, token, payload_hash, activo, created_by
    ) values (
      v_punto_id, v_version, v_token, v_payload_hash, true, p_actor_id
    );
    update public.puntos_rondin
    set qr_version = v_version,
        token_hash = v_payload_hash,
        updated_by = p_actor_id
    where id = v_punto_id;

    insert into public.admin_rondin_auditoria (actor_id, punto_id, accion, metadata)
    values (
      p_actor_id, v_punto_id, 'ROTAR_CODIGO',
      jsonb_build_object('qr_version', v_version)
    );
  else
    select s.token,
           'SIQR1.' || s.punto_id::text || '.' || s.qr_version::text || '.' || s.token,
           s.payload_hash,
           s.qr_version
      into v_token, v_payload, v_payload_hash, v_version
    from private.puntos_rondin_secretos s
    where s.punto_id = v_punto_id and s.activo = true
    order by s.qr_version desc
    limit 1;
    if not found then
      raise exception using errcode = 'P0002', message = 'CODIGO_NO_ENCONTRADO';
    end if;
    if v_payload_hash <> encode(
      extensions.digest(convert_to(v_payload, 'UTF8'), 'sha256'), 'hex'
    ) then
      raise exception using errcode = 'XX001', message = 'CODIGO_INCONSISTENTE';
    end if;

    insert into public.admin_rondin_auditoria (actor_id, punto_id, accion, metadata)
    values (
      p_actor_id, v_punto_id, 'OBTENER_CODIGO',
      jsonb_build_object('qr_version', v_version)
    );
  end if;

  select (to_jsonb(p) - 'token_hash') || coalesce((
           select jsonb_build_object(
             'orden', rp.orden,
             'segundos_minimos_desde_anterior', rp.segundos_minimos_desde_anterior,
             'segundos_maximos_desde_anterior', rp.segundos_maximos_desde_anterior
           )
           from public.ruta_rondin_puntos rp
           join public.rutas_rondin r on r.id = rp.ruta_id and r.activo = true
           where rp.punto_id = p.id
           order by rp.created_at
           limit 1
         ), '{}'::jsonb)
    into v_punto
  from public.puntos_rondin p
  where p.id = v_punto_id;

  return jsonb_build_object('punto', v_punto, 'qr_payload', v_payload);
exception
  when unique_violation then
    raise exception using errcode = '23505', message = 'ORDEN_O_NOMBRE_DUPLICADO';
end;
$$;

revoke all on function private.administrar_punto_rondin_servidor(uuid, text, jsonb)
  from public, anon, authenticated, service_role;
grant usage on schema private to service_role;
grant execute on function private.administrar_punto_rondin_servidor(uuid, text, jsonb)
  to service_role;

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

  -- La auditoria deliberadamente no duplica el motivo.
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

-- Wrapper expuesto sin privilegios elevados. PostgREST solo ve public; la
-- implementacion SECURITY DEFINER permanece en private y solo service_role
-- puede invocarla.
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

-- Valida e inserta un rondin completo en una sola transaccion. La funcion
-- recibe un usuario ya autenticado por la Edge Function, pero vuelve a validar
-- perfil, password, rol y acceso al sitio antes de tocar evidencia.
create or replace function private.sincronizar_rondin_servidor(
  p_usuario_id uuid,
  p_rondin jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, public, private, extensions, pg_temp
as $$
declare
  v_local_id text;
  v_sitio_id uuid;
  v_ruta_reportada_id uuid;
  v_ruta_id uuid;
  v_turno_reportado_id uuid;
  v_turno_id uuid;
  v_device_id text;
  v_turno_fecha date;
  v_inicio timestamptz;
  v_fin timestamptz;
  v_inicio_monotonic bigint;
  v_fin_monotonic bigint;
  v_input_hash text;
  v_existente_id uuid;
  v_existente_hash text;
  v_rol public.rol_usuario;
  v_ruta_activa boolean;
  v_orden_aleatorio boolean := false;
  v_minutos_minimos integer := 0;
  v_minutos_maximos integer := 180;
  v_codigos text[] := '{}';
  v_riesgo integer := 0;
  v_estado text;
  v_tiene_rechazada boolean := false;
  v_tiene_pendiente boolean := false;
  v_esperados integer := 0;
  v_recibidos integer := 0;
  v_rondin_id uuid;
  v_lecturas_evaluadas jsonb := '[]'::jsonb;
  v_lectura jsonb;
  v_eval jsonb;
  v_total_lecturas integer;
  v_local_lectura text;
  v_punto_reportado_id uuid;
  v_punto_id uuid;
  v_secuencia integer;
  v_capturado timestamptz;
  v_monotonic bigint;
  v_boot_count integer;
  v_lat numeric;
  v_lng numeric;
  v_accuracy numeric;
  v_gps_age integer;
  v_gps_mocked boolean;
  v_wifi_bssid text;
  v_wifi_ssid text;
  v_token_version integer;
  v_qr_hash text;
  v_hora_automatica boolean;
  v_opciones_desarrollador boolean;
  v_adb_activo boolean;
  v_hash_anterior text;
  v_hash_evento text;
  v_liveness_passed boolean;
  v_point_activo boolean;
  v_point_lat numeric;
  v_point_lng numeric;
  v_radio integer;
  v_wifi_ap_id uuid;
  v_requiere_liveness boolean;
  v_wifi_esperado text;
  v_paso_orden integer;
  v_min_segundos integer;
  v_max_segundos integer;
  v_qr_valido boolean;
  v_distancia numeric;
  v_dentro boolean;
  v_wifi_ok boolean;
  v_lectura_codigos text[];
  v_lectura_riesgo integer;
  v_lectura_estado text;
  v_lectura_fatal boolean;
  v_delta_monotonic numeric;
  v_delta_pared numeric;
  v_prev_monotonic bigint;
  v_prev_capturado timestamptz;
  v_prev_boot integer;
  v_prev_hash_evento text;
  v_puntos_vistos uuid[] := '{}';
  v_secuencias_vistas integer[] := '{}';
  v_locales_vistos text[] := '{}';
  v_codigo text;
begin
  if jsonb_typeof(p_rondin) <> 'object' then
    raise exception using errcode = '22023', message = 'RONDIN_INVALIDO';
  end if;

  select p.rol into v_rol
  from public.profiles p
  where p.id = p_usuario_id
    and p.activo = true
    and p.estado_laboral in ('activo', 'reingreso')
    and p.debe_cambiar_password = false;
  if not found or v_rol not in ('elemento', 'supervisor', 'admin') then
    raise exception using errcode = '42501', message = 'PERFIL_NO_AUTORIZADO';
  end if;

  v_local_id := btrim(coalesce(p_rondin ->> 'local_id', ''));
  v_sitio_id := nullif(p_rondin ->> 'sitio_id', '')::uuid;
  v_ruta_reportada_id := nullif(p_rondin ->> 'ruta_id', '')::uuid;
  v_turno_reportado_id := nullif(p_rondin ->> 'turno_id', '')::uuid;
  v_device_id := btrim(coalesce(p_rondin ->> 'device_id', ''));
  v_turno_fecha := nullif(p_rondin ->> 'turno_fecha', '')::date;
  v_inicio := nullif(p_rondin ->> 'iniciado_at_dispositivo', '')::timestamptz;
  v_fin := nullif(p_rondin ->> 'finalizado_at_dispositivo', '')::timestamptz;
  v_inicio_monotonic := nullif(p_rondin ->> 'iniciado_monotonic_ms', '')::bigint;
  v_fin_monotonic := nullif(p_rondin ->> 'finalizado_monotonic_ms', '')::bigint;

  if char_length(v_local_id) not between 8 and 100
     or v_sitio_id is null
     or v_ruta_reportada_id is null
     or char_length(v_device_id) not between 1 and 200
     or v_inicio is null
     or v_inicio_monotonic is null
     or v_inicio_monotonic < 0 then
    raise exception using errcode = '22023', message = 'CAMPOS_RONDIN_INVALIDOS';
  end if;

  if not exists (
    select 1 from public.sitios s where s.id = v_sitio_id and s.activo = true
  ) then
    raise exception using errcode = '22023', message = 'SITIO_INVALIDO';
  end if;
  if v_rol <> 'admin' and not exists (
    select 1 from public.usuario_sitios us
    where us.usuario_id = p_usuario_id and us.sitio_id = v_sitio_id
  ) then
    raise exception using errcode = '42501', message = 'SITIO_NO_AUTORIZADO';
  end if;

  if jsonb_typeof(p_rondin -> 'lecturas') <> 'array' then
    raise exception using errcode = '22023', message = 'LECTURAS_INVALIDAS';
  end if;
  v_total_lecturas := jsonb_array_length(p_rondin -> 'lecturas');
  if v_total_lecturas < 1 or v_total_lecturas > 200 then
    raise exception using errcode = '22023', message = 'CANTIDAD_LECTURAS_INVALIDA';
  end if;

  v_input_hash := encode(
    extensions.digest(convert_to(p_rondin::text, 'UTF8'), 'sha256'),
    'hex'
  );
  select r.id, r.payload_hash
    into v_existente_id, v_existente_hash
  from public.rondines r
  where r.usuario_id = p_usuario_id and r.local_id = v_local_id;
  if found then
    if v_existente_hash <> v_input_hash then
      raise exception using errcode = '23505', message = 'IDEMPOTENCIA_CONFLICTO';
    end if;
    return private.resultado_rondin_json(v_existente_id);
  end if;

  select r.id, r.activo, r.orden_aleatorio, r.minutos_minimos, r.minutos_maximos
    into v_ruta_id, v_ruta_activa, v_orden_aleatorio,
         v_minutos_minimos, v_minutos_maximos
  from public.rutas_rondin r
  where r.id = v_ruta_reportada_id and r.sitio_id = v_sitio_id;
  if not found then
    v_ruta_id := null;
    v_codigos := private.rondin_agregar_codigo(v_codigos, 'RUTA_INVALIDA');
    v_riesgo := 100;
  elsif not v_ruta_activa then
    v_codigos := private.rondin_agregar_codigo(v_codigos, 'RUTA_DESACTUALIZADA');
    v_riesgo := greatest(v_riesgo, 25);
  end if;

  if v_turno_reportado_id is not null then
    select t.id into v_turno_id
    from public.turnos t
    where t.id = v_turno_reportado_id
      and t.usuario_id = p_usuario_id
      and t.sitio_id = v_sitio_id
      and t.inicio_at <= v_inicio + interval '30 minutes'
      and (t.fin_at is null or v_inicio <= t.fin_at + interval '30 minutes')
    limit 1;
  else
    select t.id into v_turno_id
    from public.turnos t
    where t.usuario_id = p_usuario_id
      and t.sitio_id = v_sitio_id
      and t.inicio_at <= v_inicio + interval '30 minutes'
      and (t.fin_at is null or v_inicio <= t.fin_at + interval '30 minutes')
    order by t.inicio_at desc
    limit 1;
  end if;
  if v_turno_id is null then
    v_codigos := private.rondin_agregar_codigo(v_codigos, 'SIN_TURNO_VALIDO');
    v_riesgo := 100;
  end if;

  if v_inicio > now() + interval '10 minutes' then
    v_codigos := private.rondin_agregar_codigo(v_codigos, 'INICIO_EN_EL_FUTURO');
    v_riesgo := greatest(v_riesgo, 60);
  elsif v_inicio < now() - interval '30 days' then
    v_codigos := private.rondin_agregar_codigo(v_codigos, 'SINCRONIZACION_MUY_TARDIA');
    v_riesgo := greatest(v_riesgo, 40);
  end if;
  if v_fin is null then
    v_codigos := private.rondin_agregar_codigo(v_codigos, 'RONDIN_SIN_CIERRE');
    v_riesgo := greatest(v_riesgo, 50);
  elsif v_fin < v_inicio - interval '5 minutes' then
    raise exception using errcode = '22023', message = 'FECHAS_RONDIN_INVALIDAS';
  end if;

  if v_ruta_id is not null then
    select count(*)::integer into v_esperados
    from public.ruta_rondin_puntos rp
    join public.puntos_rondin p on p.id = rp.punto_id
    where rp.ruta_id = v_ruta_id and rp.obligatorio = true and p.activo = true;
  end if;

  v_prev_monotonic := v_inicio_monotonic;
  v_prev_capturado := v_inicio;

  for v_lectura in
    select value
    from jsonb_array_elements(p_rondin -> 'lecturas') value
    order by (value ->> 'secuencia')::integer
  loop
    v_local_lectura := btrim(coalesce(v_lectura ->> 'local_id', ''));
    v_punto_reportado_id := nullif(v_lectura ->> 'punto_id', '')::uuid;
    v_secuencia := nullif(v_lectura ->> 'secuencia', '')::integer;
    v_capturado := nullif(v_lectura ->> 'capturado_at_dispositivo', '')::timestamptz;
    v_monotonic := nullif(v_lectura ->> 'monotonic_ms', '')::bigint;
    v_boot_count := coalesce((v_lectura ->> 'boot_count')::integer, 0);
    v_lat := nullif(v_lectura ->> 'lat', '')::numeric;
    v_lng := nullif(v_lectura ->> 'lng', '')::numeric;
    v_accuracy := nullif(v_lectura ->> 'gps_accuracy_m', '')::numeric;
    v_gps_age := nullif(v_lectura ->> 'gps_age_ms', '')::integer;
    v_gps_mocked := coalesce(
      (v_lectura ->> 'ubicacion_simulada')::boolean,
      (v_lectura ->> 'gps_is_mocked')::boolean,
      false
    );
    v_wifi_bssid := nullif(lower(btrim(v_lectura ->> 'wifi_bssid')), '');
    v_wifi_ssid := nullif(btrim(v_lectura ->> 'wifi_ssid'), '');
    v_token_version := nullif(v_lectura ->> 'token_version', '')::integer;
    v_qr_hash := lower(btrim(coalesce(v_lectura ->> 'qr_payload_hash', '')));
    v_hora_automatica := coalesce((v_lectura ->> 'hora_automatica')::boolean, true);
    v_opciones_desarrollador := coalesce(
      (v_lectura ->> 'opciones_desarrollador')::boolean, false
    );
    v_adb_activo := coalesce((v_lectura ->> 'adb_activo')::boolean, false);
    v_hash_anterior := nullif(lower(btrim(v_lectura ->> 'hash_anterior')), '');
    v_hash_evento := lower(btrim(coalesce(v_lectura ->> 'hash_evento', '')));
    v_liveness_passed := (v_lectura ->> 'liveness_passed')::boolean;

    if char_length(v_local_lectura) not between 8 and 100
       or v_punto_reportado_id is null
       or v_secuencia is null or v_secuencia < 1
       or v_capturado is null
       or v_monotonic is null or v_monotonic < 0
       or v_token_version is null or v_token_version < 1
       or v_qr_hash !~ '^[0-9a-f]{64}$'
       or v_hash_evento !~ '^[0-9a-f]{64}$'
       or (v_hash_anterior is not null and v_hash_anterior !~ '^[0-9a-f]{64}$') then
      raise exception using errcode = '22023', message = 'LECTURA_MALFORMADA';
    end if;
    if v_local_lectura = any(v_locales_vistos)
       or v_punto_reportado_id = any(v_puntos_vistos)
       or v_secuencia = any(v_secuencias_vistas) then
      raise exception using errcode = '23505', message = 'LECTURA_DUPLICADA';
    end if;
    v_locales_vistos := array_append(v_locales_vistos, v_local_lectura);
    v_puntos_vistos := array_append(v_puntos_vistos, v_punto_reportado_id);
    v_secuencias_vistas := array_append(v_secuencias_vistas, v_secuencia);

    v_lectura_codigos := '{}';
    v_lectura_riesgo := 0;
    v_lectura_fatal := false;
    v_punto_id := null;
    v_point_activo := false;
    v_point_lat := null;
    v_point_lng := null;
    v_radio := null;
    v_wifi_ap_id := null;
    v_requiere_liveness := false;
    v_wifi_esperado := null;
    v_paso_orden := null;
    v_min_segundos := null;
    v_max_segundos := null;
    v_qr_valido := false;
    v_distancia := null;
    v_dentro := false;
    v_wifi_ok := false;

    select p.id, p.activo, p.lat, p.lng, p.radio_metros,
           p.wifi_ap_id, p.requiere_liveness
      into v_punto_id, v_point_activo, v_point_lat, v_point_lng, v_radio,
           v_wifi_ap_id, v_requiere_liveness
    from public.puntos_rondin p
    where p.id = v_punto_reportado_id and p.sitio_id = v_sitio_id;

    if v_punto_id is null then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'PUNTO_DESCONOCIDO'
      );
      v_lectura_riesgo := 100;
      v_lectura_fatal := true;
    else
      if not v_point_activo then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'PUNTO_DESACTUALIZADO'
        );
        v_lectura_riesgo := greatest(v_lectura_riesgo, 25);
      end if;

      select rp.orden,
             rp.segundos_minimos_desde_anterior,
             rp.segundos_maximos_desde_anterior
        into v_paso_orden, v_min_segundos, v_max_segundos
      from public.ruta_rondin_puntos rp
      where rp.ruta_id = v_ruta_id and rp.punto_id = v_punto_id;
      if v_paso_orden is null then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'PUNTO_FUERA_DE_RUTA'
        );
        v_lectura_riesgo := 100;
        v_lectura_fatal := true;
      elsif not v_orden_aleatorio and v_paso_orden <> v_secuencia then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'ORDEN_INCORRECTO'
        );
        v_lectura_riesgo := greatest(v_lectura_riesgo, 35);
      end if;

      select exists (
        select 1
        from private.puntos_rondin_secretos s
        where s.punto_id = v_punto_id
          and s.qr_version = v_token_version
          and s.payload_hash = v_qr_hash
          and s.created_at <= v_capturado + interval '10 minutes'
          and (s.rotated_at is null or v_capturado <= s.rotated_at + interval '10 minutes')
      ) into v_qr_valido;
      if not v_qr_valido then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'QR_INVALIDO_O_ROTADO'
        );
        v_lectura_riesgo := 100;
        v_lectura_fatal := true;
      end if;
    end if;

    if v_secuencia <> cardinality(v_secuencias_vistas) then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'SECUENCIA_NO_CONTIGUA'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 40);
    end if;

    if v_gps_mocked then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'GPS_SIMULADO'
      );
      v_lectura_riesgo := 100;
      v_lectura_fatal := true;
    end if;
    if v_lat is null or v_lng is null then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'GPS_NO_DISPONIBLE'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 50);
    elsif v_point_lat is null or v_point_lng is null then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'PUNTO_SIN_COORDENADAS'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 30);
    else
      v_distancia := private.rondin_distancia_m(v_lat, v_lng, v_point_lat, v_point_lng);
      v_dentro := v_distancia <= v_radio + least(coalesce(v_accuracy, 0), 75);
      if not v_dentro then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'FUERA_DE_GEOCERCA'
        );
        v_lectura_riesgo := greatest(v_lectura_riesgo, 85);
        v_lectura_fatal := true;
      end if;
    end if;
    if v_accuracy is null or v_accuracy > 80 then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'GPS_BAJA_PRECISION'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 30);
    end if;
    if v_gps_age is null or v_gps_age > 60000 then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'GPS_ANTIGUO'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 25);
    end if;

    if v_wifi_ap_id is not null then
      select lower(btrim(w.bssid)) into v_wifi_esperado
      from public.sitio_wifi_aps w
      where w.id = v_wifi_ap_id and w.sitio_id = v_sitio_id and w.activo = true;
      v_wifi_ok := v_wifi_esperado is not null and v_wifi_bssid = v_wifi_esperado;
      if not v_wifi_ok then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'WIFI_NO_COINCIDE'
        );
        v_lectura_riesgo := greatest(v_lectura_riesgo, 30);
      end if;
    end if;

    if v_requiere_liveness and v_liveness_passed is distinct from true then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'LIVENESS_REQUERIDA'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 45);
    end if;
    if not v_hora_automatica then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'HORA_NO_AUTOMATICA'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 35);
    end if;
    if v_opciones_desarrollador then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'OPCIONES_DESARROLLADOR'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 15);
    end if;
    if v_adb_activo then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'ADB_ACTIVO'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 20);
    end if;

    if v_capturado < v_inicio - interval '5 minutes'
       or (v_fin is not null and v_capturado > v_fin + interval '5 minutes')
       or v_capturado > now() + interval '10 minutes' then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'TIEMPO_CAPTURA_INVALIDO'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 80);
      v_lectura_fatal := true;
    end if;

    if v_prev_boot is not null and v_boot_count <> v_prev_boot then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'DISPOSITIVO_REINICIADO'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 35);
    else
      v_delta_monotonic := (v_monotonic - v_prev_monotonic) / 1000.0;
      v_delta_pared := extract(epoch from (v_capturado - v_prev_capturado));
      if v_delta_monotonic < 0 then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'RELOJ_MONOTONO_INVALIDO'
        );
        v_lectura_riesgo := 100;
        v_lectura_fatal := true;
      elsif abs(v_delta_pared - v_delta_monotonic) > 120 then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'CAMBIO_RELOJ_DETECTADO'
        );
        v_lectura_riesgo := greatest(v_lectura_riesgo, 55);
      end if;
      if v_secuencia > 1 and v_min_segundos is not null
         and v_delta_monotonic < v_min_segundos then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'TRASLADO_DEMASIADO_RAPIDO'
        );
        v_lectura_riesgo := greatest(v_lectura_riesgo, 85);
        v_lectura_fatal := true;
      elsif v_secuencia > 1 and v_max_segundos is not null
            and v_delta_monotonic > v_max_segundos then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'TRASLADO_DEMASIADO_LENTO'
        );
        v_lectura_riesgo := greatest(v_lectura_riesgo, 25);
      end if;
    end if;

    if v_secuencia = 1 then
      if v_hash_anterior is not null then
        v_lectura_codigos := private.rondin_agregar_codigo(
          v_lectura_codigos, 'CADENA_HASH_INVALIDA'
        );
        v_lectura_riesgo := greatest(v_lectura_riesgo, 45);
      end if;
    elsif v_hash_anterior is distinct from v_prev_hash_evento then
      v_lectura_codigos := private.rondin_agregar_codigo(
        v_lectura_codigos, 'CADENA_HASH_ROTA'
      );
      v_lectura_riesgo := greatest(v_lectura_riesgo, 55);
    end if;

    if v_lectura_fatal then
      v_lectura_estado := 'rechazado';
      v_tiene_rechazada := true;
    elsif v_lectura_riesgo > 0 then
      v_lectura_estado := 'pendiente_revision';
      v_tiene_pendiente := true;
    else
      v_lectura_estado := 'validado';
    end if;

    if v_qr_valido and v_paso_orden is not null then
      v_recibidos := v_recibidos + 1;
    end if;
    v_riesgo := greatest(v_riesgo, v_lectura_riesgo);
    foreach v_codigo in array v_lectura_codigos loop
      v_codigos := private.rondin_agregar_codigo(v_codigos, v_codigo);
    end loop;

    v_eval := v_lectura || jsonb_build_object(
      'punto_id_validado', v_punto_id,
      'gps_is_mocked', v_gps_mocked,
      'qr_valido', v_qr_valido,
      'distancia_punto_m', v_distancia,
      'dentro_geocerca', v_dentro,
      'wifi_reconocido', v_wifi_ok,
      'estado_validacion', v_lectura_estado,
      'puntaje_riesgo', v_lectura_riesgo,
      'codigos_riesgo', to_jsonb(v_lectura_codigos)
    );
    v_lecturas_evaluadas := v_lecturas_evaluadas || jsonb_build_array(v_eval);

    v_prev_monotonic := v_monotonic;
    v_prev_capturado := v_capturado;
    v_prev_boot := v_boot_count;
    v_prev_hash_evento := v_hash_evento;
    if nullif(p_rondin ->> 'finalizado_monotonic_ms', '') is null then
      v_fin_monotonic := v_monotonic;
    end if;
  end loop;

  if v_recibidos < v_esperados then
    v_codigos := private.rondin_agregar_codigo(v_codigos, 'PUNTOS_FALTANTES');
    v_riesgo := greatest(v_riesgo, 85);
    v_tiene_rechazada := true;
  end if;
  if v_ruta_id is null or v_turno_id is null then
    v_tiene_rechazada := true;
  end if;

  if v_fin_monotonic is not null and v_fin_monotonic >= v_inicio_monotonic then
    if (v_fin_monotonic - v_inicio_monotonic) < v_minutos_minimos * 60000::bigint then
      v_codigos := private.rondin_agregar_codigo(v_codigos, 'RONDIN_DEMASIADO_RAPIDO');
      v_riesgo := greatest(v_riesgo, 85);
      v_tiene_rechazada := true;
    elsif (v_fin_monotonic - v_inicio_monotonic) > v_minutos_maximos * 60000::bigint then
      v_codigos := private.rondin_agregar_codigo(v_codigos, 'RONDIN_DEMASIADO_LENTO');
      v_riesgo := greatest(v_riesgo, 30);
      v_tiene_pendiente := true;
    end if;
  end if;

  if v_tiene_rechazada then
    v_estado := 'rechazado';
  elsif v_tiene_pendiente or v_riesgo > 0 then
    v_estado := 'pendiente_revision';
  else
    v_estado := 'validado';
  end if;

  insert into public.rondines (
    local_id, usuario_id, sitio_id, turno_id, ruta_id, ruta_reportada_id,
    device_id, turno_fecha, iniciado_at_dispositivo, iniciado_monotonic_ms,
    finalizado_at_dispositivo, finalizado_monotonic_ms, estado_validacion,
    puntaje_riesgo, codigos_riesgo, puntos_esperados, puntos_recibidos,
    payload_hash
  ) values (
    v_local_id, p_usuario_id, v_sitio_id, v_turno_id, v_ruta_id,
    v_ruta_reportada_id, v_device_id, v_turno_fecha, v_inicio,
    v_inicio_monotonic, v_fin, v_fin_monotonic, v_estado, v_riesgo,
    v_codigos, v_esperados, v_recibidos, v_input_hash
  )
  returning id into v_rondin_id;

  for v_eval in select value from jsonb_array_elements(v_lecturas_evaluadas) value
  loop
    insert into public.rondin_lecturas (
      rondin_id, local_id, punto_id, punto_reportado_id, secuencia,
      capturado_at_dispositivo, monotonic_ms, boot_count, lat, lng,
      gps_accuracy_m, gps_age_ms, gps_is_mocked, wifi_bssid, wifi_ssid,
      token_version, qr_payload_hash, hora_automatica,
      opciones_desarrollador, adb_activo, hash_anterior, hash_evento,
      liveness_passed, qr_valido, distancia_punto_m, dentro_geocerca,
      wifi_reconocido, estado_validacion, puntaje_riesgo, codigos_riesgo
    ) values (
      v_rondin_id,
      v_eval ->> 'local_id',
      nullif(v_eval ->> 'punto_id_validado', '')::uuid,
      (v_eval ->> 'punto_id')::uuid,
      (v_eval ->> 'secuencia')::integer,
      (v_eval ->> 'capturado_at_dispositivo')::timestamptz,
      (v_eval ->> 'monotonic_ms')::bigint,
      coalesce((v_eval ->> 'boot_count')::integer, 0),
      nullif(v_eval ->> 'lat', '')::numeric,
      nullif(v_eval ->> 'lng', '')::numeric,
      nullif(v_eval ->> 'gps_accuracy_m', '')::numeric,
      nullif(v_eval ->> 'gps_age_ms', '')::integer,
      (v_eval ->> 'gps_is_mocked')::boolean,
      nullif(lower(btrim(v_eval ->> 'wifi_bssid')), ''),
      nullif(btrim(v_eval ->> 'wifi_ssid'), ''),
      (v_eval ->> 'token_version')::integer,
      lower(v_eval ->> 'qr_payload_hash'),
      coalesce((v_eval ->> 'hora_automatica')::boolean, true),
      coalesce((v_eval ->> 'opciones_desarrollador')::boolean, false),
      coalesce((v_eval ->> 'adb_activo')::boolean, false),
      nullif(lower(btrim(v_eval ->> 'hash_anterior')), ''),
      lower(v_eval ->> 'hash_evento'),
      (v_eval ->> 'liveness_passed')::boolean,
      (v_eval ->> 'qr_valido')::boolean,
      nullif(v_eval ->> 'distancia_punto_m', '')::numeric,
      (v_eval ->> 'dentro_geocerca')::boolean,
      (v_eval ->> 'wifi_reconocido')::boolean,
      v_eval ->> 'estado_validacion',
      (v_eval ->> 'puntaje_riesgo')::integer,
      array(select jsonb_array_elements_text(v_eval -> 'codigos_riesgo'))
    );
  end loop;

  return private.resultado_rondin_json(v_rondin_id);
exception
  when unique_violation then
    select r.id, r.payload_hash
      into v_existente_id, v_existente_hash
    from public.rondines r
    where r.usuario_id = p_usuario_id and r.local_id = v_local_id;
    if v_existente_id is not null and v_existente_hash = v_input_hash then
      return private.resultado_rondin_json(v_existente_id);
    end if;
    raise;
end;
$$;

revoke all on function private.sincronizar_rondin_servidor(uuid, jsonb)
  from public, anon, authenticated, service_role;
grant execute on function private.sincronizar_rondin_servidor(uuid, jsonb)
  to service_role;

create or replace function public.sincronizar_rondin_servidor(
  p_usuario_id uuid,
  p_rondin jsonb
)
returns jsonb
language sql
set search_path = pg_catalog, private, pg_temp
as $$
  select private.sincronizar_rondin_servidor(p_usuario_id, p_rondin);
$$;

revoke all on function public.sincronizar_rondin_servidor(uuid, jsonb)
  from public, anon, authenticated;
grant execute on function public.sincronizar_rondin_servidor(uuid, jsonb)
  to service_role;

-- RLS y privilegios. Los catálogos no contienen el token imprimible y ninguna
-- escritura del cliente llega directo: administración y evidencia pasan por
-- funciones de servidor auditadas.
alter table public.secciones_sitio enable row level security;
alter table public.puntos_rondin enable row level security;
alter table public.rutas_rondin enable row level security;
alter table public.ruta_rondin_puntos enable row level security;
alter table public.rondines enable row level security;
alter table public.rondin_lecturas enable row level security;
alter table public.rondin_revisiones enable row level security;
alter table public.admin_rondin_auditoria enable row level security;
alter table private.puntos_rondin_secretos enable row level security;

create policy secciones_sitio_select on public.secciones_sitio
  for select to authenticated
  using (public.tiene_acceso_sitio(sitio_id));

create policy puntos_rondin_select on public.puntos_rondin
  for select to authenticated
  using (public.tiene_acceso_sitio(sitio_id));
create policy rutas_rondin_select on public.rutas_rondin
  for select to authenticated
  using (public.tiene_acceso_sitio(sitio_id));
create policy ruta_rondin_puntos_select on public.ruta_rondin_puntos
  for select to authenticated
  using (public.tiene_acceso_sitio(sitio_id));

create policy rondines_select on public.rondines
  for select to authenticated
  using (
    usuario_id = (select auth.uid())
    or (
      (select public.rol_actual()) in ('supervisor', 'cliente', 'admin')
      and public.tiene_acceso_sitio(sitio_id)
    )
  );
create policy rondin_lecturas_select on public.rondin_lecturas
  for select to authenticated
  using (
    exists (
      select 1
      from public.rondines r
      where r.id = rondin_id
        and (
          r.usuario_id = (select auth.uid())
          or (
            (select public.rol_actual()) in ('supervisor', 'cliente', 'admin')
            and public.tiene_acceso_sitio(r.sitio_id)
          )
        )
    )
  );
create policy rondin_revisiones_select_admin on public.rondin_revisiones
  for select to authenticated
  using ((select public.es_admin()));
create policy admin_rondin_auditoria_select on public.admin_rondin_auditoria
  for select to authenticated
  using ((select public.es_admin()));

do $$
declare
  v_tabla text;
begin
  foreach v_tabla in array array[
    'secciones_sitio',
    'puntos_rondin',
    'rutas_rondin',
    'ruta_rondin_puntos',
    'rondines',
    'rondin_lecturas',
    'rondin_revisiones',
    'admin_rondin_auditoria'
  ]
  loop
    execute format(
      'create policy password_temporal_gate on public.%I as restrictive '
      'for all to authenticated using ((select public.sesion_operativa_habilitada())) '
      'with check ((select public.sesion_operativa_habilitada()))',
      v_tabla
    );
  end loop;
end
$$;

revoke all on table
  public.secciones_sitio,
  public.puntos_rondin,
  public.rutas_rondin,
  public.ruta_rondin_puntos,
  public.rondines,
  public.rondin_lecturas,
  public.rondin_revisiones,
  public.admin_rondin_auditoria
from public, anon, authenticated;

-- Ni siquiera service_role escribe el historial directamente: toda revision
-- debe pasar por private.revisar_rondin_servidor para validar y auditar.
revoke all on table public.rondin_revisiones from service_role;

grant select on table public.secciones_sitio to authenticated;
grant select on table
  public.rutas_rondin,
  public.ruta_rondin_puntos,
  public.rondines,
  public.rondin_lecturas,
  public.rondin_revisiones,
  public.admin_rondin_auditoria
to authenticated;

-- El hash vigente equivale a un verificador del secreto del QR. No forma parte
-- del catalogo descargable: los clientes solo reciben metadatos no sensibles.
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

-- Declaracion explicita para documentar lo unico que necesita el servidor.
-- Las funciones SECURITY DEFINER son las que escriben; estos grants permiten
-- ademas las lecturas administrativas realizadas desde las Edge Functions.
grant select, insert, update on table
  public.secciones_sitio,
  public.puntos_rondin,
  public.rutas_rondin,
  public.ruta_rondin_puntos
to service_role;
grant select, insert on table
  public.rondines,
  public.rondin_lecturas,
  public.admin_rondin_auditoria
to service_role;
