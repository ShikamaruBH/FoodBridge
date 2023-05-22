import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/model/userrole.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends ChangeNotifier {
  static final UserController _instance = UserController._internal();
  StreamSubscription? listener;

  UserController._internal();

  factory UserController() {
    return _instance;
  }

  cancelAllListener() async {
    await listener?.cancel();
    debugPrint("User listener cancelled");
  }

  Future<void> listenToUser() async {
    await cancelAllListener();
    if (authController.currentUserRole == Role.none) {
      return;
    }
    debugPrint("Listen to user ${FirebaseAuth.instance.currentUser!.uid}");
    listener = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((documentSnapshot) async {
      if (!documentSnapshot.exists) {
        authController.currentUserInfo.email = '';
        authController.currentUserInfo.phoneNumber = '';
        return;
      } else {
        final user = documentSnapshot.data()!;
        authController.currentUserInfo.email = user['email'];
        authController.currentUserInfo.phoneNumber = user['phoneNumber'];
      }
      notifyListeners();
    });
  }

  Future<Map<String, dynamic>> updateAvatar(XFile image) async {
    final imgRef = FirebaseStorage.instance
        .ref('${FirebaseAuth.instance.currentUser!.uid}/avatar.jpg');
    await imgRef.putFile(File(image.path));
    String photoURL = await imgRef.getDownloadURL();
    try {
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(photoURL);
      return {"success": true};
    } catch (err) {
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> updateDisplayName(String name) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      return {"success": true};
    } catch (err) {
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> updatePhoneNumber(String phoneNumber) async {
    return callCloudFunction(
      {"phoneNumber": phoneNumber},
      "user-updateUserInfo",
    );
  }

  Future<Map<String, dynamic>> updateEmail(String email) async {
    return callCloudFunction(
      {"email": email},
      "user-updateUserInfo",
    );
  }

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    return callCloudFunction({"uid": uid}, "user-getUserInfo");
  }

  Future<Map<String, dynamic>> getDonorInfo(String uid) async {
    return callCloudFunction({"uid": uid}, "user-getDonorInfo");
  }

  Future<Map<String, dynamic>> getRecipientInfo(String uid) async {
    return callCloudFunction({"uid": uid}, "user-getRecipientInfo");
  }
}
