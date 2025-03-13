import 'package:better_bus_core/src/models/gtfs/gtfs_data.dart';
import 'package:better_bus_core/src/models/waypoint.dart';
import 'package:latlong2/latlong.dart';

import '../models.dart';
import '../helper.dart';

class LineShape {
  late final List<WayPoint> wayPoints;

  LineShape(GTFSShape shape, List<TripStop> stopTimes) {
    final shapeI = shape.wayPoints.iterator;
    final timesI = stopTimes.iterator;
    print(stopTimes);
    wayPoints = [];
    return;
    wayPoints = [timesI.current];

    while (timesI.moveNext()) {
      final next = timesI.current;
      final previous = wayPoints.last;
      double totalDst = 0;
      double endDst = double.infinity;
      var lastDst = double.infinity;
      final path = <LatLng>[];
      do {
        final waypoint = shapeI.current;
         lastDst = endDst;
         endDst = next.position.distance(waypoint);
         if (path.isNotEmpty) {
           totalDst += path.last.distance(waypoint);
         }
         path.add(waypoint);

      } while (shapeI.moveNext() && (lastDst > endDst || endDst > 0.1));

      WayPoint last = wayPoints.last;
      Duration dt = next.time.difference(previous.time);
      wayPoints.addAll(
        path.map((e) {
          final dst = last.position.distance(e);
          last = WayPoint(position: e,
              time: previous.time.add(dt * (dst / totalDst))
          );
          return last;
        })
      );
      wayPoints.add(next);
    }
  }
}
