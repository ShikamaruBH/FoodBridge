import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/model/userrole.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();
  String currentUsername = 'No username';
  Role currentUserRole = Role.none;
  String? currentUserAvatar;

  AuthController._internal();

  factory AuthController() {
    return _instance;
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
      currentUsername = userCredential.user!.displayName ?? "No display name";
      IdTokenResult idTokenResult =
          await userCredential.user!.getIdTokenResult();
      currentUserRole =
          RoleExtension.fromValue(idTokenResult.claims?['role'] ?? '');
      currentUserAvatar = userCredential.user!.photoURL;
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
      currentUsername = userCredential.user!.displayName ?? "No display name";
      IdTokenResult idTokenResult =
          await userCredential.user!.getIdTokenResult();
      currentUserRole =
          RoleExtension.fromValue(idTokenResult.claims?['role'] ?? '');
      currentUserAvatar = userCredential.user!.photoURL;
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
      currentUsername = user.displayName!;
      IdTokenResult idTokenResult = await user.getIdTokenResult();
      currentUserRole =
          RoleExtension.fromValue(idTokenResult.claims?['role'] ?? '');
      currentUserAvatar = user.photoURL;
      return true;
    }
    return false;
  }
}
