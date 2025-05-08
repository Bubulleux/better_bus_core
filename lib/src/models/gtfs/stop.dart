import 'package:latlong2/latlong.dart';

import '../place.dart';
import '../station.dart';

class GTFSStop extends Place {
  const GTFSStop(super.name, this.id,
  {required super.position, required this.code, this.parent});

  final int id;
  final String code;
  final int? parent;
  bool get isParent => parent == null;

  GTFSStop.fromCSV(Map<String, String> row)
      : this(
      row["stop_name"]!,
      int.parse(row["stop_id"]!),
      position: LatLng(double.parse(row["stop_lat"]!),
          double.parse(row["stop_lon"]!)),
    code: row["stop_code"]!,
    // Prevent 0 as parent
    parent: ((p) => p == 0 ? null : p)(int.tryParse(row["parent_station"]!))
  );

  Station toStation(List<GTFSStop> children) {
    return Station(name, id, position: super.position,
        stops: Map<int, LatLng>.fromEntries(children.map((e) => MapEntry(e.id, e.position)))
    );
  }

}
