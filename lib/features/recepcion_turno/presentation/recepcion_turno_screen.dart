import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/remote/foto_service.dart';
import '../../accesos/providers/accesos_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bitacora/providers/bitacora_provider.dart';
import '../data/recepcion_repository.dart';

final recepcionRepositoryProvider = Provider<RecepcionRepository>((ref) {
  return RecepcionRepository(ref.watch(appDatabaseProvider));
});

final catalogoEquipoProvider =
    FutureProvider<List<LocalCatalogoEquipoData>>((ref) {
  final sitioId = ref.watch(sitioOperativoProvider);
  if (sitioId == null) return Future.value(const []);
  ref.watch(syncEstadoProvider);
  return ref.watch(recepcionRepositoryProvider).catalogoDelSitio(sitioId);
});

final elementosDisponiblesProvider = FutureProvider<List<LocalProfile>>((ref) {
  ref.watch(syncEstadoProvider);
  return ref.watch(recepcionRepositoryProvider).elementosDisponibles();
});

final recepcionesRecientesProvider =
    StreamProvider<List<LocalRecepcionesTurnoData>>((ref) {
  final sitioId = ref.watch(sitioOperativoProvider);
  if (sitioId == null) return Stream.value(const []);
  return ref.watch(recepcionRepositoryProvider).observarRecientes(sitioId);
});

/// Recepción de turno: revisión del equipo de la caseta.
///
/// Sólo firma **quien recibe**. El saliente ya se va, así que pedirle su firma
/// en pantalla sería una ficción; se registra únicamente como referencia de a
/// quién se le recibió.
class RecepcionTurnoScreen extends ConsumerStatefulWidget {
  const RecepcionTurnoScreen({super.key});

  @override
  ConsumerState<RecepcionTurnoScreen> createState() =>
      _RecepcionTurnoScreenState();
}

class _RecepcionTurnoScreenState extends ConsumerState<RecepcionTurnoScreen> {
  final Map<String, PartidaRevisada> _partidas = {};
  final _observaciones = TextEditingController();

  String? _entregaId;
  bool? _aceptaConformidad;
  bool _guardando = false;

