import 'package:flutter/material.dart';
import 'package:foodlence/models/scan_model.dart';
import 'package:foodlence/views/auth/login_screen.dart';
import 'package:foodlence/views/auth/register_screen.dart';
import 'package:foodlence/views/history/history_detail_screen.dart';
import 'package:foodlence/views/history/history_screen.dart';
import 'package:foodlence/views/profiles/profile_screen.dart';
import 'package:foodlence/views/settings/settings_screen.dart';
import 'package:foodlence/views/splash/splash_screen.dart';
import 'package:foodlence/widgets/navigation/bottom_navigation_bar.dart';

/// Centralized route names and route generation for FoodLence.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String profiles = '/profiles';
  static const String settings = '/settings';
  static const String backendStatus = '/backend-status';
  static const String history = '/history';
  static const String historyDetail = '/history-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => SplashScreen(
            onFinish: () => Navigator.of(context).pushReplacementNamed(login),
          ),
        );
      case home:
      case dashboard:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const MainNavigationScreen(),
        );
      case login:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => LoginScreen(
            onSignIn: () => Navigator.of(context).pushReplacementNamed(home),
            onCreateAccount: () => Navigator.of(context).pushNamed(register),
            onGoogleSignIn: () =>
                Navigator.of(context).pushReplacementNamed(home),
          ),
        );
      case register:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => RegisterScreen(
            onGoToLogin: () => Navigator.of(context).pop(),
            onCreateAccount: () =>
                Navigator.of(context).pushReplacementNamed(home),
          ),
        );
      case profiles:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ProfilesScreen(),
        );
      case settings:
      case backendStatus:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const SettingsScreen(),
        );
      case history:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => HistoryListScreen(
            onItemTap: (item) =>
                Navigator.of(context).pushNamed(historyDetail, arguments: item),
            onStartScanning: () =>
                Navigator.of(context).pushReplacementNamed(home),
          ),
        );
      case historyDetail:
        final item = routeSettings.arguments is ScanItem
            ? routeSettings.arguments! as ScanItem
            : kHistory.first;
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) => HistoryDetailScreen(
            item: item,
            onScanAnother: () =>
                Navigator.of(context).pushReplacementNamed(home),
          ),
        );
      default:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const MainNavigationScreen(),
        );
    }
  }
}
