# CLAUDE.md

Guía para Claude Code (claude.ai/code) al trabajar en este repositorio.

> Contexto de workspace: este proyecto vive dentro de `C:\Programacion`. El `CLAUDE.md` raíz tiene las convenciones cruzadas (vocabulario de dominio en español, Windows + PowerShell/Git Bash). Este archivo es autoritativo para App Seguridad Industrial.

## Qué es este proyecto

App de control de servicio de seguridad privada en planta industrial. Un solo código Dart entrega dos productos:

- **Android (nativo)** — app operativa del `elemento` y del `supervisor` en la caseta. Escribe datos. **Offline-first** con Drift.
- **Web (Flutter Web)** — consola del `admin` (empresa de seguridad) y del `cliente` (la fábrica). Sólo lectura y administración. **Sin Drift, sin motor de sincronización** — habla directo con Supabase.

El backend es Supabase (Postgres + Auth + Storage + Realtime + pg_cron).

## Estado actual

App completa en ambas plataformas. Android y web compilan; `flutter analyze` sale limpio y las pruebas pasan.

**Backend** — migraciones 001 → 009 aplicadas, seed corrido (sitio "Fábrica" con 3 partidas de equipo y aviso de privacidad v1.0), 3 jobs de pg_cron activos.

**Android** (elemento y supervisor): login con cambio de contraseña forzado, asistencia con geocerca + BSSID + prueba de vida, recepción de turno con armamento, control de acceso de visitantes, bitácora, notificaciones, perfil. Todo offline-first.

**Web** (admin y cliente): tablero en vivo, historial de turnos con revisión de asistencias, visitantes, bitácora, estado del equipo, solicitudes, reportes PDF/CSV y administración de sitios y usuarios.

Verificado en la base con datos de prueba (ya borrados): el bootstrap de perfil desde `auth.users` funciona, y la clasificación de puntualidad da `a_tiempo` a las 08:00, `retardo` a las 08:30 (30 min) y `falta` a las 09:45 (105 min).

### Cuenta inicial

La cuenta administradora se provisiona fuera del repositorio. No documentar
correos, contraseñas temporales ni credenciales de producción en archivos
versionados.

## Notificaciones — dos canales complementarios

| Canal | Cubre | Implementación |
|---|---|---|
| **Realtime** | App abierta | `NotificacionesService` escucha `public.notificaciones` y levanta una notificación local |
| **FCM** | App cerrada o en segundo plano | `PushService` registra el token; `pg_cron` → Edge Function `enviar-push` → Firebase |

Los dos usan el mismo id de notificación (`uuid.hashCode`), y `show()` reemplaza por id: si ambos entregan el mismo aviso, no se duplica.

### Cómo viaja un push

1. Un trigger inserta en `notificaciones` con `push_enviada = false`
2. `pg_cron` corre `disparar_envio_push()` cada minuto (migración 010)
3. La función sale temprano si no hay pendientes — no gasta invocaciones de Edge Function en balde
4. Si hay, llama a `enviar-push` con el header `x-cron-secret` (el secreto vive en **Vault**, no en `cron.job`, que es legible)
5. La Edge Function firma un JWT con la cuenta de servicio, lo canja por un access token de Google y manda a **FCM v1**
6. Marca `push_enviada = true`. Si falla, la fila se queda pendiente y el siguiente ciclo reintenta

Se eligió **barrido y no disparo directo desde el trigger** justamente por el paso 6: un trigger que dispara y olvida perdería la alerta sin que nadie se entere.

### Proyecto Firebase

- Proyecto: `seguridad-industrial-dc4f3`
- Paquete Android: `com.tesnal.seguridad_industrial`
- `android/app/google-services.json` **sí se versiona**: no contiene secretos, sólo identificadores públicos acotados al nombre del paquete. La cuenta de servicio (que sí es secreta) **nunca** entra al repositorio — vive como variable de entorno de la Edge Function.

### Secretos — viven en Vault, no en variables de entorno

Los dos secretos que necesita la Edge Function están en **Supabase Vault** dentro de la propia base, cifrados. Se eligió así (migración 011) porque las variables de entorno de una Edge Function sólo se cargan desde el panel de Supabase o con un token de administración, mientras que Vault se puebla con una instrucción SQL — reproducible desde el editor, un script o una migración.

