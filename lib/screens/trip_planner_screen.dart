import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'trip_result_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final cityCtrl = TextEditingController();
  final daysCtrl = TextEditingController(text: "3");
  final peopleCtrl = TextEditingController(text: "1");

  DateTime? travelDate;
  String mood = "Chill";

  void pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) setState(() => travelDate = d);
  }

  double calculateBudget() {
    final days = int.tryParse(daysCtrl.text) ?? 3;
    final people = int.tryParse(peopleCtrl.text) ?? 1;

    double basePerDay = 1000;

    if (mood == "Explore") basePerDay += 300;
    if (mood == "Adventure") basePerDay += 600;

    return basePerDay * days * people;
  }

  List<String> itineraryForCity(String city) {
    return [
      "Arrival and explore nearby areas",
      "Visit popular attractions and cafes",
      "Local markets and relaxed evening",
    ];
  }

  void planTrip() {
    if (cityCtrl.text.trim().isEmpty || travelDate == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripResultScreen(
          city: cityCtrl.text.trim(),
          mood: mood,
          itinerary: itineraryForCity(cityCtrl.text.trim()),
          packingList: const [
            "Comfortable clothes",
            "Phone charger",
            "Personal essentials"
          ],
          totalBudget: calculateBudget(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cityCtrl.dispose();
    daysCtrl.dispose();
    peopleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        centerTitle: true,
        title: const Text(
          "Trip Planner",
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          input(cityCtrl, "Destination city"),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: input(daysCtrl, "Days", number: true)),
              const SizedBox(width: 10),
              Expanded(child: input(peopleCtrl, "People", number: true)),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E7E0),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Color(0xFF4A3C31)),
                  const SizedBox(width: 10),
                  Text(
                    travelDate == null
                        ? "Select travel date"
                        : DateFormat.yMMMd().format(travelDate!),
                    style: const TextStyle(color: Color(0xFF4A3C31)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Trip Mood",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3C31),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ["Chill", "Explore", "Adventure"]
                .map(
                  (m) => ChoiceChip(
                    label: Text(m),
                    selected: mood == m,
                    onSelected: (_) => setState(() => mood = m),
                    selectedColor: const Color(0xFFDAB9A3),
                    backgroundColor: const Color(0xFFF3E7E0),
                    labelStyle:
                        const TextStyle(color: Color(0xFF4A3C31)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 26),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDAB9A3),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: planTrip,
            child: const Text(
              "Plan My Trip",
              style: TextStyle(
                color: Color(0xFF4A3C31),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget input(
    TextEditingController c,
    String hint, {
    bool number = false,
  }) {
    return TextField(
      controller: c,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3E7E0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
