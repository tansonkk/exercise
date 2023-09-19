import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  final String key = 'AIzaSyBJ63O8ETKwJCc3zVtdDzQ-vdjW4KcntTU';

  Future<String> getPlaceId(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";

    var response = await http.get(Uri.parse(url));

    var json = jsonDecode(response.body) as Map<String, dynamic>;

    var placeId = json['candidates'][0]['place_id'] as String;

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    print(" placeId : " + placeId);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body) as Map<String, dynamic>;

    return json;
  }

  Future<List<LatLng>> getDirection(LatLng origin, LatLng destination) async {
    final String key = 'AIzaSyBJ63O8ETKwJCc3zVtdDzQ-vdjW4KcntTU';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<LatLng> routePoints = [];

      if (decoded['status'] == 'OK') {
        final List<dynamic> steps = decoded['routes'][0]['legs'][0]['steps'];
        routePoints.add(origin);

        for (dynamic step in steps) {
          final String polyline = step['polyline']['points'];
          final List<LatLng> decodedPolyline = _decodePolyline(polyline);
          routePoints.addAll(decodedPolyline);
        }

        routePoints.add(destination);
      }

      return routePoints;
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }

    return poly;
  }

  Future<int> getDuration(LatLng origin, LatLng? destination) async {
    final String key = 'AIzaSyBJ63O8ETKwJCc3zVtdDzQ-vdjW4KcntTU';

    final String baseUrl =
        'https://maps.googleapis.com/maps/api/directions/json?';
    final String url = '$baseUrl&origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination!.latitude},${destination.longitude}'
        '&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final int durationInSeconds =
          data['routes'][0]['legs'][0]['duration']['value'];
      print(durationInSeconds);
      return durationInSeconds;
    } else {
      throw Exception('Failed to fetch duration');
    }
  }

  double getDistance(LatLng origin, LatLng destination) {
    const double earthRadius = 6371.0; // Radius of the Earth in kilometers

    double lat1 = origin.latitude;
    double lon1 = origin.longitude;
    double lat2 = destination.latitude;
    double lon2 = destination.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c; // Distance in kilometers
    return distance * 1000; // Convert to meters
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
}
