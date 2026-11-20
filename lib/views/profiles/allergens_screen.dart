import 'package:flutter/material.dart';
import '../../config/app_routes.dart';

/// Allergen management screen for viewing, editing, and adding user allergens.
class AllergensScreen extends StatefulWidget {
  final Function(String, {Map<String, dynamic>? data})? go;
  final Widget? bottomNavigationBar;

  const AllergensScreen({
    super.key,
    this.go,
    this.bottomNavigationBar,
  });

  @override
  State<AllergensScreen> createState() => _AllergensScreenState();
}

class _AllergensScreenState extends State<AllergensScreen> {
  late List<Map<String, dynamic>> _myAllergens;

  @override
  void initState() {
    super.initState();
    _myAllergens = [
      {
        'name': 'Milk / Dairy',
        'severity': 'High',
        'icon': '🥛',
        'type': 'Confirmed allergy',
      },
      {
        'name': 'Peanuts',
        'severity': 'High',
        'icon': '🥜',
        'type': 'Confirmed allergy',
      },
      {
        'name': 'Wheat',
        'severity': 'Moderate',
        'icon': '🌾',
        'type': 'Sensitivity',
      },
    ];
  }

  void _navigate(String target, {Map<String, dynamic>? data}) {
    if (widget.go != null) {
      widget.go!(target, data: data);
      return;
    }
    if (target == 'home') {
      Navigator.of(context).maybePop();
    } else if (target == 'allergen-setup') {
      _showAddAllergenDialog();
    }
  }

  void _showAddAllergenDialog() {
    final nameController = TextEditingController();
    String selectedSeverity = 'High';
    String selectedType = 'Confirmed allergy';
    String selectedIcon = '⚠️';

    final iconOptions = ['🥛', '🥜', '🌾', '🥚', '🦐', '🐟', '🌰', '🫘', '⚠️'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Allergen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Allergen Name',
                  hintText: 'e.g. Soy, Shellfish, Sesame',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Icon',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: iconOptions.map((emoji) {
                  final isSelected = selectedIcon == emoji;
                  return ChoiceChip(
                    label: Text(emoji, style: const TextStyle(fontSize: 18)),
                    selected: isSelected,
                    onSelected: (_) => setModalState(() => selectedIcon = emoji),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Severity Level',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['High', 'Moderate', 'Low'].map((sev) {
                  final isSelected = selectedSeverity == sev;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(sev),
                      selected: isSelected,
                      selectedColor: const Color(0xFFE8F5F2),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF16A085)
                            : const Color(0xFF374151),
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) =>
                          setModalState(() => selectedSeverity = sev),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF16A085),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty) {
                      setState(() {
                        _myAllergens.add({
                          'name': nameController.text.trim(),
                          'severity': selectedSeverity,
                          'icon': selectedIcon,
                          'type': selectedType,
                        });
                      });
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text('Save Allergen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(int index) {
    final allergen = _myAllergens[index];
    String currentSeverity = allergen['severity'] as String;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit ${allergen['name']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Update Severity Level',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: ['High', 'Moderate', 'Low'].map((sev) {
                  final isSelected = currentSeverity == sev;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(sev),
                      selected: isSelected,
                      selectedColor: const Color(0xFFE8F5F2),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF16A085)
                            : const Color(0xFF374151),
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) =>
                          setModalState(() => currentSeverity = sev),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF16A085),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _myAllergens[index]['severity'] = currentSeverity;
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeAllergen(int index) {
    final removed = _myAllergens[index];
    setState(() {
      _myAllergens.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed ${removed['name']}'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFF16A085),
          onPressed: () {
            setState(() {
              _myAllergens.insert(index, removed);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: const Text(
                '9:41',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Header
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => _navigate(
                      'home',
                      data: {'navTab': 'home'},
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Color(0xFF16A085),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xFF16A085),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'My Allergens',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Description
                  const Text(
                    'FoodLense uses this list when checking scanned products.',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Allergen list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                children: [
                  ...List.generate(_myAllergens.length, (index) {
                    final allergen = _myAllergens[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _allergenCard(allergen, index),
                    );
                  }),

                  // Empty state
                  if (_myAllergens.isEmpty) _emptyState(),

                  // Add allergen button
                  const SizedBox(height: 4),
                  _addAllergenButton(),
                ],
              ),
            ),

            // Bottom navigation
            widget.bottomNavigationBar ?? _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // Allergen card
  Widget _allergenCard(Map<String, dynamic> allergen, int index) {
    final severity = allergen['severity'] as String;
    final colors = _severityColors(severity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          // Allergen information
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  allergen['icon'] as String,
                  style: const TextStyle(fontSize: 24),
                ),
              ),

              const SizedBox(width: 12),

              // Name and type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allergen['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      allergen['type'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              // Severity badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors['background'],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: colors['border']!),
                ),
                child: Text(
                  severity,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colors['text'],
                  ),
                ),
              ),
            ],
          ),

          // Divider
          const SizedBox(height: 12),
          const Divider(
            color: Color(0xFFF3F4F6),
            height: 1,
          ),
          const SizedBox(height: 12),

          // Edit and Remove buttons
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: 'Edit',
                  textColor: const Color(0xFF374151),
                  borderColor: const Color(0xFFE5E7EB),
                  onTap: () => _showEditDialog(index),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _actionButton(
                  label: 'Remove',
                  textColor: const Color(0xFFDC2626),
                  borderColor: const Color(0xFFFEE2E2),
                  onTap: () => _removeAllergen(index),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Severity colors
  Map<String, Color> _severityColors(String severity) {
    switch (severity) {
      case 'High':
        return {
          'text': const Color(0xFFDC2626),
          'background': const Color(0xFFFEE2E2),
          'border': const Color(0xFFFECACA),
        };

      case 'Moderate':
        return {
          'text': const Color(0xFFD97706),
          'background': const Color(0xFFFEF3C7),
          'border': const Color(0xFFFDE68A),
        };

      case 'Low':
        return {
          'text': const Color(0xFF16A34A),
          'background': const Color(0xFFDCFCE7),
          'border': const Color(0xFFBBF7D0),
        };

      default:
        return {
          'text': Colors.grey,
          'background': Colors.grey.shade100,
          'border': Colors.grey.shade300,
        };
    }
  }

  // Edit / Remove button
  Widget _actionButton({
    required String label,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Empty state
  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: const Text(
              '🛡️',
              style: TextStyle(fontSize: 36),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'No allergens added',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Add allergens to receive personalised ingredient warnings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Add allergen button
  Widget _addAllergenButton() {
    return ElevatedButton(
      onPressed: () => _navigate('allergen-setup'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF16A085),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        elevation: 6,
        shadowColor: const Color(0x4D16A085),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 18),
          SizedBox(width: 8),
          Text(
            'Add Allergen',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom navigation matching screenshot
  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isSelected: false,
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (r) => false,
              ),
            ),
            _buildRaisedScanButton(),
            _buildNavItem(
              icon: Icons.access_time_rounded,
              label: 'History',
              isSelected: false,
              onTap: () => Navigator.of(context).pushReplacementNamed(
                AppRoutes.history,
              ),
            ),
            _buildNavItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              isSelected: true,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const activeColor = Color(0xFF16A085);
    const inactiveColor = Color(0xFF9CA3AF);

    return InkWell(
      onTap: onTap,
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

  Widget _buildRaisedScanButton() {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.scanner),
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
            child: const Text(
              'Scan',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
