import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Marker.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  String? routeName;
  double? routeLenght;
  String? routeDifficulty;
  String? routeCreator;
  String? id;
  double? duration;
  double? startLat;
  double? startLng;
  double? endLat;
  double? endLng;

  Routes({
    this.id,
    this.routeName,
    this.routeDifficulty,
    this.routeLenght,
    this.routeCreator,
    this.duration,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
  }) {
    //transferRawMarkersToMarkers(markersRaw, markers);
  }

  Map<String, dynamic> toJson() => {
        "name": routeName,
        "length": routeLenght,
        "difficulty": routeDifficulty,
        "creator": routeCreator,
        "duration": duration,
        "startLat": startLat,
        "startLng": startLng,
        "endLat": endLat,
        "endLng": endLng,
      };

  static Routes fromJson(Map<String, dynamic> json) {
    return Routes(
        id: json['id'],
        routeName: json['name'],
        routeLenght: json['length'],
        routeDifficulty: json['difficulty'],
        routeCreator: json['routeCreator'],
        duration: json['duration'],
        startLat: json['startLat'],
        startLng: json['startLng'],
        endLat: json['endLat'],
        endLng: json['endLng'],
        );
  }

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
