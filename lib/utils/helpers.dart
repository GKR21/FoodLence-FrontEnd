import 'package:flutter/material.dart';
import '../config/app_routes.dart';

class Helpers {
  Helpers._();

  static void snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
  }

  /// Bottom-nav navigation. Tabs: 0 Home, 1 Scan, 2 History, 3 Profile.
  static void goTab(BuildContext context, int index, {required int current}) {
    if (index == current) return;
    final nav = Navigator.of(context);
    switch (index) {
      case 0:
        nav.pushNamedAndRemoveUntil(AppRoutes.dashboard, (_) => false);
      case 1:
        nav.pushNamed(AppRoutes.scanner);
      case 2:
        nav.pushNamedAndRemoveUntil(AppRoutes.history, (_) => false);
      default:
        nav.pushNamedAndRemoveUntil(AppRoutes.profile, (_) => false);
    }
  }
}