| Secreto en Vault | Contenido |
|---|---|
| `cron_secret` | Cadena compartida entre `pg_cron` y la función. Se genera sola en la migración 010 |
| `firebase_service_account` | JSON completo de la cuenta de servicio de Firebase |

La lectura pasa por `obtener_secreto(text)`, con `EXECUTE` concedido **sólo a `service_role`** — el rol que tiene la Edge Function y ningún cliente.

Para cargar o **rotar** la llave de Firebase:

```sql
select public.guardar_cuenta_firebase('<el JSON completo de la cuenta de servicio>');
```

Valida que el JSON traiga `private_key`, `client_email` y `project_id` antes de guardarlo; una llave mal pegada se rechaza ahí en vez de descubrirse cuando un push falle en silencio.

Para consultar el secreto del cron: `select decrypted_secret from vault.decrypted_secrets where name = 'cron_secret';`

### Diagnóstico cuando no llegan los push

```sql
select id, status_code, left(coalesce(content, error_msg, ''), 200) as respuesta
  from net._http_response order by created desc limit 5;
```

| Código | Qué significa |
|---|---|
| `503` | Falta `firebase_service_account` en Vault. La tubería está bien; sólo falta la llave |
| `401` | El header `x-cron-secret` no coincide con `cron_secret` de Vault |
| `500` | Error de la función — revisar sus logs en el panel |
| Sin filas | `pg_cron` no está corriendo, o no hay notificaciones pendientes (la función sale temprano a propósito) |

La función **falla cerrado**: si no puede verificar el secreto, rechaza. Nunca se abre por omisión de configuración.

Sólo Android. El push en navegador necesitaría claves VAPID y un service worker propio; el administrador usa el teléfono para las alertas.

### Lo que falta

- Capturar la geocerca real de la fábrica y los BSSID de sus access points, desde `Sitios` en la consola
- Icono y splash de marca
- Revisión legal del texto del aviso de privacidad

## Proyecto Supabase

| | |
|---|---|
| Nombre | `seguridad-industrial` |
| Ref | `imcwrzldbssnmxtmoidl` |
| Región | us-west-1 |
| URL | `https://imcwrzldbssnmxtmoidl.supabase.co` |
| Publishable key | `sb_publishable_QnE-6xNZfbA6spwvoyiV6w__wXdRQVH` |
| Costo | $10 USD/mes |

La publishable key **no es un secreto** — viaja embebida en el cliente por diseño y lo que protege los datos es el RLS. La `service_role key` jamás debe entrar a este repositorio.

## Decisiones tomadas (no volver a litigar)

Estas salieron de un cuestionario con el usuario. Están cerradas salvo que él las reabra.

| Tema | Decisión | Por qué |
|---|---|---|
| Plataforma | Flutter, Android + Web desde un código | Debe correr en Android y en web; Kotlin obligaría a escribir la web aparte |
| Punto de partida | Proyecto nuevo copiando módulos de `App Plaza Encuentro`, **no** un fork | Plaza tiene ~34 features irrelevantes (locatarios, motos, estacionamiento, CCTV, rondines) y 40+ migraciones con colisiones de número. Además Plaza corre en Dart 3.6 con `drift 2.28.2` + override de `analyzer 7.3.0` que son *load-bearing* ahí y dañinos aquí (este proyecto usa Dart 3.12) |
| Multi-sitio | Sí, desde el inicio | Hoy es una fábrica, podrían ser dos. El modelo ya lo admite sin migración |
| Offline | **Offline-first con Drift en Android.** Web sólo online | Lo pidió explícitamente |
| Supabase | Proyecto nuevo, separado de `plaza-encuentro` | RLS aislado, sin riesgo sobre producción de Plaza |
| Riverpod | v3 **sin** code-generation | Proyecto nuevo debe arrancar en la major vigente. Sin codegen de Riverpod el único generador es Drift — evita exactamente la trampa de pins de versión en la que cayó Plaza |
| Reconocimiento facial | **No.** Sólo prueba de vida + selfie de evidencia | El reconocimiento 1:1 es dato biométrico bajo LFPDPPP y exige consentimiento expreso por escrito de cada elemento. La prueba de vida da el control antifraude sin entrar a ese régimen |
| Hosting web | Vercel | |
| Notificaciones | Fila en `notificaciones` + Realtime (en app) y FCM (app cerrada) | FCM requiere que el usuario cree el proyecto Firebase — pendiente |

