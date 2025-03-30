import 'api_provider.dart';
import 'bus_network.dart';
import 'gtfs_provider.dart';
import 'models/bus_line.dart';
import 'models/gtfs/timetable.dart';
import 'models/line_timetable.dart';
import 'models/matching_timetable.dart';
import 'models/station.dart';
import 'models/timetable.dart';
import 'models/traffic_info.dart';

class NetworkProvider extends BusNetwork {
  final ApiProvider api;
  final GTFSProvider gtfs;

  BusNetwork get preferApi => api.isAvailable() ? api : gtfs;
  BusNetwork get preferGtfs => gtfs.isAvailable() ? gtfs : api;

  NetworkProvider({required this.api, required this.gtfs});


  @override
  Future<bool> init() async {
    final superInit = super.init();
    final result = await Future.wait([api.init(), gtfs.init()]);
    if (!result[0] || !result[1]) {
      print("Failed to init all providers");
      print("API PROVIDER: ${result[0]}");
      print("GTFS PROVIDER: ${result[1]}");
    }
    return (result[0] || result[1]) && await superInit;
  }

  @override
  bool isAvailable() {
    return api.isAvailable() && gtfs.isAvailable();
  }

  @override
  Future<Map<String, BusLine>> getAllLines() {
    return preferGtfs.getAllLines();
  }

  @override
  Future<LineTimetable> getLineTimetable(Station station, BusLine line, int direction, DateTime date)
    => gtfs.getLineTimetable(station, line, direction, date);

  @override
  Future<List<BusLine>> getPassingLines(Station station) => preferGtfs.getPassingLines(station);

  @override
  Future<List<Station>> getStations() => preferGtfs.getStations();


  @override
  Future<Timetable> getTimetable(Station station) async {
    if (!gtfs.isAvailable() || !api.isAvailable()) {
      return preferApi.getTimetable(station);
    }
    GTFSTimeTable gtfsTimes = await gtfs.getTimetable(station);
    final apiTimes = await api.getTimetable(station);

    return MatchingTimetable(apiTimes, gtfsTimes);

  }

  @override
  Future<List<InfoTraffic>> getTrafficInfos() => api.getTrafficInfos();


}