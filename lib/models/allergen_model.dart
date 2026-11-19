class Allergen {
  final String id;
  final String label;
  final String emoji;

  const Allergen({required this.id, required this.label, required this.emoji});

  /// The allergens shown on the setup screen.
  static const List<Allergen> catalog = [
    Allergen(id: 'milk', label: 'Milk / Dairy', emoji: '🥛'),
    Allergen(id: 'eggs', label: 'Eggs', emoji: '🥚'),
    Allergen(id: 'peanuts', label: 'Peanuts', emoji: '🥜'),
    Allergen(id: 'tree-nuts', label: 'Tree Nuts', emoji: '🌰'),
    Allergen(id: 'soy', label: 'Soy', emoji: '🫘'),
    Allergen(id: 'wheat', label: 'Wheat', emoji: '🌾'),
    Allergen(id: 'gluten', label: 'Gluten', emoji: '🍞'),
    Allergen(id: 'fish', label: 'Fish', emoji: '🐟'),
    Allergen(id: 'shellfish', label: 'Shellfish', emoji: '🦐'),
    Allergen(id: 'sesame', label: 'Sesame', emoji: '⚪'),
  ];
}
