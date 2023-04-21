import 'package:flutter/material.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/view/login.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 15,
            ),
            Text(LocalizationController().getTranslate('loading-text'))
          ],
        ),
      ),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.done_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
      title:
          Text(LocalizationController().getTranslate('register-success-text')),
      content: Text(LocalizationController()
          .getTranslate('register-success-description')),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(LocalizationController().getTranslate('cancel-text')),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final err;

  const ErrorDialog(
    this.err, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.red,
        child: Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
      title: Text(LocalizationController().getTranslate('error-text')),
      content: Text("${err.code} - ${err.message}"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
