# Graph Report - App Seguridad Industrial  (2026-08-11)

## Corpus Check
- 123 files · ~152,741 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2333 nodes · 3385 edges · 99 communities (93 shown, 6 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `0ad7d4c8`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 48|Community 48]]
- [[_COMMUNITY_Community 49|Community 49]]
- [[_COMMUNITY_Community 50|Community 50]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 53|Community 53]]
- [[_COMMUNITY_Community 54|Community 54]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 57|Community 57]]
- [[_COMMUNITY_Community 58|Community 58]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 62|Community 62]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 65|Community 65]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 68|Community 68]]
- [[_COMMUNITY_Community 69|Community 69]]
- [[_COMMUNITY_Community 70|Community 70]]
- [[_COMMUNITY_Community 71|Community 71]]
- [[_COMMUNITY_Community 72|Community 72]]
- [[_COMMUNITY_Community 73|Community 73]]
- [[_COMMUNITY_Community 77|Community 77]]
- [[_COMMUNITY_Community 78|Community 78]]
- [[_COMMUNITY_Community 79|Community 79]]
- [[_COMMUNITY_Community 80|Community 80]]
- [[_COMMUNITY_Community 81|Community 81]]
- [[_COMMUNITY_Community 82|Community 82]]
- [[_COMMUNITY_Community 83|Community 83]]
- [[_COMMUNITY_Community 84|Community 84]]
- [[_COMMUNITY_Community 85|Community 85]]
- [[_COMMUNITY_Community 86|Community 86]]
- [[_COMMUNITY_Community 87|Community 87]]
- [[_COMMUNITY_Community 88|Community 88]]
- [[_COMMUNITY_Community 89|Community 89]]
- [[_COMMUNITY_Community 90|Community 90]]
- [[_COMMUNITY_Community 91|Community 91]]
- [[_COMMUNITY_Community 92|Community 92]]
- [[_COMMUNITY_Community 93|Community 93]]
- [[_COMMUNITY_Community 94|Community 94]]
- [[_COMMUNITY_Community 95|Community 95]]
- [[_COMMUNITY_Community 96|Community 96]]
- [[_COMMUNITY_Community 97|Community 97]]
- [[_COMMUNITY_Community 98|Community 98]]

## God Nodes (most connected - your core abstractions)
1. `_` - 384 edges
2. `_` - 32 edges
3. `_` - 32 edges
4. `perfilActualProvider` - 26 edges
5. `_` - 22 edges
6. `DataClass` - 20 edges
7. `_` - 20 edges
8. `syncEngineProvider` - 19 edges
9. `_` - 18 edges
10. `panelRepositoryProvider` - 16 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `syncEngineProvider`  [EXTRACTED]
  lib/main.dart → lib/core/providers/app_providers.dart
- `_detectar` --references--> `syncEngineProvider`  [EXTRACTED]
  lib/features/rondines/presentation/escanear_punto_screen.dart → lib/core/providers/app_providers.dart
- `_AccesosRepositoryPrueba` --inherits--> `AccesosRepository`  [EXTRACTED]
  test/video_regression_screens_test.dart → lib/features/accesos/data/accesos_repository.dart
- `initState` --references--> `perfilActualProvider`  [EXTRACTED]
  lib/features/perfil/presentation/perfil_screen.dart → lib/features/auth/providers/auth_provider.dart
- `_BitacoraRepositoryPrueba` --inherits--> `BitacoraRepository`  [EXTRACTED]
  test/video_regression_screens_test.dart → lib/features/bitacora/data/bitacora_repository.dart

## Import Cycles
- None detected.

## Communities (99 total, 6 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.01
Nodes (334): class LocalAvisosPrivacidadData extends, class LocalBitacoraEvento extends, class LocalBitacoraFoto extends, class LocalCatalogoEquipoData extends, class LocalPersonalClienteData extends, class LocalPuntosRondinData extends, class LocalRecepcionesTurnoData extends, class LocalRecepcionItem extends (+326 more)

