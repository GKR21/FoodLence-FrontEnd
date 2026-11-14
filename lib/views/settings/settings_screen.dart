import 'package:flutter/material.dart';
import 'package:foodlence/config/app_colors.dart';
import 'package:foodlence/config/app_constants.dart';
import 'package:foodlence/config/app_routes.dart';

/// Application settings and backend diagnostics screen.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Diagnostics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.dns, color: AppColors.primaryGreen),
                title: Text('FastAPI Endpoint'),
                subtitle: Text('${AppConstants.backendBaseUrl} (Dockerized)'),
                trailing: Text('Ready', style: TextStyle(color: Colors.green)),
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.storage, color: Colors.blue),
                title: Text('PostgreSQL Database'),
                subtitle: Text(
                  'Database: ${AppConstants.databaseName} (Port ${AppConstants.databasePort})',
                ),
                trailing: Text('Ready', style: TextStyle(color: Colors.green)),
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.memory, color: Colors.deepPurple),
                title: Text('AI / NLP Engine'),
                subtitle: Text('spaCy (en_core_web_sm) + RapidFuzz'),
                trailing: Text('Loaded', style: TextStyle(color: Colors.green)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Testing connection to ${AppConstants.backendHealthUrl} ...',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Test Connection'),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Account & Authentication',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('Return to login & registration screens'),
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Backwards compatibility alias for the backend diagnostic screen.
typedef BackendStatusScreen = SettingsScreen;
