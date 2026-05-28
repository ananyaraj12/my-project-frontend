import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/trip_storage.dart';
import '../models/trip_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<TripModel> trips = [];

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  Future<void> loadTrips() async {
    final data = await TripStorage.getTrips();
    setState(() => trips = data);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          userCard(auth),
          const SizedBox(height: 24),
          section("Recent Trips"),
          trips.isEmpty ? emptyTrips() : tripList(),
          const SizedBox(height: 28),
          section("About"),
          aboutCard(),
        ],
      ),
    );
  }

  Widget userCard(AuthService auth) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E0D3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFDAB9A3),
            child: Icon(Icons.person, color: Color(0xFF4A3C31), size: 32),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                auth.name ?? "Traveler",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3C31),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                auth.email ?? "",
                style: const TextStyle(
                  color: Color(0xFF6B5B50),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tripList() {
    return Column(
      children: trips.map((t) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1E0D3),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.city,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3C31),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.date,
                    style: const TextStyle(
                      color: Color(0xFF6B5B50),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                "₹${t.budget.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3C31),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget emptyTrips() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        "No trips planned yet",
        style: TextStyle(color: Color(0xFF6B5B50)),
      ),
    );
  }

  Widget aboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E0D3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Epic Nomads",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3C31),
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Smart trip planning, food discovery & travel budgeting",
            style: TextStyle(color: Color(0xFF6B5B50), fontSize: 13),
          ),
          SizedBox(height: 6),
          Text(
            "Version 1.0.0",
            style: TextStyle(color: Color(0xFF6B5B50), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget section(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        t,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A3C31),
          fontSize: 18,
        ),
      ),
    );
  }
}
