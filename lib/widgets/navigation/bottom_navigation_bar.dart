import 'package:flutter/material.dart';
import 'package:foodlence/config/app_routes.dart';
import 'package:foodlence/config/app_theme.dart';
import 'package:foodlence/models/scan_model.dart';
import 'package:foodlence/views/dashboard/dashboard_screen.dart';
import 'package:foodlence/views/history/history_detail_screen.dart';
import 'package:foodlence/views/history/history_screen.dart';
import 'package:foodlence/views/profiles/profile_screen.dart';
import 'package:foodlence/views/scanner/scanner_screen.dart';

/// Root navigation shell hosting the 4 main app sections with a custom dock bottom bar.
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onOpenScanner: () => _onTabTapped(1),
        onOpenHistory: () => _onTabTapped(2),
        onOpenProfile: () => _onTabTapped(3),
      ),
      ScannerScreen(
        onClose: () => _onTabTapped(0),
        go: (route, {data}) {
          if (route == "home") {
            _onTabTapped(0);
          } else if (route == "processing") {
            Navigator.of(context).pushNamed(AppRoutes.processing);
          }
        },
      ),
      HistoryListScreen(
        bottomNavigationBar: null,
        onItemTap: (ScanItem item) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HistoryDetailScreen(
                item: item,
                onScanAnother: () {
                  Navigator.of(context).pop();
                  _onTabTapped(0);
                },
              ),
            ),
          );
        },
        onStartScanning: () {
          _onTabTapped(0);
        },
      ),
      ProfileScreen(
        showBottomNav: false,
        onTabSelected: _onTabTapped,
        go: (screen, [args]) {
          final target = screen.toLowerCase();
          if (target == 'allergens') {
            Navigator.of(context).pushNamed(AppRoutes.allergens);
          } else if (target == 'login') {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
          } else {
            Navigator.of(context).pushNamed(AppRoutes.settings);
          }
        },
      ),
    ];

    final isDark = AppTheme.isDark(context);
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;

    // If on scanner screen, show full screen without bottom navigation bar
    if (_currentIndex == 1) {
      return Scaffold(body: pages[1]);
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: _buildCustomBottomNavigationBar(isDark),
    );
  }

  // Custom Bottom Navigation Bar matching the provided screenshots
  Widget _buildCustomBottomNavigationBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x33000000) : const Color(0x0C000000),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 0: Home Tab
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
                isDark: isDark,
              ),

              // 1: Scan Tab (Raised circular teal button)
              _buildRaisedScanButton(isDark),

              // 2: History Tab
              _buildNavItem(
                index: 2,
                icon: Icons.access_time_rounded,
                label: 'History',
                isDark: isDark,
              ),

              // 3: Profile Tab
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    bool isDark = false,
  }) {
    final isSelected = _currentIndex == index;
    const activeColor = Color(0xFF16A085);
    final inactiveColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF);

    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Raised Circular Center "Scan" Button matching screenshots
  Widget _buildRaisedScanButton(bool isDark) {
    return InkWell(
      onTap: () => _onTabTapped(1),
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFF16A085),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3816A085),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -6),
            child: Text(
              'Scan',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
