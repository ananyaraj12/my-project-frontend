import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class FoodSuggestionsScreen extends StatefulWidget {
  const FoodSuggestionsScreen({super.key});

  @override
  State<FoodSuggestionsScreen> createState() => _FoodSuggestionsScreenState();
}

class _FoodSuggestionsScreenState extends State<FoodSuggestionsScreen> {
  bool loading = false;
  List<dynamic> places = [];
  String? error;
  String query = "";

  Future<void> findNearby() async {
    setState(() {
      loading = true;
      error = null;
      places.clear();
    });

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() {
          loading = false;
          error = "Enable location services";
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          loading = false;
          error = "Location permission denied";
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final res =
          await ApiService.fetchFoodNearby(pos.latitude, pos.longitude);

      setState(() {
        loading = false;
        if (res == null || res.isEmpty) {
          error = "No places found nearby";
        } else {
          places = res;
        }
      });
    } catch (_) {
      setState(() {
        loading = false;
        error = "Something went wrong";
      });
    }
  }

  String distanceText(dynamic d) {
    if (d is num) {
      return d < 1000 ? "${d.round()} m" : "${(d / 1000).toStringAsFixed(1)} km";
    }
    return "";
  }

  double fakeRating(Map p) {
    final h = (p['name'] ?? '').hashCode.abs();
    return (3.8 + (h % 12) / 10).clamp(3.8, 4.9);
  }

  String imageFor(String c) {
    final t = c.toLowerCase();
    if (t.contains("cafe")) {
      return "https://images.pexels.com/photos/374885/pexels-photo-374885.jpeg";
    }
    if (t.contains("fast")) {
      return "https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg";
    }
    return "https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg";
  }

  Future<void> openMap(double lat, double lon) async {
    final uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF9EFEA);
    const card = Color(0xFFF1E0D3);
    const primary = Color(0xFF4A3C31);
    const secondary = Color(0xFF6B5B50);

    final filtered = query.isEmpty
        ? places
        : places.where((p) {
            final n = (p['name'] ?? '').toString().toLowerCase();
            final a = (p['address'] ?? '').toString().toLowerCase();
            return n.contains(query.toLowerCase()) ||
                a.contains(query.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        title: const Text(
          "Food Explorer",
          style: TextStyle(color: primary, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Eat like a local 🍜",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Discover cafes & restaurants around you",
              style: TextStyle(color: secondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDAB9A3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: loading ? null : findNearby,
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "Find Nearby Food",
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            if (places.isNotEmpty) ...[
              const SizedBox(height: 14),
              TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: "Search places",
                  filled: true,
                  fillColor: const Color(0xFFF3E7E0),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: filtered.isEmpty && !loading
                  ? const Center(
                      child: Text(
                        "Nothing here yet",
                        style: TextStyle(color: secondary),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        final name = p['name'] ?? 'Unnamed';
                        final addr = p['address'] ?? '';
                        final cat = p['category'] ?? '';
                        final dist = distanceText(p['distance']);
                        final rate = fakeRating(p as Map);
                        final lat = (p['lat'] as num).toDouble();
                        final lon = (p['lon'] as num).toDouble();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: card,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.brown.withOpacity(0.14),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: Image.network(
                                  imageFor(cat.toString()),
                                  width: 92,
                                  height: 92,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: primary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (dist.isNotEmpty)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: primary,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                dist,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (addr.isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            addr.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: secondary,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              size: 16, color: Colors.amber),
                                          const SizedBox(width: 4),
                                          Text(
                                            rate.toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: primary,
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: () =>
                                                openMap(lat, lon),
                                            child: const Text(
                                              "Open Map",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: primary,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
