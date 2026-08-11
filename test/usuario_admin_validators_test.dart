import 'package:flutter_test/flutter_test.dart';
import 'package:seguridad_industrial/features/panel/domain/usuario_admin_validators.dart';

void main() {
  group('UsuarioAdminValidators', () {
    test('valida nombre y correo', () {
      expect(UsuarioAdminValidators.nombre('Erika Cruz'), isNull);
      expect(UsuarioAdminValidators.nombre('E'), isNotNull);
      expect(UsuarioAdminValidators.correo('erika@example.com'), isNull);
      expect(UsuarioAdminValidators.correo('correo-invalido'), isNotNull);
    });

    test('normaliza y valida WhatsApp', () {
      expect(
        UsuarioAdminValidators.normalizarTelefono('+52 (55) 1234-5678'),
        '525512345678',
      );
      expect(UsuarioAdminValidators.telefono(''), isNull);
      expect(UsuarioAdminValidators.telefono('5512345678'), isNull);
      expect(UsuarioAdminValidators.telefono('123'), isNotNull);
    });

    test('la contraseña temporal exige ocho caracteres y un número', () {
      expect(UsuarioAdminValidators.passwordTemporal('corta1'), isNotNull);
      expect(UsuarioAdminValidators.passwordTemporal('sinNumeros'), isNotNull);
      expect(UsuarioAdminValidators.passwordTemporal('Temporal9'), isNull);
    });

    test('la confirmación debe coincidir', () {
      expect(
        UsuarioAdminValidators.confirmacion('Temporal9', 'Temporal9'),
        isNull,
      );
      expect(
        UsuarioAdminValidators.confirmacion('OtraClave9', 'Temporal9'),
        isNotNull,
      );
    });
  });
}
