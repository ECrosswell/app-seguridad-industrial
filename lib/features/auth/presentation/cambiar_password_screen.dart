import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

/// Cambio de contraseña.
///
/// Se muestra de dos formas:
///   · **Forzada** ([forzada] = true) al primer ingreso, porque el admin creó
///     la cuenta con una contraseña temporal que él conoce. Sin salida: no hay
///     botón de regreso ni de cerrar sesión que valga.
///   · **Voluntaria** desde el perfil, cuando el usuario quiere cambiarla.
class CambiarPasswordScreen extends ConsumerStatefulWidget {
  const CambiarPasswordScreen({super.key, this.forzada = false});

  final bool forzada;

  @override
  ConsumerState<CambiarPasswordScreen> createState() =>
      _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState extends ConsumerState<CambiarPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nueva = TextEditingController();
  final _confirmar = TextEditingController();

  bool _ocultar = true;
  bool _procesando = false;
  String? _error;

  @override
  void dispose() {
    _nueva.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _procesando = true;
      _error = null;
    });

    final error =
        await ref.read(authControllerProvider.notifier).cambiarPassword(_nueva.text);

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _procesando = false;
        _error = error;
      });
      return;
    }

    setState(() => _procesando = false);

    if (widget.forzada) {
      // El enrutador redirige solo al ver que ya no debe cambiarla.
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Durante el cambio forzado no se puede salir con el botón atrás.
      canPop: !widget.forzada,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.forzada
              ? 'Crea tu contraseña'
              : 'Cambiar contraseña'),
          automaticallyImplyLeading: !widget.forzada,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.forzada) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.ambarSeguridad.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline,
                                  color: AppTheme.ambarSeguridad),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tu cuenta se creó con una contraseña temporal. '
                                  'Define una nueva que sólo tú conozcas para continuar.',
                                  style: TextStyle(height: 1.35),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      TextFormField(
                        controller: _nueva,
                        obscureText: _ocultar,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Nueva contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_ocultar
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _ocultar = !_ocultar),
                          ),
                        ),
                        validator: (v) {
                          final valor = v ?? '';
                          if (valor.length < 8) {
                            return 'Usa al menos 8 caracteres';
                          }
                          if (!valor.contains(RegExp(r'[0-9]'))) {
                            return 'Incluye al menos un número';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _confirmar,
                        obscureText: _ocultar,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _guardar(),
                        decoration: const InputDecoration(
                          labelText: 'Confirma la contraseña',
                          prefixIcon: Icon(Icons.lock_reset_outlined),
                        ),
                        validator: (v) =>
                            v != _nueva.text ? 'Las contraseñas no coinciden' : null,
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: const TextStyle(color: AppTheme.rojoAlerta),
                        ),
                      ],

                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: _procesando ? null : _guardar,
                        child: _procesando
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Guardar contraseña'),
                      ),

                      if (widget.forzada) ...[
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => ref
                              .read(authControllerProvider.notifier)
                              .cerrarSesion(),
                          child: const Text('Salir'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
