import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_bridge/controller/bottombuttoncontroller.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/mapcontroller.dart';
import 'package:food_bridge/controller/quantitycontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/loadinghandler.dart';
import 'package:food_bridge/model/recipientstatus.dart';
import 'package:food_bridge/model/userinfo.dart';
import 'package:food_bridge/model/userrole.dart';
import 'package:food_bridge/view/screens/neworupdatedonation.dart';
import 'package:food_bridge/view/screens/profile.dart';
import 'package:food_bridge/view/screens/routeviewer.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:provider/provider.dart';

class DonationDetailScreen extends StatelessWidget {
  final String donationId;
  const DonationDetailScreen(this.donationId, {super.key});

  @override
  Widget build(BuildContext context) {
    quantityController.reset();
    return LayoutBuilder(
      builder: (_, constraints) => ChangeNotifierProvider.value(
        value: localeController,
        child: Consumer<LocalizationController>(
          builder: (_, ___, __) => Scaffold(
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
              child: ChangeNotifierProvider.value(
                value: donationController,
                child: Consumer<DonationController>(
                  builder: (_, __, ___) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: FutureBuilder(
                            future: userController.getUserInfo(
                                donationController
                                    .getDonation(donationId)
                                    .donor),
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
                                  snapshot.data!['result']);
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
                                        style: StyleManagement.menuTextStyle
                                            .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                                    donationController
                                                        .getDonation(donationId)
                                                        .title,
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
                                                          donationController
                                                              .getDonation(
                                                                  donationId)
                                                              .getQuantityLeft(),
                                                          donationController
                                                              .getDonation(
                                                                  donationId)
                                                              .unit),
                                                      style: StyleManagement
                                                          .notificationTitleMedium
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
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
                                            children: [
                                              donationController
                                                  .getDonation(donationId)
                                                  .getTimeRemaining()
                                            ],
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
                                                child: ChangeNotifierProvider
                                                    .value(
                                                  value: mapController,
                                                  child:
                                                      Consumer<MapController>(
                                                    builder: (_, ___, __) =>
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
                                                  donationController
                                                      .getDonation(donationId)
                                                      .note,
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
                            builder: (_, ___, __) => Row(
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
    if (donationController.getDonation(donationId).imgs.isEmpty) {
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
      itemCount: donationController.getDonation(donationId).imgs.length,
      itemBuilder: (context, index, realIndex) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder(
          future: donationController.getUrl(
              donationController.getDonation(donationId).donor,
              donationController.getDonation(donationId).imgs[index]),
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
    return loadingHandler(
      () => donationController.restoreDonation({"id": id}),
      (_) {
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
      },
      loadingText: 'restoring-text',
      autoClose: true,
    );
  }

  void receiveDonation(String id) async {
    await loadingHandler(
      () => donationController.receiveDonation({
        "id": id,
        "quantity": quantityController.value,
      }),
      (_) {
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
      },
      autoClose: true,
    );
  }

  void reviewDonation(String id) async {
    await loadingHandler(
      () => donationController.reviewDonation({
        "id": id,
        "rating": reviewController.rating,
        "review": reviewController.review,
      }),
      (_) {
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
      },
      autoClose: true,
    );
  }

  List<Widget> getBottomButton(
      BuildContext context, BoxConstraints constraints) {
    final donation = donationController.getDonation(donationId);
    switch (authController.currentUserRole) {
      case Role.donor:
        return [
          if (donation.deleteAt != null)
            IconTextButton(
              constraints,
              () => restoreDonation(donation.id),
              Icons.restore,
              'restore-text',
            )
          else
            IconTextButton(
              constraints,
              () {
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
              Icons.edit_square,
              'edit-button-title',
            ),
          getReviewsButton(constraints, context),
          getRecipientsButton(constraints, context),
        ];
      case Role.recipient:
        if (alreadyReceivedDonation()) {
          return [
            IconTextButton(
              constraints,
              () async {
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
              Icons.rate_review,
              'review-button-title',
            ),
            getReviewsButton(constraints, context),
            getRecipientsButton(constraints, context),
          ];
        }
        if (bottomButtonController.isQuantityOpen) {
          return [
            getQuantityButton(constraints, context),
          ];
        }
        return [
          IconTextButton(
            constraints,
            () => bottomButtonController.switchQuantity(),
            Icons.card_giftcard,
            'receive-text',
          ),
          getReviewsButton(constraints, context),
          getRecipientsButton(constraints, context),
        ];
      default:
        return [];
    }
  }

  bool alreadyReceivedDonation() {
    return donationController
        .getDonation(donationId)
        .recipients
        .containsKey(FirebaseAuth.instance.currentUser!.uid);
  }

  getQuantityButton(BoxConstraints constraints, BuildContext context) {
    return Expanded(
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
                        color: Theme.of(context).colorScheme.secondary))),
            child: ChangeNotifierProvider.value(
              value: quantityController,
              child: Consumer<QuantityController>(
                builder: (_, ___, __) => TextField(
                  controller: quantityController.controller,
                  onChanged: quantityController.setValue,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: StyleManagement.quantityTextStyle,
                  decoration: const InputDecoration(border: InputBorder.none),
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
            onPressed: () =>
                receiveDonation(donationController.getDonation(donationId).id),
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
    );
  }

  getRecipientsButton(BoxConstraints constraints, BuildContext context) {
    return IconTextButton(
      constraints,
      () => showRecipients(context, constraints, 'recipients-button-text'),
      Icons.people_alt,
      'recipients-button-text',
    );
  }

  getReviewsButton(BoxConstraints constraints, BuildContext context) {
    return IconTextButton(
      constraints,
      () => showReviews(
        context,
        constraints,
        'review-button-text',
      ),
      Icons.mode_comment_outlined,
      'review-button-text',
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
    final donation = donationController.getDonation(donationId);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          ViewRouteScreen(donation.latlng.latitude, donation.latlng.longitude),
    ));
  }

  void showReviews(context, BoxConstraints constraints, String title) {
    return showBottomPanel(
      context,
      constraints,
      getReviewListView(constraints),
      title,
    );
  }

  void showRecipients(context, BoxConstraints constraints, String title) {
    return showBottomPanel(
      context,
      constraints,
      getRecipientsListView(constraints),
      title,
    );
  }

  void showBottomPanel(
    context,
    BoxConstraints constraints,
    listview,
    String title,
  ) {
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
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Text(
                  localeController.getTranslate(title),
                  style: StyleManagement.historyItemTitleTextStyle
                      .copyWith(color: ColorManagement.iconColor),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: listview,
              ),
            )
          ],
        ),
      ),
    );
  }

  getReviewListView(BoxConstraints constraints) {
    if (donationController.getDonation(donationId).reviews.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(localeController.getTranslate('no-review-text')),
        ],
      );
    }
    return ChangeNotifierProvider.value(
      value: donationController,
      child: Consumer<DonationController>(
        builder: (_, __, ___) => ListView.builder(
          itemCount: donationController.getDonation(donationId).reviews.length,
          itemBuilder: (context, index) {
            return reviewListTitle(index, constraints);
          },
        ),
      ),
    );
  }

  getRecipientsListView(BoxConstraints constraints) {
    if (donationController.getDonation(donationId).recipients.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(localeController.getTranslate('no-recipient-text')),
        ],
      );
    }
    bool isDonor = authController.currentUserRole == Role.donor;
    return ChangeNotifierProvider.value(
      value: donationController,
      child: Consumer<DonationController>(
        builder: (_, __, ___) => ListView.builder(
          itemCount:
              donationController.getDonation(donationId).recipients.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: getRecipientListTitle(index, constraints, isDonor),
            );
          },
        ),
      ),
    );
  }

