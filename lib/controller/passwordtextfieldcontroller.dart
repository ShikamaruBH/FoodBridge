import 'package:flutter/material.dart';

class PasswordTextfieldController extends ChangeNotifier {
  bool visible = false;

  static final PasswordTextfieldController _instance =
      PasswordTextfieldController._internal();

  PasswordTextfieldController._internal();

  factory PasswordTextfieldController() {
    return _instance;
  }
  void switchVisible() {
    visible = !visible;
    notifyListeners();
  }
}
