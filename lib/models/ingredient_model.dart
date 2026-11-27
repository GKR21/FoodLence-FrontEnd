class IngredientModel {
  final String name;
  final String type;
  final String? eNumber;

  const IngredientModel({required this.name, required this.type, this.eNumber});
}

class IngredientInfo {
  final String what;
  final String why;
  final String foundIn;

  const IngredientInfo({
    required this.what,
    required this.why,
    required this.foundIn,
  });
}
