import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/foodtypecheckboxcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/mapcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/view/screens/neworupdatedonation.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DonationDetailScreen extends StatelessWidget {
  final Donation donation;
  const DonationDetailScreen(this.donation, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ChangeNotifierProvider.value(
        value: LocalizationController(),
        child: Consumer<LocalizationController>(
          builder: (_, localeController, __) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black.withOpacity(.01),
              elevation: 0,
              title: Text(
                localeController.getTranslate('donation-detail-title'),
                style: const TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
              ),
            ),
            body: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: CarouselSlider.builder(
                              itemCount: donation.imgs.length,
                              itemBuilder: (context, index, realIndex) =>
                                  ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FutureBuilder(
                                  future: donationController
                                      .getUrl(donation.imgs[index]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
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
                                      width: constraints.maxWidth,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                              options: CarouselOptions(
                                height: constraints.maxHeight * .25,
                                enableInfiniteScroll: false,
                                enlargeCenterPage: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    donation.title,
                                    style: StyleManagement.menuTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${localeController.getTranslate('food-quantity-title')}: ",
                                      style: StyleManagement
                                          .newDonationFieldTitleTextStyle,
                                    ),
                                    TextSpan(
                                      text: localeController.getTranslate(
                                              "quantity-left-text")(
                                          donation.quantity, donation.unit),
                                      style: StyleManagement
                                          .notificationTitleBold
                                          .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const CustomSpacerWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [getDurationUntilEnd(donation.end)],
                          ),
                          const CustomSpacerWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                localeController.getTranslate('address-title') +
                                    ': ',
                                style: StyleManagement
                                    .newDonationFieldTitleTextStyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: ChangeNotifierProvider.value(
                                  value: MapController(),
                                  child: Consumer<MapController>(
                                    builder: (_, mapController, __) => Text(
                                      mapController.currentAddress,
                                      style: StyleManagement
                                          .notificationTitleBold
                                          .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const CustomSpacerWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                localeController.getTranslate(
                                        'pickup-instruction-text') +
                                    ': ',
                                style: StyleManagement
                                    .newDonationFieldTitleTextStyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  donation.note,
                                  style: StyleManagement.notificationTitleBold
                                      .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Theme.of(context).colorScheme.primary,
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: getBottomButton(context),
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

  Future<bool> restoreDonation(String id) async {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const LoadingDialog(
        message: 'restoring-text',
      ),
    );
    await donationController.restoreDonation({"id": id}).then((result) async {
      Navigator.pop(navigatorKey.currentState!.context);
      if (result['success']) {
        Navigator.pop(navigatorKey.currentState!.context);
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'restore-donation-success-text',
            'restore-donation-success-description',
            () {},
            showActions: false,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(navigatorKey.currentState!.context).pop();
      } else {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => ErrorDialog(result['err']),
        );
      }
      return true;
    }).catchError((err) {
      Navigator.pop(navigatorKey.currentState!.context);
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => ErrorDialog(err),
      );
      return true;
    });
    return false;
  }

  List<Widget> getBottomButton(BuildContext context) {
    if (donation.deleteAt != null) {
      return [
        Flexible(
          child: ElevatedButton(
            onPressed: () => restoreDonation(donation.id),
            style: StyleManagement.elevatedButtonStyle.copyWith(
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            child: Text(
              localeController.getTranslate('restore-text'),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        )
      ];
    }
    return [
      Flexible(
        child: ElevatedButton(
          onPressed: () {
            FoodCategoryCheckBoxController().update(donation.categories);
            donationController.urls = List.from(donation.imgs);
            donationController.images.clear();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewOrUpdateDonationScreen(donation),
              ),
            );
          },
          style: StyleManagement.elevatedButtonStyle.copyWith(
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: Text(
            localeController.getTranslate('edit-button-title'),
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Flexible(
        child: ElevatedButton(
          onPressed: () {},
          style: StyleManagement.elevatedButtonStyle.copyWith(
              backgroundColor: const MaterialStatePropertyAll(
                  ColorManagement.selectedColor)),
          child: Text(
            localeController.getTranslate('rate-button-title'),
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    ];
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

  getDurationUntilEnd(DateTime end) {
    if (DateTime.now().isAfter(end)) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  "${localeController.getTranslate('time-remaining-title')}: ",
              style: StyleManagement.newDonationFieldTitleTextStyle,
            ),
            TextSpan(
              text: localeController.getTranslate('donation-ended-text'),
              style: StyleManagement.notificationTitleBold.copyWith(
                fontWeight: FontWeight.w600,
              ),
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
              style: StyleManagement.newDonationFieldTitleTextStyle,
            ),
            TextSpan(
              text: Function.apply(
                localeController.getTranslate("time-remaining-text"),
                getDayHourMinute(seconds),
              ),
              style: StyleManagement.notificationTitleBold.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
