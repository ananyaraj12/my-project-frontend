import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _token;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get email => _email;

  final String baseUrl = "http://localhost:5000/api/auth";

  Null get userName => null;

  Future<void> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    _isLoading = false;
    if (response.statusCode == 200) {
      await login(email, password);
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _email = email;
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('email', email);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse('$baseUrl/forgot-password');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _email = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final savedEmail = prefs.getString('email');
    if (savedToken != null && savedEmail != null) {
      _token = savedToken;
      _email = savedEmail;
      _isLoggedIn = true;
    }
    notifyListeners();
  }
}
