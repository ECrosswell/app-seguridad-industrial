import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/remote/foto_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/accesos_provider.dart';

/// Alta de un visitante.
///
/// El orden de los campos sigue el de la conversación real en la caseta:
/// primero quién eres, luego con quién vas y a qué, después el vehículo, y al
/// final la identificación — que es opcional y es lo único que requiere
/// consentimiento.
class AccesoFormScreen extends ConsumerStatefulWidget {
  const AccesoFormScreen({super.key});

  @override
  ConsumerState<AccesoFormScreen> createState() => _AccesoFormScreenState();
}

class _AccesoFormScreenState extends ConsumerState<AccesoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombre = TextEditingController();
  final _empresa = TextEditingController();
  final _telefono = TextEditingController();
  final _asunto = TextEditingController();
  final _personaTexto = TextEditingController();
  final _placas = TextEditingController();
  final _marca = TextEditingController();
  final _modelo = TextEditingController();
  final _color = TextEditingController();
  final _observaciones = TextEditingController();

  String? _personaVisitadaId;
  bool _ingresaVehiculo = false;
  bool _guardarFrecuente = false;
  bool _avisoAceptado = false;
  TipoIdentificacion _tipoIdentificacion = TipoIdentificacion.ninguna;
  String? _rutaIdentificacion;
  String? _visitanteLocalId;

  bool _guardando = false;

  @override
  void dispose() {
    for (final c in [
      _nombre, _empresa, _telefono, _asunto, _personaTexto,
      _placas, _marca, _modelo, _color, _observaciones,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personal = ref.watch(personalClienteProvider).value ?? const [];
    final aviso = ref.watch(avisoVigenteProvider).value;
    final sitioId = ref.watch(sitioOperativoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar visitante')),
      body: sitioId == null
          ? const _SinSitio()
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                children: [
                  _Seccion(titulo: 'Quién llega'),
                  _BuscadorFrecuentes(onSeleccionar: _precargarVisitante),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _nombre,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'Captura el nombre completo'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _empresa,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Empresa o procedencia',
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _telefono,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),

                  const SizedBox(height: 24),
                  _Seccion(titulo: 'Con quién va y a qué'),

                  // Si el cliente ya pobló su catálogo, se elige de la lista;
                  // si no, cae a texto libre para no bloquear la operación.
                  if (personal.isNotEmpty)
                    DropdownButtonFormField<String>(
                      initialValue: _personaVisitadaId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'A quién visita *',
                        prefixIcon: Icon(Icons.person_search_outlined),
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
                        _personaVisitadaId = v;
                        final elegido = personal.where((p) => p.id == v);
                        _personaTexto.text =
                            elegido.isEmpty ? '' : elegido.first.nombreCompleto;
                      }),
                      validator: (v) =>
                          v == null ? 'Indica a quién visita' : null,
                    )
                  else
                    TextFormField(
                      controller: _personaTexto,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'A quién visita *',
                        helperText:
                            'El cliente aún no ha capturado su directorio',
                        prefixIcon: Icon(Icons.person_search_outlined),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Indica a quién visita'
                          : null,
                    ),

                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _asunto,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Asunto *',
                      prefixIcon: Icon(Icons.assignment_outlined),
                    ),
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'Describe el motivo de la visita'
                        : null,
                  ),

                  const SizedBox(height: 24),
                  _Seccion(titulo: 'Vehículo'),
                  SwitchListTile(
                    value: _ingresaVehiculo,
                    onChanged: (v) => setState(() => _ingresaVehiculo = v),
                    title: const Text('Ingresa con vehículo'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_ingresaVehiculo) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _placas,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Placas *',
                        prefixIcon: Icon(Icons.pin_outlined),
                      ),
                      validator: (v) => (_ingresaVehiculo &&
                              (v == null || v.trim().length < 5))
                          ? 'Captura las placas'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _marca,
                            textCapitalization: TextCapitalization.words,
                            decoration:
                                const InputDecoration(labelText: 'Marca'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _color,
                            textCapitalization: TextCapitalization.words,
                            decoration:
                                const InputDecoration(labelText: 'Color'),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),
                  _Seccion(titulo: 'Identificación (opcional)'),
                  _CapturaIdentificacion(
                    tipo: _tipoIdentificacion,
                    ruta: _rutaIdentificacion,
                    aviso: aviso,
                    avisoAceptado: _avisoAceptado,
                    onTipo: (t) => setState(() => _tipoIdentificacion = t),
                    onFoto: _tomarIdentificacion,
                    onQuitarFoto: () => setState(() {
                      _rutaIdentificacion = null;
                      _avisoAceptado = false;
                    }),
                    onAceptarAviso: (v) => setState(() => _avisoAceptado = v),
                  ),

                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _observaciones,
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: _guardarFrecuente,
                    onChanged: (v) =>
                        setState(() => _guardarFrecuente = v ?? false),
                    title: const Text('Guardar como visitante frecuente'),
                    subtitle: const Text(
                        'Para no recapturar sus datos la próxima vez',
                        style: TextStyle(fontSize: 12)),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _guardando ? null : () => _guardar(sitioId),
                    icon: _guardando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Registrar entrada'),
                  ),
                ],
              ),
            ),
    );
  }

  void _precargarVisitante(LocalVisitante v) {
    setState(() {
      _visitanteLocalId = v.localId;
      _nombre.text = v.nombreCompleto;
      _empresa.text = v.empresa;
      _telefono.text = v.telefono;
      if (v.placasHabituales.isNotEmpty) {
        _ingresaVehiculo = true;
        _placas.text = v.placasHabituales;
      }
    });

    if (v.vetado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ATENCIÓN: visitante vetado. ${v.motivoVeto}'),
          backgroundColor: AppTheme.rojoAlerta,
          duration: const Duration(seconds: 8),
        ),
      );
    }
  }

  Future<void> _tomarIdentificacion() async {
    final imagen = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (imagen == null) return;

    final comprimida = await FotoService.comprimirYGuardar(imagen.path);
    if (!mounted) return;
    setState(() => _rutaIdentificacion = comprimida ?? imagen.path);
  }

  Future<void> _guardar(String sitioId) async {
    if (!_formKey.currentState!.validate()) return;

    // El consentimiento es condición para conservar la imagen. Sin aceptación
    // no se guarda la foto — es requisito de la LFPDPPP, no una preferencia.
    if (_rutaIdentificacion != null && !_avisoAceptado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'El visitante debe aceptar el aviso de privacidad para conservar '
              'la foto de su identificación.'),
          backgroundColor: AppTheme.ambarSeguridad,
        ),
      );
      return;
    }

    final perfil = ref.read(perfilActualProvider);
    if (perfil == null) return;

    setState(() => _guardando = true);

    try {
      final repo = ref.read(accesosRepositoryProvider);

      var visitanteId = _visitanteLocalId;
      if (_guardarFrecuente && visitanteId == null) {
        visitanteId = await repo.guardarVisitanteFrecuente(
          nombreCompleto: _nombre.text.trim(),
          empresa: _empresa.text.trim(),
          telefono: _telefono.text.trim(),
          placasHabituales: _placas.text.trim(),
        );
      }

      final aviso = ref.read(avisoVigenteProvider).value;

      await repo.registrarEntrada(
        sitioId: sitioId,
        registradoPor: perfil.id,
        nombreCompleto: _nombre.text.trim(),
        asunto: _asunto.text.trim(),
        empresaProcedencia: _empresa.text.trim(),
        telefono: _telefono.text.trim(),
        personaVisitadaId: _personaVisitadaId,
        personaVisitadaTexto: _personaTexto.text.trim(),
        ingresaVehiculo: _ingresaVehiculo,
        placas: _placas.text.trim(),
        vehiculoMarca: _marca.text.trim(),
        vehiculoModelo: _modelo.text.trim(),
        vehiculoColor: _color.text.trim(),
        identificacionTipo: _tipoIdentificacion.valor,
        identificacionRutaLocal: _rutaIdentificacion,
        avisoPrivacidadId: aviso?.id,
        avisoAceptado: _avisoAceptado,
        visitanteLocalId: visitanteId,
        observaciones: _observaciones.text.trim(),
      );

      unawaited(ref.read(syncEngineProvider).sincronizarAhora());

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nombre.text.trim()} registrado'),
          backgroundColor: AppTheme.verdeOperativo,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo registrar: $e'),
          backgroundColor: AppTheme.rojoAlerta,
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _BuscadorFrecuentes extends ConsumerStatefulWidget {
  const _BuscadorFrecuentes({required this.onSeleccionar});

  final void Function(LocalVisitante) onSeleccionar;

  @override
  ConsumerState<_BuscadorFrecuentes> createState() =>
      _BuscadorFrecuentesState();
}

