import 'package:flutter/material.dart';
import 'package:foodlence/config/app_colors.dart';
import 'package:foodlence/config/app_constants.dart';
import 'package:foodlence/config/app_routes.dart';

/// Main scanner and live analysis preview screen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Dashboard (placeholder)')),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedProfile = 'Dilshan (Nut & Gluten Allergy)';
  String _sampleText =
      'Wheat Flour, Sugar, Palm Oil, Cocoa Butter, Whey Solids (Milk), Soy Lecithin (E322), Peanut Butter, Salt.';
  bool _isAnalyzing = false;
  bool _hasResult = true;

  void _runSimulation(String text) {
    setState(() {
      _sampleText = text;
      _isAnalyzing = true;
      _hasResult = false;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _hasResult = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.eco,
                color: AppColors.primaryGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              AppConstants.appName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Account',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.login);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile selector card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: AppColors.primaryGreen,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Active Health Profile',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          _selectedProfile,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.swap_horiz, color: Colors.grey),
                    onSelected: (val) => setState(() => _selectedProfile = val),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Dilshan (Nut & Gluten Allergy)',
                        child: Text('Dilshan (Nut & Gluten)'),
                      ),
                      const PopupMenuItem(
                        value: 'Child (Dairy & Egg Allergy)',
                        child: Text('Child (Dairy & Egg)'),
                      ),
                      const PopupMenuItem(
                        value: 'Family Profile (Universal Filter)',
                        child: Text('Family (All Combined)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Camera / Scan Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.mintBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: 44,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Point Camera at Food Label',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.navyAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Extracts text with On-Device OCR & AI Analysis',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.document_scanner, size: 18),
                            label: const Text('Scan Packaging'),
                            onPressed: () => _runSimulation(
                              'Wheat Flour, Milk Solids, Peanut Butter, Soy Lecithin E322.',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _runSimulation(
                            'Rolled Oats, Organic Honey, Almond Milk, Chia Seeds.',
                          ),
                          child: const Text('Sample B (Safe)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Live Analysis Result Preview
            if (_isAnalyzing)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: AppColors.primaryGreen),
                      SizedBox(height: 12),
                      Text('Running Semantic AI & Allergen Matching...'),
                    ],
                  ),
                ),
              )
            else if (_hasResult) ...[
              const Text(
                'AI Analysis Result',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Danger Alert Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _sampleText.contains('Peanut')
                      ? AppColors.unsafeBg
                      : AppColors.safeBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _sampleText.contains('Peanut')
                        ? AppColors.unsafeDot
                        : AppColors.safeDot,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _sampleText.contains('Peanut')
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: _sampleText.contains('Peanut')
                          ? AppColors.unsafeText
                          : AppColors.safeText,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _sampleText.contains('Peanut')
                                ? 'ALLERGY WARNING DETECTED'
                                : 'PRODUCT APPEARS SAFE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: _sampleText.contains('Peanut')
                                  ? AppColors.unsafeDark
                                  : AppColors.safeDark,
                            ),
                          ),
                          Text(
                            _sampleText.contains('Peanut')
                                ? 'Contains ingredients conflicting with ${_selectedProfile.split(' ')[0]}\'s profile.'
                                : 'No conflicting allergens found for the active profile.',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Detected Allergens Chips
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detected Ingredients & Allergens',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _sampleText.contains('Peanut')
                            ? [
                                _allergenChip(
                                  'Peanut (High Risk)',
                                  true,
                                  '98%',
                                ),
                                _allergenChip('Wheat / Gluten', true, '95%'),
                                _allergenChip(
                                  'Whey Solids (Dairy)',
                                  true,
                                  '92%',
                                ),
                                _allergenChip('Soy Lecithin', true, '88%'),
                              ]
                            : [
                                _allergenChip('Rolled Oats', false, '99%'),
                                _allergenChip('Honey', false, '97%'),
                                _allergenChip('Almond Milk', false, '96%'),
                              ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        'Chemical Additives & E-Numbers',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'E322',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Lecithins (Emulsifier / Stabilizer)',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _allergenChip(String name, bool isRisk, String confidence) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isRisk ? AppColors.unsafeBg : AppColors.chipBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRisk ? AppColors.unsafeBorder : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRisk ? Icons.dangerous : Icons.check,
            size: 14,
            color: isRisk ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isRisk ? AppColors.unsafeDeep : Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              confidence,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
