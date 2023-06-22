import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<FirebaseApp> initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandle);
  return firebaseApp;
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandle(RemoteMessage message) async {
  debugPrint("Receive new message");
  final data = message.data;
  await notificationService.showNotification(data);
}

Future<Map<String, dynamic>> callCloudFunction(
    Map<String, dynamic> data, String funcName) async {
  try {
    final result =
        await FirebaseFunctions.instance.httpsCallable(funcName).call(data);
    return {"success": true, "result": result};
  } on FirebaseFunctionsException catch (err) {
    return {"success": false, "err": err};
  }
}
