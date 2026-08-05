import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Métrica del tablero.
///
/// Ancho fijo para que las tarjetas se acomoden solas en `Wrap` sin saltos raros
/// entre el escritorio del administrador y el teléfono del cliente.
class TarjetaMetrica extends StatelessWidget {
  const TarjetaMetrica({
    super.key,
    required this.icono,
    required this.etiqueta,
    required this.valor,
    required this.color,
    this.onTap,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icono, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(valor,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w700)),
                      Text(
                        etiqueta,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.grisNeutro),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
