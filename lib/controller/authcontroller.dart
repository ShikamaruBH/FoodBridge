import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();
  String currentUsername = 'No username';
  String currentUserRole = '';

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
      currentUserRole = idTokenResult.claims?['role'] ?? '';
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
      currentUserRole = idTokenResult.claims?['role'] ?? '';
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
}
