import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
}
