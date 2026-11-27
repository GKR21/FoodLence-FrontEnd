import 'package:flutter/material.dart';
import 'package:foodlence/config/app_colors.dart';

/// Safety verdict classification for a scanned product.
enum Verdict { safe, caution, unsafe }

/// Visual styling helpers for [Verdict].
extension VerdictStyle on Verdict {
  String get label => switch (this) {
    Verdict.safe => 'Safe',
    Verdict.caution => 'Caution',
    Verdict.unsafe => 'Unsafe',
  };

  Color get color => switch (this) {
    Verdict.safe => AppColors.safeText,
    Verdict.caution => AppColors.cautionText,
    Verdict.unsafe => AppColors.unsafeText,
  };

  Color get bg => switch (this) {
    Verdict.safe => AppColors.safeBg,
    Verdict.caution => AppColors.cautionBg,
    Verdict.unsafe => AppColors.unsafeBg,
  };

  Color get dot => switch (this) {
    Verdict.safe => AppColors.safeDot,
    Verdict.caution => AppColors.cautionDot,
    Verdict.unsafe => AppColors.unsafeDot,
  };

  String get icon => switch (this) {
    Verdict.safe => '✓',
    Verdict.caution => '⚠',
    Verdict.unsafe => '✕',
  };
}

/// Data model representing a scanned food product in scan history.
class ScanItem {
  final String name;
  final String date;
  final Verdict verdict;
  final String img;

  const ScanItem({
    required this.name,
    required this.date,
    required this.verdict,
    required this.img,
  });
}

/// Sample scan history items used by the history screens.
const List<ScanItem> kHistory = [
  ScanItem(
    name: 'Chocolate Chip Cookies',
    date: 'Today, 10:30 AM',
    verdict: Verdict.caution,
    img:
        'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=80&h=80&fit=crop&auto=format',
  ),
  ScanItem(
    name: 'Greek Yogurt',
    date: 'Yesterday, 3:15 PM',
    verdict: Verdict.unsafe,
    img:
        'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=80&h=80&fit=crop&auto=format',
  ),
  ScanItem(
    name: 'Oat Granola Bar',
    date: '12 Sep 2026',
    verdict: Verdict.safe,
    img:
        'https://images.unsplash.com/photo-1571748982800-fa51082c2224?w=80&h=80&fit=crop&auto=format',
  ),
  ScanItem(
    name: 'Instant Noodles',
    date: '11 Sep 2026',
    verdict: Verdict.caution,
    img:
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=80&h=80&fit=crop&auto=format',
  ),
  ScanItem(
    name: 'Almond Milk',
    date: '10 Sep 2026',
    verdict: Verdict.safe,
    img:
        'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=80&h=80&fit=crop&auto=format',
  ),
];