  @override
  void dispose() {
    _observaciones.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogo = ref.watch(catalogoEquipoProvider);
    final elementos = ref.watch(elementosDisponiblesProvider).value ?? const [];
    final sitioId = ref.watch(sitioOperativoProvider);
    final fechaTurno = ref.watch(turnoFechaActualProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recepción de turno')),
      body: catalogo.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (partidasCatalogo) {
          if (partidasCatalogo.isEmpty) {
            return const _SinCatalogo();
          }

          // Todo arranca en "perfecto": es el caso normal y así el elemento
          // sólo toca lo que está mal, en vez de marcar tres cosas bien cada
          // día para poder guardar.
          for (final p in partidasCatalogo) {
            _partidas.putIfAbsent(
              p.id,
              () => PartidaRevisada(
                equipoId: p.id,
                estado: EstadoEquipo.perfecto,
                cantidadEncontrada: p.cantidadEsperada,
              ),
            );
          }

          final hayNovedades =
              _partidas.values.any((p) => p.estado.esNovedad);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              _Encabezado(fechaTurno: fechaTurno),
              const SizedBox(height: 20),

              if (elementos.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  initialValue: _entregaId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Recibo de (opcional)',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: [
                    for (final e in elementos)
                      DropdownMenuItem(
                        value: e.id,
                        child: Text(e.nombreCompleto,
                            overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (v) => setState(() => _entregaId = v),
                ),
                const SizedBox(height: 20),
              ],

              const Text('Equipo de la caseta',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text(
                'Revisa cada partida y marca su estado real.',
                style: TextStyle(color: AppTheme.grisNeutro, fontSize: 13),
              ),
              const SizedBox(height: 12),

              for (final equipo in partidasCatalogo)
                _TarjetaPartida(
                  equipo: equipo,
                  revision: _partidas[equipo.id]!,
                  onCambio: (r) => setState(() => _partidas[equipo.id] = r),
                  onFoto: () => _tomarFoto(equipo.id),
                ),

              const SizedBox(height: 20),
              TextField(
                controller: _observaciones,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Observaciones generales',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),
              _Conformidad(
                valor: _aceptaConformidad,
                hayNovedades: hayNovedades,
                onCambio: (v) => setState(() => _aceptaConformidad = v),
              ),

              if (hayNovedades || _aceptaConformidad == false) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppTheme.ambarSeguridad.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.ambarSeguridad.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.notification_important_outlined,
                          color: AppTheme.ambarSeguridad, size: 21),
                      SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          'Se enviará una alerta al administrador con lo que '
                          'reportaste. Tu turno no se bloquea: puedes seguir '
                          'operando con normalidad.',
                          style: TextStyle(fontSize: 13, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: (_guardando ||
                        _aceptaConformidad == null ||
                        sitioId == null ||
                        fechaTurno == null)
                    ? null
                    : () => _guardar(sitioId, fechaTurno),
                icon: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.check),
                label: const Text('Confirmar recepción'),
              ),
              if (_aceptaConformidad == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Indica si recibes de conformidad para continuar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppTheme.grisNeutro),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _tomarFoto(String equipoId) async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (imagen == null) return;

    final comprimida = await FotoService.comprimirYGuardar(imagen.path);
    if (!mounted) return;

    setState(() {
      _partidas[equipoId] =
          _partidas[equipoId]!.copiarCon(fotoRutaLocal: comprimida ?? imagen.path);
    });
  }

  Future<void> _guardar(String sitioId, DateTime fechaTurno) async {
    final perfil = ref.read(perfilActualProvider);
    if (perfil == null || _aceptaConformidad == null) return;

    setState(() => _guardando = true);

    try {
      await ref.read(recepcionRepositoryProvider).guardar(
            sitioId: sitioId,
            turnoFecha: fechaTurno,
            recibeId: perfil.id,
            aceptaConformidad: _aceptaConformidad!,
            partidas: _partidas.values.toList(),
            entregaId: _entregaId,
            observaciones: _observaciones.text.trim(),
          );

      unawaited(ref.read(syncEngineProvider).sincronizarAhora());

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recepción de turno registrada'),
          backgroundColor: AppTheme.verdeOperativo,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar: $e'),
          backgroundColor: AppTheme.rojoAlerta,
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.fechaTurno});

  final DateTime? fechaTurno;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppTheme.azulAcero.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.inventory_2_outlined,
                  color: AppTheme.azulAcero, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Revisión de equipo',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(
                    fechaTurno == null
                        ? 'Turno sin abrir'
                        : 'Turno del ${DateFormat('d MMM yyyy', 'es_MX').format(fechaTurno!)}',
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
}

class _TarjetaPartida extends StatelessWidget {
  const _TarjetaPartida({
    required this.equipo,
    required this.revision,
    required this.onCambio,
    required this.onFoto,
  });

  final LocalCatalogoEquipoData equipo;
  final PartidaRevisada revision;
  final ValueChanged<PartidaRevisada> onCambio;
  final VoidCallback onFoto;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.colorEstadoEquipo(revision.estado.valor);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(equipo.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15.5)),
                      if (equipo.descripcion.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(equipo.descripcion,
                              style: const TextStyle(
                                  fontSize: 12.5, color: AppTheme.grisNeutro)),
                        ),
                    ],
                  ),
                ),
                if (equipo.cantidadEsperada > 1)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.grisNeutro.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Esperado: ${equipo.cantidadEsperada}',
                        style: const TextStyle(fontSize: 11.5)),
                  ),
              ],
            ),

            if (equipo.debeEstarSinUsar)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 15, color: AppTheme.ambarSeguridad),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Debe recibirse sin usar. Si viene usado, hubo un evento '
                        'que nadie reportó.',
                        style: TextStyle(
                            fontSize: 11.5, color: AppTheme.ambarSeguridad),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            SegmentedButton<EstadoEquipo>(
              segments: const [
                ButtonSegment(
                    value: EstadoEquipo.perfecto,
                    label: Text('Bien'),
                    icon: Icon(Icons.check, size: 17)),
                ButtonSegment(
                    value: EstadoEquipo.usado,
                    label: Text('Usado'),
                    icon: Icon(Icons.remove, size: 17)),
                ButtonSegment(
                    value: EstadoEquipo.danado,
                    label: Text('Dañado'),
                    icon: Icon(Icons.warning_amber, size: 17)),
                ButtonSegment(
                    value: EstadoEquipo.falta,
                    label: Text('Falta'),
                    icon: Icon(Icons.close, size: 17)),
              ],
              selected: {revision.estado},
              onSelectionChanged: (s) =>
                  onCambio(revision.copiarCon(estado: s.first)),
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStateProperty.all(
                    const TextStyle(fontSize: 12)),
              ),
            ),

            if (revision.estado.esNovedad) ...[
              const SizedBox(height: 12),
              TextFormField(
                initialValue: revision.observaciones,
                onChanged: (v) => onCambio(revision.copiarCon(observaciones: v)),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Qué observaste',
                  isDense: true,
                  prefixIcon: Icon(Icons.edit_note, color: color),
                ),
              ),
            ],

            if (equipo.requiereFoto || revision.estado.esNovedad) ...[
              const SizedBox(height: 10),
              if (revision.fotoRutaLocal == null)
                OutlinedButton.icon(
                  onPressed: onFoto,
                  icon: const Icon(Icons.photo_camera_outlined, size: 19),
                  label: Text(equipo.requiereFoto
                      ? 'Fotografiar (requerida)'
                      : 'Agregar foto'),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42)),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(revision.fotoRutaLocal!),
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Conformidad extends StatelessWidget {
  const _Conformidad({
    required this.valor,
    required this.hayNovedades,
    required this.onCambio,
  });

  final bool? valor;
  final bool hayNovedades;
  final ValueChanged<bool> onCambio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('¿Recibes de conformidad?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text(
          'Tu respuesta queda registrada con fecha y hora.',
          style: TextStyle(color: AppTheme.grisNeutro, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _BotonConformidad(
                etiqueta: 'Sí, de conformidad',
                icono: Icons.thumb_up_outlined,
                color: AppTheme.verdeOperativo,
                activo: valor == true,
                onTap: () => onCambio(true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _BotonConformidad(
                etiqueta: 'No de conformidad',
                icono: Icons.thumb_down_outlined,
                color: AppTheme.rojoAlerta,
                activo: valor == false,
                onTap: () => onCambio(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BotonConformidad extends StatelessWidget {
  const _BotonConformidad({
    required this.etiqueta,
    required this.icono,
    required this.color,
    required this.activo,
    required this.onTap,
  });

  final String etiqueta;
  final IconData icono;
  final Color color;
  final bool activo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: activo ? color.withValues(alpha: 0.13) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: activo ? color : AppTheme.grisNeutro.withValues(alpha: 0.4),
            width: activo ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icono, color: activo ? color : AppTheme.grisNeutro, size: 24),
            const SizedBox(height: 7),
            Text(
              etiqueta,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
                color: activo ? color : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SinCatalogo extends StatelessWidget {
  const _SinCatalogo();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 56, color: AppTheme.grisNeutro),
            SizedBox(height: 16),
            Text('Sin catálogo de equipo',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text(
              'El administrador todavía no ha dado de alta el equipo de esta '
              'caseta, o falta sincronizar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.grisNeutro, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
