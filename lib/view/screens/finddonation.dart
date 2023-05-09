import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/datetimepickercontroller.dart';
import 'package:food_bridge/controller/distanceslidercontroller.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/foodtypecheckboxcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/screens/neworupdatedonation.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:provider/provider.dart';

class FindDonationScreen extends StatelessWidget {
  const FindDonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ChangeNotifierProvider.value(
        value: localeController,
        child: Consumer<LocalizationController>(
          builder: (__, localeController, _) => Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              title: Text(
                localeController.getTranslate('find-donation-title'),
              ),
            ),
            body: Container(
              width: constraints.maxWidth,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        const FieldTitleWidget('food-type-title'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              FoodTypeCheckBoxWidget(
                                'food-type-grocery',
                                Icons.local_grocery_store_rounded,
                              ),
                              FoodTypeCheckBoxWidget(
                                'food-type-cooked',
                                Icons.ramen_dining_rounded,
                              ),
                              FoodTypeCheckBoxWidget(
                                'food-type-fruits',
                                Icons.apple_rounded,
                              ),
                              FoodTypeCheckBoxWidget(
                                'food-type-beverage',
                                Icons.emoji_food_beverage_rounded,
                              ),
                            ],
                          ),
                        ),
                        ChangeNotifierProvider.value(
                          value: dateTimePickerController,
                          child: Consumer<DatetimePickerController>(
                            builder: (_, dateTimePickerController, __) => Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const FieldTitleWidget(
                                          'food-start-date-title'),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: DonationDatetimePicker(
                                          'start',
                                          dateTimePickerController.setStart,
                                          dateTimePickerController.start,
                                          style: StyleManagement
                                              .textFieldTextStyleLight,
                                          decoration: DecoratorManagement
                                              .defaultTextFieldDecoratorLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const CustomSpacerWidget(),
                        const FieldTitleWidget('distance-title'),
                        const DistanceSlider()
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(13),
                            topRight: Radius.circular(13),
                          ),
                        ),
                        child: ChangeNotifierProvider.value(
                          value: donationController,
                          child: Consumer<DonationController>(
                            builder: (_, donationController, __) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            style: StyleManagement
                                                .usernameTextStyle
                                                .copyWith(color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: localeController
                                                    .getTranslate(
                                                        'avaiable-donation-text'),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' (${donationController.isLoading ? 0 : donationController.donations.length})',
                                                style: StyleManagement
                                                    .notificationTitleBold
                                                    .copyWith(fontSize: 20),
                                              )
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(child: ListView())
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DistanceSlider extends StatelessWidget {
  const DistanceSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DistanceSliderController(),
      child: Consumer<DistanceSliderController>(
        builder: (_, sliderController, __) => SliderTheme(
          data: SliderTheme.of(context).copyWith(
            tickMarkShape: SliderTickMarkShape.noTickMark,
            trackHeight: 2,
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Row(
            children: [
              Expanded(
                child: Slider(
                  max: sliderController.max,
                  divisions: sliderController.divisions,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(.4),
                  value: sliderController.value,
                  onChanged: (value) => sliderController.setValue(value),
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  '${sliderController.value.toInt()} Km',
                  textAlign: TextAlign.end,
                  style:
                      StyleManagement.newDonationFieldTitleTextStyle.copyWith(
                    color: ColorManagement.titleColorLight,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FieldTitleWidget extends StatelessWidget {
  final String title;
  const FieldTitleWidget(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          localeController.getTranslate(title),
          style: StyleManagement.newDonationFieldTitleTextStyle.copyWith(
            color: ColorManagement.titleColorLight,
          ),
        )
      ],
    );
  }
}

class FoodTypeCheckBoxWidget extends StatelessWidget {
  final String type;
  final IconData icon;

  const FoodTypeCheckBoxWidget(
    this.type,
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: foodCategoryController,
      child: Consumer<FoodCategoryCheckBoxController>(
        builder: (_, checkBoxController, __) => Column(
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              color: checkBoxController.status(type)
                  ? ColorManagement.foodTypeCheckBoxCardBackgroundChecked
                  : ColorManagement.foodTypeCheckBoxCardBackgroundUncheck,
              child: InkWell(
                onTap: () => checkBoxController.check(type),
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: Icon(
                    icon,
                    size: 48,
                    color: checkBoxController.status(type)
                        ? Colors.white
                        : ColorManagement
                            .foodTypeCheckBoxCardIconUncheckColorLight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                localeController.getTranslate(type),
                style: StyleManagement.newDonationFieldTitleTextStyle.copyWith(
                  color: Colors.white
                      .withOpacity(checkBoxController.status(type) ? .87 : .43),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
