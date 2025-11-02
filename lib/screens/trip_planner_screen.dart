import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  String travelMode = 'Train';
  String stayType = 'Hotel';
  DateTime? selectedDate;
  Map<String, dynamic>? weatherData;
  List<dynamic> attractions = [];
  bool isLoading = false;

  Future<void> planTrip() async {
    if (_cityController.text.isEmpty) return;
    setState(() => isLoading = true);

    final city = _cityController.text;
    final weather = await ApiService.fetchWeather(city);
    final tourist = await ApiService.fetchTourist(city);

    setState(() {
      weatherData = weather;
      attractions = tourist ?? [];
      isLoading = false;
    });
  }

  double calculateBudget() {
    double base = 1200;
    double multiplier = 1;
    if (travelMode == 'Flight') multiplier *= 2.2;
    if (travelMode == 'Bus') multiplier *= 0.8;
    if (stayType == 'Hostel') multiplier *= 0.7;
    if (stayType == 'Homestay') multiplier *= 1.1;

    int days = int.tryParse(_daysController.text) ?? 1;
    return base * multiplier * days;
  }

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        centerTitle: true,
        title: const Text(
          'Trip Planner',
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plan Your Perfect Trip ✈️',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A3C31),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_cityController, 'Enter city name'),
            const SizedBox(height: 15),
            _buildTextField(_daysController, 'Number of days'),
            const SizedBox(height: 15),
            _buildDropdown('Travel Mode', ['Flight', 'Train', 'Bus'], travelMode,
                (val) => setState(() => travelMode = val!)),
            const SizedBox(height: 15),
            _buildDropdown('Stay Type', ['Hotel', 'Hostel', 'Homestay'], stayType,
                (val) => setState(() => stayType = val!)),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: selectDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E7E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  selectedDate == null
                      ? 'Select Travel Date'
                      : 'Selected: ${DateFormat.yMMMd().format(selectedDate!)}',
                  style: const TextStyle(color: Color(0xFF4A3C31)),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDAB9A3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                onPressed: planTrip,
                child: const Text(
                  'Plan My Trip',
                  style: TextStyle(
                    color: Color(0xFF4A3C31),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF4A3C31)),
              ),
            if (weatherData != null) _buildWeatherCard(weatherData!),
            if (attractions.isNotEmpty) _buildAttractionsList(),
            const SizedBox(height: 20),
            if (selectedDate != null)
              Text(
                '⏳ ${selectedDate!.difference(DateTime.now()).inDays} days left until your trip!',
                style: const TextStyle(
                  color: Color(0xFF6B5B50),
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Estimated Budget: ₹${calculateBudget().toStringAsFixed(0)}',
              style: const TextStyle(
                color: Color(0xFF4A3C31),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDAB9A3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Trip saved successfully!'),
                  ));
                },
                child: const Text(
                  'Save My Trip',
                  style: TextStyle(
                    color: Color(0xFF4A3C31),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3E7E0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E7E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildWeatherCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
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
            '${data['name']}',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3C31)),
          ),
          Text(
            '${data['main']['temp']}°C, ${data['weather'][0]['description']}',
            style: const TextStyle(color: Color(0xFF6B5B50)),
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Attractions 🌆',
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...attractions.map((a) {
          final name = a['properties']['name'] ?? 'Unnamed';
          final dist = (a['properties']['dist'] ?? 0).toStringAsFixed(0);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E0D3),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.place, color: Color(0xFF4A3C31)),
              title: Text(
                name,
                style: const TextStyle(
                    color: Color(0xFF4A3C31), fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '$dist m away',
                style: const TextStyle(color: Color(0xFF6B5B50)),
              ),
            ),
          );
        }),
      ],
    );
  }
}
