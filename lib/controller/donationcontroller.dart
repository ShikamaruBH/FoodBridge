import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:image_picker/image_picker.dart';

class DonationController extends ChangeNotifier {
  static final DonationController _instance = DonationController._internal();

  List<XFile> images = [];

  DonationController._internal();

  factory DonationController() {
    return _instance;
  }

  void addImage(XFile image) {
    images.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  Future<Map<String, dynamic>> createDonation(Map<String, dynamic> data) async {
    List<String> imgs = [];
    String imgName;
    for (XFile img in images) {
      imgName = "${DateTime.now().toString()}-${img.name}";
      await FirebaseStorage.instance
          .ref('${FirebaseAuth.instance.currentUser!.uid}/$imgName')
          .putFile(File(img.path));
      imgs.add(imgName);
    }
    data['imgs'] = imgs;
    print("Data: $data");
    return callCloudFunction(data, "donation-createDonation");
  }
}
