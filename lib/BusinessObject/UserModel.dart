import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:flutter/cupertino.dart';

class UserModel {

  String? email;
  String? firstname;
  String? lastname;
  String? role;
  String? id;

  UserModel({ this.id, this.email,  this.lastname,   this.firstname,  this.role}){
    //transferRawMarkersToMarkers(markersRaw, markers);

  }
  Map<String, dynamic> toJson() => {"name": email, "length": firstname,"difficulty":lastname,"creator":role};

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(id: json?['id'],email: json?['name'], firstname: json?['length'],lastname: json?['difficulty'],role: json?['routeCreator']);
  }
  static UserModel fromDocSnap(DocumentSnapshot doc) {
    return UserModel(email: doc.data().toString().contains('name') ? doc.get('name') : "",
        firstname: doc.data().toString().contains('length') ? doc.get('length') : "",
        lastname: doc.data().toString().contains('difficulty') ? doc.get('difficulty') : "",
        role: doc.data().toString().contains('routeCreator') ? doc.get('routeCreator') : "");
  }

}
