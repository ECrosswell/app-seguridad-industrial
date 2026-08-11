import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/panel_repository.dart' show RangoFechas;
import '../data/rondin_admin_models.dart';
import '../providers/panel_provider.dart';
import 'rondin_punto_dialog.dart';
import 'rondin_qr_dialog.dart';

class PanelRondinesScreen extends ConsumerStatefulWidget {
  const PanelRondinesScreen({super.key});

  @override
  ConsumerState<PanelRondinesScreen> createState() =>
      _PanelRondinesScreenState();
}

class _PanelRondinesScreenState extends ConsumerState<PanelRondinesScreen> {
  bool _incluirInactivos = false;
  String? _estadoResultado;
  String? _operandoPuntoId;
  String? _revisandoRondinId;

  @override
  Widget build(BuildContext context) {
    final perfil = ref.watch(perfilActualProvider);
    if (perfil?.rol != RolUsuario.admin) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 52, color: AppTheme.grisNeutro),
              SizedBox(height: 12),
              Text('Esta sección es exclusiva para administradores.'),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _EncabezadoRondines(
              onAdministrarSecciones: _administrarSecciones,
              onNuevoPunto: _crearPunto,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: _AvisoAntifraude(),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.qr_code_2), text: 'Puntos QR'),
                Tab(icon: Icon(Icons.fact_check_outlined), text: 'Resultados'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _PuntosTab(
                  incluirInactivos: _incluirInactivos,
                  operandoPuntoId: _operandoPuntoId,
                  onIncluirInactivos: (valor) {
                    setState(() => _incluirInactivos = valor);
                  },
                  onEditar: _editarPunto,
                  onMostrarQr: _mostrarQr,
                  onRotarQr: _rotarQr,
                ),
                _ResultadosTab(
                  estado: _estadoResultado,
                  revisandoRondinId: _revisandoRondinId,
                  revisionBloqueada: _revisandoRondinId != null,
                  onEstado: (valor) {
                    setState(() => _estadoResultado = valor);
                  },
                  onRevisar: _revisarRondin,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _administrarSecciones() async {
    await mostrarDialogoAdministrarSecciones(context);
    if (!mounted) return;
    ref.invalidate(puntosRondinPanelProvider);
  }

  Future<void> _crearPunto() async {
    final respuesta = await mostrarDialogoPuntoRondin(context);
    if (!mounted || respuesta == null) return;

    ref.invalidate(puntosRondinPanelProvider);
    _mensaje('Punto creado. Imprime y coloca el QR en su sección.');
    final payload = respuesta.qrPayload;
    if (payload == null || payload.isEmpty) return;

    final punto = await _puntoConContexto(respuesta.punto);
    if (!mounted) return;
    await mostrarDialogoQrPunto(context, punto: punto, payload: payload);
  }

  Future<void> _editarPunto(PuntoRondin punto) async {
    final respuesta = await mostrarDialogoPuntoRondin(context, punto: punto);
    if (!mounted || respuesta == null) return;
    ref.invalidate(puntosRondinPanelProvider);
    _mensaje('Punto actualizado correctamente.');
  }

  Future<void> _mostrarQr(PuntoRondin punto) async {
    setState(() => _operandoPuntoId = punto.id);
    try {
      final codigo = await ref
          .read(panelRepositoryProvider)
          .obtenerCodigoPunto(punto.id);
      if (!mounted) return;
      await mostrarDialogoQrPunto(
        context,
        punto: codigo.punto.conContextoDe(punto),
        payload: codigo.payload,
      );
    } catch (error) {
      if (mounted) _mensajeError(error.toString());
    } finally {
      if (mounted) setState(() => _operandoPuntoId = null);
    }
  }

  Future<void> _rotarQr(PuntoRondin punto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rotar código QR'),
        content: Text(
          'El QR impreso de "${punto.nombre}" será rechazado por el servidor. '
          'Un teléfono sin conexión aún podría capturarlo, pero no se '
          'validará al sincronizar. Hazlo si fue fotografiado, alterado o '
          'reemplazado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.ambarSeguridad,
              foregroundColor: Colors.black87,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Revocar y generar nuevo'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    setState(() => _operandoPuntoId = punto.id);
    try {
      final codigo = await ref
          .read(panelRepositoryProvider)
          .rotarCodigoPunto(punto.id);
      ref.invalidate(puntosRondinPanelProvider);
      if (!mounted) return;
      await mostrarDialogoQrPunto(
        context,
        punto: codigo.punto.conContextoDe(punto),
        payload: codigo.payload,
        codigoRotado: true,
      );
    } catch (error) {
      if (mounted) _mensajeError(error.toString());
    } finally {
      if (mounted) setState(() => _operandoPuntoId = null);
    }
  }

  Future<void> _revisarRondin(ResultadoRondin rondin, String decision) async {
    if (_revisandoRondinId != null) return;

    String? motivo;
    if (decision == 'aprobado') {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.check_circle_outline,
            color: AppTheme.verdeOperativo,
          ),
          title: const Text('Aprobar rondín'),
          content: Text(
            'Confirmas que revisaste la evidencia de '
            '${rondin.usuarioNombre.isEmpty ? 'este elemento' : rondin.usuarioNombre} '
            'y apruebas administrativamente el rondín. El veredicto '
            'automático se conservará sin cambios.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Confirmar aprobación'),
            ),
          ],
        ),
      );
      if (confirmado != true) return;
      motivo = '';
    } else {
      motivo = await _pedirMotivoRechazo(rondin);
      if (motivo == null) return;
    }
    if (!mounted || _revisandoRondinId != null) return;

    setState(() => _revisandoRondinId = rondin.id);
    try {
      await ref
          .read(panelRepositoryProvider)
          .revisarRondin(
            rondinId: rondin.id,
            decision: decision,
            motivo: motivo,
          );
      ref.invalidate(resultadosRondinPanelProvider);
      if (!mounted) return;
      _mensaje(
        decision == 'aprobado'
            ? 'Rondín aprobado administrativamente.'
            : 'Rondín rechazado administrativamente.',
      );
    } catch (error) {
      if (mounted) _mensajeError(error.toString());
    } finally {
      if (mounted) setState(() => _revisandoRondinId = null);
    }
  }

  Future<String?> _pedirMotivoRechazo(ResultadoRondin rondin) async {
    final formulario = GlobalKey<FormState>();
    final control = TextEditingController();
    final motivo = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.block_outlined, color: AppTheme.rojoAlerta),
        title: const Text('Rechazar rondín'),
        content: SizedBox(
          width: 480,
          child: Form(
            key: formulario,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'El rechazo quedará en el historial de '
                  '${rondin.usuarioNombre.isEmpty ? 'este rondín' : rondin.usuarioNombre}. '
                  'Explica el hallazgo observado.',
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: control,
                  autofocus: true,
                  maxLines: 4,
                  maxLength: 2000,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Motivo del rechazo *',
                    alignLabelWithHint: true,
                  ),
                  validator: (valor) => valor == null || valor.trim().isEmpty
                      ? 'El motivo es obligatorio'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.rojoAlerta),
            onPressed: () {
              if (formulario.currentState!.validate()) {
                Navigator.of(dialogContext).pop(control.text.trim());
              }
            },
            child: const Text('Confirmar rechazo'),
          ),
        ],
      ),
    );
    control.dispose();
    return motivo;
  }

  Future<PuntoRondin> _puntoConContexto(PuntoRondin punto) async {
    try {
      final puntos = await ref.read(puntosRondinPanelProvider.future);
      final contexto = puntos.where((item) => item.id == punto.id).firstOrNull;
      return contexto == null ? punto : punto.conContextoDe(contexto);
    } catch (_) {
      return punto;
    }
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: AppTheme.verdeOperativo),
    );
  }

  void _mensajeError(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: AppTheme.rojoAlerta),
    );
  }
}

