import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/constants/enums.dart';
import 'panel_repository.dart';

/// Generación de reportes descargables.
///
/// PDF para lo que se entrega al cliente (lleva encabezado, periodo y totales)
/// y CSV para lo que alguien va a analizar en Excel.
///
/// `Printing.sharePdf` funciona igual en web y en Android: en el navegador
/// dispara la descarga y en el teléfono abre el selector de compartir.
class ReportesService {
  const ReportesService();

  static final _fechaHora = DateFormat('d MMM yyyy HH:mm', 'es_MX');
  static final _soloFecha = DateFormat('d MMM yyyy', 'es_MX');

  // ─── PDF ──────────────────────────────────────────────────────────────────

  Future<void> pdfAsistencias({
    required List<Map<String, dynamic>> turnos,
    required RangoFechas rango,
    required String nombreSitio,
  }) async {
    final doc = pw.Document();

    final aTiempo = turnos.where((t) => t['clasificacion_entrada'] == 'a_tiempo').length;
    final retardos = turnos.where((t) => t['clasificacion_entrada'] == 'retardo').length;
    final faltas = turnos.where((t) => t['clasificacion_entrada'] == 'falta').length;
    final dobletes = turnos.where((t) => t['es_doblete'] == true).length;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        header: (ctx) => _encabezado('Reporte de asistencias', nombreSitio, rango),
        footer: _pie,
        build: (ctx) => [
          _resumen({
            'Turnos': '${turnos.length}',
            'A tiempo': '$aTiempo',
            'Retardos': '$retardos',
            'Faltas': '$faltas',
            'Dobletes': '$dobletes',
          }),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Elemento', 'Sitio', 'Fecha turno', 'Entrada', 'Salida',
              'Horas', 'Puntualidad', 'Retardo (min)', 'Observaciones',
            ],
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 9,
                color: PdfColors.white),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1B3A57)),
            cellStyle: const pw.TextStyle(fontSize: 8.5),
            cellAlignment: pw.Alignment.centerLeft,
            data: [
              for (final t in turnos)
                [
                  (t['profiles'] as Map?)?['nombre_completo'] as String? ?? '',
                  (t['sitios'] as Map?)?['nombre'] as String? ?? '',
                  _fechaCorta(t['turno_fecha']),
                  _hora(t['inicio_at']),
                  _hora(t['fin_at']),
                  _horasEntre(t['inicio_at'], t['fin_at']),
                  ClasificacionAsistencia.desdeValor(
                          t['clasificacion_entrada'] as String?)
                      .etiqueta,
                  '${t['minutos_retardo'] ?? 0}',
                  [
                    if (t['es_doblete'] == true) 'Doblete',
                    if (t['es_cobertura'] == true) 'Cobertura',
                    if (t['estado'] == 'cerrado_por_admin') 'Cerrado por admin',
                    if (t['estado'] == 'anomalia') 'Anomalía',
                  ].join(', '),
                ],
            ],
          ),
        ],
      ),
    );

    await _compartir(doc, 'asistencias');
  }

  Future<void> pdfVisitantes({
    required List<Map<String, dynamic>> accesos,
    required RangoFechas rango,
    required String nombreSitio,
  }) async {
    final doc = pw.Document();
    final conVehiculo = accesos.where((a) => a['ingresa_vehiculo'] == true).length;
    final dentro = accesos.where((a) => a['hora_salida'] == null).length;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        header: (ctx) => _encabezado('Reporte de visitantes', nombreSitio, rango),
        footer: _pie,
        build: (ctx) => [
          _resumen({
            'Accesos': '${accesos.length}',
            'Con vehículo': '$conVehiculo',
            'Aún dentro': '$dentro',
          }),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Visitante', 'Empresa', 'Visita a', 'Asunto', 'Placas',
              'Entrada', 'Salida', 'Registró',
            ],
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 9,
                color: PdfColors.white),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1B3A57)),
            cellStyle: const pw.TextStyle(fontSize: 8.5),
            cellAlignment: pw.Alignment.centerLeft,
            data: [
              for (final a in accesos)
                [
                  a['nombre_completo'] as String? ?? '',
                  a['empresa_procedencia'] as String? ?? '',
                  (a['personal_cliente'] as Map?)?['nombre_completo']
                          as String? ??
                      (a['persona_visitada_texto'] as String? ?? ''),
                  a['asunto'] as String? ?? '',
                  a['placas'] as String? ?? '',
                  _fechaHoraCorta(a['hora_entrada']),
                  a['hora_salida'] == null
                      ? 'Dentro'
                      : _fechaHoraCorta(a['hora_salida']),
                  (a['profiles'] as Map?)?['nombre_completo'] as String? ?? '',
                ],
            ],
          ),
        ],
      ),
    );

    await _compartir(doc, 'visitantes');
  }

  Future<void> pdfBitacora({
    required List<Map<String, dynamic>> eventos,
    required RangoFechas rango,
    required String nombreSitio,
  }) async {
    final doc = pw.Document();

    final porTipo = <String, int>{};
    for (final e in eventos) {
      final t = e['tipo'] as String? ?? 'libre';
      porTipo[t] = (porTipo[t] ?? 0) + 1;
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter.landscape,
        header: (ctx) => _encabezado('Bitácora de servicio', nombreSitio, rango),
        footer: _pie,
        build: (ctx) => [
          _resumen({
            'Eventos': '${eventos.length}',
            for (final e in porTipo.entries)
              TipoEventoBitacora.desdeValor(e.key).etiqueta: '${e.value}',
          }),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Fecha', 'Tipo', 'Descripción', 'Placas', 'Destino',
              'Documento', 'Autorizó', 'Registró',
            ],
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, fontSize: 9,
                color: PdfColors.white),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1B3A57)),
            cellStyle: const pw.TextStyle(fontSize: 8.5),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              2: const pw.FlexColumnWidth(3),
            },
            data: [
              for (final e in eventos)
                [
                  _fechaHoraCorta(e['ocurrido_at']),
                  TipoEventoBitacora.desdeValor(e['tipo'] as String?).etiqueta,
                  e['descripcion'] as String? ?? '',
                  e['placas'] as String? ?? '',
                  e['destino'] as String? ?? '',
                  e['num_documento'] as String? ?? '',
                  (e['personal_cliente'] as Map?)?['nombre_completo']
                          as String? ??
                      (e['autorizado_por_texto'] as String? ?? ''),
                  (e['profiles'] as Map?)?['nombre_completo'] as String? ?? '',
                ],
            ],
          ),
        ],
      ),
    );

    await _compartir(doc, 'bitacora');
  }

  // ─── CSV ──────────────────────────────────────────────────────────────────

  Future<void> csvAsistencias(List<Map<String, dynamic>> turnos) async {
    final filas = <List<dynamic>>[
      [
        'Elemento', 'Sitio', 'Fecha turno', 'Entrada', 'Salida', 'Horas',
        'Puntualidad', 'Minutos retardo', 'Doblete', 'Cobertura', 'Estado',
      ],
      for (final t in turnos)
        [
          (t['profiles'] as Map?)?['nombre_completo'] ?? '',
          (t['sitios'] as Map?)?['nombre'] ?? '',
          t['turno_fecha'] ?? '',
          _hora(t['inicio_at']),
          _hora(t['fin_at']),
          _horasEntre(t['inicio_at'], t['fin_at']),
          ClasificacionAsistencia.desdeValor(
                  t['clasificacion_entrada'] as String?)
              .etiqueta,
          t['minutos_retardo'] ?? 0,
          t['es_doblete'] == true ? 'Sí' : 'No',
          t['es_cobertura'] == true ? 'Sí' : 'No',
          t['estado'] ?? '',
        ],
    ];

    await _descargarCsv(filas, 'asistencias');
  }

  Future<void> csvVisitantes(List<Map<String, dynamic>> accesos) async {
    final filas = <List<dynamic>>[
      [
        'Visitante', 'Empresa', 'Teléfono', 'Visita a', 'Área', 'Asunto',
        'Vehículo', 'Placas', 'Entrada', 'Salida', 'Registró',
      ],
      for (final a in accesos)
        [
          a['nombre_completo'] ?? '',
          a['empresa_procedencia'] ?? '',
          a['telefono'] ?? '',
          (a['personal_cliente'] as Map?)?['nombre_completo'] ??
              (a['persona_visitada_texto'] ?? ''),
          (a['personal_cliente'] as Map?)?['area'] ?? '',
          a['asunto'] ?? '',
          a['ingresa_vehiculo'] == true ? 'Sí' : 'No',
          a['placas'] ?? '',
          _fechaHoraCorta(a['hora_entrada']),
          a['hora_salida'] == null ? 'Dentro' : _fechaHoraCorta(a['hora_salida']),
          (a['profiles'] as Map?)?['nombre_completo'] ?? '',
        ],
    ];

    await _descargarCsv(filas, 'visitantes');
  }

  Future<void> csvBitacora(List<Map<String, dynamic>> eventos) async {
    final filas = <List<dynamic>>[
      [
        'Fecha', 'Tipo', 'Descripción', 'Prioridad', 'Placas', 'Operador',
        'Transportista', 'Documento', 'Destino', 'Autorizó', 'Registró',
        'Pendiente',
      ],
      for (final e in eventos)
        [
          _fechaHoraCorta(e['ocurrido_at']),
          TipoEventoBitacora.desdeValor(e['tipo'] as String?).etiqueta,
          e['descripcion'] ?? '',
          e['prioridad'] ?? '',
          e['placas'] ?? '',
          e['transportista'] ?? '',
          e['empresa_transporte'] ?? '',
          e['num_documento'] ?? '',
          e['destino'] ?? '',
          (e['personal_cliente'] as Map?)?['nombre_completo'] ??
              (e['autorizado_por_texto'] ?? ''),
          (e['profiles'] as Map?)?['nombre_completo'] ?? '',
          (e['requiere_seguimiento'] == true && e['resuelto'] != true)
              ? 'Sí'
              : 'No',
        ],
    ];

    await _descargarCsv(filas, 'bitacora');
  }

  // ─── Auxiliares ───────────────────────────────────────────────────────────

  Future<void> _compartir(pw.Document doc, String nombre) async {
    final bytes = await doc.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${nombre}_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.pdf',
    );
  }

  Future<void> _descargarCsv(List<List<dynamic>> filas, String nombre) async {
    // `excel` es la instancia de csv ya configurada para Excel (separador y
    // comillas que Excel espera).
    final texto = excel.encode(filas);

    // Codificar en UTF-8 de verdad, no `codeUnits`: eso daría UTF-16 y todos
    // los acentos y eñes saldrían rotos.
    //
    // El BOM al inicio es lo que hace que Excel en Windows reconozca el archivo
    // como UTF-8; sin él abre los acentos como caracteres basura aunque el
    // contenido sea correcto.
    final bytes = <int>[0xEF, 0xBB, 0xBF, ...utf8.encode(texto)];

    await Printing.sharePdf(
      bytes: Uint8List.fromList(bytes),
      filename:
          '${nombre}_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.csv',
    );
  }

  static pw.Widget _encabezado(
      String titulo, String sitio, RangoFechas rango) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      margin: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColor.fromInt(0xFF1B3A57), width: 2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Seguridad Industrial',
                  style: pw.TextStyle(
                      fontSize: 10, color: PdfColors.grey700)),
              pw.SizedBox(height: 2),
              pw.Text(titulo,
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 2),
              pw.Text(sitio, style: const pw.TextStyle(fontSize: 11)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Del ${_soloFecha.format(rango.desde)} al ${_soloFecha.format(rango.hasta)}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 2),
              pw.Text('Generado ${_fechaHora.format(DateTime.now())}',
                  style: const pw.TextStyle(
                      fontSize: 9, color: PdfColors.grey600)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _pie(pw.Context ctx) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Página ${ctx.pageNumber} de ${ctx.pagesCount}',
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
      ),
    );
  }

  static pw.Widget _resumen(Map<String, String> datos) {
    return pw.Row(
      children: [
        for (final d in datos.entries)
          pw.Container(
            margin: const pw.EdgeInsets.only(right: 10),
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(d.key,
                    style: const pw.TextStyle(
                        fontSize: 8, color: PdfColors.grey700)),
                pw.SizedBox(height: 2),
                pw.Text(d.value,
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
      ],
    );
  }

  static String _hora(Object? v) {
    final d = DateTime.tryParse(v?.toString() ?? '');
    return d == null ? '—' : DateFormat('HH:mm').format(d.toLocal());
  }

  static String _fechaCorta(Object? v) {
    final d = DateTime.tryParse(v?.toString() ?? '');
    return d == null ? '—' : DateFormat('dd/MM/yy').format(d);
  }

  static String _fechaHoraCorta(Object? v) {
    final d = DateTime.tryParse(v?.toString() ?? '');
    return d == null ? '—' : DateFormat('dd/MM HH:mm').format(d.toLocal());
  }

  static String _horasEntre(Object? inicio, Object? fin) {
    final a = DateTime.tryParse(inicio?.toString() ?? '');
    if (a == null) return '—';
    final b = DateTime.tryParse(fin?.toString() ?? '') ?? DateTime.now();
    final d = b.difference(a);
    return '${d.inHours}h ${d.inMinutes % 60}m';
  }
}
