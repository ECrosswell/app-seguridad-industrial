/// Configuración de entorno.
///
/// Las credenciales llegan por `--dart-define` en cada run/build. No hay
/// archivo `.env` a propósito: en Flutter Web cualquier cosa que se empaquete
/// como asset queda legible desde el navegador, y un `.env` en el repositorio
/// termina en el control de versiones tarde o temprano.
///
/// La `anon key` no es un secreto — va embebida en el cliente por diseño y lo
/// que realmente protege los datos es el RLS de Postgres. La `service_role key`
/// **jamás** debe entrar a este proyecto.
library;

class EnvConfig {
  const EnvConfig._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Buckets de Storage. Separados porque tienen políticas de retención
  /// distintas: las identificaciones se purgan a los 90 días (LFPDPPP).
  static const String bucketEvidencias = 'evidencias';
  static const String bucketIdentificaciones = 'identificaciones';

  /// Las imágenes se sirven con URL firmada de vida corta. Nunca públicas: una
  /// URL pública de Storage no caduca y es indexable.
  static const Duration vigenciaUrlFirmada = Duration(minutes: 30);

  /// Máximo por imagen. `flutter_image_compress` la reduce hasta caber; el
  /// bucket rechaza cualquier cosa por encima.
  static const int maxBytesImagen = 3 * 1024 * 1024;

  static bool get estaConfigurado =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Falla temprano y con un mensaje útil. Sin esto, la app arranca y truena
  /// más adelante con un error de red incomprensible.
  static void validar() {
    if (!estaConfigurado) {
      throw StateError(
        'Faltan las credenciales de Supabase.\n'
        'Hay que pasarlas al correr o compilar:\n'
        '  --dart-define=SUPABASE_URL="https://xxx.supabase.co"\n'
        '  --dart-define=SUPABASE_ANON_KEY="eyJ..."',
      );
    }
  }
}
