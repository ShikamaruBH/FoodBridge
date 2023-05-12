import 'package:flutter/material.dart';

class ReviewDialogController extends ChangeNotifier {
  static final ReviewDialogController _instance =
      ReviewDialogController._internal();
  double rating = 2.5;
  TextEditingController controller = TextEditingController();

  ReviewDialogController._internal();

  factory ReviewDialogController() {
    return _instance;
  }

  String get review => controller.text;
}
