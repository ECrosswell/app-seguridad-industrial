@echo off
REM Compila la consola web y la publica en Vercel.
REM
REM El rewrite de vercel.json manda todo a index.html: sin eso, recargar la
REM pagina en una ruta como /panel/visitantes da 404, porque Vercel busca un
REM archivo que no existe (el enrutado lo hace Flutter en el cliente).

set FLUTTER=C:\flutter_sdk\flutter\bin\flutter.bat
set SUPABASE_URL=https://imcwrzldbssnmxtmoidl.supabase.co
set SUPABASE_ANON_KEY=sb_publishable_QnE-6xNZfbA6spwvoyiV6w__wXdRQVH

echo Compilando consola web...
"%FLUTTER%" build web -t lib/main_web.dart --release ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY%

if errorlevel 1 (
  echo.
  echo La compilacion fallo. No se publica nada.
  exit /b 1
)

echo.
echo Publicando en Vercel...
npx vercel deploy --prod
