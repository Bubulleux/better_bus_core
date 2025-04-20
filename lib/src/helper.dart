
import 'dart:math';

import 'package:latlong2/latlong.dart';

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

extension LatLngDst on LatLng {
  double distance(LatLng other, {int dec = 2}) {
    final lat1 = latitude;
    final lon1 = longitude;
    final lat2 = other.latitude;
    final lon2 = other.longitude;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double result = 12742 * asin(sqrt(a));
    final factor = pow(10, dec);
    return (result * factor).roundToDouble() / factor;
  }
}
