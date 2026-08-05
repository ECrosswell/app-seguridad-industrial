import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_logger.dart';
import 'supabase_service.dart';

/// Puente entre las alertas de la base y el sistema operativo.
///
/// Escucha `public.notificaciones` por Realtime y levanta una notificación
/// nativa cuando llega una nueva. Así el administrador se entera de un
/// armamento reportado o de un relevo que no llegó sin tener que estar mirando
/// la pantalla.
///
/// **Limitación conocida:** esto sólo funciona con la app abierta o en segundo
/// plano reciente — Realtime necesita la conexión viva. Para que una alerta
/// llegue con la app cerrada hace falta FCM, que requiere un proyecto Firebase.
/// La tabla `dispositivos_push` ya está lista para guardar los tokens cuando se
/// conecte.
class NotificacionesService {
  NotificacionesService._();

  static final NotificacionesService instancia = NotificacionesService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  RealtimeChannel? _canal;
  bool _inicializado = false;

  /// Canal de Android para las alertas críticas. Se declara con importancia
  /// alta para que suene y aparezca encima, no como aviso silencioso.
  static const _canalAlertas = AndroidNotificationChannel(
    'alertas_operativas',
    'Alertas operativas',
    description:
        'Armamento reportado, relevo que no llegó, salidas sin registrar y '
        'solicitudes del cliente.',
    importance: Importance.high,
  );

  Future<void> inicializar() async {
    if (_inicializado || kIsWeb) return;

    const ajustesAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(
      settings: const InitializationSettings(android: ajustesAndroid),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_canalAlertas);

    // Android 13+ exige permiso explícito para notificar.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _inicializado = true;
    AppLogger.i('Notificaciones locales listas');
  }

  /// Empieza a escuchar las notificaciones dirigidas al usuario en sesión.
  Future<void> escuchar() async {
    if (kIsWeb) return;

    final usuarioId = SupabaseService.usuarioId;
    if (usuarioId == null) return;

    await inicializar();
    await dejarDeEscuchar();

    _canal = SupabaseService.cliente
        .channel('notificaciones_$usuarioId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notificaciones',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'destinatario_id',
            value: usuarioId,
          ),
          callback: (payload) => _mostrar(payload.newRecord),
        )
        .subscribe();

    AppLogger.i('Escuchando notificaciones de $usuarioId');
  }

  Future<void> dejarDeEscuchar() async {
    final canal = _canal;
    if (canal == null) return;
    _canal = null;
    await SupabaseService.cliente.removeChannel(canal);
  }

  /// Muestra una notificación que llegó por FCM con la app en primer plano.
  ///
  /// Comparte el mismo cálculo de id que la ruta de Realtime, y como
  /// `show()` reemplaza por id, si ambas llegan no se duplica el aviso.
  Future<void> mostrarDesdePush({
    required String id,
    required String titulo,
    required String cuerpo,
    required String prioridad,
  }) async {
    await inicializar();
    await _mostrar({
      'id': id,
      'titulo': titulo,
      'cuerpo': cuerpo,
      'prioridad': prioridad,
    });
  }

  Future<void> _mostrar(Map<String, dynamic> fila) async {
    try {
      final titulo = fila['titulo'] as String? ?? 'Alerta';
      final cuerpo = fila['cuerpo'] as String? ?? '';
      final prioridad = fila['prioridad'] as String? ?? 'normal';

      await _plugin.show(
        // El id tiene que caber en un int de 32 bits; el hash del uuid sirve y
        // además hace que reenviar la misma notificación no la duplique.
        id: fila['id'].hashCode & 0x7FFFFFFF,
        title: titulo,
        body: cuerpo,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _canalAlertas.id,
            _canalAlertas.name,
            channelDescription: _canalAlertas.description,
            importance: prioridad == 'critica'
                ? Importance.max
                : Importance.high,
            priority:
                prioridad == 'critica' ? Priority.max : Priority.high,
            styleInformation: BigTextStyleInformation(cuerpo),
            // Las críticas no se descartan solas al tocarlas: relevo que no
            // llegó o armamento dañado tienen que quedarse hasta que alguien
            // las atienda.
            autoCancel: prioridad != 'critica',
          ),
        ),
        payload: fila['id'] as String?,
      );
    } catch (e, s) {
      AppLogger.e('No se pudo mostrar la notificación', e, s);
    }
  }
}
