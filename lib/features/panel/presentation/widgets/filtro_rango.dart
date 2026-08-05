import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/panel_repository.dart';
import '../../providers/panel_provider.dart';

/// Selector de periodo para las consultas del panel.
class FiltroRango extends ConsumerWidget {
  const FiltroRango({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rango = ref.watch(rangoFiltroProvider);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _Opcion(
          etiqueta: 'Hoy',
          activo: _mismoRango(rango, RangoFechas.ultimosDias(0)),
          onTap: () => ref
              .read(rangoFiltroProvider.notifier)
              .seleccionar(RangoFechas.ultimosDias(0)),
        ),
        _Opcion(
          etiqueta: '7 días',
          activo: _mismoRango(rango, RangoFechas.ultimosDias(7)),
          onTap: () => ref
              .read(rangoFiltroProvider.notifier)
              .seleccionar(RangoFechas.ultimosDias(7)),
        ),
        _Opcion(
          etiqueta: '30 días',
          activo: _mismoRango(rango, RangoFechas.ultimosDias(30)),
          onTap: () => ref
              .read(rangoFiltroProvider.notifier)
              .seleccionar(RangoFechas.ultimosDias(30)),
        ),
        _Opcion(
          etiqueta: 'Este mes',
          activo: _mismoRango(rango, RangoFechas.mesActual()),
          onTap: () => ref
              .read(rangoFiltroProvider.notifier)
              .seleccionar(RangoFechas.mesActual()),
        ),
        OutlinedButton.icon(
          onPressed: () => _elegirRango(context, ref, rango),
          icon: const Icon(Icons.date_range, size: 18),
          label: Text(
            '${DateFormat('d MMM', 'es_MX').format(rango.desde)} – '
            '${DateFormat('d MMM', 'es_MX').format(rango.hasta)}',
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 38),
            padding: const EdgeInsets.symmetric(horizontal: 14),
          ),
        ),
      ],
    );
  }

  Future<void> _elegirRango(
    BuildContext context,
    WidgetRef ref,
    RangoFechas actual,
  ) async {
    final elegido = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: DateTimeRange(start: actual.desde, end: actual.hasta),
      locale: const Locale('es', 'MX'),
    );

    if (elegido != null) {
      ref.read(rangoFiltroProvider.notifier).seleccionar(
            // Se lleva el fin al final del día para no cortar los eventos de
            // esa misma tarde.
            RangoFechas(
              elegido.start,
              DateTime(elegido.end.year, elegido.end.month, elegido.end.day,
                  23, 59, 59),
            ),
          );
    }
  }

  /// Compara sólo por día: los rangos se recrean con `DateTime.now()` y nunca
  /// serían iguales al milisegundo.
  static bool _mismoRango(RangoFechas a, RangoFechas b) {
    return a.desdeFecha == b.desdeFecha && a.hastaFecha == b.hastaFecha;
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion({
    required this.etiqueta,
    required this.activo,
    required this.onTap,
  });

  final String etiqueta;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(etiqueta),
      selected: activo,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.azulAcero.withValues(alpha: 0.15),
    );
  }
}
