import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/customvalidators.dart';
import 'package:food_bridge/model/dayhourminute.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/loadinghandler.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:timer_count_down/timer_count_down.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  const LoadingDialog({
    this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
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
            Text(localeController.getTranslate(message ?? 'loading-text'))
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: Text(localeController.getTranslate(title)),
      content: Text(localeController.getTranslate(content)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          style: StyleManagement.textButtonStyle,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
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
                  style: StyleManagement.textButtonStyle,
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

class UpdateUserDetailDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final String title;
  final List<String? Function(String?)> validators;
  final String value;
  UpdateUserDetailDialog(this.title, this.value, this.validators, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    localeController.getTranslate(title),
                    style: StyleManagement.settingsLabelTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const VSpacer(),
            FormBuilder(
              key: _formKey,
              child: FormBuilderTextField(
                name: 'value',
                initialValue: value,
                textAlign: TextAlign.center,
                decoration:
                    DecoratorManagement.defaultTextFieldDecoratorDark("", null),
                validator: FormBuilderValidators.compose(validators),
              ),
            ),
            const VSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, {'status': false});
                  },
                  style: StyleManagement.textButtonStyle,
                  child: Text(localeController.getTranslate('cancel-text')),
                ),
                TextButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> data = _formKey.currentState!.value;
                      Navigator.pop(context, {
                        "status": true,
                        'value': data['value'].trim(),
                      });
                    }
                  },
                  style: StyleManagement.textButtonStyle,
                  child:
                      Text(localeController.getTranslate('save-button-title')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserFeedbackDialog extends StatelessWidget {
  const UserFeedbackDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.green,
                  width: 100,
                  height: 100,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ReceiveDonationDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final DateTime end;
  final DateTime start;
  final int maxQuantity;
  ReceiveDonationDialog(this.start, this.end, this.maxQuantity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      localeController.getTranslate("receive-donation-text"),
                      style: StyleManagement.settingsLabelTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const VSpacer(),
              FormBuilderTextField(
                name: 'quantity',
                decoration: DecoratorManagement.defaultTextFieldDecoratorDark(
                  'food-quantity-title',
                  null,
                ),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose(
                  [
                    CustomValidator.required,
                    CustomValidator.numberic,
                    (value) {
                      final quantity = int.tryParse(value!);
                      if (quantity == null || quantity > maxQuantity) {
                        return localeController
                            .getTranslate("invalid-donation-quantity-text");
                      }
                      return null;
                    }
                  ],
                ),
              ),
              const VSpacer(),
              FormBuilderDateTimePicker(
                name: "arriveTime",
                initialDate: DateTime.now(),
                initialTime: TimeOfDay.now(),
                firstDate: DateTime.now(),
                lastDate: end,
                decoration: DecoratorManagement.defaultTextFieldDecoratorDark(
                  'arrive-time-title',
                  null,
                ).copyWith(
                  prefixIcon: const Icon(Icons.calendar_month),
                ),
                validator: FormBuilderValidators.compose([
                  CustomValidator.required,
                  (DateTime? value) {
                    if (value!.isAfter(end)) {
                      return localeController
                          .getTranslate("invalid-receive-time-after-end-text");
                    }
                    if (DateTime.now().isBefore(start)) {
                      return localeController.getTranslate(
                          "invalid-receive-time-before-start-text");
                    }
                    return null;
                  }
                ]),
              ),
              const VSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        {"success": false},
                      );
                    },
                    style: StyleManagement.textButtonStyle,
                    child: Text(
                      localeController.getTranslate('cancel-text'),
                      style:
                          const TextStyle(color: ColorManagement.deleteColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () => checkData(context),
                    style: StyleManagement.textButtonStyle,
                    child: Text(
                      localeController.getTranslate('confirm-button-title'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void checkData(context) {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = _formKey.currentState!.value;
      Navigator.pop(context, {"success": true, "data": data});
    }
  }
}

class TimerDialog extends StatelessWidget {
  final Duration duration;
  const TimerDialog(this.duration, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      localeController
                          .getTranslate("receive-time-remaining-text"),
                      style: StyleManagement.statsTextStyle
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const VSpacer(),
              ...getTimerWidget(context, duration),
              const VSpacer(),
            ],
          ),
        ),
      ),
    );
  }

  getTimerWidget(context, Duration duration) {
    if (duration.isNegative) {
      return [
        Row(
          children: [
            Flexible(
              child: Text(
                localeController.getTranslate("timeout-description-text"),
                style: StyleManagement.donationDetailTextStyle
                    .copyWith(color: ColorManagement.deleteColor),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ];
    }
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                localeController
                    .getTranslate("receive-donation-timer-description-text"),
                style: StyleManagement.donationDetailTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      const VSpacer(),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Countdown(
            seconds: duration.inSeconds,
            interval: const Duration(seconds: 1),
            onFinished: Navigator.of(context).pop,
            build: (_, seconds) => Text(
              getTime(seconds),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    ];
  }
}

class ConfirmReceiveDonationDialog extends StatelessWidget {
  final String? title;
  final String? donationId;
  final String? recipientUid;
  final DateTime deadline;
  const ConfirmReceiveDonationDialog(
    this.deadline, {
    this.title,
    this.donationId,
    this.recipientUid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      getDialogTitle(),
                      style: StyleManagement.statsTextStyle
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const VSpacer(),
              if (title != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: StyleManagement.donationDetailTextStyle,
                          children: [
                            TextSpan(
                                text: localeController.getTranslate(
                                    'confirm-received-donation-description')),
                            const TextSpan(
                              text: ' ',
                            ),
                            TextSpan(
                              text: title,
                              style: StyleManagement.donationDetailTextStyle
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const VSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: constraints.maxWidth / 3,
                      height: constraints.maxWidth / 3,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Countdown(
                            seconds:
                                deadline.difference(DateTime.now()).inSeconds,
                            interval: const Duration(seconds: 1),
                            onFinished: () async {
                              Navigator.of(navigatorKey.currentState!.context)
                                  .pop({"success": false});
                            },
                            build: (_, seconds) => Text(
                              seconds.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const VSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop({"success": false}),
                      style: StyleManagement.elevatedButtonStyle.copyWith(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.secondary),
                        elevation: const MaterialStatePropertyAll(4),
                      ),
                      child: Text(
                        localeController.getTranslate('cancel-text'),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  if (title != null) ...[
                    HSpacer(),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop({"success": true});
                          confirmReceived(donationId, recipientUid);
                        },
                        style: StyleManagement.elevatedButtonStyle.copyWith(
                          backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.secondary),
                          elevation: const MaterialStatePropertyAll(4),
                        ),
                        child: Text(
                          localeController.getTranslate('confirm-button-title'),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              const VSpacer(),
            ],
          ),
        ),
      ),
    );
  }

  getDialogTitle() {
    if (title == null) {
      return localeController
          .getTranslate('waiting-for-recipient-confirm-text');
    }
    return localeController.getTranslate('confirm-received-donation-text');
  }

  Future<bool> confirmReceived(donationId, recipientUid) async {
    return loadingHandler(
      () => donationController.confirmReceived({
        "donationId": donationId,
        "recipientUid": recipientUid,
      }),
      (_) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'confirm-recipient-success-text',
            'confirm-recipient-success-description',
            () {},
            showActions: false,
          ),
        );
      },
      loadingText: 'updating-text',
      autoClose: true,
    );
  }
}

class ReceiveDonationFailedDialog extends StatelessWidget {
  const ReceiveDonationFailedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      localeController.getTranslate('receive-failed-text'),
                      style: StyleManagement.statsTextStyle
                          .copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const VSpacer(),
              Center(
                child: ClipOval(
                  child: Container(
                    color: Colors.yellow,
                    width: constraints.maxWidth / 3,
                    height: constraints.maxWidth / 3,
                    child: Icon(
                      Icons.timer_off,
                      color: Colors.black,
                      size: constraints.maxWidth / 4,
                    ),
                  ),
                ),
              ),
              const VSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      localeController
                          .getTranslate("receive-failed-description"),
                      style: StyleManagement.donationDetailTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              const VSpacer(),
            ],
          ),
        ),
      ),
    );
  }
}
