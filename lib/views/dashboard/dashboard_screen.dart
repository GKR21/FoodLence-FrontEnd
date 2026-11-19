import 'package:flutter/material.dart';
import 'package:foodlence/config/app_colors.dart';
import 'package:foodlence/config/app_routes.dart';
import 'package:foodlence/models/scan_model.dart';
import 'package:foodlence/widgets/dashboard/quick_action_card.dart';
import 'package:foodlence/widgets/dashboard/safety_summary_card.dart';

/// Main Dashboard and Home screen matching the FoodLense UI design.
class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenScanner;
  final VoidCallback? onOpenHistory;
  final VoidCallback? onOpenProfile;

  const HomeScreen({
    super.key,
    this.onOpenScanner,
    this.onOpenHistory,
    this.onOpenProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAnalyzing = false;
  ScanItem? _simulatedResult;

  void _runScanSimulation({required bool isSafe}) {
    setState(() {
      _isAnalyzing = true;
      _simulatedResult = null;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _simulatedResult = isSafe
            ? const ScanItem(
                name: 'Organic Almond Granola Bar',
                date: 'Just now',
                verdict: Verdict.safe,
                img:
                    'https://images.unsplash.com/photo-1571748982800-fa51082c2224?w=80&h=80&fit=crop&auto=format',
              )
            : const ScanItem(
                name: 'Chocolate Chip Cookies (Contains Peanuts)',
                date: 'Just now',
                verdict: Verdict.unsafe,
                img:
                    'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=80&h=80&fit=crop&auto=format',
              );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(context),
              const SizedBox(height: 20),
              SafetySummaryCard(
                onScanNow: () {
                  if (widget.onOpenScanner != null) {
                    widget.onOpenScanner!();
                  } else {
                    _runScanSimulation(isSafe: false);
                  }
                },
                onUploadImage: () => _runScanSimulation(isSafe: true),
              ),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              if (_isAnalyzing)
                _buildAnalysisLoading()
              else if (_simulatedResult != null) ...[
                _buildSimulationResultCard(_simulatedResult!),
                const SizedBox(height: 20),
              ],
              _buildRecentScansSection(context),
              const SizedBox(height: 16),
              _buildOfflineBanner(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Top Header with greeting, name, active profile and right side action buttons
  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good morning 👋',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Heshan',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            RichText(
              text: const TextSpan(
                text: 'Scanning for: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9CA3AF),
                ),
                children: [
                  TextSpan(
                    text: 'Heshan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16A085),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Notification bell with red badge dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF374151),
                      size: 22,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No new allergen alert notifications.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 9,
                  right: 11,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // User Avatar circle 'H'
            InkWell(
              onTap: () {
                if (widget.onOpenProfile != null) {
                  widget.onOpenProfile!();
                } else {
                  Navigator.of(context).pushNamed(AppRoutes.profiles);
                }
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A085),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'H',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Quick Actions: My Allergens, Search, Scan History, Learn
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            QuickActionCard(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              title: 'My Allergens',
              onTap: () {
                if (widget.onOpenProfile != null) {
                  widget.onOpenProfile!();
                } else {
                  Navigator.of(context).pushNamed(AppRoutes.profiles);
                }
              },
            ),
            const SizedBox(width: 10),
            QuickActionCard(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
              ),
              title: 'Search',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Ingredient Database Search...'),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            QuickActionCard(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
              ),
              title: 'Scan History',
              onTap: () {
                if (widget.onOpenHistory != null) {
                  widget.onOpenHistory!();
                } else {
                  Navigator.of(context).pushNamed(AppRoutes.history);
                }
              },
            ),
            const SizedBox(width: 10),
            QuickActionCard(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.style_outlined,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              title: 'Learn',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
            ),
          ],
        ),
      ],
    );
  }

  // Recent Scans Section with "See all" header
  Widget _buildRecentScansSection(BuildContext context) {
    final recentItems = kHistory.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Scans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            InkWell(
              onTap: () {
                if (widget.onOpenHistory != null) {
                  widget.onOpenHistory!();
                } else {
                  Navigator.of(context).pushNamed(AppRoutes.history);
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A085),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentItems.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = recentItems[index];
            return _buildRecentScanTile(context, item);
          },
        ),
      ],
    );
  }

  // Individual recent scan card matching screenshot
  Widget _buildRecentScanTile(BuildContext context, ScanItem item) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.historyDetail, arguments: item);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            // Food image thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.img,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fastfood_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Title & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Status Badge (Safe, Caution, Unsafe)
            _buildVerdictBadge(item.verdict),
          ],
        ),
      ),
    );
  }

  // Verdict status badge pill matching screenshots
  Widget _buildVerdictBadge(Verdict verdict) {
    final (String label, Color bg, Color fg) = switch (verdict) {
      Verdict.safe => (
        '✓ Safe',
        const Color(0xFFDCFCE7),
        const Color(0xFF16A34A),
      ),
      Verdict.caution => (
        '⚠️ Caution',
        const Color(0xFFFEF3C7),
        const Color(0xFFD97706),
      ),
      Verdict.unsafe => (
        '✕ Unsafe',
        const Color(0xFFFEE2E2),
        const Color(0xFFDC2626),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  // Offline mode alert banner from Screenshot 2
  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFEDD5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Color(0xFFEA580C), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Offline mode — analysis requires internet',
              style: TextStyle(
                color: Color(0xFF9A3412),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisLoading() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
      ),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: AppColors.teal),
            SizedBox(height: 12),
            Text(
              'Analyzing food label with AI & OCR...',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationResultCard(ScanItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.verdict == Verdict.safe
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.verdict == Verdict.safe
              ? const Color(0xFF86EFAC)
              : const Color(0xFFFCA5A5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            item.verdict == Verdict.safe
                ? Icons.check_circle_outline
                : Icons.warning_amber_rounded,
            color: item.verdict == Verdict.safe
                ? const Color(0xFF16A34A)
                : const Color(0xFFDC2626),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.verdict == Verdict.safe
                      ? 'PRODUCT APPEARS SAFE'
                      : 'ALLERGEN WARNING DETECTED',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: item.verdict == Verdict.safe
                        ? const Color(0xFF15803D)
                        : const Color(0xFFB91C1C),
                  ),
                ),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Backwards compatibility alias for the dashboard screen.
typedef DashboardScreen = HomeScreen;
