// Envía por FCM las notificaciones que siguen sin entregar.
//
// Se invoca cada minuto desde pg_cron (ver migración 010). Trabaja por barrido
// y no por disparo directo desde el trigger: si Firebase o la red fallan, la
// fila simplemente sigue con push_enviada = false y el siguiente ciclo la
// reintenta. Con un trigger que dispara y olvida, esa alerta se perdería.
//
// Autenticación: la función corre con verify_jwt = false porque quien la llama
// es pg_cron, no un usuario. En su lugar exige la cabecera x-cron-secret, y
// falla cerrado si no puede verificarla.
//
// Los secretos salen de **Vault** (migración 011) y no de variables de entorno:
// las variables sólo se cargan desde el panel de Supabase, mientras que Vault
// se puebla con una instrucción SQL. Se leen vía la RPC `obtener_secreto`,
// restringida a service_role.
//
//   cron_secret                cadena compartida con el job de pg_cron
//   firebase_service_account   JSON completo de la cuenta de servicio
//
// Para cargar o rotar la cuenta de Firebase:
//   select public.guardar_cuenta_firebase('<el JSON completo>');

import { createClient } from 'jsr:@supabase/supabase-js@2';

interface CuentaServicio {
  client_email: string;
  private_key: string;
  project_id: string;
  token_uri: string;
}

const FCM_SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';

// ─── OAuth para FCM v1 ───────────────────────────────────────────────────────

function base64url(datos: ArrayBuffer | string): string {
  const bytes = typeof datos === 'string'
    ? new TextEncoder().encode(datos)
    : new Uint8Array(datos);
  let binario = '';
  for (const b of bytes) binario += String.fromCharCode(b);
  return btoa(binario).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

/** Convierte la llave PEM de la cuenta de servicio a una CryptoKey. */
async function importarLlave(pem: string): Promise<CryptoKey> {
  const cuerpo = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\s/g, '');

  const binario = atob(cuerpo);
  const bytes = new Uint8Array(binario.length);
  for (let i = 0; i < binario.length; i++) bytes[i] = binario.charCodeAt(i);

  return crypto.subtle.importKey(
    'pkcs8',
    bytes.buffer,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  );
}

/**
 * Intercambia la cuenta de servicio por un access token de Google.
 *
 * FCM v1 ya no acepta la "server key" heredada: hay que firmar un JWT con la
 * llave privada y canjearlo.
 */
async function obtenerAccessToken(cuenta: CuentaServicio): Promise<string> {
  const ahora = Math.floor(Date.now() / 1000);

  const encabezado = base64url(JSON.stringify({ alg: 'RS256', typ: 'JWT' }));
  const carga = base64url(JSON.stringify({
    iss: cuenta.client_email,
    scope: FCM_SCOPE,
    aud: cuenta.token_uri,
    iat: ahora,
    exp: ahora + 3600,
  }));

  const llave = await importarLlave(cuenta.private_key);
  const firma = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    llave,
    new TextEncoder().encode(`${encabezado}.${carga}`),
  );

  const jwt = `${encabezado}.${carga}.${base64url(firma)}`;

  const respuesta = await fetch(cuenta.token_uri, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  });

  if (!respuesta.ok) {
    throw new Error(`No se pudo obtener access token: ${await respuesta.text()}`);
  }

  const { access_token } = await respuesta.json();
  return access_token;
}

// ─── Envío ───────────────────────────────────────────────────────────────────

interface ResultadoEnvio {
  ok: boolean;
  tokenInvalido: boolean;
  detalle?: string;
}

async function enviarAFcm(
  accessToken: string,
  projectId: string,
  token: string,
  titulo: string,
  cuerpo: string,
  datos: Record<string, string>,
  critica: boolean,
): Promise<ResultadoEnvio> {
  const respuesta = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: {
          token,
          // El bloque `notification` es lo que hace que Android despliegue el
          // aviso solo cuando la app está cerrada. Sin él sólo llegarían datos
          // y no se vería nada.
          notification: { title: titulo, body: cuerpo },
          data: datos,
          android: {
            priority: critica ? 'HIGH' : 'NORMAL',
            notification: {
              channel_id: 'alertas_operativas',
              sound: 'default',
            },
          },
        },
      }),
    },
  );

  if (respuesta.ok) return { ok: true, tokenInvalido: false };

  const texto = await respuesta.text();

  // 404 UNREGISTERED o 400 con token inválido: el dispositivo desinstaló la
  // app o borró sus datos. Se desactiva para no seguir intentando por siempre.
  const tokenInvalido = respuesta.status === 404 ||
    texto.includes('UNREGISTERED') ||
    texto.includes('INVALID_ARGUMENT');

  return { ok: false, tokenInvalido, detalle: texto };
}

