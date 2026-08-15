import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF08101F);
  static const surface = Color(0xFF11203B);
  static const panel = Color(0xFF14274A);
  static const accent = Color(0xFF4ADE80);
  static const accentSoft = Color(0xFF6EE7B7);
  static const danger = Color(0xFFF87171);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF94A3B8);
  static const border = Color(0xFF334155);
}

class AppGradients {
  static const background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF06101A), Color(0xFF0B1526)],
  );
}

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.accent,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accent,
    secondary: Color(0xFF38BDF8),
    surface: AppColors.surface,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: false,
  ),
  cardColor: AppColors.surface,
  canvasColor: AppColors.background,
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: AppColors.textSecondary),
    bodyMedium: TextStyle(color: AppColors.textPrimary),
    bodyLarge: TextStyle(color: AppColors.textPrimary),
    titleLarge: TextStyle(color: AppColors.textPrimary),
    titleMedium: TextStyle(color: AppColors.textPrimary),
    titleSmall: TextStyle(color: AppColors.textSecondary),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.panel,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: AppColors.textSecondary),
    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      foregroundColor: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
  iconTheme: const IconThemeData(color: AppColors.textPrimary),
  cardTheme: const CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(28)),
    ),
  ),
);
