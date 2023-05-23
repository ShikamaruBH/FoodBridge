class AppUserInfo {
  String? uid;
  String displayName;
  String? photoURL;
  String? email;
  String? phoneNumber;
  int? likes;
  bool? isLiked;

  AppUserInfo(
    this.displayName,
    this.photoURL, {
    this.email,
    this.phoneNumber,
    this.likes,
    this.isLiked,
  });

  factory AppUserInfo.fromJson(Map<String, dynamic> data) => AppUserInfo(
        data['displayName'],
        data['photoURL'],
      );

  Map<String, dynamic> getLikes() {
    return {
      'likes': likes ?? 0,
      'isLiked': isLiked ?? false,
    };
  }
}

class DonorInfo extends AppUserInfo {
  double totalRecipient;
  double totalDonation;

  DonorInfo(
    displayName,
    photoURL,
    email,
    phoneNumer,
    likes,
    isLiked,
    this.totalDonation,
    this.totalRecipient,
  ) : super(
          displayName,
          photoURL,
          email: email,
          phoneNumber: phoneNumer,
          likes: likes,
          isLiked: isLiked,
        );

  factory DonorInfo.fromJson(Map<String, dynamic> data) => DonorInfo(
        data['displayName'],
        data['photoURL'],
        data['email'],
        data['phoneNumber'],
        data['likes']?.toInt() ?? 0,
        data['isLiked'],
        data['totalDonation'].toDouble(),
        data['totalRecipient'].toDouble(),
      );

  String getTotalDonation() {
    return totalDonation.toInt().toString();
  }

  String getTotalRecipient() {
    return totalRecipient.toInt().toString();
  }
}

class RecipientInfo extends AppUserInfo {
  double totalReceivedDonation;

  RecipientInfo(
    displayName,
    photoURL,
    email,
    phoneNumber,
    likes,
    isLiked,
    this.totalReceivedDonation,
  ) : super(
          displayName,
          photoURL,
          email: email,
          phoneNumber: phoneNumber,
          likes: likes,
          isLiked: isLiked,
        );

  factory RecipientInfo.fromJson(Map<String, dynamic> data) => RecipientInfo(
        data['displayName'],
        data['photoURL'],
        data['email'],
        data['phoneNumber'],
        data['likes']?.toInt() ?? 0,
        data['isLiked'],
        data['totalReceivedDonation'].toDouble(),
      );

  String getTotalDonation() {
    return totalReceivedDonation.toInt().toString();
  }
}
