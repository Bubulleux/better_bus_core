import 'package:better_bus_core/src/helper.dart';

import 'bus_network.dart';
import 'gtfs_downloader.dart';
import 'models/bus_line.dart';
import 'models/gtfs/gtfs_data.dart';
import 'models/gtfs/gtfs_path.dart';
import 'models/gtfs/timetable.dart';
import 'models/gtfs/trip.dart';
import 'models/line_direction.dart';
import 'models/line_timetable.dart';
import 'models/station.dart';
import 'models/traffic_info.dart';

class GTFSProvider extends BusNetwork {
  GTFSProvider({required this.downloader});

  GTFSProvider.vitalis(GTFSPaths paths)
      : this(downloader: GTFSDataDownloader.vitalis(paths));

  final GTFSDataDownloader downloader;
  GTFSData? get _data => downloader.data;

  GTFSData get data => _data!;

  @override
  Future<bool> init({bool offline = false, OnProgress? onProgress}) async {
    if (offline) {
      await downloader.paths.init();
      await downloader.loadIfExist();
      return isAvailable();
    }

    bool pathInit = await downloader.paths.init();
    if (!pathInit) {
      print("Path provider failded to init");
      return false;
    }
    await downloader.downloadAndLoad(onProgress ?? (_) {});
    return isAvailable();
  }

  @override
  bool isAvailable() {
    return _data != null;
  }

  @override
  Future<List<Station>> getStations() {
    return Future.value(_data!.stations.values.toList());
  }

  @override
  Future<Map<String, BusLine>> getAllLines() {
    return Future.value(
        {for (var e in data.routes.entries) e.value.id: e.value});
  }

  @override
  Future<List<BusLine>> getPassingLines(Station station) {
    if (station.stops.isEmpty) {
      station = data.stations[station.id]!;
    }

    List<BusLine> result = data.trips.entries
        .where((e) => e.value.stopTimes.containsKey(station))
        .map((e) => e.value.line)
        .toSet()
        .toList(growable: false);

    result.sort();

    return Future.value(result);
  }

  @override
  Future<GTFSTimeTable> getTimetable(Station station, {DateTime? time}) {
    DateTime now = time ?? DateTime.now();

    Set<String> validServices = data.calendar.getEnablesServices(now);

    final trips =
        data.trips.values.where((e) => validServices.contains(e.serviceID));

    final timesHash = <int>{};
    final output = <GTFSTrip>[];
    for (var e in trips) {
      final hash = e.direction.hashCode ^ e.stopTimes.values.first.arrival.hashCode;
      if (timesHash.contains(hash)) continue;
      output.add(e);
      timesHash.add(hash);
    }

    return Future.value(GTFSTimeTable(station, now, output));
  }

  @override
  Future<LineTimetable> getLineTimetable(
      Station station, BusLine line, int direction, DateTime date) {
    DateTime today = date.atMidnight();
    Set<String> validServices = data.calendar.getEnablesServices(today);

    Map<String, String> ends = {};
    Map<DateTime, String> stopTimes = {};

    const labels = "abcdefghijk............";

    for (var trip in data.trips.values) {
      if (!validServices.contains(trip.serviceID) ||
          !trip.stopTimes.containsKey(station) ||
          trip.line != line ||
          trip.direction.directionId != direction) {
        continue;
      }
      if (!ends.containsKey(trip.direction.destination)) {
        ends[trip.direction.destination] = ends.length < labels.length
            ? labels[ends.length]
            : ends.length.toString();
      }
      final stopTime = trip.stopTimes[station]!;
      stopTimes[today.add(stopTime.arrival)] =
          ends[trip.direction.destination]!;
    }
    stopTimes = Map.fromEntries(
        stopTimes.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    final result = LineTimetable(
      station,
      line,
      today,
      destinations: {for (var e in ends.entries) e.value: e.key},
      passingTimes: stopTimes,
    );

    return Future.value(result);
  }

  List<LineDirection> getStopDirections(int stopId) {
    final station = data.stopsParent[stopId]!;
    return data.trips.values
        .where((t) => t.stopTimes.keys.contains(station) && t.stopTimes[station]!.stopId == stopId)
        .map((e) => e.direction)
        .toSet()
        .toList();
  }

  @override
  Future<List<InfoTraffic>> getTrafficInfos() {
    // TODO: implement getTrafficInfos
    throw UnimplementedError();
  }
}
