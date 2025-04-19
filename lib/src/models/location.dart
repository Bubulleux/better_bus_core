import 'package:latlong2/latlong.dart';

class Location {
  final LatLng position;

  const Location({required this.position});

  @override
  // TODO: implement hashCode
  int get hashCode => position.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Location && hashCode == other.hashCode;
  }
}