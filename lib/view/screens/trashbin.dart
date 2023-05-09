import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/screens/donationdetail.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
              builder: (_, donationController, __) => Column(
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
      return Text(localeController.getTranslate('no-data-text'));
    }
    if (donationController.deletedDonations.isNotEmpty &&
        !donationController.isLoading) {
      return ListView.builder(
        itemCount: donationController.deletedDonations.length,
        itemBuilder: (context, index) => DonationTileWidget(index),
      );
    }
    if (donationController.isLoading) {
      return Text(localeController.getTranslate('loading-text'));
    }
  }
}

class DonationTileWidget extends StatelessWidget {
  final int index;
  const DonationTileWidget(
    this.index, {
    super.key,
  });
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
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const LoadingDialog(
        message: 'deleting-text',
      ),
    );
    await donationController.deleteDonation({"id": id}).then((result) async {
      Navigator.pop(navigatorKey.currentState!.context);
      if (result['success']) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'delete-donation-success-text',
            'delete-donation-success-description',
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

  @override
  Widget build(BuildContext context) {
    final donation = donationController.deletedDonations[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Slidable(
        key: Key(donation.id),
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
                  builder: (context) => DonationDetailScreen(donation),
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
                      child: FutureBuilder(
                        future: donationController.getUrl(donation.imgs.first),
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
                            placeholder: (context, url) => const Center(
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
}
