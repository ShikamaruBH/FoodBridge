import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  BackgroundService._internal();

  factory BackgroundService() {
    return _instance;
  }

  init() async {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Food Bridge",
      notificationText: "Food Bridge is running in background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
        name: 'ic_launcher',
        defType: 'drawable',
      ),
    );
    bool hasPermissions = await FlutterBackground.hasPermissions;
    debugPrint("Has permission: $hasPermissions");
    bool success =
        await FlutterBackground.initialize(androidConfig: androidConfig);
    debugPrint("Background service init success:  $success");
    success = await FlutterBackground.enableBackgroundExecution();
    debugPrint("Enable background execution success: $success");
  }
}
