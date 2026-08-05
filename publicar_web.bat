@echo off
REM Compila la consola web y la publica en Vercel.
REM
REM Dos archivos son indispensables para que esto funcione, y si falta
REM cualquiera de los dos el despliegue responde 404:
REM
REM   .vercelignore  Sin el, el CLI usa el .gitignore de Flutter, que excluye
REM                  /build/ — y build/web nunca se sube.
REM   vercel.json    El rewrite manda todo a index.html; sin el, recargar en
REM                  una ruta como /panel/visitantes da 404 porque Vercel busca
REM                  un archivo que no existe (el enrutado lo hace Flutter).

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
