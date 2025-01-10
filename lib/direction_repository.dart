import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'directions.dart';

class DirectionRepository {
  static const baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";
  static final Dio _dio = Dio();
  static final _googleAPIKey = "AIzaSyC2YuI8OaA05zovbtJdlC2VkAH-2ljOSRk";

  static Future<Directions?> getDirection(
      LatLng origin, LatLng destination) async {
    print("get direction called");
    final response = await _dio.get(baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': _googleAPIKey
    });

    if (response.statusCode == 200) {
      print("got data");
      return Directions.fromMap(response.data);
    }

    print("no data catch up");
    return null;
  }
}
