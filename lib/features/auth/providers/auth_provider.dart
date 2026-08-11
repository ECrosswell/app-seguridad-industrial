import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/app_logger.dart';
import '../../../core/services/supabase_service.dart';
import '../../../data/models/perfil.dart';
import '../data/perfil_local_cache.dart';

/// Estado de autenticación de la app.
sealed class EstadoAuth {
  const EstadoAuth();
}

class AuthCargando extends EstadoAuth {
  const AuthCargando();
}

class AuthSinSesion extends EstadoAuth {
  const AuthSinSesion({this.mensaje});

  final String? mensaje;
}

class AuthAutenticado extends EstadoAuth {
  const AuthAutenticado(this.perfil);

  final Perfil perfil;

  /// El admin crea las cuentas con contraseña temporal. Hasta que el usuario la
  /// cambie, el enrutador lo retiene en la pantalla de cambio: si se le dejara
  /// entrar, la contraseña temporal —que el admin conoce— seguiría siendo
  /// válida indefinidamente.
  bool get debeCambiarPassword => perfil.debeCambiarPassword;
}

/// Perfil del usuario en sesión, o null.
final perfilActualProvider = Provider<Perfil?>((ref) {
  final estado = ref.watch(authControllerProvider);
  return estado is AuthAutenticado ? estado.perfil : null;
});

final authControllerProvider = NotifierProvider<AuthController, EstadoAuth>(
  AuthController.new,
);

class AuthController extends Notifier<EstadoAuth> {
  @override
  EstadoAuth build() {
    _escucharCambiosDeSesion();

    // También se intenta el perfil cacheado para continuar sin red dentro del
    // mismo arranque y de la misma sesión. La primera sesión exige conexión.
    Future.microtask(_cargarPerfil);
    return const AuthCargando();
  }

  void _escucharCambiosDeSesion() {
    final sub = SupabaseService.cambiosDeAuth.listen((evento) async {
      switch (evento.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
        case AuthChangeEvent.userUpdated:
          await _cargarPerfil();
        case AuthChangeEvent.signedOut:
          state = const AuthSinSesion();
        default:
          break;
      }
    });
    ref.onDispose(sub.cancel);
  }

  Future<void> _cargarPerfil() async {
    final id = SupabaseService.usuarioId;
    final sessionId = _sessionIdActual();
    try {
      if (id == null) throw const AuthException('offline_without_session');
      final fila = await SupabaseService.cliente
          .from('profiles')
          .select()
          .eq('id', id)
          .single();

      final perfil = Perfil.desdeJson(fila);

      // Una cuenta dada de baja no debe poder entrar aunque su usuario de auth
      // siga existiendo: el admin da de baja en `profiles`, no en `auth.users`.
      if (!perfil.activo || perfil.estadoLaboral.valor == 'baja') {
        await SupabaseService.auth.signOut();
        state = const AuthSinSesion(
          mensaje: 'Tu cuenta está dada de baja. Contacta al administrador.',
        );
        return;
      }

      if (sessionId == null) {
        await PerfilLocalCache.limpiar();
      } else {
        await PerfilLocalCache.guardar(perfil, sessionId: sessionId);
      }
      state = AuthAutenticado(perfil);
    } catch (e, s) {
      AppLogger.e('No se pudo cargar el perfil', e, s);
      // El caché permite continuar sin red, pero nunca sustituye una sesión
      // local de Supabase. Si no hay usuario persistido, no hay identidad a la
      // cual vincular de forma segura las capturas offline.
      final cacheado = id == null || sessionId == null
          ? null
          : await PerfilLocalCache.cargar(usuarioId: id, sessionId: sessionId);
      if (cacheado != null) {
        state = AuthAutenticado(cacheado.perfil);
        return;
      }
      state = const AuthSinSesion(
        mensaje: 'Conéctate para validar tu sesión antes de trabajar offline.',
      );
    }
  }

  String? _sessionIdActual() {
    try {
      final token = SupabaseService.auth.currentSession?.accessToken;
      if (token == null) return null;
      final partes = token.split('.');
      if (partes.length != 3) return null;
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(partes[1]))),
      );
      if (payload is! Map) return null;
      final sessionId = payload['session_id'];
      return sessionId is String && sessionId.isNotEmpty ? sessionId : null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> iniciarSesion(String correo, String password) async {
    state = const AuthCargando();
    try {
      await SupabaseService.auth.signInWithPassword(
        email: correo.trim().toLowerCase(),
        password: password,
      );
      await _cargarPerfil();
      return null;
    } on AuthException catch (e) {
      state = const AuthSinSesion();
      return _mensajeDeError(e);
    } catch (e) {
      state = const AuthSinSesion();
      AppLogger.e('Error inesperado al iniciar sesión', e);
      return 'No se pudo iniciar sesión. Revisa tu conexión.';
    }
  }

  /// Cambia la contraseña en el servidor y levanta la bandera temporal sólo
  /// después de validar que la sesión se creó tras el último restablecimiento.
  Future<String?> cambiarPassword(String nueva) async {
    final sesion = SupabaseService.auth.currentSession;
    if (sesion == null) return 'Tu sesión terminó. Inicia sesión nuevamente.';

    try {
      await SupabaseService.cliente.functions.invoke(
        'administrar-usuarios',
        body: {'accion': 'cambiar_password_propio', 'password_nueva': nueva},
        headers: {'Authorization': 'Bearer ${sesion.accessToken}'},
      );

      await _cargarPerfil();
      return null;
    } on FunctionException catch (e) {
      final detalle = e.details;
      if (detalle is Map) {
        final mensaje = detalle['error'];
        if (mensaje is String && mensaje.trim().isNotEmpty) return mensaje;
      }
      if (e.status == 401) {
        return 'Tu sesión terminó. Inicia sesión nuevamente.';
      }
      if (e.status == 403) {
        return 'Cierra sesión e ingresa con la contraseña temporal más reciente.';
      }
      return 'No se pudo cambiar la contraseña.';
    } catch (e) {
      AppLogger.e('Error al cambiar contraseña', e);
      return 'No se pudo cambiar la contraseña.';
    }
  }

  Future<String?> actualizarWhatsapp(String telefono) async {
    final id = SupabaseService.usuarioId;
    if (id == null) return 'No hay sesión activa.';

    try {
      await SupabaseService.cliente
          .from('profiles')
          .update({'telefono_whatsapp': telefono.trim()})
          .eq('id', id);
      await _cargarPerfil();
      return null;
    } catch (e) {
      AppLogger.e('Error al actualizar WhatsApp', e);
      return 'No se pudo guardar el número.';
    }
  }

  Future<void> cerrarSesion() async {
    await PerfilLocalCache.limpiar();
    await SupabaseService.auth.signOut();
    state = const AuthSinSesion();
  }

  /// Traduce los errores de GoTrue a algo que un elemento pueda entender.
  /// "Invalid login credentials" no le dice nada a nadie en una caseta.
  String _mensajeDeError(AuthException e) {
    final mensaje = e.message.toLowerCase();
    if (mensaje.contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (mensaje.contains('email not confirmed')) {
      return 'Tu cuenta aún no está confirmada. Contacta al administrador.';
    }
    if (mensaje.contains('should be at least')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (mensaje.contains('same as the old') ||
        mensaje.contains('should be different')) {
      return 'La nueva contraseña debe ser distinta de la actual.';
    }
    if (mensaje.contains('network') || mensaje.contains('timeout')) {
      return 'Sin conexión. Revisa tu red e intenta de nuevo.';
    }
    return e.message;
  }
}
