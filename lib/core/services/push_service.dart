import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'app_logger.dart';
import 'device_service.dart';
import 'notificaciones_service.dart';
import 'supabase_service.dart';

/// Manejador de mensajes en segundo plano.
///
/// Tiene que ser una función de nivel superior con `@pragma('vm:entry-point')`:
/// Android la invoca en un isolate nuevo, sin el árbol de widgets ni nada del
/// estado de la app. Sin la anotación, el compilador AOT la elimina por
/// considerarla código muerto y las notificaciones con la app cerrada dejan de
/// llegar sin ningún error visible.
@pragma('vm:entry-point')
Future<void> manejarMensajeEnSegundoPlano(RemoteMessage mensaje) async {
  // No hace falta mostrar nada: los mensajes se envían con bloque
  // `notification`, así que Android los despliega solo cuando la app no está
  // en primer plano.
  await Firebase.initializeApp();
}

/// Notificaciones push por Firebase Cloud Messaging.
///
/// Es lo que hace que una alerta de armamento reportado o de relevo que no
/// llegó despierte el teléfono del administrador **con la app cerrada**. Con la
/// app abierta las alertas ya llegaban por Realtime; esto cubre el resto.
///
/// Sólo Android. La consola web no registra tokens: el push en navegador
/// necesita claves VAPID y un service worker propio, y el administrador usa el
/// teléfono para las alertas.
class PushService {
  PushService._();

  static final PushService instancia = PushService._();

  bool _inicializado = false;
  String? _tokenActual;

  Future<void> inicializar() async {
    if (_inicializado || kIsWeb) return;

    try {
      // En Android las credenciales salen de android/app/google-services.json,
      // que el plugin de Gradle convierte en recursos nativos.
      await Firebase.initializeApp();

      FirebaseMessaging.onBackgroundMessage(manejarMensajeEnSegundoPlano);

      final permiso = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (permiso.authorizationStatus == AuthorizationStatus.denied) {
        AppLogger.w(
          'El usuario negó las notificaciones. Las alertas sólo llegarán '
          'con la app abierta.',
        );
      }

      // Con la app en primer plano Android NO despliega el mensaje solo, así
      // que se levanta la notificación local. Comparte el id con la ruta de
      // Realtime, y como `show()` reemplaza por id, nunca se duplica aunque
      // lleguen las dos.
      FirebaseMessaging.onMessage.listen((mensaje) {
        final datos = mensaje.data;
        NotificacionesService.instancia.mostrarDesdePush(
          id: datos['notificacion_id'] as String? ?? mensaje.messageId ?? '',
          titulo: mensaje.notification?.title ?? datos['titulo'] as String? ?? 'Alerta',
          cuerpo: mensaje.notification?.body ?? datos['cuerpo'] as String? ?? '',
          prioridad: datos['prioridad'] as String? ?? 'normal',
        );
      });

      // El token se rota solo (reinstalación, borrado de datos, cambio de
      // equipo). Sin escuchar esto, el dispositivo dejaría de recibir sin
      // avisar.
      FirebaseMessaging.instance.onTokenRefresh.listen(_guardarToken);

      _inicializado = true;
      AppLogger.i('Firebase Messaging inicializado');
    } catch (e, s) {
      // Que falle el push no puede tumbar la app: la caseta tiene que poder
      // operar aunque Firebase no responda.
      AppLogger.e('No se pudo inicializar Firebase Messaging', e, s);
    }
  }

  /// Registra el token del dispositivo para el usuario en sesión.
  Future<void> registrarDispositivo() async {
    if (kIsWeb) return;
    await inicializar();
    if (!_inicializado) return;

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _guardarToken(token);
    } catch (e) {
      AppLogger.w('No se pudo obtener el token de FCM: $e');
    }
  }

  Future<void> _guardarToken(String token) async {
    final usuarioId = SupabaseService.usuarioId;
    if (usuarioId == null) return;

    try {
      final deviceId = await DeviceService.instancia.deviceId();

      await SupabaseService.cliente.from('dispositivos_push').upsert({
        'usuario_id': usuarioId,
        'fcm_token': token,
        'plataforma': 'android',
        'device_id': deviceId,
        'activo': true,
        'ultima_conexion': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'fcm_token');

      _tokenActual = token;
      AppLogger.i('Dispositivo registrado para notificaciones push');
    } catch (e) {
      AppLogger.w('No se pudo registrar el token: $e');
    }
  }

  /// Da de baja el token al cerrar sesión.
  ///
  /// Sin esto, el siguiente elemento que use el mismo teléfono recibiría las
  /// alertas del anterior — que en una caseta con equipo compartido sería fuga
  /// de información operativa.
  Future<void> darDeBajaDispositivo() async {
    final token = _tokenActual;
    if (token == null || kIsWeb) return;

    try {
      await SupabaseService.cliente
          .from('dispositivos_push')
          .update({'activo': false}).eq('fcm_token', token);
      _tokenActual = null;
    } catch (e) {
      AppLogger.w('No se pudo dar de baja el dispositivo: $e');
    }
  }
}