  getRecipientListTitle(int index, BoxConstraints constraints, bool isDonor) {
    if (isDonor) {
      return slidableRecipientListTitle(index, constraints);
    }
    return recipientListTitle(index, constraints);
  }

  reviewListTitle(int index, BoxConstraints constraints) {
    final donation = donationController.getDonation(donationId);
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
        final userInfo = AppUserInfo.fromJson(snapshot.data!["result"]);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getRecipientAvatar(constraints, userInfo),
                HSpacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => openRecipientProfile(
                              context, donation.reviews.keys.toList()[index]),
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

  slidableRecipientListTitle(int index, BoxConstraints constraints) {
    final donation = donationController.getDonation(donationId);
    final recipientUid = donation.recipients.keys.toList()[index];
    final status = RecipientStatusExtension.fromValue(
        donation.recipients[recipientUid]["status"]);
    return Slidable(
      key: Key(donationId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: .5,
        dismissible: DismissiblePane(
          onDismissed: () {},
          closeOnCancel: true,
          confirmDismiss: () async {
            rejectRecipient(recipientUid);
            return false;
          },
        ),
        children: [
          if (status == RecipientStatus.pending) ...[
            SlidableAction(
              onPressed: (context) async {
                await rejectRecipient(recipientUid);
              },
              borderRadius: BorderRadius.circular(10),
              backgroundColor: ColorManagement.deleteColor,
              foregroundColor: Colors.black,
              icon: Icons.delete,
              label: localeController.getTranslate('reject-text'),
            ),
            SlidableAction(
              onPressed: (context) async {
                await confirmReceived(recipientUid);
              },
              borderRadius: BorderRadius.circular(10),
              backgroundColor: ColorManagement.recipientStatusReceived,
              foregroundColor: Colors.black,
              icon: Icons.done,
              label: localeController.getTranslate('confirm-button-title'),
            ),
          ],
          if (status == RecipientStatus.rejected ||
              status == RecipientStatus.received)
            SlidableAction(
              onPressed: (context) async {
                await undoRecipient(recipientUid);
              },
              borderRadius: BorderRadius.circular(10),
              backgroundColor: ColorManagement.recipientStatusPending,
              foregroundColor: Colors.black,
              icon: Icons.undo,
              label: localeController.getTranslate('undo-text'),
            ),
        ],
      ),
      child: recipientListTitle(index, constraints),
    );
  }

  recipientListTitle(int index, BoxConstraints constraints) {
    final donation = donationController.getDonation(donationId);
    final recipientUid = donation.recipients.keys.toList()[index];
    return FutureBuilder(
      future: userController.getUserInfo(recipientUid),
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
        final userInfo = AppUserInfo.fromJson(snapshot.data!["result"]);
        return Card(
          margin: EdgeInsets.zero,
          color: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getRecipientAvatar(constraints, userInfo),
                HSpacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => openRecipientProfile(context,
                              donation.recipients.keys.toList()[index]),
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
                        RichText(
                          text: TextSpan(
                              style: StyleManagement.notificationTitleBold,
                              children: [
                                TextSpan(
                                  text: localeController
                                      .getTranslate('food-quantity-title'),
                                ),
                                const TextSpan(text: ': '),
                                TextSpan(
                                  text: donation.recipients[recipientUid]
                                          ["quantity"]
                                      .toString(),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: constraints.maxWidth * .25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: getRecipentStatusColor(
                              donation.recipients[recipientUid]['status']),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            localeController.getTranslate(
                                donation.recipients[recipientUid]['status']),
                            textAlign: TextAlign.center,
                            style: StyleManagement.notificationTitleBold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getRecipientAvatar(BoxConstraints constraints, AppUserInfo userInfo) {
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
    await loadingHandler(
      () => userController
          .getDonorInfo(donationController.getDonation(donationId).donor),
      (result) {
        DonorInfo donorInfo = DonorInfo.fromJson(result["result"]);
        donorInfo.uid = donationController.getDonation(donationId).donor;
        likeButtonController.setLike(donorInfo.getLikes());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(donorInfo: donorInfo),
          ),
        );
      },
      loadingText: 'loading-user-info-text',
    );
  }

  openRecipientProfile(BuildContext context, String uid) async {
    await loadingHandler(
      () => userController.getRecipientInfo(uid),
      (result) {
        RecipientInfo recipientInfo = RecipientInfo.fromJson(result["result"]);
        recipientInfo.uid = uid;
        likeButtonController.setLike(recipientInfo.getLikes());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                UserProfileScreen(recipientInfo: recipientInfo),
          ),
        );
      },
      loadingText: 'loading-user-info-text',
    );
  }

  Future<bool> rejectRecipient(recipientUid) async {
    bool rs = await showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const ConfirmDialog(
        'reject-recipient-confirm-title',
        'reject-recipient-confirm-content',
      ),
    );
    if (!rs) {
      return rs;
    }
    return loadingHandler(
      () => donationController.rejectRecipient({
        "donationId": donationId,
        "recipientUid": recipientUid,
      }),
      (_) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'reject-recipient-success-text',
            'reject-recipient-success-description',
            () {},
            showActions: false,
          ),
        );
      },
      loadingText: 'rejecting-recipient-text',
      autoClose: true,
    );
  }

