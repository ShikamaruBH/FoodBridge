import 'package:flutter/material.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';

class ColorManagement {
  static final titleColorDark = Colors.black.withOpacity(0.71);
  static final iconColor = Colors.black.withOpacity(0.85);
  static final descriptionColorDark = Colors.black.withOpacity(0.55);
  static final descriptionColorLight = Colors.white.withOpacity(0.55);
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
  static final descriptionTextStyleLight = TextStyle(
    color: ColorManagement.descriptionColorLight,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static final textButtonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.all(5),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: const Color(0xff489FB5).withOpacity(0.71));
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

  static getLanguageButtonStyle(locale) =>
      LocalizationController().locale == locale
          ? textButtonLanguageStyle
          : textButtonLanguageInactiveStyle;

  static getIcon(IconData icon) => Icon(
        icon,
        size: 32,
        color: ColorManagement.iconColor,
      );
}
