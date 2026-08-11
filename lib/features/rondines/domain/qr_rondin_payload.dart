import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Contenido canónico de las placas de rondín.
///
/// Offline sólo se valida la estructura. La autenticidad del token no puede
/// probarse con datos públicos descargados en el teléfono: el servidor recibe
/// el payload RAW y lo compara con su secreto al sincronizar.
class QrRondinPayload {
  const QrRondinPayload({
    required this.puntoId,
    required this.version,
    required this.token,
    required this.raw,
  });

  static final _uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );
  static final _tokenSeguro = RegExp(r'^[A-Za-z0-9_-]{32,128}$');

  final String puntoId;
  final int version;
  final String token;
  final String raw;

  static QrRondinPayload? intentarParsear(String valor) {
    final raw = valor.trim();
    final partes = raw.split('.');
    if (partes.length != 4 || partes[0] != 'SIQR1') return null;

    final version = int.tryParse(partes[2]);
    if (!_uuid.hasMatch(partes[1]) ||
        version == null ||
        version < 1 ||
        !_tokenSeguro.hasMatch(partes[3])) {
      return null;
    }

    return QrRondinPayload(
      puntoId: partes[1].toLowerCase(),
      version: version,
      token: partes[3],
      raw: raw,
    );
  }

  String get sha256Hex => sha256.convert(utf8.encode(raw)).toString();
}
