import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/distanceslidercontroller.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/model/userrole.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:md5_file_checksum/md5_file_checksum.dart';

class DonationController extends ChangeNotifier {
  static final DonationController _instance = DonationController._internal();
  final Distance distance = const Distance();
  List<String> urls = [];
  List<XFile> images = [];
  List<Donation> donations = [];
  List<Donation> receivedDonations = [];
  List<Donation> allDonations = [];
  List<Donation> deletedDonations = [];
  Map<String, String> imgURLs = {};
  bool isLoading = false;
  StreamSubscription? listener;

  DonationController._internal() {
    listenToUserChange();
  }

  factory DonationController() {
    return _instance;
  }

  void listenToUserChange() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        listener?.cancel();
        return;
      }
      switch (authController.currentUserRole) {
        case Role.donor:
          listenToUserDonation();
          break;
        case Role.recipient:
          listenToFilteredDonation();
          break;
        default:
      }
    });
  }

  void listenToUserDonation() {
    listener?.cancel();
    allDonations.clear();
    debugPrint(
        "Listen to donations of user ${FirebaseAuth.instance.currentUser!.uid}");
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
            allDonations.add(donation);
            break;
          case DocumentChangeType.modified:
            allDonations[allDonations.indexWhere((d) => d.id == donation.id)] =
                donation;
            break;
          case DocumentChangeType.removed:
            allDonations.removeWhere((d) => d.id == donation.id);
            for (var img in donation.imgs) {
              imgURLs.remove(img);
            }
            break;
        }
      }
      donations =
          allDonations.where((element) => element.deleteAt == null).toList();
      deletedDonations =
          allDonations.where((element) => element.deleteAt != null).toList();
      isLoading = false;
      notifyListeners();
    });
  }

  void listenToFilteredDonation() {
    listener?.cancel();
    donations.clear();
    debugPrint(
        "Listen to filtered donations from user ${FirebaseAuth.instance.currentUser!.uid}");
    debugPrint("Category filter: ${foodCategoryController.getChecked()}");
    debugPrint(
        "Datetime filter: ${dateTimePickerController.start.toUtc().toString()}");
    debugPrint("Distance filter: ${DistanceSliderController().value}");
    Query query = FirebaseFirestore.instance.collection('donations').where(
          'start',
          isGreaterThanOrEqualTo:
              dateTimePickerController.start.toUtc().toIso8601String(),
        );
    if (foodCategoryController.getChecked().isNotEmpty) {
      query = query.where(
        'categories',
        arrayContainsAny: foodCategoryController.getChecked(),
      );
    }
    listener = query.snapshots().listen((event) async {
      isLoading = true;
      notifyListeners();
      for (var element in event.docChanges) {
        Donation donation = Donation.fromJson(
            element.doc.id, element.doc.data()! as Map<String, dynamic>);
        if (!distanceFilter(
            donation.latlng.latitude, donation.latlng.longitude)) {
          continue;
        }
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
      debugPrint("Donation $donations");
      isLoading = false;
      notifyListeners();
    });
  }

  bool distanceFilter(double latitude, double longitude) {
    final LatLng userLatLng = LatLng(
      mapController.currentLatLng.latitude,
      mapController.currentLatLng.longitude,
    );
    final LatLng donationLatLng = LatLng(latitude, longitude);
    final double km = distance(donationLatLng, userLatLng) / 1000;
    debugPrint(
        "Donation latlng: $donationLatLng, User latlng: $userLatLng, distance: $km");
    return km <= DistanceSliderController().value;
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

  void clearImageCache() {
    urls.clear();
    foodCategoryController.update([]);
    images.clear();
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
    clearImageCache();
    return callCloudFunction(data, 'donation-deleteDonation');
  }

  Future<Map<String, dynamic>> softDeleteDonation(
      Map<String, dynamic> data) async {
    clearImageCache();
    return callCloudFunction(data, 'donation-softDeleteDonation');
  }

  Future<Map<String, dynamic>> restoreDonation(
      Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-restoreDonation');
  }

  Future<String> getUrl(String uid, String img) async {
    try {
      if (!imgURLs.containsKey(img)) {
        imgURLs[img] =
            await FirebaseStorage.instance.ref("$uid/$img").getDownloadURL();
      }
      return imgURLs[img]!;
    } catch (e) {
      return '';
    }
  }
}
