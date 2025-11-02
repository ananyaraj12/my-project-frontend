import 'package:flutter/material.dart';
import 'package:epic_nomads/services/api_service.dart';

class FoodSuggestionsScreen extends StatefulWidget {
  const FoodSuggestionsScreen({super.key});

  @override
  State<FoodSuggestionsScreen> createState() => _FoodSuggestionsScreenState();
}

class _FoodSuggestionsScreenState extends State<FoodSuggestionsScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> foodPlaces = [];
  bool isLoading = false;

  Future<void> fetchFood(String city) async {
    setState(() => isLoading = true);
    final data = await ApiService.fetchFood(city);
    setState(() {
      foodPlaces = data ?? [];
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
          'Food Finder',
          style: TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Discover the best food spots!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A3C31),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                filled: true,
                fillColor: const Color(0xFFF3E7E0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAB9A3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  fetchFood(_controller.text);
                }
              },
              child: const Text(
                'Find Food',
                style: TextStyle(
                  color: Color(0xFF4A3C31),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (isLoading)
              const CircularProgressIndicator(color: Color(0xFF4A3C31))
            else if (foodPlaces.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: foodPlaces.length,
                  itemBuilder: (context, index) {
                    final place = foodPlaces[index];
                    final name = place['name'] ?? 'Unnamed Place';
                    final location =
                        place['location']?['formatted_address'] ?? 'Unknown area';
                    final rating =
                        place['rating']?.toString() ?? 'No rating';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E0D3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.restaurant_menu,
                            color: Color(0xFF4A3C31)),
                        title: Text(
                          name,
                          style: const TextStyle(
                            color: Color(0xFF4A3C31),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$location\n⭐ $rating',
                          style: const TextStyle(
                            color: Color(0xFF6B5B50),
                            height: 1.3,
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              )
            else
              const Text(
                'No food spots found. Try another city!',
                style: TextStyle(
                  color: Color(0xFF6B5B50),
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
