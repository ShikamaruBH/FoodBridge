import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/widget_controller/passwordtextfieldcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/customvalidators.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/loadinghandler.dart';
import 'package:food_bridge/view/screens/login.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/widgets/languageswitch.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  RegisterScreen({super.key});

  void toLoginScreen() {
    Navigator.of(navigatorKey.currentState!.context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void register(context) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = _formKey.currentState!.value;
      await loadingHandler(
        () => authController.register({
          "fullname": data["fullname"].trim(),
          "email": data["email"].trim(),
          "password": data["password"].trim(),
        }),
        (_) => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => SuccessDialog(
            'register-success-text',
            'register-success-description',
            toLoginScreen,
          ),
        ),
      );
    }
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
                      alignment: Alignment(0.7, 1),
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
                      elevation: 20,
                      child: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FormBuilder(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      localeController.getTranslate(
                                          'register-button-title'),
                                      style: StyleManagement.titleTextStyle,
                                    ),
                                    const VSpacer(),
                                    FormBuilderTextField(
                                      name: 'fullname',
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.person),
                                        label: Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              WidgetSpan(
                                                child: Text(localeController
                                                    .getTranslate(
                                                        'name-textfield-title')),
                                              ),
                                              const WidgetSpan(
                                                child: Text(
                                                  '*',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      validator: CustomValidator.required,
                                    ),
                                    const VSpacer(),
                                    FormBuilderTextField(
                                      name: 'email',
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
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
                                    const VSpacer(),
                                    ChangeNotifierProvider.value(
                                      value: passwordTextFieldController,
                                      child:
                                          Consumer<PasswordTextfieldController>(
                                        builder: (_, controller, __) =>
                                            FormBuilderTextField(
                                          name: 'password',
                                          obscureText: !controller.visible,
                                          decoration: InputDecoration(
                                            label: Text.rich(
                                              TextSpan(
                                                children: <InlineSpan>[
                                                  WidgetSpan(
                                                    child: Text(localeController
                                                        .getTranslate(
                                                            'password-textfield-title')),
                                                  ),
                                                  const WidgetSpan(
                                                    child: Text(
                                                      '*',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            prefixIcon: const Icon(Icons.lock),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                              ),
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed:
                                                  controller.switchVisible,
                                              icon: Icon(controller.visible
                                                  ? Icons.visibility
                                                  : Icons
                                                      .visibility_off_outlined),
                                            ),
                                          ),
                                          validator:
                                              FormBuilderValidators.compose(
                                            [
                                              CustomValidator.required,
                                              CustomValidator.minLength(6),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const VSpacer(),
                                    ChangeNotifierProvider.value(
                                      value: PasswordTextfieldController(),
                                      child:
                                          Consumer<PasswordTextfieldController>(
                                        builder: (_, controller, __) =>
                                            FormBuilderTextField(
                                          name: 'password2',
                                          obscureText: !controller.visible,
                                          decoration: InputDecoration(
                                            label: Text.rich(
                                              TextSpan(
                                                children: <InlineSpan>[
                                                  WidgetSpan(
                                                    child: Text(localeController
                                                        .getTranslate(
                                                            'password2-textfield-title')),
                                                  ),
                                                  const WidgetSpan(
                                                    child: Text(
                                                      '*',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            prefixIcon: const Icon(Icons.lock),
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          validator:
                                              FormBuilderValidators.compose(
                                            [
                                              CustomValidator.required,
                                              CustomValidator.minLength(6),
                                              (password) {
                                                _formKey.currentState?.save();
                                                if (password !=
                                                    _formKey.currentState!
                                                        .value['password']) {
                                                  return localeController
                                                      .getTranslate(
                                                          'password2-error-textfield-title');
                                                }
                                                return null;
                                              }
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const VSpacer(),
                                    ElevatedButton(
                                      onPressed: () => register(context),
                                      style:
                                          StyleManagement.elevatedButtonStyle,
                                      child: Text(
                                        localeController.getTranslate(
                                            'register-button-title'),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const VSpacer(),
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
