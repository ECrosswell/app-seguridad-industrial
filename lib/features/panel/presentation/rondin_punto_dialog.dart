import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/sitio.dart';
import '../data/rondin_admin_models.dart';
import '../providers/panel_provider.dart';

Future<RespuestaPuntoRondin?> mostrarDialogoPuntoRondin(
  BuildContext context, {
  PuntoRondin? punto,
}) {
  return showDialog<RespuestaPuntoRondin>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _DialogoPuntoRondin(punto: punto),
  );
}

Future<void> mostrarDialogoAdministrarSecciones(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _DialogoAdministrarSecciones(),
  );
}

class _DialogoPuntoRondin extends ConsumerStatefulWidget {
  const _DialogoPuntoRondin({this.punto});

  final PuntoRondin? punto;

  @override
  ConsumerState<_DialogoPuntoRondin> createState() =>
      _DialogoPuntoRondinState();
}

class _DialogoPuntoRondinState extends ConsumerState<_DialogoPuntoRondin> {
  final _formulario = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _descripcion;
  late final TextEditingController _lat;
  late final TextEditingController _lng;
  late final TextEditingController _radio;
  late final TextEditingController _orden;
  late final TextEditingController _minutos;

  String? _sitioId;
  String? _seccionId;
  String? _wifiApId;
  bool _requiereLiveness = false;
  bool _activo = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final punto = widget.punto;
    _sitioId = punto?.sitioId ?? ref.read(sitioFiltroProvider);
    _seccionId = punto?.seccionId;
    _wifiApId = punto?.wifiApId;
    _requiereLiveness = punto?.requiereLiveness ?? false;
    _activo = punto?.activo ?? true;
    _nombre = TextEditingController(text: punto?.nombre ?? '');
    _descripcion = TextEditingController(text: punto?.descripcion ?? '');
    _lat = TextEditingController(text: punto?.lat?.toString() ?? '');
    _lng = TextEditingController(text: punto?.lng?.toString() ?? '');
    _radio = TextEditingController(text: '${punto?.radioMetros ?? 30}');
    _orden = TextEditingController(text: '${punto?.orden ?? 1}');
    _minutos = TextEditingController(
      text: '${punto?.minutosMinimosDesdeAnterior ?? 0}',
    );
  }

  @override
  void dispose() {
    for (final control in [
      _nombre,
      _descripcion,
      _lat,
      _lng,
      _radio,
      _orden,
      _minutos,
    ]) {
      control.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sitiosAsync = ref.watch(sitiosPanelProvider);
    final seccionesAsync = ref.watch(seccionesRondinPanelProvider(_sitioId));
    final wifiAsync = _sitioId == null
        ? const AsyncValue<List<Map<String, dynamic>>>.data([])
        : ref.watch(wifiApsPanelProvider(_sitioId!));

    final sitios = sitiosAsync.value ?? const <Sitio>[];
    if (_sitioId == null && sitios.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _sitioId == null) {
          setState(() => _sitioId = sitios.first.id);
        }
      });
    }

    final secciones = (seccionesAsync.value ?? const <SeccionRondin>[])
        .where((seccion) => seccion.activo || seccion.id == _seccionId)
        .toList();
    final aps = wifiAsync.value ?? const <Map<String, dynamic>>[];

    return AlertDialog(
      title: Text(widget.punto == null ? 'Nuevo punto QR' : 'Editar punto QR'),
      content: SizedBox(
        width: 720,
        child: Form(
          key: _formulario,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'El punto pertenece a una sección física de la planta. '
                  'Las coordenadas, el WiFi y el orden se usarán como señales '
                  'adicionales; el QR por sí solo no valida presencia.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.grisNeutro,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final sitio = DropdownButtonFormField<String>(
                      key: ValueKey('sitio-${_sitioId ?? 'ninguno'}'),
                      initialValue: sitios.any((item) => item.id == _sitioId)
                          ? _sitioId
                          : null,
                      decoration: const InputDecoration(labelText: 'Sitio *'),
                      items: [
                        for (final item in sitios.where(
                          (item) => item.activo || item.id == _sitioId,
                        ))
                          DropdownMenuItem(
                            value: item.id,
                            child: Text(item.nombre),
                          ),
                      ],
                      onChanged: _guardando
                          ? null
                          : (valor) => setState(() {
                              _sitioId = valor;
                              _seccionId = null;
                              _wifiApId = null;
                            }),
                      validator: (valor) =>
                          valor == null ? 'Selecciona el sitio' : null,
                    );
                    final seccion = Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            key: ValueKey(
                              'seccion-${_sitioId ?? 'sin-sitio'}-'
                              '${_seccionId ?? 'ninguna'}',
                            ),
                            initialValue:
                                secciones.any((item) => item.id == _seccionId)
                                ? _seccionId
                                : null,
                            decoration: const InputDecoration(
                              labelText: 'Sección de la fábrica *',
                            ),
                            items: [
                              for (final item in secciones)
                                DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.nombre),
                                ),
                            ],
                            onChanged: _guardando
                                ? null
                                : (valor) => setState(() => _seccionId = valor),
                            validator: (valor) => valor == null
                                ? 'Selecciona o crea una sección'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          tooltip: 'Crear sección',
                          onPressed: _sitioId == null || _guardando
                              ? null
                              : _crearSeccion,
                          icon: const Icon(Icons.add_business_outlined),
                        ),
                      ],
                    );

                    if (constraints.maxWidth < 570) {
                      return Column(
                        children: [sitio, const SizedBox(height: 12), seccion],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: sitio),
                        const SizedBox(width: 12),
                        Expanded(child: seccion),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nombre,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del punto *',
                    hintText: 'Ej. Puerta de almacén 2',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (valor) => valor == null || valor.trim().isEmpty
                      ? 'Captura el nombre del punto'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descripcion,
                  decoration: const InputDecoration(
                    labelText: 'Instrucciones',
                    hintText: 'Qué debe revisar el elemento al llegar',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final lat = TextFormField(
                      controller: _lat,
                      decoration: const InputDecoration(labelText: 'Latitud'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      validator: (valor) => _validarCoordenada(
                        valor,
                        otra: _lng.text,
                        min: -90,
                        max: 90,
                        nombre: 'latitud',
                      ),
                    );
                    final lng = TextFormField(
                      controller: _lng,
                      decoration: const InputDecoration(labelText: 'Longitud'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      validator: (valor) => _validarCoordenada(
                        valor,
                        otra: _lat.text,
                        min: -180,
                        max: 180,
                        nombre: 'longitud',
                      ),
                    );
                    final radio = TextFormField(
                      controller: _radio,
                      decoration: const InputDecoration(
                        labelText: 'Radio permitido (m) *',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (valor) {
                        final numero = int.tryParse(valor?.trim() ?? '');
                        if (numero == null || numero < 5 || numero > 1000) {
                          return 'Entre 5 y 1000 m';
                        }
                        return null;
                      },
                    );

                    if (constraints.maxWidth < 570) {
                      return Column(
                        children: [
                          lat,
                          const SizedBox(height: 12),
                          lng,
                          const SizedBox(height: 12),
                          radio,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: lat),
                        const SizedBox(width: 10),
                        Expanded(child: lng),
                        const SizedBox(width: 10),
                        Expanded(child: radio),
                      ],
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _guardando
                        ? null
                        : () => _usarCentroSitio(sitios),
                    icon: const Icon(Icons.my_location, size: 18),
                    label: const Text('Usar coordenadas del sitio'),
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String?>(
                  key: ValueKey(
                    'wifi-${_sitioId ?? 'sin-sitio'}-'
                    '${_wifiApId ?? 'ninguno'}',
                  ),
                  initialValue: aps.any((item) => item['id'] == _wifiApId)
                      ? _wifiApId
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'WiFi/BSSID de esta zona (opcional)',
                    helperText:
                        'Es una señal adicional; no reemplaza GPS, orden y tiempos.',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Ninguno'),
                    ),
                    for (final ap in aps)
                      DropdownMenuItem<String?>(
                        value: ap['id'] as String?,
                        child: Text(_etiquetaWifi(ap)),
                      ),
                  ],
                  onChanged: _guardando
                      ? null
                      : (valor) => setState(() => _wifiApId = valor),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final orden = TextFormField(
                      controller: _orden,
                      decoration: const InputDecoration(
                        labelText: 'Orden del rondín *',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (valor) {
                        final numero = int.tryParse(valor?.trim() ?? '');
                        return numero == null || numero < 1
                            ? 'Usa 1 o mayor'
                            : null;
                      },
                    );
                    final minutos = TextFormField(
                      controller: _minutos,
                      decoration: const InputDecoration(
                        labelText: 'Mínimo desde el anterior (min) *',
                        helperText: '0 para el primer punto',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (valor) {
                        final numero = int.tryParse(valor?.trim() ?? '');
                        return numero == null || numero < 0 || numero > 1440
                            ? 'Entre 0 y 1440 min'
                            : null;
                      },
                    );

                    if (constraints.maxWidth < 570) {
                      return Column(
                        children: [orden, const SizedBox(height: 12), minutos],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: orden),
                        const SizedBox(width: 12),
                        Expanded(child: minutos),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Pedir prueba de vida en este punto'),
                  subtitle: const Text(
                    'Añade evidencia de una persona presente, pero no sustituye '
                    'la comprobación de ubicación.',
                  ),
                  value: _requiereLiveness,
                  onChanged: _guardando
                      ? null
                      : (valor) => setState(() => _requiereLiveness = valor),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Punto activo'),
                  subtitle: const Text(
                    'Al desactivarlo deja de aparecer en rondines nuevos.',
                  ),
                  value: _activo,
                  onChanged: _guardando
                      ? null
                      : (valor) => setState(() => _activo = valor),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _guardando ? null : _guardar,
          icon: _guardando
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: Text(widget.punto == null ? 'Crear y generar QR' : 'Guardar'),
        ),
      ],
    );
  }

  Future<void> _crearSeccion() async {
    final creada = await _editarSeccion(context, sitioId: _sitioId!);
    if (creada == null || !mounted) return;
    ref.invalidate(seccionesRondinPanelProvider(_sitioId));
    setState(() => _seccionId = creada.id);
  }

  void _usarCentroSitio(List<Sitio> sitios) {
    final sitio = sitios.where((item) => item.id == _sitioId).firstOrNull;
    if (sitio?.lat == null || sitio?.lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El sitio todavía no tiene coordenadas capturadas.'),
          backgroundColor: AppTheme.ambarSeguridad,
        ),
      );
      return;
    }
    _lat.text = sitio!.lat!.toStringAsFixed(7);
    _lng.text = sitio.lng!.toStringAsFixed(7);
  }

  Future<void> _guardar() async {
    if (!_formulario.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      final respuesta = await ref
          .read(panelRepositoryProvider)
          .guardarPuntoRondin(
            puntoId: widget.punto?.id,
            sitioId: _sitioId!,
            seccionId: _seccionId!,
            nombre: _nombre.text,
            descripcion: _descripcion.text,
            lat: _lat.text.trim().isEmpty
                ? null
                : double.parse(_lat.text.trim()),
            lng: _lng.text.trim().isEmpty
                ? null
                : double.parse(_lng.text.trim()),
            radioMetros: int.parse(_radio.text.trim()),
            wifiApId: _wifiApId,
            requiereLiveness: _requiereLiveness,
            activo: _activo,
            orden: int.parse(_orden.text.trim()),
            segundosMinimosDesdeAnterior: int.parse(_minutos.text.trim()) * 60,
          );
      if (mounted) Navigator.of(context).pop(respuesta);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppTheme.rojoAlerta,
        ),
      );
      setState(() => _guardando = false);
    }
  }
}

