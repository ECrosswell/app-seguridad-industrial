@echo off
REM Compila la consola web y la publica en Vercel.
REM
REM El despliegue usa la especificación Build Output API de Vercel. Así se
REM publica exactamente el contenido de build/web y no la raíz del proyecto.
REM
REM   scripts\prepare-vercel-output.mjs  Empaqueta los archivos estáticos y
REM                                      configura el fallback de la SPA.

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
echo Empaquetando artefacto para Vercel...
node scripts\prepare-vercel-output.mjs

if errorlevel 1 (
  echo.
  echo El empaquetado fallo. No se publica nada.
  exit /b 1
)

echo.
echo Publicando en Vercel...
npx --yes vercel@58.1.0 deploy --prebuilt --prod --yes