class _EncabezadoRondines extends StatelessWidget {
  const _EncabezadoRondines({
    required this.onAdministrarSecciones,
    required this.onNuevoPunto,
  });

  final VoidCallback onAdministrarSecciones;
  final VoidCallback onNuevoPunto;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final titulo = const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rondines QR',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 3),
            Text(
              'Configura puntos físicos y revisa la evidencia sincronizada.',
              style: TextStyle(color: AppTheme.grisNeutro),
            ),
          ],
        );
        final acciones = Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: onAdministrarSecciones,
              icon: const Icon(Icons.domain_outlined),
              label: const Text('Secciones'),
            ),
            FilledButton.icon(
              onPressed: onNuevoPunto,
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Nuevo punto QR'),
            ),
          ],
        );

        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [titulo, const SizedBox(height: 14), acciones],
          );
        }
        return Row(
          children: [
            Expanded(child: titulo),
            acciones,
          ],
        );
      },
    );
  }
}

class _AvisoAntifraude extends StatelessWidget {
  const _AvisoAntifraude();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.azulAcero.withValues(alpha: 0.055),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.verified_user_outlined, color: AppTheme.azulAcero),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Un QR impreso puede ser fotografiado. Por eso el sistema no '
                'lo valida solo: al sincronizar también revisa ubicación, GPS '
                'simulado, WiFi de zona, orden, tiempos y repeticiones. Los '
                'casos dudosos quedan visibles para revisión.',
                style: TextStyle(fontSize: 12.5, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PuntosTab extends ConsumerWidget {
  const _PuntosTab({
    required this.incluirInactivos,
    required this.operandoPuntoId,
    required this.onIncluirInactivos,
    required this.onEditar,
    required this.onMostrarQr,
    required this.onRotarQr,
  });

  final bool incluirInactivos;
  final String? operandoPuntoId;
  final ValueChanged<bool> onIncluirInactivos;
  final ValueChanged<PuntoRondin> onEditar;
  final ValueChanged<PuntoRondin> onMostrarQr;
  final ValueChanged<PuntoRondin> onRotarQr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puntos = ref.watch(puntosRondinPanelProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(puntosRondinPanelProvider);
        await ref.read(puntosRondinPanelProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Puntos ordenados por ruta',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              FilterChip(
                label: const Text('Incluir inactivos'),
                selected: incluirInactivos,
                onSelected: onIncluirInactivos,
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Actualizar',
                onPressed: () => ref.invalidate(puntosRondinPanelProvider),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 12),
          puntos.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => _ErrorCarga(
              mensaje: 'No se pudieron cargar los puntos: $error',
              onReintentar: () => ref.invalidate(puntosRondinPanelProvider),
            ),
            data: (lista) {
              final visibles = incluirInactivos
                  ? lista
                  : lista.where((punto) => punto.activo).toList();
              if (visibles.isEmpty) {
                return const _Vacio(
                  icono: Icons.qr_code_2,
                  titulo: 'Todavía no hay puntos QR',
                  descripcion: 'Crea una sección y el primer punto del rondín.',
                );
              }
              return Column(
                children: [
                  for (final punto in visibles)
                    _TarjetaPunto(
                      punto: punto,
                      operando: operandoPuntoId == punto.id,
                      onEditar: () => onEditar(punto),
                      onMostrarQr: () => onMostrarQr(punto),
                      onRotarQr: () => onRotarQr(punto),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TarjetaPunto extends StatelessWidget {
  const _TarjetaPunto({
    required this.punto,
    required this.operando,
    required this.onEditar,
    required this.onMostrarQr,
    required this.onRotarQr,
  });

  final PuntoRondin punto;
  final bool operando;
  final VoidCallback onEditar;
  final VoidCallback onMostrarQr;
  final VoidCallback onRotarQr;

  @override
  Widget build(BuildContext context) {
    final sitioSeccion = [
      punto.sitioNombre,
      punto.seccionNombre,
    ].where((texto) => texto.isNotEmpty).join(' · ');
    final senales = <String>[
      if (punto.lat != null && punto.lng != null)
        '${punto.lat!.toStringAsFixed(5)}, ${punto.lng!.toStringAsFixed(5)} '
            '(±${punto.radioMetros} m)',
      if (punto.wifiNombre.isNotEmpty) 'WiFi ${punto.wifiNombre}',
      if (punto.requiereLiveness) 'Prueba de vida',
    ];

    return Opacity(
      opacity: punto.activo ? 1 : 0.62,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.azulAcero.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${punto.orden}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.azulAcero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          punto.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (sitioSeccion.isNotEmpty)
                          Text(
                            sitioSeccion,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppTheme.grisNeutro,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _ChipEstado(
                    texto: punto.activo ? 'Activo' : 'Inactivo',
                    color: punto.activo
                        ? AppTheme.verdeOperativo
                        : AppTheme.grisNeutro,
                  ),
                ],
              ),
              if (punto.descripcion.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(punto.descripcion, style: const TextStyle(height: 1.35)),
              ],
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _DatoPunto(
                    icono: Icons.timer_outlined,
                    texto: punto.minutosMinimosDesdeAnterior == 0
                        ? 'Sin espera mínima'
                        : 'Mínimo ${punto.minutosMinimosDesdeAnterior} min',
                  ),
                  _DatoPunto(
                    icono: Icons.qr_code,
                    texto: 'QR v${punto.qrVersion}',
                  ),
                  for (final senal in senales)
                    _DatoPunto(icono: Icons.verified_outlined, texto: senal),
                ],
              ),
              const Divider(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: operando ? null : onEditar,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar'),
                  ),
                  OutlinedButton.icon(
                    onPressed: operando ? null : onRotarQr,
                    icon: const Icon(Icons.autorenew),
                    label: const Text('Rotar QR'),
                  ),
                  FilledButton.icon(
                    onPressed: operando ? null : onMostrarQr,
                    icon: operando
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.print_outlined),
                    label: const Text('Ver / imprimir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatoPunto extends StatelessWidget {
  const _DatoPunto({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 15, color: AppTheme.grisNeutro),
          const SizedBox(width: 5),
          Flexible(child: Text(texto, style: const TextStyle(fontSize: 11.5))),
        ],
      ),
    );
  }
}

class _ResultadosTab extends ConsumerWidget {
  const _ResultadosTab({
    required this.estado,
    required this.revisandoRondinId,
    required this.revisionBloqueada,
    required this.onEstado,
    required this.onRevisar,
  });

  final String? estado;
  final String? revisandoRondinId;
  final bool revisionBloqueada;
  final ValueChanged<String?> onEstado;
  final void Function(ResultadoRondin rondin, String decision) onRevisar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultados = ref.watch(resultadosRondinPanelProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(resultadosRondinPanelProvider);
        await ref.read(resultadosRondinPanelProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Periodo:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ActionChip(
                label: const Text('7 días'),
                onPressed: () => ref
                    .read(rangoFiltroProvider.notifier)
                    .seleccionar(RangoFechas.ultimosDias(7)),
              ),
              ActionChip(
                label: const Text('30 días'),
                onPressed: () => ref
                    .read(rangoFiltroProvider.notifier)
                    .seleccionar(RangoFechas.ultimosDias(30)),
              ),
              ActionChip(
                label: const Text('Mes actual'),
                onPressed: () => ref
                    .read(rangoFiltroProvider.notifier)
                    .seleccionar(RangoFechas.mesActual()),
              ),
              const SizedBox(width: 8),
              _FiltroEstadoResultado(estado: estado, onEstado: onEstado),
              IconButton(
                tooltip: 'Actualizar',
                onPressed: () => ref.invalidate(resultadosRondinPanelProvider),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 14),
          resultados.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => _ErrorCarga(
              mensaje: 'No se pudieron cargar los rondines: $error',
              onReintentar: () => ref.invalidate(resultadosRondinPanelProvider),
            ),
            data: (lista) {
              final filtrados = estado == null
                  ? lista
                  : lista
                        .where((rondin) => rondin.estadoValidacion == estado)
                        .toList();
              if (filtrados.isEmpty) {
                return const _Vacio(
                  icono: Icons.fact_check_outlined,
                  titulo: 'Sin resultados en este periodo',
                  descripcion:
                      'Los rondines aparecerán después de sincronizarse.',
                );
              }
              return Column(
                children: [
                  for (final rondin in filtrados)
                    _TarjetaResultado(
                      rondin: rondin,
                      revisando: revisandoRondinId == rondin.id,
                      revisionBloqueada: revisionBloqueada,
                      onAprobar: () => onRevisar(rondin, 'aprobado'),
                      onRechazar: () => onRevisar(rondin, 'rechazado'),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FiltroEstadoResultado extends StatelessWidget {
  const _FiltroEstadoResultado({required this.estado, required this.onEstado});

  final String? estado;
  final ValueChanged<String?> onEstado;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: estado,
      hint: const Text('Todos los estados'),
      items: const [
        DropdownMenuItem(value: null, child: Text('Todos los estados')),
        DropdownMenuItem(value: 'validado', child: Text('Validados')),
        DropdownMenuItem(
          value: 'pendiente_revision',
          child: Text('Por revisar'),
        ),
        DropdownMenuItem(value: 'rechazado', child: Text('Rechazados')),
      ],
      onChanged: onEstado,
    );
  }
}

class _TarjetaResultado extends StatelessWidget {
  const _TarjetaResultado({
    required this.rondin,
    required this.revisando,
    required this.revisionBloqueada,
    required this.onAprobar,
    required this.onRechazar,
  });

  final ResultadoRondin rondin;
  final bool revisando;
  final bool revisionBloqueada;
  final VoidCallback onAprobar;
  final VoidCallback onRechazar;

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat('d MMM yyyy, HH:mm', 'es_MX');
    final color = _colorEstado(rondin.estadoValidacion);
    final titulo = rondin.usuarioNombre.isEmpty
        ? 'Elemento ${_abreviarId(rondin.usuarioId)}'
        : rondin.usuarioNombre;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.13),
          child: Icon(_iconoEstado(rondin.estadoValidacion), color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            _ChipEstado(
              texto: 'Auto: ${_etiquetaEstado(rondin.estadoValidacion)}',
              color: color,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            [
              rondin.sitioNombre,
              rondin.rutaNombre,
              formato.format(rondin.iniciadoAt),
              rondin.puntosEsperados > 0
                  ? '${rondin.puntosRecibidos}/${rondin.puntosEsperados} puntos'
                  : '${rondin.lecturas.length} puntos',
              'riesgo ${rondin.puntajeRiesgo}',
            ].where((texto) => texto.isNotEmpty).join(' · '),
          ),
        ),
        children: [
          _ResumenRevisionRondin(
            rondin: rondin,
            revisando: revisando,
            revisionBloqueada: revisionBloqueada,
            onAprobar: onAprobar,
            onRechazar: onRechazar,
          ),
          const SizedBox(height: 14),
          if (rondin.codigosRiesgo.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final codigo in rondin.codigosRiesgo)
                    _ChipRiesgo(codigo: codigo),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (rondin.lecturas.isEmpty)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'No hay lecturas sincronizadas para este rondín.',
                style: TextStyle(color: AppTheme.grisNeutro),
              ),
            )
          else
            Column(
              children: [
                for (final lectura in [
                  ...rondin.lecturas,
                ]..sort((a, b) => a.secuencia.compareTo(b.secuencia)))
                  _FilaLectura(lectura: lectura),
              ],
            ),
        ],
      ),
    );
  }
}

class _ResumenRevisionRondin extends StatelessWidget {
  const _ResumenRevisionRondin({
    required this.rondin,
    required this.revisando,
    required this.revisionBloqueada,
    required this.onAprobar,
    required this.onRechazar,
  });

  final ResultadoRondin rondin;
  final bool revisando;
  final bool revisionBloqueada;
  final VoidCallback onAprobar;
  final VoidCallback onRechazar;

  @override
  Widget build(BuildContext context) {
    final revision = rondin.revisionAdministrativa;
    final requiereDecision =
        rondin.estadoValidacion == 'pendiente_revision' && revision == null;
    final colorDecision = switch (revision?.decision) {
      'aprobado' => AppTheme.verdeOperativo,
      'rechazado' => AppTheme.rojoAlerta,
      _ => AppTheme.grisNeutro,
    };
    final etiquetaDecision = switch (revision?.decision) {
      'aprobado' => 'Aprobado',
      'rechazado' => 'Rechazado',
      _ => 'Sin revisar',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              _VeredictoSeparado(
                etiqueta: 'Veredicto automático',
                valor: _etiquetaEstado(rondin.estadoValidacion),
                color: _colorEstado(rondin.estadoValidacion),
              ),
              _VeredictoSeparado(
                etiqueta: 'Decisión administrativa',
                valor: etiquetaDecision,
                color: colorDecision,
              ),
            ],
          ),
          if (revision != null) ...[
            const SizedBox(height: 10),
            Text(
              [
                'Registrada ${DateFormat('d MMM yyyy, HH:mm', 'es_MX').format(revision.createdAt)}',
                if (revision.actorNombre.isNotEmpty) revision.actorNombre,
              ].join(' · '),
              style: const TextStyle(
                fontSize: 11.5,
                color: AppTheme.grisNeutro,
              ),
            ),
            if (revision.motivo.trim().isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                'Motivo: ${revision.motivo}',
                style: const TextStyle(fontSize: 12.5, height: 1.35),
              ),
            ],
          ],
          if (requiereDecision) ...[
            const SizedBox(height: 14),
            const Text(
              'Este rondín requiere una decisión humana. Revisa sus lecturas '
              'y señales antes de resolverlo.',
              style: TextStyle(fontSize: 12.5, height: 1.35),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: revisionBloqueada ? null : onRechazar,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.rojoAlerta,
                  ),
                  icon: const Icon(Icons.block_outlined),
                  label: const Text('Rechazar'),
                ),
                FilledButton.icon(
                  onPressed: revisionBloqueada ? null : onAprobar,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.verdeOperativo,
                  ),
                  icon: revisando
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(revisando ? 'Guardando…' : 'Aprobar'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _VeredictoSeparado extends StatelessWidget {
  const _VeredictoSeparado({
    required this.etiqueta,
    required this.valor,
    required this.color,
  });

  final String etiqueta;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(fontSize: 10.5, color: AppTheme.grisNeutro),
        ),
        const SizedBox(height: 3),
        Text(
          valor,
          style: TextStyle(fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

class _FilaLectura extends StatelessWidget {
  const _FilaLectura({required this.lectura});

  final LecturaResultadoRondin lectura;

  @override
  Widget build(BuildContext context) {
    final color = _colorEstado(lectura.estadoValidacion);
    final detalles = <String>[
      DateFormat('HH:mm:ss').format(lectura.capturadoAt),
      if (lectura.distanciaPuntoM != null)
        '${lectura.distanciaPuntoM!.round()} m del punto',
      if (lectura.gpsAccuracyM != null)
        'precisión ±${lectura.gpsAccuracyM!.round()} m',
      lectura.wifiReconocido ? 'WiFi reconocido' : 'WiFi no reconocido',
      if (lectura.gpsIsMocked) 'GPS simulado',
      if (!lectura.qrValido) 'QR inválido',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${lectura.secuencia}',
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [
                    lectura.puntoNombre,
                    lectura.seccionNombre,
                  ].where((texto) => texto.isNotEmpty).join(' · '),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  detalles.join(' · '),
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppTheme.grisNeutro,
                  ),
                ),
                if (lectura.codigosRiesgo.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (final codigo in lectura.codigosRiesgo)
                        _ChipRiesgo(codigo: codigo),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${lectura.puntajeRiesgo}',
            style: TextStyle(fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

class _ChipEstado extends StatelessWidget {
  const _ChipEstado({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _ChipRiesgo extends StatelessWidget {
  const _ChipRiesgo({required this.codigo});

  final String codigo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.ambarSeguridad.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        codigo.replaceAll('_', ' '),
        style: const TextStyle(fontSize: 10.5, color: Colors.brown),
      ),
    );
  }
}

class _Vacio extends StatelessWidget {
  const _Vacio({
    required this.icono,
    required this.titulo,
    required this.descripcion,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(38),
        child: Column(
          children: [
            Icon(icono, size: 48, color: AppTheme.grisNeutro),
            const SizedBox(height: 12),
            Text(
              titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 5),
            Text(
              descripcion,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.grisNeutro),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCarga extends StatelessWidget {
  const _ErrorCarga({required this.mensaje, required this.onReintentar});

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

Color _colorEstado(String estado) {
  return switch (estado) {
    'validado' => AppTheme.verdeOperativo,
    'pendiente_revision' => AppTheme.ambarSeguridad,
    'rechazado' => AppTheme.rojoAlerta,
    _ => AppTheme.grisNeutro,
  };
}

IconData _iconoEstado(String estado) {
  return switch (estado) {
    'validado' => Icons.verified_outlined,
    'pendiente_revision' => Icons.rate_review_outlined,
    'rechazado' => Icons.block_outlined,
    _ => Icons.schedule_outlined,
  };
}

String _etiquetaEstado(String estado) {
  return switch (estado) {
    'validado' => 'Validado',
    'pendiente_revision' => 'Por revisar',
    'rechazado' => 'Rechazado',
    _ => estado.replaceAll('_', ' '),
  };
}

String _abreviarId(String id) {
  if (id.length <= 8) return id;
  return id.substring(0, 8);
}
