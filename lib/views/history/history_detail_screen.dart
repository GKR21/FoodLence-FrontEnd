import 'package:flutter/material.dart';
import 'history_list_screen.dart';

/// Shows the details of a single scan from the history list.
class HistoryDetailScreen extends StatelessWidget {
  final ScanItem item;

  /// Called when the back button is tapped.
  /// Defaults to Navigator.pop if not provided.
  final VoidCallback? onBack;

  /// Called when "Scan Another" is tapped (optional).
  final VoidCallback? onScanAnother;

  const HistoryDetailScreen({
    super.key,
    required this.item,
    this.onBack,
    this.onScanAnother,
  });

  static const _teal = Color(0xFF16A085);

  String get _message => switch (item.verdict) {
        Verdict.safe =>
          'No ingredients matching your allergen profile were found. This product looks safe for you.',
        Verdict.caution =>
          'Some ingredients may need attention, or the label mentions possible traces. Check the label carefully before consuming.',
        Verdict.unsafe =>
          'This product contains ingredients that match your allergen profile. It is not recommended for you.',
      };

  @override
  Widget build(BuildContext context) {
    final v = item.verdict;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 20, color: _teal),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: _teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    item.img,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF3F4F6),
                      child: const Icon(Icons.fastfood,
                          size: 48, color: Color(0xFFD1D5DB)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name + date
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 6),
                  Text(
                    'Scanned ${item.date}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Verdict card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: v.bg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: v.dot,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            v.icon,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          v.label,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: v.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _message,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: v.color,
                      ),
                    ),
                  ],
                ),
              ),

              // Scan another button
              if (onScanAnother != null) ...[
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: onScanAnother,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _teal,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _teal.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Scan Another',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
