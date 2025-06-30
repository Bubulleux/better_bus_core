import 'dart:io';

import 'package:better_bus_core/core.dart';
import 'package:better_bus_core/src/models/gtfs/protoc/gtfs-realtime.pb.dart';
import 'package:better_bus_core/src/models/gtfs/rt_timetable.dart';
import 'package:http/http.dart' as http;


class GTFSRTProvider extends GTFSProvider {

  FeedMessage? message;


  GTFSRTProvider({required super.downloader});

  Future test() async {
    await init();

    final station = (await getStations()).firstWhere((e) => e.name.startsWith("Angoulême Cathédrale"));
    final times = await getTimetable(station);
    for (var t in times.getNext()){
      print(t);
    }
  }

  @override
  Future<GTFSRTTimetable> getTimetable(Station station, {DateTime? time}) async {
    await checkData();
    final timetable = await super.getTimetable(station, time: time);
    return GTFSRTTimetable(timetable, message!);
  }

  Future checkData() async {
    message = await downloader.fetchRealtime();
  }


  // Future _loadFile() async {
  //     final file = File("/home/ulysse/Projects/better_bus_workspace/core/lib/src/protoc/mobius-angouleme");
  //
  //     final data = await file.readAsBytes();
  //     print(data.length);
  //
  //     final message = FeedMessage.fromBuffer(data);
  //     print(message.entity.first);
  //
  // }
}
