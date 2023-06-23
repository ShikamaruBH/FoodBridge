import 'package:flutter/material.dart';

class FilterController extends ChangeNotifier {
  static final FilterController _instance = FilterController._internal();
  bool isEnable = true;
  FilterController._internal();

  factory FilterController() {
    return _instance;
  }

  void swap() {
    isEnable = !isEnable;
    notifyListeners();
  }
}
