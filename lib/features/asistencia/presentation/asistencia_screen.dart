import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/models/sitio.dart';
import '../../../data/sync/sync_engine.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/asistencia_provider.dart';
import '../services/presence_service.dart';
import 'prueba_vida_screen.dart';

/// Pantalla de asistencia del elemento y del supervisor.
///
/// Un turno dura 24 h, así que esta pantalla es lo primero que se ve al llegar
/// y lo último al irse. Todo el flujo está pensado para operarse de pie y con
/// una sola mano.
class AsistenciaScreen extends ConsumerStatefulWidget {
  const AsistenciaScreen({super.key});

  @override
  ConsumerState<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends ConsumerState<AsistenciaScreen> {
  bool _procesando = false;

  @override
  Widget build(BuildContext context) {
    final perfil = ref.watch(perfilActualProvider);
    final turnoAsync = ref.watch(turnoAbiertoProvider);
    final sitiosAsync = ref.watch(sitiosDisponiblesProvider);

    if (perfil == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencia'),
        actions: const [_IndicadorSync()],
      ),
      body: RefreshIndicator(
        // `reintentarTodo` y no `sincronizarAhora`: deslizar es el gesto que
        // hace el elemento cuando algo no sube, así que también reactiva las
        // filas que ya habían agotado sus reintentos.
        onRefresh: () => ref.read(syncEngineProvider).reintentarTodo(),
        child: sitiosAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _MensajeVacio(
            icono: Icons.cloud_off,
            titulo: 'No se pudieron cargar los sitios',
            detalle: 'Conéctate una vez para descargar la configuración.',
          ),
          data: (sitios) {
            if (sitios.isEmpty) {
              return const _MensajeVacio(
                icono: Icons.location_off_outlined,
                titulo: 'Sin sitios configurados',
                detalle:
                    'El administrador todavía no ha dado de alta ningún sitio.',
              );
            }

            final turno = turnoAsync.value;
            final sitioId = ref.watch(sitioSeleccionadoProvider) ?? sitios.first.id;
            final sitio = sitios.firstWhere(
              (s) => s.id == (turno?.sitioId ?? sitioId),
              orElse: () => sitios.first,
            );

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              children: [
                _TarjetaTurno(turno: turno, sitio: sitio),
                const SizedBox(height: 20),

                // El sitio sólo se puede elegir antes de abrir turno: una vez
                // dentro, la salida tiene que registrarse en el mismo sitio.
                if (turno == null && sitios.length > 1) ...[
                  _SelectorSitio(sitios: sitios, seleccionado: sitio.id),
                  const SizedBox(height: 20),
                ],

                if (turno == null)
                  _BotonPrincipal(
                    etiqueta: 'Registrar entrada',
                    icono: Icons.login,
                    color: AppTheme.verdeOperativo,
                    ocupado: _procesando,
                    onTap: () => _registrar(
                        TipoEventoAsistencia.entrada, sitio, conSelfie: true),
                  )
                else ...[
                  _BotonPrincipal(
                    etiqueta: 'Registrar salida',
                    icono: Icons.logout,
                    color: AppTheme.azulAcero,
                    ocupado: _procesando,
                    onTap: () => _registrar(
                        TipoEventoAsistencia.salida, sitio, conSelfie: true),
                  ),
                  const SizedBox(height: 12),
                  _BotonesDescanso(
                    sitio: sitio,
                    fechaTurno: turno.turnoFecha,
                    ocupado: _procesando,
                    onRegistrar: (tipo) =>
                        _registrar(tipo, sitio, conSelfie: false),
                  ),
                ],

                if (perfil.rol == RolUsuario.supervisor) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _procesando
                        ? null
                        : () => _registrar(TipoEventoAsistencia.supervision,
                            sitio, conSelfie: true),
                    icon: const Icon(Icons.verified_user_outlined),
                    label: const Text('Registrar visita de supervisión'),
                  ),
                ],

                const SizedBox(height: 28),
                if (turno != null)
                  _LineaDeTiempo(fechaTurno: turno.turnoFecha),
              ],
            );
          },
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _registrar(
    TipoEventoAsistencia tipo,
    Sitio sitio, {
    required bool conSelfie,
  }) async {
    final perfil = ref.read(perfilActualProvider);
    if (perfil == null) return;

    setState(() => _procesando = true);

    try {
      await PresenceService.solicitarPermisos();
      final presencia = await PresenceService.obtener();

      if (!mounted) return;

      // Se le enseña al elemento qué detectó el teléfono ANTES de registrar.
      // Si el GPS lo pone a 800 m es mejor que lo sepa y lo corrija, a que se
      // entere días después cuando el supervisor le rechace la asistencia.
      final confirmado = await _confirmar(tipo, sitio, presencia);
      if (confirmado != true || !mounted) return;

      String? rutaFoto;
      var liveness = false;

      if (conSelfie) {
        final resultado = await Navigator.of(context).push<ResultadoPruebaVida>(
          MaterialPageRoute(
            builder: (_) => PruebaVidaScreen(titulo: tipo.etiqueta),
          ),
        );
        if (resultado == null || !mounted) return;
        rutaFoto = resultado.rutaFoto;
        liveness = resultado.aprobada;
      }

      final fechaTurno = sitio.fechaTurnoDe(DateTime.now());

      await ref.read(asistenciaRepositoryProvider).registrarEvento(
            usuarioId: perfil.id,
            sitioId: sitio.id,
            tipo: tipo,
            presencia: presencia,
            fechaTurno: fechaTurno,
            selfieRutaLocal: rutaFoto,
            livenessPassed: liveness,
          );

      // Se dispara un ciclo fuera de tiempo para que suba de inmediato si hay
      // red, en vez de esperar los 30 s del temporizador.
      unawaited(ref.read(syncEngineProvider).sincronizarAhora());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${tipo.etiqueta} registrada'),
          backgroundColor: AppTheme.verdeOperativo,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo registrar: $e'),
          backgroundColor: AppTheme.rojoAlerta,
        ),
      );
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  /// Qué se le dice al elemento sobre su ubicación. Se separa del `build` para
  /// poder hacer las comprobaciones de nulo de forma legible.
  String _textoUbicacion(Presencia presencia, Sitio sitio, double? distancia) {
    if (!presencia.tieneUbicacion) {
      return presencia.errorUbicacion ?? 'No disponible';
    }
    if (!sitio.tieneGeocerca || distancia == null) {
      return 'Capturada (el sitio aún no tiene geocerca)';
    }
    final metros = distancia.round();
    return distancia <= sitio.radioMetros
        ? 'Dentro del sitio ($metros m)'
        : 'A $metros m del sitio';
  }

