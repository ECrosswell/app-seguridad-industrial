-- ─────────────────────────────────────────────────────────────────────────────
-- 011: Los secretos de la Edge Function se mudan a Vault.
--
-- **Por qué.** Las variables de entorno de una Edge Function sólo se pueden
-- cargar desde el panel de Supabase o con un token de administración. Vault
-- vive dentro de la base, cifrado, y se puebla con una sola instrucción SQL —
-- que es algo que se puede hacer desde el editor, un script de despliegue o
-- una migración.
--
-- El esquema `vault` no está expuesto por PostgREST, así que la lectura pasa
-- por `obtener_secreto`, restringida **exclusivamente** a `service_role`: el
-- rol que sólo tiene la Edge Function, nunca un cliente.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.obtener_secreto(p_nombre text)
returns text
language sql
stable
security definer
set search_path = public, vault, pg_temp
as $$
  select decrypted_secret
    from vault.decrypted_secrets
   where name = p_nombre
   limit 1;
$$;

-- Cerrada a cal y canto: ni `anon` ni `authenticated` pueden asomarse.
revoke all on function public.obtener_secreto(text) from public, anon, authenticated;
grant execute on function public.obtener_secreto(text) to service_role;

-- ─────────────────────────────────────────────────────────────────────────────
-- Carga y rotación de la cuenta de servicio de Firebase.
--
-- Uso:
--   select public.guardar_cuenta_firebase('<pega aquí el JSON completo>');
--
-- Sirve igual para la carga inicial que para rotar la llave: si ya existe, la
-- reemplaza.
-- ─────────────────────────────────────────────────────────────────────────────

create or replace function public.guardar_cuenta_firebase(p_json text)
returns text
language plpgsql
security definer
set search_path = public, vault, pg_temp
as $$
declare
  v_id uuid;
begin
  if p_json is null or p_json = '' then
    raise exception 'El JSON de la cuenta de servicio viene vacío';
  end if;

  -- Valida que sea JSON y que traiga lo que la función necesita. Sin esto, una
  -- llave mal pegada no se descubriría hasta que un push fallara en silencio.
  perform p_json::jsonb;

  if (p_json::jsonb ->> 'private_key') is null
     or (p_json::jsonb ->> 'client_email') is null
     or (p_json::jsonb ->> 'project_id') is null then
    raise exception 'El JSON no parece una cuenta de servicio de Firebase: '
                    'faltan private_key, client_email o project_id';
  end if;

  select id into v_id from vault.secrets where name = 'firebase_service_account';

  if v_id is null then
    perform vault.create_secret(
      p_json,
      'firebase_service_account',
      'Cuenta de servicio de Firebase para enviar push por FCM v1'
    );
    return 'Cuenta de Firebase guardada en Vault.';
  else
    perform vault.update_secret(v_id, p_json);
    return 'Cuenta de Firebase actualizada en Vault.';
  end if;
end;
$$;

revoke all on function public.guardar_cuenta_firebase(text) from public, anon, authenticated;
