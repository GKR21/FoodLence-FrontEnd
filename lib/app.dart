import 'package:flutter/material.dart';
import 'package:foodlence/config/app_constants.dart';
import 'package:foodlence/config/app_routes.dart';
import 'package:foodlence/config/app_theme.dart';

/// Root application widget configuring theme and routing.
class FoodLenceApp extends StatelessWidget {
  const FoodLenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}
