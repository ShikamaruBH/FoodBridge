import 'package:flutter/material.dart';

class FoodCategoryCheckBoxController extends ChangeNotifier {
  static final FoodCategoryCheckBoxController _instance =
      FoodCategoryCheckBoxController._internal();
  Map<String, bool> checked = {};
  FoodCategoryCheckBoxController._internal();

  factory FoodCategoryCheckBoxController() {
    return _instance;
  }

  bool status(String name) {
    return (checked.containsKey(name) && checked[name]!);
  }

  void check(String name) {
    checked[name] = !status(name);
    notifyListeners();
  }

  void update(List<String> categories) {
    checked.updateAll((key, value) => value = false);
    for (var category in categories) {
      checked[category] = true;
    }
  }
}
