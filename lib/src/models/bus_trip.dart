import 'package:better_bus_core/src/models/gtfs/gtfs_data.dart';
import 'package:better_bus_core/src/models/gtfs/way_point.dart';
import 'package:better_bus_core/src/models/waypoint.dart';

import '../models.dart';

class BusTrip extends LineDirected {
  BusTrip(super.direction, {required this.stopTimes, required this.shape, required this.id});


  final int id;
  final List<TripStop> stopTimes;
  final LineShape shape;

  Iterable<TripStop> from(Station station) {
    return stopTimes.skipWhile((e) => e.station != station);
  }

  @override
  String toString() {
    return 'BusTrip{direction: $direction, stopLength: ${stopTimes.length}';
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is BusTrip && hashCode == other.hashCode;
  }

  bool isPassingBy(Station station) {
    return stopTimes.any((e) => e.station == station);
  }
}

class TripStop extends WayPoint {
  TripStop(this.station, this.travelDist, {required super.time}): super(position: station.position);

  final Station station;
  final int travelDist;
}
