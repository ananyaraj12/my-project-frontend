import 'package:flutter/material.dart';
import 'package:epic_nomads/services/weather_services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;

  Future<void> fetchWeather(String city) async {
    setState(() => isLoading = true);
    final data = await WeatherService().fetchWeather(city);
    setState(() {
      weatherData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        centerTitle: true,
        title: const Text(
          'Weather Forecast',
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Check Weather by City',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A3C31),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                filled: true,
                fillColor: const Color(0xFFF3E7E0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAB9A3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  fetchWeather(_controller.text);
                }
              },
              child: const Text(
                'Check Weather',
                style: TextStyle(
                  color: Color(0xFF4A3C31),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (isLoading)
              const CircularProgressIndicator(color: Color(0xFF4A3C31))
            else if (weatherData != null)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E0D3),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${weatherData!['name']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3C31),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${weatherData!['main']['temp']}°C',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B5B50),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${weatherData!['weather'][0]['description']}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4A3C31),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Humidity: ${weatherData!['main']['humidity']}%  |  Wind: ${weatherData!['wind']['speed']} m/s',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B5B50),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Text(
                'No weather data yet. Try searching a city!',
                style: TextStyle(color: Color(0xFF6B5B50)),
              ),
          ],
        ),
      ),
    );
  }
}
