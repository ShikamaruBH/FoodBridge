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

  reset() {
    start = DateTime.now();
    end = DateTime.now();
  }

  setStart(DateTime value) {
    start = value;
    end = value;
    notifyListeners();
  }

  setEnd(DateTime value) {
    end = value;
    notifyListeners();
  }
}
