import 'dart:convert';

import 'package:better_bus_core/core.dart';
import 'package:http/http.dart' as http;

class RadarClient {
  late final Uri apiUrl;
  final BusNetwork provider;
  late final Map<int, Station> _stations;
  Future? stationLoad;

  static final localhostEndPoint = Uri.parse("http://192.168.188.242:8080");
  static final productionEndpoint =
      Uri.parse("https://better-bus-server-fthea.ondigitalocean.app");

  RadarClient({required this.apiUrl, required this.provider}) {
    stationLoad = provider.getStations()
      ..then((value) {
        _stations = value.asMap().map((_, value) => MapEntry(value.id, value));
        stationLoad = null;
      });
  }

  RadarClient.localhost({required BusNetwork provider})
      : this(apiUrl: localhostEndPoint, provider: provider);

  RadarClient.production({required BusNetwork provider})
      : this(apiUrl: productionEndpoint, provider: provider);

  Future<List<Report>> getReports() async {
    await stationLoad;

    final response = await http.get(Uri.parse('$apiUrl/reports'));
    if (response.statusCode != 200) {
      print("Failed to get reports");
      return [];
    }
    String body = utf8.decode(response.bodyBytes);
    List<dynamic> output = jsonDecode(body);
    return output
        .map((e) => Report.fromJson(e, _stations))
        .toList(growable: false);
  }

  Future<Report?> sendReport(Station station) async {
    // TODO : Maybe Post is better ?
    await stationLoad;
    final uri = Uri.parse('$apiUrl/sendReport/${station.id}');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      print("Failed to send report");
      return null;
    }
    return Report.fromResponse(response, _stations);
  }

  Future<Report?> updateReport(Report report, bool stillThere) async {
    await stationLoad;
    final uri = Uri.parse('$apiUrl/update/${report.id}/${stillThere ? 1 : 0}');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      print("Failed to update report");
      return null;
    }
    String body = utf8.decode(response.bodyBytes);
    Map<String, dynamic> output = jsonDecode(body);
    return Report.fromJson(output, _stations);
  }
}
