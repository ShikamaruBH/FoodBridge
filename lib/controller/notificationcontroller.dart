import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/model/notification.dart';

class NotificationController extends ChangeNotifier {
  static final NotificationController _instance =
      NotificationController._internal();
  NotificationController._internal();
  StreamSubscription? listener;
  bool isLoading = false;

  final List<UserNotification> notifications = [];

  factory NotificationController() {
    return _instance;
  }

  cancelAllListener() async {
    await listener?.cancel();
    debugPrint("Notification listener cancelled");
  }

  Future<void> listenToUserNotification() async {
    await cancelAllListener();
    notifications.clear();
    debugPrint("Listen to user notifications");
    listener = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .snapshots()
        .listen((event) async {
      isLoading = true;
      notifyListeners();
      for (var element in event.docChanges) {
        UserNotification notification =
            UserNotification.fromJson(element.doc.id, element.doc.data()!);

        switch (element.type) {
          case DocumentChangeType.added:
            notifications.add(notification);
            break;
          case DocumentChangeType.modified:
            notifications[notifications
                .indexWhere((d) => d.id == notification.id)] = notification;
            break;
          case DocumentChangeType.removed:
            notifications.removeWhere((d) => d.id == notification.id);
            break;
        }
      }
      notifications.sort(
        (a, b) => b.createAt.compareTo(a.createAt),
      );
      debugPrint("Fetch ${notifications.length} notifications");
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Map<String, dynamic>> markAsRead(Map<String, dynamic> data) async {
    return callCloudFunction(data, "notification-markAsRead");
  }

  Future<Map<String, dynamic>> markAllAsRead() async {
    return callCloudFunction({}, "notification-markAllAsRead");
  }

  int get totalNotification => notifications.length;

  int get totalUnread => notifications
      .where((notification) => notification.hasRead == false)
      .length;
}
