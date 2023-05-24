import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/model/donation.dart';
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
        authController.currentUserInfo.likes = 0;
        return;
      } else {
        final user = documentSnapshot.data()!;
        authController.currentUserInfo.email = user['email'];
        authController.currentUserInfo.phoneNumber = user['phoneNumber'];
        authController.currentUserInfo.likes = user['likes'];
        authController.currentUserInfo.isLiked = user['likedUsers']
                ?.contains(FirebaseAuth.instance.currentUser!.uid) ??
            false;
      }
      notifyListeners();
    });
  }

  Future<Map<String, dynamic>> updateAvatar(XFile image) async {
    final imgRef = FirebaseStorage.instance
        .ref('${FirebaseAuth.instance.currentUser!.uid}/avatar.jpg');
    await imgRef.putFile(File(image.path));
    String photoURL = await imgRef.getDownloadURL();
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(photoURL);
    return callCloudFunction({"photoURL": photoURL}, "user-updateUserInfo");
  }

  Future<Map<String, dynamic>> updateDisplayName(String name) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      return callCloudFunction({"displayName": name}, "user-updateUserInfo");
    } catch (err) {
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> updatePhoneNumber(String phoneNumber) async {
    return callCloudFunction(
        {"phoneNumber": phoneNumber}, "user-updateUserInfo");
  }

  Future<Map<String, dynamic>> updateEmail(String email) async {
    return callCloudFunction({"email": email}, "user-updateUserInfo");
  }

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    debugPrint("Getting info of $uid");
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final data = documentSnapshot.data();
      final result = {
        "displayName": data!['displayName'],
        "photoURL": data['photoURL'],
      };
      return {"success": true, "result": result};
    } catch (err) {
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> getDonorInfo(String uid) async {
    debugPrint("Getting donor info of $uid");
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final data = documentSnapshot.data();
      final List<String> likedUsers = data!["likedUsers"].cast<String>() ?? [];
      final isLiked =
          likedUsers.contains(FirebaseAuth.instance.currentUser!.uid);

      final querySnapshot = await FirebaseFirestore.instance
          .collection("donations")
          .where("donor", isEqualTo: uid)
          .get();

      final recipientSet = <String>{};

      for (var element in querySnapshot.docs) {
        final Map<String, dynamic> recipients =
            element.data()["recipients"]?.cast<String, dynamic>() ?? {};
        recipientSet.addAll(recipients.keys);
      }

      final result = {
        "displayName": data['displayName'],
        "photoURL": data['photoURL'],
        "email": data['email'],
        "phoneNumber": data['phoneNumber'],
        "likes": data['likes'] ?? 0,
        "isLiked": isLiked,
        "totalDonation": querySnapshot.size,
        "totalRecipient": recipientSet.length,
      };
      return {"success": true, "result": result};
    } catch (err) {
      debugPrint("Error: $err");
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> getDonationUserInfo(String id) async {
    Donation donation = donationController.getDonation(id);
    return getUserInfo(donation.donor);
  }

  Future<Map<String, dynamic>> getRecipientInfo(String uid) async {
    debugPrint("Getting recipient info of $uid");
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final data = documentSnapshot.data();
      final List<String> likedUsers = data!["likedUsers"].cast<String>() ?? [];
      final isLiked =
          likedUsers.contains(FirebaseAuth.instance.currentUser!.uid);

      final querySnapshot = await FirebaseFirestore.instance
          .collection("donations")
          .where("recipients.$uid", isNull: false)
          .get();

      final result = {
        "displayName": data['displayName'],
        "photoURL": data['photoURL'],
        "email": data['email'],
        "phoneNumber": data['phoneNumber'],
        "likes": data['likes'] ?? 0,
        "isLiked": isLiked,
        "totalReceivedDonation": querySnapshot.size,
      };
      return {"success": true, "result": result};
    } catch (err) {
      debugPrint("Error: $err");
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> likeUser(String uid) async {
    return callCloudFunction({"uid": uid}, "user-likeUser");
  }
}
