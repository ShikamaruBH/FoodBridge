import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/foodtypecheckboxcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/mapcontroller.dart';
import 'package:food_bridge/model/customvalidators.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/screens/home.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewDonationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  NewDonationScreen({super.key});

  void newDonation(context) async {
    _formKey.currentState!.save();

    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = _formKey.currentState!.value;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const LoadingDialog(),
      );
      Map<String, dynamic> data = {
        "latlng": MapController().getLatLng(),
        'note': formData['note']?.trim() ?? "",
        'foodCategory': List.from(FoodTypeCheckBoxController().checked.keys),
        'title': formData['title'].trim(),
        'quantity': formData['quantity'].trim(),
        'unit': formData['unit'].trim(),
        'start': formData['start'].toIso8601String(),
        'end': formData['end'].toIso8601String(),
      };
      await DonationController().createDonation(data).then((result) {
        Navigator.pop(context);
        if (result['success']) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => SuccessDialog(
              'new-donation-success-text',
              'new-donation-success-description',
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              ),
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
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ChangeNotifierProvider.value(
        value: LocalizationController(),
        child: Consumer<LocalizationController>(
          builder: (_, localeController, __) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              title: Text(localeController.getTranslate('new-donation-title')),
            ),
            body: Container(
              width: constraints.maxWidth,
              // height: constraints.maxHeight,
              color: Theme.of(context).colorScheme.primary,
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: ChangeNotifierProvider.value(
                        value: MapController(),
                        child: Consumer<MapController>(
                          builder: (_, mapController, __) => TextFormField(
                            readOnly: true,
                            controller:
                                mapController.addressTextFieldController,
                            style: StyleManagement.addressTextStyle,
                            decoration:
                                DecoratorManagement.addressTextFieldDecorator(
                              'address-hint-text',
                              Icon(
                                Icons.location_on_sharp,
                                color: ColorManagement.descriptionColorDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const CustomSpacerWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: FormBuilderTextField(
                        name: 'note',
                        style: StyleManagement.addressTextStyle,
                        decoration:
                            DecoratorManagement.addressTextFieldDecorator(
                          'pickup-instruction-text',
                          null,
                        ),
                      ),
                    ),
                    const CustomSpacerWidget(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(13),
                              topRight: Radius.circular(13),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 10,
                            ),
                            child: Column(
                              children: [
                                const FieldTitleWidget('food-type-title'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FoodTypeCheckBoxWidget(
                                        'food-type-grocery',
                                        Icons.local_grocery_store_rounded,
                                      ),
                                      FoodTypeCheckBoxWidget(
                                        'food-type-cooked',
                                        Icons.ramen_dining_rounded,
                                      ),
                                      FoodTypeCheckBoxWidget(
                                        'food-type-fruits',
                                        Icons.apple_rounded,
                                      ),
                                      FoodTypeCheckBoxWidget(
                                        'food-type-beverage',
                                        Icons.emoji_food_beverage_rounded,
                                      ),
                                    ],
                                  ),
                                ),
                                const FieldTitleWidget('food-title-title'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: FormBuilderTextField(
                                    name: 'title',
                                    style: StyleManagement.textFieldTextStyle,
                                    decoration: DecoratorManagement
                                        .defaultTextFieldDecorator,
                                    validator: CustomValidator.required,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const FieldTitleWidget(
                                              'food-quantity-title'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: FormBuilderTextField(
                                              name: 'quantity',
                                              style: StyleManagement
                                                  .textFieldTextStyle,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: DecoratorManagement
                                                  .defaultTextFieldDecorator,
                                              validator: FormBuilderValidators
                                                  .compose([
                                                CustomValidator.required,
                                                CustomValidator.numberic,
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const FieldTitleWidget(
                                              'food-unit-title'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: FormBuilderTextField(
                                                name: 'unit',
                                                style: StyleManagement
                                                    .textFieldTextStyle,
                                                decoration: DecoratorManagement
                                                    .defaultTextFieldDecorator,
                                                validator:
                                                    CustomValidator.required,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const FieldTitleWidget(
                                              'food-start-date-title'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: FormBuilderDateTimePicker(
                                              name: 'start',
                                              format: DateFormat(
                                                  'MMM d, yyyy hh:mm a'),
                                              style: StyleManagement
                                                  .textFieldTextStyle,
                                              currentDate: DateTime.now(),
                                              decoration: DecoratorManagement
                                                  .defaultTextFieldDecorator,
                                              validator:
                                                  CustomValidator.required,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const FieldTitleWidget(
                                              'food-end-date-title'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: FormBuilderDateTimePicker(
                                              name: 'end',
                                              format: DateFormat(
                                                  'MMM d, yyyy hh:mm a'),
                                              style: StyleManagement
                                                  .textFieldTextStyle,
                                              currentDate: DateTime.now(),
                                              decoration: DecoratorManagement
                                                  .defaultTextFieldDecorator,
                                              validator:
                                                  CustomValidator.required,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const FieldTitleWidget('food-photo-title'),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ChangeNotifierProvider.value(
                                          value: DonationController(),
                                          child: Consumer<DonationController>(
                                            builder:
                                                (_, donationController, __) =>
                                                    ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: donationController
                                                      .images.length +
                                                  1,
                                              itemBuilder: (context, index) =>
                                                  Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                  child: index == 0
                                                      ? NewImageButton()
                                                      : ImageListTileWidget(
                                                          index - 1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ElevatedButton(
                                    onPressed: () => newDonation(context),
                                    style: StyleManagement.elevatedButtonStyle
                                        .copyWith(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      elevation:
                                          const MaterialStatePropertyAll(4),
                                    ),
                                    child: Text(
                                      localeController
                                          .getTranslate('confirm-button-title'),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageListTileWidget extends StatelessWidget {
  final int index;
  final donationController = DonationController();
  ImageListTileWidget(
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Image.file(
            File(donationController.images[index].path),
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 5,
              right: 5,
              child: InkWell(
                onTap: () {
                  donationController.removeImage(index);
                },
                splashColor: Theme.of(context).colorScheme.primary,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class NewImageButton extends StatelessWidget {
  final ImagePicker picker = ImagePicker();
  final donationController = DonationController();
  static const int maxImg = 5;
  NewImageButton({
    super.key,
  });

  void pickImage() async {
    if (donationController.images.length >= maxImg) {
      Fluttertoast.showToast(
        msg:
            "${localeController.getTranslate('max-number-of-image-notification')} $maxImg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    donationController.addImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () => pickImage(),
      child: Container(
        width: 90,
        color: ColorManagement.foodTypeCheckBoxCardBackgroundUncheck,
        child: Icon(
          Icons.add_rounded,
          size: 40,
          color: ColorManagement.descriptionColorDark,
        ),
      ),
    );
  }
}

class FoodTypeCheckBoxWidget extends StatelessWidget {
  final String type;
  final IconData icon;
  final localeController = LocalizationController();

  FoodTypeCheckBoxWidget(
    this.type,
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: FoodTypeCheckBoxController(),
      child: Consumer<FoodTypeCheckBoxController>(
        builder: (_, checkBoxController, __) => Column(
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              color: checkBoxController.status(type)
                  ? ColorManagement.foodTypeCheckBoxCardBackgroundChecked
                  : ColorManagement.foodTypeCheckBoxCardBackgroundUncheck,
              child: InkWell(
                onTap: () => checkBoxController.check(type),
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: Icon(
                    icon,
                    size: 48,
                    color: checkBoxController.status(type)
                        ? Colors.white
                        : ColorManagement.foodTypeCheckBoxCardIconUncheckColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                localeController.getTranslate(type),
                style: StyleManagement.newDonationFieldTitleTextStyle.copyWith(
                  color: Colors.black
                      .withOpacity(checkBoxController.status(type) ? .76 : .24),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FieldTitleWidget extends StatelessWidget {
  final String title;
  const FieldTitleWidget(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          localeController.getTranslate(title),
          style: StyleManagement.newDonationFieldTitleTextStyle,
        )
      ],
    );
  }
}
