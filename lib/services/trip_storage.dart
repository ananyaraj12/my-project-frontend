import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip_model.dart';

class TripStorage {
  static const String _key = "recent_trips";

  static Future<void> saveTrip(TripModel trip) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    raw.insert(0, jsonEncode(trip.toJson()));

    if (raw.length > 5) {
      raw.removeLast();
    }

    await prefs.setStringList(_key, raw);
  }

  static Future<List<TripModel>> getTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    return raw
        .map((e) => TripModel.fromJson(jsonDecode(e)))
        .toList();
  }
}
