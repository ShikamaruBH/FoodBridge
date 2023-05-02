import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:image_picker/image_picker.dart';

class DonationController extends ChangeNotifier {
  static final DonationController _instance = DonationController._internal();
  List<Donation> donations = [];
  Map<String, String> imgURLs = {};
  StreamSubscription? listener;
  List<XFile> images = [];
  bool isLoading = false;

  DonationController._internal() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        listenToUserDonation();
      }
    });
  }

  factory DonationController() {
    return _instance;
  }

  void listenToUserDonation() {
    listener?.cancel();
    donations.clear();
    listener = FirebaseFirestore.instance
        .collection('donations')
        .where('donor', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) async {
      isLoading = true;
      notifyListeners();
      for (var element in event.docChanges) {
        Donation donation =
            Donation.fromJson(element.doc.id, element.doc.data()!);

        switch (element.type) {
          case DocumentChangeType.added:
            donations.add(donation);
            for (var img in donation.imgs) {
              imgURLs[img] = await FirebaseStorage.instance
                  .ref("${FirebaseAuth.instance.currentUser!.uid}/$img")
                  .getDownloadURL();
            }
            break;
          case DocumentChangeType.modified:
            donations[donations.indexWhere((d) => d.id == donation.id)] =
                donation;
            break;
          case DocumentChangeType.removed:
            donations.removeWhere((d) => d.id == donation.id);
            for (var img in donation.imgs) {
              imgURLs.remove(img);
            }
            break;
        }
      }
      isLoading = false;
      notifyListeners();
    });
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
    return callCloudFunction(data, "donation-createDonation");
  }
}
