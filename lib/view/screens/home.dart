import 'package:flutter/material.dart';
import 'package:food_bridge/controller/authcontroller.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/screens/chooselocation.dart';
import 'package:food_bridge/view/screens/login.dart';
import 'package:food_bridge/view/screens/settings.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void logout() async {
    await AuthController().signOut();
    Navigator.of(navigatorKey.currentState!.context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: LocalizationController(),
      child: Consumer<LocalizationController>(
        builder: (_, localeController, __) => LayoutBuilder(
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
                  children: [
                    const AccountHeaderWidget(),
                    MenuListTile(
                        Icons.account_box_rounded, 'account-title', () {}),
                    MenuListTile(
                      Icons.settings,
                      'setting-title',
                      () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      )),
                    ),
                    MenuListTile(Icons.logout, 'logout-title', logout),
                  ],
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
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                await Permission.location.request();
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChooseLocationScreen(),
                  ),
                );
              },
            ),
            body: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 57,
                    child: Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),
                  const CustomSpacerWidget(),
                  Text(
                    AuthController().currentUsername,
                    style: StyleManagement.usernameTextStyle,
                  ),
                  const CustomSpacerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          localeController.getTranslate('welcome-back-text'),
                          style: StyleManagement.regularTextStyle,
                        ),
                      )
                    ],
                  ),
                  const CustomSpacerWidget(),
                  MonthlyDescriptionTextWidget(5),
                  DonationHistoryWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DonationHistoryWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  DonationHistoryWidget({
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
          child: Column(
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
                                  .getTranslate('donation-history-text'),
                            ),
                            TextSpan(
                              text: ' (2)',
                              style: StyleManagement.notificationTitleBold
                                  .copyWith(fontSize: 20),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) => const DonationTileWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonationTileWidget extends StatelessWidget {
  const DonationTileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: ColorManagement.donationTileColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 71,
                  height: 85,
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(5),
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
                            children: const [
                              Expanded(
                                child: Text(
                                  "Mixed Vegetables and a b c d e f g h i j k",
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
                                  "Category: Grocery, Cooked, Beverage, Fruits",
                                  style: StyleManagement
                                      .historyItemCategoryTextStyle,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: const [Text("Apr 15, 2023")],
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
}

class MonthlyDescriptionTextWidget extends StatelessWidget {
  final num total;
  // ignore: prefer_const_constructors_in_immutables
  MonthlyDescriptionTextWidget(
    this.total, {
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
                child: RichText(
                    text: TextSpan(
                        style: StyleManagement.monthlyDescriptionTextStyle,
                        children: [
                      TextSpan(
                        text: localeController
                            .getTranslate('monthly-donation-text-part-1'),
                      ),
                      TextSpan(
                        text: ' $total ',
                      ),
                      TextSpan(
                        text: localeController
                            .getTranslate('monthly-donation-text-part-2'),
                      ),
                    ])),
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
  const AccountHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
            child: CircleAvatar(
              radius: 57,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              AuthController().currentUsername,
              style: StyleManagement.usernameTextStyle,
            ),
          ),
        ],
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
