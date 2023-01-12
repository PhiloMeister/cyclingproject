class Routes {
  String? routeCreator;
  String? routeDifficulty;
  num? routeDuration;
  num? routeLenght;
  String? routeName;
  List? pointsLat;
  List? pointsLng;
  List? dangerPointsLat;
  List? dangerPointsLng;

  // local variable
  bool? routeLiked;

  String? id;

  Routes({
    this.id,
    this.routeName,
    this.routeDifficulty,
    this.routeLenght,
    this.routeCreator,
    this.routeDuration,
    this.pointsLat,
    this.pointsLng,
    this.dangerPointsLat,
    this.dangerPointsLng,
  }) {
    routeLiked ??= false;
    routeDuration ??= 0;
    routeLenght ??= 0;
  }

  Map<String, dynamic> toJson() => {
        "creator": routeCreator,
        "difficulty": routeDifficulty,
        "duration": routeDuration,
        "length": routeLenght,
        "name": routeName,
        "pointsLat": pointsLat,
        "pointsLng": pointsLng,
        "dangerPointsLat": dangerPointsLat,
        "dangerPointsLng": dangerPointsLng,
      };

  static Routes fromJson(Map<String, dynamic> json) {
    return Routes(
      id: json['id'],
      routeName: json['name'],
      routeLenght: json['length'],
      routeDifficulty: json['difficulty'],
      routeCreator: json['creator'],
      routeDuration: json['duration'],
      pointsLat: json['pointsLat'],
      pointsLng: json['pointsLng'],
      dangerPointsLat: json['dangerPointsLat'],
      dangerPointsLng: json['dangerPointsLng'],
    );
  }
}
