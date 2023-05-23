class UserNotification {
  String id;
  String from;
  String donation;
  bool hasRead;
  DateTime createAt;

  UserNotification(
    this.id,
    this.from,
    this.donation,
    this.hasRead,
    this.createAt,
  );

  factory UserNotification.fromJson(String id, Map<String, dynamic> data) =>
      UserNotification(
        id,
        data['from'],
        data['donation'],
        data['hasRead'],
        data['createAt'].toDate(),
      );
}
