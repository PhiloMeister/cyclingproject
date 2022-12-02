import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Marker.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:flutter/cupertino.dart';

class Routes {

   String routeName;
   String routeLenght;
   String routeDifficulty;
   String routeCreator;

  Routes({ required this.routeName, required this.routeDifficulty,  required this.routeLenght, required this.routeCreator}){
    //transferRawMarkersToMarkers(markersRaw, markers);

  }
  Map<String, dynamic> toJson() => {"name": routeName, "length": routeLenght,"difficulty":routeDifficulty,"creator":routeCreator};

  static Routes fromJson(Map<String, dynamic>? json) {
  return Routes(routeName: json?['name'], routeLenght: json?['length'],routeDifficulty: json?['difficulty'],routeCreator: json?['routeCreator']);
  }
   static Routes fromDocSnap(DocumentSnapshot doc) {
     return Routes(routeName: doc.data().toString().contains('name') ? doc.get('name') : "",
         routeLenght: doc.data().toString().contains('length') ? doc.get('length') : "",
         routeDifficulty: doc.data().toString().contains('difficulty') ? doc.get('difficulty') : "",
      routeCreator: doc.data().toString().contains('routeCreator') ? doc.get('routeCreator') : "");
   }

}
