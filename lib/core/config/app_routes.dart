/// Nombres y rutas de navegación.
///
/// Constantes y no literales sueltos: un typo en una cadena de ruta no lo
/// detecta el compilador y se manifiesta como una pantalla en blanco.
class Rutas {
  const Rutas._();

  // Comunes
  static const login = '/login';
  static const cambiarPassword = '/cambiar-password';
  static const perfil = '/perfil';
  static const notificaciones = '/notificaciones';

  // Elemento y supervisor (Android)
  static const inicio = '/inicio';
  static const asistencia = '/asistencia';
  static const asistenciaCamara = '/asistencia/camara';
  static const recepcionTurno = '/recepcion-turno';
  static const accesos = '/accesos';
  static const accesoNuevo = '/accesos/nuevo';
  static const accesosDentro = '/accesos/dentro';
  static const bitacora = '/bitacora';
  static const bitacoraNueva = '/bitacora/nueva';
  static const supervision = '/supervision';

  // Consola web
  static const panel = '/panel';
  static const panelPersonal = '/panel/personal';
  static const panelAsistencias = '/panel/asistencias';
  static const panelVisitantes = '/panel/visitantes';
  static const panelBitacora = '/panel/bitacora';
  static const panelEquipo = '/panel/equipo';
  static const panelSolicitudes = '/panel/solicitudes';
  static const panelReportes = '/panel/reportes';
  static const panelSitios = '/panel/sitios';
  static const panelUsuarios = '/panel/usuarios';
}
