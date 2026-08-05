-- ─────────────────────────────────────────────────────────────────────────────
-- 008: Alertas programadas y purga de datos personales.
--
-- Tres rutinas que corren solas en la base:
--   1. detectar_relevo_no_llego()   cada 10 min
--   2. detectar_salidas_pendientes() cada hora
--   3. purgar_identificaciones()     diario
--
-- Corren cada pocos minutos (y no una sola vez a las 09:00) porque cada sitio
-- tiene su propia hora de inicio y su propia tolerancia: la rutina evalúa la
-- configuración de cada sitio en lugar de asumir un horario global.
--
-- `alertas_emitidas` da idempotencia: sin ella, una rutina que corre cada 10
-- minutos mandaría la misma alerta 6 veces por hora hasta que alguien la
-- atienda.
-- ─────────────────────────────────────────────────────────────────────────────

create extension if not exists pg_cron with schema extensions;

-- ─── TABLA: alertas_emitidas ─────────────────────────────────────────────────

create table if not exists public.alertas_emitidas (
  id          uuid primary key default gen_random_uuid(),
  sitio_id    uuid not null references public.sitios(id) on delete cascade,
  tipo        text not null,
  turno_fecha date not null,
  -- Discrimina alertas del mismo tipo y fecha para entidades distintas
  -- (p. ej. dos turnos abiertos sin salida el mismo día).
  referencia  uuid,
  emitida_at  timestamptz not null default now(),
  unique (sitio_id, tipo, turno_fecha, referencia)
);

-- Postgres no considera iguales dos filas con NULL en una columna del UNIQUE,
-- así que sin este índice las alertas sin `referencia` se duplicarían.
create unique index if not exists uidx_alertas_sin_referencia
  on public.alertas_emitidas (sitio_id, tipo, turno_fecha)
  where referencia is null;

alter table public.alertas_emitidas enable row level security;

drop policy if exists alertas_emitidas_admin on public.alertas_emitidas;
create policy alertas_emitidas_admin on public.alertas_emitidas
  for select to authenticated using (public.es_admin());

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. RELEVO QUE NO LLEGÓ / DOBLETE
--
-- Para cada sitio activo: si ya pasó la tolerancia desde el inicio del turno
-- (por defecto 1 h → 09:00) y nadie registró entrada para el turno de hoy,
-- pero sí hay alguien con turno abierto del día anterior, entonces ese
-- elemento se quedó a hacer doblete. Se marca el turno y se alerta al admin.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.detectar_relevo_no_llego()
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  r_sitio        record;
  v_fecha_turno  date;
  v_inicio_turno timestamptz;
  v_hay_entrada  boolean;
  r_abierto      record;
  v_alertas      integer := 0;
begin
  -- Sin filtrar por `lat is not null`: esta alerta no depende del GPS. Se basa
  -- en si alguien registró entrada, y el registro existe aunque la geocerca
  -- todavía no esté capturada.
  for r_sitio in
    select * from public.sitios where activo = true
  loop
    -- Fecha operativa del turno en curso y su hora de arranque en UTC.
    v_fecha_turno := ((now() + make_interval(hours => r_sitio.huso_horario_offset_h))
                      - r_sitio.hora_inicio_turno)::date;
    -- Se ancla en UTC explícitamente: `date + time` produce un timestamp sin
    -- zona y dejarlo al TimeZone de la sesión haría que la alerta se disparara
    -- a una hora distinta si alguien cambia ese parámetro.
    v_inicio_turno := ((v_fecha_turno + r_sitio.hora_inicio_turno)
                      - make_interval(hours => r_sitio.huso_horario_offset_h))
                      at time zone 'UTC';

    -- ¿Ya venció la tolerancia?
    continue when now() < v_inicio_turno + make_interval(mins => r_sitio.minutos_alerta_relevo);

    -- ¿Alguien registró entrada para el turno de hoy en este sitio?
    select exists (
      select 1 from public.asistencias
       where sitio_id    = r_sitio.id
         and turno_fecha = v_fecha_turno
         and tipo_evento = 'entrada'
         and deleted_at is null
    ) into v_hay_entrada;

    continue when v_hay_entrada;

    -- Nadie llegó. ¿Hay alguien del turno anterior todavía adentro?
    for r_abierto in
      select t.*, p.nombre_completo
        from public.turnos t
        join public.profiles p on p.id = t.usuario_id
       where t.sitio_id = r_sitio.id
         and t.estado = 'en_curso'
         and t.turno_fecha < v_fecha_turno
    loop
      -- Idempotencia: una alerta por sitio, tipo y fecha de turno.
      begin
        insert into public.alertas_emitidas (sitio_id, tipo, turno_fecha, referencia)
        values (r_sitio.id, 'relevo_no_llego', v_fecha_turno, r_abierto.id);
      exception when unique_violation then
        continue;
      end;

      update public.turnos set es_doblete = true where id = r_abierto.id;

      perform public.notificar_rol(
        'admin', 'relevo_no_llego',
        'Relevo no llegó — ' || r_sitio.nombre,
        r_abierto.nombre_completo || ' sigue en turno y no se ha registrado el relevo. '
          || 'Pasó la tolerancia de ' || r_sitio.minutos_alerta_relevo || ' min. '
          || 'Lleva ' || round(extract(epoch from (now() - r_abierto.inicio_at)) / 3600.0, 1)
          || ' h en el sitio (doblete).',
        'critica', r_sitio.id, 'turno', r_abierto.id,
        jsonb_build_object(
          'usuario_id',  r_abierto.usuario_id,
          'inicio_at',   r_abierto.inicio_at,
          'turno_fecha', v_fecha_turno
        )
      );

      -- También al supervisor del sitio, que es quien puede mover gente.
      perform public.notificar_rol(
        'supervisor', 'relevo_no_llego',
        'Relevo no llegó — ' || r_sitio.nombre,
        r_abierto.nombre_completo || ' se quedó a cubrir. Requiere relevo.',
        'critica', r_sitio.id, 'turno', r_abierto.id
      );

      v_alertas := v_alertas + 1;
    end loop;
  end loop;

  return v_alertas;