  Future<bool> undoRecipient(recipientUid) async {
    return loadingHandler(
      () => donationController.undoRecipient({
        "donationId": donationId,
        "recipientUid": recipientUid,
      }),
      (_) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'undo-recipient-success-text',
            'undo-recipient-success-description',
            () {},
            showActions: false,
          ),
        );
      },
      loadingText: 'undoing-recipient-text',
      autoClose: true,
    );
  }

  Future<bool> confirmReceived(recipientUid) async {
    return loadingHandler(
      () => donationController.confirmReceived({
        "donationId": donationId,
        "recipientUid": recipientUid,
      }),
      (_) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'confirm-recipient-success-text',
            'confirm-recipient-success-description',
            () {},
            showActions: false,
          ),
        );
      },
      loadingText: 'updating-text',
      autoClose: true,
    );
  }

  getRecipentStatusColor(String value) {
    RecipientStatus status = RecipientStatusExtension.fromValue(value);
    switch (status) {
      case RecipientStatus.pending:
        return ColorManagement.recipientStatusPending;
      case RecipientStatus.received:
        return ColorManagement.recipientStatusReceived;
      case RecipientStatus.rejected:
        return ColorManagement.recipientStatusRejected;
      default:
        return null;
    }
  }
}

class IconTextButton extends StatelessWidget {
  final BoxConstraints constraints;
  final void Function() callback;
  final IconData icon;
  final String title;
  const IconTextButton(
    this.constraints,
    this.callback,
    this.icon,
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: callback,
        child: SizedBox(
          height: constraints.maxWidth * .1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: ColorManagement.iconColor,
              ),
              HSpacer(
                offset: -8,
              ),
              Flexible(
                child: Text(
                  localeController.getTranslate(title),
                  style: StyleManagement.settingsItemTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
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
