-- ─────────────────────────────────────────────────────────────────────────────
-- Datos iniciales.
--
-- Se corre UNA vez después de aplicar las migraciones 001–008.
-- Es idempotente: se puede volver a correr sin duplicar.
--
-- Lo que NO va aquí y hay que capturar desde el panel de admin:
--   · Coordenadas y radio de la geocerca (parándose físicamente en la puerta)
--   · BSSIDs de los access points de la planta
--   · Usuarios (los crea el admin desde la consola de Supabase Auth o la app)
-- ─────────────────────────────────────────────────────────────────────────────

-- ─── Aviso de privacidad ─────────────────────────────────────────────────────
-- El texto es un borrador operativo. Antes de producción debe revisarlo quien
-- lleve el tema legal del cliente: el aviso integral tiene requisitos de
-- contenido específicos en la LFPDPPP (identidad del responsable, finalidades,
-- medios para ejercer derechos ARCO, transferencias).

insert into public.avisos_privacidad (version, titulo, resumen, url_completo, vigente_desde, activo)
values (
  '1.0',
  'Aviso de Privacidad — Control de Acceso',
  'Los datos que proporcionas (nombre, empresa, motivo de visita, vehículo y, '
  'de manera opcional, imagen de tu identificación) se recaban únicamente para '
  'el control de acceso y la seguridad de las instalaciones. La imagen de tu '
  'identificación se elimina automáticamente a los 90 días. No se comparten con '
  'terceros salvo requerimiento de autoridad competente. Puedes ejercer tus '
  'derechos de acceso, rectificación, cancelación y oposición contactando al '
  'responsable.',
  '',
  current_date,
  true
)
on conflict (version) do nothing;

-- ─── Sitio inicial ───────────────────────────────────────────────────────────
-- Geocerca nula a propósito: se captura desde el panel de admin. Mientras no
-- tenga coordenadas, la validación por GPS no aplica y la asistencia se apoya
-- en el BSSID del WiFi (o entra como 'pendiente_revision').

insert into public.sitios (
  nombre, razon_social, direccion,
  hora_inicio_turno,
  minutos_tolerancia_retardo,
  minutos_tolerancia_falta,
  minutos_alerta_relevo,
  huso_horario_offset_h,
  radio_metros,
  activo
)
select
  'Fábrica', '', '',
  '08:00',
  1,    -- 08:01 en adelante → retardo
  90,   -- 09:30 en adelante → falta
  60,   -- 09:00 → alerta de relevo no llegó
  -6,   -- Ciudad de México, sin horario de verano
  150,
  true
where not exists (select 1 from public.sitios where nombre = 'Fábrica');

-- ─── Catálogo de equipo de la caseta ─────────────────────────────────────────
-- Sin serializar: se controla por partida y cantidad. Asignado al sitio, no al
-- elemento — la misma escopeta la usan ambos turnos.

insert into public.catalogo_equipo (
  sitio_id, nombre, descripcion, categoria,
  cantidad_esperada, requiere_foto, debe_estar_sin_usar, orden, activo
)
select s.id, v.nombre, v.descripcion, v.categoria,
       v.cantidad, v.requiere_foto, v.sin_usar, v.orden, true
from public.sitios s
cross join (values
  ('Escopeta no letal', 'Arma no letal de cargo de la caseta', 'armamento_no_letal', 1, true,  false, 1),
  ('Porta fusil',       'Porta fusil de la escopeta',           'accesorio',          1, false, false, 2),
  ('Tanques de gas',    'Deben recibirse llenos y sin usar',     'consumible',         2, true,  true,  3)
) as v(nombre, descripcion, categoria, cantidad, requiere_foto, sin_usar, orden)
where s.nombre = 'Fábrica'
  and not exists (
    select 1 from public.catalogo_equipo ce
    where ce.sitio_id = s.id and ce.nombre = v.nombre
  );
