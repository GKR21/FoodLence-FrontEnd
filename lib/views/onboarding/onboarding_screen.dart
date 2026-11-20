import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';

/// Onboarding screen matching the exact FoodLense onboarding UI design.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  final VoidCallback? onSkip;
  final VoidCallback? onLogin;

  const OnboardingScreen({
    super.key,
    this.onFinish,
    this.onSkip,
    this.onLogin,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    if (widget.onFinish != null) {
      widget.onFinish!();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.disclaimer);
    }
  }

  void _skip() {
    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  void _goToLogin() {
    if (widget.onLogin != null) {
      widget.onLogin!();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 8),
                child: TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16A085),
                    ),
                  ),
                ),
              ),
            ),

            // Page carousel
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildPage(
                    illustration: _buildScanIllustration(),
                    title: 'Scan Food Labels Instantly',
                    description:
                        'Capture an ingredient label and let FoodLense identify what\'s inside — no more guessing.',
                  ),
                  _buildPage(
                    illustration: _buildAllergenIllustration(),
                    title: 'Personalized Allergen\nDetection',
                    description:
                        'FoodLense compares ingredients against your personal allergen profile and alerts you instantly.',
                  ),
                  _buildPage(
                    illustration: _buildIngredientIllustration(),
                    title: 'Understand Every\nIngredient',
                    description:
                        'Learn what ingredients, additives and E-numbers mean before you consume them.',
                  ),
                ],
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isActive = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 24 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF16A085)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Bottom CTA button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF16A085),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: const Color(0x3816A085),
                  ),
                  onPressed: _onNext,
                  child: Text(
                    _currentPage == 2 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // "I already have an account" link on page 3
            if (_currentPage == 2) ...[
              const SizedBox(height: 18),
              InkWell(
                onTap: _goToLogin,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text(
                    'I already have an account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              const SizedBox(height: 48),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required Widget illustration,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          illustration,
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // Illustration 1: Food Label Document with Checkmark
  Widget _buildScanIllustration() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4F1),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Center(
        child: Container(
          width: 88,
          height: 110,
          padding: const EdgeInsets.fromLTRB(10, 14, 10, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF16A085), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBar(width: 58, color: const Color(0xFF99D5C7)),
              const SizedBox(height: 7),
              _buildBar(width: 44, color: const Color(0xFF99D5C7)),
              const SizedBox(height: 7),
              _buildBar(width: 50, color: const Color(0xFF99D5C7)),
              const Spacer(),
              Container(
                height: 32,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4EDE6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A085),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Illustration 2: Large Checkmark Circle connected to 3 Allergen Boxes
  Widget _buildAllergenIllustration() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3FF),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Check Circle Badge
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFD5ECE5),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF16A085), width: 2.2),
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF16A085),
                size: 32,
              ),
            ),

            // Dotted vertical line
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                height: 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDot(),
                    _buildDot(),
                    _buildDot(),
                  ],
                ),
              ),
            ),

            // 3 Allergen Boxes (Yellow, Red, Green)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAllergenChip(
                  color: const Color(0xFFFEF3C7),
                  borderColor: const Color(0xFFFBBF24),
                ),
                const SizedBox(width: 8),
                _buildAllergenChip(
                  color: const Color(0xFFFEE2E2),
                  borderColor: const Color(0xFFF87171),
                ),
                const SizedBox(width: 8),
                _buildAllergenChip(
                  color: const Color(0xFFDCFCE7),
                  borderColor: const Color(0xFF34D399),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Illustration 3: Ingredient card with Top-Right Checkmark Badge
  Widget _buildIngredientIllustration() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4F1),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Center(
        child: SizedBox(
          width: 96,
          height: 76,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Card
              Container(
                width: 96,
                height: 76,
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF16A085), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBar(width: 44, color: const Color(0xFF99D5C7)),
                    _buildBar(width: 62, color: const Color(0xFFCBD5E1)),
                    _buildBar(width: 36, color: const Color(0xFFCBD5E1)),
                  ],
                ),
              ),

              // Overlapping Top-Right Badge
              Positioned(
                top: -10,
                right: -8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A085),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar({required double width, required Color color}) {
    return Container(
      height: 5.5,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 2.5,
      height: 2.5,
      decoration: const BoxDecoration(
        color: Color(0xFF16A085),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildAllergenChip({
    required Color color,
    required Color borderColor,
  }) {
    return Container(
      width: 32,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: borderColor, width: 2),
      ),
    );
  }
}
