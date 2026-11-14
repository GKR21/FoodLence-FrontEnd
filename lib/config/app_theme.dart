import 'package:flutter/material.dart';
import 'package:foodlence/config/app_colors.dart';

/// Application Material theme configuration.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.light,
        primary: AppColors.primaryGreen,
        surface: AppColors.surfaceGreenTint,
      ),
      fontFamily: 'Roboto',
    );
  }
}