class _BuscadorFrecuentesState extends ConsumerState<_BuscadorFrecuentes> {
  String _texto = '';

  @override
  Widget build(BuildContext context) {
    final resultados = _texto.trim().length < 2
        ? const <LocalVisitante>[]
        : (ref.watch(busquedaVisitantesProvider(_texto)).value ?? const []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          onChanged: (v) => setState(() => _texto = v),
          decoration: const InputDecoration(
            labelText: 'Buscar visitante frecuente',
            hintText: 'Nombre, empresa o placas',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        if (resultados.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.grisNeutro.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (final v in resultados)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      v.vetado ? Icons.block : Icons.person_outline,
                      color: v.vetado ? AppTheme.rojoAlerta : null,
                    ),
                    title: Text(v.nombreCompleto),
                    subtitle: Text(
                      [v.empresa, v.placasHabituales]
                          .where((s) => s.isNotEmpty)
                          .join(' · '),
                    ),
                    onTap: () {
                      widget.onSeleccionar(v);
                      setState(() => _texto = '');
                      FocusScope.of(context).unfocus();
                    },
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CapturaIdentificacion extends StatelessWidget {
  const _CapturaIdentificacion({
    required this.tipo,
    required this.ruta,
    required this.aviso,
    required this.avisoAceptado,
    required this.onTipo,
    required this.onFoto,
    required this.onQuitarFoto,
    required this.onAceptarAviso,
  });

  final TipoIdentificacion tipo;
  final String? ruta;
  final LocalAvisosPrivacidadData? aviso;
  final bool avisoAceptado;
  final ValueChanged<TipoIdentificacion> onTipo;
  final VoidCallback onFoto;
  final VoidCallback onQuitarFoto;
  final ValueChanged<bool> onAceptarAviso;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<TipoIdentificacion>(
          initialValue: tipo,
          decoration: const InputDecoration(
            labelText: 'Tipo de identificación',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          items: [
            for (final t in TipoIdentificacion.values)
              DropdownMenuItem(value: t, child: Text(t.etiqueta)),
          ],
          onChanged: (v) => onTipo(v ?? TipoIdentificacion.ninguna),
        ),

        if (tipo != TipoIdentificacion.ninguna) ...[
          const SizedBox(height: 12),
          if (ruta == null)
            OutlinedButton.icon(
              onPressed: onFoto,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Fotografiar identificación'),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(ruta!),
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: onQuitarFoto,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Quitar foto'),
                  style: TextButton.styleFrom(
                      foregroundColor: AppTheme.rojoAlerta),
                ),
              ],
            ),

          if (ruta != null && aviso != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.azulAcero.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.azulAcero.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(aviso!.titulo,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(aviso!.resumen,
                      style: const TextStyle(fontSize: 12.5, height: 1.4)),
                  if (aviso!.urlCompleto.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => launchUrl(
                        Uri.parse(aviso!.urlCompleto),
                        mode: LaunchMode.externalApplication,
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Ver aviso completo'),
                    ),
                  ],
                  CheckboxListTile(
                    value: avisoAceptado,
                    onChanged: (v) => onAceptarAviso(v ?? false),
                    title: const Text(
                      'El visitante aceptó el aviso de privacidad',
                      style: TextStyle(fontSize: 13),
                    ),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppTheme.grisNeutro,
        ),
      ),
    );
  }
}

class _SinSitio extends StatelessWidget {
  const _SinSitio();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off_outlined, size: 56, color: AppTheme.grisNeutro),
            SizedBox(height: 16),
            Text(
              'Sin sitio seleccionado',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Registra tu entrada o elige un sitio en la pantalla de '
              'asistencia antes de dar de alta visitantes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.grisNeutro, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
