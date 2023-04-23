import 'package:flutter/material.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/view/roleselectbutton.dart';

class SelectRoleColumn extends StatelessWidget {
  final LocalizationController localeController;
  final String imgPath;
  final String title;
  final String desc;
  final String role;
  final bool mirror;

  const SelectRoleColumn(
    this.imgPath,
    this.role,
    this.title,
    this.desc,
    this.localeController,
    this.mirror, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RoleSelectButton(imgPath, role, mirror),
          const SizedBox(
            height: 5,
          ),
          Text(
            localeController.getTranslate(title),
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            localeController.getTranslate(desc),
            textAlign: TextAlign.center,
            style: StyleManagement.descriptionTextStyleLight,
          ),
        ],
      ),
    );
  }
}
