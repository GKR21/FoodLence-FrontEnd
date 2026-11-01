
/// Severity level of an allergen reaction as defined in clinical and consumer food safety standards
enum AllergenSeverity {
  mild,
  moderate,
  severe, // Anaphylactic / life-threatening
}

extension AllergenSeverityExtension on AllergenSeverity {
  String get label {
    switch (this) {
      case AllergenSeverity.mild:
        return 'Mild';
      case AllergenSeverity.moderate:
        return 'Moderate';
      case AllergenSeverity.severe:
        return 'Severe (Anaphylactic)';
    }
  }

  String get shortLabel {
    switch (this) {
      case AllergenSeverity.mild:
        return 'Mild';
      case AllergenSeverity.moderate:
        return 'Moderate';
      case AllergenSeverity.severe:
        return 'Severe';
    }
  }

  static AllergenSeverity fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'severe':
      case 'anaphylactic':
        return AllergenSeverity.severe;
      case 'moderate':
        return AllergenSeverity.moderate;
      case 'mild':
      default:
        return AllergenSeverity.mild;
    }
  }
}

/// Individual allergen entry mapped to a profile with user-defined severity
class AllergenItem {
  final String name;
  final AllergenSeverity severity;
  final String? notes;

  const AllergenItem({
    required this.name,
    this.severity = AllergenSeverity.severe,
    this.notes,
  });

  AllergenItem copyWith({
    String? name,
    AllergenSeverity? severity,
    String? notes,
  }) {
    return AllergenItem(
      name: name ?? this.name,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'severity': severity.name,
      'notes': notes,
    };
  }

  factory AllergenItem.fromJson(Map<String, dynamic> json) {
    return AllergenItem(
      name: json['name'] as String? ?? '',
      severity: AllergenSeverityExtension.fromString(json['severity'] as String?),
      notes: json['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllergenItem &&
          runtimeType == other.runtimeType &&
          name.toLowerCase() == other.name.toLowerCase();

  @override
  int get hashCode => name.toLowerCase().hashCode;
}

/// Dietary profile model supporting multi-profile management per user account
///
/// Implements requirements specified in SE5104 Proposal Section 5.1 (FR-07):
/// - Multiple profiles per account (Self, Children, Partner, etc.)
/// - Granular allergen configuration with clinical severity indicators
/// - Dietary lifestyle preferences (Vegan, Vegetarian, Halal, Kosher, Gluten-Free)
class DietaryProfile {
  final String id;
  final String name;
  final String avatarIcon;
  final bool isDefault;
  final List<AllergenItem> allergens;
  final List<String> dietaryPreferences;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  DietaryProfile({
    required this.id,
    required this.name,
    this.avatarIcon = 'person',
    this.isDefault = false,
    this.allergens = const [],
    this.dietaryPreferences = const [],
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  DietaryProfile copyWith({
    String? id,
    String? name,
    String? avatarIcon,
    bool? isDefault,
    List<AllergenItem>? allergens,
    List<String>? dietaryPreferences,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DietaryProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      isDefault: isDefault ?? this.isDefault,
      allergens: allergens ?? List.from(this.allergens),
      dietaryPreferences: dietaryPreferences ?? List.from(this.dietaryPreferences),
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_icon': avatarIcon,
      'is_default': isDefault,
      'allergens': allergens.map((a) => a.toJson()).toList(),
      'dietary_preferences': dietaryPreferences,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DietaryProfile.fromJson(Map<String, dynamic> json) {
    return DietaryProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatarIcon: json['avatar_icon'] as String? ?? 'person',
      isDefault: json['is_default'] as bool? ?? false,
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((item) => AllergenItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      dietaryPreferences: (json['dietary_preferences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Global standard common allergens (Big 8 / Big 14 allergens)
  static const List<String> standardAllergens = [
    'Peanuts',
    'Tree Nuts',
    'Milk / Dairy',
    'Eggs',
    'Wheat / Gluten',
    'Soy',
    'Fish',
    'Crustacean Shellfish',
    'Sesame',
    'Sulfites',
    'Mustard',
    'Celery',
    'Lupin',
    'Molluscs',
  ];

  /// Standard dietary and lifestyle preferences
  static const List<String> standardPreferences = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Halal',
    'Kosher',
    'Low-FODMAP',
    'Keto-Friendly',
  ];

  /// Standard avatar icon keys
  static const List<String> avatarOptions = [
    'person',
    'face',
    'child',
    'favorite',
    'star',
    'pets',
  ];
}
