import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_routes.dart';

/// Contenedor con la barra de navegación inferior.
///
/// Cuatro destinos y nada más. La caseta se opera con una mano y muchas veces
/// sin mirar: más pestañas se vuelven inalcanzables con el pulgar y aumentan el
/// riesgo de tocar la equivocada.
class ShellOperativo extends StatelessWidget {
  const ShellOperativo({super.key, required this.child});

  final Widget child;

  static const _destinos = [
    (ruta: Rutas.inicio, icono: Icons.home_outlined, activo: Icons.home, etiqueta: 'Inicio'),
    (ruta: Rutas.asistencia, icono: Icons.badge_outlined, activo: Icons.badge, etiqueta: 'Asistencia'),
    (ruta: Rutas.accesos, icono: Icons.people_outline, activo: Icons.people, etiqueta: 'Visitantes'),
    (ruta: Rutas.bitacora, icono: Icons.menu_book_outlined, activo: Icons.menu_book, etiqueta: 'Bitácora'),
  ];

  int _indiceActual(BuildContext context) {
    final ruta = GoRouterState.of(context).matchedLocation;
    final i = _destinos.indexWhere((d) => d.ruta == ruta);
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final indice = _indiceActual(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: indice,
        onDestinationSelected: (i) => context.go(_destinos[i].ruta),
        destinations: [
          for (final d in _destinos)
            NavigationDestination(
              icon: Icon(d.icono),
              selectedIcon: Icon(d.activo),
              label: d.etiqueta,
            ),
        ],
      ),
    );
  }
}