## Reglas de negocio

Configurables por sitio en la tabla `sitios`; los valores por defecto son los de la fábrica actual.

**Turnos**
- Turno de **24 h** que arranca a las **08:00**
- `08:01` en adelante → **retardo**
- `09:30` en adelante (hora y media) → **falta**
- `09:00` (1 h de tolerancia) → si no llegó el relevo, **alerta al admin** y el turno saliente se marca **doblete**
- Si el elemento olvida marcar salida **no se cierra solo**: se alerta al admin y él lo cierra a mano, quedando constancia de quién y por qué
- Un elemento puede cubrir un sitio distinto al asignado (`es_cobertura`)
- Se registran descansos/comidas (`inicio_descanso` / `fin_descanso`)

**Asistencia**
- Geo-referencia + selfie con prueba de vida, en entrada y salida
- Validación por GPS (geocerca) **y** por BSSID de WiFi de la planta. El BSSID es la MAC del AP: valida presencia física aunque el GPS falle bajo techo industrial, y no se clona como un SSID
- **Nunca se le bloquea el registro al elemento.** Si no valida, entra como `pendiente_revision` y el supervisor resuelve
- La clasificación (a tiempo / retardo / falta) la calcula un trigger en el servidor, no el cliente — si no, una app modificada podría mandarse un `a_tiempo`
- El **supervisor** registra sus visitas de supervisión con el mismo mecanismo (`tipo_evento = 'supervision'`)

**Visitantes**
- Nombre completo, a quién visita, asunto, empresa de procedencia, vehículo y placas
- Identificación fotografiada **opcional**
- "A quién visita" sale del catálogo `personal_cliente` que mantiene el cliente, con `persona_visitada_texto` como respaldo mientras el catálogo se puebla
- Salida con un toque desde la lista de "quién está adentro" (`v_visitantes_dentro`)
- Visitantes recurrentes en el catálogo `visitantes` para no recapturar
- **Sin gafetes** — no se controla devolución

**Bitácora**
- Tipos: `salida_mercancia`, `ingreso_materia_prima`, `entrada_vehiculo`, `salida_vehiculo`, `falla_infraestructura`, `incidente_seguridad`, `ronda`, `correspondencia`, `libre`
- En movimientos de mercancía, **placas + destino + quién autorizó son obligatorios**. Lo impone un CHECK en la base, no la UI
- Se agrupa por turno; el histórico se consulta por rango de fechas
- Fallas e incidentes arrastran `requiere_seguimiento` para que no se pierdan al cambiar de turno

**Equipo / armamento**
- Inventario actual: **escopeta no letal, porta fusil, tanques de gas llenos**
- **No serializado** — por partida y cantidad
- Asignado **por sitio/caseta**, no por elemento: la misma escopeta la usan ambos turnos
- Sólo **quien recibe** firma conformidad (aceptación explícita con sello de tiempo, no garabato en pantalla)
- Estados: `perfecto` / `usado` / `danado` / `falta`
- Si reporta novedad, **el turno NO se bloquea** — sigue operando y viaja la alerta al admin

**Cliente**
- Varios usuarios, **todos ven todo** (por ahora sin permisos diferenciados)
- Ve asistencias, bitácora, visitantes, incidencias
- Contacta al elemento por **WhatsApp directo** (`wa.me/`, campo `profiles.telefono_whatsapp`) — no hay chat interno
- Levanta solicitudes → notifican al supervisor
- Reportes descargables (PDF/Excel) con periodicidad libre

**Cuentas**
- El **admin** da de alta, de baja y reingresa elementos (`estado_laboral`)
- Cuenta con contraseña temporal; `debe_cambiar_password` fuerza el cambio en el primer ingreso
- Sin auto-registro

## Protección de datos (LFPDPPP)

No es un detalle decorativo, es requisito legal y está construido en el esquema:

