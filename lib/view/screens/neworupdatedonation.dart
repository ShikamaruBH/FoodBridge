import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/controller/widget_controller/datetimepickercontroller.dart';
import 'package:food_bridge/controller/widget_controller/foodtypecheckboxcontroller.dart';
import 'package:food_bridge/controller/widget_controller/limitcontroller.dart';
import 'package:food_bridge/controller/widget_controller/mapcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/customvalidators.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/donation.dart';
import 'package:food_bridge/model/loadinghandler.dart';
import 'package:food_bridge/view/screens/chooselocation.dart';
import 'package:food_bridge/view/screens/home.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/widgets/donationdatetimepicker.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewOrUpdateDonationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final Donation? donation;
  NewOrUpdateDonationScreen(this.donation, {super.key});

  void newDonation() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = _formKey.currentState!.value;
      Map<String, dynamic> data = {
        "latlng": mapController.getLatLng(),
        'note': formData['note']?.trim() ?? "",
        'categories': foodCategoryController.getChecked(),
        'title': formData['title'].trim(),
        'quantity': num.parse(formData['quantity'].trim()),
        'maxQuantityPerRecipient': formData['noLimit'] == true ? num.parse(formData['quantity'].trim()) : num.parse(formData['maxQuantityPerRecipient'].trim()),
        'noLimit': formData['noLimit'],
        'unit': formData['unit'].trim(),
        'start': formData['start'].toUtc().toIso8601String(),
        'end': formData['end'].toUtc().toIso8601String(),
      };
      debugPrint("Data: $data");
      loadingHandler(
        () => donationController.createDonation(data),
        (_) => showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'new-donation-success-text',
            'new-donation-success-description',
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            ),
          ),
        ),
        loadingText: 'creating-donation-text',
      );
    }
  }

  void updateDonation() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = _formKey.currentState!.value;
      Map<String, dynamic> data = {
        'id': donation!.id,
        "latlng": mapController.getLatLng(),
        'note': formData['note']?.trim() ?? "",
        'categories': foodCategoryController.getChecked(),
        'title': formData['title'].trim(),
        'quantity': num.parse(formData['quantity'].trim()),
        'maxQuantityPerRecipient': formData['noLimit'] == true ? num.parse(formData['quantity'].trim()) : num.parse(formData['maxQuantityPerRecipient'].trim()),
        'noLimit': formData['noLimit'],
        'unit': formData['unit'].trim(),
        'start': formData['start'].toUtc().toIso8601String(),
        'end': formData['end'].toUtc().toIso8601String(),
      };
      loadingHandler(
        () => donationController.updateDonation(data),
        (_) => showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'update-donation-success-text',
            'new-donation-success-description',
            () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false),
          ),
        ),
        loadingText: 'updating-donation-text',
      );
    }
  }

  void deleteDonation(String id) async {
    bool result = await showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const ConfirmDialog(
        'delete-donation-confirm-title',
        'delete-donation-confirm-content',
      ),
    );
    if (!result) {
      return;
    }
    loadingHandler(
      () => donationController.softDeleteDonation({"id": id}),
      (_) {
        Navigator.of(navigatorKey.currentState!.context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'delete-donation-success-text',
            'delete-donation-success-description',
            () {},
            showActions: false,
          ),
        );
      },
      loadingText: 'deleting-text',
      autoClose: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ChangeNotifierProvider.value(
        value: localeController,
        child: Consumer<LocalizationController>(
          builder: (_, ___, __) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              title: Text(
                localeController.getTranslate(
                  donation != null ? 'edit-donation-title' : 'new-donation-title',
                ),
              ),
            ),
            body: Container(
              width: constraints.maxWidth,
              color: Theme.of(context).colorScheme.primary,
              child: FormBuilder(
                key: _formKey,
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: ChangeNotifierProvider.value(
                              value: mapController,
                              child: Consumer<MapController>(
                                builder: (_, ___, __) => TextFormField(
                                  readOnly: true,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChooseLocationScreen(false),
                                    ),
                                  ),
                                  controller: mapController.addressTextFieldController,
                                  style: StyleManagement.addressTextStyle,
                                  decoration: DecoratorManagement.addressTextFieldDecorator(
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
                          const VSpacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: FormBuilderTextField(
                              name: 'note',
                              initialValue: donation?.note ?? "",
                              style: StyleManagement.addressTextStyle,
                              decoration: DecoratorManagement.addressTextFieldDecorator(
                                'pickup-instruction-text',
                                null,
                              ),
                            ),
                          ),
                          const VSpacer(),
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
                                      Column(
                                        children: [
                                          const FieldTitleWidget('food-type-title'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: const [
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
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: FormBuilderTextField(
                                              name: 'title',
                                              initialValue: donation?.title ?? "",
                                              style: StyleManagement.textFieldTextStyleDark,
                                              decoration: DecoratorManagement.defaultTextFieldDecoratorDark(
                                                "",
                                                null,
                                              ),
                                              validator: CustomValidator.required,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    const FieldTitleWidget('food-quantity-title'),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      child: FormBuilderTextField(
                                                        name: 'quantity',
                                                        initialValue: donation?.quantity.toString() ?? "",
                                                        style: StyleManagement.textFieldTextStyleDark,
                                                        keyboardType: TextInputType.number,
                                                        decoration: DecoratorManagement.defaultTextFieldDecoratorDark("", null),
                                                        validator: FormBuilderValidators.compose([
                                                          CustomValidator.required,
                                                          CustomValidator.numberic,
                                                          CustomValidator.positive,
                                                        ]),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              HSpacer(),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    const FieldTitleWidget('food-unit-title'),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                                        child: FormBuilderTextField(
                                                          name: 'unit',
                                                          initialValue: donation?.unit ?? "",
                                                          style: StyleManagement.textFieldTextStyleDark,
                                                          decoration: DecoratorManagement.defaultTextFieldDecoratorDark("", null),
                                                          validator: CustomValidator.required,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const FieldTitleWidget('max-quantity-per-recipient-title'),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ChangeNotifierProvider.value(
                                                  value: limitController,
                                                  child: Consumer<LimitController>(
                                                    builder: (_, __, ___) => FormBuilderTextField(
                                                      name: 'maxQuantityPerRecipient',
                                                      initialValue: getQuantityLimit(),
                                                      readOnly: !limitController.isLimited,
                                                      style: StyleManagement.textFieldTextStyleDark,
                                                      keyboardType: TextInputType.number,
                                                      decoration: DecoratorManagement.defaultTextFieldDecoratorDark("", null),
                                                      validator: FormBuilderValidators.compose([
                                                        CustomValidator.required,
                                                        limitController.isLimited ? CustomValidator.numberic : (_) => null,
                                                        limitController.isLimited ? CustomValidator.positive : (_) => null,
                                                        (value) {
                                                          if (limitController.isLimited == false) {
                                                            return null;
                                                          }
                                                          final quantityStr = _formKey.currentState!.getRawValue("quantity");
                                                          final quantity = num.tryParse(quantityStr) ?? -1;
                                                          final limit = num.tryParse(value ?? "0") ?? 0;
                                                          if (limit <= quantity) {
                                                            return null;
                                                          }
                                                          return localeController.getTranslate("limit-invalid-text");
                                                        }
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              HSpacer(),
                                              Expanded(
                                                child: FormBuilderCheckbox(
                                                  name: 'noLimit',
                                                  decoration: const InputDecoration(
                                                    contentPadding: EdgeInsets.zero,
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                  ),
                                                  contentPadding: EdgeInsets.zero,
                                                  initialValue: donation != null ? donation?.noLimit : !limitController.isLimited,
                                                  onChanged: (value) {
                                                    _formKey.currentState!.patchValue(
                                                        {"maxQuantityPerRecipient": value == true ? localeController.getTranslate('unlimited-text') : "0"});
                                                    limitController.setLimit(value);
                                                  },
                                                  title: Text(
                                                    localeController.getTranslate('no-limit-title'),
                                                    style: StyleManagement.newDonationFieldTitleTextStyle,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          ChangeNotifierProvider.value(
                                            value: dateTimePickerController,
                                            child: Consumer<DatetimePickerController>(
                                              builder: (_, ___, __) => Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        const FieldTitleWidget('food-start-date-title'),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                                          child: DonationDatetimePicker(
                                                            'start',
                                                            dateTimePickerController.setStart,
                                                            dateTimePickerController.start,
                                                            firstDate: DateTime.now(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  HSpacer(),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        const FieldTitleWidget('food-end-date-title'),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                                          child: DonationDatetimePicker(
                                                            'end',
                                                            dateTimePickerController.setEnd,
                                                            dateTimePickerController.start,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const FieldTitleWidget('food-photo-title'),
                                          const VSpacer(),
                                          Row(
                                            children: [
                                              ChangeNotifierProvider.value(
                                                value: donationController,
                                                child: Consumer<DonationController>(
                                                  builder: (_, ___, __) => SizedBox(
                                                    width: constraints.maxWidth * .85,
                                                    height: 100,
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: donationController.images.length + donationController.urls.length + 1,
                                                      itemBuilder: (context, index) => Padding(
                                                        padding: const EdgeInsets.only(right: 5),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(9),
                                                          child: getListTile(index),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: getBottomBar(donation),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  StatelessWidget getListTile(int index) {
    if (index == 0) return const NewImageButton();
    index -= 1;
    if (index < donationController.images.length) {
      return ImageListTileWidget(
        index,
        Image.file(
          File(donationController.images[index].path),
          fit: BoxFit.cover,
        ),
        donationController.removeImage,
      );
    }
    index -= donationController.images.length;
    return ImageListTileWidget(
      index,
      FutureBuilder(
        future: donationController.getUrl(donation!.donor, donationController.urls[index]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          }
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        },
      ),
      donationController.removeUrl,
    );
  }

  getBottomBar(Donation? donation) {
    if (donation == null) {
      return ElevatedButton(
        onPressed: () => newDonation(),
        style: StyleManagement.elevatedButtonStyle.copyWith(
          backgroundColor: MaterialStatePropertyAll(Theme.of(navigatorKey.currentState!.context).colorScheme.secondary),
          elevation: const MaterialStatePropertyAll(4),
        ),
        child: Text(
          localeController.getTranslate('confirm-button-title'),
          style: const TextStyle(fontSize: 20),
        ),
      );
    }
    return Row(
      children: [
        Flexible(
          child: ElevatedButton(
            onPressed: () => updateDonation(),
            style: StyleManagement.elevatedButtonStyle
                .copyWith(backgroundColor: MaterialStatePropertyAll(Theme.of(navigatorKey.currentState!.context).colorScheme.secondary)),
            child: Text(
              localeController.getTranslate('confirm-button-title'),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        HSpacer(),
        Card(
          elevation: 5,
          color: ColorManagement.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () => deleteDonation(donation.id),
            borderRadius: BorderRadius.circular(10),
            splashColor: ColorManagement.deleteColor.withOpacity(.5),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.delete_forever_rounded,
                color: ColorManagement.deleteColor,
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  getQuantityLimit() {
    if (donation != null) {
      return donation!.noLimit ? localeController.getTranslate('unlimited-text') : donation!.maxQuantityPerRecipient.toString();
    }
    return "";
  }
}

class ImageListTileWidget extends StatelessWidget {
  final int index;
  final Widget image;
  final Function callback;
  const ImageListTileWidget(
    this.index,
    this.image,
    this.callback, {
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
          image,
          Positioned(
              top: 5,
              right: 5,
              child: InkWell(
                onTap: () => callback(index),
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
  const NewImageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () => showImageSourceBottomSheet(context),
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

  Future<dynamic> showImageSourceBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localeController.getTranslate('choose-image-text'),
                      style: StyleManagement.usernameTextStyle.copyWith(color: Colors.black.withOpacity(.8)),
                    )
                  ],
                ),
                Row(
                  children: [
                    ImageSourceButton(Icons.camera_alt_rounded, "Camera", ImageSource.camera),
                    ImageSourceButton(Icons.image_rounded, "gallery-text", ImageSource.gallery),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final ImageSource source;
  final ImagePicker picker = ImagePicker();
  static const int maxImg = 5;
  ImageSourceButton(
    this.icon,
    this.text,
    this.source, {
    super.key,
  });

  void pickImage(ImageSource source) async {
    if (donationController.images.length + donationController.urls.length >= maxImg) {
      Fluttertoast.showToast(
        msg: "${localeController.getTranslate('max-number-of-image-notification')} $maxImg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    XFile? image = await picker.pickImage(source: source);
    if (image == null) return;
    donationController.addImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              pickImage(source);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Icon(
                  icon,
                  color: ColorManagement.iconColor,
                  size: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localeController.getTranslate(text),
                      style: StyleManagement.newDonationFieldTitleTextStyle,
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

class FoodTypeCheckBoxWidget extends StatelessWidget {
  final String type;
  final IconData icon;

  const FoodTypeCheckBoxWidget(
    this.type,
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: foodCategoryController,
      child: Consumer<FoodCategoryCheckBoxController>(
        builder: (_, ___, __) => Column(
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              color: foodCategoryController.status(type)
                  ? ColorManagement.foodTypeCheckBoxCardBackgroundChecked
                  : ColorManagement.foodTypeCheckBoxCardBackgroundUncheck,
              child: InkWell(
                onTap: () => foodCategoryController.check(type),
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: Icon(
                    icon,
                    size: 48,
                    color: foodCategoryController.status(type) ? Colors.white : ColorManagement.foodTypeCheckBoxCardIconUncheckColorDark,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                localeController.getTranslate(type),
                style: StyleManagement.newDonationFieldTitleTextStyle.copyWith(
                  color: Colors.black.withOpacity(foodCategoryController.status(type) ? .76 : .24),
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
