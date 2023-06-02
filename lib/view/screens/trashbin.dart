import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/model/loadinghandler.dart';
import 'package:food_bridge/view/screens/donationdetail.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/spacer.dart';

class TrashBinScreen extends StatelessWidget {
  const TrashBinScreen({super.key});

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
                localeController.getTranslate(
                  'trash-bin-title',
                ),
              ),
            ),
            body: Container(
              color: Theme.of(context).colorScheme.primary,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Column(
                children: const [
                  DeletedDonationWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeletedDonationWidget extends StatelessWidget {
  const DeletedDonationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              builder: (_, ___, __) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              style: StyleManagement.usernameTextStyle
                                  .copyWith(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: localeController
                                      .getTranslate('deleted-donation-text'),
                                ),
                                TextSpan(
                                  text:
                                      ' (${donationController.isLoading ? 0 : donationController.deletedDonations.length})',
                                  style: StyleManagement.notificationTitleBold
                                      .copyWith(fontSize: 20),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: getDeletedDonationListView(),
                  ),
                  const VSpacer(),
                  if (donationController.deletedDonations.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () => deleteAll(),
                              style: StyleManagement.elevatedButtonStyle
                                  .copyWith(
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              ColorManagement.deleteColor)),
                              child: Text(
                                localeController
                                    .getTranslate('delete-all-button-title'),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getDeletedDonationListView() {
    if (donationController.deletedDonations.isEmpty) {
      return Text(localeController.getTranslate('no-delete-donation-text'));
    }
    if (donationController.deletedDonations.isNotEmpty &&
        !donationController.isLoading) {
      return SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: donationController.deletedDonations.length,
          itemBuilder: (context, index) => DonationTileWidget(index),
        ),
      );
    }
    if (donationController.isLoading) {
      return Text(localeController.getTranslate('loading-text'));
    }
  }

  deleteAll() async {
    await loadingHandler(
      () => donationController.deleteAllDonation({}),
      (_) {
        Navigator.pop(navigatorKey.currentState!.context);
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'delete-all-donation-success-text',
            'delete-all-donation-success-description',
            () {},
            showActions: false,
          ),
        );
      },
      loadingText: 'deleting-text',
      autoClose: true,
    );
  }
}

class DonationTileWidget extends StatelessWidget {
  final int index;
  const DonationTileWidget(
    this.index, {
    super.key,
  });
  Future<bool> restoreDonation(String id) async {
    return loadingHandler(
      () => donationController.restoreDonation({"id": id}),
      (_) => showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => SuccessDialog(
          'restore-donation-success-text',
          'restore-donation-success-description',
          () {},
          showActions: false,
        ),
      ),
      loadingText: 'restoring-text',
      autoClose: true,
    );
  }

  Future<bool> deleteDonation(String id) async {
    bool rs = await showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const ConfirmDialog(
        'delete-donation-confirm-title',
        'delete-donation-confirm-content',
      ),
    );
    if (!rs) {
      return rs;
    }
    return loadingHandler(
      () => donationController.deleteDonation({"id": id}),
      (_) => showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => SuccessDialog(
          'delete-donation-success-text',
          'delete-donation-success-description',
          () {},
          showActions: false,
        ),
      ),
      loadingText: 'deleting-text',
      autoClose: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final donation = donationController.deletedDonations[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Slidable(
        key: Key(donation.id),
        groupTag: "deletedDonationTile",
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: .3,
          dismissible: DismissiblePane(
            onDismissed: () {},
            closeOnCancel: true,
            confirmDismiss: () async {
              restoreDonation(donation.id);
              return false;
            },
          ),
          children: [
            SlidableAction(
              onPressed: (context) async {
                await restoreDonation(donation.id);
              },
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.restore_rounded,
              label: localeController.getTranslate('restore-text'),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: .3,
          dismissible: DismissiblePane(
            onDismissed: () {},
            closeOnCancel: true,
            confirmDismiss: () async {
              deleteDonation(donation.id);
              return false;
            },
          ),
          children: [
            SlidableAction(
              onPressed: (context) async {
                await deleteDonation(donation.id);
              },
              borderRadius: BorderRadius.circular(10),
              backgroundColor: ColorManagement.deleteColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: localeController.getTranslate('delete-text'),
            ),
          ],
        ),
        child: Card(
          color: ColorManagement.donationTileColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          child: InkWell(
            onTap: () {
              mapController.setAddress(donation.latlng);
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
                                    style: StyleManagement
                                        .historyItemTitleTextStyle,
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
                              children: [
                                Text(DateFormat('dd/MM/yyyy')
                                    .format(donation.createAt))
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
}
