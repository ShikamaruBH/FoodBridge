import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_bridge/controller/authcontroller.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/model/loadinghandler.dart';
import 'package:food_bridge/model/userrole.dart';
import 'package:food_bridge/view/screens/chooselocation.dart';
import 'package:food_bridge/view/screens/donationdetail.dart';
import 'package:food_bridge/view/screens/login.dart';
import 'package:food_bridge/view/screens/profile.dart';
import 'package:food_bridge/view/screens/settings.dart';
import 'package:food_bridge/view/screens/trashbin.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:food_bridge/view/widgets/useravatar.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout() async {
    await authController.signOut();
    Navigator.of(navigatorKey.currentState!.context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: localeController,
      child: Consumer<LocalizationController>(
        builder: (_, ___, __) => LayoutBuilder(
          builder: (context, constraints) => Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],
            ),
            drawer: SafeArea(
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: getDrawerListTitle(context),
                ),
              ),
            ),
            endDrawer: SafeArea(
              child: Drawer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const NotificationBarWidget(0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, index) =>
                            const NotificationCardWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: getFloatingButton(context),
            body: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Theme.of(context).colorScheme.primary,
              child: ChangeNotifierProvider.value(
                value: donationController,
                child: Consumer<DonationController>(
                  builder: (_, ___, __) => ChangeNotifierProvider.value(
                    value: authController,
                    child: Consumer<AuthController>(
                      builder: (_, ___, __) => Column(
                        children: [
                          UserAvatar(constraints),
                          const VSpacer(),
                          Text(
                            authController.currentUserInfo.displayName,
                            style: StyleManagement.usernameTextStyle,
                          ),
                          const VSpacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  localeController
                                      .getTranslate('welcome-back-text'),
                                  style: StyleManagement.regularTextStyle,
                                ),
                              )
                            ],
                          ),
                          const VSpacer(),
                          getCurrentMonthReportTextWidget(),
                          getDonationHistoryWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton getFloatingButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(authController.currentUserRole == Role.donor
          ? Icons.add
          : Icons.search),
      onPressed: () async {
        await Permission.location.request();
        dateTimePickerController.reset();
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChooseLocationScreen(true),
          ),
        );
      },
    );
  }

  getDonationHistoryWidget() {
    switch (authController.currentUserRole) {
      case Role.donor:
        return DonationHistoryWidget(
          'donation-history-text-donor',
          'no-donation-text',
          donationController.donations,
          true,
        );
      case Role.recipient:
        return DonationHistoryWidget(
          'donation-history-text-recipient',
          'no-received-donation-text',
          donationController.receivedDonations,
          false,
        );
      default:
        return const Text('');
    }
  }

  getCurrentMonthReportTextWidget() {
    switch (authController.currentUserRole) {
      case Role.donor:
        return MonthlyDescriptionTextWidget(
          donationController.getTotalDonationThisMonth(),
          'monthly-donation-text-donor',
        );
      case Role.recipient:
        return MonthlyDescriptionTextWidget(
          donationController.getTotalReceivedDonationThisMonth(),
          'monthly-donation-text-recipient',
        );
      default:
        return const Text('');
    }
  }

  getDrawerListTitle(BuildContext context) {
    return [
      ChangeNotifierProvider.value(
        value: authController,
        child: Consumer<AuthController>(
          builder: (__, authController, _) => AccountHeaderWidget(),
        ),
      ),
      MenuListTile(Icons.account_box_rounded, 'profile-title', () {
        likeButtonController.setLike(authController.currentUserInfo.getLikes());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const UserProfileScreen(),
          ),
        );
      }),
      if (authController.currentUserRole == Role.donor)
        MenuListTile(
          Icons.delete_rounded,
          'trash-bin-title',
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TrashBinScreen(),
            ),
          ),
        ),
      MenuListTile(
        Icons.settings,
        'setting-title',
        () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        ),
      ),
      MenuListTile(Icons.logout, 'logout-title', logout),
    ];
  }
}