### Community 1 - "Community 1"
Cohesion: 0.01
Nodes (164): BoolColumn get, DateTimeColumn get, IntColumn get, aceptaConformidad, aceptadoAt, activo, adbActivo, area (+156 more)

### Community 2 - "Community 2"
Cohesion: 0.03
Nodes (79): areaVisitada, asignarSitio, asistencias, asistenciasPorRevisar, asunto, bitacora, cambiarEstadoLaboral, catalogoEquipo (+71 more)

### Community 3 - "Community 3"
Cohesion: 0.08
Nodes (24): dart:math, double?, activo, _aDouble, _aRadianes, desdeJson, direccion, distanciaA (+16 more)

### Community 4 - "Community 4"
Cohesion: 0.09
Nodes (21): ChangeNotifier, _NotificadorAuth, dispose, notificador, _NotificadorAuthWeb, _quitar, _ref, ../constants/enums.dart (+13 more)

### Community 5 - "Community 5"
Cohesion: 0.05
Nodes (41): FutureProvider, _Campo, campos, _cargar, clave, _Contador, _controles, createState (+33 more)

### Community 6 - "Community 6"
Cohesion: 0.06
Nodes (37): PersonalEnSitio, VisitanteDentro, package:url_launcher/url_launcher.dart, accion, _BloqueAlertas, _Cargando, color, _Error (+29 more)

### Community 7 - "Community 7"
Cohesion: 0.05
Nodes (36): ../../core/services/connectivity_service.dart, ../remote/foto_service.dart, rondin_sync_payload.dart, _aDouble, _bajarCatalogoRondines, _bajarReferencias, _ciclando, _cortocircuitado (+28 more)

### Community 8 - "Community 8"
Cohesion: 0.05
Nodes (36): _asunto, aviso, _avisoAceptado, _CapturaIdentificacion, _color, createState, dispose, _empresa (+28 more)

### Community 9 - "Community 9"
Cohesion: 0.13
Nodes (15): _Aviso, _correo, createState, dispose, _Encabezado, _entrar, _error, _formKey (+7 more)

### Community 10 - "Community 10"
Cohesion: 0.07
Nodes (29): CameraController?, Color get, FaceDetector?, package:camera/camera.dart, package:google_mlkit_face_detection/google_mlkit_face_detection.dart, _actualizar, _aInputImage, aprobada (+21 more)

### Community 11 - "Community 11"
Cohesion: 0.09
Nodes (41): Insertable, DataClass, LocalAsistencia, LocalAsistenciasCompanion, LocalAvisosPrivacidadCompanion, LocalAvisosPrivacidadData, LocalBitacoraEvento, LocalBitacoraEventosCompanion (+33 more)

### Community 12 - "Community 12"
Cohesion: 0.07
Nodes (26): Arquitectura de la app, Base de datos, Comandos, Convenciones del esquema, Crear usuarios a mano — trampa conocida, Cuenta inicial, Cómo viaja un push, Decisiones tomadas (no volver a litigar) (+18 more)

### Community 13 - "Community 13"
Cohesion: 0.06
Nodes (31): ../../bitacora/providers/bitacora_provider.dart, bool?, ../data/recepcion_repository.dart, _aceptaConformidad, activo, _BotonConformidad, color, _Conformidad (+23 more)

### Community 14 - "Community 14"
Cohesion: 0.09
Nodes (21): dart:typed_data, _compartir, csvAsistencias, csvBitacora, csvVisitantes, _descargarCsv, _encabezado, _fechaCorta (+13 more)

### Community 15 - "Community 15"
Cohesion: 0.07
Nodes (30): _, accesoNuevo, accesos, accesosDentro, asistencia, asistenciaCamara, bitacora, bitacoraNueva (+22 more)

### Community 16 - "Community 16"
Cohesion: 0.05
Nodes (43): ../../../data/sync/sync_engine.dart, _BotonPrincipal, color, _confirmar, createState, detalle, _Etiqueta, evento (+35 more)

