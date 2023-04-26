import 'package:flutter/material.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/widgets/languageswitch.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: LocalizationController(),
      child: Consumer<LocalizationController>(
        builder: (_, localeController, __) => Scaffold(
          appBar: AppBar(
            title: Text(localeController.getTranslate('setting-title')),
          ),
          body: ListView(
            children: [
              SettingsLabelWidget('general-setting-label'),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        localeController.getTranslate('language-setting-text'),
                        style: StyleManagement.settingsItemTextStyle,
                      ),
                    ),
                    LaguageSwitchWidget(),
                  ],
                ),
              ),
              SettingsLabelWidget('notifications-text'),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsLabelWidget extends StatelessWidget {
  final String label;
  final localeController = LocalizationController();
  SettingsLabelWidget(
    this.label, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        localeController.getTranslate(label),
        style: StyleManagement.settingsLabelTextStyle,
        textAlign: TextAlign.left,
      ),
    );
  }
}
