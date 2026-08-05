import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/panel_provider.dart';
import 'widgets/filtro_rango.dart';

/// Historial de turnos y revisión de asistencias.
///
/// Dos pestañas porque son dos trabajos distintos: consultar el historial
/// (cliente y admin) y resolver los registros que no validaron ubicación
/// (supervisor y admin).
class PanelPersonalScreen extends ConsumerWidget {
  const PanelPersonalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final porRevisar = ref.watch(asistenciasPorRevisarProvider).value ?? const [];

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              tabs: [
                const Tab(text: 'Turnos'),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Por revisar'),
                      if (porRevisar.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.ambarSeguridad,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('${porRevisar.length}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [_Turnos(), _PorRevisar()],
            ),
          ),
        ],
      ),
    );
  }
}

class _Turnos extends ConsumerWidget {
  const _Turnos();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final turnos = ref.watch(turnosPanelProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const FiltroRango(),
        const SizedBox(height: 20),
        turnos.when(
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
                  child: Center(child: Text('Sin turnos en el periodo')),
                ),
              );
            }

            return Column(
              children: [for (final t in lista) _TarjetaTurno(turno: t)],
            );
          },
        ),
      ],
    );
  }
}

class _TarjetaTurno extends ConsumerWidget {
  const _TarjetaTurno({required this.turno});

  final Map<String, dynamic> turno;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombre =
        (turno['profiles'] as Map?)?['nombre_completo'] as String? ?? 'Elemento';
    final sitio = (turno['sitios'] as Map?)?['nombre'] as String? ?? '';
    final inicio = DateTime.tryParse(turno['inicio_at']?.toString() ?? '')?.toLocal();
    final fin = DateTime.tryParse(turno['fin_at']?.toString() ?? '')?.toLocal();
    final estado = turno['estado'] as String? ?? 'en_curso';
    final clasificacion = turno['clasificacion_entrada'] as String? ?? 'a_tiempo';
    final color = AppTheme.colorClasificacion(clasificacion);
    final abierto = estado == 'en_curso';

    final duracion = inicio == null
        ? null
        : (fin ?? DateTime.now()).difference(inicio);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(
                    [
                      sitio,
                      if (inicio != null)
                        DateFormat('d MMM · HH:mm', 'es_MX').format(inicio),
                      if (fin != null) '→ ${DateFormat('HH:mm').format(fin)}',
                      if (duracion != null)
                        '${duracion.inHours}h ${duracion.inMinutes % 60}m',
                    ].join(' · '),
                    style: const TextStyle(
                        fontSize: 12.5, color: AppTheme.grisNeutro),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _Pastilla(
                          texto: ClasificacionAsistencia.desdeValor(clasificacion)
                              .etiqueta,
                          color: color),
                      if (turno['es_doblete'] == true)
                        const _Pastilla(
                            texto: 'Doblete', color: AppTheme.ambarSeguridad),
                      if (turno['es_cobertura'] == true)
                        const _Pastilla(
                            texto: 'Cubriendo', color: AppTheme.azulAcero),
                      if (estado == 'cerrado_por_admin')
                        const _Pastilla(
                            texto: 'Cerrado por admin',
                            color: AppTheme.grisNeutro),
                      if (estado == 'anomalia')
                        const _Pastilla(
                            texto: 'Anomalía', color: AppTheme.rojoAlerta),
                    ],
                  ),
                ],
              ),
            ),
            // Un turno abierto más de 26 h es el caso del elemento que olvidó
            // marcar salida. Se cierra a mano para que quede constancia.
            if (abierto &&
                duracion != null &&
                duracion.inHours >= 26)
              TextButton.icon(
                onPressed: () => _cerrar(context, ref, turno['id'] as String),
                icon: const Icon(Icons.lock_clock, size: 18),
                label: const Text('Cerrar'),
                style: TextButton.styleFrom(foregroundColor: AppTheme.rojoAlerta),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _cerrar(
      BuildContext context, WidgetRef ref, String turnoId) async {
    final motivo = TextEditingController(
        text: 'El elemento no registró su salida');

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar turno manualmente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Queda registrado que tú lo cerraste y por qué.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: motivo,
              decoration: const InputDecoration(labelText: 'Motivo'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Cerrar turno')),
        ],
      ),
    );

    if (confirmar == true) {
      await ref.read(panelRepositoryProvider).cerrarTurnoManual(
            turnoId: turnoId,
            motivo: motivo.text.trim(),
          );
      if (context.mounted) refrescarPanel(ref);
    }
    motivo.dispose();
  }
}

class _PorRevisar extends ConsumerWidget {
  const _PorRevisar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendientes = ref.watch(asistenciasPorRevisarProvider);

    return pendientes.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (lista) {
        if (lista.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 56, color: AppTheme.verdeOperativo),
                  SizedBox(height: 14),
                  Text('Nada pendiente de revisar'),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.grisNeutro),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Estos registros no validaron ubicación por GPS ni por '
                        'el WiFi de la planta. No se les bloqueó el registro: '
                        'aquí decides si cuentan.',
                        style: TextStyle(fontSize: 13, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (final a in lista) _TarjetaRevision(asistencia: a),
          ],
        );
      },
    );
  }
}

class _TarjetaRevision extends ConsumerWidget {
  const _TarjetaRevision({required this.asistencia});

  final Map<String, dynamic> asistencia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = asistencia;
    final nombre =
        (a['profiles'] as Map?)?['nombre_completo'] as String? ?? 'Elemento';
    final sitio = (a['sitios'] as Map?)?['nombre'] as String? ?? '';
    final cuando = DateTime.tryParse(a['ocurrido_at']?.toString() ?? '')?.toLocal();
    final distancia = a['distancia_sitio_m'];
    final precision = a['gps_accuracy_m'];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$nombre — ${TipoEventoAsistencia.desdeValor(a['tipo_evento'] as String?).etiqueta}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text(
              [
                sitio,
                if (cuando != null)
                  DateFormat('d MMM · HH:mm', 'es_MX').format(cuando),
              ].join(' · '),
              style: const TextStyle(fontSize: 12.5, color: AppTheme.grisNeutro),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                _DatoTecnico(
                  etiqueta: 'Distancia',
                  valor: distancia == null
                      ? 'sin GPS'
                      : '${(distancia as num).round()} m',
                ),
                _DatoTecnico(
                  etiqueta: 'Precisión GPS',
                  valor: precision == null
                      ? '—'
                      : '±${(precision as num).round()} m',
                ),
                _DatoTecnico(
                  etiqueta: 'WiFi',
                  valor: (a['wifi_ssid'] as String?)?.isNotEmpty == true
                      ? a['wifi_ssid'] as String
                      : 'no conectado',
                ),
                _DatoTecnico(
                  etiqueta: 'Prueba de vida',
                  valor: a['liveness_passed'] == true ? 'sí' : 'no',
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _resolver(context, ref, a['id'] as String, false),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Rechazar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.rojoAlerta,
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _resolver(context, ref, a['id'] as String, true),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Aprobar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.verdeOperativo,
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resolver(
    BuildContext context,
    WidgetRef ref,
    String id,
    bool aprobar,
  ) async {
    await ref.read(panelRepositoryProvider).resolverAsistencia(
          asistenciaId: id,
          aprobar: aprobar,
        );
    if (context.mounted) refrescarPanel(ref);
  }
}

class _DatoTecnico extends StatelessWidget {
  const _DatoTecnico({required this.etiqueta, required this.valor});

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

class _Pastilla extends StatelessWidget {
  const _Pastilla({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(texto,
          style: TextStyle(
              fontSize: 11.5, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
