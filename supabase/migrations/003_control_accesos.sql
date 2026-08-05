-- ─────────────────────────────────────────────────────────────────────────────
-- 003: Control de acceso de visitantes.
--
-- El elemento registra a quien llega: nombre completo, a quién visita, asunto,
-- empresa de procedencia, vehículo y placas, y opcionalmente fotografía de una
-- identificación. Al salir, la pantalla lista "quién está adentro" y la salida
-- se da con un toque.
--
-- Protección de datos (LFPDPPP): la fotografía de la identificación es un dato
-- personal. Se le muestra al visitante un aviso de privacidad que debe aceptar
-- (con liga al texto completo), se guarda constancia de qué versión aceptó, y
-- la imagen se purga automáticamente a los 90 días — ver migración 007.
-- ─────────────────────────────────────────────────────────────────────────────

-- ─── TABLA: avisos_privacidad ────────────────────────────────────────────────
-- Versionado. Guardar QUÉ versión aceptó cada visitante es lo que hace
-- defendible el consentimiento si algún día lo reclaman.

create table if not exists public.avisos_privacidad (
  id          uuid primary key default gen_random_uuid(),
  version     text not null unique,
  titulo      text not null default 'Aviso de Privacidad',
  -- Texto corto que se muestra en pantalla antes de capturar la identificación.
  resumen     text not null,
  -- Liga al aviso integral, para el visitante que quiera leerlo completo.
  url_completo text not null default '',
  vigente_desde date not null default current_date,
  activo      boolean not null default true,
  created_at  timestamptz not null default now()
);

-- ─── TABLA: personal_cliente ─────────────────────────────────────────────────
-- Catálogo del personal de la fábrica al que se puede visitar. Lo mantiene el
-- cliente. Mientras esté vacío, el registro cae al campo de texto libre
-- `persona_visitada_texto`, así que la app es usable desde el día uno.

