import 'package:flutter_test/flutter_test.dart';
import 'package:seguridad_industrial/features/rondines/domain/validacion_rondin.dart';

void main() {
  const punto = ConfiguracionPuntoRondin(
    lat: 19.432608,
    lng: -99.133209,
    radioMetros: 35,
    bssidRequerido: '00:11:22:33:44:55',
    segundosMinimosDesdeAnterior: 60,
    segundosMaximosDesdeAnterior: 900,
  );

  test('evidencia fresca y de zona queda capturada con evidencia', () {
    final resultado = evaluarEvidenciaLocal(
      punto: punto,
      evidencia: const EvidenciaPuntoRondin(
        lat: 19.43261,
        lng: -99.13321,
        precisionM: 8,
        gpsAgeMs: 1200,
        bssid: '00:11:22:33:44:55',
        segundosDesdeAnterior: 180,
        secuenciaEsperada: 2,
        secuenciaReal: 2,
      ),
    );

    expect(resultado.estado, 'capturado_con_evidencia');
    expect(resultado.codigosRiesgo, isEmpty);
  });

  test('GPS simulado y viaje imposible quedan sospechosos', () {
    final resultado = evaluarEvidenciaLocal(
      punto: punto,
      evidencia: const EvidenciaPuntoRondin(
        lat: 19.43261,
        lng: -99.13321,
        precisionM: 5,
        gpsAgeMs: 500,
        ubicacionSimulada: true,
        bssid: '00:11:22:33:44:55',
        segundosDesdeAnterior: 5,
        secuenciaEsperada: 2,
        secuenciaReal: 2,
      ),
    );

    expect(resultado.estado, 'capturado_sospechoso');
    expect(resultado.codigosRiesgo, contains('ubicacion_simulada'));
    expect(resultado.codigosRiesgo, contains('traslado_demasiado_rapido'));
  });

  test('foto desde una ubicación ajena no queda validada localmente', () {
    final resultado = evaluarEvidenciaLocal(
      punto: punto,
      evidencia: const EvidenciaPuntoRondin(
        lat: 19.4400,
        lng: -99.1400,
        precisionM: 10,
        gpsAgeMs: 1000,
        bssid: '66:77:88:99:aa:bb',
        segundosDesdeAnterior: 120,
        secuenciaEsperada: 1,
        secuenciaReal: 1,
      ),
    );

    expect(resultado.estado, 'capturado_sospechoso');
    expect(resultado.codigosRiesgo, contains('fuera_del_punto'));
    expect(resultado.codigosRiesgo, contains('wifi_zona_no_coincide'));
  });

  test('cambio de reloj y orden quedan por revisar', () {
    final resultado = evaluarEvidenciaLocal(
      punto: punto,
      evidencia: const EvidenciaPuntoRondin(
        lat: 19.43261,
        lng: -99.13321,
        precisionM: 7,
        gpsAgeMs: 1000,
        bssid: '00:11:22:33:44:55',
        horaAutomatica: false,
        secuenciaEsperada: 3,
        secuenciaReal: 2,
        segundosDesdeAnterior: 120,
      ),
    );

    expect(resultado.estado, 'capturado_por_revisar');
    expect(resultado.codigosRiesgo, contains('hora_manual'));
    expect(resultado.codigosRiesgo, contains('orden_incorrecto'));
  });
}
