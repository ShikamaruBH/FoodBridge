import 'package:flutter/material.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/model/designmanagement.dart';

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
  final String title;
  final String content;
  final Function callback;
  const SuccessDialog(
    this.title,
    this.content,
    this.callback, {
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
      title: Text(LocalizationController().getTranslate(title)),
      content: Text(LocalizationController().getTranslate(content)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: StyleManagement.textButtonStyle,
          child: Text(LocalizationController().getTranslate('cancel-text')),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            callback();
          },
          style: StyleManagement.textButtonStyle,
          child: const Text("OK"),
        ),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final err;
  final localeController = LocalizationController();

  ErrorDialog(
    this.err, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title, content;
    if (localeController.getTranslate(err.code).isNotEmpty) {
      title = localeController.getTranslate(err.code);
      content = localeController.getTranslate("${err.code}-description");
    } else {
      title = localeController.getTranslate('error-text');
      content = "${err.code} - ${err.message}";
    }

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
      title: Text(title),
      content: Text(content),
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
