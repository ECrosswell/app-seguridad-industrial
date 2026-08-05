import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/panel_provider.dart';

/// Solicitudes del cliente al supervisor.
///
/// El cliente las levanta y le llega notificación al supervisor; el supervisor
/// y el admin las responden. Ambos flujos viven aquí porque son la misma
/// conversación vista desde los dos lados.
class PanelSolicitudesScreen extends ConsumerWidget {
  const PanelSolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilActualProvider);
    final solicitudes = ref.watch(solicitudesPanelProvider);
    final puedeCrear =
        perfil?.rol == RolUsuario.cliente || perfil?.rol == RolUsuario.admin;
    final puedeResponder =
        perfil?.rol == RolUsuario.supervisor || perfil?.rol == RolUsuario.admin;

    return Scaffold(
      floatingActionButton: puedeCrear
          ? FloatingActionButton.extended(
              onPressed: () => _nueva(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Nueva solicitud'),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
        children: [
          const Text('Solicitudes',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          solicitudes.when(
            loading: () => const Center(
                child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator())),
            error: (e, _) => Text('Error: $e'),
            data: (lista) {
              if (lista.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(child: Text('Sin solicitudes')),
                  ),
                );
              }
              return Column(
                children: [
                  for (final s in lista)
                    _TarjetaSolicitud(
                      solicitud: s,
                      puedeResponder: puedeResponder,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _nueva(BuildContext context, WidgetRef ref) async {
    final sitios = ref.read(sitiosPanelProvider).value ?? const [];
    if (sitios.isEmpty) return;

    final asunto = TextEditingController();
    final descripcion = TextEditingController();
    var sitioId = ref.read(sitioFiltroProvider) ?? sitios.first.id;
    var prioridad = Prioridad.normal;
    var categoria = 'general';

    final guardar = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Nueva solicitud'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (sitios.length > 1)
                    DropdownButtonFormField<String>(
                      initialValue: sitioId,
                      decoration: const InputDecoration(labelText: 'Sitio'),
                      items: [
                        for (final s in sitios)
                          DropdownMenuItem(value: s.id, child: Text(s.nombre)),
                      ],
                      onChanged: (v) => setLocal(() => sitioId = v ?? sitioId),
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: asunto,
                    decoration: const InputDecoration(labelText: 'Asunto'),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descripcion,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      alignLabelWithHint: true,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: categoria,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    items: const [
                      DropdownMenuItem(value: 'general', child: Text('General')),
                      DropdownMenuItem(value: 'personal', child: Text('Personal')),
                      DropdownMenuItem(value: 'equipo', child: Text('Equipo')),
                      DropdownMenuItem(
                          value: 'procedimiento', child: Text('Procedimiento')),
                      DropdownMenuItem(value: 'queja', child: Text('Queja')),
                      DropdownMenuItem(
                          value: 'felicitacion', child: Text('Felicitación')),
                    ],
                    onChanged: (v) => setLocal(() => categoria = v ?? 'general'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Prioridad>(
                    initialValue: prioridad,
                    decoration: const InputDecoration(labelText: 'Prioridad'),
                    items: [
                      for (final p in Prioridad.values)
                        DropdownMenuItem(value: p, child: Text(p.etiqueta)),
                    ],
                    onChanged: (v) =>
                        setLocal(() => prioridad = v ?? Prioridad.normal),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Enviar')),
          ],
        ),
      ),
    );

    if (guardar == true && asunto.text.trim().isNotEmpty) {
      await ref.read(panelRepositoryProvider).crearSolicitud(
            sitioId: sitioId,
            asunto: asunto.text.trim(),
            descripcion: descripcion.text.trim(),
            prioridad: prioridad.valor,
            categoria: categoria,
          );
      if (context.mounted) {
        refrescarPanel(ref);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud enviada. El supervisor fue notificado.'),
            backgroundColor: AppTheme.verdeOperativo,
          ),
        );
      }
    }

    asunto.dispose();
    descripcion.dispose();
  }
}

class _TarjetaSolicitud extends ConsumerWidget {
  const _TarjetaSolicitud({
    required this.solicitud,
    required this.puedeResponder,
  });

  final Map<String, dynamic> solicitud;
  final bool puedeResponder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = solicitud;
    final estado = EstadoSolicitud.desdeValor(s['estado'] as String?);
    final prioridad = Prioridad.desdeValor(s['prioridad'] as String?);
    final quien =
        (s['profiles'] as Map?)?['nombre_completo'] as String? ?? 'Cliente';
    final cuando = DateTime.tryParse(s['created_at']?.toString() ?? '');
    final abierta = estado == EstadoSolicitud.abierta ||
        estado == EstadoSolicitud.enProceso;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(s['asunto'] as String? ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: abierta
                        ? AppTheme.colorPrioridad(prioridad.valor)
                            .withValues(alpha: 0.13)
                        : AppTheme.verdeOperativo.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    estado.etiqueta,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: abierta
                          ? AppTheme.colorPrioridad(prioridad.valor)
                          : AppTheme.verdeOperativo,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              [
                quien,
                if (cuando != null)
                  DateFormat('d MMM · HH:mm', 'es_MX').format(cuando.toLocal()),
                prioridad.etiqueta,
              ].join(' · '),
              style: const TextStyle(fontSize: 12.5, color: AppTheme.grisNeutro),
            ),
            if ((s['descripcion'] as String?)?.isNotEmpty == true) ...[
              const SizedBox(height: 10),
              Text(s['descripcion'] as String, style: const TextStyle(height: 1.35)),
            ],

            if ((s['respuesta'] as String?)?.isNotEmpty == true) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.verdeOperativo.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Respuesta',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.verdeOperativo)),
                    const SizedBox(height: 5),
                    Text(s['respuesta'] as String,
                        style: const TextStyle(height: 1.35)),
                  ],
                ),
              ),
            ],

            if (puedeResponder && abierta) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () => _responder(context, ref, s['id'] as String),
                  icon: const Icon(Icons.reply, size: 18),
                  label: const Text('Responder'),
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _responder(
      BuildContext context, WidgetRef ref, String id) async {
    final respuesta = TextEditingController();
    var estado = 'resuelta';

    final guardar = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Responder solicitud'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: respuesta,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Respuesta',
                    alignLabelWithHint: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: estado,
                  decoration: const InputDecoration(labelText: 'Nuevo estado'),
                  items: const [
                    DropdownMenuItem(
                        value: 'en_proceso', child: Text('En proceso')),
                    DropdownMenuItem(value: 'resuelta', child: Text('Resuelta')),
                    DropdownMenuItem(value: 'cerrada', child: Text('Cerrada')),
                  ],
                  onChanged: (v) => setLocal(() => estado = v ?? 'resuelta'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Enviar')),
          ],
        ),
      ),
    );

    if (guardar == true) {
      await ref.read(panelRepositoryProvider).responderSolicitud(
            id: id,
            respuesta: respuesta.text.trim(),
            estado: estado,
          );
      if (context.mounted) refrescarPanel(ref);
    }
    respuesta.dispose();
  }
}
