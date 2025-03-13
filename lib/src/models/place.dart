import 'package:better_bus_core/core.dart';
import 'package:latlong2/latlong.dart';

class Place extends Location {
  const Place(this.name, {required super.position, this.address});

  final String name;
  final String? address;

  Place.fromJson(Map<String, dynamic> json)
      : this(json['name'],
      position: LatLng(json['lat'], json['long']),
            address: json['address']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'lat': position.latitude,
        'long': position.longitude,
      };
}
