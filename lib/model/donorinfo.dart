class DonorInfo {
  String displayName;
  String? photoURL;
  double totalRecipient;
  double totalDonation;
  double rating;

  DonorInfo(
    this.displayName,
    this.photoURL,
    this.totalDonation,
    this.totalRecipient,
    this.rating,
  );

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
