import 'package:food_bridge/controller/authcontroller.dart';
import 'package:food_bridge/controller/datetimepickercontroller.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/finddonationfiltercontroller.dart';
import 'package:food_bridge/controller/foodtypecheckboxcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/mapcontroller.dart';
import 'package:food_bridge/controller/quantitycontroller.dart';

final localeController = LocalizationController();
final donationController = DonationController();
final mapController = MapController();
final foodCategoryController = FoodCategoryCheckBoxController();
final dateTimePickerController = DatetimePickerController();
final filterController = FilterController();
final authController = AuthController();
final quantityController = QuantityController();
