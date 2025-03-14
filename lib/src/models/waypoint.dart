import 'package:better_bus_core/core.dart';

class WayPoint extends Location {
  // TODO: FIX IT
  final DateTime time = DateTime.now();
  WayPoint({required super.position, time});
}