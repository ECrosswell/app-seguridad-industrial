@echo off
REM Compila la app Android en modo Release (APK).

set FLUTTER=C:\flutter_sdk\flutter\bin\flutter.bat
set SUPABASE_URL=https://imcwrzldbssnmxtmoidl.supabase.co
set SUPABASE_ANON_KEY=sb_publishable_QnE-6xNZfbA6spwvoyiV6w__wXdRQVH

echo Compilando APK de Android (Release)...
"%FLUTTER%" build apk --release ^
  --dart-define=SUPABASE_URL=%SUPABASE_URL% ^
  --dart-define=SUPABASE_ANON_KEY=%SUPABASE_ANON_KEY% ^
  %*

if errorlevel 1 (
  echo.
  echo La compilacion de la APK fallo.
  exit /b 1
)

echo.
echo APK compilada con exito en build\app\outputs\flutter-apk\app-release.apk
