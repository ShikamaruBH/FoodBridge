import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/widget_controller/datetimepickercontroller.dart';
import 'package:food_bridge/controller/widget_controller/distanceslidercontroller.dart';
import 'package:food_bridge/controller/widget_controller/finddonationfiltercontroller.dart';
import 'package:food_bridge/controller/widget_controller/foodtypecheckboxcontroller.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/model/donationsort.dart';
import 'package:food_bridge/model/donationsortdropdownitem.dart';
import 'package:food_bridge/view/screens/donationdetail.dart';
import 'package:food_bridge/view/widgets/donationdatetimepicker.dart';
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
            body: ChangeNotifierProvider.value(
              value: filterController,
              child: Consumer<FilterController>(
                builder: (_, ___, __) => Container(
                  width: constraints.maxWidth,
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    children: [
                      showFilter(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: filterController.isEnable ? 10 : 0,
                          ),
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
                                builder: (_, ___, __) => Column(
                                  children: [
                                    InkWell(
                                      onTap: filterController.swap,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            getIcon(),
                                            size: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                    AvailableDonationWidget(
                                      'available-donation-text',
                                      constraints,
                                    ),
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
        ),
      ),
    );
  }

  showFilter() {
    if (!filterController.isEnable) {
      return const Text("");
    }
    return Padding(
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
              builder: (_, ___, __) => Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const FieldTitleWidget('end-after-title'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: DonationDatetimePicker(
                            'start',
                            (value) {
                              dateTimePickerController.setStart(value);
                              donationController.listenToFilteredDonation();
                            },
                            dateTimePickerController.start,
                            style: StyleManagement.textFieldTextStyleLight
                                .copyWith(fontSize: 14),
                            decoration: DecoratorManagement
                                .defaultTextFieldDecoratorLight,
                            format: 'MMMM dd, yyyy hh:mm a',
                            prefix: Icons.calendar_month_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VSpacer(),
          const FieldTitleWidget('radius-title'),
          const DistanceSlider()
        ],
      ),
    );
  }

  getIcon() {
    if (filterController.isEnable) {
      return Icons.arrow_drop_up_sharp;
    }
    return Icons.arrow_drop_down_sharp;
  }
}

class AvailableDonationWidget extends StatelessWidget {
  final String text;
  final BoxConstraints constraints;
  // ignore: prefer_const_constructors_in_immutables
  AvailableDonationWidget(
    this.text,
    this.constraints, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            builder: (_, ___, __) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            style: StyleManagement.usernameTextStyle
                                .copyWith(color: Colors.black),
                            children: [
                              TextSpan(
                                text: localeController.getTranslate(text),
                              ),
                              TextSpan(
                                text:
                                    ' (${donationController.isLoading ? 0 : donationController.donations.length})',
                                style: StyleManagement.notificationTitleBold
                                    .copyWith(fontSize: 20),
                              )
                            ]),
                      ),
                      HSpacer(),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * .3,
                              child: FormBuilderDropdown(
                                name: "sort",
                                decoration:
                                    DecoratorManagement.dropdownButtonDecorator,
                                initialValue: donationController.currentSort,
                                borderRadius: BorderRadius.circular(8),
                                selectedItemBuilder: (context) => dropdownItems
                                    .map((option) => Text(
                                          option.value!.value,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                    .toList(),
                                items: dropdownItems,
                                onChanged: (value) {
                                  donationController.setCurrentSort(value!);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: getavailableListView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getavailableListView() {
    if (donationController.donations.isEmpty) {
      return Text(localeController.getTranslate('no-available-donation-text'));
    }
    if (donationController.donations.isNotEmpty &&
        !donationController.isLoading) {
      return ListView.builder(
        itemCount: donationController.donations.length,
        itemBuilder: (context, index) => DonationTileWidget(index),
      );
    }
    if (donationController.isLoading) {
      return const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }
  }
}

class DonationTileWidget extends StatelessWidget {
  final int index;
  const DonationTileWidget(
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final donation = donationController.donations[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: ColorManagement.donationTileColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        child: InkWell(
          onTap: () {
            mapController.setAddress(donation.latlng);
            quantityController.setMaxValue(donation.getQuantityLeft().toInt());
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DonationDetailScreen(donation.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: SizedBox(
                    width: 71,
                    height: 85,
                    child: getDonationThumbnail(donation),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 2, bottom: 2, right: 0),
                    child: SizedBox(
                      height: 85,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  donation.title,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      StyleManagement.historyItemTitleTextStyle,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Category: ${donation.categories.map((e) => localeController.getTranslate(e)).join(", ")}",
                                  style: StyleManagement
                                      .historyItemCategoryTextStyle,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [getDonationDistance(donation)],
                          ),
                          Row(
                            children: [
                              Flexible(child: donation.getTimeRemaining())
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getDonationThumbnail(Donation donation) {
    if (donation.imgs.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.no_food),
      );
    }
    return FutureBuilder(
      future: donationController.getUrl(donation.donor, donation.imgs.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }
        return CachedNetworkImage(
          imageUrl: snapshot.data!,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
    );
  }

  getDonationDistance(Donation donation) {
    double m = donationController.calculateDistance(
      donation.latlng.latitude,
      donation.latlng.longitude,
    );
    if (m < 1000) {
      return Text(
        "${m.toInt()} m",
        style: StyleManagement.notificationTitleBold.copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    }
    double km = m / 1000;
    return Text(
      "${km.toStringAsFixed(2)} Km",
      style: StyleManagement.notificationTitleBold.copyWith(
        fontWeight: FontWeight.w600,
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
      value: distanceSliderController,
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
                  onChanged: (value) {
                    sliderController.setValue(value);
                    donationController.listenToFilteredDonation();
                  },
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
        builder: (_, ___, __) => Column(
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              color: foodCategoryController.status(type)
                  ? ColorManagement.foodTypeCheckBoxCardBackgroundChecked
                  : ColorManagement.foodTypeCheckBoxCardBackgroundUncheck,
              child: InkWell(
                onTap: () {
                  foodCategoryController.check(type);
                  donationController.listenToFilteredDonation();
                },
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: Icon(
                    icon,
                    size: 48,
                    color: foodCategoryController.status(type)
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
                  color: Colors.white.withOpacity(
                      foodCategoryController.status(type) ? .87 : .43),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