### Community 17 - "Community 17"
Cohesion: 0.09
Nodes (21): package:image_picker/image_picker.dart, _agregarFoto, _autorizadoPorId, _autorizadoTexto, createState, _descripcion, _destino, dispose (+13 more)

### Community 18 - "Community 18"
Cohesion: 0.07
Nodes (29): ../domain/usuario_admin_validators.dart, _AvisoPasswordTemporal, build, _confirmar, _correo, createState, _DialogoAltaUsuario, _DialogoAltaUsuarioState (+21 more)

### Community 19 - "Community 19"
Cohesion: 0.10
Nodes (20): EstadoLaboral, activo, aJson, copiarCon, correo, debeCambiarPassword, desdeJson, estadoLaboral (+12 more)

### Community 20 - "Community 20"
Cohesion: 0.10
Nodes (20): bool get, abrePendiente, CategoriaEquipo, ClasificacionAsistencia, desdeValor, esNovedad, esOperativo, EstadoEquipo (+12 more)

### Community 21 - "Community 21"
Cohesion: 0.12
Nodes (19): ../data/perfil_local_cache.dart, actualizarWhatsapp, AuthAutenticado, AuthCargando, AuthController, AuthSinSesion, build, cambiarPassword (+11 more)

### Community 22 - "Community 22"
Cohesion: 0.14
Nodes (13): ../data/reportes_service.dart, int?, clave, createState, detalle, _generando, _generar, icono (+5 more)

### Community 23 - "Community 23"
Cohesion: 0.12
Nodes (16): @pragma, device_service.dart, notificaciones_service.dart, package:firebase_core/firebase_core.dart, package:firebase_messaging/firebase_messaging.dart, darDeBajaDispositivo, _guardarToken, _inicializado (+8 more)

### Community 24 - "Community 24"
Cohesion: 0.07
Nodes (32): _, bucketEvidencias, bucketIdentificaciones, ../config/env_config.dart, EnvConfig, estaConfigurado, maxBytesImagen, supabaseAnonKey (+24 more)

### Community 25 - "Community 25"
Cohesion: 0.17
Nodes (11): _Dato, dentro, _ErrorCarga, icono, onReintentar, onSalida, registro, _TarjetaVisitante (+3 more)

### Community 26 - "Community 26"
Cohesion: 0.13
Nodes (14): _Chip, _ErrorCarga, evento, icono, mostrarResolver, onReintentar, onResolver, provider (+6 more)

### Community 27 - "Community 27"
Cohesion: 0.12
Nodes (16): cantidadEncontrada, catalogoDelSitio, copiarCon, _db, elementosDisponibles, equipoId, estado, fotoRutaLocal (+8 more)

### Community 28 - "Community 28"
Cohesion: 0.12
Nodes (15): TipoNotificacion, creadaAt, cuerpo, desdeJson, entidadId, entidadTipo, id, leida (+7 more)

### Community 29 - "Community 29"
Cohesion: 0.10
Nodes (19): app_routes.dart, dispose, notificador, _quitar, _ref, ../../features/accesos/presentation/acceso_form_screen.dart, ../../features/accesos/presentation/accesos_screen.dart, ../../features/asistencia/presentation/asistencia_screen.dart (+11 more)

### Community 30 - "Community 30"
Cohesion: 0.14
Nodes (21): LocalAsistencias, LocalAvisosPrivacidad, LocalBitacoraEventos, LocalBitacoraFotos, LocalCatalogoEquipo, LocalPersonalCliente, LocalProfiles, LocalPuntosRondin (+13 more)

### Community 31 - "Community 31"
Cohesion: 0.12
Nodes (15): package:flutter_local_notifications/flutter_local_notifications.dart, RealtimeChannel?, _canal, _canalAlertas, dejarDeEscuchar, escuchar, _inicializado, inicializar (+7 more)

