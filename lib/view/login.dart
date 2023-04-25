import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_bridge/controller/authcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/passwordtextfieldcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/customvalidators.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/chooserole.dart';
import 'package:food_bridge/view/dialogs.dart';
import 'package:food_bridge/view/forgotpassword.dart';
import 'package:food_bridge/view/home.dart';
import 'package:food_bridge/view/languageswitch.dart';
import 'package:food_bridge/view/register.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  LoginScreen({super.key});

  void login(context) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = _formKey.currentState!.value;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const LoadingDialog(),
      );
      await AuthController().signOut();
      await AuthController().login({
        "email": data["email"].trim(),
        "password": data["password"],
      }).then((result) {
        Navigator.pop(context);
        if (result['success']) {
          navigate();
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
  }

  void loginGoogle(context) async {
    await AuthController().signOut();
    await AuthController().loginGoogle().then((result) {
      if (result['success']) {
        navigate();
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

  void navigate() {
    if (AuthController().currentUserRole.isNotEmpty) {
      Navigator.of(navigatorKey.currentState!.context).push(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.of(navigatorKey.currentState!.context).push(
        MaterialPageRoute(builder: (context) => const ChooseRoleScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: LocalizationController(),
        child: Consumer<LocalizationController>(
          builder: (_, localeController, __) => Stack(
            alignment: Alignment.center,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  foregroundDecoration: const BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment(-0.8, 0.8),
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
                                      "Food Bridge",
                                      style: StyleManagement.titleTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FormBuilderTextField(
                                      name: 'email',
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        labelText: 'Email',
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
                                    ChangeNotifierProvider.value(
                                      value: PasswordTextfieldController(),
                                      child:
                                          Consumer<PasswordTextfieldController>(
                                        builder: (_, controller, __) =>
                                            FormBuilderTextField(
                                          name: 'password',
                                          onSubmitted: (value) =>
                                              login(context),
                                          obscureText: !controller.visible,
                                          decoration: InputDecoration(
                                            labelText:
                                                localeController.getTranslate(
                                                    'password-textfield-title'),
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () => login(context),
                                      style:
                                          StyleManagement.elevatedButtonStyle,
                                      child: Text(
                                        localeController
                                            .getTranslate('login-button-title'),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          style:
                                              StyleManagement.textButtonStyle,
                                          onPressed: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen(),
                                            ),
                                          ),
                                          child: Text(
                                              localeController.getTranslate(
                                                  'register-button-title')),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 31,
                                          child: TextButton(
                                            style:
                                                StyleManagement.textButtonStyle,
                                            onPressed: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPasswordScreen(),
                                              ),
                                            ),
                                            child: Text(
                                                localeController.getTranslate(
                                                    'forgot-password-button-title')),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Expanded(
                                            child: Divider(
                                              thickness: 2,
                                              endIndent: 10,
                                            ),
                                          ),
                                          Text(localeController
                                              .getTranslate('or-title')),
                                          const Expanded(
                                              child: Divider(
                                            thickness: 2,
                                            indent: 10,
                                          )),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      icon: Image.asset(
                                        "assets/images/google.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      onPressed: () => loginGoogle(context),
                                      style: StyleManagement.elevatedButtonStyle
                                          .copyWith(
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Colors.white),
                                        overlayColor: MaterialStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(.55),
                                        ),
                                      ),
                                      label: Text(
                                        localeController.getTranslate(
                                            'login-with-google-button-title'),
                                        style:
                                            TextStyle(color: Colors.blue[800]),
                                      ),
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
