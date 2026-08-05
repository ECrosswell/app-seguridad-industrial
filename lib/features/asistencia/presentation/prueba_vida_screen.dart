import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../core/services/app_logger.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/remote/foto_service.dart';

/// Resultado de la prueba de vida.
class ResultadoPruebaVida {
  const ResultadoPruebaVida({required this.rutaFoto, required this.aprobada});

  final String rutaFoto;
  final bool aprobada;
}

/// Captura la selfie de asistencia con prueba de vida.
///
/// **Qué es y qué no es.** Comprueba que frente a la cámara hay una persona
/// real y no una fotografía impresa o la pantalla de otro teléfono: se le pide
/// al elemento que parpadee y se verifica que la probabilidad de ojo abierto
/// baje y vuelva a subir. Eso es todo.
///
/// **No** es reconocimiento facial: no se compara el rostro contra ninguno
/// registrado, así que no se procesan datos biométricos y no entramos en el
/// régimen de dato personal sensible de la LFPDPPP, que exigiría consentimiento
/// expreso por escrito de cada elemento.
///
/// El análisis corre **en el dispositivo** con ML Kit; ningún fotograma del
/// stream sale del teléfono. Sólo se sube la foto final.
class PruebaVidaScreen extends StatefulWidget {
  const PruebaVidaScreen({super.key, this.titulo = 'Verificación'});

  final String titulo;

  @override
  State<PruebaVidaScreen> createState() => _PruebaVidaScreenState();
}

enum _Fase { iniciando, buscandoRostro, pideParpadeo, ojosCerrados, capturando, error }

class _PruebaVidaScreenState extends State<PruebaVidaScreen> {
  CameraController? _camara;
  FaceDetector? _detector;

  _Fase _fase = _Fase.iniciando;
  String _mensaje = 'Preparando la cámara…';
  bool _procesandoFotograma = false;
  bool _cerrando = false;

  /// Umbrales. 0.35 y 0.65 dejan una banda muerta entre "cerrado" y "abierto"
  /// para que el ruido del detector no dispare un falso parpadeo.
  static const _umbralOjoCerrado = 0.35;
  static const _umbralOjoAbierto = 0.65;

  Timer? _timeoutRostro;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  @override
  void dispose() {
    _timeoutRostro?.cancel();
    _camara?.dispose();
    _detector?.close();
    super.dispose();
  }

  Future<void> _inicializar() async {
    try {
      final camaras = await availableCameras();
      final frontal = camaras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => camaras.first,
      );

      final controlador = CameraController(
        frontal,
        ResolutionPreset.medium,
        enableAudio: false,
        // NV21 es el formato que ML Kit consume directamente en Android.
        // Pedirlo aquí evita una conversión de planos YUV propensa a errores.
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await controlador.initialize();

      _detector = FaceDetector(
        options: FaceDetectorOptions(
          // `enableClassification` es lo que habilita la probabilidad de ojo
          // abierto, que es la señal sobre la que se apoya el parpadeo.
          enableClassification: true,
          enableTracking: true,
          performanceMode: FaceDetectorMode.fast,
          minFaceSize: 0.25,
        ),
      );

      if (!mounted) return;
      _camara = controlador;
      setState(() {
        _fase = _Fase.buscandoRostro;
        _mensaje = 'Acerca tu rostro a la cámara';
      });

      await controlador.startImageStream(_procesarFotograma);
      _armarTimeout();
    } catch (e, s) {
      AppLogger.e('No se pudo iniciar la cámara', e, s);
      if (!mounted) return;
      setState(() {
        _fase = _Fase.error;
        _mensaje = 'No se pudo abrir la cámara. Revisa los permisos.';
      });
    }
  }

  /// Si en 45 s no se completa la prueba, se ofrece continuar sin ella. Un
  /// elemento no se puede quedar sin registrar su entrada porque el detector no
  /// lo reconozca de noche o con lentes.
  void _armarTimeout() {
    _timeoutRostro?.cancel();
    _timeoutRostro = Timer(const Duration(seconds: 45), () {
      if (!mounted || _cerrando) return;
      setState(() =>
          _mensaje = 'No se detecta bien tu rostro. Puedes continuar sin verificar.');
    });
  }

