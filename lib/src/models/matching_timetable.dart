import 'gtfs/timetable.dart';
import 'stop_time.dart';
import 'timetable.dart';

class MatchingTimetable extends Timetable {
  Timetable realTime;
  GTFSTimeTable gtfsTimeTable;

  MatchingTimetable(this.realTime, this.gtfsTimeTable): super.copy(realTime) {
    assert(realTime == gtfsTimeTable);
  }

  @override
  Iterable<StopTime> getNext({DateTime? from}) {
    from ??= DateTime.now();
    // return gtfsTimeTable.getNext(from: from);
    List<StopTime> apiTimes = realTime.getNext(from: from).toList();
    final result = apiTimes.where((e) => e.isRealTime).map((e) => gtfsTimeTable.matchTime(e)).toList();
    final Set<int> matchedTrips = result.map((e) => e.trip?.id ?? -1).toSet();
    print(apiTimes.length);
    print(result.length);
    print(matchedTrips.length);
    
    result.addAll(gtfsTimeTable.getNext(from: from)
        .where((e) => !matchedTrips.contains(e.trip?.id))
    );
    print(result.length);

    result.sort();
    return result;
  }

}