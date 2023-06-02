import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/distanceslidercontroller.dart';
import 'package:food_bridge/controller/firebasecontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/model/donationsort.dart';
import 'package:food_bridge/model/recipientstatus.dart';
import 'package:food_bridge/model/userrole.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
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
  bool isSortReveser = false;
  DonationSort currentSort = DonationSort.NONE;
  StreamSubscription? donationListener;
  StreamSubscription? receivedDonationListener;

  DonationController._internal();

  factory DonationController() {
    return _instance;
  }

  cancelAllListener() async {
    await donationListener?.cancel();
    debugPrint("Donation listener cancelled");
    await receivedDonationListener?.cancel();
    debugPrint("Received donation listener cancelled");
    allDonations.clear();
    donations.clear();
    receivedDonations.clear();
    deletedDonations.clear();
  }

  Future<void> listenToUserDonation() async {
    await cancelAllListener();
    allDonations.clear();
    debugPrint(
        "Listen to donations of user ${FirebaseAuth.instance.currentUser!.uid}");
    donationListener = FirebaseFirestore.instance
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
      debugPrint("Fetch ${donations.length} donations");
      debugPrint("Fetch ${deletedDonations.length} deleted donations");
      isLoading = false;
      notifyListeners();
    });
  }

  void listenToFilteredDonation() async {
    await donationListener?.cancel();
    donations.clear();
    debugPrint(
        "Listen to filtered donations from user ${FirebaseAuth.instance.currentUser!.uid}");
    debugPrint("Category filter: ${foodCategoryController.getChecked()}");
    debugPrint(
        "Datetime filter: ${dateTimePickerController.start.toUtc().toString()}");
    debugPrint("Distance filter: ${DistanceSliderController().value}");
    Query query = FirebaseFirestore.instance.collection('donations').where(
          'end',
          isGreaterThanOrEqualTo:
              dateTimePickerController.start.toUtc().toIso8601String(),
        );
    if (foodCategoryController.getChecked().isNotEmpty) {
      query = query.where(
        'categories',
        arrayContainsAny: foodCategoryController.getChecked(),
      );
    }
    donationListener =
        query.where("deleteAt", isNull: true).snapshots().listen((event) async {
      isLoading = true;
      notifyListeners();
      for (var element in event.docChanges) {
        var data = element.doc.data()! as Map<String, dynamic>;
        Donation donation = Donation.fromJson(element.doc.id, data);
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
      sortDonation();
      debugPrint("Fetch ${donations.length} filtered donations");
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> listenToReceivedDonation() async {
    await cancelAllListener();
    receivedDonations.clear();
    var uid = FirebaseAuth.instance.currentUser!.uid;
    debugPrint("Listen to received donations of user $uid");
    receivedDonationListener = FirebaseFirestore.instance
        .collection("donations")
        .where(
          'recipients.$uid',
          isNull: false,
        )
        .snapshots()
        .listen((event) {
      isLoading = true;
      notifyListeners();
      for (var element in event.docChanges) {
        Donation donation =
            Donation.fromJson(element.doc.id, element.doc.data()!);
        final uid = FirebaseAuth.instance.currentUser!.uid;
        final status = RecipientStatusExtension.fromValue(
            donation.recipients[uid]!["status"]);
        if (status == RecipientStatus.receiving) {
          final confirmDeadline = donation.recipients[uid]!["confirmDeadline"];
          final duration = confirmDeadline.toDate().difference(DateTime.now());
          showDialog(
            barrierDismissible: false,
            context: navigatorKey.currentState!.context,
            builder: (context) => ConfirmReceiveDonationDialog(
              duration,
              title: donation.title,
              donationId: donation.id,
              recipientUid: uid,
            ),
          );
        }
        switch (element.type) {
          case DocumentChangeType.added:
            receivedDonations.add(donation);
            break;
          case DocumentChangeType.modified:
            receivedDonations[receivedDonations
                .indexWhere((d) => d.id == donation.id)] = donation;
            break;
          case DocumentChangeType.removed:
            receivedDonations.removeWhere((d) => d.id == donation.id);
            for (var img in donation.imgs) {
              imgURLs.remove(img);
            }
            break;
        }
      }
      debugPrint("Fetch ${receivedDonations.length} received donations");
      isLoading = false;
      notifyListeners();
    });
  }

  void sortDonation() {
    switch (currentSort) {
      case DonationSort.DISTANCE:
        donations.sort(
          (a, b) => calculateDistance(a.latlng.latitude, a.latlng.longitude)
              .compareTo(
                  calculateDistance(b.latlng.latitude, b.latlng.longitude)),
        );
        break;
      case DonationSort.TIME_REMAINING:
        donations.sort(
          (a, b) => b.end.compareTo(a.end),
        );
        break;
      default:
    }
  }

  bool distanceFilter(double latitude, double longitude) {
    final double km = calculateDistance(latitude, longitude) / 1000;
    debugPrint("Distance: $km Km");
    return km <= DistanceSliderController().value;
  }

  double calculateDistance(double latitude, double longitude) {
    final LatLng userLatLng = LatLng(
      mapController.currentLatLng.latitude,
      mapController.currentLatLng.longitude,
    );
    final LatLng donationLatLng = LatLng(latitude, longitude);
    return distance(donationLatLng, userLatLng);
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
      }
      imgs.add(imgName);
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

  Future<Map<String, dynamic>> deleteAllDonation(
      Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-deleteAllDonation');
  }

  Future<Map<String, dynamic>> confirmReceived(
      Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-confirmReceived');
  }

  Future<Map<String, dynamic>> undoRecipient(Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-undoRecipient');
  }

  Future<Map<String, dynamic>> rejectRecipient(
      Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-rejectRecipient');
  }

  Future<Map<String, dynamic>> softDeleteDonation(
      Map<String, dynamic> data) async {
    clearImageCache();
    return callCloudFunction(data, 'donation-softDeleteDonation');
  }

  Future<Map<String, dynamic>> reviewDonation(Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-reviewDonation');
  }

  Future<Map<String, dynamic>> restoreDonation(
      Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-restoreDonation');
  }

  Future<Map<String, dynamic>> receiveDonation(
      Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-receiveDonation');
  }

  Future<Map<String, dynamic>> receivingDonation(
      Map<String, dynamic> data) async {
    return callCloudFunction(data, 'donation-receivingDonation');
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

  String getTotalDonation() {
    switch (authController.currentUserRole) {
      case Role.donor:
        return allDonations.length.toString();
      case Role.recipient:
        return receivedDonations.length.toString();
      default:
        return '0';
    }
  }

  String getTotalRecipient() {
    Set<String> recipients = {};
    for (var donation in allDonations) {
      recipients.addAll(donation.recipients.keys);
    }
    return recipients.length.toString();
  }

  num getTotalDonationThisMonth() {
    return getTotalDonationThisMonthOf(donations);
  }

  num getTotalReceivedDonationThisMonth() {
    return getTotalDonationThisMonthOf(receivedDonations);
  }

  num getTotalDonationThisMonthOf(List<Donation> source) {
    int thisMonth = DateTime.now().month;
    return source
        .where((donation) => donation.createAt.month == thisMonth)
        .length;
  }

  getDonation(String id) {
    for (var list in [donations, receivedDonations, deletedDonations]) {
      final rs = list.where((donation) => donation.id == id);
      if (rs.isNotEmpty) {
        return rs.first;
      }
    }
    return null;
  }

  Future<Donation> fetchDonation(String id, {bool useCache = true}) async {
    Donation? donation = getDonation(id);
    if (donation != null && useCache) {
      return donation;
    }
    final donationRef =
        FirebaseFirestore.instance.collection("donations").doc(id);
    final donationSnapshot = await donationRef.get();
    donation = Donation.fromJson(donationSnapshot.id, donationSnapshot.data()!);
    donations.add(donation);
    return donation;
  }

  void setCurrentSort(DonationSort donationSort) {
    currentSort = donationSort;
    sortDonation();
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