create table if not exists public.personal_cliente (
  id          uuid primary key default gen_random_uuid(),
  sitio_id    uuid not null references public.sitios(id) on delete cascade,
  nombre_completo text not null,
  area        text not null default '',
  puesto      text not null default '',
  extension   text not null default '',
  activo      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists idx_personal_cliente_sitio
  on public.personal_cliente (sitio_id) where activo = true;

create trigger personal_cliente_set_updated_at
  before update on public.personal_cliente
  for each row execute function public.set_updated_at();

-- ─── TABLA: visitantes ───────────────────────────────────────────────────────
-- Visitantes recurrentes (proveedores, transportistas de siempre). Evita
-- recapturar los mismos datos en cada visita: el elemento lo busca y precarga.

create table if not exists public.visitantes (
  id              uuid primary key default gen_random_uuid(),
  local_id        text not null unique,
  device_id       text not null default '',

  nombre_completo text not null,
  empresa         text not null default '',
  telefono        text not null default '',
  -- Placas habituales; en cada visita se confirma o se corrige.
  placas_habituales text not null default '',
  notas           text not null default '',

  es_frecuente    boolean not null default true,
  veces_registrado integer not null default 0,
  ultima_visita_at timestamptz,

  -- Lista negra: personas a las que no se les permite el acceso.
  vetado          boolean not null default false,
  motivo_veto     text not null default '',

  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  deleted_at      timestamptz,
  updated_by      uuid references public.profiles(id)
);

-- `'spanish'::regconfig` y no `'spanish'` a secas: `to_tsvector(text, text)` es
-- STABLE y Postgres no admite funciones STABLE en un índice. La sobrecarga que
-- recibe `regconfig` sí es IMMUTABLE.
create index if not exists idx_visitantes_nombre
  on public.visitantes using gin (to_tsvector('spanish'::regconfig, nombre_completo))
  where deleted_at is null;
create index if not exists idx_visitantes_empresa
  on public.visitantes (empresa) where deleted_at is null;

create trigger visitantes_set_updated_at
  before update on public.visitantes
  for each row execute function public.set_updated_at();

-- ─── TABLA: registros_acceso ─────────────────────────────────────────────────

create table if not exists public.registros_acceso (
  id                uuid primary key default gen_random_uuid(),
  local_id          text not null unique,
  device_id         text not null default '',

  sitio_id          uuid not null references public.sitios(id),
  turno_id          uuid references public.turnos(id),
  turno_fecha       date not null,
  -- Elemento que capturó el registro
  registrado_por    uuid not null references public.profiles(id),

  -- Si es un visitante recurrente queda ligado al catálogo; si no, los datos
  -- viven sólo aquí.
  visitante_id      uuid references public.visitantes(id),
  nombre_completo   text not null,
  empresa_procedencia text not null default '',
  telefono          text not null default '',

  -- A quién visita: preferimos el catálogo, con texto libre como respaldo.
  persona_visitada_id   uuid references public.personal_cliente(id),
  persona_visitada_texto text not null default '',
  asunto            text not null,

  -- Vehículo
  ingresa_vehiculo  boolean not null default false,
  placas            text not null default '',
  vehiculo_marca    text not null default '',
  vehiculo_modelo   text not null default '',
  vehiculo_color    text not null default '',

  -- Identificación (opcional). `identificacion_purgada` deja constancia de que
  -- la foto existió y se eliminó por política de retención, sin conservarla.
  identificacion_tipo   text not null default ''
                          check (identificacion_tipo in ('', 'ine', 'licencia',
                                                         'pasaporte', 'gafete_empresa', 'otro')),
  identificacion_foto_url text,
  identificacion_purgar_at timestamptz,
  identificacion_purgada   boolean not null default false,

  -- Consentimiento
  aviso_privacidad_id   uuid references public.avisos_privacidad(id),
  aviso_aceptado        boolean not null default false,
  aviso_aceptado_at     timestamptz,

  hora_entrada      timestamptz not null default now(),
  hora_salida       timestamptz,
  -- Quién le dio salida (puede ser otro elemento: los turnos son de 24 h pero
  -- la visita puede cruzar el cambio de turno).
  salida_registrada_por uuid references public.profiles(id),

  observaciones     text not null default '',

  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  deleted_at        timestamptz,
  updated_by        uuid references public.profiles(id)
);

-- Índice que sostiene la pantalla "quién está adentro ahora".
create index if not exists idx_accesos_dentro
  on public.registros_acceso (sitio_id, hora_entrada desc)
  where hora_salida is null and deleted_at is null;
create index if not exists idx_accesos_sitio_fecha
  on public.registros_acceso (sitio_id, turno_fecha desc) where deleted_at is null;
create index if not exists idx_accesos_placas
  on public.registros_acceso (placas) where deleted_at is null and placas <> '';
-- Soporta el barrido diario de purga de identificaciones.
create index if not exists idx_accesos_purga
  on public.registros_acceso (identificacion_purgar_at)
  where identificacion_purgada = false and identificacion_foto_url is not null;

create trigger registros_acceso_set_updated_at
  before update on public.registros_acceso
  for each row execute function public.set_updated_at();

-- ─── Lógica ──────────────────────────────────────────────────────────────────

-- Fija la fecha de purga de la identificación y la fecha operativa del turno.
create or replace function public.preparar_registro_acceso()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_sitio public.sitios%rowtype;
begin
  select * into v_sitio from public.sitios where id = new.sitio_id;

  if new.turno_fecha is null and found then
    new.turno_fecha := ((new.hora_entrada + make_interval(hours => v_sitio.huso_horario_offset_h))
                        - v_sitio.hora_inicio_turno)::date;
  end if;

  -- Retención de 90 días para la fotografía de la identificación.
  if new.identificacion_foto_url is not null and new.identificacion_purgar_at is null then
    new.identificacion_purgar_at := new.hora_entrada + interval '90 days';
  end if;

  return new;
end;
$$;

drop trigger if exists registros_acceso_preparar on public.registros_acceso;
create trigger registros_acceso_preparar
  before insert on public.registros_acceso
  for each row execute function public.preparar_registro_acceso();

-- Mantiene el contador del visitante recurrente.
create or replace function public.actualizar_visitante_recurrente()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if new.visitante_id is not null then
    update public.visitantes
       set veces_registrado = veces_registrado + 1,
           ultima_visita_at = new.hora_entrada
     where id = new.visitante_id;
  end if;
  return new;
end;
$$;

drop trigger if exists registros_acceso_visitante on public.registros_acceso;
create trigger registros_acceso_visitante
  after insert on public.registros_acceso
  for each row execute function public.actualizar_visitante_recurrente();

-- ─── VISTA: visitantes dentro de la planta ───────────────────────────────────

create or replace view public.v_visitantes_dentro
with (security_invoker = true)
as
select
  r.id,
  r.sitio_id,
  s.nombre                as sitio_nombre,
  r.nombre_completo,
  r.empresa_procedencia,
  r.asunto,
  coalesce(pc.nombre_completo, r.persona_visitada_texto) as persona_visitada,
  pc.area                 as area_visitada,
  r.placas,
  r.ingresa_vehiculo,
  r.hora_entrada,
  round(extract(epoch from (now() - r.hora_entrada)) / 3600.0, 1) as horas_dentro,
  r.identificacion_foto_url is not null as tiene_identificacion,
  p.nombre_completo       as registrado_por_nombre
from public.registros_acceso r
join public.sitios   s  on s.id  = r.sitio_id
join public.profiles p  on p.id  = r.registrado_por
left join public.personal_cliente pc on pc.id = r.persona_visitada_id
where r.hora_salida is null
  and r.deleted_at is null;

-- ─────────────────────────────────────────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.avisos_privacidad  enable row level security;
alter table public.personal_cliente   enable row level security;
alter table public.visitantes         enable row level security;
alter table public.registros_acceso   enable row level security;

-- El aviso vigente lo tiene que poder leer cualquiera que registre visitas.
drop policy if exists avisos_select on public.avisos_privacidad;
create policy avisos_select on public.avisos_privacidad
  for select to authenticated using (true);

drop policy if exists avisos_admin on public.avisos_privacidad;
create policy avisos_admin on public.avisos_privacidad
  for all to authenticated
  using (public.es_admin()) with check (public.es_admin());

-- Catálogo de personal: lo lee quien tenga acceso al sitio; lo mantiene el
-- cliente (es su gente) y el admin.
drop policy if exists personal_cliente_select on public.personal_cliente;
create policy personal_cliente_select on public.personal_cliente
  for select to authenticated using (public.tiene_acceso_sitio(sitio_id));

drop policy if exists personal_cliente_escribe on public.personal_cliente;
create policy personal_cliente_escribe on public.personal_cliente
  for all to authenticated
  using (public.tiene_acceso_sitio(sitio_id) and public.rol_actual() in ('cliente', 'admin'))
  with check (public.tiene_acceso_sitio(sitio_id) and public.rol_actual() in ('cliente', 'admin'));

-- Visitantes recurrentes: los consulta y los da de alta quien opera el acceso.
drop policy if exists visitantes_select on public.visitantes;
create policy visitantes_select on public.visitantes
  for select to authenticated using (true);

drop policy if exists visitantes_insert on public.visitantes;
create policy visitantes_insert on public.visitantes
  for insert to authenticated
  with check (public.rol_actual() in ('elemento', 'supervisor', 'admin'));

drop policy if exists visitantes_update on public.visitantes;
create policy visitantes_update on public.visitantes
  for update to authenticated
  using (public.rol_actual() in ('elemento', 'supervisor', 'admin'))
  with check (public.rol_actual() in ('elemento', 'supervisor', 'admin'));

-- Registros de acceso
drop policy if exists accesos_select on public.registros_acceso;
create policy accesos_select on public.registros_acceso
  for select to authenticated using (public.tiene_acceso_sitio(sitio_id));

drop policy if exists accesos_insert on public.registros_acceso;
create policy accesos_insert on public.registros_acceso
  for insert to authenticated
  with check (
    registrado_por = auth.uid()
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  );

-- El UPDATE es sobre todo para dar la salida. Lo puede hacer cualquier elemento
-- con acceso al sitio, no sólo el que registró la entrada: la visita puede
-- cruzar el cambio de turno.
drop policy if exists accesos_update on public.registros_acceso;
create policy accesos_update on public.registros_acceso
  for update to authenticated
  using (
    public.tiene_acceso_sitio(sitio_id)
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  )
  with check (
    public.tiene_acceso_sitio(sitio_id)
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  );
