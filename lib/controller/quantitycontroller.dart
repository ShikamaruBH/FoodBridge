import 'package:flutter/material.dart';

class QuantityController extends ChangeNotifier {
  static final QuantityController _instance = QuantityController._internal();
  int value = 0;
  int maxValue = 0;
  TextEditingController controller = TextEditingController();
  QuantityController._internal();

  factory QuantityController() {
    return _instance;
  }

  void increase() {
    if (value >= maxValue) {
      return;
    }
    value++;
    controller.text = value.toString();
    notifyListeners();
  }

  void decrease() {
    if (value <= 0) {
      return;
    }
    value--;
    controller.text = value.toString();
    notifyListeners();
  }

  void setValue(String s) {
    int v = int.tryParse(controller.text) ?? 0;
    if (v < 0) {
      value = 0;
      return;
    }
    if (v > maxValue) {
      value = maxValue;
      return;
    }
    value = v;
    notifyListeners();
  }

  void setMaxValue(int value) {
    maxValue = value;
    notifyListeners();
  }

  void reset() {
    value = 0;
    controller.text = value.toString();
    notifyListeners();
  }
}
