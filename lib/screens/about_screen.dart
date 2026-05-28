import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        centerTitle: true,
        title: const Text(
          "About Epic Nomads",
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(
              Icons.explore_rounded,
              size: 60,
              color: Color(0xFF4A3C31),
            ),
            SizedBox(height: 16),
            Text(
              "Epic Nomads",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3C31),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Plan trips smarter. Travel better.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B5B50),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Features",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3C31),
              ),
            ),
            SizedBox(height: 6),
            Text("• Personalized trip planning",
                style: TextStyle(color: Color(0xFF6B5B50))),
            Text("• Weather & food discovery",
                style: TextStyle(color: Color(0xFF6B5B50))),
            Text("• Budget estimation",
                style: TextStyle(color: Color(0xFF6B5B50))),
            Text("• Saved recent trips",
                style: TextStyle(color: Color(0xFF6B5B50))),
            SizedBox(height: 20),
            Text(
              "Made for travelers who love simplicity.",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B5B50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