- La foto de identificación del visitante se purga **a los 90 días**. `registros_acceso.identificacion_purgar_at` la agenda; la rutina diaria `marcar_identificaciones_vencidas()` la marca y anula la URL, conservando constancia de que existió y se eliminó
- El visitante acepta un **aviso de privacidad versionado** (`avisos_privacidad`) y se guarda **qué versión** aceptó — eso es lo que hace defendible el consentimiento
- Los buckets de Storage son **privados**; las imágenes se sirven con URLs firmadas de vida corta. Nunca enlaces públicos: una URL pública de Storage no caduca y es indexable
- El cliente **no** ve las identificaciones de los visitantes — no las necesita
- No se procesan datos biométricos (ver decisión sobre reconocimiento facial arriba)

## Comandos

Flutter **no está en el PATH**. Usar la ruta completa `C:\flutter_sdk\flutter\bin\flutter.bat`, o los lanzadores `.bat` de la raíz del proyecto, que ya traen las credenciales:

| Lanzador | Qué hace |
|---|---|
| `correr_android.bat` | App Android en el dispositivo conectado |
| `correr_web.bat` | Consola web en Chrome |
| `servidor_web.bat` | Consola web servida en `127.0.0.1:8080` (para probar desde otro navegador) |
| `publicar_web.bat` | Compila y publica en Vercel |

```bash
C:\flutter_sdk\flutter\bin\flutter.bat --version
```

```bash
C:\flutter_sdk\flutter\bin\flutter.bat pub get
```

Generación de código (sólo Drift; Riverpod va sin codegen):

```bash
C:\flutter_sdk\flutter\bin\flutter.bat pub run build_runner build --delete-conflicting-outputs
```

Correr Android:

```bash
C:\flutter_sdk\flutter\bin\flutter.bat run --dart-define=SUPABASE_URL="..." --dart-define=SUPABASE_ANON_KEY="..."
```

Correr web (entry point distinto — hay que pasar `-t`):

```bash
C:\flutter_sdk\flutter\bin\flutter.bat run -d chrome -t lib/main_web.dart --dart-define=SUPABASE_URL="..." --dart-define=SUPABASE_ANON_KEY="..."
```

Análisis y pruebas:

```bash
C:\flutter_sdk\flutter\bin\flutter.bat analyze
```

```bash
C:\flutter_sdk\flutter\bin\flutter.bat test
```

Builds:

```bash
C:\flutter_sdk\flutter\bin\flutter.bat build apk --release
```

```bash
C:\flutter_sdk\flutter\bin\flutter.bat build web -t lib/main_web.dart --release
```

## Despliegue web (Vercel)

`publicar_web.bat` compila y publica. Dos archivos de la raíz son **indispensables**; si falta cualquiera, el sitio responde 404 completo:

| Archivo | Por qué |
|---|---|
| `.vercelignore` | Sin él, el CLI de Vercel usa el `.gitignore` de Flutter, que excluye `/build/`. Resultado: `build/web` nunca se sube y el despliegue queda vacío. **Ya pasó una vez.** |
| `vercel.json` | `framework`, `buildCommand` e `installCommand` en `null` (el bundle ya viene compilado; sin eso Vercel intenta detectar y construir). El `rewrite` a `/index.html` es lo que permite recargar en rutas como `/panel/visitantes` |

En `.vercelignore` el orden importa: primero `build/**` y después `!build/web/**`. Con `build/` a secas (excluyendo el directorio entero) no se puede readmitir lo de adentro.

`vercel.json` **no admite claves desconocidas** — no se le pueden meter comentarios en forma de `"// nota"`, los rechaza la validación.

## Base de datos

Migraciones numeradas en `supabase/migrations/`. **Sin colisiones de número** — es una regla, no una casualidad: Plaza Encuentro tiene varias (`019_consignas_admin.sql` vs `019_fix_attendance_rls.sql`) y vuelven ambiguo el orden de aplicación.