  Future<void> _procesarFotograma(CameraImage imagen) async {
    if (_procesandoFotograma || _cerrando) return;
    if (_fase == _Fase.capturando || _fase == _Fase.error) return;

    _procesandoFotograma = true;
    try {
      final entrada = _aInputImage(imagen);
      if (entrada == null) return;

      final rostros = await _detector!.processImage(entrada);

      if (rostros.isEmpty) {
        _actualizar(_Fase.buscandoRostro, 'Acerca tu rostro a la cámara');
        return;
      }

      final rostro = rostros.first;
      final izq = rostro.leftEyeOpenProbability;
      final der = rostro.rightEyeOpenProbability;

      // Sin clasificación de ojos (pasa en algunos equipos de gama baja) no se
      // puede medir el parpadeo. Se acepta la presencia de rostro y se sigue:
      // más vale una evidencia parcial que dejar al elemento sin registrar.
      if (izq == null || der == null) {
        await _capturar(aprobada: false);
        return;
      }

      final promedio = (izq + der) / 2;

      switch (_fase) {
        case _Fase.buscandoRostro:
          _actualizar(_Fase.pideParpadeo, 'Parpadea una vez');
        case _Fase.pideParpadeo:
          if (promedio < _umbralOjoCerrado) {
            _actualizar(_Fase.ojosCerrados, 'Ahora abre los ojos');
          }
        case _Fase.ojosCerrados:
          if (promedio > _umbralOjoAbierto) {
            await _capturar(aprobada: true);
          }
        default:
          break;
      }
    } catch (e) {
      AppLogger.w('Error al analizar fotograma: $e');
    } finally {
      _procesandoFotograma = false;
    }
  }

  void _actualizar(_Fase fase, String mensaje) {
    if (!mounted || (_fase == fase && _mensaje == mensaje)) return;
    setState(() {
      _fase = fase;
      _mensaje = mensaje;
    });
  }

  Future<void> _capturar({required bool aprobada}) async {
    if (_cerrando) return;
    _cerrando = true;
    _timeoutRostro?.cancel();

    _actualizar(_Fase.capturando, 'Listo, tomando la foto…');

    try {
      // Hay que detener el stream antes de tomar la foto: la cámara no puede
      // servir ambos a la vez.
      await _camara!.stopImageStream();
      final archivo = await _camara!.takePicture();

      final comprimida = await FotoService.comprimirYGuardar(archivo.path);
      if (!mounted) return;

      Navigator.of(context).pop(
        ResultadoPruebaVida(
          rutaFoto: comprimida ?? archivo.path,
          aprobada: aprobada,
        ),
      );
    } catch (e, s) {
      AppLogger.e('No se pudo tomar la foto', e, s);
      if (!mounted) return;
      setState(() {
        _fase = _Fase.error;
        _mensaje = 'No se pudo tomar la foto.';
        _cerrando = false;
      });
    }
  }

  /// Convierte el fotograma de la cámara al formato que espera ML Kit.
  InputImage? _aInputImage(CameraImage imagen) {
    final camara = _camara;
    if (camara == null) return null;

    final rotacion = InputImageRotationValue.fromRawValue(
      camara.description.sensorOrientation,
    );
    if (rotacion == null) return null;

    final formato = InputImageFormatValue.fromRawValue(imagen.format.raw);
    if (formato == null) return null;

    return InputImage.fromBytes(
      bytes: imagen.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(imagen.width.toDouble(), imagen.height.toDouble()),
        rotation: rotacion,
        format: formato,
        bytesPerRow: imagen.planes.first.bytesPerRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final camara = _camara;
    final listo = camara != null && camara.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (listo)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: camara.value.previewSize?.height ?? 1,
                height: camara.value.previewSize?.width ?? 1,
                child: CameraPreview(camara),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Óvalo guía
          if (listo)
            Center(
              child: Container(
                width: 260,
                height: 340,
                decoration: BoxDecoration(
                  border: Border.all(color: _colorGuia, width: 3),
                  borderRadius: BorderRadius.circular(180),
                ),
              ),
            ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _mensaje,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Salida siempre disponible: el registro nunca se bloquea por
                  // culpa del detector.
                  if (_fase != _Fase.capturando)
                    TextButton.icon(
                      onPressed: _cerrando ? null : () => _capturar(aprobada: false),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Tomar foto sin verificar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
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

  Color get _colorGuia => switch (_fase) {
        _Fase.buscandoRostro => Colors.white54,
        _Fase.pideParpadeo => AppTheme.ambarSeguridad,
        _Fase.ojosCerrados => AppTheme.ambarSeguridad,
        _Fase.capturando => AppTheme.verdeOperativo,
        _ => Colors.white24,
      };
}
