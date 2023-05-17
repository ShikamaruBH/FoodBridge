import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/model/donationsort.dart';

final dropdownItems = [
  DropdownMenuItem(
    value: DonationSort.NONE,
    child: Text(localeController.getTranslate('order-by-text')),
  ),
  DropdownMenuItem(
    value: DonationSort.DISTANCE,
    child: Text(localeController.getTranslate('distance-title')),
  ),
  DropdownMenuItem(
    value: DonationSort.TIME_REMAINING,
    child: Text(localeController.getTranslate('time-remaining-title')),
  ),
];
