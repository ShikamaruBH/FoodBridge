List<dynamic> getDayHourMinute(double seconds) {
  Duration duration = Duration(seconds: seconds.toInt());
  return [
    duration.inDays,
    duration.inHours.remainder(24),
    duration.inMinutes.remainder(60),
    duration.inSeconds.remainder(60)
  ];
}

String getTime(double value) {
  Duration duration = Duration(seconds: value.toInt());
  String str(int value) => value.toString().padLeft(2, '0');
  final days = duration.inDays;
  final hours = duration.inHours.remainder(24);
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  return "${str(days)}:${str(hours)}:${str(minutes)}:${str(seconds)}";
}
