class AppUserInfo {
  String displayName;
  String? photoURL;

  AppUserInfo(
    this.displayName,
    this.photoURL,
  );

  factory AppUserInfo.fromJson(Map<String, dynamic> data) => AppUserInfo(
        data['displayName'],
        data['photoURL'],
      );
}

class DonorInfo extends AppUserInfo {
  double totalRecipient;
  double totalDonation;
  double rating;

  DonorInfo(
    displayName,
    photoURL,
    this.totalDonation,
    this.totalRecipient,
    this.rating,
  ) : super(displayName, photoURL);

  factory DonorInfo.fromJson(Map<String, dynamic> data) => DonorInfo(
        data['displayName'],
        data['photoURL'],
        data['totalDonation'].toDouble(),
        data['totalRecipient'].toDouble(),
        data['rating'].toDouble(),
      );

  String getTotalDonation() {
    return totalDonation.toInt().toString();
  }

  String getTotalRecipient() {
    return totalRecipient.toInt().toString();
  }

  String getRating() {
    return rating.toStringAsFixed(1);
  }
}

class RecipientInfo extends AppUserInfo {
  double totalReceivedDonation;
  double rating;

  RecipientInfo(
    displayName,
    photoURL,
    this.totalReceivedDonation,
    this.rating,
  ) : super(displayName, photoURL);

  factory RecipientInfo.fromJson(Map<String, dynamic> data) => RecipientInfo(
        data['displayName'],
        data['photoURL'],
        data['totalReceivedDonation'].toDouble(),
        data['rating'].toDouble(),
      );

  String getTotalDonation() {
    return totalReceivedDonation.toInt().toString();
  }

  String getRating() {
    return rating.toStringAsFixed(1);
  }
}
