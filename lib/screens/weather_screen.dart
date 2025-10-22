import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import '../services/weather_services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // 📌 For time formatting

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  late String destination;
  IconData _weatherIcon = WeatherIcons.day_sunny;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    destination = ModalRoute.of(context)!.settings.arguments as String;
    _getWeather();
  }

  Future<void> _getWeather() async {
    final data = await _weatherService.fetchWeather(destination);
    setState(() {
      _weatherData = data;
      _isLoading = false;
      _weatherIcon = _getWeatherIcon(data?['weather'][0]['main'] ?? '');
    });
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
        return WeatherIcons.cloud;
      case 'rain':
        return WeatherIcons.rain;
      case 'drizzle':
        return WeatherIcons.showers;
      case 'thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'snow':
        return WeatherIcons.snow;
      case 'mist':
      case 'fog':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.day_sunny;
    }
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          //Image.asset('assets/bg.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else if (_weatherData != null)
            _buildWeatherView()
          else
            const Center(
              child: Text(
                'Could not load weather data.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeatherView() {
    final temp = _weatherData!['main']['temp'];
    final desc = _weatherData!['weather'][0]['description'];
    final city = _weatherData!['name'];

    final sunrise = _weatherData!['sys']['sunrise'];
    final sunset = _weatherData!['sys']['sunset'];

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              const Text(
                'Weather',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
          const SizedBox(height: 50),
          Icon(_weatherIcon, size: 80, color: Colors.white),
          const SizedBox(height: 15),
          Text(
            city,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$temp °C',
            style: const TextStyle(fontSize: 26, color: Colors.white),
          ),
          Text(
            desc.toUpperCase(),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(
                    WeatherIcons.sunrise,
                    color: Colors.orangeAccent,
                    size: 40,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatTime(sunrise),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Text(
                    'Sunrise',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(
                    WeatherIcons.sunset,
                    color: Colors.deepOrange,
                    size: 40,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatTime(sunset),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Text(
                    'Sunset',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
