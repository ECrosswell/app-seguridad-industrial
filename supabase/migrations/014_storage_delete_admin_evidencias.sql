-- ─────────────────────────────────────────────────────────────────────────────
-- 014: Faltaba la política de borrado para el bucket `evidencias`.
--
-- El elemento no debe poder borrar evidencia (por eso no se le concede), pero
-- el administrador sí: hace falta para depurar material erróneo y para la
-- rutina de retención, que hoy sólo anula la URL en la fila y deja el objeto
-- huérfano en Storage.
-- ─────────────────────────────────────────────────────────────────────────────

drop policy if exists "evidencias: borra admin" on storage.objects;
create policy "evidencias: borra admin" on storage.objects
  for delete to authenticated
  using (bucket_id = 'evidencias' and public.es_admin());
