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
          children: [
            const Text(
              'Check weather before you travel ☀️',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A3C31),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city',
                filled: true,
                fillColor: const Color(0xFFF3E7E0),
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAB9A3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
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
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator(color: Color(0xFF4A3C31))
            else if (weatherData != null)
              Expanded(
                child: SingleChildScrollView(
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
                      children: [
                        Text(
                          weatherData!['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A3C31),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${weatherData!['main']['temp']}°C',
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6B5B50),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          weatherData!['weather'][0]['description'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF4A3C31),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _stat(
                              Icons.water_drop,
                              '${weatherData!['main']['humidity']}%',
                              'Humidity',
                            ),
                            _stat(
                              Icons.air,
                              '${weatherData!['wind']['speed']} m/s',
                              'Wind',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              const Text(
                'Search a city to see weather details',
                style: TextStyle(color: Color(0xFF6B5B50)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4A3C31)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A3C31),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B5B50),
          ),
        ),
      ],
    );
  }
}
