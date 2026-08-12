import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_routes.dart';
import '../../../core/constants/enums.dart';
import '../../../core/services/app_logger.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/app_database.dart';
import '../providers/bitacora_provider.dart';

class BitacoraScreen extends ConsumerWidget {
  const BitacoraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendientes = ref.watch(pendientesBitacoraProvider).value ?? const [];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bitácora'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Turno'),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Pendientes'),
                    if (pendientes.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.ambarSeguridad,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${pendientes.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Tab(text: 'Histórico'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(Rutas.bitacoraNueva),
          icon: const Icon(Icons.add),
          label: const Text('Nuevo evento'),
        ),
        body: TabBarView(
          children: [
            _Lista(
              provider: bitacoraDelTurnoProvider,
              vacio: 'Sin eventos en este turno',
            ),
            _Lista(
              provider: pendientesBitacoraProvider,
              vacio: 'Nada pendiente de resolver',
              mostrarResolver: true,
            ),
            _Lista(provider: historialBitacoraProvider, vacio: 'Sin histórico'),
          ],
        ),
      ),
    );
  }
}

class _Lista extends ConsumerWidget {
  const _Lista({
    required this.provider,
    required this.vacio,
    this.mostrarResolver = false,
  });

  final StreamProvider<List<LocalBitacoraEvento>> provider;
  final String vacio;
  final bool mostrarResolver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datos = ref.watch(provider);

    return datos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) {
        AppLogger.e('No se pudo cargar la bitácora', e, s);
        return _ErrorCarga(onReintentar: () => ref.invalidate(provider));
      },
      data: (lista) {
        if (lista.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 56,
                  color: AppTheme.grisNeutro,
                ),
                const SizedBox(height: 14),
                Text(vacio, style: const TextStyle(color: AppTheme.grisNeutro)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
          itemCount: lista.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _TarjetaEvento(
            evento: lista[i],
            onResolver: mostrarResolver
                ? () => _resolver(context, ref, lista[i])
                : null,
          ),
        );
      },
    );
  }

  Future<void> _resolver(
    BuildContext context,
    WidgetRef ref,
    LocalBitacoraEvento evento,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Marcar como resuelto?'),
        content: Text(evento.descripcion),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Resolver'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await ref.read(bitacoraRepositoryProvider).resolver(evento.localId);
    }
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
              'No se pudo cargar la bitácora.',
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

class _TarjetaEvento extends StatelessWidget {
  const _TarjetaEvento({required this.evento, this.onResolver});

  final LocalBitacoraEvento evento;
  final VoidCallback? onResolver;

  @override
  Widget build(BuildContext context) {
    final e = evento;
    final tipo = TipoEventoBitacora.desdeValor(e.tipo);
    final color = AppTheme.colorPrioridad(e.prioridad);
    final sincronizado = e.syncStatus == 'sincronizado';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                  child: Icon(_icono(tipo), size: 20, color: color),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipo.etiqueta,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'd MMM · HH:mm',
                          'es_MX',
                        ).format(e.ocurridoAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.grisNeutro,
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
            const SizedBox(height: 10),
            Text(e.descripcion, style: const TextStyle(height: 1.35)),

            if (e.placas.isNotEmpty ||
                e.destino.isNotEmpty ||
                e.numDocumento.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  if (e.placas.isNotEmpty)
                    _Chip(
                      icono: Icons.directions_car_outlined,
                      texto: e.placas,
                    ),
                  if (e.destino.isNotEmpty)
                    _Chip(icono: Icons.place_outlined, texto: e.destino),
                  if (e.numDocumento.isNotEmpty)
                    _Chip(
                      icono: Icons.description_outlined,
                      texto: e.numDocumento,
                    ),
                  if (e.transportista.isNotEmpty)
                    _Chip(
                      icono: Icons.local_shipping_outlined,
                      texto: e.transportista,
                    ),
                  if (e.autorizadoPorTexto.isNotEmpty)
                    _Chip(
                      icono: Icons.how_to_reg_outlined,
                      texto: 'Autorizó ${e.autorizadoPorTexto}',
                    ),
                ],
              ),
            ],

            if (onResolver != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onResolver,
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text('Marcar resuelto'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static IconData _icono(TipoEventoBitacora tipo) => switch (tipo) {
    TipoEventoBitacora.salidaMercancia => Icons.output_outlined,
    TipoEventoBitacora.ingresoMateriaPrima => Icons.input_outlined,
    TipoEventoBitacora.entradaVehiculo => Icons.login_outlined,
    TipoEventoBitacora.salidaVehiculo => Icons.logout_outlined,
    TipoEventoBitacora.fallaInfraestructura => Icons.build_outlined,
    TipoEventoBitacora.incidenteSeguridad => Icons.warning_amber_outlined,
    TipoEventoBitacora.ronda => Icons.directions_walk_outlined,
    TipoEventoBitacora.correspondencia => Icons.mail_outline,
    TipoEventoBitacora.libre => Icons.notes_outlined,
  };
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 15, color: AppTheme.grisNeutro),
        const SizedBox(width: 5),
        Text(
          texto,
          style: const TextStyle(fontSize: 12.5, color: AppTheme.grisNeutro),
        ),
      ],
    );
  }
}
