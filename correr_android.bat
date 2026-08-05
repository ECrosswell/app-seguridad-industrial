@echo off
REM Corre la app Android en modo desarrollo.
REM
REM Las credenciales van por --dart-define y no en un archivo .env: en Flutter
REM Web cualquier asset empaquetado queda legible desde el navegador.
REM La anon key NO es un secreto (viaja embebida en el cliente por diseno);
REM lo que protege los datos es el RLS de Postgres.

set FLUTTER=C:\flutter_sdk\flutter\bin\flutter.bat
set SUPABASE_URL=https://imcwrzldbssnmxtmoidl.supabase.co
set SUPABASE_ANON_KEY=sb_publishable_QnE-6xNZfbA6spwvoyiV6w__wXdRQVH

"%FLUTTER%" run ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY% ^
  %*