### Community 32 - "Community 32"
Cohesion: 0.15
Nodes (14): ../data/panel_repository.dart, PanelRepository, build, PanelEquipoScreen, asistenciasPanelProvider, build, estadoEquipoProvider, periodic (+6 more)

### Community 33 - "Community 33"
Cohesion: 0.18
Nodes (20): _AccesoFormScreenState, _guardar, _darSalida, _PestanaDentro, build, _guardar, build, InicioScreen (+12 more)

### Community 34 - "Community 34"
Cohesion: 0.07
Nodes (29): ../../auth/providers/auth_provider.dart, ../../../core/config/app_routes.dart, ../../notificaciones/providers/notificaciones_provider.dart, package:go_router/go_router.dart, _Accion, _AccionesDeTurno, _AvisoSinTurno, detalle (+21 more)

### Community 35 - "Community 35"
Cohesion: 0.06
Nodes (43): class, TipoEventoBitacora, core/theme/app_theme.dart, map, Map, package:flutter/material.dart, package:intl/intl.dart, createState (+35 more)

### Community 36 - "Community 36"
Cohesion: 0.17
Nodes (11): ../../accesos/providers/accesos_provider.dart, ../data/bitacora_repository.dart, bitacoraDelTurnoProvider, bitacoraRepositoryProvider, fecha, historialBitacoraProvider, sitio, sitioId (+3 more)

### Community 37 - "Community 37"
Cohesion: 0.17
Nodes (12): core/providers/app_providers.dart, ../data/accesos_repository.dart, ../../../data/local/app_database.dart, AccesosScreen, build, _PestanaHistorial, historialAccesosProvider, sitioId (+4 more)

### Community 38 - "Community 38"
Cohesion: 0.09
Nodes (24): _double, package:geolocator/geolocator.dart, package:network_info_plus/network_info_plus.dart, package:permission_handler/permission_handler.dart, _, bssid, errorUbicacion, errorWifi (+16 more)

### Community 39 - "Community 39"
Cohesion: 0.03
Nodes (66): activo, actorId, actorNombre, bssid, capturadoAt, CodigoQrPuntoRondin, codigosRiesgo, conContextoDe (+58 more)

### Community 40 - "Community 40"
Cohesion: 0.04
Nodes (54): LecturaResultadoRondin, ResultadoRondin, _abreviarId, _administrarSecciones, build, codigo, color, _colorEstado (+46 more)

### Community 41 - "Community 41"
Cohesion: 0.15
Nodes (14): LogFilter, package:flutter/foundation.dart, package:logger/logger.dart, _, AppLogger, d, e, _FiltroPorEntorno (+6 more)

### Community 42 - "Community 42"
Cohesion: 0.33
Nodes (5): config, flutterOutput, projectRoot, staticOutput, vercelOutput

### Community 43 - "Community 43"
Cohesion: 0.15
Nodes (12): app_logger.dart, dart:async, package:connectivity_plus/connectivity_plus.dart, cambios, _connectivity, ConnectivityService, _hayInterfaz, hayInterfazDeRed (+4 more)

### Community 44 - "Community 44"
Cohesion: 0.17
Nodes (13): ../../core/config/env_config.dart, dart:io, package:flutter_image_compress/flutter_image_compress.dart, package:path/path.dart, package:path_provider/path_provider.dart, package:supabase_flutter/supabase_flutter.dart, _, borrarLocal (+5 more)

### Community 45 - "Community 45"
Cohesion: 0.15
Nodes (12): package:device_info_plus/device_info_plus.dart, package:flutter_secure_storage/flutter_secure_storage.dart, package:uuid/uuid.dart, _almacen, _claveDeviceId, deviceId, _deviceIdCache, DeviceService (+4 more)

### Community 46 - "Community 46"
Cohesion: 0.17
Nodes (13): static const, _, ambarSeguridad, AppTheme, azulAcero, azulProfundo, _base, colorClasificacion (+5 more)

