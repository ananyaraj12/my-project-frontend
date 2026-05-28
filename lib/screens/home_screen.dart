import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'weather_screen.dart';
import 'trip_planner_screen.dart';
import 'food_suggestions_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController controller;
  late Animation<double> fade;

  final pages =  [
    _Dashboard(),
    WeatherScreen(),
    TripPlannerScreen(),
    FoodSuggestionsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    fade = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.forward();
  }

  void switchTab(int index) {
    controller.reset();
    setState(() => currentIndex = index);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        title: const Text(
          'Epic Nomads',
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF4A3C31)),
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          )
        ],
      ),
      body: FadeTransition(
        opacity: fade,
        child: pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: switchTab,
        backgroundColor: const Color(0xFFF1E0D3),
        selectedItemColor: const Color(0xFF4A3C31),
        unselectedItemColor: const Color(0xFF6B5B50),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_rounded),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Trip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_rounded),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi ${auth.name ?? "Nomad"} 👋",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A3C31),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Ready for your next journey?",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B5B50),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: const [
                _QuickCard(
                  icon: Icons.cloud_outlined,
                  title: "Weather",
                  subtitle: "Check forecast",
                ),
                _QuickCard(
                  icon: Icons.map_outlined,
                  title: "Trip Planner",
                  subtitle: "Plan journeys",
                ),
                _QuickCard(
                  icon: Icons.restaurant_outlined,
                  title: "Food Finder",
                  subtitle: "Nearby cafes",
                ),
                _QuickCard(
                  icon: Icons.person_outline,
                  title: "Profile",
                  subtitle: "Saved trips",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1E0D3),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color(0xFF4A3C31)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3C31),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B5B50),
            ),
          ),
        ],
      ),
    );
  }
}
