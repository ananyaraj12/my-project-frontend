import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trip_model.dart';

class TripStorage {
  static const String key = "saved_trips";

  static Future<void> saveTrip(TripModel trip) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(key) ?? [];

    existing.add(jsonEncode(trip.toJson()));
    await prefs.setStringList(key, existing);
  }

  static Future<List<TripModel>> getTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList(key) ?? [];

    return data
        .map((e) => TripModel.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList();
  }
}
