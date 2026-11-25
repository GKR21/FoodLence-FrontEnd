import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../widgets/results/allergen_warning_card.dart';
import '../../widgets/results/ingredient_card.dart';
import '../../widgets/results/safety_status_card.dart';

/// Full screen displaying the food label scan results (Safe, Caution, Unsafe).
class ResultScreen extends StatefulWidget {
  final String resultType; // 'safe', 'caution', 'unsafe'
  final VoidCallback? onHome;
  final Function(String)? onIngredientDetail;
  final VoidCallback? onScanner;
  final VoidCallback? onHistory;
  final Widget? bottomNavigation;

  const ResultScreen({
    super.key,
    this.resultType = 'unsafe',
    this.onHome,
    this.onIngredientDetail,
    this.onScanner,
    this.onHistory,
    this.bottomNavigation,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showAllIngredients = false;

  // Demo allergen matches matching the UI designs
  final List<AllergenMatchItem> _allergenMatches = const [
    AllergenMatchItem(
      name: 'Casein',
      category: 'Protein',
      matchType: 'Related Ingredient',
      allergen: 'Milk',
      sensitivity: 'High',
      reason: 'Casein is a protein commonly derived from milk.',
    ),
    AllergenMatchItem(
      name: 'Milk Powder',
      category: 'Dairy ingredient',
      matchType: 'Exact Match',
      allergen: 'Milk',
      sensitivity: 'High',
      reason: 'Milk powder is a direct dairy ingredient.',
    ),
  ];

  // Demo ingredients list
  final List<IngredientCardItem> _allIngredients = const [
    IngredientCardItem(name: 'Wheat Flour', category: 'Grain', isSafe: true),
    IngredientCardItem(
      name: 'Sodium Benzoate',
      category: 'Preservative · E211',
      isSafe: true,
    ),
    IngredientCardItem(
      name: 'Lecithin (Soy)',
      category: 'Emulsifier · E322',
      isSafe: true,
    ),
    IngredientCardItem(
      name: 'Casein',
      category: 'Protein · Related to Milk',
      isSafe: false,
    ),
    IngredientCardItem(
      name: 'Milk Powder',
      category: 'Dairy · Direct Match',
      isSafe: false,
    ),
    IngredientCardItem(name: 'Sugar', category: 'Sweetener', isSafe: true),
    IngredientCardItem(name: 'Cocoa Powder', category: 'Flavoring', isSafe: true),
  ];

  void _handleBack() {
    if (widget.onHome != null) {
      widget.onHome!();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
    }
  }

  void _handleIngredientDetail(String name) {
    if (widget.onIngredientDetail != null) {
      widget.onIngredientDetail!(name);
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.ingredientDetail,
        arguments: name,
      );
    }
  }

  void _handleScanner() {
    if (widget.onScanner != null) {
      widget.onScanner!();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  void _handleHistory() {
    if (widget.onHistory != null) {
      widget.onHistory!();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.history);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSafe = widget.resultType.toLowerCase() == 'safe';

    // Show only first 3 ingredients unless "Show all" is toggled
    final displayedIngredients = _showAllIngredients
        ? _allIngredients
        : _allIngredients.take(3).toList();

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Status Header (Safe / Caution / Unsafe)
            SafetyStatusCard(
              resultType: widget.resultType,
              onBack: _handleBack,
            ),

            // Safe Mode Advisory Notice Box
            if (isSafe) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E3A8A).withValues(alpha: 0.3)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2563EB).withValues(alpha: 0.4)
                          : const Color(0xFFDBEAFE),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: isDark
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFF3B82F6),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Always verify the original product label, especially for severe allergies.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? const Color(0xFF93C5FD)
                                : const Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Allergen Matches Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFF59E0B),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Allergen Matches (${_allergenMatches.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),

            // Allergen Match Cards List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _allergenMatches.map((match) {
                  return AllergenWarningCard(
                    item: match,
                    onViewDetails: () => _handleIngredientDetail(match.name),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // All Ingredients Breakdown Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Ingredients (${_allIngredients.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showAllIngredients = !_showAllIngredients;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        _showAllIngredients ? 'Show less' : 'Show all',
                        style: const TextStyle(
                          color: Color(0xFF16A085),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Ingredients List Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: displayedIngredients.map((ing) {
                  return IngredientCard(
                    item: ing,
                    onTap: () => _handleIngredientDetail(ing.name),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Actions: Scan Another & View History
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _handleScanner,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF16A085),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Scan Another',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleHistory,
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            isDark ? const Color(0xFF1E293B) : Colors.white,
                        foregroundColor:
                            isDark ? Colors.white : const Color(0xFF1F2937),
                        minimumSize: const Size(double.infinity, 52),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE5E7EB),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'View History',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom padding to ensure comfortable scrolling above bottom bar
            const SizedBox(height: 36),
          ],
        ),
      ),
      bottomNavigationBar: widget.bottomNavigation ?? _buildDefaultBottomDock(isDark),
    );
  }

  // Default fallback bottom dock if none is supplied
  Widget _buildDefaultBottomDock(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _dockItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isSelected: false,
                isDark: isDark,
                onTap: _handleBack,
              ),
              _scanButton(),
              _dockItem(
                icon: Icons.access_time_rounded,
                label: 'History',
                isSelected: false,
                isDark: isDark,
                onTap: _handleHistory,
              ),
              _dockItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isSelected: false,
                isDark: isDark,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.profiles),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dockItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final color = isSelected
        ? const Color(0xFF16A085)
        : (isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scanButton() {
    return GestureDetector(
      onTap: _handleScanner,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF16A085),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF16A085).withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Scan',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF16A085),
            ),
          ),
        ],
      ),
    );
  }
}

/// Backwards compatibility alias matching the file architecture.
typedef ScanResultScreen = ResultScreen;
