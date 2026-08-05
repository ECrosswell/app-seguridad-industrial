import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/perfil.dart';
import '../providers/panel_provider.dart';

/// Alta, baja y reingreso de personal.
///
/// **Las cuentas se crean desde el panel de Supabase (Authentication → Add
/// user)**, no desde aquí: crear un usuario requiere la `service_role key`, que
/// nunca debe vivir en una app cliente — quien la extrajera del bundle tendría
/// acceso total a la base saltándose todo el RLS.
///
/// Al crear el usuario allá hay que capturar en «User Metadata»:
/// `nombre_completo`, `rol` y `telefono_whatsapp`. El trigger `handle_new_user`
/// crea el perfil solo y lo marca para cambio de contraseña en el primer
/// ingreso.
class PanelUsuariosScreen extends ConsumerStatefulWidget {
  const PanelUsuariosScreen({super.key});

  @override
  ConsumerState<PanelUsuariosScreen> createState() =>
      _PanelUsuariosScreenState();
}

class _PanelUsuariosScreenState extends ConsumerState<PanelUsuariosScreen> {
  RolUsuario? _filtroRol;
  bool _incluirBajas = false;

  @override
  Widget build(BuildContext context) {
    final usuarios = ref.watch(usuariosPanelProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Usuarios',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),

        Card(
          color: AppTheme.azulAcero.withValues(alpha: 0.05),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AppTheme.azulAcero, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Las cuentas nuevas se crean desde el panel de Supabase '
                    '(Authentication → Add user), capturando en User Metadata: '
                    'nombre_completo, rol y telefono_whatsapp. El perfil se crea '
                    'solo y pide cambiar la contraseña al primer ingreso.\n\n'
                    'No se hace desde aquí porque crear usuarios exige una llave '
                    'de servicio que no puede vivir en una app cliente.',
                    style: TextStyle(fontSize: 12.5, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Todos'),
              selected: _filtroRol == null,
              onSelected: (_) => setState(() => _filtroRol = null),
            ),
            for (final r in RolUsuario.values)
              ChoiceChip(
                label: Text(r.etiqueta),
                selected: _filtroRol == r,
                onSelected: (_) => setState(() => _filtroRol = r),
              ),
            FilterChip(
              label: const Text('Incluir bajas'),
              selected: _incluirBajas,
              onSelected: (v) => setState(() => _incluirBajas = v),
            ),
          ],
        ),
        const SizedBox(height: 20),

        usuarios.when(
          loading: () => const Center(
              child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator())),
          error: (e, _) => Text('Error: $e'),
          data: (lista) {
            var filtrada = lista;
            if (_filtroRol != null) {
              filtrada = filtrada.where((u) => u.rol == _filtroRol).toList();
            }
            if (!_incluirBajas) {
              filtrada = filtrada
                  .where((u) => u.estadoLaboral != EstadoLaboral.baja)
                  .toList();
            }

            if (filtrada.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(child: Text('Sin usuarios que coincidan')),
                ),
              );
            }

            return Column(
              children: [for (final u in filtrada) _TarjetaUsuario(perfil: u)],
            );
          },
        ),
      ],
    );
  }
}

class _TarjetaUsuario extends ConsumerWidget {
  const _TarjetaUsuario({required this.perfil});

  final Perfil perfil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = perfil;
    final deBaja = p.estadoLaboral == EstadoLaboral.baja;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: deBaja
                  ? AppTheme.grisNeutro.withValues(alpha: 0.2)
                  : AppTheme.azulAcero.withValues(alpha: 0.15),
              child: Text(p.iniciales,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: deBaja ? AppTheme.grisNeutro : AppTheme.azulAcero,
                  )),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          p.nombreCompleto.isEmpty ? p.correo : p.nombreCompleto,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            decoration: deBaja ? TextDecoration.lineThrough : null,
                            color: deBaja ? AppTheme.grisNeutro : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.azulAcero.withValues(alpha: 0.11),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(p.rol.etiqueta,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [
                      p.correo,
                      if (p.telefonoWhatsapp.isNotEmpty) p.telefonoWhatsapp,
                      if (p.fechaAlta != null)
                        'Alta ${DateFormat('d MMM yyyy', 'es_MX').format(p.fechaAlta!)}',
                      if (deBaja && p.fechaBaja != null)
                        'Baja ${DateFormat('d MMM yyyy', 'es_MX').format(p.fechaBaja!)}',
                    ].join(' · '),
                    style: const TextStyle(
                        fontSize: 12.5, color: AppTheme.grisNeutro),
                  ),
                  if (deBaja && p.motivoBaja.isNotEmpty)
                    Text('Motivo: ${p.motivoBaja}',
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.rojoAlerta)),
                  if (p.debeCambiarPassword)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('Contraseña temporal sin cambiar',
                          style: TextStyle(
                              fontSize: 11.5, color: AppTheme.ambarSeguridad)),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              itemBuilder: (_) => [
                if (!deBaja)
                  const PopupMenuItem(value: 'baja', child: Text('Dar de baja')),
                if (deBaja)
                  const PopupMenuItem(
                      value: 'reingreso', child: Text('Reingresar')),
                const PopupMenuItem(value: 'sitio', child: Text('Asignar sitio')),
              ],
              onSelected: (v) => switch (v) {
                'baja' => _darDeBaja(context, ref),
                'reingreso' => _reingresar(context, ref),
                'sitio' => _asignarSitio(context, ref),
                _ => null,
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _darDeBaja(BuildContext context, WidgetRef ref) async {
    final motivo = TextEditingController();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Dar de baja a ${perfil.nombreCompleto}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No podrá volver a entrar a la app. Su historial se conserva '
              'íntegro: no se borra la cuenta.',
              style: TextStyle(fontSize: 13, height: 1.35),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: motivo,
              decoration: const InputDecoration(labelText: 'Motivo de baja'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.rojoAlerta),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Dar de baja'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await ref.read(panelRepositoryProvider).cambiarEstadoLaboral(
            usuarioId: perfil.id,
            estado: 'baja',
            motivo: motivo.text.trim(),
          );
      if (context.mounted) ref.invalidate(usuariosPanelProvider);
    }
    motivo.dispose();
  }

  Future<void> _reingresar(BuildContext context, WidgetRef ref) async {
    await ref.read(panelRepositoryProvider).cambiarEstadoLaboral(
          usuarioId: perfil.id,
          estado: 'reingreso',
        );
    if (context.mounted) ref.invalidate(usuariosPanelProvider);
  }

  Future<void> _asignarSitio(BuildContext context, WidgetRef ref) async {
    final sitios = ref.read(sitiosPanelProvider).value ?? const [];
    if (sitios.isEmpty) return;

    final elegido = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('Asignar sitio a ${perfil.nombreCompleto}'),
        children: [
          for (final s in sitios)
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(s.id),
              child: Text(s.nombre),
            ),
        ],
      ),
    );

    if (elegido != null) {
      await ref
          .read(panelRepositoryProvider)
          .asignarSitio(usuarioId: perfil.id, sitioId: elegido);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sitio asignado'),
            backgroundColor: AppTheme.verdeOperativo,
          ),
        );
      }
    }
  }
}
