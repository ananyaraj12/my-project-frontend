import 'dart:convert';
import 'package:http/http.dart' as http;

const BACKEND_BASE = 'http://localhost:5000';

class ApiService {
  static Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url = Uri.parse('$BACKEND_BASE/api/weather/$city');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('Weather Error: ${res.body}');
    }
    return null;
  }

  static Future<List<dynamic>?> fetchFood(String city) async {
    final url = Uri.parse('$BACKEND_BASE/api/food/$city');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('Food Error: ${res.body}');
    }
    return null;
  }

  static Future<List<dynamic>?> fetchTourist(String city) async {
    final url = Uri.parse('$BACKEND_BASE/api/tourist/$city');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('Tourist Error: ${res.body}');
    }
    return null;
  }

  static Future<bool> signup(String name, String email, String password) async {
    final url = Uri.parse('$BACKEND_BASE/api/auth/signup');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return res.statusCode == 201;
  }

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$BACKEND_BASE/api/auth/login');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return res.statusCode == 200;
  }
}
