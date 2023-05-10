import 'package:flutter/material.dart';

class QuantityController extends ChangeNotifier {
  static final QuantityController _instance = QuantityController._internal();
  int value = 0;
  TextEditingController controller = TextEditingController();
  QuantityController._internal();

  factory QuantityController() {
    return _instance;
  }

  void increase() {
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

  void setValue(int value) {
    if (value < 0) {
      return;
    }
    this.value = value;
    controller.text = value.toString();
    notifyListeners();
  }

  void reset() {
    value = 0;
    controller.text = value.toString();
    notifyListeners();
  }

  void update(String s) {
    value = int.tryParse(controller.text) ?? 0;
  }
}
