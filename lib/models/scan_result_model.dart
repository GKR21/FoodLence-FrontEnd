import 'ingredient_model.dart';
import 'scan_model.dart';

enum MatchType { exact, related }

extension MatchTypeLabel on MatchType {
  String get label =>
      this == MatchType.exact ? 'Exact Match' : 'Related Ingredient';
}

class AllergenMatch {
  final IngredientModel ingredient;
  final String allergenId;
  final String allergenLabel;
  final MatchType matchType;
  final String reason;

  const AllergenMatch({
    required this.ingredient,
    required this.allergenId,
    required this.allergenLabel,
    required this.matchType,
    required this.reason,
  });
}

class ScanResultModel {
  final List<IngredientModel> ingredients;
  final List<AllergenMatch> matches;
  final DateTime scannedAt;

  const ScanResultModel({
    required this.ingredients,
    required this.matches,
    required this.scannedAt,
  });

  /// Exact match => unsafe, only related matches => caution, none => safe.
  Verdict get verdict {
    if (matches.any((m) => m.matchType == MatchType.exact)) {
      return Verdict.unsafe;
    }
    if (matches.isNotEmpty) {
      return Verdict.caution;
    }
    return Verdict.safe;
  }

  Set<String> get flaggedNames => matches.map((m) => m.ingredient.name).toSet();

  List<IngredientModel> get clearIngredients =>
      ingredients.where((i) => !flaggedNames.contains(i.name)).toList();
}
