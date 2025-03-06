
int colorFromHex(String hex) {
  return int.parse(hex.replaceAll("#", "0xff"));
}

double clamp(double x, double min, double max) {
  return x < min ? min : x > max ? max : x;
}

extension DateTimeAtMidnight on DateTime {
  DateTime atMidnight() {
    return DateTime(year, month, day);
  }
}
