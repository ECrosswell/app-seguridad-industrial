import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/panel_provider.dart';

/// Estado del armamento y equipo de cada caseta.
///
/// Arriba las novedades sin atender, porque es lo que exige acción del
/// administrador. Abajo el estado actual de cada partida.
class PanelEquipoScreen extends ConsumerWidget {
  const PanelEquipoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final novedades = ref.watch(recepcionesConNovedadProvider);
    final estado = ref.watch(estadoEquipoProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Equipo',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),

        novedades.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (lista) {
            final pendientes =
                lista.where((n) => n['atendido'] != true).toList();
            if (pendientes.isEmpty) {
              return Card(
                color: AppTheme.verdeOperativo.withValues(alpha: 0.07),
                child: const Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: AppTheme.verdeOperativo),
                      SizedBox(width: 12),
                      Text('Sin novedades pendientes de atender'),
                    ],
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${pendientes.length} novedad(es) por atender',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (final n in pendientes) _TarjetaNovedad(recepcion: n),
              ],
            );
          },
        ),

        const SizedBox(height: 28),
        const Text('Estado actual por caseta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),

        estado.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (lista) {
            if (lista.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                      child: Text('Todavía no hay recepciones registradas')),
                ),
              );
            }

            // Agrupado por sitio para que se lea como un inventario y no como
            // una lista plana.
            final porSitio = <String, List<Map<String, dynamic>>>{};
            for (final e in lista) {
              final sitio = e['sitio_nombre'] as String? ?? 'Sitio';
              porSitio.putIfAbsent(sitio, () => []).add(e);
            }

            return Column(
              children: [
                for (final entrada in porSitio.entries)
                  Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entrada.key,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),
                          for (final item in entrada.value)
                            _FilaEquipo(item: item),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FilaEquipo extends StatelessWidget {
  const _FilaEquipo({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final estado = item['estado'] as String? ?? 'perfecto';
    final color = AppTheme.colorEstadoEquipo(estado);
    final fecha = DateTime.tryParse(item['aceptado_at']?.toString() ?? '');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['equipo_nombre'] as String? ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  [
                    EstadoEquipo.desdeValor(estado).etiqueta,
                    if (item['cantidad_encontrada'] != null &&
                        item['cantidad_esperada'] != null)
                      '${item['cantidad_encontrada']} de ${item['cantidad_esperada']}',
                    if (fecha != null)
                      DateFormat('d MMM', 'es_MX').format(fecha.toLocal()),
                    if ((item['reportado_por'] as String?)?.isNotEmpty == true)
                      item['reportado_por'] as String,
                  ].join(' · '),
                  style:
                      const TextStyle(fontSize: 12.5, color: AppTheme.grisNeutro),
                ),
                if ((item['observaciones'] as String?)?.isNotEmpty == true)
                  Text('"${item['observaciones']}"',
                      style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.grisNeutro)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaNovedad extends ConsumerWidget {
  const _TarjetaNovedad({required this.recepcion});

  final Map<String, dynamic> recepcion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = recepcion;
    final quien =
        (r['profiles'] as Map?)?['nombre_completo'] as String? ?? 'Elemento';
    final sitio = (r['sitios'] as Map?)?['nombre'] as String? ?? '';
    final fecha = DateTime.tryParse(r['aceptado_at']?.toString() ?? '');
    final items = ((r['recepcion_turno_items'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .where((i) => i['estado'] != 'perfecto')
        .toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.ambarSeguridad.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppTheme.ambarSeguridad.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.gpp_maybe_outlined,
                    color: AppTheme.ambarSeguridad),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('$quien — $sitio',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                ),
                if (fecha != null)
                  Text(DateFormat('d MMM HH:mm', 'es_MX').format(fecha.toLocal()),
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.grisNeutro)),
              ],
            ),
            const SizedBox(height: 12),

            if (r['acepta_conformidad'] == false)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('No recibió el equipo de conformidad.',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.rojoAlerta)),
              ),

            for (final i in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle,
                        size: 7,
                        color: AppTheme.colorEstadoEquipo(
                            i['estado'] as String? ?? '')),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${(i['catalogo_equipo'] as Map?)?['nombre'] ?? 'Equipo'}: '
                        '${EstadoEquipo.desdeValor(i['estado'] as String?).etiqueta}'
                        '${(i['observaciones'] as String?)?.isNotEmpty == true ? ' — ${i['observaciones']}' : ''}',
                        style: const TextStyle(fontSize: 13, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),

            if ((r['observaciones'] as String?)?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text('"${r['observaciones']}"',
                  style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.grisNeutro)),
            ],

            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _atender(context, ref, r['id'] as String),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Marcar atendida'),
                style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _atender(
      BuildContext context, WidgetRef ref, String id) async {
    final nota = TextEditingController();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Marcar como atendida'),
        content: TextField(
          controller: nota,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Qué se hizo',
            hintText: 'Se repuso el tanque, se envió a reparación…',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Guardar')),
        ],
      ),
    );

    if (confirmar == true) {
      await ref
          .read(panelRepositoryProvider)
          .marcarRecepcionAtendida(id, nota.text.trim());
      if (context.mounted) refrescarPanel(ref);
    }
    nota.dispose();
  }
}
