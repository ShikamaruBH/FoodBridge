import 'package:flutter/material.dart';
import 'package:food_bridge/controller/rolebuttoncontroller.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:provider/provider.dart';

class RoleSelectButton extends StatelessWidget {
  final String imagePath;
  final String role;
  final bool mirror;
  const RoleSelectButton(
    this.imagePath,
    this.role,
    this.mirror, {
    super.key,
  });

  Color getColor(RoleButtonController controller, context) {
    return controller.currentRole == role
        ? ColorManagement.selectedColor
        : Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ChangeNotifierProvider.value(
        value: RoleButtonController(),
        child: Consumer<RoleButtonController>(
          builder: (_, controller, __) => Material(
            color: getColor(controller, context), // Button color
            child: InkWell(
              splashColor: Colors.white.withOpacity(0.5), // Splash color
              onTap: () {
                controller.setRole(role);
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Transform.scale(
                        scaleX: mirror ? -1 : 1,
                        child: Image.asset(imagePath))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
