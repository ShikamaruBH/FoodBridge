import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/view/widgets/spacer.dart';

class LoadingLogo extends StatelessWidget {
  const LoadingLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/icons/logo_transparent_bg.png",
              scale: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              HSpacer(),
              Text(localeController.getTranslate('loading-text')),
            ],
          ),
        ],
      ),
    );
  }
}
