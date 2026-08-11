import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/remote/foto_service.dart';
import '../../asistencia/presentation/prueba_vida_screen.dart';
import '../../asistencia/services/presence_service.dart';
import '../data/rondines_repository.dart';
import '../providers/rondines_provider.dart';
import '../services/security_clock_service.dart';

class EscanearPuntoScreen extends ConsumerStatefulWidget {
  const EscanearPuntoScreen({super.key, required this.rondinLocalId});

  final String rondinLocalId;

  @override
  ConsumerState<EscanearPuntoScreen> createState() =>
      _EscanearPuntoScreenState();
}

class _EscanearPuntoScreenState extends ConsumerState<EscanearPuntoScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );
  bool _procesando = false;
  String? _mensaje;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  Future<void> _detectar(BarcodeCapture captura) async {
    if (_procesando) return;
    String? raw;
    for (final codigo in captura.barcodes) {
      if (codigo.rawValue != null && codigo.rawValue!.isNotEmpty) {
        raw = codigo.rawValue;
        break;
      }
    }
    if (raw == null) return;

    setState(() {
      _procesando = true;
      _mensaje = 'Comprobando ubicación y señales del punto…';
    });
    await _controller.stop();

    String? fotoLiveness;
    try {
      final punto = await ref
          .read(rondinesRepositoryProvider)
          .puntoConfiguradoParaQr(raw);
      var livenessPassed = false;
      if (punto.requiereLiveness) {
        if (!mounted) return;
        final prueba = await Navigator.of(context).push<ResultadoPruebaVida>(
          MaterialPageRoute(
            builder: (_) =>
                const PruebaVidaScreen(titulo: 'Prueba de vida del rondín'),
          ),
        );
        if (prueba == null) {
          if (!mounted) return;
          setState(() {
            _procesando = false;
            _mensaje = null;
          });
          await _controller.start();
          return;
        }
        fotoLiveness = prueba.rutaFoto;
        livenessPassed = prueba.aprobada;
      }

      final resultados = await Future.wait<dynamic>([
        PresenceService.obtener(),
        SecurityClockService.obtener(),
      ]);
      final resultado = await ref
          .read(rondinesRepositoryProvider)
          .registrarLectura(
            rondinLocalId: widget.rondinLocalId,
            qrRaw: raw,
            presencia: resultados[0] as Presencia,
            senales: resultados[1] as SenalesSeguridadDispositivo,
            livenessPassed: livenessPassed,
          );
      if (!mounted) return;
      refrescarRondines(ref);
      unawaited(ref.read(syncEngineProvider).sincronizarAhora());
      await _mostrarResultado(resultado);
    } on RondinException catch (e) {
      if (!mounted) return;
      setState(() => _mensaje = e.mensaje);
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        _procesando = false;
        _mensaje = null;
      });
      await _controller.start();
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _mensaje = 'No se pudo guardar la lectura. Intenta otra vez.',
      );
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        _procesando = false;
        _mensaje = null;
      });
      await _controller.start();
    } finally {
      if (fotoLiveness != null) {
        unawaited(FotoService.borrarLocal(fotoLiveness));
      }
    }
  }

  Future<void> _mostrarResultado(RegistroLecturaResultado resultado) async {
    final sospechoso = resultado.evaluacion.estado == 'capturado_sospechoso';
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          sospechoso ? Icons.warning_amber : Icons.cloud_upload_outlined,
          color: AppTheme.ambarSeguridad,
          size: 42,
        ),
        title: Text(
          resultado.rondinCompletado
              ? 'Rondín pendiente de validación'
              : 'Captura registrada',
        ),
        content: Text(
          resultado.evaluacion.codigosRiesgo.isEmpty
              ? 'La evidencia quedó guardada como pendiente. Sólo el '
                    'servidor puede validar el QR al sincronizar.'
              : 'Quedó guardado para revisión: '
                    '${resultado.evaluacion.codigosRiesgo.join(', ')}.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Escanear punto'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _detectar),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (_procesando)
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      _mensaje ??
                          'Apunta la cámara al QR colocado físicamente en la sección.',
                      style: const TextStyle(color: Colors.white, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
