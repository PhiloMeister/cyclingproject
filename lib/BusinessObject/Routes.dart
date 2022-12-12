import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Marker.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  String? routeCreator;
  String? routeDifficulty;
  num? routeDuration;
  num? routeEndLat;
  num? routeEndLng;
  num? routeLenght;
  String? routeName;
  num? routeStartLat;
  num? routeStartLng;

  String? id;

  Routes(
      {this.id,
      this.routeName,
      this.routeDifficulty,
      this.routeLenght,
      this.routeCreator,
      this.routeDuration,
      this.routeEndLat,
      this.routeEndLng,
      this.routeStartLat,
      this.routeStartLng}) {
    //transferRawMarkersToMarkers(markersRaw, markers);
  }

  Map<String, dynamic> toJson() => {
        "creator": routeCreator,
        "difficulty": routeDifficulty,
        "duration": routeDuration,
        "endLat": routeEndLat,
        "endLng": routeEndLng,
        "length": routeLenght,
        "name": routeName,
        "startLat": routeStartLat,
        "startLng": routeEndLng,
      };

  static Routes fromJson(Map<String, dynamic> json) {
    return Routes(
        id: json?['id'],
        routeName: json?['name'],
        routeLenght: json?['length'],
        routeDifficulty: json?['difficulty'],
        routeCreator: json?['creator'],
        routeDuration: json?['duration'],
        routeEndLat: json?['endLat'],
        routeEndLng: json?['endLng'],
        routeStartLat: json?['startLat'],
        routeStartLng: json?['startLng']);
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
