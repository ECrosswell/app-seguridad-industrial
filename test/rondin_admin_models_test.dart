import 'package:flutter_test/flutter_test.dart';
import 'package:seguridad_industrial/features/panel/data/rondin_admin_models.dart';

void main() {
  test('elige la última revisión por created_at e id', () {
    final resultado = ResultadoRondin.desdeJson({
      'id': 'rondin-1',
      'usuario_id': 'usuario-1',
      'sitio_id': 'sitio-1',
      'estado_validacion': 'pendiente_revision',
      'iniciado_at_dispositivo': '2026-08-11T12:00:00Z',
      'rondin_lecturas': <Map<String, dynamic>>[],
      'rondin_revisiones': [
        {
          'id': 'revision-z-antigua',
          'rondin_id': 'rondin-1',
          'actor_id': 'admin-1',
          'decision': 'aprobado',
          'motivo': '',
          'created_at': '2026-08-11T12:30:00Z',
        },
        {
          'id': 'revision-a',
          'rondin_id': 'rondin-1',
          'actor_id': 'admin-1',
          'decision': 'aprobado',
          'motivo': '',
          'created_at': '2026-08-11T13:00:00Z',
        },
        {
          'id': 'revision-b',
          'rondin_id': 'rondin-1',
          'actor_id': 'admin-2',
          'decision': 'rechazado',
          'motivo': 'Secuencia imposible',
          'created_at': '2026-08-11T13:00:00Z',
          'profiles': {'nombre_completo': 'Administradora Dos'},
        },
      ],
    });

    expect(resultado.revisionAdministrativa, isNotNull);
    expect(resultado.revisionAdministrativa!.id, 'revision-b');
    expect(resultado.revisionAdministrativa!.decision, 'rechazado');
    expect(resultado.revisionAdministrativa!.motivo, 'Secuencia imposible');
    expect(resultado.revisionAdministrativa!.actorNombre, 'Administradora Dos');
  });

  test('mantiene separado un pendiente automático sin revisión', () {
    final resultado = ResultadoRondin.desdeJson({
      'id': 'rondin-2',
      'usuario_id': 'usuario-1',
      'sitio_id': 'sitio-1',
      'estado_validacion': 'pendiente_revision',
      'iniciado_at_dispositivo': '2026-08-11T12:00:00Z',
      'rondin_lecturas': <Map<String, dynamic>>[],
      'rondin_revisiones': <Map<String, dynamic>>[],
    });

    expect(resultado.estadoValidacion, 'pendiente_revision');
    expect(resultado.revisionAdministrativa, isNull);
  });
}
