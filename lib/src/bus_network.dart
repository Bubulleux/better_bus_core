import 'dart:io';

import 'models/bus_line.dart';
import 'models/line_timetable.dart';
import 'models/station.dart';
import 'models/timetable.dart';
import 'models/traffic_info.dart';
import 'package:meta/meta.dart';
import 'package:flutter/scheduler.dart';

abstract class BusNetwork {

  Future<bool>? waitInit;

  BusNetwork() {
    waitInit = init();
  }

  // Initiate and return true if is available
  // Need to be call at the start of the function and returned at the end
  @mustCallSuper
  @protected
  Future<bool> init() {
    if (waitInit != null) return waitInit!;
    return Future.value(true);
  }
  // Return if available
  bool isAvailable();

  // Return a list of all bus station on the network
  Future<List<Station>> getStations();

  // Return a map of all the Line in the network
  // Key is the short name of the line
  Future<Map<String,BusLine>> getAllLines();

  // Return all the line passing at the bus station
  Future<List<BusLine>> getPassingLines(Station station);

  // Return the timetable of the station
  Future<Timetable> getTimetable(Station station);

  // Return the timetable of the Line in the Station Only
  Future<LineTimetable> getLineTimetable(Station station, BusLine line,int direction, DateTime date);

  // Return a list of all available Traffic info
  Future<List<InfoTraffic>> getTrafficInfos();
}
