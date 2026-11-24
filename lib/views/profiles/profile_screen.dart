import 'package:flutter/material.dart';
import 'package:foodlence/config/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  final dynamic state;
  final Function(String, [Map<String, dynamic>?])? go;
  final bool showBottomNav;
  final ValueChanged<int>? onTabSelected;

  const ProfileScreen({
    super.key,
    this.state,
    this.go,
    this.showBottomNav = true,
    this.onTabSelected,
  });

  static const Color primaryColor = Color(0xFF16A085);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  final List<Map<String, dynamic>> menuItems = const [
    {
      'icon': '🛡️',
      'label': 'My Allergens',
      'sub': '3 allergens saved',
      'screen': 'allergens',
    },
    {'icon': '🌐', 'label': 'Language', 'sub': 'English', 'screen': 'settings'},
    {
      'icon': '🔔',
      'label': 'Notifications',
      'sub': 'Enabled',
      'screen': 'settings',
    },
    {
      'icon': '🔒',
      'label': 'Privacy',
      'sub': 'Manage your data',
      'screen': 'settings',
    },
    {'icon': '❓', 'label': 'Help & Support', 'sub': null, 'screen': 'settings'},
    {
      'icon': 'ℹ️',
      'label': 'About FoodLense',
      'sub': 'Version 1.0.0',
      'screen': 'settings',
    },
  ];

  void _handleNavigation(
    BuildContext context,
    String screen, [
    Map<String, dynamic>? args,
  ]) {
    if (go != null) {
      go!(screen, args);
      return;
    }
    final target = screen.toLowerCase();
    switch (target) {
      case 'allergens':
        Navigator.of(context).pushNamed(AppRoutes.allergens);
        break;
      case 'settings':
      case 'language':
      case 'languages':
      case 'notifications':
      case 'privacy':
      case 'help':
      case 'help & support':
      case 'about':
      case 'about foodlence':
      case 'about foodlense':
        Navigator.of(context).pushNamed(AppRoutes.settings);
        break;
      case 'login':
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        break;
      default:
        Navigator.of(context).pushNamed(AppRoutes.settings);
        break;
    }
  }

  void _showSwitchProfileModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Switch Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: _profileAvatar('H', primaryColor),
                  title: Text(
                    'Heshan Perera (Active)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  subtitle: Text(
                    'Peanuts, Tree Nuts, Gluten',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  trailing: const Icon(Icons.check_circle, color: primaryColor),
                  onTap: () => Navigator.of(context).pop(),
                ),
                ListTile(
                  leading: _profileAvatar('S', const Color(0xFF3B82F6)),
                  title: Text(
                    'Sachini Perera',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  subtitle: Text(
                    'Dairy, Lactose, Shellfish',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Switched active profile to Sachini'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: _profileAvatar('C', const Color(0xFF10B981)),
                  title: Text(
                    'Child Profile',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  subtitle: Text(
                    'Egg Whites, Cow Milk',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Switched active profile to Child'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of FoodLense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _handleNavigation(context, 'login');
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              _buildProfileHeader(context, isDark),
              _buildMenuSection(context, isDark),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? _buildBottomNavigation(context, isDark)
          : null,
    );
  }

  // Profile Header
  Widget _buildProfileHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'H',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Heshan Perera',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'heshan@example.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF6B7280),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        _buildBadge(
                          '3 allergens',
                          isDark
                              ? const Color(0xFF16A085).withValues(alpha: 0.2)
                              : const Color(0xFFE8F5F2),
                          primaryColor,
                        ),

                        const SizedBox(width: 8),

                        _buildBadge(
                          '5 scans',
                          isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFF3F4F6),
                          isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF6B7280),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Switch Profile
          InkWell(
            onTap: () {
              _showSwitchProfileModal(context);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 58,
                    height: 30,
                    child: Stack(
                      children: [
                        _profileAvatar('H', primaryColor),
                        Positioned(
                          left: 25,
                          child: _profileAvatar('S', const Color(0xFF3B82F6)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Switch Profile',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF374151),
                      ),
                    ),
                  ),

                  Icon(
                    Icons.chevron_right,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF9CA3AF),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Profile Avatar
  Widget _profileAvatar(String letter, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Badges
  Widget _buildBadge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  // Menu Section
  Widget _buildMenuSection(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: List.generate(menuItems.length, (index) {
                  final item = menuItems[index];

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          _handleNavigation(context, item['screen'] as String);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  item['icon'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 21),
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['label'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF111827),
                                      ),
                                    ),

                                    if (item['sub'] != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        item['sub'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              Icon(
                                Icons.chevron_right,
                                size: 20,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFFD1D5DB),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (index < menuItems.length - 1)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFF3F4F6),
                          indent: 20,
                          endIndent: 20,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Logout Button
          InkWell(
            onTap: () {
              _showLogoutDialog(context);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 17),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF7F1D1D)
                      : const Color(0xFFFEE2E2),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Color(0xFFDC2626), size: 20),

                  SizedBox(width: 8),

                  Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation
  Widget _buildBottomNavigation(BuildContext context, bool isDark) {
    return BottomNavigationBar(
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor:
          isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      onTap: (index) {
        if (onTabSelected != null) {
          onTabSelected!(index);
          return;
        }
        if (index == 0) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else if (index == 1) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else if (index == 2) {
          Navigator.of(context).pushNamed(AppRoutes.history);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: 'Scan',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// Backwards compatibility alias for the profile screen.
typedef ProfilesScreen = ProfileScreen;
