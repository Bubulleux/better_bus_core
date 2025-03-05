
int colorFromHex(String hex) {
  return int.parse(hex.replaceAll("#", "0xff"));
}

double clamp(double v, double min, double max) {
  final mini = min > v ? min : v;
  return max < mini ? max : mini;
}
extension DateTimeAtMidnight on DateTime {
  DateTime atMidnight() {
    return DateTime(year, month, day);
  }
}
