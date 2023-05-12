import 'package:google_maps_flutter/google_maps_flutter.dart';

class Donation {
  String id;
  DateTime createAt;
  DateTime? deleteAt;
  String donor;
  String title;
  List<String> categories;
  LatLng latlng;
  String note;
  num quantity;
  String unit;
  DateTime start;
  DateTime end;
  List<String> imgs;
  Map<String, int> recipients;
  Map<String, Map<String, dynamic>> reviews;

  Donation(
    this.id,
    this.createAt,
    this.deleteAt,
    this.donor,
    this.title,
    this.categories,
    this.latlng,
    this.note,
    this.quantity,
    this.unit,
    this.start,
    this.end,
    this.imgs,
    this.recipients,
    this.reviews,
  );

  factory Donation.fromJson(String id, Map<String, dynamic> data) => Donation(
        id,
        data['createAt'].toDate(),
        data['deleteAt']?.toDate(),
        data['donor'],
        data['title'],
        List<String>.from(data['categories']),
        LatLng.fromJson(data['latlng'])!,
        data['note'],
        num.parse(data['quantity']),
        data['unit'],
        DateTime.parse(data['start']).toLocal(),
        DateTime.parse(data['end']).toLocal(),
        List<String>.from(data['imgs']),
        data["recipients"]?.cast<String, int>() ?? {},
        data["reviews"]?.cast<String, Map<String, dynamic>>() ?? {},
      );

  num getQuantityLeft() {
    num total = 0;
    recipients.forEach((_, value) => total += value);
    return quantity - total;
  }
}
