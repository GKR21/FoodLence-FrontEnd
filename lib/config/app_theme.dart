import 'package:flutter/material.dart';
import 'package:foodlence/config/app_colors.dart';

/// Application Material theme configuration with global theme switching.
class AppTheme {
  AppTheme._();

  /// Global notifier for theme mode changes.
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Current active ThemeMode.
  static ThemeMode get themeMode => themeModeNotifier.value;

  /// Sets the global ThemeMode and notifies all listening widgets.
  static void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }

  /// Helper to check if dark mode is currently active.
  static bool isDark(BuildContext context) {
    if (themeModeNotifier.value == ThemeMode.dark) return true;
    if (themeModeNotifier.value == ThemeMode.light) return false;
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.light,
        primary: AppColors.primaryGreen,
        surface: Colors.white,
      ),
      fontFamily: 'Roboto',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF1E293B),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.dark,
        primary: AppColors.primaryGreen,
        surface: const Color(0xFF1E293B),
      ),
      fontFamily: 'Roboto',
    );
  }
}
