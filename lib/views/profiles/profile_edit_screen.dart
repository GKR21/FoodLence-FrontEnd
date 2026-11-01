import 'package:flutter/material.dart';
import '../../models/profile_model.dart';
import '../../services/profile_service.dart';

const _teal = Color(0xFF16A085);
const _ink = Color(0xFF111827);
const _gray500 = Color(0xFF6B7280);
const _gray700 = Color(0xFF374151);
const _border = Color(0xFFE5E7EB);
const _fieldBg = Color(0xFFF9FAFB);

class ProfileEditScreen extends StatefulWidget {
  final DietaryProfile? profile;

  const ProfileEditScreen({super.key, this.profile});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late String _selectedAvatar;
  late bool _isDefault;
  late List<AllergenItem> _allergens;
  late List<String> _dietaryPreferences;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p?.name ?? '');
    _notesController = TextEditingController(text: p?.notes ?? '');
    _selectedAvatar = p?.avatarIcon ?? 'person';
    _isDefault = p?.isDefault ?? false;
    _allergens = p != null ? List.from(p.allergens) : [];
    _dietaryPreferences = p != null ? List.from(p.dietaryPreferences) : [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  IconData _resolveAvatarIcon(String iconKey) {
    switch (iconKey) {
      case 'child':
        return Icons.child_care;
      case 'face':
        return Icons.face;
      case 'favorite':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      case 'pets':
        return Icons.pets;
      case 'person':
      default:
        return Icons.person;
    }
  }

  Color _severityBgColor(AllergenSeverity severity) {
    switch (severity) {
      case AllergenSeverity.severe:
        return const Color(0xFFFEE2E2);
      case AllergenSeverity.moderate:
        return const Color(0xFFFFEDD5);
      case AllergenSeverity.mild:
        return const Color(0xFFFEF3C7);
    }
  }

  Color _severityTextColor(AllergenSeverity severity) {
    switch (severity) {
      case AllergenSeverity.severe:
        return const Color(0xFF991B1B);
      case AllergenSeverity.moderate:
        return const Color(0xFF9A3412);
      case AllergenSeverity.mild:
        return const Color(0xFF92400E);
    }
  }

  void _showAddAllergenDialog() {
    String selectedAllergen = DietaryProfile.standardAllergens.firstWhere(
      (a) => !_allergens.any((item) => item.name.toLowerCase() == a.toLowerCase()),
      orElse: () => DietaryProfile.standardAllergens.first,
    );
    AllergenSeverity selectedSeverity = AllergenSeverity.severe;
    final customController = TextEditingController();
    bool isCustom = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final availableStandards = DietaryProfile.standardAllergens
                .where((a) => !_allergens.any((item) => item.name.toLowerCase() == a.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
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
                        'Add Allergen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _ink,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: _gray500),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Standard vs Custom toggle
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Common Allergens'),
                        selected: !isCustom,
                        onSelected: (val) {
                          if (val) setModalState(() => isCustom = false);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Custom Allergen'),
                        selected: isCustom,
                        onSelected: (val) {
                          if (val) setModalState(() => isCustom = true);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (!isCustom) ...[
                    if (availableStandards.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue: availableStandards.contains(selectedAllergen)
                            ? selectedAllergen
                            : availableStandards.first,
                        decoration: InputDecoration(
                          labelText: 'Select Allergen',
                          filled: true,
                          fillColor: _fieldBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _border),
                          ),
                        ),
                        items: availableStandards
                            .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedAllergen = val);
                          }
                        },
                      )
                    else
                      const Text(
                        'All standard allergens have been added. Choose "Custom Allergen" to add another.',
                        style: TextStyle(color: _gray500),
                      ),
                  ] else ...[
                    TextField(
                      controller: customController,
                      decoration: InputDecoration(
                        labelText: 'Allergen Name (e.g. Kiwi, Strawberries)',
                        filled: true,
                        fillColor: _fieldBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _border),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  const Text(
                    'Reaction Severity Level:',
                    style: TextStyle(fontWeight: FontWeight.w600, color: _ink),
                  ),
                  const SizedBox(height: 8),

                  ...AllergenSeverity.values.map((sev) {
                    final isSelected = selectedSeverity == sev;
                    return GestureDetector(
                      onTap: () {
                        setModalState(() => selectedSeverity = sev);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _severityBgColor(sev)
                              : const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? _severityTextColor(sev)
                                : _border,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 18,
                              color: isSelected
                                  ? _severityTextColor(sev)
                                  : _gray500,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              sev.label,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? _severityTextColor(sev) : _gray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final name = isCustom ? customController.text.trim() : selectedAllergen;
                        if (name.isNotEmpty) {
                          setState(() {
                            _allergens.removeWhere(
                              (item) => item.name.toLowerCase() == name.toLowerCase(),
                            );
                            _allergens.add(
                              AllergenItem(name: name, severity: selectedSeverity),
                            );
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text(
                        'Add to Profile',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final String id = widget.profile?.id ?? 'profile_${DateTime.now().millisecondsSinceEpoch}';
    final profile = DietaryProfile(
      id: id,
      name: _nameController.text.trim(),
      avatarIcon: _selectedAvatar,
      isDefault: _isDefault,
      allergens: _allergens,
      dietaryPreferences: _dietaryPreferences,
      notes: _notesController.text.trim(),
      createdAt: widget.profile?.createdAt,
    );

    final service = ProfileService.instance;
    if (widget.profile == null) {
      await service.createProfile(profile);
    } else {
      await service.updateProfile(profile);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile "${profile.name}" saved successfully.'),
          backgroundColor: _teal,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.profile != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _ink),
        title: Text(
          isEditing ? 'Edit Profile' : 'New Dietary Profile',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _ink,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: _teal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Avatar selector
              const Text(
                'Profile Icon',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _gray700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: DietaryProfile.avatarOptions.map((opt) {
                  final isSel = _selectedAvatar == opt;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatar = opt),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSel ? _teal : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel ? _teal : _border,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _resolveAvatarIcon(opt),
                        color: isSel ? Colors.white : _gray700,
                        size: 24,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Profile Name
              const Text(
                'Profile Name *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _gray700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Myself, Leo (Child), Emma',
                  filled: true,
                  fillColor: _fieldBg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _teal, width: 1.5),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a profile name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Default profile switch
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _fieldBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Primary Default Profile',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                          ),
                        ),
                        Text(
                          'Used automatically on app launch and initial scans',
                          style: TextStyle(fontSize: 11, color: _gray500),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isDefault,
                      activeTrackColor: _teal.withAlpha(120),
                      activeThumbColor: _teal,
                      onChanged: (val) => setState(() => _isDefault = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Allergens Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Allergen Restrictions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _ink,
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: _teal),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Allergen', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _showAddAllergenDialog,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_allergens.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _fieldBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border, style: BorderStyle.solid),
                  ),
                  child: const Center(
                    child: Text(
                      'No allergens added yet.\nTap "+ Add Allergen" above to protect this profile.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _gray500, fontSize: 13, height: 1.4),
                    ),
                  ),
                )
              else
                Column(
                  children: _allergens.map((allergen) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: _severityBgColor(allergen.severity),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            allergen.severity == AllergenSeverity.severe
                                ? Icons.warning_amber_rounded
                                : Icons.circle,
                            color: _severityTextColor(allergen.severity),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allergen.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _severityTextColor(allergen.severity),
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Severity: ${allergen.severity.label}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _severityTextColor(allergen.severity),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            color: _severityTextColor(allergen.severity),
                            onPressed: () {
                              setState(() {
                                _allergens.removeWhere((item) => item.name == allergen.name);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 28),

              // Dietary Preferences Section
              const Text(
                'Dietary & Lifestyle Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select diets you follow to highlight matching ingredients',
                style: TextStyle(fontSize: 12, color: _gray500),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: DietaryProfile.standardPreferences.map((pref) {
                  final isSelected = _dietaryPreferences.contains(pref);
                  return FilterChip(
                    label: Text(pref),
                    selected: isSelected,
                    selectedColor: _teal.withAlpha(40),
                    checkmarkColor: _teal,
                    labelStyle: TextStyle(
                      color: isSelected ? _teal : _gray700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? _teal : _border,
                      ),
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _dietaryPreferences.add(pref);
                        } else {
                          _dietaryPreferences.remove(pref);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Medical / Emergency Notes
              const Text(
                'Emergency & Clinical Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _gray700,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Carries EpiPen Auto-Injector in side pouch. Call 911 if swelling occurs.',
                  filled: true,
                  fillColor: _fieldBg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _teal, width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Save Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                onPressed: _saveProfile,
                child: Text(
                  isEditing ? 'Save Changes' : 'Create Profile',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
