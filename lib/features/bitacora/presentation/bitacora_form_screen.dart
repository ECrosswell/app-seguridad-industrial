import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/remote/foto_service.dart';
import '../../accesos/providers/accesos_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/bitacora_provider.dart';

/// Alta de un evento de bitácora.
///
/// El formulario se adapta al tipo elegido. En movimientos de mercancía las
/// placas, el destino y quién autorizó son **obligatorios** — y no por decisión
/// de esta pantalla: la base tiene un CHECK que rechaza la fila sin ellos. Si
/// la UI no los pidiera, el registro se guardaría local y fallaría al subir,
/// que es la peor forma de descubrirlo.
class BitacoraFormScreen extends ConsumerStatefulWidget {
  const BitacoraFormScreen({super.key});

  @override
  ConsumerState<BitacoraFormScreen> createState() => _BitacoraFormScreenState();
}

class _BitacoraFormScreenState extends ConsumerState<BitacoraFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descripcion = TextEditingController();
  final _placas = TextEditingController();
  final _transportista = TextEditingController();
  final _empresaTransporte = TextEditingController();
  final _numDocumento = TextEditingController();
  final _destino = TextEditingController();
  final _autorizadoTexto = TextEditingController();

  TipoEventoBitacora _tipo = TipoEventoBitacora.libre;
  Prioridad _prioridad = Prioridad.normal;
  String? _autorizadoPorId;
  final List<String> _fotos = [];
  bool _guardando = false;

  @override
  void dispose() {
    for (final c in [
      _descripcion, _placas, _transportista, _empresaTransporte,
      _numDocumento, _destino, _autorizadoTexto,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _esMercancia => _tipo.requierePlacas;

  @override
  Widget build(BuildContext context) {
    final personal = ref.watch(personalClienteProvider).value ?? const [];
    final sitioId = ref.watch(sitioOperativoProvider);
    final fechaTurno = ref.watch(turnoFechaActualProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo evento')),
      body: (sitioId == null || fechaTurno == null)
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'Registra tu entrada antes de capturar eventos de bitácora.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.grisNeutro),
                ),
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                children: [
                  DropdownButtonFormField<TipoEventoBitacora>(
                    initialValue: _tipo,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de evento',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: [
                      for (final t in TipoEventoBitacora.values)
                        DropdownMenuItem(value: t, child: Text(t.etiqueta)),
                    ],
                    onChanged: (v) => setState(() {
                      _tipo = v ?? TipoEventoBitacora.libre;
                      // Las fallas e incidentes entran como prioridad alta por
                      // defecto: son los que no deben pasar desapercibidos.
                      if (_tipo.abrePendiente && _prioridad == Prioridad.normal) {
                        _prioridad = Prioridad.alta;
                      }
                    }),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _descripcion,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Descripción *',
                      alignLabelWithHint: true,
                      hintText: 'Qué pasó, dónde y con quién',
                    ),
                    validator: (v) => (v == null || v.trim().length < 5)
                        ? 'Describe el evento'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  if (_esMercancia) ...[
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: AppTheme.ambarSeguridad.withValues(alpha: 0.11),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 19, color: AppTheme.ambarSeguridad),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'En movimientos de mercancía son obligatorias las '
                              'placas, el destino y quién autorizó.',
                              style: TextStyle(fontSize: 12.5, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  if (_esMercancia ||
                      _tipo == TipoEventoBitacora.entradaVehiculo ||
                      _tipo == TipoEventoBitacora.salidaVehiculo) ...[
                    TextFormField(
                      controller: _placas,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: _esMercancia ? 'Placas *' : 'Placas',
                        prefixIcon: const Icon(Icons.pin_outlined),
                      ),
                      validator: (v) =>
                          (_esMercancia && (v == null || v.trim().length < 5))
                              ? 'Captura las placas'
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _transportista,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Operador / transportista',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _empresaTransporte,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Empresa de transporte',
                        prefixIcon: Icon(Icons.local_shipping_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  if (_esMercancia) ...[
                    TextFormField(
                      controller: _destino,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Destino *',
                        hintText: 'A dónde va la mercancía',
                        prefixIcon: Icon(Icons.place_outlined),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Indica el destino'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _numDocumento,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Remisión / factura / orden',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    if (personal.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue: _autorizadoPorId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Autorizado por *',
                          prefixIcon: Icon(Icons.how_to_reg_outlined),
                        ),
                        items: [
                          for (final p in personal)
                            DropdownMenuItem(
                              value: p.id,
                              child: Text(
                                p.area.isEmpty
                                    ? p.nombreCompleto
                                    : '${p.nombreCompleto} · ${p.area}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (v) => setState(() {
                          _autorizadoPorId = v;
                          final elegido = personal.where((p) => p.id == v);
                          _autorizadoTexto.text = elegido.isEmpty
                              ? ''
                              : elegido.first.nombreCompleto;
                        }),
                        validator: (v) =>
                            v == null ? 'Indica quién autorizó' : null,
                      )
                    else
                      TextFormField(
                        controller: _autorizadoTexto,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Autorizado por *',
                          helperText:
                              'El cliente aún no ha capturado su directorio',
                          prefixIcon: Icon(Icons.how_to_reg_outlined),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Indica quién autorizó'
                            : null,
                      ),
                    const SizedBox(height: 14),
                  ],

                  DropdownButtonFormField<Prioridad>(
                    initialValue: _prioridad,
                    decoration: const InputDecoration(
                      labelText: 'Prioridad',
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                    items: [
                      for (final p in Prioridad.values)
                        DropdownMenuItem(value: p, child: Text(p.etiqueta)),
                    ],
                    onChanged: (v) =>
                        setState(() => _prioridad = v ?? Prioridad.normal),
                  ),

                  const SizedBox(height: 20),
                  _Fotos(
                    rutas: _fotos,
                    onAgregar: _agregarFoto,
                    onQuitar: (i) => setState(() => _fotos.removeAt(i)),
                  ),

                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _guardando
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
                    label: const Text('Guardar evento'),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _agregarFoto() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (imagen == null) return;

    final comprimida = await FotoService.comprimirYGuardar(imagen.path);
    if (!mounted) return;
    setState(() => _fotos.add(comprimida ?? imagen.path));
  }

  Future<void> _guardar(String sitioId, DateTime fechaTurno) async {
    if (!_formKey.currentState!.validate()) return;

    final perfil = ref.read(perfilActualProvider);
    if (perfil == null) return;

    setState(() => _guardando = true);

    try {
      await ref.read(bitacoraRepositoryProvider).registrarEvento(
            sitioId: sitioId,
            registradoPor: perfil.id,
            turnoFecha: fechaTurno,
            tipo: _tipo,
            descripcion: _descripcion.text.trim(),
            placas: _placas.text.trim(),
            transportista: _transportista.text.trim(),
            empresaTransporte: _empresaTransporte.text.trim(),
            numDocumento: _numDocumento.text.trim(),
            destino: _destino.text.trim(),
            autorizadoPorId: _autorizadoPorId,
            autorizadoPorTexto: _autorizadoTexto.text.trim(),
            prioridad: _prioridad,
            fotosRutasLocales: _fotos,
          );

      unawaited(ref.read(syncEngineProvider).sincronizarAhora());

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento registrado'),
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

class _Fotos extends StatelessWidget {
  const _Fotos({
    required this.rutas,
    required this.onAgregar,
    required this.onQuitar,
  });

  final List<String> rutas;
  final VoidCallback onAgregar;
  final ValueChanged<int> onQuitar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('Evidencia fotográfica',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const Spacer(),
            TextButton.icon(
              onPressed: onAgregar,
              icon: const Icon(Icons.add_a_photo_outlined, size: 19),
              label: const Text('Agregar'),
            ),
          ],
        ),
        if (rutas.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: rutas.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(rutas[i]),
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => onQuitar(i),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
