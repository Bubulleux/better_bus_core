
// TODO: Remove helper function
import 'bus_line.dart';
import 'station.dart';
import '../helper.dart';

class LineTimetable {
  // TODO : Maybe not needed but their is this to do here
  LineTimetable(this.station, this.line, DateTime _date, {
    required this.destinations,
    required this.passingTimes,
    this.directionId = 0,
  }) {
    date = _date.atMidnight();
  }

  final Station station;
  final BusLine line;
  late final DateTime date;
  final Map<String, String> destinations;
  final Map<DateTime, String> passingTimes;
  final int directionId;
}