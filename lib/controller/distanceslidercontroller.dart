import 'package:flutter/material.dart';

class DistanceSliderController extends ChangeNotifier {
  static final DistanceSliderController _instance =
      DistanceSliderController._internal();
  double value = 0;
  final double max = 50;
  final divisions = 10;
  DistanceSliderController._internal();

  factory DistanceSliderController() {
    return _instance;
  }

  void setValue(double value) {
    this.value = value.roundToDouble();
    notifyListeners();
  }
}
