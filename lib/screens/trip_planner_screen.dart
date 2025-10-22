import 'package:flutter/material.dart';
//import 'weather_screen.dart';

class TripPlannerScreen extends StatelessWidget {
  final String destination;
  const TripPlannerScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDEBD0),
      appBar: AppBar(
        title: Text("Trip Planner - $destination"),
        backgroundColor: Colors.brown[400],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/weather', arguments: destination);
          },
          child: const Text("Check Weather"),
        ),
      ),
    );
  }
}
