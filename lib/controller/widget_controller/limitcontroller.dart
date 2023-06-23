import 'package:flutter/material.dart';

class LimitController extends ChangeNotifier {
  static final LimitController _instance = LimitController._internal();
  bool isLimited = false;
  LimitController._internal();

  factory LimitController() {
    return _instance;
  }

  void setLimit(bool? noLimit) {
    isLimited = noLimit != true;
    notifyListeners();
  }
}