| Archivo | Contenido |
|---|---|
| `001_perfiles_y_sitios.sql` | Roles, `profiles`, `sitios` con geocerca, `usuario_sitios`, APs WiFi, helpers de RLS |
| `002_asistencias_y_turnos.sql` | `asistencias` (eventos) + `turnos` (estado derivado), clasificación de puntualidad, vista `v_personal_en_sitio` |
| `003_control_accesos.sql` | Visitantes, registros de acceso, `personal_cliente`, avisos de privacidad, vista `v_visitantes_dentro` |
| `004_bitacora.sql` | Eventos de bitácora + fotos, vista `v_bitacora_pendientes` |
| `005_equipo_y_recepcion_turno.sql` | Catálogo de equipo por sitio, recepciones de turno, vista `v_estado_equipo_sitio` |
| `006_notificaciones_y_solicitudes.sql` | Notificaciones + Realtime, tokens FCM, solicitudes del cliente, triggers de alerta |
| `007_storage_y_retencion.sql` | Buckets `evidencias` e `identificaciones` con sus políticas |
| `008_alertas_programadas.sql` | Rutinas pg_cron: relevo no llegó, salidas pendientes, purga de identificaciones |
| `009_blindar_funciones_rpc.sql` | Revoca `EXECUTE` en las funciones que no deben exponerse como REST |
| `010_disparador_push.sql` | pg_net + Vault + job que invoca la Edge Function `enviar-push` cada minuto |

Edge Functions en `supabase/functions/`: `enviar-push` (FCM v1, `verify_jwt = false` con autenticación propia por header).

### Antes de revocar una función, revisa si alguna policy la usa

**Esto ya causó un bug en producción** (migraciones 009 → 012). Las policies de RLS se evalúan **con los privilegios de quien consulta**, no del dueño de la tabla. Si se revoca `EXECUTE` sobre una función que una policy referencia, esa policy revienta con `permission denied for function ...` para todos los usuarios de ese rol.

Pasó con `uuid_seguro`: se revocó al blindar los RPC sin notar que la policy de lectura de `evidencias` la usa. Resultado: **ninguna imagen se subió nunca**, y como la asistencia no puede empujar su fila sin la selfie, las asistencias quedaron atoradas en los teléfonos durante días. Lo demás sí subía, porque iba sin foto — lo que hacía ver el problema como "la sincronización no sirve".

Auditoría para correr después de cualquier cambio de permisos:

```sql
with funciones_en_policies as (
  select distinct f.proname
  from pg_policies pol
  cross join lateral (
    select p.proname from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and (coalesce(pol.qual,'') || ' ' || coalesce(pol.with_check,'')) like '%' || p.proname || '(%'
  ) f
  where pol.schemaname in ('public','storage')
)
select f.proname,
       case when has_function_privilege('authenticated', p.oid, 'EXECUTE')
            then 'OK' else '*** ROMPE LA POLICY ***' end as estado
from funciones_en_policies f
join pg_proc p on p.proname = f.proname
join pg_namespace n on n.oid = p.pronamespace and n.nspname = 'public';
```

### Storage necesita INSERT **y** UPDATE

`FotoService.subir` usa `upsert: true` para que un reintento sobre la misma ruta no falle. Eso hace UPDATE cuando el objeto ya existe, así que **ambas policies son necesarias**. Con sólo INSERT, el reintento tras una caída de red se rechaza y la fila queda atorada (migración 013).

### Funciones y RPC — leer antes de agregar una función

Supabase publica **toda** función del esquema `public` como endpoint REST en `/rest/v1/rpc/<nombre>`. Una función `SECURITY DEFINER` recién creada queda invocable por cualquiera, incluso sin sesión.

Eso ya causó un agujero real que arregla la 009: `notificar_rol` inserta notificaciones con privilegios elevados y no valida quién la llama (se escribió asumiendo que sólo la invocarían triggers). Expuesta, cualquiera podía falsificarle al administrador una alerta de "relevo no llegó".

**Al agregar cualquier función nueva a `public`, revocarle `EXECUTE` a `public, anon, authenticated` salvo que esté pensada para llamarse desde la app.** Revocar no rompe triggers — Postgres no verifica ese privilegio al dispararlos — ni jobs de pg_cron, que corren como el dueño del job.

Correr `get_advisors` después de cada cambio de DDL.

### Convenciones del esquema

Toda tabla operativa (las que escribe el Android offline) lleva:

- `id uuid` — PK del servidor
- `local_id text unique` — **UUID generado por el cliente**. Es la clave de idempotencia del motor de sincronización: el upsert va contra `local_id`, así reintentar nunca duplica
- `device_id text` — dispositivo de origen, para auditoría
- `deleted_at` — borrado lógico, nunca `DELETE` físico
- `updated_by` — quién tocó la fila

