import 'package:flutter/material.dart';
import '../services/bookmark_service.dart';
import '../widgets/food_card.dart';

class BookmarkedFoodScreen extends StatefulWidget {
  const BookmarkedFoodScreen({super.key});

  @override
  State<BookmarkedFoodScreen> createState() => _BookmarkedFoodScreenState();
}

class _BookmarkedFoodScreenState extends State<BookmarkedFoodScreen> {
  @override
  Widget build(BuildContext context) {
    final bookmarks = BookmarkService.getBookmarks();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Foods 📌'),
      ),
      body: bookmarks.isEmpty
          ? const Center(child: Text('No bookmarks yet 😄'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return FoodCard(food: bookmarks[index]);
              },
            ),
    );
  }
}
