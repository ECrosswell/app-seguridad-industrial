@echo off
REM Sirve la consola web en 127.0.0.1:8080 para desarrollo y pruebas.
REM A diferencia de correr_web.bat, este no abre Chrome: expone un servidor
REM al que se puede conectar cualquier navegador.

cd /d "%~dp0"

set SUPABASE_URL=https://imcwrzldbssnmxtmoidl.supabase.co
set SUPABASE_ANON_KEY=sb_publishable_QnE-6xNZfbA6spwvoyiV6w__wXdRQVH

C:\flutter_sdk\flutter\bin\flutter.bat run -d web-server ^
  -t lib/main_web.dart ^
  --web-port 8080 ^
  --web-hostname 127.0.0.1 ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY%
