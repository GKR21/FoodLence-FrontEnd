import 'package:flutter/widgets.dart';

class Validators {
  Validators._();

  static String? name(String? v) =>
      (v == null || v.trim().length < 2) ? 'Enter your full name' : null;

  static String? email(String? v) {
    final s = v?.trim() ?? '';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s)
        ? null
        : 'Enter a valid email address';
  }

  static String? password(String? v) =>
      (v == null || v.length < 8) ? 'Use at least 8 characters' : null;

  static String? Function(String?) matches(TextEditingController other) =>
      (v) => v == other.text ? null : 'Passwords do not match';
}
