import 'package:better_bus_core/core.dart';
import 'package:better_bus_core/src/models/waypoint.dart';
import 'package:latlong2/latlong.dart';


class VitalisRoute {
  VitalisRoute({required this.id, required this.itinerary, required this.polyLines});

  VitalisRoute.fromJson(Map<String, dynamic> json): this(
    id: json["id"],
    itinerary: json["itinerary"].map((e) => RoutePassage.fromJson(e)).toList().cast<RoutePassage>(),
    polyLines: json["polylines"].map((e) => shapeFromJson(e)).toList().cast<LineShape>(),
  );

  static LineShape shapeFromJson(Map<String, dynamic> json) {
    List<WayPoint> wayPoints = [];
    List<double> line = json["lineString"].cast<double>();
    // TODO: z Do it another way...
    final t = DateTime.now();
    for(var i = 0; i < line.length; i+=2) {
      wayPoints.add(WayPoint(position: LatLng(line[i], line[i+1]), time: t));
    }
    return LineShape(wayPoints);
  }

  String id;
  List<RoutePassage> itinerary;
  List<LineShape> polyLines;

  Duration get timeTravel  {
    Duration sum = const Duration();
    for(RoutePassage passage in itinerary) {
      sum += passage.travelTime;
    }
    return sum;
  }

  int get busDistanceTravel  {
    int sum = 0;
    for(RoutePassage passage in itinerary) {
      if (passage.lines == null){
        continue;
      }
      sum += passage.travelDistance;
    }
    return sum;
  }

  int get walkDistanceTravel  {
    int sum = 0;
    for(RoutePassage passage in itinerary) {
      if (passage.lines != null){
        continue;
      }
      sum += passage.travelDistance;
    }
    return sum;
  }
}


class RoutePassage {
  RoutePassage({
    required this.startPlace,
    required this.endPlace,
    required this.startTime,
    required this.endTime,
    this.lines,
    required this.instruction,
    required this.type,
    required this.travelTime,
    required this.travelDistance,
  });

  RoutePassage.fromJson(Map<String, dynamic> json): this(
    startPlace: json["start"],
    endPlace: json["end"],

    startTime: DateTime.parse(json["startTime"]),
    endTime: DateTime.parse(json["endTime"]),

    lines: json["line"] != null ? RouteLine.fromJson(json["line"]) : null,

    instruction: json["instruction"],

    travelDistance: json["travelDistance"],
    travelTime: Duration(seconds: json["travelTime"]),

    type: json["type"],
  );

  String startPlace;
  String endPlace;

  DateTime startTime;
  DateTime endTime;

  RouteLine? lines;

  String instruction;

  Duration travelTime;
  int travelDistance;

  String type;
}



class RouteLine  extends BusLine {
  RouteLine({required this.name, required this.destination, required int colorInt}):
        super(name, destination, colorInt, directions: {});

  RouteLine.fromJson(Map<String, dynamic> json): this(
    name: json["lineName"],
    destination: json["destination"],
    colorInt: colorFromHex(json["lineBackground"]),
  );

  String name;
  String destination;

}
