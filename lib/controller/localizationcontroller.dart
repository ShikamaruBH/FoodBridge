import 'package:flutter/material.dart';
import 'package:food_bridge/model/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends ChangeNotifier {
  static final LocalizationController _instance =
      LocalizationController._localizationController();
  late SharedPreferences prefs;
  String? locale = "en";

  LocalizationController._localizationController() {
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      locale = prefs.getString("locale") ?? "vi";
      notifyListeners();
    });
  }

  factory LocalizationController() {
    return _instance;
  }

  getLocale() async {
    await SharedPreferences.getInstance().then((value) {
      locale = value.getString("locale") ?? "vi";
    });
  }

  dynamic getTranslate(String text) {
    if (!appLocalizations.containsKey(text)) {
      return text;
    }
    return appLocalizations[text][locale];
  }

  Future<bool> setLocale(String locale) async {
    this.locale = locale;
    notifyListeners();
    return prefs.setString('locale', locale);
  }
}
