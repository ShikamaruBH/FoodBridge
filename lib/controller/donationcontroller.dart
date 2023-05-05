import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:md5_file_checksum/md5_file_checksum.dart';

class DonationController extends ChangeNotifier {
  static final DonationController _instance = DonationController._internal();
  List<Donation> donations = [];
  Map<String, String> imgURLs = {};
  StreamSubscription? listener;
  List<XFile> images = [];
  List<String> urls = [];
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

  void removeUrl(index) {
    urls.removeAt(index);
    notifyListeners();
  }

  Future<Map<String, dynamic>> createDonation(Map<String, dynamic> data) async {
    List<String> imgs = [];
    String imgName;
    for (XFile img in images) {
      String imgHash =
          await Md5FileChecksum.getFileChecksum(filePath: img.path);
      imgName = "$imgHash.jpg";
      final imgRef = FirebaseStorage.instance
          .ref('${FirebaseAuth.instance.currentUser!.uid}/$imgName');
      try {
        await imgRef.getData();
        print("Image already exist");
      } catch (e) {
        await imgRef.putFile(File(img.path));
        imgs.add(imgName);
      }
    }
    data['imgs'] = imgs;
    images.clear();
    return callCloudFunction(data, "donation-createDonation");
  }

  Future<Map<String, dynamic>> updateDonation(Map<String, dynamic> data) async {
    List<String> imgs = [];
    String imgName;
    for (XFile img in images) {
      String imgHash =
          await Md5FileChecksum.getFileChecksum(filePath: img.path);
      imgName = "$imgHash.jpg";
      final imgRef = FirebaseStorage.instance
          .ref('${FirebaseAuth.instance.currentUser!.uid}/$imgName');
      try {
        await imgRef.getData();
        print("Image already exist");
      } catch (e) {
        await imgRef.putFile(File(img.path));
        imgs.add(imgName);
      }
    }
    imgs.addAll(urls);
    data['imgs'] = imgs;
    images.clear();
    return callCloudFunction(data, "donation-updateDonation");
  }

  Future<Map<String, dynamic>> deleteDonation(Map<String, dynamic> data) async {
    urls.clear();
    foodCategoryController.update([]);
    images.clear();
    return callCloudFunction(data, 'donation-deleteDonation');
  }

  Future<String> getUrl(String img) async {
    try {
      if (!imgURLs.containsKey(img)) {
        imgURLs[img] = await FirebaseStorage.instance
            .ref("${FirebaseAuth.instance.currentUser!.uid}/$img")
            .getDownloadURL();
      }
      return imgURLs[img]!;
    } catch (e) {
      return '';
    }
  }
}
