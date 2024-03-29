import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/model/designmanagement.dart';

class LaguageSwitchWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  LaguageSwitchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
            style: StyleManagement.getLanguageButtonStyle('vi'),
            onPressed: () {
              localeController.setLocale('vi');
            },
            child: const Text("VI")),
        const VerticalDivider(
          thickness: 2,
          width: 1,
          color: Colors.white,
        ),
        TextButton(
            style: StyleManagement.getLanguageButtonStyle('en').copyWith(
              shape: const MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
              ),
            ),
            onPressed: () {
              localeController.setLocale('en');
            },
            child: const Text("EN")),
      ],
    );
  }
}
