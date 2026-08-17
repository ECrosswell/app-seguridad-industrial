-- ─────────────────────────────────────────────────────────────────────────────
-- 013: Políticas de UPDATE sobre Storage, que faltaban.
--
-- `upsert: true` hace INSERT si el objeto no existe y UPDATE si ya existe. Sin
-- policy de UPDATE, el segundo caso se rechaza con
-- `new row violates row-level security policy`.
--
-- **Escenario real que esto arregla.** El teléfono sube la selfie, se cae la
-- red antes de que alcance a guardar la referencia local, y al reintentar
-- choca contra la misma ruta remota (el nombre del archivo es determinista).
-- Sin UPDATE esa fila queda atorada para siempre — justo lo que `upsert`
-- existía para evitar.
--
-- Se limitan a los mismos roles que ya pueden insertar. El cliente sigue sin
-- poder escribir en ninguno de los dos buckets.
-- ─────────────────────────────────────────────────────────────────────────────

drop policy if exists "evidencias: reintenta personal operativo" on storage.objects;
create policy "evidencias: reintenta personal operativo" on storage.objects
  for update to authenticated
  using (
    bucket_id = 'evidencias'
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  )
  with check (
    bucket_id = 'evidencias'
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  );

drop policy if exists "identificaciones: reintenta personal operativo" on storage.objects;
create policy "identificaciones: reintenta personal operativo" on storage.objects
  for update to authenticated
  using (
    bucket_id = 'identificaciones'
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  )
  with check (
    bucket_id = 'identificaciones'
    and public.rol_actual() in ('elemento', 'supervisor', 'admin')
  );
