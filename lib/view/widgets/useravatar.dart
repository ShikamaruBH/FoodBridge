import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/controllermanagement.dart';

class UserAvatar extends StatelessWidget {
  final BoxConstraints constraints;
  // ignore: prefer_const_constructors_in_immutables
  UserAvatar(this.constraints, {super.key});

  @override
  Widget build(BuildContext context) {
    if (authController.currentUserAvatar != null) {
      return ClipOval(
        child: Container(
          color: Colors.grey.shade100,
          child: CachedNetworkImage(
            imageUrl: authController.currentUserAvatar!,
            width: constraints.maxWidth / 3,
            height: constraints.maxWidth / 3,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: SizedBox(
                width: constraints.maxWidth / 6,
                height: constraints.maxWidth / 6,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.grey.shade300,
      radius: constraints.maxWidth / 6,
      child: Icon(
        Icons.person,
        size: constraints.maxWidth / 4,
        color: Colors.white,
      ),
    );
  }
}
