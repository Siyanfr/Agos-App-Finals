import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFF10B981);
  static const statusPending = Color(0xFF004AC6);
  static const statusPendingBg = Color(0xFFD9E3F6);
  static const statusResolved = Color(0xFF006C49);
  static const statusRejected = Color(0xFFDC2626);
  static const background = Color(0xFFF8F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceTint = Color(0xFFDBE1FF);
  static const onSurface = Color(0xFF1F2937);
  static const error = Color(0xFFDC2626);
  static const scrim = Color(0x80000000);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

class AppRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double pill = 28;
}

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
  ),
  scaffoldBackgroundColor: AppColors.background,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
    labelSmall: TextStyle(fontSize: 12, color: Colors.grey),
  ),
  cardTheme: CardThemeData(
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    ),
  ),
);