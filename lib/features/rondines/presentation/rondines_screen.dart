import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_routes.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../asistencia/providers/asistencia_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/rondines_repository.dart';
import '../providers/rondines_provider.dart';
import '../services/security_clock_service.dart';

class RondinesScreen extends ConsumerWidget {
  const RondinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilActualProvider);
    final turno = ref.watch(turnoAbiertoProvider).value;
    final actual = ref.watch(rondinEnCursoProvider);
    final rutas = ref.watch(rutasRondinDisponiblesProvider);
    final historial = ref.watch(historialRondinesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Rondín QR')),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(syncEngineProvider).sincronizarAhora();
          ref.invalidate(rutasRondinDisponiblesProvider);
          ref.invalidate(rondinEnCursoProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            const _AvisoAntifraude(),
            const SizedBox(height: 16),
            if (perfil == null || turno == null)
              const _SinTurno()
            else
              actual.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('No se pudo abrir el rondín: $e'),
                data: (rondin) {
                  if (rondin != null) {
                    return _RondinActivo(rondin: rondin);
                  }
                  return rutas.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('No se pudieron leer las rutas: $e'),
                    data: (lista) => _RutasDisponibles(
                      rutas: lista,
                      onIniciar: (ruta) =>
                          _iniciar(context, ref, perfil.id, turno, ruta),
                    ),
                  );
                },
              ),
            if (historial.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Rondines recientes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final r in historial.take(8)) _HistorialTile(rondin: r),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _iniciar(
    BuildContext context,
    WidgetRef ref,
    String usuarioId,
    dynamic turno,
    RutaRondinLocal ruta,
  ) async {
    try {
      final senales = await SecurityClockService.obtener();
      final localId = await ref
          .read(rondinesRepositoryProvider)
          .iniciar(
            usuarioId: usuarioId,
            turno: turno,
            ruta: ruta,
            senales: senales,
          );
      if (!context.mounted) return;
      refrescarRondines(ref);
      context.push(Rutas.rondinEscanear(localId));
    } on RondinException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.mensaje)));
      }
    }
  }
}

class _AvisoAntifraude extends StatelessWidget {
  const _AvisoAntifraude();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.azulAcero.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.azulAcero.withValues(alpha: 0.25)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined, color: AppTheme.azulAcero),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cada lectura registra ubicación, precisión, WiFi de zona, '
              'orden y tiempo de traslado. Sin conexión queda guardada en el '
              'teléfono y el servidor la verifica al sincronizar.',
              style: TextStyle(fontSize: 13, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _SinTurno extends StatelessWidget {
  const _SinTurno();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.lock_clock_outlined),
        title: Text('Necesitas un turno abierto'),
        subtitle: Text('Registra tu entrada antes de iniciar un rondín.'),
      ),
    );
  }
}

class _RutasDisponibles extends StatelessWidget {
  const _RutasDisponibles({required this.rutas, required this.onIniciar});

  final List<RutaRondinLocal> rutas;
  final ValueChanged<RutaRondinLocal> onIniciar;

  @override
  Widget build(BuildContext context) {
    if (rutas.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No hay una ruta descargada para este sitio. Conéctate una vez '
            'después de que el administrador configure los puntos.',
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rutas disponibles',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        for (final ruta in rutas)
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.route_outlined)),
              title: Text(ruta.ruta.nombre),
              subtitle: Text(
                '${ruta.pasos.length} punto(s) · '
                '${ruta.ruta.minutosMinimos}–${ruta.ruta.minutosMaximos} min',
              ),
              trailing: FilledButton(
                onPressed: () => onIniciar(ruta),
                child: const Text('Iniciar'),
              ),
            ),
          ),
      ],
    );
  }
}

class _RondinActivo extends ConsumerWidget {
  const _RondinActivo({required this.rondin});

  final dynamic rondin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lecturas =
        ref.watch(lecturasRondinProvider(rondin.localId)).value ?? const [];
    final rutas = ref.watch(rutasRondinDisponiblesProvider).value ?? const [];
    RutaRondinLocal? ruta;
    for (final item in rutas) {
      if (item.ruta.id == rondin.rutaId) ruta = item;
    }
    final total = ruta?.pasos.length ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.directions_walk, color: AppTheme.verdeOperativo),
                SizedBox(width: 10),
                Text(
                  'Rondín en curso',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: total == 0 ? 0 : lecturas.length / total,
            ),
            const SizedBox(height: 8),
            Text('${lecturas.length} de $total puntos registrados'),
            if (ruta != null && lecturas.length < ruta.pasos.length) ...[
              const SizedBox(height: 8),
              Text(
                'Siguiente: ${ruta.pasos[lecturas.length].punto.seccionNombre} '
                '· ${ruta.pasos[lecturas.length].punto.nombre}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () =>
                  context.push(Rutas.rondinEscanear(rondin.localId)),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Escanear siguiente punto'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistorialTile extends StatelessWidget {
  const _HistorialTile({required this.rondin});
  final dynamic rondin;

  @override
  Widget build(BuildContext context) {
    final servidor = rondin.estadoValidacionServidor as String?;
    final (icono, color, texto) = switch (servidor) {
      'validado' => (
        Icons.verified,
        AppTheme.verdeOperativo,
        'Verificado por servidor',
      ),
      'rechazado' => (Icons.cancel_outlined, AppTheme.rojoAlerta, 'Rechazado'),
      'pendiente_revision' => (
        Icons.manage_search,
        AppTheme.ambarSeguridad,
        'En revisión',
      ),
      _ => (
        Icons.cloud_upload_outlined,
        AppTheme.grisNeutro,
        'Pendiente de sincronizar',
      ),
    };
    return ListTile(
      leading: Icon(icono, color: color),
      title: Text(texto),
      subtitle: Text(rondin.iniciadoAtDispositivo.toString()),
    );
  }
}
