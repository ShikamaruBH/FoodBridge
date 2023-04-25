import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_bridge/controller/authcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/rolebuttoncontroller.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/dialogs.dart';
import 'package:food_bridge/view/home.dart';
import 'package:food_bridge/view/languageswitch.dart';
import 'package:food_bridge/view/roleselectcolumn.dart';
import 'package:provider/provider.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  void next(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const LoadingDialog(),
    );
    AuthController().chooseRole(
        {"role": RoleButtonController().currentRole}).then((result) {
      Navigator.pop(context);
      if (result['success']) {
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
        value: LocalizationController(),
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
