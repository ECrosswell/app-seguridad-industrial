import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../data/reportes_service.dart';
import '../providers/panel_provider.dart';
import 'widgets/filtro_rango.dart';

/// Descarga de reportes en PDF y CSV.
///
/// El periodo lo elige el usuario, no hay periodicidad fija: el cliente pidió
/// poder sacarlos cuando quiera y del rango que quiera.
class PanelReportesScreen extends ConsumerStatefulWidget {
  const PanelReportesScreen({super.key});

  @override
  ConsumerState<PanelReportesScreen> createState() =>
      _PanelReportesScreenState();
}

class _PanelReportesScreenState extends ConsumerState<PanelReportesScreen> {
  String? _generando;

  @override
  Widget build(BuildContext context) {
    final turnos = ref.watch(turnosPanelProvider);
    final accesos = ref.watch(accesosPanelProvider);
    final bitacora = ref.watch(bitacoraPanelProvider);

    final sitios = ref.watch(sitiosPanelProvider).value ?? const [];
    final sitioId = ref.watch(sitioFiltroProvider);
    final nombreSitio = sitioId == null
        ? 'Todos los sitios'
        : sitios.where((s) => s.id == sitioId).map((s) => s.nombre).firstOrNull ??
            'Sitio';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Reportes',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        const Text(
          'Elige el periodo y descarga. El PDF trae encabezado y totales; '
          'el CSV se abre en Excel.',
          style: TextStyle(color: AppTheme.grisNeutro, height: 1.4),
        ),
        const SizedBox(height: 20),
        const FiltroRango(),
        const SizedBox(height: 24),

        _TarjetaReporte(
          icono: Icons.badge_outlined,
          titulo: 'Asistencias y turnos',
          detalle:
              'Entradas, salidas, horas trabajadas, retardos, faltas y dobletes.',
          registros: turnos.value?.length,
          generando: _generando,
          clave: 'asistencias',
          onPdf: () => _generar('asistencias', () async {
            await const ReportesService().pdfAsistencias(
              turnos: turnos.value ?? const [],
              rango: ref.read(rangoFiltroProvider),
              nombreSitio: nombreSitio,
            );
          }),
          onCsv: () => _generar('asistencias', () async {
            await const ReportesService()
                .csvAsistencias(turnos.value ?? const []);
          }),
        ),

        _TarjetaReporte(
          icono: Icons.people_outline,
          titulo: 'Control de acceso',
          detalle:
              'Visitantes, a quién visitaron, motivo, vehículos y placas.',
          registros: accesos.value?.length,
          generando: _generando,
          clave: 'visitantes',
          onPdf: () => _generar('visitantes', () async {
            await const ReportesService().pdfVisitantes(
              accesos: accesos.value ?? const [],
              rango: ref.read(rangoFiltroProvider),
              nombreSitio: nombreSitio,
            );
          }),
          onCsv: () => _generar('visitantes', () async {
            await const ReportesService()
                .csvVisitantes(accesos.value ?? const []);
          }),
        ),

        _TarjetaReporte(
          icono: Icons.menu_book_outlined,
          titulo: 'Bitácora de servicio',
          detalle:
              'Movimientos de mercancía, fallas, incidentes, rondas y vehículos.',
          registros: bitacora.value?.length,
          generando: _generando,
          clave: 'bitacora',
          onPdf: () => _generar('bitacora', () async {
            await const ReportesService().pdfBitacora(
              eventos: bitacora.value ?? const [],
              rango: ref.read(rangoFiltroProvider),
              nombreSitio: nombreSitio,
            );
          }),
          onCsv: () => _generar('bitacora', () async {
            await const ReportesService()
                .csvBitacora(bitacora.value ?? const []);
          }),
        ),
      ],
    );
  }

  Future<void> _generar(String clave, Future<void> Function() accion) async {
    setState(() => _generando = clave);
    try {
      await accion();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo generar el reporte: $e'),
            backgroundColor: AppTheme.rojoAlerta,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _generando = null);
    }
  }
}

class _TarjetaReporte extends StatelessWidget {
  const _TarjetaReporte({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.registros,
    required this.generando,
    required this.clave,
    required this.onPdf,
    required this.onCsv,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final int? registros;
  final String? generando;
  final String clave;
  final VoidCallback onPdf;
  final VoidCallback onCsv;

  @override
  Widget build(BuildContext context) {
    final ocupado = generando == clave;
    final vacio = registros == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.azulAcero.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icono, color: AppTheme.azulAcero, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(detalle,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.grisNeutro,
                          height: 1.35)),
                  const SizedBox(height: 8),
                  Text(
                    registros == null
                        ? 'Cargando…'
                        : '$registros registro(s) en el periodo',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: vacio ? AppTheme.ambarSeguridad : AppTheme.azulAcero,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: (ocupado || vacio || registros == null)
                            ? null
                            : onPdf,
                        icon: ocupado
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        label: const Text('PDF'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: (ocupado || vacio || registros == null)
                            ? null
                            : onCsv,
                        icon: const Icon(Icons.table_chart_outlined, size: 18),
                        label: const Text('CSV'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
