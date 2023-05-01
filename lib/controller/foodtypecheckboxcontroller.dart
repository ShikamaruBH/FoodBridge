import 'package:flutter/material.dart';

class FoodTypeCheckBoxController extends ChangeNotifier {
  static final FoodTypeCheckBoxController _instance =
      FoodTypeCheckBoxController._internal();
  Map<String, bool> checked = {};
  FoodTypeCheckBoxController._internal();

  factory FoodTypeCheckBoxController() {
    return _instance;
  }

  bool status(String name) {
    return (checked.containsKey(name) && checked[name]!);
  }

  void check(String name) {
    checked[name] = !status(name);
    notifyListeners();
  }
}
