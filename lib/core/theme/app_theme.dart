import 'package:flutter/material.dart';

/// Tema de la app.
///
/// Paleta industrial: azul acero como base y ámbar de seguridad como acento.
/// El ámbar se reserva para lo que exige atención (retardos, novedades de
/// equipo) y el rojo para lo crítico — si todo grita, nada grita.
///
/// Se usa tipografía grande y contraste alto a propósito: la caseta se opera
/// de pie, con guantes, a veces de noche y a veces bajo sol directo.
class AppTheme {
  const AppTheme._();

  static const azulAcero = Color(0xFF1B3A57);
  static const azulProfundo = Color(0xFF0F2438);
  static const ambarSeguridad = Color(0xFFF5A623);
  static const verdeOperativo = Color(0xFF2E9E6B);
  static const rojoAlerta = Color(0xFFD64545);
  static const grisNeutro = Color(0xFF6B7785);

  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(
      seedColor: azulAcero,
      brightness: Brightness.light,
      primary: azulAcero,
      secondary: ambarSeguridad,
      error: rojoAlerta,
    );

    return _base(esquema).copyWith(
      scaffoldBackgroundColor: const Color(0xFFF4F6F8),
    );
  }

  static ThemeData get oscuro {
    final esquema = ColorScheme.fromSeed(
      seedColor: azulAcero,
      brightness: Brightness.dark,
      primary: const Color(0xFF6FA8DC),
      secondary: ambarSeguridad,
      error: const Color(0xFFFF6B6B),
    );

    return _base(esquema).copyWith(
      scaffoldBackgroundColor: azulProfundo,
    );
  }

  static ThemeData _base(ColorScheme esquema) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      appBarTheme: AppBarTheme(
        backgroundColor: esquema.brightness == Brightness.dark
            ? azulProfundo
            : azulAcero,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: esquema.outlineVariant.withValues(alpha: 0.5)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          // 52 px de alto: el objetivo táctil mínimo cómodo con guantes.
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: esquema.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: esquema.outlineVariant),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(space: 1, thickness: 1),
    );
  }

  /// Color para la clasificación de puntualidad.
  static Color colorClasificacion(String clasificacion) {
    return switch (clasificacion) {
      'a_tiempo' => verdeOperativo,
      'retardo' => ambarSeguridad,
      'falta' => rojoAlerta,
      _ => grisNeutro,
    };
  }

  /// Color para el estado de una partida de equipo.
  static Color colorEstadoEquipo(String estado) {
    return switch (estado) {
      'perfecto' => verdeOperativo,
      'usado' => ambarSeguridad,
      'danado' => rojoAlerta,
      'falta' => rojoAlerta,
      _ => grisNeutro,
    };
  }

  static Color colorPrioridad(String prioridad) {
    return switch (prioridad) {
      'critica' => rojoAlerta,
      'alta' => ambarSeguridad,
      _ => grisNeutro,
    };
  }
}
