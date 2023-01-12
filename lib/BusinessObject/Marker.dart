class Marker {
  final String latitude;
  final String longitude;
  final String order;

  Marker(
      {required this.latitude, required this.longitude, required this.order});

  Map<String, dynamic> toJson() =>
      {"latitude": latitude, "longitude": longitude, "order": order};

  static Marker fromJson(Map<String, dynamic> json) => Marker(
      latitude: json['latitude'],
      longitude: json['longitude'],
      order: json['order']);
}
