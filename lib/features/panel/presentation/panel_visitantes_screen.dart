import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/panel_provider.dart';
import 'widgets/filtro_rango.dart';

/// Registro de visitantes: quién está dentro e histórico de accesos.
class PanelVisitantesScreen extends ConsumerStatefulWidget {
  const PanelVisitantesScreen({super.key});

  @override
  ConsumerState<PanelVisitantesScreen> createState() =>
      _PanelVisitantesScreenState();
}

class _PanelVisitantesScreenState
    extends ConsumerState<PanelVisitantesScreen> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    final dentro = ref.watch(visitantesDentroPanelProvider).value ?? const [];
    final historial = ref.watch(accesosPanelProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Visitantes',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),

        if (dentro.isNotEmpty) ...[
          Card(
            color: AppTheme.verdeOperativo.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people, color: AppTheme.verdeOperativo),
                      const SizedBox(width: 10),
                      Text('${dentro.length} dentro de la planta',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  for (final v in dentro)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle,
                              size: 8, color: AppTheme.verdeOperativo),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(v.nombreCompleto,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  [
                                    if (v.empresaProcedencia.isNotEmpty)
                                      v.empresaProcedencia,
                                    if (v.personaVisitada.isNotEmpty)
                                      'visita a ${v.personaVisitada}',
                                    v.asunto,
                                    if (v.placas.isNotEmpty) v.placas,
                                  ].join(' · '),
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      color: AppTheme.grisNeutro),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${DateFormat('HH:mm').format(v.horaEntrada)}\n'
                            '${v.horasDentro.toStringAsFixed(1)} h',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        const Text('Histórico de accesos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        const FiltroRango(),
        const SizedBox(height: 14),
        TextField(
          onChanged: (v) => setState(() => _busqueda = v.toLowerCase()),
          decoration: const InputDecoration(
            labelText: 'Buscar por nombre, empresa o placas',
            prefixIcon: Icon(Icons.search),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),

        historial.when(
          loading: () => const Center(
              child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator())),
          error: (e, _) => Text('Error: $e'),
          data: (lista) {
            final filtrada = _busqueda.isEmpty
                ? lista
                : lista.where((r) {
                    final texto = [
                      r['nombre_completo'],
                      r['empresa_procedencia'],
                      r['placas'],
                      r['asunto'],
                    ].whereType<String>().join(' ').toLowerCase();
                    return texto.contains(_busqueda);
                  }).toList();

            if (filtrada.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: Text('Sin registros en el periodo')),
                ),
              );
            }

            return Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 22,
                  columns: const [
                    DataColumn(label: Text('Visitante')),
                    DataColumn(label: Text('Empresa')),
                    DataColumn(label: Text('Visita a')),
                    DataColumn(label: Text('Asunto')),
                    DataColumn(label: Text('Placas')),
                    DataColumn(label: Text('Entrada')),
                    DataColumn(label: Text('Salida')),
                    DataColumn(label: Text('ID')),
                  ],
                  rows: [
                    for (final r in filtrada)
                      DataRow(cells: [
                        DataCell(Text(r['nombre_completo'] as String? ?? '')),
                        DataCell(
                            Text(r['empresa_procedencia'] as String? ?? '—')),
                        DataCell(Text(
                          (r['personal_cliente'] as Map?)?['nombre_completo']
                                  as String? ??
                              (r['persona_visitada_texto'] as String? ?? '—'),
                        )),
                        DataCell(SizedBox(
                          width: 180,
                          child: Text(r['asunto'] as String? ?? '',
                              overflow: TextOverflow.ellipsis),
                        )),
                        DataCell(Text(
                          (r['placas'] as String?)?.isNotEmpty == true
                              ? r['placas'] as String
                              : '—',
                        )),
                        DataCell(Text(_fecha(r['hora_entrada']))),
                        DataCell(Text(
                          r['hora_salida'] == null
                              ? 'dentro'
                              : _fecha(r['hora_salida']),
                          style: TextStyle(
                            color: r['hora_salida'] == null
                                ? AppTheme.verdeOperativo
                                : null,
                            fontWeight: r['hora_salida'] == null
                                ? FontWeight.w600
                                : null,
                          ),
                        )),
                        DataCell(
                          r['identificacion_purgada'] == true
                              ? const Tooltip(
                                  message:
                                      'Purgada por política de retención (90 días)',
                                  child: Icon(Icons.auto_delete_outlined,
                                      size: 18, color: AppTheme.grisNeutro),
                                )
                              : (r['identificacion_foto_url'] != null
                                  ? const Icon(Icons.badge,
                                      size: 18, color: AppTheme.azulAcero)
                                  : const Text('—')),
                        ),
                      ]),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  static String _fecha(Object? v) {
    final d = DateTime.tryParse(v?.toString() ?? '');
    if (d == null) return '—';
    return DateFormat('d MMM HH:mm', 'es_MX').format(d.toLocal());
  }
}
