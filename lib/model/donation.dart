import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/recipientstatus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timer_count_down/timer_count_down.dart';

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
  Map<String, Map<String, dynamic>> recipients;
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
        data["recipients"]?.cast<String, Map<String, dynamic>>() ?? {},
        data["reviews"]?.cast<String, Map<String, dynamic>>() ?? {},
      );

  num getQuantityLeft() {
    num total = 0;
    recipients.forEach((_, recipient) {
      if (RecipientStatusExtension.fromValue(recipient['status']) !=
          RecipientStatus.rejected) {
        total += recipient["quantity"];
      }
    });
    return quantity - total;
  }

  getTimeRemaining() {
    if (DateTime.now().isBefore(start)) {
      return Text(
        localeController.getTranslate('donation-has-not-start-yet-text'),
        style: StyleManagement.donationDetailTextStyle,
      );
    }
    if (DateTime.now().isAfter(end)) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  "${localeController.getTranslate('time-remaining-title')}: ",
              style: StyleManagement.donationDetailTextStyle,
            ),
            TextSpan(
              text: localeController.getTranslate('donation-ended-text'),
              style: StyleManagement.notificationTitleMedium
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }
    Duration duration = end.difference(DateTime.now());
    return Countdown(
      seconds: duration.inSeconds,
      interval: const Duration(seconds: 1),
      build: (_, seconds) => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  "${localeController.getTranslate('time-remaining-title')}: ",
              style: StyleManagement.donationDetailTextStyle,
            ),
            TextSpan(
              text: Function.apply(
                localeController.getTranslate("time-remaining-text"),
                getDayHourMinute(seconds),
              ),
              style: StyleManagement.notificationTitleMedium
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> getDayHourMinute(double seconds) {
    Duration duration = Duration(seconds: seconds.toInt());
    return [
      duration.inDays,
      duration.inHours.remainder(24),
      duration.inMinutes.remainder(60),
      duration.inSeconds.remainder(60)
    ];
  }
}
