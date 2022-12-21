import 'package:cloud_firestore/cloud_firestore.dart';

class Routes {
  String? routeCreator;
  String? routeDifficulty;
  num? routeDuration;
  num? routeLenght;
  String? routeName;
  List? pointsLat;
  List? pointsLng;

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
    );
  }

  //old do not use
  static Routes fromDocSnap(DocumentSnapshot doc) {
    return Routes(
        routeName:
            doc.data().toString().contains('name') ? doc.get('name') : "",
        routeLenght:
            doc.data().toString().contains('length') ? doc.get('length') : "",
        routeDifficulty: doc.data().toString().contains('difficulty')
            ? doc.get('difficulty')
            : "",
        routeCreator: doc.data().toString().contains('routeCreator')
            ? doc.get('routeCreator')
            : "");
  }
}
