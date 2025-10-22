import 'package:flutter/material.dart';
import 'trip_planner_screen.dart';
import 'weather_screen.dart';
import 'food_suggestions_screen.dart';
import 'bookmarked_food_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('EPIC NOMADS 🧭'),
        backgroundColor: const Color(0xFFE8D8C4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Plan your next journey effortlessly ✨",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 🏙️ Destination Input
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "Enter Destination City",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 🌍 Trip Planner Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TripPlannerScreen()),
                );
              },
              icon: const Icon(Icons.flight_takeoff),
              label: const Text("Trip Planner"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD5BDAF)),
            ),
            const SizedBox(height: 10),

            // 🌤️ Weather Button
            ElevatedButton.icon(
              onPressed: () {
                if (cityController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeatherScreen(city: cityController.text),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.cloud),
              label: const Text("Check Weather"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD5BDAF)),
            ),
            const SizedBox(height: 10),

            // 🍽️ Food Suggestions Button
            ElevatedButton.icon(
              onPressed: () {
                if (cityController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodSuggestionsScreen(city: cityController.text),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text("Food Suggestions"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD5BDAF)),
            ),
            const SizedBox(height: 10),

            // 📌 Bookmarked Foods Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarkedFoodScreen()),
                );
              },
              icon: const Icon(Icons.bookmarks),
              label: const Text("Bookmarked Foods"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD5BDAF)),
            ),
          ],
        ),
      ),
    );
  }
}
