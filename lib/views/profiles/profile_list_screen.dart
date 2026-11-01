import 'package:flutter/material.dart';
import '../../models/profile_model.dart';
import '../../services/profile_service.dart';
import 'profile_edit_screen.dart';

const _teal = Color(0xFF16A085);
const _ink = Color(0xFF111827);
const _gray500 = Color(0xFF6B7280);
const _gray700 = Color(0xFF374151);
const _border = Color(0xFFE5E7EB);
const _cardBg = Colors.white;

class ProfileListScreen extends StatelessWidget {
  const ProfileListScreen({super.key});

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
        return const Color(0xFFFEE2E2); // Light red
      case AllergenSeverity.moderate:
        return const Color(0xFFFFEDD5); // Light orange
      case AllergenSeverity.mild:
        return const Color(0xFFFEF3C7); // Light amber
    }
  }

  Color _severityTextColor(AllergenSeverity severity) {
    switch (severity) {
      case AllergenSeverity.severe:
        return const Color(0xFF991B1B); // Dark red
      case AllergenSeverity.moderate:
        return const Color(0xFF9A3412); // Dark orange
      case AllergenSeverity.mild:
        return const Color(0xFF92400E); // Dark amber
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileService = ProfileService.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Dietary Profiles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _ink,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: _teal, size: 28),
            tooltip: 'Add Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileEditScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: profileService,
        builder: (context, _) {
          final profiles = profileService.profiles;
          final activeProfile = profileService.activeProfile;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Active profile banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), _teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _teal.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _resolveAvatarIcon(activeProfile.avatarIcon),
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENTLY SCANNING FOR',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activeProfile.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${activeProfile.allergens.length} Allergens • ${activeProfile.dietaryPreferences.length} Diets',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: _teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Household Profiles',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _ink,
                    ),
                  ),
                  Text(
                    '${profiles.length} total',
                    style: const TextStyle(
                      fontSize: 13,
                      color: _gray500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ...profiles.map((profile) {
                final isActive = profile.id == activeProfile.id;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive ? _teal : _border,
                      width: isActive ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? _teal.withAlpha(25)
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _resolveAvatarIcon(profile.avatarIcon),
                                color: isActive ? _teal : _gray700,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          profile.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _ink,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (profile.isDefault) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE0E7FF),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'DEFAULT',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF3730A3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (profile.notes != null &&
                                      profile.notes!.trim().isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      profile.notes!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: _gray500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: _gray500, size: 20),
                              tooltip: 'Edit Profile',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProfileEditScreen(profile: profile),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Allergens List
                        if (profile.allergens.isNotEmpty) ...[
                          const Text(
                            'Allergens:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _gray500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: profile.allergens.map((allergen) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _severityBgColor(allergen.severity),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      allergen.severity == AllergenSeverity.severe
                                          ? Icons.warning_amber_rounded
                                          : Icons.circle,
                                      size: 12,
                                      color: _severityTextColor(allergen.severity),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${allergen.name} (${allergen.severity.shortLabel})',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _severityTextColor(allergen.severity),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Dietary Preferences
                        if (profile.dietaryPreferences.isNotEmpty) ...[
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: profile.dietaryPreferences.map((diet) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: _border),
                                ),
                                child: Text(
                                  diet,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: _gray700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                        ],

                        const Divider(color: _border, height: 1),
                        const SizedBox(height: 10),

                        // Bottom Actions: Switch Active / Set Default / Delete
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isActive)
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  foregroundColor: _teal,
                                ),
                                icon: const Icon(Icons.radio_button_unchecked, size: 18),
                                label: const Text(
                                  'Set as Active Scan Profile',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  profileService.setActiveProfile(profile.id);
                                },
                              )
                            else
                              const Row(
                                children: [
                                  Icon(Icons.check_circle, color: _teal, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'Active Scan Profile',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _teal,
                                    ),
                                  ),
                                ],
                              ),
                            if (profiles.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
                                tooltip: 'Delete Profile',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Profile?'),
                                      content: Text('Are you sure you want to delete "${profile.name}"?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFEF4444),
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await profileService.deleteProfile(profile.id);
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Add Profile Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: _teal, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: _teal,
                ),
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Add Another Dietary Profile',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileEditScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
