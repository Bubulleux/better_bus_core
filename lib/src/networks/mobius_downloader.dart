import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:better_bus_core/core.dart';

class MobiusDownloader extends GTFSDataDownloader {
  MobiusDownloader({required super.paths});


  @override
  Future<DatasetMetadata> getFileMetaData() async {
    final uri = Uri.parse("https://transport.data.gouv.fr/api/datasets/6038d0cdcb69d16225b11e23");
    http.Response res = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(utf8.decode(res.bodyBytes));

    List<dynamic> ressources = json["ressource"];
    late final Uri dataUri;
    late final DateTime updateTime;
    Uri? rtEndPoint;

    for (var ressource in ressources) {
    final format = ressource["format"];
    if (format == "GTFS") {
       dataUri = Uri.parse(ressource["original_url"]);
       updateTime = DateTime.parse(ressource["updated_at"]);
    }
    if (format == "gtfs-rt") {
        assert(rtEndPoint == null);
       rtEndPoint = Uri.parse(ressource["original_url"]);
    }
  }


    return DatasetMetadata(dataUri, updateTime, rtEndPoint);
  }
}
