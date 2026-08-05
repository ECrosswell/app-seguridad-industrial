import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/env_config.dart';
import '../../core/services/app_logger.dart';
import '../../core/services/supabase_service.dart';

/// Manejo de evidencia fotográfica: comprimir, guardar en el dispositivo y
/// subir a Storage.
///
/// El flujo siempre es **guardar local primero, subir después**. La foto se
/// comprime y se copia a un directorio propio de la app en el momento en que se
/// toma; el motor de sincronización la sube cuando haya red. Si se subiera
/// directo, una caseta sin señal simplemente no podría documentar nada.
class FotoService {
  const FotoService._();

  static const _uuid = Uuid();

  /// Comprime y guarda la imagen en el almacenamiento de la app.
  ///
  /// Devuelve la ruta local. Baja la calidad de forma progresiva hasta caber en
  /// el límite del bucket (3 MB): las cámaras de gama media producen JPEG de
  /// 4-8 MB que el servidor rechazaría.
  static Future<String?> comprimirYGuardar(String rutaOrigen) async {
    try {
      final directorio = await _directorioEvidencias();
      final destino = p.join(directorio.path, '${_uuid.v4()}.jpg');

      var calidad = 85;
      File? resultado;

      while (calidad >= 40) {
        final comprimido = await FlutterImageCompress.compressAndGetFile(
          rutaOrigen,
          destino,
          quality: calidad,
          minWidth: 1280,
          minHeight: 720,
          format: CompressFormat.jpeg,
        );

        if (comprimido == null) break;

        final archivo = File(comprimido.path);
        if (await archivo.length() <= EnvConfig.maxBytesImagen) {
          resultado = archivo;
          break;
        }

        // No cupo: bajamos calidad y reintentamos sobre el mismo destino.
        await archivo.delete();
        calidad -= 15;
      }

      if (resultado == null) {
        AppLogger.w('No se pudo comprimir la imagen por debajo del límite');
        return null;
      }

      return resultado.path;
    } catch (e, s) {
      AppLogger.e('Error al comprimir imagen', e, s);
      return null;
    }
  }

  /// Sube un archivo local a Storage y devuelve su ruta remota.
  ///
  /// La ruta empieza con el uuid del sitio porque la política de Storage lee
  /// ese primer segmento para decidir quién puede leer el objeto. Cambiar el
  /// formato rompe el control de acceso.
  static Future<String?> subir({
    required String rutaLocal,
    required String bucket,
    required String sitioId,
  }) async {
    final archivo = File(rutaLocal);
    if (!await archivo.exists()) {
      AppLogger.w('La foto ya no existe en el dispositivo: $rutaLocal');
      return null;
    }

    final ahora = DateTime.now();
    final carpetaMes = '${ahora.year}-${ahora.month.toString().padLeft(2, '0')}';
    final rutaRemota = '$sitioId/$carpetaMes/${p.basename(rutaLocal)}';

    await SupabaseService.cliente.storage.from(bucket).upload(
          rutaRemota,
          archivo,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

    AppLogger.sync('Foto subida: $bucket/$rutaRemota');
    return rutaRemota;
  }

  /// Borra la copia local ya subida. Sin esto el almacenamiento del teléfono se
  /// llena: son cientos de fotos al mes entre selfies, identificaciones y
  /// evidencia de bitácora.
  static Future<void> borrarLocal(String? rutaLocal) async {
    if (rutaLocal == null || rutaLocal.isEmpty) return;
    try {
      final archivo = File(rutaLocal);
      if (await archivo.exists()) await archivo.delete();
    } catch (e) {
      AppLogger.w('No se pudo borrar la copia local: $e');
    }
  }

  static Future<Directory> _directorioEvidencias() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'evidencias'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
}
