import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/perfil.dart';
import '../../../data/models/sitio.dart';
import '../data/panel_repository.dart';
import '../domain/usuario_admin_validators.dart';
import '../providers/panel_provider.dart';

const _rolesAlta = <RolUsuario>[
  RolUsuario.elemento,
  RolUsuario.supervisor,
  RolUsuario.cliente,
];

Future<bool> mostrarDialogoAltaUsuario(
  BuildContext context, {
  required List<Sitio> sitios,
}) async {
  if (sitios.isEmpty) return false;
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _DialogoAltaUsuario(sitios: sitios),
      ) ??
      false;
}

Future<bool> mostrarDialogoRestablecerPassword(
  BuildContext context, {
  required Perfil perfil,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _DialogoRestablecerPassword(perfil: perfil),
      ) ??
      false;
}

class _DialogoAltaUsuario extends ConsumerStatefulWidget {
  const _DialogoAltaUsuario({required this.sitios});

  final List<Sitio> sitios;

  @override
  ConsumerState<_DialogoAltaUsuario> createState() =>
      _DialogoAltaUsuarioState();
}

class _DialogoAltaUsuarioState extends ConsumerState<_DialogoAltaUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _telefono = TextEditingController();
  final _password = TextEditingController();
  final _confirmar = TextEditingController();

  RolUsuario _rol = RolUsuario.elemento;
  late String _sitioId;
  bool _ocultar = true;
  bool _procesando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _sitioId = widget.sitios.first.id;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _telefono.dispose();
    _password.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _procesando = true;
      _error = null;
    });

    try {
      await ref
          .read(panelRepositoryProvider)
          .crearUsuario(
            nombreCompleto: _nombre.text,
            correo: _correo.text,
            telefonoWhatsapp: UsuarioAdminValidators.normalizarTelefono(
              _telefono.text,
            ),
            rol: _rol.valor,
            sitioId: _sitioId,
            passwordTemporal: _password.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on UsuarioAdminException catch (e) {
      if (mounted) {
        setState(() {
          _procesando = false;
          _error = e.mensaje;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _procesando = false;
          _error = 'No se pudo dar de alta al usuario.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final campoRol = DropdownButtonFormField<RolUsuario>(
      initialValue: _rol,
      decoration: const InputDecoration(
        labelText: 'Rol',
        prefixIcon: Icon(Icons.badge_outlined),
      ),
      items: [
        for (final rol in _rolesAlta)
          DropdownMenuItem(value: rol, child: Text(rol.etiqueta)),
      ],
      onChanged: _procesando
          ? null
          : (rol) {
              if (rol != null) setState(() => _rol = rol);
            },
    );
    final campoSitio = DropdownButtonFormField<String>(
      initialValue: _sitioId,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Sitio principal',
        prefixIcon: Icon(Icons.factory_outlined),
      ),
      items: [
        for (final sitio in widget.sitios)
          DropdownMenuItem(
            value: sitio.id,
            child: Text(sitio.nombre, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: _procesando
          ? null
          : (sitioId) {
              if (sitioId != null) setState(() => _sitioId = sitioId);
            },
    );

    return AlertDialog(
      title: const Text('Dar de alta usuario'),
      content: SizedBox(
        width: 540,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AvisoPasswordTemporal(),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nombre,
                  enabled: !_procesando,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: UsuarioAdminValidators.nombre,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _correo,
                  enabled: !_procesando,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: UsuarioAdminValidators.correo,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _telefono,
                  enabled: !_procesando,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp (opcional)',
                    prefixIcon: Icon(Icons.phone_outlined),
                    hintText: '5215512345678',
                  ),
                  validator: UsuarioAdminValidators.telefono,
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 480) {
                      return Column(
                        children: [
                          campoRol,
                          const SizedBox(height: 14),
                          campoSitio,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: campoRol),
                        const SizedBox(width: 12),
                        Expanded(child: campoSitio),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _password,
                  enabled: !_procesando,
                  obscureText: _ocultar,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(
                    labelText: 'Contraseña temporal',
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                      tooltip: _ocultar
                          ? 'Mostrar contraseña'
                          : 'Ocultar contraseña',
                      onPressed: _procesando
                          ? null
                          : () => setState(() => _ocultar = !_ocultar),
                      icon: Icon(
                        _ocultar
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: UsuarioAdminValidators.passwordTemporal,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmar,
                  enabled: !_procesando,
                  obscureText: _ocultar,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _guardar(),
                  decoration: const InputDecoration(
                    labelText: 'Confirmar contraseña temporal',
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                  ),
                  validator: (valor) => UsuarioAdminValidators.confirmacion(
                    valor,
                    _password.text,
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  _MensajeError(_error!),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _procesando
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _procesando ? null : _guardar,
          icon: _procesando
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.person_add_alt_1),
          label: Text(_procesando ? 'Creando…' : 'Dar de alta'),
        ),
      ],
    );
  }
}

class _DialogoRestablecerPassword extends ConsumerStatefulWidget {
  const _DialogoRestablecerPassword({required this.perfil});

  final Perfil perfil;

  @override
  ConsumerState<_DialogoRestablecerPassword> createState() =>
      _DialogoRestablecerPasswordState();
}

class _DialogoRestablecerPasswordState
    extends ConsumerState<_DialogoRestablecerPassword> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmar = TextEditingController();
  bool _ocultar = true;
  bool _procesando = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _procesando = true;
      _error = null;
    });

    try {
      await ref
          .read(panelRepositoryProvider)
          .restablecerPasswordUsuario(
            usuarioId: widget.perfil.id,
            passwordTemporal: _password.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on UsuarioAdminException catch (e) {
      if (mounted) {
        setState(() {
          _procesando = false;
          _error = e.mensaje;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _procesando = false;
          _error = 'No se pudo restablecer la contraseña.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombre = widget.perfil.nombreCompleto.isEmpty
        ? widget.perfil.correo
        : widget.perfil.nombreCompleto;

    return AlertDialog(
      title: const Text('Restablecer contraseña'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.perfil.correo,
                  style: const TextStyle(color: AppTheme.grisNeutro),
                ),
                const SizedBox(height: 16),
                const _AvisoPasswordTemporal(),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _password,
                  enabled: !_procesando,
                  obscureText: _ocultar,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Nueva contraseña temporal',
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                      tooltip: _ocultar
                          ? 'Mostrar contraseña'
                          : 'Ocultar contraseña',
                      onPressed: _procesando
                          ? null
                          : () => setState(() => _ocultar = !_ocultar),
                      icon: Icon(
                        _ocultar
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: UsuarioAdminValidators.passwordTemporal,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmar,
                  enabled: !_procesando,
                  obscureText: _ocultar,
                  enableSuggestions: false,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _guardar(),
                  decoration: const InputDecoration(
                    labelText: 'Confirmar contraseña temporal',
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                  ),
                  validator: (valor) => UsuarioAdminValidators.confirmacion(
                    valor,
                    _password.text,
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  _MensajeError(_error!),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _procesando
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _procesando ? null : _guardar,
          icon: _procesando
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.lock_reset),
          label: Text(_procesando ? 'Guardando…' : 'Restablecer'),
        ),
      ],
    );
  }
}

class _AvisoPasswordTemporal extends StatelessWidget {
  const _AvisoPasswordTemporal();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.ambarSeguridad.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppTheme.ambarSeguridad, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'La contraseña será temporal. En su siguiente acceso, la persona '
              'deberá crear una nueva que sólo ella conozca.',
              style: TextStyle(fontSize: 12.5, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _MensajeError extends StatelessWidget {
  const _MensajeError(this.mensaje);

  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(mensaje, style: const TextStyle(color: AppTheme.rojoAlerta)),
    );
  }
}
