-- ─────────────────────────────────────────────────────────────────────────────
-- 007: Buckets de Storage y política de retención.
--
-- Dos buckets separados a propósito:
--   · evidencias       — selfies de asistencia, fotos de bitácora y de equipo.
--                        Se conservan como respaldo operativo del servicio.
--   · identificaciones — fotografías de identificaciones de visitantes.
--                        Dato personal bajo LFPDPPP: acceso más restringido y
--                        purga automática a los 90 días (migración 008).
--
-- Ambos son privados. Las imágenes se sirven con URLs firmadas de vida corta,
-- nunca con enlace público: una URL pública de Storage es indexable y no
-- caduca, lo que dejaría fotos de identificaciones accesibles a quien tenga
-- la liga.
-- ─────────────────────────────────────────────────────────────────────────────

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('evidencias', 'evidencias', false, 3145728,
   array['image/jpeg', 'image/png', 'image/webp']),
  ('identificaciones', 'identificaciones', false, 3145728,
   array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update
  set file_size_limit   = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types,
      public             = false;

-- Casteo defensivo. Si un objeto se sube con una ruta que no empieza con el
-- uuid del sitio, `texto::uuid` lanzaría una excepción y la policy tronaría en
-- lugar de simplemente negar el acceso. Esta versión devuelve null y la policy
-- niega, que es el comportamiento correcto.
create or replace function public.uuid_seguro(p_texto text)
returns uuid
language plpgsql
immutable
as $$
begin
  return p_texto::uuid;
exception when others then
  return null;
end;
$$;

-- ─── Políticas de Storage ────────────────────────────────────────────────────
-- Convención de rutas:  <bucket>/<sitio_id>/<yyyy-mm>/<archivo>
-- El primer segmento es el sitio, lo que permite filtrar acceso por sitio
-- reutilizando `tiene_acceso_sitio`.

drop policy if exists "evidencias: sube personal operativo" on storage.objects;
create policy "evidencias: sube personal operativo" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'evidencias'
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  );

drop policy if exists "evidencias: lee quien tiene acceso al sitio" on storage.objects;
create policy "evidencias: lee quien tiene acceso al sitio" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'evidencias'
    and (
      public.es_admin()
      -- El primer segmento de la ruta es el uuid del sitio.
      or public.tiene_acceso_sitio(nullif((storage.foldername(name))[1], '')::uuid)
    )
  );

-- Identificaciones: las sube quien opera el acceso; las lee sólo el personal
-- de seguridad. El cliente NO las ve — no necesita las identificaciones de sus
-- propios visitantes y cada ojo de más es exposición innecesaria.
drop policy if exists "identificaciones: sube personal operativo" on storage.objects;
create policy "identificaciones: sube personal operativo" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'identificaciones'
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  );

drop policy if exists "identificaciones: lee seguridad" on storage.objects;
create policy "identificaciones: lee seguridad" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'identificaciones'
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  );

-- El borrado lo hace la rutina de purga (service_role), no la app.
drop policy if exists "identificaciones: borra admin" on storage.objects;
create policy "identificaciones: borra admin" on storage.objects
  for delete to authenticated
  using (bucket_id = 'identificaciones' and public.es_admin());
