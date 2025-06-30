import 'package:better_bus_core/core.dart';
import 'package:better_bus_core/src/models/gtfs/protoc/gtfs-realtime.pb.dart';
import 'package:better_bus_core/src/models/gtfs/trip.dart';

class GTFSRTTrip extends BusTrip {
  GTFSRTTrip(BusTrip trip, TripUpdate tripUpdate) : super(trip, 
    stopTimes: [], 
    shape: trip.shape, 
    id: trip.id) {
    final updates = Map.fromEntries(
      tripUpdate.stopTimeUpdate.map((e) =>
        MapEntry(int.parse(e.stopId), e))
    );

    for (var time in trip.stopTimes) {
      final update = updates[time.subStation];
    if (update == null) {
      stopTimes.add(time);
      continue;
    }

    if (update.scheduleRelationship == TripUpdate_StopTimeUpdate_ScheduleRelationship.SCHEDULED) {
      stopTimes.add(time);
      final delay = update.hasArrival() ?
        update.arrival.delay : update.departure.delay;
      time.realTime = time.time.add(Duration(seconds: delay));
    }
  }
  }

}
