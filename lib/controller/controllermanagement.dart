import 'package:food_bridge/controller/authcontroller.dart';
import 'package:food_bridge/controller/bottombuttoncontroller.dart';
import 'package:food_bridge/controller/datetimepickercontroller.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/finddonationfiltercontroller.dart';
import 'package:food_bridge/controller/foodtypecheckboxcontroller.dart';
import 'package:food_bridge/controller/likebuttoncontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/mapcontroller.dart';
import 'package:food_bridge/controller/notificationcontroller.dart';
import 'package:food_bridge/controller/quantitycontroller.dart';
import 'package:food_bridge/controller/reviewdialogcontroller.dart';
import 'package:food_bridge/controller/usercontroller.dart';

final mapController = MapController();
final authController = AuthController();
final userController = UserController();
final filterController = FilterController();
final quantityController = QuantityController();
final donationController = DonationController();
final reviewController = ReviewDialogController();
final localeController = LocalizationController();
final likeButtonController = LikeButtonController();
final bottomButtonController = BottomButtonController();
final notificationController = NotificationController();
final dateTimePickerController = DatetimePickerController();
final foodCategoryController = FoodCategoryCheckBoxController();
