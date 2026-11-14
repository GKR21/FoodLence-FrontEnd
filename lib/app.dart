import 'package:flutter/material.dart';
import 'package:foodlence/config/app_constants.dart';
import 'package:foodlence/config/app_routes.dart';
import 'package:foodlence/config/app_theme.dart';

/// Root application widget configuring theme and routing.
class FoodLenceApp extends StatelessWidget {
  const FoodLenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
