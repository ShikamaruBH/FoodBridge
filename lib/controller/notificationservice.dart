import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:notification_permissions/notification_permissions.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: printPayload,
      onDidReceiveBackgroundNotificationResponse: printPayload,
    );

    PermissionStatus permissionStatus =
        await NotificationPermissions.getNotificationPermissionStatus();

    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus =
          await NotificationPermissions.requestNotificationPermissions(
              openSettings: true);
    }
    debugPrint("Notification permission: $permissionStatus");
  }

  static printPayload(details) {
    debugPrint("Notification response: ${details.payload}");
  }

  showNotification(Map<String, dynamic> data) async {
    if (data["donor"] != null) {
      return showRecipientNotification(data['title'], data['donor']);
    }
    if (data['recipient'] != null) {
      return showDonorNotification(data['title'], data['recipient']);
    }
  }

  showRecipientNotification(String title, String from) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails("newDonation", "New Donation",
          groupKey: "recipientNotification",
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation('')),
    );

    await _notificationsPlugin.show(
      id,
      localeController.getTranslate("recipient-notification-title-part-1"),
      "${localeController.getTranslate('recipient-notification-title-part-1')} $title ${localeController.getTranslate('recipient-notification-title-part-2')} $from",
      notificationDetails,
      payload: 'New donation playload for $title',
    );
  }

  showDonorNotification(String title, String from) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails("newRecipient", "New recipient",
          groupKey: "donorNotification",
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation('')),
    );

    await _notificationsPlugin.show(
      id,
      localeController.getTranslate("donor-notification-title-part-1"),
      "${localeController.getTranslate('donor-notification-title-part-1')} $title ${localeController.getTranslate('donor-notification-title-part-2')} $from",
      notificationDetails,
      payload: 'New recipient playload for $title',
    );
  }
}
