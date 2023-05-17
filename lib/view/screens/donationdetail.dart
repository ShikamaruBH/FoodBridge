import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/mapcontroller.dart';
import 'package:food_bridge/controller/quantitycontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/model/donorinfo.dart';
import 'package:food_bridge/model/userrole.dart';
import 'package:food_bridge/view/screens/neworupdatedonation.dart';
import 'package:food_bridge/view/screens/profile.dart';
import 'package:food_bridge/view/screens/routeviewer.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:provider/provider.dart';

class DonationDetailScreen extends StatelessWidget {
  final Donation donation;
  const DonationDetailScreen(this.donation, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ChangeNotifierProvider.value(
        value: localeController,
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: FutureBuilder(
                        future: userController.getDonorInfo(donation.donor),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                HSpacer(),
                                const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ],
                            );
                          }
                          final donorInfo =
                              DonorInfo.fromJson(snapshot.data!['result'].data);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getUserAvatar(constraints, donorInfo),
                              HSpacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                  onTap: () => {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DonorProfileScreen(
                                                donorInfo: donorInfo),
                                      ),
                                    )
                                  },
                                  child: Text(
                                    donorInfo.displayName,
                                    style:
                                        StyleManagement.menuTextStyle.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: getImageDisplayer(constraints),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    donation.title,
                                    style: StyleManagement.menuTextStyle
                                        .copyWith(fontSize: 17),
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
                                          donation.getQuantityLeft(),
                                          donation.unit),
                                      style: StyleManagement
                                          .donationDetailTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const VSpacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [donation.getTimeRemaining()],
                          ),
                          const VSpacer(),
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
                                  value: mapController,
                                  child: Consumer<MapController>(
                                    builder: (_, mapController, __) => InkWell(
                                      onTap: () => showRoute(context),
                                      child: getCurrentAddressTextWidget(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const VSpacer(),
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
                                  style:
                                      StyleManagement.donationDetailTextStyle,
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

  getCurrentAddressTextWidget() {
    if (mapController.isLoading) {
      return Text(
        localeController.getTranslate('loading-text'),
        style: StyleManagement.donationDetailTextStyle,
      );
    }
    return RichText(
      text: TextSpan(style: StyleManagement.donationDetailTextStyle, children: [
        TextSpan(text: mapController.currentAddress),
        const TextSpan(text: ". "),
        TextSpan(
          text: localeController.getTranslate('show-on-map-text'),
          style: StyleManagement.notificationTitleBold.copyWith(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ]),
    );
  }

  getImageDisplayer(BoxConstraints constraints) {
    if (donation.imgs.isEmpty) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight * .25,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_food),
            const VSpacer(),
            Text(localeController.getTranslate('no-image-text')),
          ],
        ),
      );
    }
    return CarouselSlider.builder(
      itemCount: donation.imgs.length,
      itemBuilder: (context, index, realIndex) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder(
          future:
              donationController.getUrl(donation.donor, donation.imgs[index]),
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
              width: constraints.maxWidth,
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
        ),
      ),
      options: CarouselOptions(
        height: constraints.maxHeight * .25,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
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

  void receiveDonation(String id) async {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const LoadingDialog(
        message: 'loading-text',
      ),
    );
    await donationController.receiveDonation({
      "id": id,
      "quantity": quantityController.value,
    }).then((result) async {
      Navigator.pop(navigatorKey.currentState!.context);
      if (result['success']) {
        Navigator.pop(navigatorKey.currentState!.context);
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'receive-donation-success-text',
            'receive-donation-success-description',
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
    }).catchError((err) {
      Navigator.pop(navigatorKey.currentState!.context);
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => ErrorDialog(err),
      );
    });
  }

  void reviewDonation(String id) async {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const LoadingDialog(
        message: 'loading-text',
      ),
    );
    await donationController.reviewDonation({
      "id": id,
      "rating": reviewController.rating,
      "review": reviewController.review,
    }).then((result) async {
      Navigator.pop(navigatorKey.currentState!.context);
      if (result['success']) {
        Navigator.pop(navigatorKey.currentState!.context);
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'review-donation-success-text',
            'review-donation-success-description',
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
    }).catchError((err) {
      Navigator.pop(navigatorKey.currentState!.context);
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => ErrorDialog(err),
      );
    });
  }

  List<Widget> getBottomButton(BuildContext context) {
    switch (authController.currentUserRole) {
      case Role.donor:
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
            ),
          ];
        }
        return [
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                foodCategoryController.update(donation.categories);
                donationController.urls = List.from(donation.imgs);
                donationController.images.clear();
                dateTimePickerController.setStart(donation.start);
                dateTimePickerController.setEnd(donation.end);
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
        ];
      case Role.recipient:
        if (donation.recipients
            .containsKey(FirebaseAuth.instance.currentUser!.uid)) {
          return [
            Flexible(
              child: ElevatedButton(
                onPressed: () async {
                  var uid = FirebaseAuth.instance.currentUser!.uid;
                  if (donation.reviews.containsKey(uid)) {
                    reviewController.rating =
                        donation.reviews[uid]!["rating"].toDouble();
                    reviewController.review = donation.reviews[uid]!["review"];
                  }
                  bool rs = await showDialog(
                    context: navigatorKey.currentState!.context,
                    builder: (context) => const ReviewDialog(),
                  );
                  if (rs) {
                    reviewDonation(donation.id);
                  }
                },
                style: StyleManagement.elevatedButtonStyle.copyWith(
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Text(
                  localeController.getTranslate('review-button-title'),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ];
        }
        return [
          FoodQuantityButton(
            Icons.remove,
            quantityController.decrease,
            const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          HSpacer(
            offset: -9.5,
          ),
          Container(
            color: Colors.white,
            width: 40,
            child: ChangeNotifierProvider.value(
              value: quantityController,
              child: Consumer<QuantityController>(
                builder: (_, quantityController, __) => TextField(
                  controller: quantityController.controller,
                  onChanged: quantityController.setValue,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: StyleManagement.quantityTextStyle,
                ),
              ),
            ),
          ),
          HSpacer(
            offset: -9.9,
          ),
          FoodQuantityButton(
            Icons.add,
            quantityController.increase,
            const BorderRadius.only(
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
          ),
          HSpacer(),
          Flexible(
            child: ElevatedButton(
              onPressed: () => receiveDonation(donation.id),
              style: StyleManagement.elevatedButtonStyle.copyWith(
                backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Text(
                localeController.getTranslate('receive-text'),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ];
      default:
        return [];
    }
  }

  getUserAvatar(BoxConstraints constraints, DonorInfo donorInfo) {
    if (donorInfo.photoURL != null) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: donorInfo.photoURL!,
          width: constraints.maxWidth / 7,
          height: constraints.maxWidth / 7,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: SizedBox(
              width: constraints.maxWidth / 7,
              height: constraints.maxWidth / 7,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.grey.shade300,
      radius: constraints.maxWidth / 14,
      child: Icon(
        Icons.person,
        size: constraints.maxWidth / 14,
        color: Colors.white,
      ),
    );
  }

  void showRoute(context) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          ViewRouteScreen(donation.latlng.latitude, donation.latlng.longitude),
    ));
  }
}

// ignore: must_be_immutable
class FoodQuantityButton extends StatelessWidget {
  final IconData icon;
  final Function callback;
  final BorderRadius borderRadius;
  bool isHoding = false;
  int delay = 500;
  int minDelay = 10;
  FoodQuantityButton(
    this.icon,
    this.callback,
    this.borderRadius, {
    super.key,
  });

  void callbackLoop(details) async {
    if (isHoding) {
      return;
    }
    isHoding = true;
    int newDelay = delay;
    int count = 0;
    while (isHoding) {
      callback();
      await Future.delayed(Duration(milliseconds: newDelay));
      count++;
      if (count % 5 != 0) {
        continue;
      }
      if (newDelay > minDelay) {
        newDelay ~/= 2;
      }
    }
  }

  void stopCallbackLoop(details) {
    isHoding = false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: callbackLoop,
      onTapUp: stopCallbackLoop,
      onTap: () => stopCallbackLoop(1),
      onTapCancel: () => stopCallbackLoop(1),
      borderRadius: borderRadius,
      child: Ink(
        width: 40,
        height: 47,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 30,
          ),
        ),
      ),
    );
  }
}
