import 'package:flutter/material.dart';
import 'views/home/profile_selector.dart';
import 'views/profiles/profile_list_screen.dart';

void main() {
  runApp(const FoodLenceApp());
}

class FoodLenceApp extends StatelessWidget {
  const FoodLenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodLence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F9D58),
          brightness: Brightness.light,
          primary: const Color(0xFF0F9D58),
          surface: const Color(0xFFF8FAF9),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CompareScreen(),
    ProfileListScreen(),
    BackendStatusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
            icon: Icon(Icons.compare_arrows_outlined),
            selectedIcon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Profiles',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_sync_outlined),
            selectedIcon: Icon(Icons.cloud_sync),
            label: 'Backend',
          ),
        ],
      ),
    );
  }
}

// ----------------- 1. SCANNER & HOME SCREEN -----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
        title: const Text(
          'FoodLence',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          const ProfileSelectorChip(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
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
                  const Icon(Icons.person, color: Color(0xFF0F9D58), size: 22),
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
                              fontWeight: FontWeight.w600, fontSize: 13),
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
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF0F9D58).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_outlined,
                              size: 44, color: Color(0xFF0F9D58)),
                          const SizedBox(height: 8),
                          const Text(
                            'Point Camera at Food Label',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1E3A8A),
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
                              backgroundColor: const Color(0xFF0F9D58),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.document_scanner, size: 18),
                            label: const Text('Scan Packaging'),
                            onPressed: () => _runSimulation(
                                'Wheat Flour, Milk Solids, Peanut Butter, Soy Lecithin E322.'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _runSimulation(
                              'Rolled Oats, Organic Honey, Almond Milk, Chia Seeds.'),
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
                      CircularProgressIndicator(color: Color(0xFF0F9D58)),
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
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _sampleText.contains('Peanut')
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF22C55E),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _sampleText.contains('Peanut')
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: _sampleText.contains('Peanut')
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF16A34A),
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
                                  ? const Color(0xFFB91C1C)
                                  : const Color(0xFF15803D),
                            ),
                          ),
                          Text(
                            _sampleText.contains('Peanut')
                                ? 'Contains ingredients conflicting with ${ _selectedProfile.split(' ')[0] }\'s profile.'
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
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _sampleText.contains('Peanut')
                            ? [
                                _allergenChip('Peanut (High Risk)', true, '98%'),
                                _allergenChip('Wheat / Gluten', true, '95%'),
                                _allergenChip('Whey Solids (Dairy)', true, '92%'),
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
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('E322',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
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
        color: isRisk ? const Color(0xFFFEE2E2) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isRisk ? const Color(0xFFFCA5A5) : Colors.grey.shade300,
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
              color: isRisk ? const Color(0xFF991B1B) : Colors.black87,
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

// ----------------- 2. COMPARE PRODUCTS SCREEN -----------------
class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Comparison')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: const Color(0xFFFEF2F2),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Product A',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Standard Biscuit',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('❌ 4 Allergens'),
                          Text('⚠️ 3 Additives (E322, E471, E500)'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: const Color(0xFFF0FDF4),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Product B (Recommended)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF15803D))),
                          Text('Gluten-Free Oat Cookie',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('✅ 0 Major Allergens'),
                          Text('✅ 1 Additive (E500)'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.lightbulb_outline, color: Colors.amber),
                title: Text('Recommendation: Choose Product B'),
                subtitle: Text(
                    'Product B has 75% fewer additives and matches your household dietary restriction profile.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- 3. PROFILES SCREEN -----------------
class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dietary & Allergy Profiles')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('D')),
              title: Text('Dilshan (Self)'),
              subtitle: Text('Severe: Peanuts, Tree Nuts | Moderate: Gluten'),
              trailing: Icon(Icons.edit, size: 20),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('C')),
              title: Text('Child'),
              subtitle: Text('Severe: Cow Milk (Lactose, Casein), Egg Whites'),
              trailing: Icon(Icons.edit, size: 20),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('P')),
              title: Text('Partner'),
              subtitle: Text('No severe allergies. Vegetarian preference.'),
              trailing: Icon(Icons.edit, size: 20),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        label: const Text('Add Member'),
      ),
    );
  }
}

// ----------------- 4. BACKEND DIAGNOSTICS SCREEN -----------------
class BackendStatusScreen extends StatelessWidget {
  const BackendStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backend API Diagnostics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.dns, color: Color(0xFF0F9D58)),
                title: Text('FastAPI Endpoint'),
                subtitle: Text('http://localhost:8000 (Dockerized)'),
                trailing: Text('Ready', style: TextStyle(color: Colors.green)),
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.storage, color: Colors.blue),
                title: Text('PostgreSQL Database'),
                subtitle: Text('Database: foodlence_db (Port 5432)'),
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
                      content: Text('Testing connection to http://localhost:8000/health ...'),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Test Connection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
