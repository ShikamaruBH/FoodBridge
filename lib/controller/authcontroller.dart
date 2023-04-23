import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();

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

  chooseRole(Map<String, String> map) {}
}
