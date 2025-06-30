import 'package:better_bus_core/src/models/gtfs/protoc/gtfs-realtime.pb.dart';
import 'package:better_bus_core/src/models/gtfs/trip.dart';
import 'package:better_bus_core/src/models/station.dart';

class GTFSRTTrip extends GTFSTrip {
  final Map<int, double> delays = {};

  GTFSRTTrip(GTFSTrip from, TripUpdate update) : super.copy(from) {
    for (var e in update.stopTimeUpdate) {
      int id = int.parse(e.stopId);
      
      if (e.scheduleRelationship == TripDescriptor_ScheduleRelationship.DELETED) {
        delays[id] = double.infinity;
      }
      delays[id] = (e.hasArrival() ? e.ensureArrival().delay : e.ensureDeparture().delay) as double;
    }
  }
}
