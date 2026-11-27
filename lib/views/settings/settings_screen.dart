import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../config/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  String appearance = "Light"; // "Light", "Dark", "System Default"
  bool highContrast = false;
  bool largeText = false;
  String language = "English";

  static const Color primaryColor = Color(0xFF16A085);

  @override
  void initState() {
    super.initState();
    final mode = AppTheme.themeMode;
    if (mode == ThemeMode.dark) {
      appearance = "Dark";
    } else if (mode == ThemeMode.light) {
      appearance = "Light";
    } else {
      appearance = "System Default";
    }
  }

  @override
  Widget build(BuildContext context) {
    final systemIsDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final isDark =
        appearance == "Dark" || (appearance == "System Default" && systemIsDark);
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final headerBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: headerBgColor,
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Back",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
            ),

            // Settings content
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Column(
                  children: [
                    // Language
                    _sectionTitle("Language", isDark: isDark),
                    _settingsCard([
                      _optionTile(
                        title: language,
                        subtitle: "Tap to change language",
                        selected: true,
                        isDark: isDark,
                        icon: Icons.language,
                        onTap: () => _showLanguagePicker(context, isDark),
                      ),
                    ], isDark: isDark),

                    const SizedBox(height: 16),

                    // Appearance
                    _sectionTitle("Appearance", isDark: isDark),
                    _settingsCard([
                      _optionTile(
                        title: "Light",
                        icon: Icons.light_mode_outlined,
                        selected: appearance == "Light",
                        isDark: isDark,
                        onTap: () {
                          setState(() {
                            appearance = "Light";
                          });
                          AppTheme.setThemeMode(ThemeMode.light);
                        },
                      ),
                      _optionTile(
                        title: "Dark",
                        icon: Icons.dark_mode_outlined,
                        selected: appearance == "Dark",
                        isDark: isDark,
                        onTap: () {
                          setState(() {
                            appearance = "Dark";
                          });
                          AppTheme.setThemeMode(ThemeMode.dark);
                        },
                      ),
                      _optionTile(
                        title: "System Default",
                        icon: Icons.brightness_auto_outlined,
                        selected: appearance == "System Default",
                        isDark: isDark,
                        onTap: () {
                          setState(() {
                            appearance = "System Default";
                          });
                          AppTheme.setThemeMode(ThemeMode.system);
                        },
                      ),
                    ], isDark: isDark),

                    const SizedBox(height: 16),

                    // Notifications
                    _sectionTitle("Notifications", isDark: isDark),
                    _settingsCard([
                      _toggleTile(
                        title: "Push Notifications",
                        subtitle: "Analysis results and updates",
                        value: notifications,
                        isDark: isDark,
                        onChanged: (value) {
                          setState(() {
                            notifications = value;
                          });
                        },
                      ),
                    ], isDark: isDark),

                    const SizedBox(height: 16),

                    // Accessibility
                    _sectionTitle("Accessibility", isDark: isDark),
                    _settingsCard([
                      _toggleTile(
                        title: "Larger Text",
                        subtitle: "Increase text size",
                        value: largeText,
                        isDark: isDark,
                        onChanged: (value) {
                          setState(() {
                            largeText = value;
                          });
                        },
                      ),
                      _toggleTile(
                        title: "High Contrast",
                        subtitle: "Improve visibility",
                        value: highContrast,
                        isDark: isDark,
                        onChanged: (value) {
                          setState(() {
                            highContrast = value;
                          });
                        },
                      ),
                    ], isDark: isDark),

                    const SizedBox(height: 16),

                    // Privacy
                    _sectionTitle("Privacy", isDark: isDark),
                    _settingsCard([
                      _navigationTile(
                        "Manage Scan History",
                        isDark: isDark,
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.history);
                        },
                      ),
                      _navigationTile(
                        "Account Privacy",
                        isDark: isDark,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Account data is stored securely and private.',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      _navigationTile(
                        "Delete Account",
                        isDestructive: true,
                        isDark: isDark,
                        onTap: () {
                          _showDeleteAccountDialog(isDark);
                        },
                      ),
                    ], isDark: isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Language selection modal bottom sheet
  void _showLanguagePicker(BuildContext context, bool isDark) {
    final languages = [
      {'name': 'English', 'native': 'English (US)'},
      {'name': 'Spanish', 'native': 'Español'},
      {'name': 'French', 'native': 'Français'},
      {'name': 'German', 'native': 'Deutsch'},
      {'name': 'Sinhala', 'native': 'සිංහල'},
      {'name': 'Tamil', 'native': 'தமிழ்'},
      {'name': 'Japanese', 'native': '日本語'},
      {'name': 'Chinese', 'native': '中文'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Language',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE5E7EB),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF3F4F6),
                    ),
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      final isSelected = language == lang['name'];
                      return ListTile(
                        title: Text(
                          lang['name']!,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isDark ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                        subtitle: Text(
                          lang['native']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        trailing: isSelected
                            ? Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            language = lang['name']!;
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Language switched to ${lang['name']}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Section title
  Widget _sectionTitle(String title, {bool isDark = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  // Settings card with inner dividers
  Widget _settingsCard(List<Widget> children, {bool isDark = false}) {
    final List<Widget> divided = [];
    for (int i = 0; i < children.length; i++) {
      divided.add(children[i]);
      if (i < children.length - 1) {
        divided.add(
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: divided,
        ),
      ),
    );
  }

  // Option tile with visible selection indicator (checkmark or outline circle)
  Widget _optionTile({
    required String title,
    String? subtitle,
    required bool selected,
    required VoidCallback onTap,
    IconData? icon,
    bool isDark = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: primaryColor.withValues(alpha: 0.12),
        highlightColor: primaryColor.withValues(alpha: 0.06),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: Colors.transparent, // Ensures the entire tile is hit-testable
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: selected
                          ? primaryColor
                          : (isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF6B7280)),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
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
                ],
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? primaryColor : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? primaryColor
                        : (isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFD1D5DB)),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 13,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Toggle tile
  Widget _toggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isDark = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: primaryColor,
            inactiveTrackColor:
                isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
            inactiveThumbColor: Colors.white,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  // Privacy navigation tile
  Widget _navigationTile(
    String title, {
    required VoidCallback onTap,
    bool isDestructive = false,
    bool isDark = false,
  }) {
    final color = isDestructive
        ? const Color(0xFFDC2626)
        : (isDark ? Colors.white : const Color(0xFF111827));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: isDestructive
                    ? const Color(0xFFDC2626)
                    : (isDark ? const Color(0xFF64748B) : const Color(0xFFD1D5DB)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete account confirmation
  void _showDeleteAccountDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          "Delete Account",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        content: Text(
          "Are you sure you want to delete your account? "
          "This action cannot be undone.",
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Backwards compatibility alias for the backend diagnostic screen.
typedef BackendStatusScreen = SettingsScreen;
