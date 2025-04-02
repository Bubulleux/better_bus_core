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

  bool followDirection(Station start, Station end) {
    bool inWay = false;
    assert(start != end);
    for (var time in stopTimes) {
      final stop = time.station;
      if (stop == start) {
        if (inWay) return false;
        inWay = true;
      }
      if (stop == end) {
        if (!inWay) return false;
        return true;
      }
    }
    return false;
  }
}

class TripStop extends WayPoint {
  TripStop(this.station, this.travelDist, {required super.time}): super(position: station.position);

  final Station station;
  final int travelDist;
}
