import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
//import 'screens/trip_planner_screen.dart';
import 'screens/weather_screen.dart';


void main() {
  runApp(const EpicNomadsApp());
}

class EpicNomadsApp extends StatelessWidget {
  const EpicNomadsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epic Nomads',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF8EDEB),
      ),
      home: const HomeScreen(),
      routes: {'/weather': (context) => const WeatherScreen()},
    );
  }
}
