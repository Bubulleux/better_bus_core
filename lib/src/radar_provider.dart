import 'dart:convert';

import 'package:better_bus_core/core.dart';
import 'package:better_bus_core/src/bus_network.dart';
import 'package:http/http.dart' as http;

class RadarClient {
  late final Uri apiUrl;
  final BusNetwork provider;
  late final Map<int, Station> _stations;


  RadarClient({required this.apiUrl, required this.provider}) {
    provider.getStations().then((value) {
      _stations = value.asMap().map(
              (_, value) => MapEntry(value.id, value)
      );
    });
  }

  RadarClient.localhost({required this.provider}) {
    apiUrl =  Uri.parse("localhost:8080");
  }

  Future<List<Report>> getReports() async {

    final response = await http.get(Uri.parse('$apiUrl/reports'));
    if (response.statusCode != 200) {
      throw Exception("Failed to get reports");
    }
    String body = utf8.decode(response.bodyBytes);
    List<dynamic> output = jsonDecode(body);
    return output.map((e) => Report.fromJson(e, _stations)).toList(growable: false);
  }

  Future<Report?> sendReport(Station station, {bool stillThere = true}) async {
    // TODO : Maybe Post is better ?
    final uri = Uri.parse('$apiUrl/sendReport/${station.id}');
    final response = await http.get(uri);
    if(response.statusCode != 200) {
      print("Failed to send report");
      return null;
    }
    String body = utf8.decode(response.bodyBytes);
    Map<String, dynamic> output = jsonDecode(body);
    return Report.fromJson(output, _stations);
  }
}