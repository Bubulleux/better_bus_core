import 'package:better_bus_core/src/models/gtfs/gtfs_data.dart';

import '../models.dart';
import '../helper.dart';

class LineShape {
  late final List<Location> wayPoints;

  LineShape(GTFSShape shape, List<TripStop> stopTimes) {
    final shapeI = shape.wayPoints.iterator;
    final timesI = stopTimes.iterator;
    wayPoints = [];

    while (timesI.moveNext()) {
      double dst = double.infinity;
      double newDst = 0;
      do {
        newDst = wayPoints.last.position.distance(timesI.current.station.position);
        wayPoints.add(Location(shapeI.current));
      } while (shapeI.moveNext() && (newDst < dst || dst < 0.1));
      wayPoints.add(timesI.current.station);
    }
  }
}