### Community 47 - "Community 47"
Cohesion: 0.18
Nodes (12): RolUsuario, ../../../data/models/perfil.dart, panel_usuario_dialogs.dart, build, createState, _filtroRol, _incluirBajas, PanelUsuariosScreen (+4 more)

### Community 48 - "Community 48"
Cohesion: 0.05
Nodes (40): dart:convert, configuracion, _db, evaluacion, iniciar, lectura, mensaje, observarLecturas (+32 more)

### Community 49 - "Community 49"
Cohesion: 0.15
Nodes (12): _abrirTurnoLocal, _cerrarTurnoLocal, _db, estaEnDescanso, observarEventosDelTurno, observarTurnoAbierto, registrarEvento, sitioPorId (+4 more)

### Community 50 - "Community 50"
Cohesion: 0.20
Nodes (12): build, build, _Turnos, build, PanelReportesScreen, _PanelReportesScreenState, bitacoraPanelProvider, rangoFiltroProvider (+4 more)

### Community 51 - "Community 51"
Cohesion: 0.19
Nodes (14): ConsumerWidget, _SelectorSitio, _TarjetaRevision, _TarjetaTurno, _gestionarEquipo, _guardar, build, PanelSolicitudesScreen (+6 more)

### Community 52 - "Community 52"
Cohesion: 0.10
Nodes (20): AsyncValue, ../../../data/models/notificacion.dart, Notificacion, package:flutter_riverpod/flutter_riverpod.dart, build, _icono, notificacion, NotificacionesScreen (+12 more)

### Community 53 - "Community 53"
Cohesion: 0.15
Nodes (12): routerProvider, core/config/app_router.dart, core/services/app_logger.dart, core/services/notificaciones_service.dart, core/services/push_service.dart, features/auth/providers/auth_provider.dart, build, createState (+4 more)

### Community 54 - "Community 54"
Cohesion: 0.20
Nodes (9): ../../../core/constants/enums.dart, _db, observarDelTurno, observarFotos, observarHistorial, observarPendientes, registrarEvento, resolver (+1 more)

### Community 55 - "Community 55"
Cohesion: 0.18
Nodes (10): ../../../core/services/device_service.dart, avisoVigente, buscarVisitantes, _db, guardarVisitanteFrecuente, observarDentro, observarHistorial, personalDelSitio (+2 more)

### Community 56 - "Community 56"
Cohesion: 0.26
Nodes (10): corsHeaders, SupabaseAdmin, errorPasswordTemporal(), fallo(), normalizarTelefono(), ROLES_ADMINISTRABLES, texto(), validarAltaUsuario() (+2 more)

### Community 57 - "Community 57"
Cohesion: 0.13
Nodes (25): ConsumerState, ConsumerStatefulWidget, AppSeguridadIndustrial, _AppSeguridadIndustrialState, AccesoFormScreen, build, _BuscadorFrecuentes, _BuscadorFrecuentesState (+17 more)

### Community 58 - "Community 58"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 59 - "Community 59"
Cohesion: 0.13
Nodes (15): FormState, ../../panel/domain/usuario_admin_validators.dart, build, CambiarPasswordScreen, _CambiarPasswordScreenState, _confirmar, createState, destinoAlGuardar (+7 more)

### Community 60 - "Community 60"
Cohesion: 0.20
Nodes (9): Color, IconData, build, color, etiqueta, icono, onTap, TarjetaMetrica (+1 more)

### Community 61 - "Community 61"
Cohesion: 0.19
Nodes (13): build, PanelInicioScreen, PanelPersonalScreen, _PorRevisar, build, PanelVisitantesScreen, _PanelVisitantesScreenState, accesosPanelProvider (+5 more)

### Community 62 - "Community 62"
Cohesion: 0.15
Nodes (16): AsistenciaRepository, ../data/asistencia_repository.dart, AsistenciaScreen, _AsistenciaScreenState, _BotonesDescanso, _LineaDeTiempo, asistenciaRepositoryProvider, build (+8 more)

