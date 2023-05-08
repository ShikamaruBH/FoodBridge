import 'package:flutter/material.dart';

class DatetimePickerController extends ChangeNotifier {
  static final DatetimePickerController _instance =
      DatetimePickerController._internal();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  DatetimePickerController._internal();

  factory DatetimePickerController() {
    return _instance;
  }

  setStart(DateTime value) {
    start = value;
    notifyListeners();
  }

  setEnd(DateTime value) {
    end = value;
    notifyListeners();
  }
}
