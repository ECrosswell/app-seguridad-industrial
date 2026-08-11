import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../data/rondin_admin_models.dart';

Future<void> mostrarDialogoQrPunto(
  BuildContext context, {
  required PuntoRondin punto,
  required String payload,
  bool codigoRotado = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _DialogoQrPunto(
      punto: punto,
      payload: payload,
      codigoRotado: codigoRotado,
    ),
  );
}

class _DialogoQrPunto extends StatefulWidget {
  const _DialogoQrPunto({
    required this.punto,
    required this.payload,
    required this.codigoRotado,
  });

  final PuntoRondin punto;
  final String payload;
  final bool codigoRotado;

  @override
  State<_DialogoQrPunto> createState() => _DialogoQrPuntoState();
}

class _DialogoQrPuntoState extends State<_DialogoQrPunto> {
  bool _imprimiendo = false;

  @override
  Widget build(BuildContext context) {
    final punto = widget.punto;
    final ubicacion = [
      punto.sitioNombre,
      punto.seccionNombre,
    ].where((texto) => texto.trim().isNotEmpty).join(' · ');

    return AlertDialog(
      title: Text(widget.codigoRotado ? 'Nuevo código QR' : 'Código QR'),
      content: SizedBox(
        width: 430,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.codigoRotado)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.ambarSeguridad.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'El código anterior quedó revocado para la validación del '
                    'servidor. Retíralo antes de colocar esta nueva impresión.',
                    style: TextStyle(fontSize: 12.5, height: 1.35),
                  ),
                ),
              Semantics(
                label: 'Código QR del punto ${punto.nombre}',
                child: Container(
                  padding: const EdgeInsets.all(18),
                  color: Colors.white,
                  child: QrImageView(
                    data: widget.payload,
                    version: QrVersions.auto,
                    size: 250,
                    errorCorrectionLevel: QrErrorCorrectLevel.Q,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                punto.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (ubicacion.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  ubicacion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.grisNeutro),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Versión ${punto.qrVersion} · El valor interno no se muestra '
                'para evitar copias accidentales.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppTheme.grisNeutro,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _imprimiendo ? null : () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
        FilledButton.icon(
          onPressed: _imprimiendo ? null : _imprimir,
          icon: _imprimiendo
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.print_outlined),
          label: const Text('Imprimir PDF'),
        ),
      ],
    );
  }

  Future<void> _imprimir() async {
    setState(() => _imprimiendo = true);
    try {
      final documento = _crearPdf(widget.punto, widget.payload);
      await Printing.layoutPdf(
        name: _nombreArchivo(widget.punto.nombre),
        onLayout: (_) => documento.save(),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo preparar el PDF: $error'),
          backgroundColor: AppTheme.rojoAlerta,
        ),
      );
    } finally {
      if (mounted) setState(() => _imprimiendo = false);
    }
  }
}

pw.Document _crearPdf(PuntoRondin punto, String payload) {
  final documento = pw.Document(
    title: 'Punto QR - ${punto.nombre}',
    author: 'Seguridad Industrial',
  );
  final ubicacion = [
    punto.sitioNombre,
    punto.seccionNombre,
  ].where((texto) => texto.trim().isNotEmpty).join(' · ');

  documento.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(42),
      build: (context) => pw.Center(
        child: pw.Container(
          width: 430,
          padding: const pw.EdgeInsets.all(30),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.blueGrey800, width: 2),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
          ),
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                'PUNTO DE RONDÍN',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800,
                  letterSpacing: 1.2,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: payload,
                width: 260,
                height: 260,
                drawText: false,
              ),
              pw.SizedBox(height: 22),
              pw.Text(
                punto.nombre,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (ubicacion.isNotEmpty) ...[
                pw.SizedBox(height: 7),
                pw.Text(
                  ubicacion,
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
              if (punto.descripcion.trim().isNotEmpty) ...[
                pw.SizedBox(height: 14),
                pw.Text(
                  punto.descripcion,
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    fontSize: 11,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
              pw.SizedBox(height: 22),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                color: PdfColors.blueGrey50,
                child: pw.Text(
                  'Escanea este punto desde la aplicación durante tu rondín. '
                  'El servidor comprobará también ubicación, secuencia, '
                  'tiempos y señales del dispositivo.',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 10, lineSpacing: 3),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'QR v${punto.qrVersion} · No fotografiar ni reubicar',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  return documento;
}

String _nombreArchivo(String nombre) {
  final seguro = nombre
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return 'punto-rondin-${seguro.isEmpty ? 'qr' : seguro}.pdf';
}
