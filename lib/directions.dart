import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  Directions(
      this.bounds, this.polylinePoints, this.totalDistance, this.totalDuration);

  factory Directions.fromMap(Map<String, dynamic> map) {
    final data = Map<String, dynamic>.from(map['routes'][0]);

    final northeast = LatLng(data['bounds']['northeast']['lat'], data['bounds']['northeast']['lng']);
    final southwest = LatLng(data['bounds']['southwest']['lat'], data['bounds']['southwest']['lng']);
    final bounds = LatLngBounds(southwest: southwest, northeast: northeast);


    String distance = '';
    String duration = "";

    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];

      duration = leg['duration']['text'];
      distance = leg['distance']['text'];
    }

    return Directions(
        bounds,
        PolylinePoints().decodePolyline(data['overview_polyline']['points']),
        duration,
        distance);
  }
}
