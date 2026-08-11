import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_routes.dart';
import '../../../core/constants/enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/sync/sync_engine.dart';
import '../../asistencia/providers/asistencia_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../notificaciones/providers/notificaciones_provider.dart';

/// Tablero del elemento y del supervisor.
///
/// Es lo primero que ve al abrir la app. Responde tres preguntas de un vistazo:
/// ¿estoy en turno?, ¿qué me falta hacer?, ¿ya se subió lo que registré?
class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilActualProvider);
    final turno = ref.watch(turnoAbiertoProvider).value;
    final noLeidas = ref.watch(notificacionesNoLeidasProvider).value ?? 0;

    if (perfil == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguridad Industrial'),
        actions: [
          IconButton(
            onPressed: () => context.push(Rutas.notificaciones),
            icon: Badge(
              isLabelVisible: noLeidas > 0,
              label: Text('$noLeidas'),
              child: const Icon(Icons.notifications_outlined),
            ),
            tooltip: 'Notificaciones',
          ),
          IconButton(
            onPressed: () => context.push(Rutas.perfil),
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Mi perfil',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(syncEngineProvider).sincronizarAhora(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _Saludo(nombre: perfil.nombreCompleto, rol: perfil.rol),
            const SizedBox(height: 20),

            const _EstadoSincronizacion(),
            const SizedBox(height: 20),

            if (turno == null)
              _AvisoSinTurno(onRegistrar: () => context.go(Rutas.asistencia))
            else
              _AccionesDeTurno(horasEnTurno: _horas(turno.inicioAt)),

            const SizedBox(height: 24),
            const Text(
              'Acciones',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            _Accion(
              icono: Icons.qr_code_scanner,
              titulo: 'Rondín QR',
              detalle: turno == null
                  ? 'Registra tu entrada para iniciar'
                  : 'Recorre y comprueba los puntos de la planta',
              onTap: () => context.push(Rutas.rondines),
            ),
            _Accion(
              icono: Icons.inventory_2_outlined,
              titulo: 'Recepción de turno',
              detalle: 'Revisa el equipo de la caseta al recibir',
              onTap: () => context.push(Rutas.recepcionTurno),
            ),
            _Accion(
              icono: Icons.person_add_alt_1_outlined,
              titulo: 'Registrar visitante',
              detalle: 'Alta de acceso con identificación y placas',
              onTap: () => context.push(Rutas.accesoNuevo),
            ),
            _Accion(
              icono: Icons.post_add_outlined,
              titulo: 'Nuevo evento de bitácora',
              detalle: 'Mercancía, fallas, incidentes, rondas',
              onTap: () => context.push(Rutas.bitacoraNueva),
            ),
          ],
        ),
      ),
    );
  }

  static double _horas(DateTime desde) =>
      DateTime.now().difference(desde).inMinutes / 60.0;
}

class _Saludo extends StatelessWidget {
  const _Saludo({required this.nombre, required this.rol});

  final String nombre;
  final RolUsuario rol;

  @override
  Widget build(BuildContext context) {
    final hora = DateTime.now().hour;
    final saludo = hora < 12
        ? 'Buenos días'
        : (hora < 19 ? 'Buenas tardes' : 'Buenas noches');
    final primerNombre = nombre.split(' ').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$saludo, $primerNombre',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          '${rol.etiqueta} · ${DateFormat('EEEE d \'de\' MMMM', 'es_MX').format(DateTime.now())}',
          style: const TextStyle(color: AppTheme.grisNeutro, fontSize: 13),
        ),
      ],
    );
  }
}

/// Le dice al elemento si lo que registró ya está en el servidor.
///
/// Sin este indicador no tiene forma de distinguir entre "se guardó" y "se
/// guardó nada más en mi teléfono", que en una caseta sin señal es la
/// diferencia entre tener evidencia y no tenerla.
class _EstadoSincronizacion extends ConsumerWidget {
  const _EstadoSincronizacion();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(syncEstadoProvider).value;
    final pendientes = ref.watch(pendientesSyncProvider).value ?? 0;

    final (icono, color, texto) = switch (estado) {
      SyncEstado.sincronizando => (
        Icons.sync,
        AppTheme.azulAcero,
        'Sincronizando…',
      ),
      SyncEstado.sinConexion => (
        Icons.cloud_off_outlined,
        AppTheme.ambarSeguridad,
        pendientes > 0
            ? 'Sin conexión · $pendientes registro(s) por subir'
            : 'Sin conexión · puedes seguir trabajando',
      ),
      SyncEstado.error => (
        Icons.error_outline,
        AppTheme.rojoAlerta,
        'Error al sincronizar · se reintentará solo',
      ),
      SyncEstado.conPendientes => (
        Icons.cloud_upload_outlined,
        AppTheme.ambarSeguridad,
        '$pendientes registro(s) por subir',
      ),
      _ => (
        Icons.cloud_done_outlined,
        AppTheme.verdeOperativo,
        'Todo sincronizado',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icono, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvisoSinTurno extends StatelessWidget {
  const _AvisoSinTurno({required this.onRegistrar});

  final VoidCallback onRegistrar;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.schedule, color: AppTheme.grisNeutro),
                SizedBox(width: 10),
                Text(
                  'No has registrado entrada',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Registra tu entrada con ubicación y fotografía para iniciar tu turno.',
              style: TextStyle(color: AppTheme.grisNeutro, height: 1.35),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRegistrar,
              icon: const Icon(Icons.login),
              label: const Text('Registrar entrada'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccionesDeTurno extends StatelessWidget {
  const _AccionesDeTurno({required this.horasEnTurno});

  final double horasEnTurno;

  @override
  Widget build(BuildContext context) {
    // El turno dura 24 h. Pasadas las 23 se avisa que el relevo está por
    // llegar; pasadas las 24, que ya se cumplió y falta registrar salida.
    final porCumplirse = horasEnTurno >= 23 && horasEnTurno < 24;
    final cumplido = horasEnTurno >= 24;

    final color = cumplido
        ? AppTheme.rojoAlerta
        : (porCumplirse ? AppTheme.ambarSeguridad : AppTheme.verdeOperativo);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              cumplido ? Icons.notification_important : Icons.shield,
              color: color,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cumplido
                        ? 'Turno cumplido'
                        : (porCumplirse
                              ? 'Tu relevo está por llegar'
                              : 'En turno'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cumplido
                        ? 'Ya pasaron ${horasEnTurno.floor()} h. Registra tu salida.'
                        : 'Llevas ${horasEnTurno.floor()} h de 24.',
                    style: const TextStyle(
                      color: AppTheme.grisNeutro,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Accion extends StatelessWidget {
  const _Accion({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.azulAcero.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icono, color: AppTheme.azulAcero),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(detalle, style: const TextStyle(fontSize: 12.5)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
