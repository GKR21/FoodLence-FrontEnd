import 'package:flutter/material.dart';
import '../../services/profile_service.dart';
import '../profiles/profile_list_screen.dart';

const _teal = Color(0xFF16A085);
const _ink = Color(0xFF111827);
const _gray500 = Color(0xFF6B7280);
const _gray700 = Color(0xFF374151);
const _border = Color(0xFFE5E7EB);

/// Quick Profile Selector widget for FoodLence Camera and Home screens
///
/// Implements quick context switching specified in SE5104 Proposal Section 5.1 (FR-07):
/// Allows users to instantly toggle between different family members before scanning packaging
class ProfileSelectorChip extends StatelessWidget {
  final bool darkTheme;
  final VoidCallback? onProfileChanged;

  const ProfileSelectorChip({
    super.key,
    this.darkTheme = false,
    this.onProfileChanged,
  });

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

  void _openProfilePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final profileService = ProfileService.instance;

        return ListenableBuilder(
          listenable: profileService,
          builder: (context, _) {
            final profiles = profileService.profiles;
            final active = profileService.activeProfile;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Switch Dietary Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _ink,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileListScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Manage',
                            style: TextStyle(
                              color: _teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select who this food scan is being analyzed for:',
                      style: TextStyle(fontSize: 13, color: _gray500),
                    ),
                    const SizedBox(height: 16),

                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: profiles.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final profile = profiles[index];
                          final isSelected = profile.id == active.id;

                          return InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () async {
                              await profileService.setActiveProfile(profile.id);
                              if (context.mounted) {
                                Navigator.pop(ctx);
                              }
                              onProfileChanged?.call();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? _teal.withAlpha(20)
                                    : const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? _teal : _border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? _teal
                                          : const Color(0xFFE5E7EB),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      _resolveAvatarIcon(profile.avatarIcon),
                                      color: isSelected ? Colors.white : _gray700,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              profile.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: isSelected ? _teal : _ink,
                                              ),
                                            ),
                                            if (profile.isDefault) ...[
                                              const SizedBox(width: 6),
                                              const Text(
                                                '• Default',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: _gray500,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          profile.allergens.isEmpty
                                              ? 'No allergens listed'
                                              : '${profile.allergens.length} Allergens: ${profile.allergens.map((a) => a.name).take(3).join(', ')}${profile.allergens.length > 3 ? '...' : ''}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: _gray500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: _teal,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileService = ProfileService.instance;

    return ListenableBuilder(
      listenable: profileService,
      builder: (context, _) {
        final active = profileService.activeProfile;

        return GestureDetector(
          onTap: () => _openProfilePicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: darkTheme
                  ? Colors.black.withAlpha(120)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: darkTheme
                    ? Colors.white.withAlpha(50)
                    : _border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _teal,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _resolveAvatarIcon(active.avatarIcon),
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    active.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkTheme ? Colors.white : _ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: darkTheme ? Colors.white70 : _gray500,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
