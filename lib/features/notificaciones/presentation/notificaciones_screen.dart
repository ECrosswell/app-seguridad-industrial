import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/notificacion.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/notificaciones_provider.dart';

class NotificacionesScreen extends ConsumerWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilActualProvider);
    final notificaciones = ref.watch(notificacionesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          if (perfil != null)
            TextButton(
              onPressed: () => ref
                  .read(notificacionesControllerProvider)
                  .marcarTodasLeidas(perfil.id),
              child: const Text('Marcar todas',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: notificaciones.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const _SinConexion(),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 56, color: AppTheme.grisNeutro),
                  SizedBox(height: 12),
                  Text('Sin notificaciones',
                      style: TextStyle(color: AppTheme.grisNeutro)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: lista.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _Tarjeta(
              notificacion: lista[i],
              onLeer: () => ref
                  .read(notificacionesControllerProvider)
                  .marcarLeida(lista[i].id),
            ),
          );
        },
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.notificacion, required this.onLeer});

  final Notificacion notificacion;
  final VoidCallback onLeer;

  @override
  Widget build(BuildContext context) {
    final n = notificacion;
    final color = AppTheme.colorPrioridad(n.prioridad.valor);

    return Card(
      color: n.leida
          ? null
          : color.withValues(alpha: 0.06),
      child: ListTile(
        onTap: n.leida ? null : onLeer,
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_icono(n.tipo), color: color, size: 22),
        ),
        title: Text(
          n.titulo,
          style: TextStyle(
            fontWeight: n.leida ? FontWeight.w500 : FontWeight.w700,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(n.cuerpo, style: const TextStyle(height: 1.35, fontSize: 13)),
            const SizedBox(height: 6),
            Text(
              DateFormat('d MMM · HH:mm', 'es_MX').format(n.creadaAt),
              style: const TextStyle(fontSize: 11, color: AppTheme.grisNeutro),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: n.leida
            ? null
            : Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
      ),
    );
  }

  static IconData _icono(TipoNotificacion tipo) => switch (tipo) {
        TipoNotificacion.armamentoNovedad => Icons.gpp_maybe_outlined,
        TipoNotificacion.relevoNoLlego => Icons.person_off_outlined,
        TipoNotificacion.doblete => Icons.repeat_outlined,
        TipoNotificacion.salidaNoRegistrada => Icons.logout_outlined,
        TipoNotificacion.asistenciaRevision => Icons.help_outline,
        TipoNotificacion.solicitudCliente => Icons.support_agent_outlined,
        TipoNotificacion.solicitudRespondida => Icons.mark_email_read_outlined,
        TipoNotificacion.incidenteCritico => Icons.crisis_alert_outlined,
        TipoNotificacion.avisoGeneral => Icons.campaign_outlined,
      };
}

class _SinConexion extends StatelessWidget {
  const _SinConexion();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 56, color: AppTheme.grisNeutro),
            SizedBox(height: 16),
            Text(
              'Las notificaciones necesitan conexión',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Lo demás sigue funcionando sin red; sólo esta sección requiere '
              'estar en línea.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.grisNeutro, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
