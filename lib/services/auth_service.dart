import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static const String _wifiIp = '10.71.152.119';

  late final String baseUrl;

  AuthService() {
    if (kIsWeb) {
      baseUrl = "http://localhost:5000/api/auth";
    } else {
      baseUrl = "http://$_wifiIp:5000/api/auth";
    }
  }

  String? token;
  String? email;
  String? name;

  bool get isLoggedIn => token != null;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    email = prefs.getString('email');
    name = prefs.getString('name');
    notifyListeners();
  }

  Future<void> _saveUser(String t, String e, String n) async {
    token = t;
    email = e;
    name = n;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', t);
    await prefs.setString('email', e);
    await prefs.setString('name', n);
    notifyListeners();
  }

  Future<void> _clearUser() async {
    token = null;
    email = null;
    name = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('name');
    notifyListeners();
  }

  Future<String?> signup(
    String fullName,
    String userEmail,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": fullName,
          "email": userEmail,
          "password": password,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        return null;
      } else {
        return data["message"]?.toString() ?? "Signup failed";
      }
    } catch (e) {
      return "Unable to connect to server";
    }
  }

  Future<String?> login(String userEmail, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": userEmail, "password": password}),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final t = data["token"];
        final user = data["user"];

        if (t is String && user is Map) {
          final e = user["email"]?.toString() ?? "";
          final n = user["name"]?.toString() ?? "";
          if (e.isNotEmpty && n.isNotEmpty) {
            await _saveUser(t, e, n);
          }
        }
        return null;
      } else {
        return data["message"]?.toString() ?? "Login failed";
      }
    } catch (e) {
      return "Unable to connect to server";
    }
  }

  Future<String?> forgotPassword(String userEmail) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": userEmail}),
      );

      if (res.statusCode == 200) {
        return null;
      }

      final data = jsonDecode(res.body);
      return data["message"]?.toString() ?? "Something went wrong";
    } catch (e) {
      return "Unable to connect to server";
    }
  }

  Future<void> logout() async {
    await _clearUser();
  }
}
