import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/sitio.dart';
import '../providers/panel_provider.dart';

/// Administración de sitios: geocerca, WiFi autorizado, catálogo de equipo y
/// directorio del cliente.
///
/// Aquí es donde el administrador captura las coordenadas de la fábrica
/// parándose físicamente en la puerta, que es la forma de que la geocerca
/// coincida con el punto de control real y no con el centroide del predio.
class PanelSitiosScreen extends ConsumerWidget {
  const PanelSitiosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitios = ref.watch(sitiosPanelProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editarSitio(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo sitio'),
      ),
      body: sitios.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lista) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
          children: [
            const Text('Sitios',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            for (final s in lista) _TarjetaSitio(sitio: s),
          ],
        ),
      ),
    );
  }

  static Future<void> _editarSitio(
      BuildContext context, WidgetRef ref, Sitio? sitio) async {
    await showDialog(
      context: context,
      builder: (_) => _DialogoSitio(sitio: sitio),
    );
    if (context.mounted) ref.invalidate(sitiosPanelProvider);
  }
}

class _TarjetaSitio extends ConsumerWidget {
  const _TarjetaSitio({required this.sitio});

  final Sitio sitio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aps = ref.watch(wifiApsPanelProvider(sitio.id));
    final equipo = ref.watch(catalogoEquipoPanelProvider(sitio.id));
    final personal = ref.watch(personalClientePanelProvider(sitio.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sitio.nombre,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      Text(
                        'Turno ${sitio.horaInicioTurno} · retardo +${sitio.minutosToleranciaRetardo} min · '
                        'falta +${sitio.minutosToleranciaFalta} min · '
                        'alerta relevo +${sitio.minutosAlertaRelevo} min',
                        style: const TextStyle(
                            fontSize: 12.5, color: AppTheme.grisNeutro),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      PanelSitiosScreen._editarSitio(context, ref, sitio),
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Editar',
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Geocerca
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: sitio.tieneGeocerca
                    ? AppTheme.verdeOperativo.withValues(alpha: 0.07)
                    : AppTheme.ambarSeguridad.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    sitio.tieneGeocerca
                        ? Icons.gps_fixed
                        : Icons.gps_off_outlined,
                    color: sitio.tieneGeocerca
                        ? AppTheme.verdeOperativo
                        : AppTheme.ambarSeguridad,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      sitio.tieneGeocerca
                          ? 'Geocerca: ${sitio.lat!.toStringAsFixed(6)}, '
                              '${sitio.lng!.toStringAsFixed(6)} · radio ${sitio.radioMetros} m'
                          : 'Sin geocerca. Mientras no se capture, la asistencia '
                              'sólo puede validarse por el WiFi de la planta.',
                      style: const TextStyle(fontSize: 13, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 12,
              children: [
                _Contador(
                  etiqueta: 'Access points WiFi',
                  valor: aps.value?.length,
                  onTap: () => _gestionarAps(context, ref),
                ),
                _Contador(
                  etiqueta: 'Partidas de equipo',
                  valor: equipo.value?.length,
                  onTap: () => _gestionarEquipo(context, ref),
                ),
                _Contador(
                  etiqueta: 'Directorio del cliente',
                  valor: personal.value?.length,
                  onTap: () => _gestionarPersonal(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _gestionarAps(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (_) => _DialogoLista(
        titulo: 'Access points de ${sitio.nombre}',
        descripcion:
            'El BSSID es la MAC del access point. Validar contra él impide que '
            'alguien levante un hotspot con el mismo nombre de red desde fuera.',
        provider: wifiApsPanelProvider(sitio.id),
        campos: const [
          _Campo('bssid', 'BSSID (00:11:22:33:44:55)', requerido: true),
          _Campo('ssid', 'Nombre de la red'),
          _Campo('nombre_zona', 'Zona (caseta, almacén…)'),
        ],
        titulo1: (m) => m['bssid'] as String? ?? '',
        titulo2: (m) => [m['ssid'], m['nombre_zona']]
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .join(' · '),
        onGuardar: (datos) => ref
            .read(panelRepositoryProvider)
            .guardarWifiAp({...datos, 'sitio_id': sitio.id}),
      ),
    );
    if (context.mounted) ref.invalidate(wifiApsPanelProvider(sitio.id));
  }

  Future<void> _gestionarEquipo(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (_) => _DialogoLista(
        titulo: 'Equipo de ${sitio.nombre}',
        descripcion:
            'El equipo se asigna a la caseta, no al elemento: la misma escopeta '
            'la usan ambos turnos.',
        provider: catalogoEquipoPanelProvider(sitio.id),
        campos: const [
          _Campo('nombre', 'Nombre', requerido: true),
          _Campo('descripcion', 'Descripción'),
          _Campo('cantidad_esperada', 'Cantidad esperada', numerico: true),
        ],
        titulo1: (m) => m['nombre'] as String? ?? '',
        titulo2: (m) =>
            'Cantidad ${m['cantidad_esperada']} · ${m['categoria']}',
        onGuardar: (datos) =>
            ref.read(panelRepositoryProvider).guardarEquipo({
          ...datos,
          'sitio_id': sitio.id,
          'cantidad_esperada':
              int.tryParse(datos['cantidad_esperada']?.toString() ?? '1') ?? 1,
        }),
      ),
    );
    if (context.mounted) ref.invalidate(catalogoEquipoPanelProvider(sitio.id));
  }

  Future<void> _gestionarPersonal(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (_) => _DialogoLista(
        titulo: 'Directorio de ${sitio.nombre}',
        descripcion:
            'Personal de la fábrica al que se puede visitar. Mientras esté '
            'vacío, el elemento captura el nombre a mano.',
        provider: personalClientePanelProvider(sitio.id),
        campos: const [
          _Campo('nombre_completo', 'Nombre completo', requerido: true),
          _Campo('area', 'Área'),
          _Campo('puesto', 'Puesto'),
          _Campo('extension', 'Extensión'),
        ],
        titulo1: (m) => m['nombre_completo'] as String? ?? '',
        titulo2: (m) => [m['area'], m['puesto']]
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .join(' · '),
        onGuardar: (datos) => ref
            .read(panelRepositoryProvider)
            .guardarPersonalCliente({...datos, 'sitio_id': sitio.id}),
      ),
    );
    if (context.mounted) ref.invalidate(personalClientePanelProvider(sitio.id));
  }
}

class _Contador extends StatelessWidget {
  const _Contador({
    required this.etiqueta,
    required this.valor,
    required this.onTap,
  });

  final String etiqueta;
  final int? valor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${valor ?? '—'}',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Text(etiqueta,
                style: const TextStyle(
                    fontSize: 12.5, color: AppTheme.grisNeutro)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18, color: AppTheme.grisNeutro),
          ],
        ),
      ),
    );
  }
}

