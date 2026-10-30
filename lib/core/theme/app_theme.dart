import 'package:flutter/material.dart';

/// Paleta de la app: verdes de campo, amarillo de cosecha y tonos de tierra.
class AppColors {
  static const verde = Color(0xFF2E7D32);
  static const verdeOscuro = Color(0xFF1B5E20);
  static const verdeMedio = Color(0xFF4CAF50);
  static const verdeSuave = Color(0xFFE6F4E0);
  static const amarillo = Color(0xFFF2A900);
  static const amarilloSuave = Color(0xFFFFF4D6);
  static const tierra = Color(0xFF7A5A3A);
  static const crema = Color(0xFFF6FAF0);
  static const borde = Color(0xFFDCEBD3);
  static const textoSuave = Color(0xFF5E7355);
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.verde,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.verde,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFCDE9C6),
      onPrimaryContainer: AppColors.verdeOscuro,
      secondary: AppColors.amarillo,
      onSecondary: const Color(0xFF3F2E00),
      secondaryContainer: AppColors.amarilloSuave,
      onSecondaryContainer: const Color(0xFF5C4300),
      tertiary: AppColors.tierra,
      surface: Colors.white,
      onSurface: const Color(0xFF1E2A1B),
      onSurfaceVariant: AppColors.textoSuave,
      outlineVariant: AppColors.borde,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final textos = base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.crema,
      textTheme: textos.copyWith(
        headlineMedium: textos.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.verdeOscuro,
          letterSpacing: -0.4,
        ),
        titleLarge: textos.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.verdeOscuro,
        ),
        titleMedium: textos.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.verdeOscuro,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.verdeOscuro,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.borde),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF7FBF3),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIconColor: AppColors.verde,
        labelStyle: const TextStyle(color: AppColors.textoSuave),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.verde, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.verde,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.verdeOscuro,
          side: const BorderSide(color: AppColors.verde),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.verde),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.verdeOscuro),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFD8EFD0),
        selectedIconTheme: IconThemeData(color: AppColors.verdeOscuro),
        unselectedIconTheme: IconThemeData(color: Color(0xFF7C9174)),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.verdeOscuro,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(color: Color(0xFF6C8064)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borde,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.verdeOscuro,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.verde,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.verdeSuave,
        side: const BorderSide(color: AppColors.borde),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
