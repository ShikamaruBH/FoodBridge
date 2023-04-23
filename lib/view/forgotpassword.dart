import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/model/customvalidators.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/languageswitch.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  ForgotPasswordPage({super.key});

  void sendEmail(context) {
    _formKey.currentState?.validate();
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
                      alignment: Alignment.bottomLeft,
                      image: AssetImage("assets/images/foods.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 80,
                child: LaguageSwitchWidget(localeController),
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
                      elevation: 20,
                      child: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.lock_rounded,
                                size: 130,
                              ),
                              FormBuilder(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      localeController.getTranslate(
                                          'forgot-password-title'),
                                      style: StyleManagement.titleTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      localeController.getTranslate(
                                          'forgot-password-description'),
                                      textAlign: TextAlign.center,
                                      style: StyleManagement
                                          .descriptionTextStyleDark,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FormBuilderTextField(
                                      name: 'email',
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        label: Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              WidgetSpan(
                                                child: Text("Email"),
                                              ),
                                              WidgetSpan(
                                                child: Text(
                                                  '*',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      validator: FormBuilderValidators.compose(
                                        [
                                          CustomValidator.required,
                                          CustomValidator.email,
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () => sendEmail(context),
                                      style:
                                          StyleManagement.elevatedButtonStyle,
                                      child: Text(
                                        localeController.getTranslate(
                                            'reset-password-button-title'),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: StyleManagement.textButtonStyle,
                                      child: Text(localeController
                                          .getTranslate('back-button-title')),
                                    ),
                                  ],
                                ),
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
