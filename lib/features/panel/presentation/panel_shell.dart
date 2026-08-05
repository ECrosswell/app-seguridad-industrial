import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_routes.dart';
import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/panel_provider.dart';

/// Contenedor de la consola.
///
/// En pantalla ancha usa navegación lateral fija; en angosta cae a un cajón.
/// El mismo árbol sirve para el navegador de escritorio del administrador y
/// para el teléfono del cliente que quiere ver quién está en planta.
class PanelShell extends ConsumerWidget {
  const PanelShell({super.key, required this.child});

  final Widget child;

  static const _anchoEscritorio = 1000.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilActualProvider);
    if (perfil == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final destinos = _destinosPara(perfil.rol);
    final ruta = GoRouterState.of(context).matchedLocation;
    final indice = destinos.indexWhere((d) => d.ruta == ruta);
    final ancho = MediaQuery.sizeOf(context).width;
    final esEscritorio = ancho >= _anchoEscritorio;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, size: 24),
            const SizedBox(width: 10),
            const Text('Seguridad Industrial'),
            const SizedBox(width: 20),
            if (esEscritorio) const Expanded(child: _SelectorSitio()),
          ],
        ),
        actions: [
          if (!esEscritorio)
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              tooltip: 'Filtrar por sitio',
              onPressed: () => _mostrarFiltroSitio(context, ref),
            ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Text(
                perfil.iniciales,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(perfil.nombreCompleto,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(perfil.rol.etiqueta,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.grisNeutro)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'password', child: Text('Cambiar contraseña')),
              const PopupMenuItem(value: 'salir', child: Text('Cerrar sesión')),
            ],
            onSelected: (v) {
              if (v == 'salir') {
                ref.read(authControllerProvider.notifier).cerrarSesion();
              } else if (v == 'password') {
                context.push(Rutas.cambiarPassword);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: esEscritorio
          ? null
          : Drawer(
              child: SafeArea(
                child: ListView(
                  children: [
                    for (final d in destinos)
                      ListTile(
                        leading: Icon(d.icono),
                        title: Text(d.etiqueta),
                        selected: d.ruta == ruta,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go(d.ruta);
                        },
                      ),
                  ],
                ),
              ),
            ),
      body: Row(
        children: [
          if (esEscritorio)
            NavigationRail(
              selectedIndex: indice < 0 ? 0 : indice,
              onDestinationSelected: (i) => context.go(destinos[i].ruta),
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in destinos)
                  NavigationRailDestination(
                    icon: Icon(d.icono),
                    label: Text(d.etiqueta),
                  ),
              ],
            ),
          if (esEscritorio) const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  Future<void> _mostrarFiltroSitio(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: _SelectorSitio(expandido: true),
        ),
      ),
    );
  }

  /// Los destinos dependen del rol.
  ///
  /// El cliente ve todo lo operativo (así lo pidió), pero no la administración
  /// de sitios ni de usuarios: eso es de la empresa de seguridad.
  static List<_Destino> _destinosPara(RolUsuario rol) {
    final comunes = <_Destino>[
      (ruta: Rutas.panel, icono: Icons.dashboard_outlined, etiqueta: 'Tablero'),
      (ruta: Rutas.panelPersonal, icono: Icons.badge_outlined, etiqueta: 'Personal'),
      (ruta: Rutas.panelVisitantes, icono: Icons.people_outline, etiqueta: 'Visitantes'),
      (ruta: Rutas.panelBitacora, icono: Icons.menu_book_outlined, etiqueta: 'Bitácora'),
      (ruta: Rutas.panelEquipo, icono: Icons.inventory_2_outlined, etiqueta: 'Equipo'),
      (ruta: Rutas.panelSolicitudes, icono: Icons.support_agent_outlined, etiqueta: 'Solicitudes'),
      (ruta: Rutas.panelReportes, icono: Icons.download_outlined, etiqueta: 'Reportes'),
    ];

    if (rol == RolUsuario.admin) {
      return [
        ...comunes,
        (ruta: Rutas.panelSitios, icono: Icons.factory_outlined, etiqueta: 'Sitios'),
        (ruta: Rutas.panelUsuarios, icono: Icons.manage_accounts_outlined, etiqueta: 'Usuarios'),
      ];
    }
    return comunes;
  }
}

typedef _Destino = ({String ruta, IconData icono, String etiqueta});

class _SelectorSitio extends ConsumerWidget {
  const _SelectorSitio({this.expandido = false});

  final bool expandido;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitios = ref.watch(sitiosPanelProvider).value ?? const [];
    if (sitios.length < 2 && !expandido) return const SizedBox.shrink();

    final seleccionado = ref.watch(sitioFiltroProvider);

    return DropdownButtonHideUnderline(
      child: DropdownButton<String?>(
        value: seleccionado,
        isExpanded: expandido,
        dropdownColor: AppTheme.azulAcero,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        iconEnabledColor: Colors.white70,
        hint: const Text('Todos los sitios',
            style: TextStyle(color: Colors.white70, fontSize: 14)),
        items: [
          const DropdownMenuItem(value: null, child: Text('Todos los sitios')),
          for (final s in sitios)
            DropdownMenuItem(value: s.id, child: Text(s.nombre)),
        ],
        onChanged: (v) {
          ref.read(sitioFiltroProvider.notifier).seleccionar(v);
          if (expandido) Navigator.of(context).pop();
        },
      ),
    );
  }
}
