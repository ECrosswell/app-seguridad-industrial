import 'package:flutter_test/flutter_test.dart';
import 'package:seguridad_industrial/data/models/sitio.dart';

/// Pruebas de la lógica de turno y geocerca.
///
/// Es lo único del cliente que hace cálculos con consecuencias: si
/// `fechaTurnoDe` se equivoca, los eventos de la madrugada se agrupan en el
/// turno equivocado y la bitácora del turno sale incompleta.
void main() {
  const fabrica = Sitio(
    id: 'sitio-1',
    nombre: 'Fábrica',
    lat: 19.4326077,
    lng: -99.133208,
    radioMetros: 150,
    horaInicioTurno: '08:00',
    husoHorarioOffsetH: -6,
  );

  group('fechaTurnoDe', () {
    test('un evento a media mañana pertenece al turno de ese día', () {
      // 10:00 local (16:00 UTC con offset -6) del 5 de agosto.
      final instante = DateTime.utc(2026, 8, 5, 16);
      expect(fabrica.fechaTurnoDe(instante), DateTime(2026, 8, 5));
    });

    test('un evento de madrugada pertenece al turno del día anterior', () {
      // 03:00 local del 6 de agosto = 09:00 UTC. El turno arrancó a las 08:00
      // del día 5, así que ese evento es del turno del 5.
      final instante = DateTime.utc(2026, 8, 6, 9);
      expect(fabrica.fechaTurnoDe(instante), DateTime(2026, 8, 5));
    });

    test('justo al arrancar el turno ya cuenta como el día nuevo', () {
      // 08:00 local del 6 de agosto = 14:00 UTC.
      final instante = DateTime.utc(2026, 8, 6, 14);
      expect(fabrica.fechaTurnoDe(instante), DateTime(2026, 8, 6));
    });

    test('un minuto antes del relevo sigue siendo el turno anterior', () {
      // 07:59 local del 6 de agosto = 13:59 UTC.
      final instante = DateTime.utc(2026, 8, 6, 13, 59);
      expect(fabrica.fechaTurnoDe(instante), DateTime(2026, 8, 5));
    });
  });

  group('inicioDelTurno', () {
    test('devuelve las 08:00 locales expresadas en UTC', () {
      final inicio = fabrica.inicioDelTurno(DateTime(2026, 8, 5));
      expect(inicio.toUtc(), DateTime.utc(2026, 8, 5, 14));
    });
  });

  group('geocerca', () {
    test('el mismo punto da distancia cero', () {
      expect(fabrica.distanciaA(19.4326077, -99.133208), closeTo(0, 0.5));
    });

    test('un punto dentro del radio se reconoce como dentro', () {
      // ~50 m al norte (1 grado de latitud ≈ 111 320 m).
      final cerca = 19.4326077 + (50 / 111320);
      expect(fabrica.estaDentro(cerca, -99.133208), isTrue);
    });

    test('un punto fuera del radio se reconoce como fuera', () {
      // ~500 m al norte: más del triple del radio de 150 m.
      final lejos = 19.4326077 + (500 / 111320);
      expect(fabrica.estaDentro(lejos, -99.133208), isFalse);
    });

    test('sin geocerca capturada no se puede calcular distancia', () {
      const sinCoordenadas = Sitio(id: 'x', nombre: 'Nueva planta');
      expect(sinCoordenadas.tieneGeocerca, isFalse);
      expect(sinCoordenadas.distanciaA(19.0, -99.0), isNull);
      expect(sinCoordenadas.estaDentro(19.0, -99.0), isFalse);
    });
  });
}
