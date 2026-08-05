import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/cambiar_password_screen.dart';
import '../../auth/providers/auth_provider.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  late final TextEditingController _whatsapp;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _whatsapp = TextEditingController(
      text: ref.read(perfilActualProvider)?.telefonoWhatsapp ?? '',
    );
  }

  @override
  void dispose() {
    _whatsapp.dispose();
    super.dispose();
  }

  Future<void> _guardarWhatsapp() async {
    setState(() => _guardando = true);
    final error = await ref
        .read(authControllerProvider.notifier)
        .actualizarWhatsapp(_whatsapp.text);

    if (!mounted) return;
    setState(() => _guardando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Número actualizado'),
        backgroundColor: error != null ? AppTheme.rojoAlerta : AppTheme.verdeOperativo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final perfil = ref.watch(perfilActualProvider);
    if (perfil == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppTheme.azulAcero,
                  child: Text(
                    perfil.iniciales,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(perfil.nombreCompleto,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  perfil.puesto.isEmpty ? perfil.rol.etiqueta : perfil.puesto,
                  style: const TextStyle(color: AppTheme.grisNeutro),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.alternate_email),
                  title: const Text('Correo'),
                  subtitle: Text(perfil.correo),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Rol'),
                  subtitle: Text(perfil.rol.etiqueta),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text('WhatsApp',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text(
            'El cliente ve este número para contactarte directamente durante '
            'tu turno.',
            style: TextStyle(color: AppTheme.grisNeutro, fontSize: 13, height: 1.35),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _whatsapp,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Número con clave de país',
              hintText: '52 55 1234 5678',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _guardando ? null : _guardarWhatsapp,
            child: _guardando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : const Text('Guardar número'),
          ),

          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CambiarPasswordScreen(),
              ),
            ),
            icon: const Icon(Icons.lock_reset_outlined),
            label: const Text('Cambiar contraseña'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _confirmarSalir(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.rojoAlerta,
              side: const BorderSide(color: AppTheme.rojoAlerta),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarSalir(BuildContext context) async {
    final salir = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        // Advertencia real: al cerrar sesión se limpia la base local. Si quedan
        // registros sin subir, se pierden.
        content: const Text(
          'Si tienes registros sin sincronizar, conéctate antes de salir para '
          'no perderlos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.rojoAlerta),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (salir == true) {
      await ref.read(authControllerProvider.notifier).cerrarSesion();
    }
  }
}
