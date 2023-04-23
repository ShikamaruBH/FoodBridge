import 'package:flutter/material.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';

class ColorManagement {
  static final titleColorDark = Colors.black.withOpacity(0.71);
  static final descriptionColorDark = Colors.black.withOpacity(0.55);
  static final descriptionColorLight = Colors.white.withOpacity(0.55);
  static const selectedColor = Color(0xffFFA62B);
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
  static final descriptionTextStyleDark = TextStyle(
    color: ColorManagement.descriptionColorDark,
    fontSize: 18,
    fontWeight: FontWeight.w500,
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
}
