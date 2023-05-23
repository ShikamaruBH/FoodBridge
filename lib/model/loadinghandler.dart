import 'package:flutter/material.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';

Future<bool> loadingHandler(
  asyncFunction,
  successCallback, {
  String? loadingText,
  bool autoClose = false,
  bool barrierDismissible = false,
  bool showLoadingDialog = true,
}) async {
  if (showLoadingDialog) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: navigatorKey.currentState!.context,
      builder: (context) => LoadingDialog(
        message: loadingText,
      ),
    );
  }
  await asyncFunction().then((result) async {
    if (showLoadingDialog) {
      Navigator.pop(navigatorKey.currentState!.context);
    }
    if (result['success']) {
      successCallback(result);
      if (autoClose) {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(navigatorKey.currentState!.context).pop();
      }
    } else {
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => ErrorDialog(result['err']),
      );
    }
    return true;
  }).catchError((err) {
    Navigator.pop(navigatorKey.currentState!.context);
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => ErrorDialog(err),
    );
    return true;
  });
  return false;
}
