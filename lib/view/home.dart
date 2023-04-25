import 'package:flutter/material.dart';
import 'package:food_bridge/controller/authcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/login.dart';
import 'package:food_bridge/view/settings.dart';
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
        builder: (_, localeController, __) => Scaffold(
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
                      builder: (context) => SettingsScreen(),
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
                  NotificationBarWidget(0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) => NotificationCardWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
          ),
          body: Container(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class NotificationCardWidget extends StatelessWidget {
  final localeController = LocalizationController();
  NotificationCardWidget({
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
            text: TextSpan(children: [
              TextSpan(
                text: localeController
                    .getTranslate('donor-notification-title-part-1'),
                style: StyleManagement.notificationTitleMedium,
              ),
              const TextSpan(
                text: " Rice and Beans ",
                style: StyleManagement.notificationTitleBold,
              ),
              TextSpan(
                text: localeController
                    .getTranslate('donor-notification-title-part-2'),
                style: StyleManagement.notificationTitleMedium,
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
  final LocalizationController localeController = LocalizationController();
  final num total;
  NotificationBarWidget(
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
  final localeController = LocalizationController();
  final IconData icon;
  final String title;
  final Function callback;
  MenuListTile(
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
