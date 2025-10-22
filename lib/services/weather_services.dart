import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'bd90b1d27e97f7b195550ff52595e2a5'; // Replace this

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load weather data');
      return null;
    }
  }
}
