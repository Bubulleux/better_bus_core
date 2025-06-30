import 'package:better_bus_core/core.dart';
import 'package:better_bus_core/src/models/gtfs/protoc/gtfs-realtime.pb.dart';
import 'package:better_bus_core/src/models/gtfs/rt_trip.dart';

class GTFSRTTimetable extends GTFSTimeTable {
  final FeedMessage message;
  final Map<int, GTFSRTTrip> updates  = {};

  GTFSRTTimetable(super.from, this.message) : super.copy() {

    final tripsMap = Map.fromEntries(trips.map((e) => MapEntry(e.id, e)));

    for (var e in message.entity) {
    final id = int.tryParse(e.tripUpdate.trip.tripId);
    if (id == null) {
        continue;
      }
    updates[id] = GTFSRTTrip(tripsMap[id]!, e.tripUpdate);
  }
  }

  @override
  Iterable<StopTime> getNext({DateTime? from}) {
    return super.getNext(from: from).map(corect);
  }

  StopTime corect(StopTime time) {
    if (!updates.containsKey(time.trip?.id)) {
      print("Not time updata founnd");
      return time;
    }

    final update = updates[time.trip!.id]!;

    final delay = update.delays[time.station.id];
    if (delay == null || delay.isInfinite) {
      return time;
    }

    time.realTime = time.aimedTime.add(Duration(seconds: delay.toInt()));
    return time;
  }
}
