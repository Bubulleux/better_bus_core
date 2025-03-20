import 'package:latlong2/latlong.dart';

import '../location.dart';

class GTFSWayPoint extends Location implements Comparable<GTFSWayPoint> {
  final int shapeId;
  final int index;

  GTFSWayPoint(this.shapeId, this.index, {required super.position});

  GTFSWayPoint.fromRaw(Map<String, String> row)
      : this(
          int.parse(row["shape_id"]!),
          int.parse(row["shape_pt_sequence"]!),
          position: LatLng(double.parse(row["shape_pt_lat"]!),
              double.parse(row["shape_pt_lon"]!)),
        );

  @override
  int compareTo(GTFSWayPoint other) {
    return index.compareTo(other.index);
  }
}
