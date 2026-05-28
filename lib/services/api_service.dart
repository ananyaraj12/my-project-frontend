import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _wifiIp = '10.71.152.119';

  static final String _base = kIsWeb
      ? 'http://localhost:5000'
      : 'http://$_wifiIp:5000';
  static Future<Map<String, double>?> fetchCityCoordinates(String city) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$city&format=json&limit=1',
    );

    final res = await http.get(
      uri,
      headers: {'User-Agent': 'epic-nomads-app', 'Accept': 'application/json'},
    );

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);
    if (data == null || data.isEmpty) return null;

    return {
      'lat': double.parse(data[0]['lat']),
      'lon': double.parse(data[0]['lon']),
    };
  }

  static Future<Map<String, dynamic>?> fetchWeather(String city) async {
    try {
      final res = await http.get(Uri.parse('$_base/api/weather/$city'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      debugPrint('Weather error: $e');
    }
    return null;
  }

  static Future<List<dynamic>?> fetchTourist(String city) async {
    try {
      final res = await http.get(Uri.parse('$_base/api/tourist/$city'));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      debugPrint('Tourist error: $e');
    }
    return null;
  }

  static Future<List<dynamic>?> fetchFoodNearby(double lat, double lon) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/api/food/nearby?lat=$lat&lon=$lon'),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      debugPrint('Food error: $e');
    }
    return null;
  }
}
