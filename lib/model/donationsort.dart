// ignore_for_file: constant_identifier_names
import 'package:food_bridge/controller/controllermanagement.dart';

enum DonationSort {
  DISTANCE,
  TIME_REMAINING,
  NONE,
}

extension DonationSortExtension on DonationSort {
  String get value {
    switch (this) {
      case DonationSort.DISTANCE:
        return localeController.getTranslate('distance-title');
      case DonationSort.TIME_REMAINING:
        return localeController.getTranslate('time-remaining-title');
      case DonationSort.NONE:
        return localeController.getTranslate('order-by-text');
      default:
        return '';
    }
  }
}
