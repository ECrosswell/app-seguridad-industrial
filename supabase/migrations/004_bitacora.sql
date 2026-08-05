-- ─────────────────────────────────────────────────────────────────────────────
-- 004: Bitácora de turno.
--
-- El elemento registra los eventos que suceden durante su turno de 24 h: salida
-- de mercancía, ingreso de materia prima, movimientos de vehículos, fallas de
-- infraestructura ("la puerta no cierra"), incidentes, rondas, correspondencia
-- y eventos libres.
--
-- Los eventos se agrupan por turno (la bitácora "se cierra" cuando el elemento
-- entrega), pero quedan como histórico consultable por rango de fechas.
--
-- En los movimientos de mercancía las PLACAS son obligatorias, junto con el
-- destino y quién autorizó — lo impone un CHECK, no la interfaz, para que no se
-- pueda saltar desde un cliente viejo o desincronizado.
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists public.bitacora_eventos (
  id              uuid primary key default gen_random_uuid(),
  local_id        text not null unique,
  device_id       text not null default '',

  sitio_id        uuid not null references public.sitios(id),
  turno_id        uuid references public.turnos(id),
  turno_fecha     date not null,
  registrado_por  uuid not null references public.profiles(id),

  tipo            text not null
                    check (tipo in ('salida_mercancia',
                                    'ingreso_materia_prima',
                                    'entrada_vehiculo',
                                    'salida_vehiculo',
                                    'falla_infraestructura',
                                    'incidente_seguridad',
                                    'ronda',
                                    'correspondencia',
                                    'libre')),

  ocurrido_at     timestamptz not null default now(),
  descripcion     text not null,

  -- Datos de movimiento de mercancía / vehículos
  placas          text not null default '',
  transportista   text not null default '',
  empresa_transporte text not null default '',
  num_documento   text not null default '',   -- remisión, factura, orden de embarque
  destino         text not null default '',   -- a dónde va la mercancía

  -- Quién autorizó el movimiento. Preferimos el catálogo del cliente; el texto
  -- libre queda de respaldo mientras el catálogo se puebla.
  autorizado_por_id    uuid references public.personal_cliente(id),
  autorizado_por_texto text not null default '',

  -- Severidad, para que fallas e incidentes destaquen en el tablero del cliente.
  prioridad       text not null default 'normal'
                    check (prioridad in ('normal', 'alta', 'critica')),

  -- Seguimiento de fallas: "la puerta no cierra" sigue abierta hasta que alguien
  -- la resuelva.
  requiere_seguimiento boolean not null default false,
  resuelto        boolean not null default false,
  resuelto_at     timestamptz,
  resuelto_por    uuid references public.profiles(id),
  nota_resolucion text not null default '',

  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  deleted_at      timestamptz,
  updated_by      uuid references public.profiles(id),

  -- Regla dura: sin placas, destino y autorización no hay movimiento de mercancía.
  constraint chk_mercancia_requiere_datos check (
    tipo not in ('salida_mercancia', 'ingreso_materia_prima')
    or (
      placas <> ''
      and destino <> ''
      and (autorizado_por_id is not null or autorizado_por_texto <> '')
    )
  )
);

create index if not exists idx_bitacora_sitio_fecha
  on public.bitacora_eventos (sitio_id, turno_fecha desc, ocurrido_at desc)
  where deleted_at is null;
create index if not exists idx_bitacora_turno
  on public.bitacora_eventos (turno_id) where deleted_at is null;
create index if not exists idx_bitacora_tipo
  on public.bitacora_eventos (tipo, ocurrido_at desc) where deleted_at is null;
create index if not exists idx_bitacora_placas
  on public.bitacora_eventos (placas) where deleted_at is null and placas <> '';
create index if not exists idx_bitacora_pendientes
  on public.bitacora_eventos (sitio_id, ocurrido_at desc)
  where deleted_at is null and requiere_seguimiento = true and resuelto = false;

create trigger bitacora_eventos_set_updated_at
  before update on public.bitacora_eventos
  for each row execute function public.set_updated_at();

-- ─── TABLA: bitacora_fotos ───────────────────────────────────────────────────
-- Evidencia fotográfica. Tabla aparte y no un array de URLs porque cada foto
-- se sube por separado desde el motor de sincronización offline y necesita su
-- propio estado y su propia clave de idempotencia.

