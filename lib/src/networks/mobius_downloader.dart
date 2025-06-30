import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:better_bus_core/core.dart';

const angouleme = "https://transport.data.gouv.fr/api/datasets/6038d0cdcb69d16225b11e23";
const nante = "https://transport.data.gouv.fr/api/datasets/632b2c56696ec36c7f4811c8";

class MobiusDownloader extends GTFSDataDownloader {
  MobiusDownloader({required super.paths});


  @override
  Future<DatasetMetadata> getFileMetaData() async {
    final uri = Uri.parse(angouleme);
    http.Response res = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(utf8.decode(res.bodyBytes));

    List<dynamic> ressources = json["resources"];
    late final Uri dataUri;
    late final DateTime updateTime;
    Uri? rtEndPoint;

    for (var ressource in ressources) {
    final format = ressource["format"];
    if (format == "GTFS") {
       dataUri = Uri.parse(ressource["original_url"]);
       updateTime = DateTime.parse(ressource["updated"]);
    }
    if (format == "gtfs-rt") {
        assert(rtEndPoint == null);
       rtEndPoint = Uri.parse(ressource["original_url"]);
    }
  }


    return DatasetMetadata(dataUri, updateTime, rtEndPoint);
  }
}
