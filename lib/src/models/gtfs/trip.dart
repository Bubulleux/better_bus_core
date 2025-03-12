import 'package:better_bus_core/core.dart';

import '../bus_line.dart';
import '../bus_trip.dart';
import '../line_direction.dart';
import '../station.dart';
import 'direction.dart';
import 'gtfs_data.dart';
import 'stop_time.dart';
import '../../helper.dart';

class GTFSTrip {
  late final LineDirection direction;
  late final int id;
  late final String serviceID;
  late final int _routeID;
  late final Map<Station, GTFSStopTime> _stopTimes;
  late final GTFSShape shape;

  Map<Station, GTFSStopTime> get stopTimes => _stopTimes;

  BusLine get line => direction.line;

  GTFSTrip(
      Map<String, String> row, List<GTFSStopTime> stopTimes, GTFSData data) {
    _stopTimes = {for (var e in stopTimes) data.stopsParent[e.stopId]!: e};
    _routeID = int.parse(row["route_id"]!);
    serviceID = row["service_id"]!;
    id = int.parse(row["trip_id"]!);
    direction = GTFSLineDirection.fromTripRow(row, data.routes[_routeID]!);
    shape = data.shapes[int.parse(row["shape_id"]!)]!;

    data.routes[_routeID]!.addDirection(this);
  }

  BusTrip at(DateTime from) {
    final date = from.atMidnight();
    final times =  stopTimes.entries
        .map((e) => TripStop(date.add(e.value.arrival), e.key, e.value.distanceTravel))
        .toList();
    return BusTrip(direction,
        id: id,
        shape: LineShape(shape, times),
        stopTimes: times
    );
  }

  @override
  String toString() {
    return "{$direction, ${_stopTimes.values.first.arrival}, ${_stopTimes.keys.first}}";
  }
}
