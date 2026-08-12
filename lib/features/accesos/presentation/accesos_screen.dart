import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_routes.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/app_database.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/accesos_provider.dart';

/// Control de acceso: quién está adentro y quién ya salió.
///
/// La pestaña "Dentro" es la vista de trabajo — de ahí se da salida con un
/// toque. "Historial" es para consultar.
class AccesosScreen extends ConsumerWidget {
  const AccesosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dentro = ref.watch(visitantesDentroProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Visitantes'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Dentro (${dentro.value?.length ?? 0})'),
              const Tab(text: 'Historial'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(Rutas.accesoNuevo),
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Registrar'),
        ),
        body: const TabBarView(
          children: [_PestanaDentro(), _PestanaHistorial()],
        ),
      ),
    );
  }
}

class _PestanaDentro extends ConsumerWidget {
  const _PestanaDentro();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dentro = ref.watch(visitantesDentroProvider);

    return dentro.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) {
        AppLogger.e('No se pudieron cargar los visitantes dentro', e, s);
        return _ErrorCarga(
          onReintentar: () => ref.invalidate(visitantesDentroProvider),
        );
      },
      data: (lista) {
        if (lista.isEmpty) {
          return const _Vacio(
            icono: Icons.person_off_outlined,
            texto: 'No hay visitantes dentro de la planta',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
          itemCount: lista.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _TarjetaVisitante(
            registro: lista[i],
            dentro: true,
            onSalida: () => _darSalida(context, ref, lista[i]),
          ),
        );
      },
    );
  }

  Future<void> _darSalida(
    BuildContext context,
    WidgetRef ref,
    LocalRegistrosAccesoData registro,
  ) async {
    final perfil = ref.read(perfilActualProvider);
    if (perfil == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrar salida'),
        content: Text(
          '${registro.nombreCompleto}\n\n'
          'Entró a las ${DateFormat('HH:mm').format(registro.horaEntrada)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Registrar salida'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await ref
        .read(accesosRepositoryProvider)
        .registrarSalida(
          localId: registro.localId,
          salidaRegistradaPor: perfil.id,
        );

    unawaited(ref.read(syncEngineProvider).sincronizarAhora());

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Salida de ${registro.nombreCompleto} registrada'),
          backgroundColor: AppTheme.verdeOperativo,
        ),
      );
    }
  }
}

class _PestanaHistorial extends ConsumerWidget {
  const _PestanaHistorial();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historial = ref.watch(historialAccesosProvider);

    return historial.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) {
        AppLogger.e('No se pudo cargar el historial de visitantes', e, s);
        return _ErrorCarga(
          onReintentar: () => ref.invalidate(historialAccesosProvider),
        );
      },
      data: (lista) {
        if (lista.isEmpty) {
          return const _Vacio(
            icono: Icons.history,
            texto: 'Todavía no hay salidas registradas',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
          itemCount: lista.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, i) =>
              _TarjetaVisitante(registro: lista[i], dentro: false),
        );
      },
    );
  }
}

class _TarjetaVisitante extends StatelessWidget {
  const _TarjetaVisitante({
    required this.registro,
    required this.dentro,
    this.onSalida,
  });

  final LocalRegistrosAccesoData registro;
  final bool dentro;
  final VoidCallback? onSalida;

  @override
  Widget build(BuildContext context) {
    final r = registro;
    final horas = DateTime.now().difference(r.horaEntrada).inMinutes / 60.0;
    final sincronizado = r.syncStatus == 'sincronizado';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: dentro
                      ? AppTheme.verdeOperativo.withValues(alpha: 0.15)
                      : AppTheme.grisNeutro.withValues(alpha: 0.15),
                  child: Icon(
                    dentro ? Icons.person : Icons.person_outline,
                    color: dentro
                        ? AppTheme.verdeOperativo
                        : AppTheme.grisNeutro,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.nombreCompleto,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                        ),
                      ),
                      if (r.empresaProcedencia.isNotEmpty)
                        Text(
                          r.empresaProcedencia,
                          style: const TextStyle(
                            color: AppTheme.grisNeutro,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  sincronizado
                      ? Icons.cloud_done_outlined
                      : Icons.cloud_upload_outlined,
                  size: 17,
                  color: sincronizado
                      ? AppTheme.verdeOperativo
                      : AppTheme.grisNeutro,
                ),
              ],
            ),
            const SizedBox(height: 12),

            _Dato(icono: Icons.assignment_outlined, texto: r.asunto),
            if (r.personaVisitadaTexto.isNotEmpty)
              _Dato(
                icono: Icons.person_search_outlined,
                texto: 'Visita a ${r.personaVisitadaTexto}',
              ),
            if (r.placas.isNotEmpty)
              _Dato(icono: Icons.directions_car_outlined, texto: r.placas),
            _Dato(
              icono: Icons.login,
              texto:
                  'Entrada ${DateFormat('d MMM HH:mm', 'es_MX').format(r.horaEntrada)}'
                  '${dentro ? ' · ${horas.toStringAsFixed(1)} h dentro' : ''}',
            ),
            if (r.horaSalida != null)
              _Dato(
                icono: Icons.logout,
                texto:
                    'Salida ${DateFormat('d MMM HH:mm', 'es_MX').format(r.horaSalida!)}',
              ),

            if (dentro && onSalida != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onSalida,
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Registrar salida'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 16, color: AppTheme.grisNeutro),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 13, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 56, color: AppTheme.grisNeutro),
          const SizedBox(height: 14),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.grisNeutro),
          ),
        ],
      ),
    );
  }
}

class _ErrorCarga extends StatelessWidget {
  const _ErrorCarga({required this.onReintentar});

  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sync_problem_outlined,
              size: 52,
              color: AppTheme.grisNeutro,
            ),
            const SizedBox(height: 14),
            const Text(
              'No se pudieron cargar los visitantes.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
