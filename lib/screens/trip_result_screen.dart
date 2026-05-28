import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../storage/trip_storage.dart';
import '../models/trip_model.dart';

class TripResultScreen extends StatefulWidget {
  final String city;
  final String mood;
  final List<String> itinerary;
  final List<String> packingList;
  final double totalBudget;
  final DateTime travelDate;

  const TripResultScreen({
    super.key,
    required this.city,
    required this.mood,
    required this.itinerary,
    required this.packingList,
    required this.totalBudget,
    required this.travelDate,
  });

  @override
  State<TripResultScreen> createState() => _TripResultScreenState();
}

class _TripResultScreenState extends State<TripResultScreen>
    with SingleTickerProviderStateMixin {
  LatLng? cityPoint;
  late List<String> packing;
  final TextEditingController packCtrl = TextEditingController();
  late AnimationController anim;
  late Animation<double> fade;

  @override
  void initState() {
    super.initState();
    packing = List.from(widget.packingList);
    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
    anim.forward();
    loadCoords();
    saveTrip();
  }

  Future<void> saveTrip() async {
    await TripStorage.saveTrip(
      TripModel(
        city: widget.city,
        date: widget.travelDate,
        budget: widget.totalBudget,
      ),
    );
  }

  Future<void> loadCoords() async {
    final c = await ApiService.fetchCityCoordinates(widget.city);
    if (c != null && mounted) {
      setState(() {
        cityPoint = LatLng(c['lat']!, c['lon']!);
      });
    }
  }

  @override
  void dispose() {
    anim.dispose();
    packCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        centerTitle: true,
        title: Text(
          widget.city,
          style: const TextStyle(
            color: Color(0xFF4A3C31),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: fade,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            infoCard("Mood", widget.mood),
            const SizedBox(height: 16),
            mapCard(),
            const SizedBox(height: 20),
            itineraryCard(),
            const SizedBox(height: 20),
            packingCard(),
            const SizedBox(height: 20),
            budgetCard(),
            const SizedBox(height: 20),
            infoCard("Culture", cultureText(widget.city)),
            const SizedBox(height: 14),
            infoCard("Food", foodText(widget.city)),
          ],
        ),
      ),
    );
  }

  Widget mapCard() {
    if (cityPoint == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: cityPoint!,
            initialZoom: 11,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: cityPoint!,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    size: 36,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget itineraryCard() {
    return card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title("Itinerary"),
          ...widget.itinerary.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "• $e",
                style: const TextStyle(color: Color(0xFF6B5B50)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget packingCard() {
    return card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title("Packing List"),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: packing
                .map(
                  (e) => Chip(
                    label: Text(e),
                    onDeleted: () {
                      setState(() => packing.remove(e));
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: packCtrl,
                  decoration: const InputDecoration(
                    hintText: "Add item",
                    filled: true,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (packCtrl.text.trim().isNotEmpty) {
                    setState(() {
                      packing.add(packCtrl.text.trim());
                      packCtrl.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget budgetCard() {
    return card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title("Estimated Budget"),
          const SizedBox(height: 6),
          Text(
            "₹${widget.totalBudget.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3C31),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoCard(String titleText, String value) {
    return card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(titleText),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Color(0xFF6B5B50))),
        ],
      ),
    );
  }

  Widget card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E0D3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget title(String t) {
    return Text(
      t,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF4A3C31),
        fontSize: 16,
      ),
    );
  }

  String cultureText(String city) {
    return "Local traditions • Festivals • Heritage";
  }

  String foodText(String city) {
    return "Street food • Regional dishes • Local flavors";
  }
}
