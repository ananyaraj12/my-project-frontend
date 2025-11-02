import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'weather_screen.dart';
import 'trip_planner_screen.dart';
import 'food_suggestions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        title: const Text(
          'Epic Nomads',
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFDAB9A3),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF4A3C31)),
            onPressed: () {
              auth.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${auth.email ?? 'Traveler'} 👋',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A3C31),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Where will your next journey take you?',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B5B50)),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                children: [
                  _buildTile(
                    context,
                    icon: Icons.cloud,
                    title: 'Weather',
                    color: const Color(0xFFF1E0D3),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WeatherScreen()),
                    ),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.restaurant_menu,
                    title: 'Food Finder',
                    color: const Color(0xFFF1E0D3),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FoodSuggestionsScreen(),
                      ),
                    ),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.map_rounded,
                    title: 'Trip Planner',
                    color: const Color(0xFFF1E0D3),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TripPlannerScreen(),
                      ),
                    ),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.bookmark_rounded,
                    title: 'Bookmarks',
                    color: const Color(0xFFF1E0D3),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bookmarks coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.brown.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: const Color(0xFF4A3C31)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A3C31),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
