import 'package:better_bus_core/core.dart';

class WayPoint extends Location {
  final DateTime time;
  WayPoint({required super.position, required this.time});
}