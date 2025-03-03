import 'dart:convert';

import 'package:better_bus_core/core.dart';
import 'package:better_bus_core/src/bus_network.dart';
import 'package:http/http.dart' as http;

class RadarClient {
  late final Uri apiUrl;
  final BusNetwork provider;


  RadarClient({required this.apiUrl, required this.provider});

  RadarClient.localhost({required this.provider}) {
    apiUrl =  Uri.parse("localhost:8080");
  }

  Future<List<Report>> getReports() async {
    final stations = (await provider.getStations()).asMap().map(
        (_, value) => MapEntry(value.id, value)
    );

    final response = await http.get(Uri.parse('$apiUrl/reports'));
    if (response.statusCode != 200) {
      throw Exception("Failed to get reports");
    }
    String body = utf8.decode(response.bodyBytes);
    List<dynamic> output = jsonDecode(body);
    return output.map((e) => Report.fromJson(e, stations)).toList(growable: false);
  }

  Future<bool> sendReport(Station station, {bool stillThere = true}) async {
    // TODO : Maybe Post is better ?
    final uri = Uri.parse('$apiUrl/sendReport/${station.id}');
    final response = await http.get(uri);
    return response.statusCode == 200;
  }
}