// ─── Punto de entrada ────────────────────────────────────────────────────────

function json(cuerpo: unknown, status = 200): Response {
  return new Response(JSON.stringify(cuerpo), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

Deno.serve(async (peticion) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  // ─── Autenticación ─────────────────────────────────────────────────────────
  const { data: cronSecret, error: errorSecreto } = await supabase
    .rpc('obtener_secreto', { p_nombre: 'cron_secret' });

  if (errorSecreto) {
    console.error('No se pudo leer cron_secret de Vault:', errorSecreto);
    return json({ error: 'configuración incompleta' }, 500);
  }

  if (!cronSecret || peticion.headers.get('x-cron-secret') !== cronSecret) {
    return json({ error: 'no autorizado' }, 401);
  }

  // ─── Cuenta de servicio ────────────────────────────────────────────────────
  const { data: cuentaJson } = await supabase
    .rpc('obtener_secreto', { p_nombre: 'firebase_service_account' });

  if (!cuentaJson) {
    return json({
      error: 'Falta la cuenta de servicio de Firebase en Vault.',
      comoResolver:
        "Corre en el SQL editor: select public.guardar_cuenta_firebase('<el JSON completo>');",
    }, 503);
  }

  let cuenta: CuentaServicio;
  try {
    cuenta = JSON.parse(cuentaJson);
  } catch (_e) {
    return json({ error: 'La cuenta de servicio guardada no es JSON válido' }, 500);
  }

  try {
    // Sólo lo reciente: una alerta de hace dos días ya no le sirve a nadie y
    // reenviarla al reconectar sería ruido.
    const desde = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();

    const { data: pendientes, error } = await supabase
      .from('notificaciones')
      .select('id, destinatario_id, tipo, titulo, cuerpo, prioridad, entidad_tipo, entidad_id')
      .eq('push_enviada', false)
      .gte('created_at', desde)
      .order('created_at', { ascending: true })
      .limit(100);

    if (error) throw error;
    if (!pendientes || pendientes.length === 0) {
      return json({ enviadas: 0, sinPendientes: true });
    }

    const accessToken = await obtenerAccessToken(cuenta);

    let enviadas = 0;
    let sinDispositivo = 0;
    const tokensInvalidos: string[] = [];

    for (const n of pendientes) {
      const { data: dispositivos } = await supabase
        .from('dispositivos_push')
        .select('fcm_token')
        .eq('usuario_id', n.destinatario_id)
        .eq('activo', true);

      if (!dispositivos || dispositivos.length === 0) {
        // El destinatario no tiene la app instalada o no dio permiso. Se marca
        // igual como enviada: sin dispositivo no hay nada que reintentar, y
        // dejarla pendiente la haría reprocesarse cada minuto para siempre.
        await supabase
          .from('notificaciones')
          .update({ push_enviada: true, push_enviada_at: new Date().toISOString() })
          .eq('id', n.id);
        sinDispositivo++;
        continue;
      }

      let algunoLlego = false;

      for (const d of dispositivos) {
        const resultado = await enviarAFcm(
          accessToken,
          cuenta.project_id,
          d.fcm_token,
          n.titulo,
          n.cuerpo ?? '',
          {
            notificacion_id: n.id,
            tipo: n.tipo ?? '',
            prioridad: n.prioridad ?? 'normal',
            entidad_tipo: n.entidad_tipo ?? '',
            entidad_id: n.entidad_id ?? '',
          },
          n.prioridad === 'critica',
        );

        if (resultado.ok) {
          algunoLlego = true;
        } else if (resultado.tokenInvalido) {
          tokensInvalidos.push(d.fcm_token);
        } else {
          console.error(`FCM falló para ${n.id}: ${resultado.detalle}`);
        }
      }

      if (algunoLlego) {
        await supabase
          .from('notificaciones')
          .update({ push_enviada: true, push_enviada_at: new Date().toISOString() })
          .eq('id', n.id);
        enviadas++;
      }
    }

    if (tokensInvalidos.length > 0) {
      await supabase
        .from('dispositivos_push')
        .update({ activo: false })
        .in('fcm_token', tokensInvalidos);
    }

    return json({
      revisadas: pendientes.length,
      enviadas,
      sinDispositivo,
      tokensDesactivados: tokensInvalidos.length,
    });
  } catch (e) {
    console.error('Error al enviar push:', e);
    return json({ error: String(e) }, 500);
  }
});
