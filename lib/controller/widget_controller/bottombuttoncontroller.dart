import 'package:flutter/material.dart';

class BottomButtonController extends ChangeNotifier {
  static final BottomButtonController _instance =
      BottomButtonController._internal();

  bool isQuantityOpen = false;

  BottomButtonController._internal();

  factory BottomButtonController() {
    return _instance;
  }

  void switchQuantity() {
    isQuantityOpen = !isQuantityOpen;
    notifyListeners();
  }
}
