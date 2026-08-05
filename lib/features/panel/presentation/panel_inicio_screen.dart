import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../data/panel_repository.dart';
import '../providers/panel_provider.dart';
import 'widgets/tarjeta_metrica.dart';

/// Tablero de la consola.
///
/// Responde en un vistazo lo que pidió el cliente: quién llegó, quién está,
/// y cómo contactarlo. Arriba van las alertas, porque un armamento reportado o
/// un relevo que no llegó no puede quedar debajo del pliegue.
class PanelInicioScreen extends ConsumerWidget {
  const PanelInicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personal = ref.watch(personalEnSitioProvider);
    final visitantes = ref.watch(visitantesDentroPanelProvider);
    final novedades = ref.watch(recepcionesConNovedadProvider);
    final porRevisar = ref.watch(asistenciasPorRevisarProvider);

    return RefreshIndicator(
      onRefresh: () async => refrescarPanel(ref),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            DateFormat("EEEE d 'de' MMMM, HH:mm", 'es_MX').format(DateTime.now()),
            style: const TextStyle(color: AppTheme.grisNeutro, fontSize: 13),
          ),
          const SizedBox(height: 4),
          const Text('Tablero',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),

          // Métricas
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              TarjetaMetrica(
                icono: Icons.badge_outlined,
                etiqueta: 'Personal en turno',
                valor: '${personal.value?.length ?? '—'}',
                color: AppTheme.verdeOperativo,
              ),
              TarjetaMetrica(
                icono: Icons.people_outline,
                etiqueta: 'Visitantes dentro',
                valor: '${visitantes.value?.length ?? '—'}',
                color: AppTheme.azulAcero,
              ),
              TarjetaMetrica(
                icono: Icons.gpp_maybe_outlined,
                etiqueta: 'Equipo con novedad',
                valor: '${novedades.value?.where((n) => n['atendido'] != true).length ?? '—'}',
                color: AppTheme.ambarSeguridad,
              ),
              TarjetaMetrica(
                icono: Icons.help_outline,
                etiqueta: 'Asistencias por revisar',
                valor: '${porRevisar.value?.length ?? '—'}',
                color: AppTheme.grisNeutro,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Alertas primero: es lo que exige acción.
          novedades.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (lista) {
              final pendientes =
                  lista.where((n) => n['atendido'] != true).toList();
              if (pendientes.isEmpty) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: _BloqueAlertas(recepciones: pendientes),
              );
            },
          ),

          _Seccion(
            titulo: 'Personal en turno',
            accion: 'Ver historial',
            onAccion: () => context.go(Rutas.panelPersonal),
          ),
          const SizedBox(height: 12),
          personal.when(
            loading: () => const _Cargando(),
            error: (e, _) => _Error(mensaje: '$e'),
            data: (lista) => lista.isEmpty
                ? const _Vacio(texto: 'No hay personal en turno ahora mismo')
                : Column(
                    children: [
                      for (final p in lista) _TarjetaPersonal(personal: p),
                    ],
                  ),
          ),

          const SizedBox(height: 28),
          _Seccion(
            titulo: 'Visitantes dentro de la planta',
            accion: 'Ver todos',
            onAccion: () => context.go(Rutas.panelVisitantes),
          ),
          const SizedBox(height: 12),
          visitantes.when(
            loading: () => const _Cargando(),
            error: (e, _) => _Error(mensaje: '$e'),
            data: (lista) => lista.isEmpty
                ? const _Vacio(texto: 'No hay visitantes dentro')
                : Column(
                    children: [
                      for (final v in lista.take(8)) _TarjetaVisitante(visitante: v),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _BloqueAlertas extends StatelessWidget {
  const _BloqueAlertas({required this.recepciones});

  final List<Map<String, dynamic>> recepciones;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.ambarSeguridad.withValues(alpha: 0.07),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppTheme.ambarSeguridad.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notification_important_outlined,
                    color: AppTheme.ambarSeguridad),
                SizedBox(width: 10),
                Text('Requiere tu atención',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),
            for (final r in recepciones.take(5)) ...[
              _FilaAlerta(recepcion: r),
              if (r != recepciones.last) const Divider(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilaAlerta extends StatelessWidget {
  const _FilaAlerta({required this.recepcion});

  final Map<String, dynamic> recepcion;

  @override
  Widget build(BuildContext context) {
    final quien =
        (recepcion['profiles'] as Map?)?['nombre_completo'] as String? ?? 'Elemento';
    final sitio = (recepcion['sitios'] as Map?)?['nombre'] as String? ?? '';
    final items = (recepcion['recepcion_turno_items'] as List?) ?? const [];
    final conProblema = items
        .cast<Map<String, dynamic>>()
        .where((i) => i['estado'] != 'perfecto')
        .map((i) =>
            '${(i['catalogo_equipo'] as Map?)?['nombre'] ?? 'Equipo'}: ${i['estado']}')
        .join(' · ');
    final fecha = DateTime.tryParse(recepcion['aceptado_at']?.toString() ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$quien — $sitio',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        Text(
          conProblema.isEmpty
              ? 'No recibió el equipo de conformidad'
              : conProblema,
          style: const TextStyle(fontSize: 13, height: 1.3),
        ),
        if (recepcion['observaciones'] is String &&
            (recepcion['observaciones'] as String).isNotEmpty) ...[
          const SizedBox(height: 3),
          Text('"${recepcion['observaciones']}"',
              style: const TextStyle(
                  fontSize: 12.5,
                  fontStyle: FontStyle.italic,
                  color: AppTheme.grisNeutro)),
        ],
        if (fecha != null) ...[
          const SizedBox(height: 3),
          Text(DateFormat('d MMM · HH:mm', 'es_MX').format(fecha.toLocal()),
              style: const TextStyle(fontSize: 11.5, color: AppTheme.grisNeutro)),
        ],
      ],
    );
  }
}

class _TarjetaPersonal extends StatelessWidget {
  const _TarjetaPersonal({required this.personal});

  final PersonalEnSitio personal;

  @override
  Widget build(BuildContext context) {
    final p = personal;
    final color = AppTheme.colorClasificacion(p.clasificacionEntrada);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(Icons.person, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.nombreCompleto,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15.5)),
                  const SizedBox(height: 2),
                  Text(
                    '${p.sitioNombre} · desde ${DateFormat('HH:mm').format(p.inicioAt)} '
                    '(${p.horasEnTurno.toStringAsFixed(1)} h)',
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.grisNeutro),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (p.clasificacionEntrada != 'a_tiempo')
                        _Pastilla(
                          texto: p.minutosRetardo > 0
                              ? 'Retardo ${p.minutosRetardo} min'
                              : 'Falta',
                          color: color,
                        ),
                      if (p.esDoblete)
                        const _Pastilla(
                            texto: 'Doblete', color: AppTheme.ambarSeguridad),
                      if (p.esCobertura)
                        const _Pastilla(
                            texto: 'Cubriendo', color: AppTheme.azulAcero),
                      if (p.horasEnTurno >= 24)
                        const _Pastilla(
                            texto: 'Turno cumplido', color: AppTheme.rojoAlerta),
                      if (p.estadoValidacion == 'pendiente_revision')
                        const _Pastilla(
                            texto: 'Ubicación sin validar',
                            color: AppTheme.grisNeutro),
                    ],
                  ),
                ],
              ),
            ),
            // Contacto directo por WhatsApp: es exactamente lo que pidió el
            // cliente para comunicarse con el elemento en turno.
            if (p.enlaceWhatsapp != null)
              IconButton.filledTonal(
                onPressed: () => launchUrl(
                  Uri.parse(p.enlaceWhatsapp!),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.chat),
                tooltip: 'Contactar por WhatsApp',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366).withValues(alpha: 0.15),
                  foregroundColor: const Color(0xFF128C7E),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaVisitante extends StatelessWidget {
  const _TarjetaVisitante({required this.visitante});

  final VisitanteDentro visitante;

  @override
  Widget build(BuildContext context) {
    final v = visitante;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
        title: Text(v.nombreCompleto,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          [
            if (v.empresaProcedencia.isNotEmpty) v.empresaProcedencia,
            if (v.personaVisitada.isNotEmpty) 'Visita a ${v.personaVisitada}',
            v.asunto,
            if (v.placas.isNotEmpty) 'Placas ${v.placas}',
          ].join(' · '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(DateFormat('HH:mm').format(v.horaEntrada),
                style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('${v.horasDentro.toStringAsFixed(1)} h',
                style: const TextStyle(
                    fontSize: 11.5, color: AppTheme.grisNeutro)),
          ],
        ),
      ),
    );
  }
}

// ─── Auxiliares compartidos ──────────────────────────────────────────────────

class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo, this.accion, this.onAccion});

  final String titulo;
  final String? accion;
  final VoidCallback? onAccion;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(titulo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const Spacer(),
        if (accion != null)
          TextButton(onPressed: onAccion, child: Text(accion!)),
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

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
}

class _Error extends StatelessWidget {
  const _Error({required this.mensaje});

  final String mensaje;

  @override
  Widget build(BuildContext context) => Card(
        color: AppTheme.rojoAlerta.withValues(alpha: 0.07),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: AppTheme.rojoAlerta),
              const SizedBox(width: 12),
              Expanded(child: Text(mensaje, style: const TextStyle(fontSize: 13))),
            ],
          ),
        ),
      );
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Center(
            child: Text(texto,
                style: const TextStyle(color: AppTheme.grisNeutro)),
          ),
        ),
      );
}
