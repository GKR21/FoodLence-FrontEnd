import 'package:flutter/foundation.dart';
import '../models/profile_model.dart';

/// Service managing user dietary profiles in local state and synchronization
///
/// Implements requirements specified in SE5104 Proposal Section 5.1 (FR-07):
/// - Manages multiple dietary profiles per user account
/// - Tracks the currently active profile used during edge OCR scan analysis
/// - Provides reactive notification via [ChangeNotifier] for real-time UI updates
class ProfileService extends ChangeNotifier {
  // Singleton pattern
  static final ProfileService _instance = ProfileService._internal();
  static ProfileService get instance => _instance;

  factory ProfileService() => _instance;

  ProfileService._internal() {
    _initializeDefaultProfiles();
  }

  final List<DietaryProfile> _profiles = [];
  String? _activeProfileId;

  /// Returns unmodifiable list of current dietary profiles
  List<DietaryProfile> get profiles => List.unmodifiable(_profiles);

  /// Returns the currently active profile used for OCR allergen matching
  DietaryProfile get activeProfile {
    if (_profiles.isEmpty) {
      _initializeDefaultProfiles();
    }
    return _profiles.firstWhere(
      (p) => p.id == _activeProfileId,
      orElse: () => _profiles.firstWhere(
        (p) => p.isDefault,
        orElse: () => _profiles.first,
      ),
    );
  }

  /// Sets the active profile by ID
  Future<void> setActiveProfile(String profileId) async {
    final exists = _profiles.any((p) => p.id == profileId);
    if (!exists) {
      throw ArgumentError('Profile with ID $profileId does not exist.');
    }
    _activeProfileId = profileId;
    notifyListeners();
  }

  /// Sets a profile as the permanent default profile
  Future<void> setDefaultProfile(String profileId) async {
    for (int i = 0; i < _profiles.length; i++) {
      if (_profiles[i].id == profileId) {
        _profiles[i] = _profiles[i].copyWith(isDefault: true);
        _activeProfileId = profileId;
      } else if (_profiles[i].isDefault) {
        _profiles[i] = _profiles[i].copyWith(isDefault: false);
      }
    }
    notifyListeners();
  }

  /// Creates a new dietary profile
  Future<DietaryProfile> createProfile(DietaryProfile profile) async {
    // If marked as default or first profile, adjust defaults
    if (profile.isDefault || _profiles.isEmpty) {
      for (int i = 0; i < _profiles.length; i++) {
        if (_profiles[i].isDefault) {
          _profiles[i] = _profiles[i].copyWith(isDefault: false);
        }
      }
      _activeProfileId = profile.id;
    }

    _profiles.add(profile);
    notifyListeners();
    return profile;
  }

  /// Updates an existing dietary profile
  Future<DietaryProfile> updateProfile(DietaryProfile updatedProfile) async {
    final index = _profiles.indexWhere((p) => p.id == updatedProfile.id);
    if (index == -1) {
      throw ArgumentError('Profile with ID ${updatedProfile.id} not found.');
    }

    if (updatedProfile.isDefault) {
      for (int i = 0; i < _profiles.length; i++) {
        if (i != index && _profiles[i].isDefault) {
          _profiles[i] = _profiles[i].copyWith(isDefault: false);
        }
      }
      _activeProfileId = updatedProfile.id;
    }

    _profiles[index] = updatedProfile;
    notifyListeners();
    return updatedProfile;
  }

  /// Deletes a dietary profile by ID (cannot delete if it is the only remaining profile)
  Future<bool> deleteProfile(String profileId) async {
    if (_profiles.length <= 1) {
      return false; // Prevent deleting the sole remaining profile
    }

    final targetIndex = _profiles.indexWhere((p) => p.id == profileId);
    if (targetIndex == -1) return false;

    final wasActive = _activeProfileId == profileId;
    final wasDefault = _profiles[targetIndex].isDefault;

    _profiles.removeAt(targetIndex);

    // If deleted profile was active or default, reassign to the first available
    if (wasActive || wasDefault) {
      final newPrimary = _profiles.first;
      _profiles[0] = newPrimary.copyWith(isDefault: true);
      _activeProfileId = _profiles[0].id;
    }

    notifyListeners();
    return true;
  }

  /// Seeds default realistic profiles for initial app onboarding & demonstration
  void _initializeDefaultProfiles() {
    _profiles.clear();

    final selfProfile = DietaryProfile(
      id: 'profile_self_01',
      name: 'Myself (Dilshan)',
      avatarIcon: 'person',
      isDefault: true,
      allergens: const [
        AllergenItem(
          name: 'Peanuts',
          severity: AllergenSeverity.severe,
          notes: 'Carries emergency EpiPen. Avoid cross-contamination.',
        ),
        AllergenItem(
          name: 'Crustacean Shellfish',
          severity: AllergenSeverity.moderate,
          notes: 'Hives and respiratory irritation upon exposure.',
        ),
      ],
      dietaryPreferences: const ['Dairy-Free'],
      notes: 'Strict allergen screening required for school & outdoor eating.',
    );

    final childProfile = DietaryProfile(
      id: 'profile_child_02',
      name: 'Leo (Son)',
      avatarIcon: 'child',
      isDefault: false,
      allergens: const [
        AllergenItem(
          name: 'Eggs',
          severity: AllergenSeverity.severe,
          notes: 'Severe allergic response, including baked goods.',
        ),
        AllergenItem(
          name: 'Milk / Dairy',
          severity: AllergenSeverity.mild,
          notes: 'Lactose intolerance / mild bloating.',
        ),
      ],
      dietaryPreferences: const ['Gluten-Free'],
      notes: 'Verify bakery items and processed snack foods.',
    );

    _profiles.addAll([selfProfile, childProfile]);
    _activeProfileId = selfProfile.id;
  }
}
