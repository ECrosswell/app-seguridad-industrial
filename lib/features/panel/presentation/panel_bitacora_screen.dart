import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/panel_provider.dart';
import 'widgets/filtro_rango.dart';

/// Bitácora del servicio vista desde la consola.
class PanelBitacoraScreen extends ConsumerStatefulWidget {
  const PanelBitacoraScreen({super.key});

  @override
  ConsumerState<PanelBitacoraScreen> createState() =>
      _PanelBitacoraScreenState();
}

class _PanelBitacoraScreenState extends ConsumerState<PanelBitacoraScreen> {
  TipoEventoBitacora? _tipoFiltro;
  bool _soloPendientes = false;

  @override
  Widget build(BuildContext context) {
    final eventos = ref.watch(bitacoraPanelProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Bitácora',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        const FiltroRango(),
        const SizedBox(height: 14),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('Solo pendientes'),
              selected: _soloPendientes,
              onSelected: (v) => setState(() => _soloPendientes = v),
              avatar: const Icon(Icons.pending_actions, size: 18),
            ),
            ChoiceChip(
              label: const Text('Todos los tipos'),
              selected: _tipoFiltro == null,
              onSelected: (_) => setState(() => _tipoFiltro = null),
            ),
            for (final t in TipoEventoBitacora.values)
              ChoiceChip(
                label: Text(t.etiqueta),
                selected: _tipoFiltro == t,
                onSelected: (_) => setState(() => _tipoFiltro = t),
              ),
          ],
        ),
        const SizedBox(height: 20),

        eventos.when(
          loading: () => const Center(
              child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator())),
          error: (e, _) => Text('Error: $e'),
          data: (lista) {
            var filtrada = lista;
            if (_tipoFiltro != null) {
              filtrada =
                  filtrada.where((e) => e['tipo'] == _tipoFiltro!.valor).toList();
            }
            if (_soloPendientes) {
              filtrada = filtrada
                  .where((e) =>
                      e['requiere_seguimiento'] == true && e['resuelto'] != true)
                  .toList();
            }

            if (filtrada.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: Text('Sin eventos que coincidan')),
                ),
              );
            }

            return Column(
              children: [for (final e in filtrada) _TarjetaEvento(evento: e)],
            );
          },
        ),
      ],
    );
  }
}

class _TarjetaEvento extends StatelessWidget {
  const _TarjetaEvento({required this.evento});

  final Map<String, dynamic> evento;

  @override
  Widget build(BuildContext context) {
    final e = evento;
    final tipo = TipoEventoBitacora.desdeValor(e['tipo'] as String?);
    final color = AppTheme.colorPrioridad(e['prioridad'] as String? ?? 'normal');
    final quien =
        (e['profiles'] as Map?)?['nombre_completo'] as String? ?? 'Elemento';
    final autorizo = (e['personal_cliente'] as Map?)?['nombre_completo']
            as String? ??
        (e['autorizado_por_texto'] as String? ?? '');
    final cuando = DateTime.tryParse(e['ocurrido_at']?.toString() ?? '');
    final fotos = (e['bitacora_fotos'] as List?)?.length ?? 0;
    final pendiente =
        e['requiere_seguimiento'] == true && e['resuelto'] != true;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(Icons.circle, size: 8, color: color),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tipo.etiqueta,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      Text(
                        [
                          quien,
                          if (cuando != null)
                            DateFormat('d MMM · HH:mm', 'es_MX')
                                .format(cuando.toLocal()),
                        ].join(' · '),
                        style: const TextStyle(
                            fontSize: 12.5, color: AppTheme.grisNeutro),
                      ),
                    ],
                  ),
                ),
                if (pendiente)
                  const Chip(
                    label: Text('Pendiente', style: TextStyle(fontSize: 11)),
                    backgroundColor: Color(0x22F5A623),
                    visualDensity: VisualDensity.compact,
                    side: BorderSide.none,
                  ),
                if (fotos > 0) ...[
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Icon(Icons.photo_library_outlined,
                          size: 16, color: AppTheme.grisNeutro),
                      const SizedBox(width: 3),
                      Text('$fotos',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.grisNeutro)),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 11),
            Text(e['descripcion'] as String? ?? '',
                style: const TextStyle(height: 1.35)),

            if ((e['placas'] as String?)?.isNotEmpty == true ||
                (e['destino'] as String?)?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  if ((e['placas'] as String?)?.isNotEmpty == true)
                    _Dato(etiqueta: 'Placas', valor: e['placas'] as String),
                  if ((e['transportista'] as String?)?.isNotEmpty == true)
                    _Dato(
                        etiqueta: 'Operador',
                        valor: e['transportista'] as String),
                  if ((e['empresa_transporte'] as String?)?.isNotEmpty == true)
                    _Dato(
                        etiqueta: 'Transportista',
                        valor: e['empresa_transporte'] as String),
                  if ((e['destino'] as String?)?.isNotEmpty == true)
                    _Dato(etiqueta: 'Destino', valor: e['destino'] as String),
                  if ((e['num_documento'] as String?)?.isNotEmpty == true)
                    _Dato(
                        etiqueta: 'Documento',
                        valor: e['num_documento'] as String),
                  if (autorizo.isNotEmpty)
                    _Dato(etiqueta: 'Autorizó', valor: autorizo),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(etiqueta,
            style: const TextStyle(fontSize: 11, color: AppTheme.grisNeutro)),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
