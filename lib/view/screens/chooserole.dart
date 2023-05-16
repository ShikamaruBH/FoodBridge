import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/rolebuttoncontroller.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/screens/home.dart';
import 'package:food_bridge/view/widgets/languageswitch.dart';
import 'package:provider/provider.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  void next(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const LoadingDialog(),
    );
    authController.chooseRole(
        {"role": RoleButtonController().currentRole}).then((result) {
      Navigator.pop(context);
      if (result['success']) {
        donationController.listenToUserChange();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => ErrorDialog(result['err']),
        );
      }
    }).catchError((err) {
      Navigator.pop(context);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ErrorDialog(err),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: localeController,
        child: Consumer<LocalizationController>(
          builder: (__, localeController, _) => Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  foregroundDecoration: const BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment(-0.2, 1),
                      image: AssetImage("assets/images/foods.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 80,
                child: LaguageSwitchWidget(),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                      elevation: 20,
                      child: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    localeController
                                        .getTranslate('choose-role-title'),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 31,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    localeController.getTranslate(
                                        'choose-role-description'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SelectRoleColumn(
                                          "assets/images/give.png",
                                          'donor',
                                          'donor-text',
                                          'donor-description',
                                          localeController,
                                          false),
                                      SelectRoleColumn(
                                          "assets/images/receive.png",
                                          'recipient',
                                          'recipient-text',
                                          'recipient-description',
                                          localeController,
                                          true)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () => next(context),
                                    style: StyleManagement.elevatedButtonStyle
                                        .copyWith(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary)),
                                    child: Text(
                                      localeController
                                          .getTranslate('next-button-title'),
                                      style: const TextStyle(fontSize: 20),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RoleSelectButton extends StatelessWidget {
  final String imagePath;
  final String role;
  final bool mirror;
  const RoleSelectButton(
    this.imagePath,
    this.role,
    this.mirror, {
    super.key,
  });

  Color getColor(RoleButtonController controller, context) {
    return controller.currentRole == role
        ? ColorManagement.selectedColor
        : Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ChangeNotifierProvider.value(
        value: RoleButtonController(),
        child: Consumer<RoleButtonController>(
          builder: (_, controller, __) => Material(
            color: getColor(controller, context), // Button color
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.5), // Splash color
              onTap: () {
                controller.setRole(role);
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Transform.scale(
                        scaleX: mirror ? -1 : 1,
                        child: Image.asset(imagePath))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectRoleColumn extends StatelessWidget {
  final LocalizationController localeController;
  final String imgPath;
  final String title;
  final String desc;
  final String role;
  final bool mirror;

  const SelectRoleColumn(
    this.imgPath,
    this.role,
    this.title,
    this.desc,
    this.localeController,
    this.mirror, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RoleSelectButton(imgPath, role, mirror),
          const SizedBox(
            height: 5,
          ),
          Text(
            localeController.getTranslate(title),
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            localeController.getTranslate(desc),
            textAlign: TextAlign.center,
            style: StyleManagement.descriptionTextStyleLight,
          ),
        ],
      ),
    );
  }
}