create table if not exists public.bitacora_fotos (
  id          uuid primary key default gen_random_uuid(),
  local_id    text not null unique,
  evento_id   uuid not null references public.bitacora_eventos(id) on delete cascade,
  foto_url    text not null,
  descripcion text not null default '',
  orden       integer not null default 0,
  created_at  timestamptz not null default now()
);

create index if not exists idx_bitacora_fotos_evento
  on public.bitacora_fotos (evento_id, orden);

-- ─── Lógica ──────────────────────────────────────────────────────────────────

-- Rellena la fecha operativa del turno y liga el evento con el turno abierto
-- del elemento, para poder cerrar la bitácora por turno.
create or replace function public.preparar_evento_bitacora()
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
    new.turno_fecha := ((new.ocurrido_at + make_interval(hours => v_sitio.huso_horario_offset_h))
                        - v_sitio.hora_inicio_turno)::date;
  end if;

  if new.turno_id is null then
    select id into new.turno_id
      from public.turnos
     where usuario_id = new.registrado_por and estado = 'en_curso'
     order by inicio_at desc
     limit 1;
  end if;

  -- Las fallas y los incidentes arrastran seguimiento por default: son
  -- justamente los que no se deben perder al cambiar de turno.
  if new.tipo in ('falla_infraestructura', 'incidente_seguridad') then
    new.requiere_seguimiento := true;
  end if;

  return new;
end;
$$;

drop trigger if exists bitacora_eventos_preparar on public.bitacora_eventos;
create trigger bitacora_eventos_preparar
  before insert on public.bitacora_eventos
  for each row execute function public.preparar_evento_bitacora();

-- ─── VISTA: pendientes que cruzan de turno ───────────────────────────────────
-- Lo que el elemento entrante tiene que saber al recibir.

create or replace view public.v_bitacora_pendientes
with (security_invoker = true)
as
select
  b.id,
  b.sitio_id,
  b.tipo,
  b.descripcion,
  b.prioridad,
  b.ocurrido_at,
  b.turno_fecha,
  p.nombre_completo as reportado_por,
  round(extract(epoch from (now() - b.ocurrido_at)) / 3600.0, 1) as horas_abierto
from public.bitacora_eventos b
join public.profiles p on p.id = b.registrado_por
where b.deleted_at is null
  and b.requiere_seguimiento = true
  and b.resuelto = false;

-- ─────────────────────────────────────────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ─────────────────────────────────────────────────────────────────────────────

alter table public.bitacora_eventos enable row level security;
alter table public.bitacora_fotos   enable row level security;

drop policy if exists bitacora_select on public.bitacora_eventos;
create policy bitacora_select on public.bitacora_eventos
  for select to authenticated using (public.tiene_acceso_sitio(sitio_id));

drop policy if exists bitacora_insert on public.bitacora_eventos;
create policy bitacora_insert on public.bitacora_eventos
  for insert to authenticated
  with check (
    registrado_por = auth.uid()
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  );

-- El elemento puede corregir su propio evento; supervisor y admin cualquiera
-- (necesitan poder marcar resuelto un pendiente que reportó otro).
drop policy if exists bitacora_update on public.bitacora_eventos;
create policy bitacora_update on public.bitacora_eventos
  for update to authenticated
  using (
    public.tiene_acceso_sitio(sitio_id)
    and (registrado_por = auth.uid() or public.rol_actual() in ('supervisor', 'admin'))
  )
  with check (
    public.tiene_acceso_sitio(sitio_id)
    and (registrado_por = auth.uid() or public.rol_actual() in ('supervisor', 'admin'))
  );

drop policy if exists bitacora_fotos_select on public.bitacora_fotos;
create policy bitacora_fotos_select on public.bitacora_fotos
  for select to authenticated
  using (exists (
    select 1 from public.bitacora_eventos b
    where b.id = evento_id and public.tiene_acceso_sitio(b.sitio_id)
  ));

drop policy if exists bitacora_fotos_insert on public.bitacora_fotos;
create policy bitacora_fotos_insert on public.bitacora_fotos
  for insert to authenticated
  with check (exists (
    select 1 from public.bitacora_eventos b
    where b.id = evento_id and b.registrado_por = auth.uid()
  ));
