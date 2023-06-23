import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/recipientstatus.dart';

class ReceivingDialogController extends ChangeNotifier {
  static final ReceivingDialogController _instance =
      ReceivingDialogController._internal();
  bool isDialogShowing = false;
  StreamSubscription? listener;
  ReceivingDialogController._internal();

  factory ReceivingDialogController() {
    return _instance;
  }

  Future<void> cancelAllListener() async {
    await listener?.cancel();
    debugPrint("Recipient status listener cancelled");
  }

  void listenToRecipientStatus(String donationId, String recipientUid) async {
    await listener?.cancel();
    debugPrint(
        "Listening to recipient status of $recipientUid in donation $donationId");
    listener = FirebaseFirestore.instance
        .collection("donations")
        .doc(donationId)
        .snapshots()
        .listen((event) {
      final recipients = event.get("recipients");
      final status = RecipientStatusExtension.fromValue(
          recipients[recipientUid]!["status"]);
      if (status == RecipientStatus.received && isDialogShowing) {
        Navigator.pop(navigatorKey.currentState!.context, {"success": true});
      }
    });
  }
}