// ─── Diálogo de alta/edición de sitio ────────────────────────────────────────

class _DialogoSitio extends ConsumerStatefulWidget {
  const _DialogoSitio({this.sitio});

  final Sitio? sitio;

  @override
  ConsumerState<_DialogoSitio> createState() => _DialogoSitioState();
}

class _DialogoSitioState extends ConsumerState<_DialogoSitio> {
  late final TextEditingController _nombre;
  late final TextEditingController _direccion;
  late final TextEditingController _lat;
  late final TextEditingController _lng;
  late final TextEditingController _radio;
  late final TextEditingController _hora;
  late final TextEditingController _retardo;
  late final TextEditingController _falta;
  late final TextEditingController _relevo;

  bool _ubicando = false;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final s = widget.sitio;
    _nombre = TextEditingController(text: s?.nombre ?? '');
    _direccion = TextEditingController(text: s?.direccion ?? '');
    _lat = TextEditingController(text: s?.lat?.toString() ?? '');
    _lng = TextEditingController(text: s?.lng?.toString() ?? '');
    _radio = TextEditingController(text: '${s?.radioMetros ?? 150}');
    _hora = TextEditingController(text: s?.horaInicioTurno ?? '08:00');
    _retardo = TextEditingController(text: '${s?.minutosToleranciaRetardo ?? 1}');
    _falta = TextEditingController(text: '${s?.minutosToleranciaFalta ?? 90}');
    _relevo = TextEditingController(text: '${s?.minutosAlertaRelevo ?? 60}');
  }

  @override
  void dispose() {
    for (final c in [
      _nombre, _direccion, _lat, _lng, _radio, _hora, _retardo, _falta, _relevo,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _usarUbicacionActual() async {
    setState(() => _ubicando = true);
    try {
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        throw 'Permiso de ubicación denegado';
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best, timeLimit: Duration(seconds: 20)),
      );

      if (!mounted) return;
      setState(() {
        _lat.text = pos.latitude.toStringAsFixed(7);
        _lng.text = pos.longitude.toStringAsFixed(7);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ubicación capturada con precisión de ±${pos.accuracy.round()} m'),
          backgroundColor: AppTheme.verdeOperativo,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No se pudo obtener la ubicación: $e'),
              backgroundColor: AppTheme.rojoAlerta),
        );
      }
    } finally {
      if (mounted) setState(() => _ubicando = false);
    }
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    try {
      await ref.read(panelRepositoryProvider).guardarSitio({
        'id': widget.sitio?.id,
        'nombre': _nombre.text.trim(),
        'direccion': _direccion.text.trim(),
        'lat': double.tryParse(_lat.text.trim()),
        'lng': double.tryParse(_lng.text.trim()),
        'radio_metros': int.tryParse(_radio.text.trim()) ?? 150,
        'hora_inicio_turno': _hora.text.trim(),
        'minutos_tolerancia_retardo': int.tryParse(_retardo.text.trim()) ?? 1,
        'minutos_tolerancia_falta': int.tryParse(_falta.text.trim()) ?? 90,
        'minutos_alerta_relevo': int.tryParse(_relevo.text.trim()) ?? 60,
      });
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No se pudo guardar: $e'),
              backgroundColor: AppTheme.rojoAlerta),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.sitio == null ? 'Nuevo sitio' : 'Editar sitio'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _direccion,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),

              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Geocerca',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Párate en la puerta de la planta y usa el botón: así la '
                  'geocerca queda en el punto de control real.',
                  style: TextStyle(fontSize: 12, color: AppTheme.grisNeutro),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lat,
                      decoration: const InputDecoration(labelText: 'Latitud'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _lng,
                      decoration: const InputDecoration(labelText: 'Longitud'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _ubicando ? null : _usarUbicacionActual,
                icon: _ubicando
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location, size: 18),
                label: const Text('Usar mi ubicación actual'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _radio,
                decoration: const InputDecoration(
                  labelText: 'Radio en metros',
                  helperText: 'Cuánto puede alejarse y seguir contando como dentro',
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Turno',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _hora,
                decoration: const InputDecoration(
                  labelText: 'Hora de inicio (HH:MM)',
                  helperText: 'El turno dura 24 h desde esta hora',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _retardo,
                decoration: const InputDecoration(
                  labelText: 'Minutos para retardo',
                  helperText: '1 = a partir de las 08:01',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _falta,
                decoration: const InputDecoration(
                  labelText: 'Minutos para falta',
                  helperText: '90 = a partir de las 09:30',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _relevo,
                decoration: const InputDecoration(
                  labelText: 'Minutos para alertar relevo',
                  helperText: '60 = si a las 09:00 no llegó nadie, se alerta',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar')),
        FilledButton(
          onPressed: _guardando ? null : _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

// ─── Diálogo genérico para catálogos ─────────────────────────────────────────

class _Campo {
  const _Campo(this.clave, this.etiqueta,
      {this.requerido = false, this.numerico = false});

  final String clave;
  final String etiqueta;
  final bool requerido;
  final bool numerico;
}

class _DialogoLista extends ConsumerStatefulWidget {
  const _DialogoLista({
    required this.titulo,
    required this.descripcion,
    required this.provider,
    required this.campos,
    required this.titulo1,
    required this.titulo2,
    required this.onGuardar,
  });

  final String titulo;
  final String descripcion;
  final FutureProvider<List<Map<String, dynamic>>> provider;
  final List<_Campo> campos;
  final String Function(Map<String, dynamic>) titulo1;
  final String Function(Map<String, dynamic>) titulo2;
  final Future<void> Function(Map<String, dynamic>) onGuardar;

  @override
  ConsumerState<_DialogoLista> createState() => _DialogoListaState();
}

class _DialogoListaState extends ConsumerState<_DialogoLista> {
  final Map<String, TextEditingController> _controles = {};
  String? _editandoId;

  @override
  void initState() {
    super.initState();
    for (final c in widget.campos) {
      _controles[c.clave] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controles.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _cargar(Map<String, dynamic> item) {
    setState(() {
      _editandoId = item['id'] as String?;
      for (final c in widget.campos) {
        _controles[c.clave]!.text = item[c.clave]?.toString() ?? '';
      }
    });
  }

  void _limpiar() {
    setState(() {
      _editandoId = null;
      for (final c in _controles.values) {
        c.clear();
      }
    });
  }

  Future<void> _guardar() async {
    final faltantes = widget.campos
        .where((c) => c.requerido && _controles[c.clave]!.text.trim().isEmpty);
    if (faltantes.isNotEmpty) return;

    final datos = <String, dynamic>{'id': _editandoId};
    for (final c in widget.campos) {
      datos[c.clave] = _controles[c.clave]!.text.trim();
    }

    await widget.onGuardar(datos);
    if (!mounted) return;
    _limpiar();
    ref.invalidate(widget.provider);
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(widget.provider);

    return AlertDialog(
      title: Text(widget.titulo),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.descripcion,
                  style: const TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.grisNeutro,
                      height: 1.35)),
              const SizedBox(height: 18),

              for (final c in widget.campos) ...[
                TextField(
                  controller: _controles[c.clave],
                  decoration: InputDecoration(
                    labelText: c.requerido ? '${c.etiqueta} *' : c.etiqueta,
                    isDense: true,
                  ),
                  keyboardType:
                      c.numerico ? TextInputType.number : TextInputType.text,
                ),
                const SizedBox(height: 10),
              ],

              Row(
                children: [
                  if (_editandoId != null)
                    TextButton(
                        onPressed: _limpiar, child: const Text('Cancelar edición')),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _guardar,
                    icon: Icon(_editandoId == null ? Icons.add : Icons.save,
                        size: 18),
                    label: Text(_editandoId == null ? 'Agregar' : 'Guardar'),
                  ),
                ],
              ),

              const Divider(height: 28),

              items.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (lista) {
                  if (lista.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('Todavía no hay registros')),
                    );
                  }
                  return Column(
                    children: [
                      for (final item in lista)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(widget.titulo1(item)),
                          subtitle: Text(widget.titulo2(item),
                              style: const TextStyle(fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () => _cargar(item),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar')),
      ],
    );
  }
}
