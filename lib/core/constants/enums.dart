/// Enums del dominio.
///
/// Cada uno refleja un CHECK o un tipo enum de Postgres. El valor de [valor] es
/// **exactamente** el string que viaja a la base — si se cambia aquí sin cambiar
/// la migración correspondiente, el INSERT truena contra el CHECK.
library;

/// Roles del sistema. Espeja el tipo `public.rol_usuario`.
enum RolUsuario {
  /// Guardia en caseta. Registra asistencia, visitantes, bitácora y recibe turno.
  elemento('elemento', 'Elemento'),

  /// Supervisa el servicio. Registra sus visitas de supervisión con evidencia.
  supervisor('supervisor', 'Supervisor'),

  /// Empresa de seguridad. Da de alta/baja elementos y recibe todas las alertas.
  admin('admin', 'Administrador'),

  /// La fábrica. Varios usuarios, todos ven todo. Sólo lectura + solicitudes.
  cliente('cliente', 'Cliente');

  const RolUsuario(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static RolUsuario desdeValor(String? v) => RolUsuario.values.firstWhere(
        (r) => r.valor == v,
        orElse: () => RolUsuario.elemento,
      );

  /// Roles que operan desde la app Android. El resto usa la consola web.
  bool get esOperativo => this == elemento || this == supervisor;
}

/// Estado laboral del elemento. El admin lo controla.
enum EstadoLaboral {
  activo('activo', 'Activo'),
  baja('baja', 'Baja'),
  reingreso('reingreso', 'Reingreso');

  const EstadoLaboral(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static EstadoLaboral desdeValor(String? v) => EstadoLaboral.values.firstWhere(
        (e) => e.valor == v,
        orElse: () => EstadoLaboral.activo,
      );
}

/// Tipo de evento de asistencia.
enum TipoEventoAsistencia {
  entrada('entrada', 'Entrada'),
  salida('salida', 'Salida'),
  inicioDescanso('inicio_descanso', 'Inicio de descanso'),
  finDescanso('fin_descanso', 'Fin de descanso'),

  /// Visita del supervisor al servicio. Misma evidencia (geo + selfie).
  supervision('supervision', 'Supervisión');

  const TipoEventoAsistencia(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static TipoEventoAsistencia desdeValor(String? v) =>
      TipoEventoAsistencia.values.firstWhere(
        (e) => e.valor == v,
        orElse: () => TipoEventoAsistencia.entrada,
      );
}

/// Cómo se comprobó que el elemento estaba físicamente en el sitio.
enum MetodoValidacion {
  gps('gps', 'GPS'),
  wifi('wifi', 'WiFi de planta'),
  gpsYWifi('gps_y_wifi', 'GPS + WiFi'),
  manualAdmin('manual_admin', 'Registro manual'),
  sinValidar('sin_validar', 'Sin validar');

  const MetodoValidacion(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static MetodoValidacion desdeValor(String? v) =>
      MetodoValidacion.values.firstWhere(
        (m) => m.valor == v,
        orElse: () => MetodoValidacion.sinValidar,
      );
}

enum EstadoValidacion {
  validado('validado', 'Validado'),
  pendienteRevision('pendiente_revision', 'Pendiente de revisión'),
  rechazado('rechazado', 'Rechazado');

  const EstadoValidacion(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static EstadoValidacion desdeValor(String? v) =>
      EstadoValidacion.values.firstWhere(
        (e) => e.valor == v,
        orElse: () => EstadoValidacion.validado,
      );
}

/// Puntualidad de la entrada. La calcula el servidor, nunca el cliente.
enum ClasificacionAsistencia {
  aTiempo('a_tiempo', 'A tiempo'),
  retardo('retardo', 'Retardo'),
  falta('falta', 'Falta'),
  na('na', '—');

  const ClasificacionAsistencia(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static ClasificacionAsistencia desdeValor(String? v) =>
      ClasificacionAsistencia.values.firstWhere(
        (c) => c.valor == v,
        orElse: () => ClasificacionAsistencia.na,
      );
}

enum EstadoTurno {
  enCurso('en_curso', 'En curso'),
  cerrado('cerrado', 'Cerrado'),
  cerradoPorAdmin('cerrado_por_admin', 'Cerrado por administrador'),
  anomalia('anomalia', 'Anomalía');

  const EstadoTurno(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static EstadoTurno desdeValor(String? v) => EstadoTurno.values.firstWhere(
        (e) => e.valor == v,
        orElse: () => EstadoTurno.enCurso,
      );
}

/// Tipos de evento de bitácora.
///
/// [requierePlacas] marca los movimientos de mercancía, donde la base exige
/// placas + destino + autorización vía CHECK. La UI debe pedirlos como
/// obligatorios para que el INSERT no falle hasta después de capturar todo.
enum TipoEventoBitacora {
  salidaMercancia('salida_mercancia', 'Salida de mercancía', true),
  ingresoMateriaPrima('ingreso_materia_prima', 'Ingreso de materia prima', true),
  entradaVehiculo('entrada_vehiculo', 'Entrada de vehículo', false),
  salidaVehiculo('salida_vehiculo', 'Salida de vehículo', false),
  fallaInfraestructura('falla_infraestructura', 'Falla de infraestructura', false),
  incidenteSeguridad('incidente_seguridad', 'Incidente de seguridad', false),
  ronda('ronda', 'Ronda / recorrido', false),
  correspondencia('correspondencia', 'Correspondencia', false),
  libre('libre', 'Evento libre', false);

