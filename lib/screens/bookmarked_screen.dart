import 'package:flutter/material.dart';

class BookmarkedScreen extends StatelessWidget {
  const BookmarkedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Places'),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: const Color(0xFFF8EDEB),
      body: const Center(
        child: Text(
          'Your bookmarked destinations will appear here!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
