import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/model/designmanagement.dart';

class LoadingDialog extends StatelessWidget {
  final String message;
  const LoadingDialog({
    this.message = 'loading-text',
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
            Text(localeController.getTranslate(message))
          ],
        ),
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Color confirmColor;
  const ConfirmDialog(
    this.title,
    this.content, {
    this.confirmColor = ColorManagement.deleteColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(localeController.getTranslate(title)),
      content: Text(localeController.getTranslate(content)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          style: StyleManagement.textButtonStyle.copyWith(),
          child: Text(localeController.getTranslate('cancel-text')),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          style: StyleManagement.textButtonStyle,
          child: Text(
            localeController.getTranslate('confirm-button-title'),
            style: TextStyle(color: confirmColor),
          ),
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

class SuccessDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function callback;
  final bool showActions;
  const SuccessDialog(
    this.title,
    this.content,
    this.callback, {
    this.showActions = true,
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
      title: Text(localeController.getTranslate(title)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              localeController.getTranslate(content),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      actions: getActions(context),
    );
  }

  getActions(BuildContext context) {
    if (!showActions) {
      return null;
    }
    return [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: StyleManagement.textButtonStyle,
        child: Text(localeController.getTranslate('cancel-text')),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          callback();
        },
        style: StyleManagement.textButtonStyle,
        child: const Text("OK"),
      ),
    ];
  }
}

class ReviewDialog extends StatelessWidget {
  const ReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    localeController.getTranslate('rate-this-donation-title'),
                    style: StyleManagement.titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            RatingBar.builder(
              initialRating: reviewController.rating,
              itemCount: 5,
              allowHalfRating: true,
              glow: false,
              unratedColor:
                  ColorManagement.foodTypeCheckBoxCardIconUncheckColorDark,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              onRatingUpdate: (value) => reviewController.rating = value,
            ),
            TextField(
              controller: reviewController.controller,
              maxLines: 4,
              decoration: DecoratorManagement.defaultTextFieldDecoratorDark(
                  'write-a-review-text',
                  StyleManagement.addressTextStyle
                      .copyWith(color: ColorManagement.hintTextColorDark)),
              maxLength: 1000,
              style: StyleManagement.settingsItemTextStyle.copyWith(
                color: ColorManagement.reviewTextColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: StyleManagement.textButtonStyle.copyWith(),
                  child: Text(localeController.getTranslate('cancel-text')),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: StyleManagement.textButtonStyle,
                  child: Text(
                      localeController.getTranslate('confirm-button-title')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
