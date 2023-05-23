import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/model/userinfo.dart';
import 'package:food_bridge/model/userrole.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  static final AuthController _instance = AuthController._internal();
  AppUserInfo currentUserInfo = AppUserInfo("No username", "");
  Role currentUserRole = Role.none;
  StreamSubscription? listener;

  AuthController._internal() {
    listenToAuthState();
  }

  factory AuthController() {
    return _instance;
  }

  Future<void> listenToAuthState() async {
    await listener?.cancel();
    listener = FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        // AuthController
        currentUserInfo.displayName = user.displayName ?? "";
        currentUserInfo.photoURL = user.photoURL;
        notifyListeners();
        // DonationController
        IdTokenResult idTokenResult =
            await FirebaseAuth.instance.currentUser!.getIdTokenResult();
        Role currentUserRole =
            RoleExtension.fromValue(idTokenResult.claims?['role'] ?? '');
        switch (currentUserRole) {
          case Role.donor:
            await donationController.listenToUserDonation();
            debugPrint("User is donor, listen to user donation");
            break;
          case Role.recipient:
            debugPrint("User is recipient, listen to user received donation");
            await donationController.listenToReceivedDonation();
            break;
          default:
            debugPrint("User has no Role");
        }
        notifyListeners();
        // UserController
        await userController.listenToUser();
        notifyListeners();
      }
      if (user == null) {
        await donationController.cancelAllListener();
        await userController.cancelAllListener();
        debugPrint("User logged out, all listener cancelled");
        return;
      }
    });
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data['email'], password: data['password']);
      User user = credential.user!;
      await user.updateDisplayName(data['fullname']);
      return {"success": true};
    } on FirebaseAuthException catch (err) {
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> loginGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      currentUserInfo.displayName =
          userCredential.user!.displayName ?? "No display name";
      IdTokenResult idTokenResult =
          await userCredential.user!.getIdTokenResult();
      currentUserRole =
          RoleExtension.fromValue(idTokenResult.claims?['role'] ?? '');
      currentUserInfo.photoURL = userCredential.user!.photoURL;
      return {"success": true};
    } catch (err) {
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: data['email'], password: data['password']);
      currentUserInfo.displayName =
          userCredential.user!.displayName ?? "No display name";
      IdTokenResult idTokenResult =
          await userCredential.user!.getIdTokenResult();
      currentUserRole =
          RoleExtension.fromValue(idTokenResult.claims?['role'] ?? '');
      currentUserInfo.photoURL = userCredential.user!.photoURL;
      return {"success": true};
    } on FirebaseFunctionsException catch (err) {
      return {"success": false, "err": err};
    }
  }

  Future<Map<String, dynamic>> sendForgotPasswordEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return {"success": true};
    } on FirebaseAuthException catch (err) {
      return {"success": false, "err": err};
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    return FirebaseAuth.instance.signOut();
  }

  Future<Map<String, dynamic>> chooseRole(Map<String, String> data) async {
    return callCloudFunction(data, "user-updateUserRole");
  }

  Future<bool> checkUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserInfo.displayName = user.displayName!;
      IdTokenResult idTokenResult = await user.getIdTokenResult();
      currentUserRole =
          RoleExtension.fromValue(idTokenResult.claims?['role'] ?? '');
      currentUserInfo.photoURL = user.photoURL;
      return true;
    }
    return false;
  }
}
