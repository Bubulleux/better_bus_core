import 'gtfs/timetable.dart';
import 'stop_time.dart';
import 'timetable.dart';

class MatchingTimetable extends GTFSTimeTable {
  Timetable realTime;
  // GTFSTimeTable gtfsTimeTable;

  MatchingTimetable(this.realTime, GTFSTimeTable from): super.copy(from) {
    assert(realTime == from);
  }

  @override
  Iterable<StopTime> getNext({DateTime? from}) {
    from ??= DateTime.now();
    List<StopTime> apiTimes = realTime.getNext(from: from).toList();
    final result = apiTimes.where((e) => e.isRealTime).map((e) => super.matchTime(e)).toList();
    final Set<int> matchedTrips = result.map((e) => e.trip?.id ?? -1).toSet();

    result.addAll(super.getNext(from: from)
        .where((e) => !matchedTrips.contains(e.trip?.id))
    );

    result.sort();
    return result;
  }

}