end;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. SALIDA NO REGISTRADA
--
-- El turno dura 24 h. Si a las 26 h sigue abierto, o el elemento olvidó marcar
-- salida o pasó algo. No se cierra solo: se avisa al admin y él lo cierra a
-- mano, para que quede constancia de quién lo cerró y por qué.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.detectar_salidas_pendientes()
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  r_turno   record;
  v_alertas integer := 0;
begin
  for r_turno in
    select t.*, p.nombre_completo, s.nombre as sitio_nombre
      from public.turnos t
      join public.profiles p on p.id = t.usuario_id
      join public.sitios   s on s.id = t.sitio_id
     where t.estado = 'en_curso'
       and t.inicio_at < now() - interval '26 hours'
  loop
    begin
      insert into public.alertas_emitidas (sitio_id, tipo, turno_fecha, referencia)
      values (r_turno.sitio_id, 'salida_no_registrada', r_turno.turno_fecha, r_turno.id);
    exception when unique_violation then
      continue;
    end;

    perform public.notificar_rol(
      'admin', 'salida_no_registrada',
      'Salida sin registrar — ' || r_turno.sitio_nombre,
      r_turno.nombre_completo || ' abrió turno el ' || r_turno.turno_fecha
        || ' y no ha registrado salida ('
        || round(extract(epoch from (now() - r_turno.inicio_at)) / 3600.0, 1)
        || ' h). Ciérralo desde el panel.',
      'alta', r_turno.sitio_id, 'turno', r_turno.id,
      jsonb_build_object('usuario_id', r_turno.usuario_id, 'inicio_at', r_turno.inicio_at)
    );

    v_alertas := v_alertas + 1;
  end loop;

  return v_alertas;
end;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. PURGA DE IDENTIFICACIONES (LFPDPPP, 90 días)
--
-- Marca los registros vencidos y deja los objetos de Storage listos para
-- borrarse. El borrado físico del archivo lo hace la Edge Function
-- `purgar-identificaciones`, porque desde SQL no se puede llamar a la API de
-- Storage. La fila conserva la constancia de que existió una identificación y
-- de que se eliminó, sin conservar la imagen.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.marcar_identificaciones_vencidas()
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_count integer;
begin
  update public.registros_acceso
     set identificacion_purgada  = true,
         identificacion_foto_url = null
   where identificacion_purgada = false
     and identificacion_foto_url is not null
     and identificacion_purgar_at is not null
     and identificacion_purgar_at <= now();

  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- PROGRAMACIÓN (pg_cron)
-- ─────────────────────────────────────────────────────────────────────────────

-- Reprogramar es seguro: unschedule primero para que la migración sea idempotente.
do $$
begin
  perform cron.unschedule('detectar-relevo-no-llego');
exception when others then null;
end $$;

do $$
begin
  perform cron.unschedule('detectar-salidas-pendientes');
exception when others then null;
end $$;

do $$
begin
  perform cron.unschedule('marcar-identificaciones-vencidas');
exception when others then null;
end $$;

select cron.schedule(
  'detectar-relevo-no-llego',
  '*/10 * * * *',
  $$select public.detectar_relevo_no_llego();$$
);

select cron.schedule(
  'detectar-salidas-pendientes',
  '0 * * * *',
  $$select public.detectar_salidas_pendientes();$$
);

-- 09:10 UTC ≈ 03:10 hora de la Ciudad de México: fuera del cambio de turno.
select cron.schedule(
  'marcar-identificaciones-vencidas',
  '10 9 * * *',
  $$select public.marcar_identificaciones_vencidas();$$
);
