-- ─────────────────────────────────────────────────────────────────────────────
-- 005: Equipo de la caseta y recepción de turno.
--
-- El equipo NO se asigna por elemento sino por sitio/caseta: la misma escopeta
-- no letal la usa quien esté de turno. Tampoco está serializado — se controla
-- por partida y cantidad, no por número de inventario.
--
-- Al recibir el turno el elemento entrante revisa cada partida y declara su
-- estado. Sólo el que RECIBE firma conformidad (el saliente ya se va). Si algo
-- viene usado, dañado o faltando, o si el elemento no acepta de conformidad,
-- el turno NO se bloquea — sigue operando — pero se dispara una alerta al
-- administrador (trigger en la migración 006).
-- ─────────────────────────────────────────────────────────────────────────────

-- ─── TABLA: catalogo_equipo ──────────────────────────────────────────────────
-- Qué debe haber en cada caseta. Lo administra el admin.

create table if not exists public.catalogo_equipo (
  id                uuid primary key default gen_random_uuid(),
  sitio_id          uuid not null references public.sitios(id) on delete cascade,
  nombre            text not null,
  descripcion       text not null default '',
  categoria         text not null default 'general'
                      check (categoria in ('armamento_no_letal', 'accesorio',
                                           'consumible', 'comunicacion',
                                           'proteccion', 'general')),
  cantidad_esperada integer not null default 1 check (cantidad_esperada > 0),

  -- Obliga a fotografiar la partida al recibirla. Se activa en lo que importa
  -- (el arma), no en todo, para no volver la recepción un trámite eterno.
  requiere_foto     boolean not null default false,
  -- Partidas cuyo estado esperado es "sin usar" (los tanques de gas): si llegan
  -- usados es señal de que hubo un evento que nadie reportó.
  debe_estar_sin_usar boolean not null default false,

  orden             integer not null default 0,
  activo            boolean not null default true,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index if not exists idx_catalogo_equipo_sitio
  on public.catalogo_equipo (sitio_id, orden) where activo = true;

create trigger catalogo_equipo_set_updated_at
  before update on public.catalogo_equipo
  for each row execute function public.set_updated_at();

-- ─── TABLA: recepciones_turno ────────────────────────────────────────────────

create table if not exists public.recepciones_turno (
  id                uuid primary key default gen_random_uuid(),
  local_id          text not null unique,
  device_id         text not null default '',

  sitio_id          uuid not null references public.sitios(id),
  turno_id          uuid references public.turnos(id),
  turno_fecha       date not null,

  -- Quien recibe es el único que firma. El saliente se registra sólo como
  -- referencia de a quién se le recibió, y puede venir nulo (primer turno,
  -- o el saliente ya se había retirado).
  recibe_id         uuid not null references public.profiles(id),
  entrega_id        uuid references public.profiles(id),

  -- La "firma": el elemento declara si acepta de conformidad. No es un
  -- garabato en pantalla, es una aceptación explícita con sello de tiempo.
  acepta_conformidad boolean not null,
  aceptado_at       timestamptz not null default now(),

  -- Se calcula por trigger a partir del detalle: true si alguna partida no
  -- está en perfectas condiciones o si no aceptó de conformidad.
  tiene_novedades   boolean not null default false,

  observaciones     text not null default '',

  -- Seguimiento del admin sobre la novedad reportada
  atendido          boolean not null default false,
  atendido_por      uuid references public.profiles(id),
  atendido_at       timestamptz,
  nota_atencion     text not null default '',

  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  deleted_at        timestamptz,
  updated_by        uuid references public.profiles(id)
);

create index if not exists idx_recepciones_sitio_fecha
  on public.recepciones_turno (sitio_id, turno_fecha desc) where deleted_at is null;
create index if not exists idx_recepciones_novedades
  on public.recepciones_turno (sitio_id, created_at desc)
  where deleted_at is null and tiene_novedades = true and atendido = false;

create trigger recepciones_turno_set_updated_at
  before update on public.recepciones_turno
  for each row execute function public.set_updated_at();

-- ─── TABLA: recepcion_turno_items ────────────────────────────────────────────

create table if not exists public.recepcion_turno_items (
  id            uuid primary key default gen_random_uuid(),
  local_id      text not null unique,
  recepcion_id  uuid not null references public.recepciones_turno(id) on delete cascade,
  equipo_id     uuid not null references public.catalogo_equipo(id),

  estado        text not null
                  check (estado in ('perfecto', 'usado', 'danado', 'falta')),
  cantidad_encontrada integer not null default 1 check (cantidad_encontrada >= 0),
  observaciones text not null default '',
  foto_url      text,

  created_at    timestamptz not null default now()
);

create index if not exists idx_recepcion_items_recepcion
  on public.recepcion_turno_items (recepcion_id);

-- ─── Lógica ──────────────────────────────────────────────────────────────────

create or replace function public.preparar_recepcion_turno()
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
    new.turno_fecha := ((new.aceptado_at + make_interval(hours => v_sitio.huso_horario_offset_h))
                        - v_sitio.hora_inicio_turno)::date;
  end if;

  if new.turno_id is null then
    select id into new.turno_id
      from public.turnos
     where usuario_id = new.recibe_id and estado = 'en_curso'
     order by inicio_at desc
     limit 1;
  end if;

  -- No aceptar de conformidad ya es, por sí solo, una novedad.
  if new.acepta_conformidad = false then
    new.tiene_novedades := true;
  end if;

  return new;
end;
$$;

drop trigger if exists recepciones_turno_preparar on public.recepciones_turno;
create trigger recepciones_turno_preparar
  before insert on public.recepciones_turno
  for each row execute function public.preparar_recepcion_turno();

-- Recalcula `tiene_novedades` conforme se van insertando las partidas.
create or replace function public.evaluar_novedades_recepcion()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  if new.estado <> 'perfecto' then
    update public.recepciones_turno
       set tiene_novedades = true
     where id = new.recepcion_id;
  end if;
  return new;
end;
$$;

drop trigger if exists recepcion_items_evaluar on public.recepcion_turno_items;
create trigger recepcion_items_evaluar
  after insert on public.recepcion_turno_items
  for each row execute function public.evaluar_novedades_recepcion();

-- ─── VISTA: última recepción por sitio ───────────────────────────────────────
-- Estado actual del equipo de la caseta, para el tablero del admin.

create or replace view public.v_estado_equipo_sitio
with (security_invoker = true)
as
select distinct on (r.sitio_id, i.equipo_id)
  r.sitio_id,
  s.nombre        as sitio_nombre,
  ce.nombre       as equipo_nombre,
  ce.categoria,
  i.estado,
  i.cantidad_encontrada,
  ce.cantidad_esperada,
  i.observaciones,
  i.foto_url,
  r.turno_fecha,
  r.aceptado_at,
  p.nombre_completo as reportado_por,
  r.atendido
from public.recepcion_turno_items i
join public.recepciones_turno r on r.id = i.recepcion_id
join public.catalogo_equipo  ce on ce.id = i.equipo_id
join public.sitios            s on s.id  = r.sitio_id
join public.profiles          p on p.id  = r.recibe_id
where r.deleted_at is null
order by r.sitio_id, i.equipo_id, r.aceptado_at desc;

-- ─────────────────────────────────────────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.catalogo_equipo        enable row level security;
alter table public.recepciones_turno      enable row level security;
alter table public.recepcion_turno_items  enable row level security;

drop policy if exists catalogo_equipo_select on public.catalogo_equipo;
create policy catalogo_equipo_select on public.catalogo_equipo
  for select to authenticated using (public.tiene_acceso_sitio(sitio_id));

drop policy if exists catalogo_equipo_admin on public.catalogo_equipo;
create policy catalogo_equipo_admin on public.catalogo_equipo
  for all to authenticated
  using (public.es_admin()) with check (public.es_admin());

drop policy if exists recepciones_select on public.recepciones_turno;
create policy recepciones_select on public.recepciones_turno
  for select to authenticated using (public.tiene_acceso_sitio(sitio_id));

drop policy if exists recepciones_insert on public.recepciones_turno;
create policy recepciones_insert on public.recepciones_turno
  for insert to authenticated
  with check (recibe_id = auth.uid());

drop policy if exists recepciones_update on public.recepciones_turno;
create policy recepciones_update on public.recepciones_turno
  for update to authenticated
  using (public.rol_actual() in ('supervisor', 'admin'))
  with check (public.rol_actual() in ('supervisor', 'admin'));

drop policy if exists recepcion_items_select on public.recepcion_turno_items;
create policy recepcion_items_select on public.recepcion_turno_items
  for select to authenticated
  using (exists (
    select 1 from public.recepciones_turno r
    where r.id = recepcion_id and public.tiene_acceso_sitio(r.sitio_id)
  ));

drop policy if exists recepcion_items_insert on public.recepcion_turno_items;
create policy recepcion_items_insert on public.recepcion_turno_items
  for insert to authenticated
  with check (exists (
    select 1 from public.recepciones_turno r
    where r.id = recepcion_id and r.recibe_id = auth.uid()
  ));