### RLS

Está activo en **todas** las tablas. Cuando una consulta regrese vacío sin razón aparente, sospechar de RLS antes que del código.

Helpers (todos `SECURITY DEFINER` con `search_path` fijo — sin el definer, una policy sobre `profiles` que consulte `profiles` entra en recursión infinita):

- `rol_actual()` → rol del usuario autenticado
- `es_admin()` → booleano
- `tiene_acceso_sitio(uuid)` → admin siempre; el resto según `usuario_sitios`

### Crear usuarios a mano — trampa conocida

Si se inserta directo en `auth.users` con SQL (en lugar de usar el panel de Supabase o la Admin API), hay que poner **cadena vacía y no NULL** en `confirmation_token`, `recovery_token`, `email_change_token_new`, `email_change_token_current`, `email_change`, `phone_change`, `phone_change_token` y `reauthentication_token`.

GoTrue lee esas columnas como `string` de Go, que no admite `NULL`. Con una sola en NULL, **todo el login del proyecto** falla con un `500 Database error querying schema` que no menciona la causa por ningún lado. Ya pasó una vez aquí.

Lo normal es crear las cuentas desde el panel (Authentication → Add user), que las llena bien solo.

### Zona horaria

Se guarda como **offset numérico** (`sitios.huso_horario_offset_h`, default `-6`), no como nombre de zona. Razón: `timestamptz at time zone 'texto'` es `STABLE`, no `IMMUTABLE`, y Postgres lo rechaza en columnas generadas. Ciudad de México es UTC-6 fijo desde que se eliminó el horario de verano en 2022.

Al convertir `date + time` a `timestamptz` **siempre** anclar con `at time zone 'UTC'` explícito, en lugar de confiar en el `TimeZone` de la sesión.

## Arquitectura de la app

Clean Architecture en 3 capas dentro de `lib/`, igual que Plaza:

| Capa | Directorio | Responsabilidad |
|---|---|---|
| Presentación | `lib/features/<feature>/presentation/` | Widgets, pantallas |
| Estado | `lib/features/<feature>/providers/` | Riverpod, lógica y efectos |
| Datos | `lib/data/` | Drift (`local/`), Supabase (`remote/`), sync (`sync/`), modelos (`models/`) |

Infraestructura compartida en `lib/core/`, widgets transversales en `lib/shared/widgets/`.

### Dos entry points, dos routers

| Objetivo | Entry | Router | DB local | Sync |
|---|---|---|---|---|
| Android | `lib/main.dart` | `core/config/app_router.dart` | Drift | sí |
| Web | `lib/main_web.dart` | `core/config/app_router_web.dart` | ninguna | no |

Al agregar una pantalla hay que decidir a qué router(s) pertenece. **Los providers que dependen de Drift no se pueden referenciar desde pantallas web.**

## Variables de entorno

Vía `--dart-define` en cada run/build. No hay archivo `.env` a propósito: en Flutter Web cualquier asset empaquetado queda legible desde el navegador.

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

Los lanzadores `correr_android.bat` y `correr_web.bat` ya las traen puestas — es la forma normal de arrancar en desarrollo.

## Idioma

Identificadores, strings de UI, enums y comentarios en **español** (`elemento`, `supervisor`, `sitio`, `bitácora`, `recepción de turno`, `novedades`). Es el idioma operativo del cliente, no deuda de traducción. Preservarlo.

## Pendientes con el usuario

- **Proyecto Firebase** para FCM (push con la app cerrada). Lo tiene que crear él con su cuenta de Google. Pidió que se le explique **paso a paso, un paso a la vez** cuando se llegue a eso
- **Coordenadas y radio** de la geocerca de la fábrica; se capturan desde el panel de admin parándose en la puerta
- **BSSIDs** de los access points de la planta
- Volumen esperado (elementos, visitantes/día) para dimensionar el plan de Supabase
- Versión mínima de Android / gama de los equipos
- Revisión legal del texto del aviso de privacidad (el sembrado es un borrador operativo)

Resuelto: la app se llama **Seguridad Industrial** y el `applicationId` `com.tesnal.seguridad_industrial` se queda.
