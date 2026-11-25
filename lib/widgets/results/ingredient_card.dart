import 'package:flutter/material.dart';

/// Single item in the ingredients breakdown list.
class IngredientCardItem {
  final String name;
  final String category;
  final bool isSafe;

  const IngredientCardItem({
    required this.name,
    required this.category,
    this.isSafe = true,
  });
}

/// Reusable ingredient tile matching FoodLense design.
class IngredientCard extends StatelessWidget {
  final IngredientCardItem item;
  final VoidCallback? onTap;

  const IngredientCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Green checkmark in soft rounded square
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.isSafe
                      ? (isDark
                          ? const Color(0xFF064E3B).withValues(alpha: 0.5)
                          : const Color(0xFFECFDF5))
                      : (isDark
                          ? const Color(0xFF7F1D1D).withValues(alpha: 0.5)
                          : const Color(0xFFFEF2F2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  item.isSafe ? Icons.check : Icons.warning_amber_rounded,
                  color: item.isSafe
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  size: 18,
                ),
              ),

              const SizedBox(width: 14),

              // Title & Category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron right
              Icon(
                Icons.chevron_right,
                size: 18,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
