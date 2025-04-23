import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'models/gtfs/csv_parser.dart';
import 'models/gtfs/gtfs_data.dart';
import 'models/gtfs/gtfs_path.dart';


class DatasetMetadata {
  Uri ressourceUri;
  DateTime updateTime;

  DatasetMetadata(this.ressourceUri, this.updateTime);
}
typedef OnProgress = void Function(double progress);

class GTFSDataDownloader {
  GTFSDataDownloader({
    required this.dataSetAPI,
    required this.gtfsFileURL,
    required this.paths,
  });

  final Uri dataSetAPI;
  final Uri gtfsFileURL;
  GTFSPaths paths;


  GTFSData? _gtfsData;
  GTFSData? get data => _gtfsData;
  Directory get gtfsDir => Directory(paths.extractDir);

  GTFSDataDownloader.vitalis(GTFSPaths paths)
      : this(
          dataSetAPI: Uri.parse(
              "https://data.grandpoitiers.fr/data-fair/api/v1/datasets/offre-de-transport-du-reseau-vitalis"),
          gtfsFileURL: Uri.parse(
              "https://data.grandpoitiers.fr/data-fair/api/v1/datasets/2gwvlq16siyb7d9m3rqt1pb1/metadata-attachments/gtfs.zip"),
          paths: paths,
        );

  Future<bool> loadIfExist() async {
    await paths.init();
    await gtfsDir.create(recursive: true);

    Map<String, CSVTable> files = await loadFiles();

    if (files.isEmpty) {
      return false;
    }
    _gtfsData = GTFSData(files);
    return true;
  }

  Future<bool> downloadAndLoad(OnProgress onProgress) async {
    await paths.init();
    final success = await downloadFile(onProgress: onProgress);
    if (!success) {
      print("Download failed");
    }

    return await loadIfExist();
  }


  Future<bool> removeFiles() async {

    await paths.init();
    if (!await gtfsDir.exists()) return false;
    for (var e in gtfsDir.listSync()) {
      if (e is! File) continue;
      File file = e;
      await file.delete();
    }
    return true;
  }

  Future<GTFSData?> loadFile() async {
    await gtfsDir.create(recursive: true);

    Map<String, CSVTable> files = await loadFiles();

    if (files.isEmpty) {
      return null;
    }
    _gtfsData = GTFSData(files);
    return _gtfsData;
  }

   Future<Map<String, CSVTable>> loadFiles() async {
    Map<String, CSVTable> files = {};
    final dir = Directory(paths.extractDir);
    final dirFiles = await dir.list().toList();
    for (FileSystemEntity e in dirFiles) {
      if (e is! File) continue;

      File file = e;
      if (!file.path.endsWith(".txt")) continue;
      files[basename(file.path)] = CSVTable.fromFile(file);
    }
    return files;
  }

  Future<bool> downloadFile({OnProgress? onProgress}) async {
    // TODO: Remove or handle getDownloadWhenWifi

    final lastUpdate = await getDownloadDate();

    late http.StreamedResponse response;
    final client = http.Client();
    final List<int> bytes = [];
    var received = 0;
    try {
      DatasetMetadata metadata = await getFileMetaData();
      if (lastUpdate != null && metadata.updateTime.isBefore(lastUpdate)) {
        print("Download abord recent data found");
        return true;
      }
      print("Start Downloading GTFS: Last : $lastUpdate, New :${metadata.updateTime}");

      final request = http.Request("GET", metadata.ressourceUri);
      response = await client.send(request);
      final total = response.contentLength ?? 0;

      await for (var value in response.stream) {
        bytes.addAll(value);
        received += value.length;
        onProgress?.call(received / total);
      }
    } on Exception {
      return false;
    }

    final file = File(paths.gtfsFilePath);
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);

    await extractZipFile();
    await setDownloadDate(DateTime.now());

    return true;
  }

  Future<void> forceDownload({void Function(double value)? onProgress}) async {
    await setDownloadDate(null);
    await downloadFile(onProgress: onProgress);
    _gtfsData = await loadFile();
  }

  Future<void> setDownloadDate(DateTime? time) async {
    final file = File("${paths.extractDir}download-date");
    if (time == null) {
      if (await file.exists()) {
        await file.delete();
      }
      return;
    }

    await file.writeAsString(time.millisecondsSinceEpoch.toString());
  }

  Future<DateTime?> getDownloadDate() async {
    final file = File("${paths.extractDir}download-date");

    print(file.path);
    if (!await file.exists()) return null;
    final content = await file.readAsString();
    final value = int.tryParse(content);
    if (value == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  Future<DatasetMetadata> getFileMetaData() async {
    http.Response res = await http.get(dataSetAPI);
    Map<String, dynamic> json = jsonDecode(utf8.decode(res.bodyBytes));

    var ressource =
        json["attachments"].firstWhere((e) => e["title"] == "gtfs.zip");

    var uri = Uri.parse(ressource["url"]);
    DateTime updateTime = DateTime.parse(ressource["updatedAt"]);

    return DatasetMetadata(uri, updateTime);
  }

  Future extractZipFile() async {
    await extractFileToDisk(paths.gtfsFilePath, paths.extractDir);
  }
}
