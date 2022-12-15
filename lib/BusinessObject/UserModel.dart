import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:flutter/cupertino.dart';

class UserModel {
  String? email;
  String? firstname;
  String? lastname;
  String? creator;
  String? id;

  UserModel({this.id, this.email, this.lastname, this.firstname, this.creator}) {
    //transferRawMarkersToMarkers(markersRaw, markers);
  }
  Map<String, dynamic> toJson() => {
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "creator": creator
      };

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json?['id'],
        email: json?['email'],
        firstname: json?['firstname'],
        lastname: json?['lastname'],
        creator: json?['creator']);
  }

  static UserModel fromDocSnap(DocumentSnapshot doc) {
    return UserModel(
        email: doc.data().toString().contains('name') ? doc.get('email') : "",
        firstname: doc.data().toString().contains('length')
            ? doc.get('firstname')
            : "",
        lastname: doc.data().toString().contains('lastname')
            ? doc.get('difficulty')
            : "",
        creator: doc.data().toString().contains('routeCreator')
            ? doc.get('creator')
            : "");
  }
}