class _DialogoAdministrarSecciones extends ConsumerStatefulWidget {
  const _DialogoAdministrarSecciones();

  @override
  ConsumerState<_DialogoAdministrarSecciones> createState() =>
      _DialogoAdministrarSeccionesState();
}

class _DialogoAdministrarSeccionesState
    extends ConsumerState<_DialogoAdministrarSecciones> {
  String? _sitioId;

  @override
  void initState() {
    super.initState();
    _sitioId = ref.read(sitioFiltroProvider);
  }

  @override
  Widget build(BuildContext context) {
    final sitios = ref.watch(sitiosPanelProvider).value ?? const <Sitio>[];
    if (_sitioId == null && sitios.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _sitioId == null) {
          setState(() => _sitioId = sitios.first.id);
        }
      });
    }
    final secciones = ref.watch(seccionesRondinPanelProvider(_sitioId));

    return AlertDialog(
      title: const Text('Secciones de la fábrica'),
      content: SizedBox(
        width: 620,
        height: 520,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    key: ValueKey('secciones-sitio-${_sitioId ?? 'ninguno'}'),
                    initialValue: sitios.any((item) => item.id == _sitioId)
                        ? _sitioId
                        : null,
                    decoration: const InputDecoration(labelText: 'Sitio'),
                    items: [
                      for (final sitio in sitios)
                        DropdownMenuItem(
                          value: sitio.id,
                          child: Text(sitio.nombre),
                        ),
                    ],
                    onChanged: (valor) => setState(() => _sitioId = valor),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  tooltip: 'Nueva sección',
                  onPressed: _sitioId == null ? null : () => _nuevaSeccion(),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Usa secciones físicas reconocibles: nave, almacén, patio, '
              'cuarto eléctrico o perímetro. Desactivar conserva el historial.',
              style: TextStyle(
                fontSize: 12.5,
                color: AppTheme.grisNeutro,
                height: 1.4,
              ),
            ),
            const Divider(height: 28),
            Expanded(
              child: secciones.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
                data: (lista) {
                  if (lista.isEmpty) {
                    return const Center(
                      child: Text('Aún no hay secciones en este sitio.'),
                    );
                  }
                  return ListView.separated(
                    itemCount: lista.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, indice) {
                      final seccion = lista[indice];
                      return ListTile(
                        leading: Icon(
                          seccion.activo
                              ? Icons.domain_outlined
                              : Icons.hide_source_outlined,
                          color: seccion.activo
                              ? AppTheme.azulAcero
                              : AppTheme.grisNeutro,
                        ),
                        title: Text(seccion.nombre),
                        subtitle: Text(
                          seccion.descripcion.isEmpty
                              ? (seccion.activo ? 'Activa' : 'Inactiva')
                              : seccion.descripcion,
                        ),
                        trailing: IconButton(
                          tooltip: 'Editar sección',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _modificarSeccion(seccion),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  Future<void> _nuevaSeccion() async {
    final creada = await _editarSeccion(context, sitioId: _sitioId!);
    if (creada != null && mounted) {
      ref.invalidate(seccionesRondinPanelProvider(_sitioId));
    }
  }

  Future<void> _modificarSeccion(SeccionRondin seccion) async {
    final guardada = await _editarSeccion(
      context,
      sitioId: seccion.sitioId,
      seccion: seccion,
    );
    if (guardada != null && mounted) {
      ref.invalidate(seccionesRondinPanelProvider(_sitioId));
      ref.invalidate(puntosRondinPanelProvider);
    }
  }
}

Future<SeccionRondin?> _editarSeccion(
  BuildContext context, {
  required String sitioId,
  SeccionRondin? seccion,
}) {
  return showDialog<SeccionRondin>(
    context: context,
    builder: (_) => _DialogoSeccion(sitioId: sitioId, seccion: seccion),
  );
}

class _DialogoSeccion extends ConsumerStatefulWidget {
  const _DialogoSeccion({required this.sitioId, this.seccion});

  final String sitioId;
  final SeccionRondin? seccion;

  @override
  ConsumerState<_DialogoSeccion> createState() => _DialogoSeccionState();
}

class _DialogoSeccionState extends ConsumerState<_DialogoSeccion> {
  late final TextEditingController _nombre;
  late final TextEditingController _descripcion;
  late bool _activo;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.seccion?.nombre ?? '');
    _descripcion = TextEditingController(
      text: widget.seccion?.descripcion ?? '',
    );
    _activo = widget.seccion?.activo ?? true;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.seccion == null ? 'Nueva sección' : 'Editar sección'),
      content: SizedBox(
        width: 430,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombre,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Nombre *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcion,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sección activa'),
              value: _activo,
              onChanged: _guardando
                  ? null
                  : (valor) => setState(() => _activo = valor),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardando ? null : _guardar,
          child: _guardando
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _guardar() async {
    if (_nombre.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Captura el nombre de la sección.')),
      );
      return;
    }
    setState(() => _guardando = true);
    try {
      final guardada = await ref
          .read(panelRepositoryProvider)
          .guardarSeccionRondin({
            'id': widget.seccion?.id,
            'sitio_id': widget.sitioId,
            'nombre': _nombre.text.trim(),
            'descripcion': _descripcion.text.trim(),
            'activo': _activo,
          });
      if (mounted) Navigator.of(context).pop(guardada);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar la sección: $error'),
          backgroundColor: AppTheme.rojoAlerta,
        ),
      );
      setState(() => _guardando = false);
    }
  }
}

String? _validarCoordenada(
  String? valor, {
  required String otra,
  required double min,
  required double max,
  required String nombre,
}) {
  final texto = valor?.trim() ?? '';
  if (texto.isEmpty) {
    return otra.trim().isEmpty ? null : 'Falta la $nombre';
  }
  final numero = double.tryParse(texto);
  if (numero == null || numero < min || numero > max) {
    return '$nombre inválida';
  }
  return null;
}

String _etiquetaWifi(Map<String, dynamic> ap) {
  final zona = ap['nombre_zona'] as String? ?? '';
  final ssid = ap['ssid'] as String? ?? '';
  final bssid = ap['bssid'] as String? ?? '';
  return [
    zona,
    ssid,
    bssid,
  ].where((valor) => valor.trim().isNotEmpty).join(' · ');
}