class DonationHistoryWidget extends StatelessWidget {
  final String text;
  final String noDataText;
  final List<Donation> source;
  final bool canDelete;
  // ignore: prefer_const_constructors_in_immutables
  DonationHistoryWidget(
    this.text,
    this.noDataText,
    this.source,
    this.canDelete, {
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
                                  text: localeController.getTranslate(text),
                                ),
                                TextSpan(
                                  text:
                                      ' (${donationController.isLoading ? 0 : source.length})',
                                  style: StyleManagement.notificationTitleBold
                                      .copyWith(fontSize: 20),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: getHistoryListView(noDataText, source, canDelete),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getHistoryListView(String nodata, List<Donation> source, bool canDelete) {
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
    if (source.isEmpty) {
      return Text(localeController.getTranslate(nodata));
    }
    if (source.isNotEmpty && !donationController.isLoading) {
      return ListView.builder(
        itemCount: source.length,
        itemBuilder: (context, index) =>
            DonationTileWidget(index, source, canDelete),
      );
    }
  }
}

class DonationTileWidget extends StatelessWidget {
  final int index;
  final List<Donation> source;
  final bool canDelete;
  const DonationTileWidget(
    this.index,
    this.source,
    this.canDelete, {
    super.key,
  });

  Future<bool> softDeleteDonation(String id) async {
    bool rs = await showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const ConfirmDialog(
        'delete-donation-confirm-title',
        'soft-delete-donation-confirm-content',
      ),
    );
    if (!rs) {
      return rs;
    }
    return loadingHandler(
      () => donationController.softDeleteDonation({"id": id}),
      (_) => showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => SuccessDialog(
          'delete-donation-success-text',
          'soft-delete-donation-success-description',
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
    final donation = source[index];
    if (canDelete) {
      return getDeleteAbleDonationTile(donation, context);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: getDonationTile(donation, context),
    );
  }

  getDeleteAbleDonationTile(Donation donation, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Slidable(
        key: Key(donation.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: .3,
          dismissible: DismissiblePane(
            onDismissed: () {},
            closeOnCancel: true,
            confirmDismiss: () async {
              softDeleteDonation(donation.id);
              return false;
            },
          ),
          children: [
            SlidableAction(
              onPressed: (context) async {
                await softDeleteDonation(donation.id);
              },
              borderRadius: BorderRadius.circular(10),
              backgroundColor: ColorManagement.deleteColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: localeController.getTranslate('delete-text'),
            ),
          ],
        ),
        child: getDonationTile(donation, context),
      ),
    );
  }

  getDonationTile(Donation donation, BuildContext context) {
    return Card(
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
                    left: 10,
                    top: 2,
                    bottom: 2,
                    right: 0,
                  ),
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

class MonthlyDescriptionTextWidget extends StatelessWidget {
  final num total;
  final String text;
  // ignore: prefer_const_constructors_in_immutables
  MonthlyDescriptionTextWidget(
    this.total,
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(
          width: constraints.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  localeController.getTranslate(text)(total),
                  style: StyleManagement.monthlyDescriptionTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCardWidget extends StatelessWidget {
  const NotificationCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManagement.notificationUnread,
      child: ListTile(
        onTap: () {},
        trailing: Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            'Just now',
            style: TextStyle(fontSize: 12),
          ),
        ),
        title: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
                style: StyleManagement.notificationTitleMedium,
                children: [
                  TextSpan(
                    text: localeController
                        .getTranslate('donor-notification-title-part-1'),
                  ),
                  const TextSpan(
                    text: " Rice and Beans ",
                    style: StyleManagement.notificationTitleBold,
                  ),
                  TextSpan(
                    text: localeController
                        .getTranslate('donor-notification-title-part-2'),
                  ),
                  const TextSpan(
                    text: " Nadia Kim",
                    style: StyleManagement.notificationTitleBold,
                  )
                ])),
      ),
    );
  }
}

class NotificationBarWidget extends StatelessWidget {
  final num total;
  const NotificationBarWidget(
    this.total, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: localeController.getTranslate('notifications-text'),
                    style: StyleManagement.usernameTextStyle.copyWith(
                      color: ColorManagement.titleColorDark,
                    ),
                  ),
                  TextSpan(
                    text: " ($total)",
                    style: StyleManagement.usernameTextStyle.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          splashRadius: 20,
          onPressed: () {},
          icon: const Icon(
            Icons.clear_all_rounded,
            size: 34,
          ),
        ),
      ],
    );
  }
}

class AccountHeaderWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AccountHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
        height: 175,
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
              child: UserAvatar(constraints),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                authController.currentUserInfo.displayName,
                style: StyleManagement.usernameTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function callback;
  const MenuListTile(
    this.icon,
    this.title,
    this.callback, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: StyleManagement.getIcon(icon),
      title: Text(
        localeController.getTranslate(title),
        style: StyleManagement.menuTextStyle,
      ),
      onTap: () => callback(),
    );
  }
}
