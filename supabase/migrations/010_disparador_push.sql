-- ─────────────────────────────────────────────────────────────────────────────
-- 010: Disparador de notificaciones push.
--
-- Llama cada minuto a la Edge Function `enviar-push`, que barre las
-- notificaciones con `push_enviada = false` y las manda por FCM.
--
-- **Por qué barrido y no disparo directo desde el trigger de inserción:** si
-- Firebase o la red fallan, la fila se queda pendiente y el siguiente ciclo la
-- reintenta sola. Un trigger que dispara y olvida perdería esa alerta sin que
-- nadie se entere — justo lo que no puede pasar con un aviso de armamento
-- reportado.
--
-- Un minuto de latencia es aceptable para lo que se alerta aquí (armamento con
-- novedad, relevo que no llegó, salida sin registrar, solicitud del cliente).
-- Ninguna de esas es una emergencia de segundos.
-- ─────────────────────────────────────────────────────────────────────────────

create extension if not exists pg_net with schema extensions;

-- ─── Secreto compartido ──────────────────────────────────────────────────────
-- Vive en Vault, cifrado. No en una tabla normal ni escrito en el texto del
-- job: `cron.job` es legible por cualquiera con acceso al esquema `cron`.

do $$
declare
  v_secreto text;
begin
  if not exists (select 1 from vault.secrets where name = 'cron_secret') then
    v_secreto := encode(extensions.gen_random_bytes(32), 'hex');
    perform vault.create_secret(
      v_secreto,
      'cron_secret',
      'Secreto compartido entre pg_cron y la Edge Function enviar-push'
    );
  end if;
end $$;

-- ─── Disparador ──────────────────────────────────────────────────────────────

create or replace function public.disparar_envio_push()
returns bigint
language plpgsql
security definer
set search_path = public, extensions, vault, pg_temp
as $$
declare
  v_secreto text;
  v_peticion bigint;
begin
  select decrypted_secret into v_secreto
    from vault.decrypted_secrets
   where name = 'cron_secret'
   limit 1;

  if v_secreto is null then
    raise warning 'No hay cron_secret en Vault; no se envían push';
    return null;
  end if;

  -- Salida temprana: si no hay nada pendiente no se gasta una invocación de
  -- Edge Function (se cobran por uso) ni se despierta a Firebase en balde.
  if not exists (
    select 1 from public.notificaciones
     where push_enviada = false
       and created_at > now() - interval '24 hours'
  ) then
    return null;
  end if;

  select net.http_post(
    url     := 'https://imcwrzldbssnmxtmoidl.supabase.co/functions/v1/enviar-push',
    headers := jsonb_build_object(
                 'Content-Type', 'application/json',
                 'x-cron-secret', v_secreto
               ),
    body    := '{}'::jsonb,
    timeout_milliseconds := 20000
  ) into v_peticion;

  return v_peticion;
end;
$$;

-- Como toda función nueva en `public`, se le cierra el acceso por REST.
-- Ver la nota sobre RPC en la migración 009.
revoke all on function public.disparar_envio_push() from public, anon, authenticated;

do $$
begin
  perform cron.unschedule('enviar-push');
exception when others then null;
end $$;

select cron.schedule(
  'enviar-push',
  '* * * * *',
  $$select public.disparar_envio_push();$$
);
