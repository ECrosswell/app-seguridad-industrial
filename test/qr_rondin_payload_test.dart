import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seguridad_industrial/features/rondines/domain/qr_rondin_payload.dart';

void main() {
  const raw =
      'SIQR1.123e4567-e89b-42d3-a456-426614174000.3.'
      'abcdefghijklmnopqrstuvwxyzABCDEFGH';

  test('parsea y calcula la huella canónica del QR', () {
    final payload = QrRondinPayload.intentarParsear(raw);

    expect(payload, isNotNull);
    expect(payload!.puntoId, '123e4567-e89b-42d3-a456-426614174000');
    expect(payload.version, 3);
    expect(payload.sha256Hex, sha256.convert(utf8.encode(raw)).toString());
  });

  test('rechaza prefijo, UUID, versión o token alterados', () {
    expect(QrRondinPayload.intentarParsear('QR.$raw'), isNull);
    expect(
      QrRondinPayload.intentarParsear(
        'SIQR1.no-es-uuid.1.abcdefghijklmnopqrstuvwxyzABCDEFGH',
      ),
      isNull,
    );
    expect(
      QrRondinPayload.intentarParsear(
        'SIQR1.123e4567-e89b-42d3-a456-426614174000.0.token-corto',
      ),
      isNull,
    );
  });

  test('una mutación de un byte cambia la huella', () {
    final payload = QrRondinPayload.intentarParsear(raw)!;
    final mutado = raw.replaceFirst('ABCDEFGH', 'ABCDEFGI');
    final hashMutado = sha256.convert(utf8.encode(mutado)).toString();

    expect(payload.sha256Hex, isNot(hashMutado));
  });
}
