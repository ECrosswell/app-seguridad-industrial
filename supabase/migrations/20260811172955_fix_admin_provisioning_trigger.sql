-- Supabase Auth ejecuta el INSERT de auth.users antes de persistir el
-- app_metadata enviado a la Admin API. Por eso el trigger no puede usar ese
-- campo como marca de procedencia durante el INSERT.
--
-- Defensa segura: cualquier alta nace inactiva, con el rol de menor privilegio
-- y sin sitio. La Edge Function administrativa prepara el perfil, asigna el
-- sitio y lo activa sólo después de completar todos los pasos. Si el registro
-- público se habilitara por accidente, la cuenta seguiría sin acceso operativo.
create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public, private, pg_temp
as $$
begin
  insert into public.profiles (
    id,
    correo,
    nombre_completo,
    rol,
    telefono_whatsapp,
    estado_laboral,
    fecha_alta,
    debe_cambiar_password,
    password_cambio_requerido_at,
    activo
  )
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'nombre_completo', ''),
    'elemento',
    coalesce(new.raw_user_meta_data ->> 'telefono_whatsapp', ''),
    'activo',
    current_date,
    true,
    now(),
    false
  );

  return new;
end;
$$;

revoke all on function private.handle_new_user() from public, anon, authenticated;
