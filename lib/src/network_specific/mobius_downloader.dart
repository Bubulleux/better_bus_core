import 'dart:convert';

import '../gtfs_downloader.dart';
import '../models/gtfs/metadata.dart';
import 'package:http/http.dart' as http;

class MobiusDownloader extends GTFSDataDownloader {
  MobiusDownloader({required super.paths});


  @override
  Future<DatasetMetadata> getFileMetaData() async {
    final uri = Uri.parse("https://transport.data.gouv.fr/api/datasets/6038d0cdcb69d16225b11e23");
    http.Response res = await http.get(uri);
    Map<String, dynamic> json = jsonDecode(utf8.decode(res.bodyBytes));

    var ressource = json["history"][0];

    final dataUri = Uri.parse(ressource["payload"]["permanent_url"]);
    DateTime updateTime = DateTime.parse(ressource["updated_at"]);

    return DatasetMetadata(dataUri, updateTime);
  }
}