import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/bottombuttoncontroller.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/mapcontroller.dart';
import 'package:food_bridge/controller/quantitycontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/model/userinfo.dart';
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
    quantityController.reset();
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FutureBuilder(
                        future: userController.getUserInfo(donation.donor),
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
                          final userInfo = AppUserInfo.fromJson(
                              snapshot.data!['result'].data);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getUserAvatar(constraints, userInfo),
                              HSpacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                  onTap: () => openDonorProfile(context),
                                  child: Text(
                                    userInfo.displayName,
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
                  const VSpacer(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: getImageDisplayer(constraints),
                          ),
                          Divider(color: ColorManagement.hintTextColorDark),
                          Expanded(
                            child: Card(
                              color: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                donation.title,
                                                style: StyleManagement
                                                    .menuTextStyle
                                                    .copyWith(fontSize: 17),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${localeController.getTranslate('food-quantity-title')}: ",
                                                  style: StyleManagement
                                                      .donationDetailTextStyle,
                                                ),
                                                TextSpan(
                                                  text: localeController
                                                          .getTranslate(
                                                              "quantity-left-text")(
                                                      donation
                                                          .getQuantityLeft(),
                                                      donation.unit),
                                                  style: StyleManagement
                                                      .notificationTitleMedium
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VSpacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [donation.getTimeRemaining()],
                                      ),
                                      const VSpacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            localeController.getTranslate(
                                                    'address-title') +
                                                ': ',
                                            style: StyleManagement
                                                .donationDetailTextStyle,
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: ChangeNotifierProvider.value(
                                              value: mapController,
                                              child: Consumer<MapController>(
                                                builder:
                                                    (_, mapController, __) =>
                                                        InkWell(
                                                  onTap: () =>
                                                      showRoute(context),
                                                  child:
                                                      getCurrentAddressTextWidget(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VSpacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            localeController.getTranslate(
                                                    'pickup-instruction-text') +
                                                ': ',
                                            style: StyleManagement
                                                .donationDetailTextStyle,
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              donation.note,
                                              style: StyleManagement
                                                  .notificationTitleMedium
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChangeNotifierProvider.value(
                      value: bottomButtonController,
                      child: Consumer<BottomButtonController>(
                        builder: (_, bottomButtonController, __) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getBottomButton(context, constraints),
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

  getCurrentAddressTextWidget() {
    if (mapController.isLoading) {
      return Text(
        localeController.getTranslate('loading-text'),
        style: StyleManagement.notificationTitleMedium
            .copyWith(fontWeight: FontWeight.w600),
      );
    }
    return RichText(
      text: TextSpan(
          style: StyleManagement.notificationTitleMedium
              .copyWith(fontWeight: FontWeight.w600),
          children: [
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

  List<Widget> getBottomButton(
      BuildContext context, BoxConstraints constraints) {
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
            HSpacer(),
            showReviewsButton(context, constraints),
          ];
        }
        return [
          if (bottomButtonController.isQuantityOpen)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FoodQuantityButton(
                    constraints,
                    Icons.remove,
                    quantityController.decrease,
                    const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                  Container(
                    width: constraints.maxWidth * .1,
                    height: constraints.maxWidth * .12,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.symmetric(
                            horizontal: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.secondary))),
                    child: ChangeNotifierProvider.value(
                      value: quantityController,
                      child: Consumer<QuantityController>(
                        builder: (_, quantityController, __) => TextField(
                          controller: quantityController.controller,
                          onChanged: quantityController.setValue,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: StyleManagement.quantityTextStyle,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  HSpacer(
                    offset: -9.9,
                  ),
                  FoodQuantityButton(
                    constraints,
                    Icons.add,
                    quantityController.increase,
                    const BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                  HSpacer(),
                  IconButton(
                    onPressed: () => receiveDonation(donation.id),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: bottomButtonController.switchQuantity,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          if (!bottomButtonController.isQuantityOpen) ...[
            Flexible(
              child: ElevatedButton(
                onPressed: () => bottomButtonController.switchQuantity(),
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
            HSpacer(),
            showReviewsButton(context, constraints),
          ],
        ];
      default:
        return [];
    }
  }

  Flexible showReviewsButton(BuildContext context, BoxConstraints constraints) {
    return Flexible(
      child: InkWell(
        onTap: () => showReviews(context, constraints),
        child: SizedBox(
          height: constraints.maxWidth * .1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mode_comment_outlined,
                color: ColorManagement.iconColor,
              ),
              HSpacer(),
              Flexible(
                child: Text(
                  localeController.getTranslate('review-button-text'),
                  style: StyleManagement.historyItemTitleTextStyle
                      .copyWith(color: ColorManagement.iconColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getUserAvatar(BoxConstraints constraints, AppUserInfo userInfo) {
    if (userInfo.photoURL != null) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: userInfo.photoURL!,
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

  void showReviews(context, BoxConstraints constraints) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: constraints.maxHeight * .9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios))
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: getReviewListView(constraints),
              ),
            )
          ],
        ),
      ),
    );
  }

  getReviewListView(BoxConstraints constraints) {
    if (donation.reviews.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(localeController.getTranslate('no-review-text')),
        ],
      );
    }
    return ListView.builder(
      itemCount: donation.reviews.length,
      itemBuilder: (context, index) {
        return reviewListTitle(index, constraints);
      },
    );
  }

  reviewListTitle(int index, BoxConstraints constraints) {
    return FutureBuilder(
      future: userController.getUserInfo(donation.reviews.keys.toList()[index]),
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
        final userInfo = AppUserInfo.fromJson(snapshot.data!["result"].data);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getReviewerAvatar(constraints, userInfo),
                HSpacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => {},
                          child: Text(
                            userInfo.displayName,
                            style: StyleManagement.menuTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(donation.reviews.values
                            .toList()[index]["rating"]
                            .toString()),
                        HSpacer(),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const VSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    donation.reviews.values.toList()[index]["review"],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  getReviewerAvatar(BoxConstraints constraints, AppUserInfo userInfo) {
    if (userInfo.photoURL != null) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: userInfo.photoURL!,
          width: constraints.maxWidth / 10,
          height: constraints.maxWidth / 10,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: SizedBox(
              width: constraints.maxWidth / 10,
              height: constraints.maxWidth / 10,
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
      radius: constraints.maxWidth / 20,
      child: Icon(
        Icons.person,
        size: constraints.maxWidth / 20,
        color: Colors.white,
      ),
    );
  }

  openDonorProfile(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const LoadingDialog(
        message: 'loading-user-info-text',
      ),
    );
    await userController.getDonorInfo(donation.donor).then((result) {
      Navigator.pop(navigatorKey.currentState!.context);
      if (result['success']) {
        DonorInfo donorInfo = DonorInfo.fromJson(result["result"].data);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DonorProfileScreen(donorInfo: donorInfo),
          ),
        );
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
}

// ignore: must_be_immutable
class FoodQuantityButton extends StatelessWidget {
  final BoxConstraints constraints;
  final IconData icon;
  final Function callback;
  final BorderRadius borderRadius;
  bool isHoding = false;
  int delay = 500;
  int minDelay = 10;
  FoodQuantityButton(
    this.constraints,
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
        width: constraints.maxWidth * .1,
        height: 47,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
