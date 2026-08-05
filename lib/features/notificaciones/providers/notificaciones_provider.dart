import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/supabase_service.dart';
import '../../../data/models/notificacion.dart';
import '../../auth/providers/auth_provider.dart';

/// Notificaciones del usuario en sesión, en vivo.
///
/// Vienen directo de Supabase con Realtime encendido sobre la tabla, no de la
/// base local: una alerta que llegó hace cuatro horas y sólo aparece cuando
/// sincroniza no sirve de nada. Es el único módulo que **requiere** conexión.
final notificacionesProvider = StreamProvider<List<Notificacion>>((ref) {
  final perfil = ref.watch(perfilActualProvider);
  if (perfil == null) return Stream.value(const []);

  return SupabaseService.cliente
      .from('notificaciones')
      .stream(primaryKey: ['id'])
      .eq('destinatario_id', perfil.id)
      .order('created_at', ascending: false)
      .limit(100)
      .map((filas) => filas.map(Notificacion.desdeJson).toList());
});

final notificacionesNoLeidasProvider = Provider<AsyncValue<int>>((ref) {
  return ref
      .watch(notificacionesProvider)
      .whenData((lista) => lista.where((n) => !n.leida).length);
});

/// Acciones sobre notificaciones.
final notificacionesControllerProvider =
    Provider<NotificacionesController>((ref) => const NotificacionesController());

class NotificacionesController {
  const NotificacionesController();

  Future<void> marcarLeida(String id) async {
    await SupabaseService.cliente.from('notificaciones').update({
      'leida': true,
      'leida_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> marcarTodasLeidas(String usuarioId) async {
    await SupabaseService.cliente
        .from('notificaciones')
        .update({
          'leida': true,
          'leida_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('destinatario_id', usuarioId)
        .eq('leida', false);
  }
}
