
int colorFromHex(String hex) {
  return int.parse(hex.replaceAll("#", "0xff"));
}

extension DateTimeAtMidnight on DateTime {
  DateTime atMidnight() {
    return DateTime(year, month, day);
  }
}