### Community 63 - "Community 63"
Cohesion: 0.17
Nodes (17): build, _SelectorSitio, PanelSitiosScreen, _nueva, _asignarSitio, _darDeAlta, build, _DialogoAdministrarSecciones (+9 more)

### Community 64 - "Community 64"
Cohesion: 0.36
Nodes (6): base64url(), CuentaServicio, importarLlave(), json(), obtenerAccessToken(), ResultadoEnvio

### Community 65 - "Community 65"
Cohesion: 0.20
Nodes (9): buildCommand, framework, git, deploymentEnabled, headers, installCommand, outputDirectory, rewrites (+1 more)

### Community 66 - "Community 66"
Cohesion: 0.05
Nodes (38): RespuestaPuntoRondin, SeccionRondin, _activo, bssid, _crearSeccion, createState, _descripcion, _DialogoSeccion (+30 more)

### Community 67 - "Community 67"
Cohesion: 0.40
Nodes (6): RangoFechas, Notifier, SitioSeleccionado, RangoFiltro, SitioFiltro, String?

### Community 68 - "Community 68"
Cohesion: 0.18
Nodes (8): package:flutter_test/flutter_test.dart, package:seguridad_industrial/features/panel/data/rondin_admin_models.dart, package:seguridad_industrial/features/panel/domain/usuario_admin_validators.dart, package:seguridad_industrial/features/rondines/domain/validacion_rondin.dart, main, main, main, punto

### Community 70 - "Community 70"
Cohesion: 0.17
Nodes (12): ../../auth/presentation/cambiar_password_screen.dart, MaterialPageRoute, build, createState, dispose, _guardando, _guardarWhatsapp, initState (+4 more)

### Community 71 - "Community 71"
Cohesion: 0.20
Nodes (10): routerWebProvider, core/config/app_router_web.dart, core/services/supabase_service.dart, build, ConsolaSeguridadIndustrial, inicializar, initializeDateFormatting, main (+2 more)

### Community 72 - "Community 72"
Cohesion: 0.40
Nodes (3): FlutterEngine, FlutterActivity, MainActivity

### Community 77 - "Community 77"
Cohesion: 0.25
Nodes (9): _, confirmacion, _correo, nombre, normalizarTelefono, passwordTemporal, telefono, UsuarioAdminValidators (+1 more)

### Community 78 - "Community 78"
Cohesion: 0.40
Nodes (5): _guardar, build, PanelShell, _confirmarSalir, authControllerProvider

### Community 79 - "Community 79"
Cohesion: 0.67
Nodes (3): _, AppDatabase, driftDatabase

### Community 80 - "Community 80"
Cohesion: 0.05
Nodes (36): a, adbActivo, bssid, bssidEsperado, bssidRequerido, codigosRiesgo, ConfiguracionPuntoRondin, distancia (+28 more)

### Community 81 - "Community 81"
Cohesion: 0.14
Nodes (24): corsHeaders, errorRpc(), json(), ACCIONES_ADMIN, booleano(), entero(), fallo(), fechaIso() (+16 more)

### Community 82 - "Community 82"
Cohesion: 0.50
Nodes (4): RondinAdminException, UsuarioAdminException, RondinException, Exception

### Community 83 - "Community 83"
Cohesion: 0.09
Nodes (28): ../../asistencia/providers/asistencia_provider.dart, ../data/rondines_repository.dart, RondinesRepository, List, _AvisoAntifraude, build, _HistorialTile, _iniciar (+20 more)

### Community 84 - "Community 84"
Cohesion: 0.08
Nodes (25): package:seguridad_industrial/core/config/app_routes.dart, package:seguridad_industrial/core/constants/enums.dart, package:seguridad_industrial/core/theme/app_theme.dart, package:seguridad_industrial/data/models/perfil.dart, package:seguridad_industrial/data/sync/sync_engine.dart, package:seguridad_industrial/features/accesos/data/accesos_repository.dart, package:seguridad_industrial/features/accesos/presentation/accesos_screen.dart, package:seguridad_industrial/features/asistencia/presentation/asistencia_screen.dart (+17 more)