  const TipoEventoBitacora(this.valor, this.etiqueta, this.requierePlacas);

  final String valor;
  final String etiqueta;

  /// Movimiento de mercancía: placas, destino y autorización obligatorios.
  final bool requierePlacas;

  static TipoEventoBitacora desdeValor(String? v) =>
      TipoEventoBitacora.values.firstWhere(
        (t) => t.valor == v,
        orElse: () => TipoEventoBitacora.libre,
      );

  /// Estos arrastran seguimiento: no se deben perder al cambiar de turno.
  bool get abrePendiente =>
      this == fallaInfraestructura || this == incidenteSeguridad;
}

/// Estado de una partida de equipo al recibir el turno.
enum EstadoEquipo {
  perfecto('perfecto', 'Perfectas condiciones'),

  /// Nótese `danado` sin eñe: es el valor literal del CHECK en Postgres.
  /// Evita problemas de codificación en el identificador; la eñe vive en la
  /// etiqueta, que es lo que ve el usuario.
  usado('usado', 'Usado'),
  danado('danado', 'Dañado'),
  falta('falta', 'Falta');

  const EstadoEquipo(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static EstadoEquipo desdeValor(String? v) => EstadoEquipo.values.firstWhere(
        (e) => e.valor == v,
        orElse: () => EstadoEquipo.perfecto,
      );

  /// Cualquier cosa que no sea "perfecto" dispara la alerta al administrador.
  bool get esNovedad => this != perfecto;
}

enum CategoriaEquipo {
  armamentoNoLetal('armamento_no_letal', 'Armamento no letal'),
  accesorio('accesorio', 'Accesorio'),
  consumible('consumible', 'Consumible'),
  comunicacion('comunicacion', 'Comunicación'),
  proteccion('proteccion', 'Protección'),
  general('general', 'General');

  const CategoriaEquipo(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static CategoriaEquipo desdeValor(String? v) =>
      CategoriaEquipo.values.firstWhere(
        (c) => c.valor == v,
        orElse: () => CategoriaEquipo.general,
      );
}

enum Prioridad {
  normal('normal', 'Normal'),
  alta('alta', 'Alta'),
  critica('critica', 'Crítica');

  const Prioridad(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static Prioridad desdeValor(String? v) => Prioridad.values.firstWhere(
        (p) => p.valor == v,
        orElse: () => Prioridad.normal,
      );
}

/// Tipos de notificación. Espeja el CHECK de `public.notificaciones.tipo`.
enum TipoNotificacion {
  armamentoNovedad('armamento_novedad', 'Novedad en equipo'),
  relevoNoLlego('relevo_no_llego', 'Relevo no llegó'),
  doblete('doblete', 'Doblete'),
  salidaNoRegistrada('salida_no_registrada', 'Salida sin registrar'),
  asistenciaRevision('asistencia_revision', 'Asistencia por revisar'),
  solicitudCliente('solicitud_cliente', 'Solicitud del cliente'),
  solicitudRespondida('solicitud_respondida', 'Solicitud atendida'),
  incidenteCritico('incidente_critico', 'Incidente crítico'),
  avisoGeneral('aviso_general', 'Aviso');

  const TipoNotificacion(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static TipoNotificacion desdeValor(String? v) =>
      TipoNotificacion.values.firstWhere(
        (t) => t.valor == v,
        orElse: () => TipoNotificacion.avisoGeneral,
      );
}

enum EstadoSolicitud {
  abierta('abierta', 'Abierta'),
  enProceso('en_proceso', 'En proceso'),
  resuelta('resuelta', 'Resuelta'),
  cerrada('cerrada', 'Cerrada');

  const EstadoSolicitud(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static EstadoSolicitud desdeValor(String? v) =>
      EstadoSolicitud.values.firstWhere(
        (e) => e.valor == v,
        orElse: () => EstadoSolicitud.abierta,
      );
}

enum TipoIdentificacion {
  ninguna('', 'Sin identificación'),
  ine('ine', 'INE / IFE'),
  licencia('licencia', 'Licencia de conducir'),
  pasaporte('pasaporte', 'Pasaporte'),
  gafeteEmpresa('gafete_empresa', 'Gafete de empresa'),
  otro('otro', 'Otro');

  const TipoIdentificacion(this.valor, this.etiqueta);

  final String valor;
  final String etiqueta;

  static TipoIdentificacion desdeValor(String? v) =>
      TipoIdentificacion.values.firstWhere(
        (t) => t.valor == v,
        orElse: () => TipoIdentificacion.ninguna,
      );
}

/// Estado de sincronización de una fila local (Drift). **Sólo vive en el
/// dispositivo** — no viaja a Supabase.
enum EstadoSync {
  pendiente('pendiente'),
  sincronizando('sincronizando'),
  sincronizado('sincronizado'),
  fallido('fallido');

  const EstadoSync(this.valor);

  final String valor;

  static EstadoSync desdeValor(String? v) => EstadoSync.values.firstWhere(
        (e) => e.valor == v,
        orElse: () => EstadoSync.pendiente,
      );
}
