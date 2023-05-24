class UserNotification {
  String id;
  String from;
  String donation;
  String donationId;
  bool hasRead;
  DateTime createAt;

  UserNotification(
    this.id,
    this.from,
    this.donation,
    this.donationId,
    this.hasRead,
    this.createAt,
  );

  factory UserNotification.fromJson(String id, Map<String, dynamic> data) =>
      UserNotification(
        id,
        data['from'],
        data['donation'],
        data['donationId'],
        data['hasRead'],
        data['createAt'].toDate(),
      );
}
