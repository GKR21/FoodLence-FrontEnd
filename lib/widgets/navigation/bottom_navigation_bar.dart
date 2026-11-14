import 'package:flutter/material.dart';
import 'package:foodlence/models/scan_model.dart';
import 'package:foodlence/views/dashboard/dashboard_screen.dart';
import 'package:foodlence/views/history/history_detail_screen.dart';
import 'package:foodlence/views/history/history_screen.dart';
import 'package:foodlence/views/profiles/profile_screen.dart';
import 'package:foodlence/views/settings/settings_screen.dart';

/// Root navigation shell hosting the main bottom navigation tabs.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      HistoryListScreen(
        onItemTap: (ScanItem item) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HistoryDetailScreen(
                item: item,
                onScanAnother: () {
                  Navigator.of(context).pop();
                  setState(() => _currentIndex = 0);
                },
              ),
            ),
          );
        },
        onStartScanning: () {
          setState(() => _currentIndex = 0);
        },
      ),
      const ProfilesScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            selectedIcon: Icon(Icons.document_scanner),
            label: 'Scanner',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Profiles',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
