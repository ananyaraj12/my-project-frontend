import 'package:flutter/material.dart';
import '../services/food_service.dart';
import '../widgets/food_card.dart';
import 'bookmarked_food_screen.dart';

class FoodSuggestionsScreen extends StatefulWidget {
  final String city;
  const FoodSuggestionsScreen({super.key, required this.city});

  @override
  State<FoodSuggestionsScreen> createState() => _FoodSuggestionsScreenState();
}

class _FoodSuggestionsScreenState extends State<FoodSuggestionsScreen> {
  late List<Map<String, String>> foods;

  @override
  void initState() {
    super.initState();
    foods = FoodService.getFoodForCity(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Famous Foods in ${widget.city}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarkedFoodScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, index) {
          return FoodCard(food: foods[index]);
        },
      ),
    );
  }
}
