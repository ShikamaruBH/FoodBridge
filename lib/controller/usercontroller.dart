import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends ChangeNotifier {
  static final UserController _instance = UserController._internal();
  UserController._internal();

  factory UserController() {
    return _instance;
  }

  Future<Map<String, dynamic>> updateAvatar(XFile image) async {
    final imgRef = FirebaseStorage.instance
        .ref('${FirebaseAuth.instance.currentUser!.uid}/avatar.jpg');
    await imgRef.putFile(File(image.path));
    String photoURL = await imgRef.getDownloadURL();
    return callCloudFunction({"photoURL": photoURL}, "user-updateUserAvatar");
  }
}
