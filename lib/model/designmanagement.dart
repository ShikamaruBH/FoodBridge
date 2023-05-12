import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';

class ColorManagement {
  static final titleColorDark = Colors.black.withOpacity(0.71);
  static const deleteColor = Color(0xffD60F0F);
  static final iconColor = Colors.black.withOpacity(0.85);
  static final reviewTextColor = Colors.black.withOpacity(.75);
  static final descriptionColorDark = Colors.black.withOpacity(0.55);
  static final hintTextColorDark = Colors.black.withOpacity(.3);
  static final descriptionColorLight = Colors.white.withOpacity(0.55);
  static final titleColorLight = Colors.white.withOpacity(0.96);
  static final foodTypeCheckBoxCardBackgroundUncheck =
      const Color(0xffD9D9D9).withOpacity(.6);
  static const foodTypeCheckBoxCardBackgroundChecked = Color(0xff489FB5);
  static final foodTypeCheckBoxCardIconUncheckColorDark =
      Colors.black.withOpacity(.1);
  static final foodTypeCheckBoxCardIconUncheckColorLight =
      Colors.white.withOpacity(.34);
  static const cardColor = Color(0xffe6e6e6);
  static const selectedColor = Color(0xffFFA62B);
  static const donationTileColor = Color(0xffF5F5F5);
  static const notificationUnread = Color(0xffEAEAEA);
  static const materialStateWhite = MaterialStatePropertyAll(Colors.white);
  static final materialStateWhiteInactive =
      MaterialStatePropertyAll(Colors.white.withOpacity(0.2));
}

class StyleManagement {
  static final titleTextStyle = TextStyle(
    color: ColorManagement.titleColorDark,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  static const monthlyDescriptionTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
  static const usernameTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  static final settingsLabelTextStyle = TextStyle(
    color: Colors.black.withOpacity(.9),
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static final descriptionTextStyleDark = TextStyle(
    color: ColorManagement.descriptionColorDark,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const quantityTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const historyItemTitleTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );
  static const regularTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );
  static final menuTextStyle = TextStyle(
    color: Colors.black.withOpacity(.81),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static final settingsItemTextStyle = TextStyle(
    color: Colors.black.withOpacity(.85),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final addressTextStyle = TextStyle(
    color: Colors.black.withOpacity(.85),
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static final historyItemCategoryTextStyle = TextStyle(
    color: Colors.black.withOpacity(.46),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static final notificationTitleMedium = TextStyle(
    color: Colors.black.withOpacity(.78),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const notificationTitleBold = TextStyle(
    color: Color(0xff489FB5),
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static final newDonationFieldTitleTextStyle = TextStyle(
    color: Colors.black.withOpacity(.5),
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
  static final descriptionTextStyleLight = TextStyle(
    color: ColorManagement.descriptionColorLight,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static final textFieldTextStyleDark = TextStyle(
    color: ColorManagement.titleColorDark,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static final textFieldTextStyleLight = TextStyle(
    color: ColorManagement.titleColorLight,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static final textButtonStyle = TextButton.styleFrom(
    padding: const EdgeInsets.all(5),
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    foregroundColor: const Color(0xff489FB5).withOpacity(0.71),
  );

  static final textButtonLanguageStyle = textButtonStyle.copyWith(
    backgroundColor: const MaterialStatePropertyAll(Color(0xff16697A)),
    foregroundColor: ColorManagement.materialStateWhite,
    shape: const MaterialStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
      ),
    ),
  );

  static final textButtonLanguageInactiveStyle =
      textButtonLanguageStyle.copyWith(
    foregroundColor: ColorManagement.materialStateWhiteInactive,
    backgroundColor: MaterialStatePropertyAll(
      const Color(0xff16697A).withOpacity(0.3),
    ),
  );

  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    minimumSize: const Size(double.infinity, 50),
  );

  static getLanguageButtonStyle(locale) => localeController.locale == locale
      ? textButtonLanguageStyle
      : textButtonLanguageInactiveStyle;

  static getIcon(IconData icon) => Icon(
        icon,
        size: 32,
        color: ColorManagement.iconColor,
      );
}

class DecoratorManagement {
  static defaultTextFieldDecoratorDark(String hint, hintStyle) =>
      InputDecoration(
        isDense: true,
        hintStyle: hintStyle,
        errorMaxLines: 2,
        hintText: localeController.getTranslate(hint),
        contentPadding: const EdgeInsets.all(11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 1,
          ),
        ),
      );
  static final defaultTextFieldDecoratorLight =
      defaultTextFieldDecoratorDark("", null).copyWith(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(width: 1, color: ColorManagement.titleColorLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(width: 1, color: ColorManagement.titleColorLight),
    ),
  );
  static addressTextFieldDecorator(String hint, prefixIcon) => InputDecoration(
        isDense: true,
        hintText: localeController.getTranslate(hint),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0),
          ),
        ),
        prefixIcon: prefixIcon,
        fillColor: Colors.white,
        filled: true,
        errorStyle: const TextStyle(color: Color(0xffFFA62B)),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffFFA62B)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      );
}
