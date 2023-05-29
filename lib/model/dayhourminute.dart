List<dynamic> getDayHourMinute(double seconds) {
  Duration duration = Duration(seconds: seconds.toInt());
  return [
    duration.inDays,
    duration.inHours.remainder(24),
    duration.inMinutes.remainder(60),
    duration.inSeconds.remainder(60)
  ];
}
