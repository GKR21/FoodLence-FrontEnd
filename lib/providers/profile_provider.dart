import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  final Set<String> _allergenIds = {};

  Set<String> get allergenIds => Set.unmodifiable(_allergenIds);
  int get allergenCount => _allergenIds.length;

  void setAllergens(Iterable<String> ids) {
    _allergenIds
      ..clear()
      ..addAll(ids);
    notifyListeners();
  }

  bool hasAllergen(String id) => _allergenIds.contains(id);
}
