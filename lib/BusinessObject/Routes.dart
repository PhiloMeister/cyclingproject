import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Marker.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  String? routeCreator;
  String? routeDifficulty;
  num? routeDuration;
  num? routeLenght;
  String? routeName;
  List? points;

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
    this.points,
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
        "points": points,
      };

  static Routes fromJson(Map<String, dynamic> json) {
    return Routes(
      id: json['id'],
      routeName: json['name'],
      routeLenght: json['length'],
      routeDifficulty: json['difficulty'],
      routeCreator: json['creator'],
      routeDuration: json['duration'],
      points: json['points'],
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
