import 'package:flutter/material.dart';
import '../../config/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool darkMode = false;
  bool highContrast = false;
  bool largeText = false;
  String language = "English";

  static const Color primaryColor = Color(0xFF16A085);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
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
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
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
                    _sectionTitle("Language"),
                    _settingsCard([
                      _optionTile(
                        title: "English",
                        selected: language == "English",
                        onTap: () {
                          setState(() {
                            language = "English";
                          });
                        },
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Appearance
                    _sectionTitle("Appearance"),
                    _settingsCard([
                      _optionTile(
                        title: "Light",
                        selected: !darkMode,
                        onTap: () {
                          setState(() {
                            darkMode = false;
                          });
                        },
                      ),
                      _optionTile(
                        title: "Dark",
                        selected: darkMode,
                        onTap: () {
                          setState(() {
                            darkMode = true;
                          });
                        },
                      ),
                      _optionTile(
                        title: "System Default",
                        selected: false,
                        onTap: () {
                          setState(() {
                            darkMode = false;
                          });
                        },
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Notifications
                    _sectionTitle("Notifications"),
                    _settingsCard([
                      _toggleTile(
                        title: "Push Notifications",
                        subtitle: "Analysis results and updates",
                        value: notifications,
                        onChanged: (value) {
                          setState(() {
                            notifications = value;
                          });
                        },
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Accessibility
                    _sectionTitle("Accessibility"),
                    _settingsCard([
                      _toggleTile(
                        title: "Larger Text",
                        subtitle: "Increase text size",
                        value: largeText,
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
                        onChanged: (value) {
                          setState(() {
                            highContrast = value;
                          });
                        },
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Privacy
                    _sectionTitle("Privacy"),
                    _settingsCard([
                      _navigationTile(
                        "Manage Scan History",
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.history);
                        },
                      ),
                      _navigationTile(
                        "Account Privacy",
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account data is stored securely and private.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      _navigationTile(
                        "Delete Account",
                        isDestructive: true,
                        onTap: () {
                          _showDeleteAccountDialog();
                        },
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9CA3AF),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  // Settings card with inner dividers
  Widget _settingsCard(List<Widget> children) {
    final List<Widget> divided = [];
    for (int i = 0; i < children.length; i++) {
      divided.add(children[i]);
      if (i < children.length - 1) {
        divided.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF3F4F6),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
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

  // Option tile with checkmark
  Widget _optionTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                ),
              ),
          ],
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
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
            inactiveTrackColor: const Color(0xFFE5E7EB),
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
  }) {
    final color = isDestructive
        ? const Color(0xFFDC2626)
        : const Color(0xFF111827);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  : const Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }

  // Delete account confirmation
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account? "
          "This action cannot be undone.",
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
