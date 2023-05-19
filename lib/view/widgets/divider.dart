import 'package:flutter/material.dart';
import 'package:food_bridge/model/designmanagement.dart';

class GreenDivider extends StatelessWidget {
  const GreenDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: ColorManagement.dividerColor,
    );
  }
}
