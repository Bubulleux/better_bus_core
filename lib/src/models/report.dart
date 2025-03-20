import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';

import '../helper.dart';
import '../models.dart';

class Report {
  Report(this.station, this.id);

  late final Station station;
  late final Map<DateTime, bool> updates = {};
  late final int id;


  Duration get lastSee => DateTime.now().difference(
    updates.entries.lastWhere((e) => e.value).key
  );

  double get stillThere => updates.containsValue(true)
      ? clamp(-(5 * 60 * 1000) / updates.entries.lastWhere((e) => e.value).key.difference(
        DateTime.now()).inMilliseconds, 0, 1) * (updates.values.last ? 1 : 0.5)
  : 0;

  Report.fromJson(Map<String, dynamic> json, Map<int, Station> stations) {
    station = stations[json["station"]]!;
    id = json["id"];
    Map<String, dynamic> rawUpdates = json["updates"]!;
    updates.addAll(rawUpdates.map((key, value) =>
        MapEntry(DateTime.fromMillisecondsSinceEpoch(int.parse(key)), value as bool)));
  }

  factory Report.fromResponse(Response response, Map<int, Station> stations) {
    assert(response.statusCode == 200);
    String body = utf8.decode(response.bodyBytes);
    Map<String, dynamic> output = jsonDecode(body);
    return Report.fromJson(output, stations);
  }

  @override
  int get hashCode => station.hashCode ^ id.hashCode ^ Object.hashAll(updates.keys);
}