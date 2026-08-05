import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env_config.dart';
import 'app_logger.dart';

/// Punto único de acceso a Supabase.
///
/// Envuelve el cliente para no regar `Supabase.instance.client` por todo el
/// código: si mañana cambia la inicialización o hay que interceptar peticiones,
/// se toca aquí y nada más.
class SupabaseService {
  const SupabaseService._();

  static bool _inicializado = false;

  static Future<void> inicializar() async {
    if (_inicializado) return;
    EnvConfig.validar();

    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      // `anonKey` quedó obsoleto a favor de `publishableKey`. El nombre de la
      // variable de entorno se mantiene como SUPABASE_ANON_KEY porque es el
      // que sigue usando la documentación de Supabase; el valor que recibe es
      // una llave `sb_publishable_...`.
      publishableKey: EnvConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        // La sesión se persiste para que el elemento no tenga que capturar su
        // contraseña cada vez que abre la app en la caseta.
        autoRefreshToken: true,
      ),
    );

    _inicializado = true;
    AppLogger.i('Supabase inicializado');
  }

  static SupabaseClient get cliente => Supabase.instance.client;

  static GoTrueClient get auth => cliente.auth;

  static User? get usuarioActual => auth.currentUser;

  static String? get usuarioId => auth.currentUser?.id;

  static bool get haySesion => auth.currentSession != null;

  static Stream<AuthState> get cambiosDeAuth => auth.onAuthStateChange;

  /// URL firmada de vida corta para una imagen privada.
  ///
  /// Los buckets son privados a propósito: una URL pública de Storage no caduca
  /// y es indexable, lo que dejaría fotos de identificaciones accesibles a
  /// quien tuviera la liga.
  static Future<String> urlFirmada(String bucket, String ruta) {
    return cliente.storage.from(bucket).createSignedUrl(
          ruta,
          EnvConfig.vigenciaUrlFirmada.inSeconds,
        );
  }
}
