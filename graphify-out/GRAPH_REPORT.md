# Graph Report - App Seguridad Industrial  (2026-08-11)

## Corpus Check
- 97 files · ~110,086 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1723 nodes · 2495 edges · 83 communities (78 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `b49467e9`
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

## God Nodes (most connected - your core abstractions)
1. `_` - 295 edges
2. `_` - 28 edges
3. `_` - 26 edges
4. `_` - 22 edges
5. `perfilActualProvider` - 22 edges
6. `_` - 18 edges
7. `panelRepositoryProvider` - 16 edges
8. `_` - 15 edges
9. `syncEngineProvider` - 15 edges
10. `_` - 15 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `syncEngineProvider`  [EXTRACTED]
  lib/main.dart → lib/core/providers/app_providers.dart
- `initState` --references--> `perfilActualProvider`  [EXTRACTED]
  lib/features/perfil/presentation/perfil_screen.dart → lib/features/auth/providers/auth_provider.dart
- `_resolver` --references--> `bitacoraRepositoryProvider`  [EXTRACTED]
  lib/features/bitacora/presentation/bitacora_screen.dart → lib/features/bitacora/providers/bitacora_provider.dart
- `_AppSeguridadIndustrialState` --references--> `syncEngineProvider`  [EXTRACTED]
  lib/main.dart → lib/core/providers/app_providers.dart
- `_AsistenciaScreenState` --references--> `syncEngineProvider`  [EXTRACTED]
  lib/features/asistencia/presentation/asistencia_screen.dart → lib/core/providers/app_providers.dart

## Import Cycles
- None detected.

## Communities (83 total, 5 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.01
Nodes (256): class LocalAvisosPrivacidadData extends, class LocalBitacoraEvento extends, class LocalBitacoraFoto extends, class LocalCatalogoEquipoData extends, class LocalPersonalClienteData extends, class LocalRecepcionesTurnoData extends, class LocalRecepcionItem extends, class LocalRegistrosAccesoData extends (+248 more)

### Community 1 - "Community 1"
Cohesion: 0.02
Nodes (128): BoolColumn get, DateTimeColumn get, int get, IntColumn get, aceptaConformidad, aceptadoAt, activo, area (+120 more)

### Community 2 - "Community 2"
Cohesion: 0.03
Nodes (69): areaVisitada, asignarSitio, asistencias, asistenciasPorRevisar, asunto, bitacora, cambiarEstadoLaboral, catalogoEquipo (+61 more)

### Community 3 - "Community 3"
Cohesion: 0.08
Nodes (23): dart:math, activo, _aDouble, _aRadianes, desdeJson, direccion, distanciaA, estaDentro (+15 more)

### Community 4 - "Community 4"
Cohesion: 0.11
Nodes (17): app_routes.dart, dispose, notificador, _quitar, _ref, ../constants/enums.dart, ../../features/panel/presentation/panel_bitacora_screen.dart, ../../features/panel/presentation/panel_equipo_screen.dart (+9 more)

### Community 5 - "Community 5"
Cohesion: 0.05
Nodes (40): FutureProvider, _Campo, campos, _cargar, clave, _controles, createState, descripcion (+32 more)

### Community 6 - "Community 6"
Cohesion: 0.06
Nodes (38): PersonalEnSitio, VisitanteDentro, package:url_launcher/url_launcher.dart, _CapturaIdentificacion, _Seccion, _SinSitio, _BotonPrincipal, _Etiqueta (+30 more)

### Community 7 - "Community 7"
Cohesion: 0.06
Nodes (34): ../../core/services/connectivity_service.dart, ../local/app_database.dart, ../remote/foto_service.dart, _aDouble, _bajarReferencias, _ciclando, _cortocircuitado, _db (+26 more)

### Community 8 - "Community 8"
Cohesion: 0.06
Nodes (33): _asunto, aviso, _avisoAceptado, _color, createState, dispose, _empresa, _formKey (+25 more)

### Community 9 - "Community 9"
Cohesion: 0.13
Nodes (15): _Aviso, _correo, createState, dispose, _Encabezado, _entrar, _error, _formKey (+7 more)

### Community 10 - "Community 10"
Cohesion: 0.06
Nodes (35): CameraController?, Color get, ../../../data/remote/foto_service.dart, FaceDetector?, package:camera/camera.dart, package:google_mlkit_face_detection/google_mlkit_face_detection.dart, _actualizar, _aInputImage (+27 more)

### Community 11 - "Community 11"
Cohesion: 0.12
Nodes (31): Insertable, DataClass, LocalAsistencia, LocalAsistenciasCompanion, LocalAvisosPrivacidadCompanion, LocalAvisosPrivacidadData, LocalBitacoraEvento, LocalBitacoraEventosCompanion (+23 more)

### Community 12 - "Community 12"
Cohesion: 0.07
Nodes (26): Arquitectura de la app, Base de datos, Comandos, Convenciones del esquema, Crear usuarios a mano — trampa conocida, Cuenta inicial, Cómo viaja un push, Decisiones tomadas (no volver a litigar) (+18 more)

### Community 13 - "Community 13"
Cohesion: 0.07
Nodes (26): ../../bitacora/providers/bitacora_provider.dart, bool?, ../data/recepcion_repository.dart, _aceptaConformidad, activo, color, createState, dispose (+18 more)

### Community 14 - "Community 14"
Cohesion: 0.07
Nodes (26): dart:convert, dart:typed_data, _compartir, csvAsistencias, csvBitacora, csvVisitantes, _descargarCsv, _encabezado (+18 more)

### Community 15 - "Community 15"
Cohesion: 0.08
Nodes (26): _, accesoNuevo, accesos, accesosDentro, asistencia, asistenciaCamara, bitacora, bitacoraNueva (+18 more)

### Community 16 - "Community 16"
Cohesion: 0.08
Nodes (24): color, _confirmar, createState, detalle, evento, fechaTurno, icono, _MensajeVacio (+16 more)

### Community 17 - "Community 17"
Cohesion: 0.09
Nodes (22): package:image_picker/image_picker.dart, _agregarFoto, _autorizadoPorId, _autorizadoTexto, createState, _descripcion, _destino, dispose (+14 more)

### Community 18 - "Community 18"
Cohesion: 0.07
Nodes (28): ../domain/usuario_admin_validators.dart, List, _AvisoPasswordTemporal, build, _confirmar, _correo, createState, _DialogoRestablecerPassword (+20 more)

### Community 19 - "Community 19"
Cohesion: 0.10
Nodes (20): EstadoLaboral, activo, aJson, copiarCon, correo, debeCambiarPassword, desdeJson, estadoLaboral (+12 more)

### Community 20 - "Community 20"
Cohesion: 0.10
Nodes (20): abrePendiente, CategoriaEquipo, ClasificacionAsistencia, desdeValor, esNovedad, esOperativo, EstadoEquipo, EstadoLaboral (+12 more)

### Community 21 - "Community 21"
Cohesion: 0.12
Nodes (18): bool get, Perfil, actualizarWhatsapp, AuthAutenticado, AuthCargando, AuthSinSesion, build, cambiarPassword (+10 more)

### Community 22 - "Community 22"
Cohesion: 0.13
Nodes (15): ../data/reportes_service.dart, int?, clave, createState, detalle, _generando, _generar, icono (+7 more)

### Community 23 - "Community 23"
Cohesion: 0.11
Nodes (17): @pragma, device_service.dart, notificaciones_service.dart, package:firebase_core/firebase_core.dart, package:firebase_messaging/firebase_messaging.dart, darDeBajaDispositivo, _guardarToken, _inicializado (+9 more)

### Community 24 - "Community 24"
Cohesion: 0.12
Nodes (18): ../config/env_config.dart, _, auth, cambiosDeAuth, cliente, haySesion, _inicializado, inicializar (+10 more)

### Community 25 - "Community 25"
Cohesion: 0.12
Nodes (16): ../../../core/config/app_routes.dart, package:go_router/go_router.dart, _Dato, dentro, icono, onSalida, registro, _TarjetaVisitante (+8 more)

### Community 26 - "Community 26"
Cohesion: 0.12
Nodes (18): BitacoraScreen, build, _Chip, evento, icono, _Lista, mostrarResolver, onResolver (+10 more)

### Community 27 - "Community 27"
Cohesion: 0.12
Nodes (16): cantidadEncontrada, catalogoDelSitio, copiarCon, _db, elementosDisponibles, equipoId, estado, fotoRutaLocal (+8 more)

### Community 28 - "Community 28"
Cohesion: 0.12
Nodes (15): TipoNotificacion, DateTime?, creadaAt, cuerpo, desdeJson, entidadId, entidadTipo, id (+7 more)

### Community 29 - "Community 29"
Cohesion: 0.11
Nodes (17): dispose, notificador, _quitar, _ref, ../../features/accesos/presentation/acceso_form_screen.dart, ../../features/accesos/presentation/accesos_screen.dart, ../../features/asistencia/presentation/asistencia_screen.dart, ../../features/auth/presentation/cambiar_password_screen.dart (+9 more)

### Community 30 - "Community 30"
Cohesion: 0.18
Nodes (16): LocalAsistencias, LocalAvisosPrivacidad, LocalBitacoraEventos, LocalBitacoraFotos, LocalCatalogoEquipo, LocalPersonalCliente, LocalProfiles, LocalRecepcionesTurno (+8 more)

### Community 31 - "Community 31"
Cohesion: 0.12
Nodes (15): package:flutter_local_notifications/flutter_local_notifications.dart, package:supabase_flutter/supabase_flutter.dart, RealtimeChannel?, _canal, _canalAlertas, dejarDeEscuchar, escuchar, _inicializado (+7 more)

### Community 32 - "Community 32"
Cohesion: 0.17
Nodes (14): PanelRepository, build, _TarjetaSitio, asistenciasPanelProvider, build, catalogoEquipoPanelProvider, periodic, personalClientePanelProvider (+6 more)

### Community 33 - "Community 33"
Cohesion: 0.11
Nodes (21): ../../../data/sync/sync_engine.dart, _IndicadorSync, build, _EstadoSincronizacion, InicioScreen, appDatabaseProvider, db, deviceIdProvider (+13 more)

### Community 34 - "Community 34"
Cohesion: 0.13
Nodes (14): ../../notificaciones/providers/notificaciones_provider.dart, _Accion, _AccionesDeTurno, _AvisoSinTurno, detalle, _horas, horasEnTurno, icono (+6 more)

### Community 35 - "Community 35"
Cohesion: 0.13
Nodes (20): Color, ConsumerWidget, _SelectorSitio, _TarjetaNovedad, asistencia, build, color, _DatoTecnico (+12 more)

### Community 36 - "Community 36"
Cohesion: 0.17
Nodes (11): ../../accesos/providers/accesos_provider.dart, BitacoraRepository, ../data/bitacora_repository.dart, bitacoraDelTurnoProvider, fecha, historialBitacoraProvider, sitio, sitioId (+3 more)

### Community 37 - "Community 37"
Cohesion: 0.15
Nodes (13): ../../asistencia/providers/asistencia_provider.dart, core/providers/app_providers.dart, AccesosRepository, ../data/accesos_repository.dart, AccesosScreen, build, _PestanaHistorial, historialAccesosProvider (+5 more)

### Community 38 - "Community 38"
Cohesion: 0.10
Nodes (21): _double, package:geolocator/geolocator.dart, package:network_info_plus/network_info_plus.dart, package:permission_handler/permission_handler.dart, _, bssid, errorUbicacion, errorWifi (+13 more)

### Community 39 - "Community 39"
Cohesion: 0.15
Nodes (14): _, bucketEvidencias, bucketIdentificaciones, EnvConfig, estaConfigurado, maxBytesImagen, supabaseAnonKey, supabaseUrl (+6 more)

### Community 40 - "Community 40"
Cohesion: 0.22
Nodes (10): ConsumerState, ConsumerStatefulWidget, AccesoFormScreen, _BuscadorFrecuentes, _BuscadorFrecuentesState, AsistenciaScreen, _DialogoAltaUsuario, _DialogoAltaUsuarioState (+2 more)

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
Nodes (13): ../../core/config/env_config.dart, core/services/app_logger.dart, dart:io, package:flutter_image_compress/flutter_image_compress.dart, package:path/path.dart, package:path_provider/path_provider.dart, _, borrarLocal (+5 more)

### Community 45 - "Community 45"
Cohesion: 0.15
Nodes (12): package:device_info_plus/device_info_plus.dart, package:flutter_secure_storage/flutter_secure_storage.dart, package:uuid/uuid.dart, _almacen, _claveDeviceId, deviceId, _deviceIdCache, DeviceService (+4 more)

### Community 46 - "Community 46"
Cohesion: 0.17
Nodes (13): static const, _, ambarSeguridad, AppTheme, azulAcero, azulProfundo, _base, colorClasificacion (+5 more)

### Community 47 - "Community 47"
Cohesion: 0.15
Nodes (16): ../../../data/models/perfil.dart, panel_usuario_dialogs.dart, PanelSitiosScreen, _asignarSitio, build, createState, _darDeAlta, _filtroRol (+8 more)

### Community 48 - "Community 48"
Cohesion: 0.15
Nodes (14): TipoEventoBitacora, build, createState, _Dato, etiqueta, evento, PanelBitacoraScreen, _PanelBitacoraScreenState (+6 more)

### Community 49 - "Community 49"
Cohesion: 0.15
Nodes (12): _abrirTurnoLocal, _cerrarTurnoLocal, _db, estaEnDescanso, observarEventosDelTurno, observarTurnoAbierto, registrarEvento, sitioPorId (+4 more)

### Community 50 - "Community 50"
Cohesion: 0.20
Nodes (11): ../data/panel_repository.dart, package:flutter_riverpod/flutter_riverpod.dart, rangoFiltroProvider, activo, build, _elegirRango, etiqueta, FiltroRango (+3 more)

### Community 51 - "Community 51"
Cohesion: 0.13
Nodes (19): map, _cerrar, _resolver, _SelectorSitio, _gestionarEquipo, _guardar, build, _nueva (+11 more)

### Community 52 - "Community 52"
Cohesion: 0.10
Nodes (21): AsyncValue, ../../auth/providers/auth_provider.dart, core/services/supabase_service.dart, ../../../data/models/notificacion.dart, Notificacion, package:intl/intl.dart, build, _icono (+13 more)

### Community 53 - "Community 53"
Cohesion: 0.15
Nodes (14): routerProvider, core/config/app_router.dart, core/services/notificaciones_service.dart, core/services/push_service.dart, features/auth/providers/auth_provider.dart, AppSeguridadIndustrial, _AppSeguridadIndustrialState, build (+6 more)

### Community 54 - "Community 54"
Cohesion: 0.20
Nodes (9): ../../../core/services/device_service.dart, _db, observarDelTurno, observarFotos, observarHistorial, observarPendientes, registrarEvento, resolver (+1 more)

### Community 55 - "Community 55"
Cohesion: 0.18
Nodes (10): avisoVigente, buscarVisitantes, _db, guardarVisitanteFrecuente, observarDentro, observarHistorial, personalDelSitio, registrarEntrada (+2 more)

### Community 56 - "Community 56"
Cohesion: 0.26
Nodes (10): corsHeaders, SupabaseAdmin, errorPasswordTemporal(), fallo(), normalizarTelefono(), ROLES_ADMINISTRABLES, texto(), validarAltaUsuario() (+2 more)

### Community 57 - "Community 57"
Cohesion: 0.18
Nodes (23): _AccesoFormScreenState, build, _guardar, _darSalida, _PestanaDentro, BitacoraFormScreen, _BitacoraFormScreenState, build (+15 more)

### Community 58 - "Community 58"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 59 - "Community 59"
Cohesion: 0.13
Nodes (15): FormState, ../../panel/domain/usuario_admin_validators.dart, build, CambiarPasswordScreen, _CambiarPasswordScreenState, _confirmar, createState, destinoAlGuardar (+7 more)

### Community 60 - "Community 60"
Cohesion: 0.20
Nodes (9): IconData, VoidCallback, build, color, etiqueta, icono, onTap, TarjetaMetrica (+1 more)

### Community 61 - "Community 61"
Cohesion: 0.16
Nodes (14): core/theme/app_theme.dart, _atender, build, _FilaEquipo, item, PanelEquipoScreen, recepcion, build (+6 more)

### Community 62 - "Community 62"
Cohesion: 0.15
Nodes (17): AsistenciaRepository, ../data/asistencia_repository.dart, _AsistenciaScreenState, _BotonesDescanso, build, _LineaDeTiempo, asistenciaRepositoryProvider, build (+9 more)

### Community 63 - "Community 63"
Cohesion: 0.18
Nodes (10): ../../../core/constants/enums.dart, _anchoEscritorio, build, child, _Destino, _destinosPara, expandido, _mostrarFiltroSitio (+2 more)

### Community 64 - "Community 64"
Cohesion: 0.36
Nodes (6): base64url(), CuentaServicio, importarLlave(), json(), obtenerAccessToken(), ResultadoEnvio

### Community 65 - "Community 65"
Cohesion: 0.20
Nodes (9): buildCommand, framework, git, deploymentEnabled, headers, installCommand, outputDirectory, rewrites (+1 more)

### Community 66 - "Community 66"
Cohesion: 0.21
Nodes (11): class, build, _busqueda, createState, _fecha, PanelVisitantesScreen, _PanelVisitantesScreenState, accesosPanelProvider (+3 more)

### Community 67 - "Community 67"
Cohesion: 0.50
Nodes (5): Notifier, SitioSeleccionado, AuthController, SitioFiltro, String?

### Community 68 - "Community 68"
Cohesion: 0.25
Nodes (6): package:flutter_test/flutter_test.dart, package:seguridad_industrial/data/models/sitio.dart, package:seguridad_industrial/features/panel/domain/usuario_admin_validators.dart, fabrica, main, main

### Community 70 - "Community 70"
Cohesion: 0.17
Nodes (12): ../../auth/presentation/cambiar_password_screen.dart, MaterialPageRoute, build, createState, dispose, _guardando, _guardarWhatsapp, initState (+4 more)

### Community 71 - "Community 71"
Cohesion: 0.22
Nodes (9): routerWebProvider, core/config/app_router_web.dart, build, ConsolaSeguridadIndustrial, inicializar, initializeDateFormatting, main, package:flutter_localizations/flutter_localizations.dart (+1 more)

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
Cohesion: 0.67
Nodes (3): ChangeNotifier, _NotificadorAuth, _NotificadorAuthWeb

## Knowledge Gaps
- **1117 isolated node(s):** `notificador`, `_ref`, `_quitar`, `dispose`, `notificador` (+1112 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_` connect `Community 0` to `Community 1`, `Community 66`, `Community 67`, `Community 2`, `Community 38`, `Community 11`, `Community 18`, `Community 51`, `Community 22`, `Community 28`?**
  _High betweenness centrality (0.291) - this node is a cross-community bridge._
- **Why does `AppDatabase` connect `Community 79` to `Community 1`, `Community 33`, `Community 7`, `Community 49`, `Community 54`, `Community 55`, `Community 27`?**
  _High betweenness centrality (0.052) - this node is a cross-community bridge._
- **Why does `map` connect `Community 51` to `Community 0`, `Community 35`, `Community 5`, `Community 6`, `Community 13`, `Community 48`, `Community 28`, `Community 61`?**
  _High betweenness centrality (0.036) - this node is a cross-community bridge._
- **What connects `notificador`, `_ref`, `_quitar` to the rest of the system?**
  _1117 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.00784313725490196 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.015503875968992248 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.02857142857142857 - nodes in this community are weakly interconnected._