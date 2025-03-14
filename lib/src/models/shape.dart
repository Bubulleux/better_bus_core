import 'package:better_bus_core/src/models/gtfs/gtfs_data.dart';
import 'package:better_bus_core/src/models/waypoint.dart';
import 'package:latlong2/latlong.dart';

import '../models.dart';
import '../helper.dart';

class LineShape {
  final List<WayPoint> wayPoints;

  LineShape(this.wayPoints);

  LineShape.fromGTFS(GTFSShape shape, List<TripStop> stopTimes)
      : this(shape.wayPoints
            .map((e) => WayPoint(position: e, time: DateTime.now()))
            .toList());

  //       {
  // wayPoints =
  // )).toList();
  // // final timeI = stopTimes.iterator;
  // TripStop? lastTime = null;
  //
  // wayPoints = [];
  // int lastIndex = 0;
  //
  // while (timeI.moveNext()) {
  //   final time = timeI.current;
  //   final path = untilGoseAway(time.station.position, shape.wayPoints);
  //
  //   if (lastTime == null) {
  //     wayPoints.add(time);
  //     lastTime = time;
  //     continue;
  //   }
  //
  //   final pathDst = pathDist(path);
  //   final dt = time.time.difference(lastTime.time);
  //   var currentDst = 0.0;
  //   var lstPt = wayPoints.last.position;
  //   for (var point in path) {
  //     currentDst += lstPt.distance(point);
  //     wayPoints.add(WayPoint(
  //       position: point,
  //       time: lastTime.time.add(dt * (currentDst / pathDst)),
  //     ));
  //   }
  //   wayPoints.add(time);
  //   lastTime = time;
  // }
  // }

  Iterable<LatLng> untilGoseAway(LatLng pos, List<LatLng> path) sync* {
    double lastDst = double.infinity;
    final iterator = path.iterator;
    if (!iterator.moveNext()) return;
    LatLng lastPoint = iterator.current;

    while (iterator.moveNext()) {
      final point = iterator.current;
      final newDst = pos.distance(point);
      if (lastDst < newDst && newDst < 0.2) break;
      yield lastPoint;
      lastPoint = point;
    }
    yield lastPoint;
  }

  double pathDist(Iterable<LatLng> path) {
    double dst = 0;
    LatLng? lastPoint;
    for (var point in path) {
      if (lastPoint != null) {
        dst += lastPoint.distance(point);
      }
      lastPoint = point;
    }
    return dst;
  }
}
