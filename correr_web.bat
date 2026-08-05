@echo off
REM Corre la consola web (admin y cliente) en Chrome.
REM
REM Ojo: la web usa OTRO entry point. Sin -t lib/main_web.dart arrancaria la
REM app de Android, que depende de Drift y no compila para navegador.

set FLUTTER=C:\flutter_sdk\flutter\bin\flutter.bat
set SUPABASE_URL=https://imcwrzldbssnmxtmoidl.supabase.co
set SUPABASE_ANON_KEY=sb_publishable_QnE-6xNZfbA6spwvoyiV6w__wXdRQVH

"%FLUTTER%" run -d chrome -t lib/main_web.dart ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY% ^
  %*