### Community 85 - "Community 85"
Cohesion: 0.10
Nodes (20): ../data/rondin_admin_models.dart, PuntoRondin, package:pdf/pdf.dart, package:pdf/widgets.dart, package:printing/printing.dart, package:qr_flutter/qr_flutter.dart, build, codigoRotado (+12 more)

### Community 86 - "Community 86"
Cohesion: 0.12
Nodes (16): ../../asistencia/presentation/prueba_vida_screen.dart, ../../asistencia/services/presence_service.dart, ../../../data/remote/foto_service.dart, package:mobile_scanner/mobile_scanner.dart, build, _controller, createState, _detectar (+8 more)

### Community 87 - "Community 87"
Cohesion: 0.15
Nodes (14): _, _canal, cargar, _clave, guardadoAt, guardar, limpiar, perfil (+6 more)

### Community 88 - "Community 88"
Cohesion: 0.14
Nodes (13): package:seguridad_industrial/data/local/app_database.dart, package:seguridad_industrial/data/sync/rondin_sync_payload.dart, package:seguridad_industrial/features/asistencia/services/presence_service.dart, package:seguridad_industrial/features/rondines/data/rondines_repository.dart, package:seguridad_industrial/features/rondines/services/security_clock_service.dart, db, main, puntoId (+5 more)

### Community 89 - "Community 89"
Cohesion: 0.17
Nodes (11): package:drift/native.dart, package:seguridad_industrial/core/providers/app_providers.dart, package:seguridad_industrial/features/accesos/providers/accesos_provider.dart, package:seguridad_industrial/features/asistencia/providers/asistencia_provider.dart, package:seguridad_industrial/features/bitacora/providers/bitacora_provider.dart, ProviderContainer, container, db (+3 more)

### Community 90 - "Community 90"
Cohesion: 0.18
Nodes (12): package:flutter/services.dart, _, adbActivo, bootCount, _canal, elapsedRealtimeMs, _enteroNoNegativo, horaAutomatica (+4 more)

### Community 91 - "Community 91"
Cohesion: 0.33
Nodes (6): BitacoraScreen, build, _Lista, provider, pendientesBitacoraProvider, Rutas.bitacoraNueva

### Community 92 - "Community 92"
Cohesion: 0.40
Nodes (6): PruebaVidaScreen, _PruebaVidaScreenState, _DialogoQrPunto, _DialogoQrPuntoState, State, StatefulWidget

### Community 93 - "Community 93"
Cohesion: 0.50
Nodes (3): package:seguridad_industrial/data/models/sitio.dart, fabrica, main

### Community 94 - "Community 94"
Cohesion: 0.67
Nodes (4): build, _TarjetaSitio, catalogoEquipoPanelProvider, personalClientePanelProvider

## Knowledge Gaps
- **1548 isolated node(s):** `FlutterEngine`, `notificador`, `_ref`, `_quitar`, `dispose` (+1543 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_` connect `Community 0` to `Community 3`, `Community 35`, `Community 67`, `Community 38`, `Community 39`, `Community 11`, `Community 48`, `Community 83`, `Community 22`, `Community 87`?**
  _High betweenness centrality (0.254) - this node is a cross-community bridge._
- **Why does `AppDatabase` connect `Community 79` to `Community 1`, `Community 7`, `Community 48`, `Community 49`, `Community 16`, `Community 54`, `Community 55`, `Community 88`, `Community 89`, `Community 27`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Why does `_` connect `Community 24` to `Community 43`, `Community 44`?**
  _High betweenness centrality (0.031) - this node is a cross-community bridge._
- **What connects `FlutterEngine`, `notificador`, `_ref` to the rest of the system?**
  _1548 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.006006006006006006 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.012121212121212121 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.025 - nodes in this community are weakly interconnected._