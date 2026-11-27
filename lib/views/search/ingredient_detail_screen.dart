import 'package:flutter/material.dart';

/// Detailed view of a single scanned food ingredient.
class IngredientDetailScreen extends StatelessWidget {
  final String ingredientName;
  final VoidCallback? onBack;

  const IngredientDetailScreen({
    super.key,
    this.ingredientName = 'Casein',
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name = ingredientName.isNotEmpty ? ingredientName : 'Casein';
    final isAllergenMatch = name.toLowerCase().contains('casein') ||
        name.toLowerCase().contains('milk') ||
        name.toLowerCase().contains('peanut') ||
        name.toLowerCase().contains('soy');

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          name,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isAllergenMatch
                          ? const Color(0xFFFEE2E2)
                          : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isAllergenMatch
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: isAllergenMatch
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF16A34A),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAllergenMatch
                              ? 'Flagged as Allergen'
                              : 'Generally Safe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isAllergenMatch
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF16A34A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAllergenMatch
                              ? 'Matches your active allergen profile'
                              : 'No matches found in your allergen profile',
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
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Overview Section
            Text(
              'Ingredient Overview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    'Category',
                    isAllergenMatch ? 'Protein / Dairy Derivative' : 'General Ingredient',
                    isDark,
                  ),
                  const Divider(height: 20),
                  _infoRow('Common Name', name, isDark),
                  const Divider(height: 20),
                  _infoRow(
                    'Origin',
                    isAllergenMatch ? 'Mammalian milk / dairy processing' : 'Natural / synthetic source',
                    isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Health & Safety Notes
            Text(
              'Allergen & Safety Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF78350F)
                      : const Color(0xFFFEF3C7),
                ),
              ),
              child: Text(
                isAllergenMatch
                    ? '$name is an ingredient or derivative associated with confirmed allergies. People with milk or dairy allergies should avoid consuming products with this ingredient.'
                    : '$name is commonly used in food manufacturing and has not triggered any alerts based on your current allergen settings.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark
                      ? const Color(0xFFFDE68A)
                      : const Color(0xFF92400E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
