class TripModel {
  final String city;
  final String date;
  final double budget;

  TripModel({
    required this.city,
    required this.date,
    required this.budget,
  });

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "date": date,
      "budget": budget,
    };
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      city: json["city"],
      date: json["date"],
      budget: json["budget"],
    );
  }
}
