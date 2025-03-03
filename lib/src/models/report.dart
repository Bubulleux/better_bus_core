import '../models.dart';

class Report {
  Report(this.station, this.id);

  late final Station station;
  late final Map<DateTime, bool> updates = {};
  late final int id;

  Report.fromJson(Map<String, dynamic> json, Map<int, Station> stations) {
    station = stations[json["station"]]!;
    id = json["id"];
    Map<String, dynamic> rawUpdates = json["updates"]!;
    updates.addAll(rawUpdates.map((key, value) =>
        MapEntry(DateTime.fromMillisecondsSinceEpoch(int.parse(key)), value as bool)));
  }
}