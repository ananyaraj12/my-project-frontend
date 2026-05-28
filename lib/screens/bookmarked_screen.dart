import 'package:flutter/material.dart';

class BookmarkedScreen extends StatelessWidget {
  const BookmarkedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4A3C31);
    const secondary = Color(0xFF6B5B50);

    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        centerTitle: true,
        title: const Text(
          'Bookmarks',
          style: TextStyle(color: primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E0D3),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bookmark_border_rounded,
                  size: 64,
                  color: primary,
                ),
                const SizedBox(height: 14),
                const Text(
                  'No bookmarks yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Save your favorite places\nand plan trips faster',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: secondary),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAB9A3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Start exploring ✈️',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
