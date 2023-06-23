import 'package:flutter/material.dart';

class RoleButtonController extends ChangeNotifier {
  static final RoleButtonController _instance =
      RoleButtonController._internal();
  String currentRole = 'donor';
  RoleButtonController._internal();

  factory RoleButtonController() {
    return _instance;
  }

  void setRole(String role) {
    currentRole = role;
    notifyListeners();
  }
}
