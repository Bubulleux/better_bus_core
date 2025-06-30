import 'package:better_bus_core/core.dart';
import 'package:better_bus_core/src/models/gtfs/protoc/gtfs-realtime.pb.dart';
import 'package:better_bus_core/src/models/gtfs/rt_trip.dart';
import 'package:better_bus_core/src/models/gtfs/trip.dart';
import 'package:better_bus_core/src/models/waypoint.dart';

class GTFSRTTimetable extends GTFSTimeTable {
  final FeedMessage message;
  final Map<int, TripUpdate> updates  = {};


  GTFSRTTimetable(super.from, this.message) : super.copy() {
    final tripsMap = Map.fromEntries(trips.map((e) => MapEntry(e.id, e)));

    for (var e in message.entity) {
    final id = int.tryParse(e.tripUpdate.trip.tripId);
    if (id == null || !tripsMap.containsKey(id)) {
        continue;
      }
    updates[id] = e.tripUpdate;
  }
  }

  @override
  Iterable<StopTime> getNext({DateTime? from}) {
    return super.getNext(from: from).map(corect);
  }

  StopTime corect(StopTime time) {
    if (!updates.containsKey(time.trip?.id)) {
      return time;
    }

    final update = updates[time.trip!.id];
    if (update == null) {
      print("No Update found");
      return time;
    }

    final newTrip = GTFSRTTrip(time.trip!, update);


    time.realTime = newTrip.from(time.station).first.realTime;
    time.trip = newTrip;
    return time;
  }
}
