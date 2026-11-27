import '../models/ingredient_model.dart';

class IngredientService {
  /// Splits a raw label into ingredients. Commas inside brackets are kept.
  List<IngredientModel> parse(String raw) {
    var text = raw.replaceAll('\n', ', ').trim();
    text = text.replaceFirst(
      RegExp(r'^\s*ingredients?\s*:\s*', caseSensitive: false),
      '',
    );

    final parts = <String>[];
    final buf = StringBuffer();
    var depth = 0;
    for (final ch in text.split('')) {
      if (ch == '(' || ch == '[') depth++;
      if ((ch == ')' || ch == ']') && depth > 0) depth--;
      if ((ch == ',' || ch == ';') && depth == 0) {
        parts.add(buf.toString());
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    parts.add(buf.toString());

    return parts
        .map(
          (s) =>
              s.replaceAll('?', '').trim().replaceAll(RegExp(r'[.\s]+$'), ''),
        )
        .where((s) => s.isNotEmpty)
        .map(_toIngredient)
        .toList();
  }

  IngredientModel _toIngredient(String s) {
    final e = RegExp(
      r'\bE\s?\d{3,4}[a-z]?\b',
      caseSensitive: false,
    ).firstMatch(s)?.group(0)?.replaceAll(' ', '').toUpperCase();
    return IngredientModel(
      name: s[0].toUpperCase() + s.substring(1),
      type: _typeOf(s.toLowerCase()),
      eNumber: e,
    );
  }

  static const _types = <String, List<String>>{
    'Preservative': [
      'benzoate',
      'sorbate',
      'sulphite',
      'sulfite',
      'nitrite',
      'propionate',
    ],
    'Emulsifier': ['lecithin', 'diglyceride'],
    'Sweetener': [
      'sugar',
      'syrup',
      'glucose',
      'fructose',
      'dextrose',
      'sweetener',
    ],
    'Protein': ['casein', 'whey', 'gluten', 'albumin'],
    'Dairy ingredient': [
      'milk',
      'butter',
      'cream',
      'cheese',
      'yogurt',
      'lactose',
    ],
    'Grain': ['flour', 'wheat', 'oat', 'barley', 'rye', 'rice', 'semolina'],
    'Fat / oil': ['oil', 'fat', 'margarine'],
    'Flavouring': ['flavour', 'flavor', 'cocoa', 'vanilla', 'spice'],
    'Seasoning': ['salt', 'pepper'],
    'Colour': ['colour', 'color', 'caramel'],
  };

  String _typeOf(String lower) {
    for (final entry in _types.entries) {
      for (final k in entry.value) {
        if (RegExp('\\b${RegExp.escape(k)}').hasMatch(lower)) return entry.key;
      }
    }
    return 'Ingredient';
  }

  // Generic, type-based descriptions. Swap for a real knowledge base later.
  static const _info = <String, IngredientInfo>{
    'Preservative': IngredientInfo(
      what: 'A substance added to food to slow spoilage caused by microbes.',
      why: 'Extends shelf life and helps keep the product safe and fresh.',
      foundIn: 'Soft drinks, sauces, pickles, baked goods and processed foods.',
    ),
    'Emulsifier': IngredientInfo(
      what:
          'An additive that helps oil and water-based ingredients stay mixed.',
      why: 'Improves texture and keeps products smooth and consistent.',
      foundIn: 'Chocolate, baked goods, margarine, spreads and dressings.',
    ),
    'Sweetener': IngredientInfo(
      what: 'An ingredient that adds sweetness to food and drinks.',
      why:
          'Improves taste and, in some products, helps with texture and browning.',
      foundIn: 'Confectionery, drinks, baked goods, sauces and desserts.',
    ),
    'Protein': IngredientInfo(
      what:
          'A protein that is often extracted from a food source such as milk or grain.',
      why: 'Adds structure, texture or nutritional value.',
      foundIn: 'Cheese, protein products, baked goods and processed foods.',
    ),
    'Dairy ingredient': IngredientInfo(
      what: 'An ingredient made from, or containing, milk.',
      why: 'Adds flavour, creaminess and texture.',
      foundIn: 'Chocolate, baked goods, desserts, sauces and snacks.',
    ),
    'Grain': IngredientInfo(
      what: 'A cereal grain or a product milled from one.',
      why: 'Provides bulk, structure and energy.',
      foundIn: 'Bread, biscuits, pasta, noodles and breakfast cereals.',
    ),
    'Fat / oil': IngredientInfo(
      what: 'A fat or oil, usually from plants.',
      why: 'Adds richness and texture, and is used for frying and baking.',
      foundIn: 'Baked goods, snacks, spreads and fried foods.',
    ),
    'Flavouring': IngredientInfo(
      what:
          'An ingredient that gives a product its characteristic taste or aroma.',
      why: 'Creates or enhances the flavour of the final product.',
      foundIn: 'Confectionery, drinks, desserts and snacks.',
    ),
  };

  IngredientInfo infoFor(IngredientModel i) =>
      _info[i.type] ??
      const IngredientInfo(
        what: 'A component listed on the food label.',
        why: 'Used for taste, texture, nutrition or preservation.',
        foundIn: 'A wide range of packaged foods.',
      );
}