  Future<bool?> _confirmar(
    TipoEventoAsistencia tipo,
    Sitio sitio,
    Presencia presencia,
  ) {
    final distancia = presencia.tieneUbicacion
        ? sitio.distanciaA(presencia.lat!, presencia.lng!)
        : null;
    final dentro = distancia != null && distancia <= sitio.radioMetros;

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (contexto) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                tipo.etiqueta,
                style: Theme.of(contexto).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(sitio.nombre,
                  style: const TextStyle(color: AppTheme.grisNeutro)),
              const SizedBox(height: 24),

              _FilaEvidencia(
                icono: Icons.location_on_outlined,
                titulo: 'Ubicación',
                valor: _textoUbicacion(presencia, sitio, distancia),
                ok: presencia.tieneUbicacion && (dentro || !sitio.tieneGeocerca),
              ),
              const SizedBox(height: 14),
              _FilaEvidencia(
                icono: Icons.wifi,
                titulo: 'WiFi de planta',
                valor: presencia.tieneWifi
                    ? (presencia.ssid ?? 'Red detectada')
                    : (presencia.errorWifi ?? 'No conectado'),
                ok: presencia.tieneWifi,
              ),

              if (presencia.sinEvidenciaDePresencia) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.ambarSeguridad.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_outlined,
                          color: AppTheme.ambarSeguridad, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Sin ubicación ni WiFi de planta, tu registro quedará '
                          'pendiente de revisión del supervisor. Puedes '
                          'continuar de todos modos.',
                          style: TextStyle(height: 1.35, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),
              FilledButton(
                onPressed: () => Navigator.of(contexto).pop(true),
                child: const Text('Continuar'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(contexto).pop(false),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _TarjetaTurno extends StatelessWidget {
  const _TarjetaTurno({required this.turno, required this.sitio});

  final LocalTurno? turno;
  final Sitio sitio;

  @override
  Widget build(BuildContext context) {
    if (turno == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.schedule, size: 32, color: AppTheme.grisNeutro),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sin turno abierto',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      'El turno inicia a las ${sitio.horaInicioTurno} y dura 24 horas.',
                      style: const TextStyle(
                          color: AppTheme.grisNeutro, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final t = turno!;
    final transcurrido = DateTime.now().difference(t.inicioAt);
    final horas = transcurrido.inHours;
    final minutos = transcurrido.inMinutes % 60;
    final clasificacion =
        ClasificacionAsistencia.desdeValor(t.clasificacionEntrada);
    final color = AppTheme.colorClasificacion(t.clasificacionEntrada);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.verdeOperativo.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shield,
                      color: AppTheme.verdeOperativo, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('En turno',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      Text(sitio.nombre,
                          style: const TextStyle(
                              color: AppTheme.grisNeutro, fontSize: 13)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${horas}h ${minutos}m',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700)),
                    const Text('transcurridas',
                        style: TextStyle(
                            color: AppTheme.grisNeutro, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barra de avance del turno de 24 h.
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (transcurrido.inMinutes / (24 * 60)).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppTheme.grisNeutro.withValues(alpha: 0.2),
                color: horas >= 24 ? AppTheme.rojoAlerta : AppTheme.verdeOperativo,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Etiqueta(
                  texto: 'Entrada ${DateFormat('HH:mm').format(t.inicioAt)}',
                  color: AppTheme.grisNeutro,
                ),
                if (clasificacion != ClasificacionAsistencia.aTiempo)
                  _Etiqueta(
                    texto: t.minutosRetardo > 0
                        ? '${clasificacion.etiqueta} · ${t.minutosRetardo} min'
                        : clasificacion.etiqueta,
                    color: color,
                  ),
                if (t.esDoblete)
                  const _Etiqueta(
                      texto: 'Doblete', color: AppTheme.ambarSeguridad),
                if (horas >= 24)
                  const _Etiqueta(
                      texto: 'Turno cumplido', color: AppTheme.rojoAlerta),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectorSitio extends ConsumerWidget {
  const _SelectorSitio({required this.sitios, required this.seleccionado});

  final List<Sitio> sitios;
  final String seleccionado;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButtonFormField<String>(
          initialValue: seleccionado,
          decoration: const InputDecoration(
            labelText: 'Sitio',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.factory_outlined),
          ),
          items: [
            for (final s in sitios)
              DropdownMenuItem(value: s.id, child: Text(s.nombre)),
          ],
          onChanged: (v) {
            if (v != null) {
              ref.read(sitioSeleccionadoProvider.notifier).seleccionar(v);
            }
          },
        ),
      ),
    );
  }
}

class _BotonPrincipal extends StatelessWidget {
  const _BotonPrincipal({
    required this.etiqueta,
    required this.icono,
    required this.color,
    required this.ocupado,
    required this.onTap,
  });

  final String etiqueta;
  final IconData icono;
  final Color color;
  final bool ocupado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: color),
        onPressed: ocupado ? null : onTap,
        icon: ocupado
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Icon(icono, size: 26),
        label: Text(etiqueta, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

class _BotonesDescanso extends ConsumerWidget {
  const _BotonesDescanso({
    required this.sitio,
    required this.fechaTurno,
    required this.ocupado,
    required this.onRegistrar,
  });

  final Sitio sitio;
  final DateTime fechaTurno;
  final bool ocupado;
  final void Function(TipoEventoAsistencia) onRegistrar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enDescanso =
        ref.watch(enDescansoProvider(fechaTurno)).value ?? false;

    return OutlinedButton.icon(
      onPressed: ocupado
          ? null
          : () => onRegistrar(enDescanso
              ? TipoEventoAsistencia.finDescanso
              : TipoEventoAsistencia.inicioDescanso),
      icon: Icon(enDescanso
          ? Icons.play_circle_outline
          : Icons.free_breakfast_outlined),
      label: Text(enDescanso ? 'Terminar descanso' : 'Iniciar descanso'),
    );
  }
}

class _LineaDeTiempo extends ConsumerWidget {
  const _LineaDeTiempo({required this.fechaTurno});

  final DateTime fechaTurno;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventos = ref.watch(eventosDelTurnoProvider(fechaTurno));

    return eventos.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (lista) {
        if (lista.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Movimientos del turno',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  for (var i = 0; i < lista.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    _FilaEvento(evento: lista[i]),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilaEvento extends StatelessWidget {
  const _FilaEvento({required this.evento});

  final LocalAsistencia evento;

  @override
  Widget build(BuildContext context) {
    final tipo = TipoEventoAsistencia.desdeValor(evento.tipoEvento);
    final sincronizado = evento.syncStatus == 'sincronizado';
    final pendienteRevision =
        evento.estadoValidacionServidor == 'pendiente_revision';

    return ListTile(
      leading: Icon(switch (tipo) {
        TipoEventoAsistencia.entrada => Icons.login,
        TipoEventoAsistencia.salida => Icons.logout,
        TipoEventoAsistencia.inicioDescanso => Icons.free_breakfast_outlined,
        TipoEventoAsistencia.finDescanso => Icons.play_circle_outline,
        TipoEventoAsistencia.supervision => Icons.verified_user_outlined,
      }),
      title: Text(tipo.etiqueta),
      subtitle: Text(DateFormat('d MMM · HH:mm', 'es_MX').format(evento.ocurridoAt)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pendienteRevision)
            const Tooltip(
              message: 'Pendiente de revisión del supervisor',
              child: Icon(Icons.help_outline,
                  size: 18, color: AppTheme.ambarSeguridad),
            ),
          const SizedBox(width: 8),
          // Le dice al elemento si su registro ya está en el servidor o sigue
          // sólo en el teléfono. Sin esto no tiene forma de saberlo.
          Icon(
            sincronizado ? Icons.cloud_done_outlined : Icons.cloud_upload_outlined,
            size: 18,
            color: sincronizado ? AppTheme.verdeOperativo : AppTheme.grisNeutro,
          ),
        ],
      ),
    );
  }
}

class _FilaEvidencia extends StatelessWidget {
  const _FilaEvidencia({
    required this.icono,
    required this.titulo,
    required this.valor,
    required this.ok,
  });

  final IconData icono;
  final String titulo;
  final String valor;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final color = ok ? AppTheme.verdeOperativo : AppTheme.ambarSeguridad;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icono, size: 22, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              Text(valor,
                  style: TextStyle(
                      color: AppTheme.grisNeutro, fontSize: 13, height: 1.3)),
            ],
          ),
        ),
        Icon(ok ? Icons.check_circle : Icons.error_outline,
            size: 20, color: color),
      ],
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _IndicadorSync extends ConsumerWidget {
  const _IndicadorSync();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendientes = ref.watch(pendientesSyncProvider).value ?? 0;
    final estado = ref.watch(syncEstadoProvider).value;

    if (pendientes == 0 && estado != SyncEstado.sinConexion) {
      return const Padding(
        padding: EdgeInsets.only(right: 12),
        child: Icon(Icons.cloud_done_outlined, size: 22),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          const Icon(Icons.cloud_upload_outlined, size: 22),
          if (pendientes > 0) ...[
            const SizedBox(width: 4),
            Text('$pendientes',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ],
      ),
    );
  }
}

class _MensajeVacio extends StatelessWidget {
  const _MensajeVacio({
    required this.icono,
    required this.titulo,
    required this.detalle,
  });

  final IconData icono;
  final String titulo;
  final String detalle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 80),
        Icon(icono, size: 56, color: AppTheme.grisNeutro),
        const SizedBox(height: 16),
        Text(titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(detalle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.grisNeutro, height: 1.4)),
        ),
      ],
    );
  }
}
