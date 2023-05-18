import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_bridge/controller/authcontroller.dart';
import 'package:food_bridge/controller/controllermanagement.dart';
import 'package:food_bridge/controller/donationcontroller.dart';
import 'package:food_bridge/controller/localizationcontroller.dart';
import 'package:food_bridge/main.dart';
import 'package:food_bridge/model/designmanagement.dart';
import 'package:food_bridge/model/userinfo.dart';
import 'package:food_bridge/view/widgets/dialogs.dart';
import 'package:food_bridge/view/widgets/spacer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DonorProfileScreen extends StatelessWidget {
  final DonorInfo? donorInfo;
  const DonorProfileScreen({
    this.donorInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ChangeNotifierProvider.value(
        value: localeController,
        child: Consumer<LocalizationController>(
          builder: (_, localeControllel, __) => Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              title: Text(
                localeController.getTranslate('profile-title'),
              ),
            ),
            body: Container(
              width: constraints.maxWidth,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * .1,
                  ),
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13),
                        ),
                      ),
                      child: Transform.translate(
                        offset: Offset(0, -constraints.maxWidth / 6),
                        child: Column(
                          children: [
                            ChangeNotifierProvider.value(
                              value: authController,
                              child: Consumer<AuthController>(
                                builder: (__, authController, _) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Stack(
                                          children: [
                                            getUserAvatar(constraints),
                                            getEditAvatarButton(constraints),
                                          ],
                                        ),
                                        const VSpacer(),
                                        SizedBox(
                                          width: constraints.maxWidth,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    donorInfo?.displayName ??
                                                        authController
                                                            .currentUsername,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: StyleManagement
                                                        .usernameTextStyle
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                                HSpacer(),
                                                getEditUsernameButton()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VSpacer(),
                            UserStatsWidget(
                              constraints,
                              donorInfo: donorInfo,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getEditUsernameButton() {
    if (donorInfo != null) {
      return const Text('');
    }
    return InkWell(
      onTap: updateDisplayName,
      child: const Icon(
        Icons.edit,
        size: 20,
      ),
    );
  }

  getEditAvatarButton(BoxConstraints constraints) {
    if (donorInfo != null) {
      return const Text('');
    }
    return EditAvatarButton(constraints);
  }

  getUserAvatar(BoxConstraints constraints) {
    if (authController.currentUserAvatar != null) {
      return ClipOval(
        child: Container(
          color: Colors.grey.shade100,
          child: CachedNetworkImage(
            imageUrl: donorInfo?.photoURL! ?? authController.currentUserAvatar!,
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

  void updateDisplayName() async {
    Map<String, dynamic> data = await showDialog(
      context: navigatorKey.currentState!.context,
      builder: (context) => UsernameDialog(),
    );
    if (!data['status']) {
      return;
    }
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const LoadingDialog(
        message: 'updating-text',
      ),
    );
    await userController
        .updateDisplayName(data["username"])
        .then((result) async {
      Navigator.pop(navigatorKey.currentState!.context);
      if (result['success']) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'update-display-name-success-text',
            'update-display-name-success-description',
            () {},
            showActions: false,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(navigatorKey.currentState!.context).pop();
      } else {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => ErrorDialog(result['err']),
        );
      }
    }).catchError((err) {
      Navigator.pop(navigatorKey.currentState!.context);
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => ErrorDialog(err),
      );
    });
  }
}

class EditAvatarButton extends StatelessWidget {
  final BoxConstraints constraints;
  const EditAvatarButton(
    this.constraints, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: constraints.maxWidth / 140,
      right: constraints.maxWidth / 120,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showImageSourceBottomSheet(context),
          splashColor: Theme.of(context).colorScheme.secondary,
          customBorder: const CircleBorder(),
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorManagement.descriptionColorDark,
                width: 1,
              ),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                Icons.camera_alt,
                color: ColorManagement.iconColor,
                size: constraints.maxWidth / 15,
              ),
            ),
          ),
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
                      style: StyleManagement.usernameTextStyle
                          .copyWith(color: Colors.black.withOpacity(.8)),
                    )
                  ],
                ),
                Row(
                  children: [
                    ImageSourceButton(
                        Icons.camera_alt_rounded, "Camera", ImageSource.camera),
                    ImageSourceButton(Icons.image_rounded, "gallery-text",
                        ImageSource.gallery),
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
  ImageSourceButton(
    this.icon,
    this.text,
    this.source, {
    super.key,
  });

  void pickImage(ImageSource source) async {
    XFile? image = await picker.pickImage(source: source);
    if (image == null) return;
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentState!.context,
      builder: (context) => const LoadingDialog(
        message: 'updating-text',
      ),
    );
    await userController.updateAvatar(image).then((result) async {
      Navigator.pop(navigatorKey.currentState!.context);
      if (result['success']) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => SuccessDialog(
            'update-avatar-success-text',
            'update-avatar-success-description',
            () {},
            showActions: false,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(navigatorKey.currentState!.context).pop();
      } else {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) => ErrorDialog(result['err']),
        );
      }
    }).catchError((err) {
      Navigator.pop(navigatorKey.currentState!.context);
      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) => ErrorDialog(err),
      );
    });
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

class UserStatsWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final DonorInfo? donorInfo;
  const UserStatsWidget(
    this.constraints, {
    this.donorInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ChangeNotifierProvider.value(
        value: donationController,
        child: Consumer<DonationController>(
          builder: (_, donationController, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsBoxWidget(
                donorInfo?.getTotalDonation() ??
                    donationController.getTotalDonation(),
                'donations-stats-label',
                constraints: constraints,
              ),
              StatsBoxWidget(
                donorInfo?.getTotalRecipient() ??
                    donationController.getTotalRecipient(),
                'recipients-stats-label',
                constraints: constraints,
              ),
              StatsBoxWidget(
                donorInfo?.getRating() ?? donationController.getRating(),
                'rating-stats-label',
                constraints: constraints,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsBoxWidget extends StatelessWidget {
  final String value;
  final String label;
  const StatsBoxWidget(
    this.value,
    this.label, {
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: StyleManagement.statsTextStyle,
        ),
        Text(
          localeController.getTranslate(label),
          style: StyleManagement.settingsItemTextStyle.copyWith(
            color: Colors.black.withOpacity(.66),
          ),
        )
      ],
    );
  }
}
