import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Marker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cyclingproject/BusinessObject/Routes.dart';

Future<Routes?> getRouteByID(String idRouteInput) async {
  var docRoute =
  FirebaseFirestore.instance.collection("Routes").doc(idRouteInput);
  var snapshot = await docRoute.get();

  if (snapshot.exists) {
    return Routes.fromJson(snapshot.data()!);
  } else {
    return null;
  }
}

Future<List<String>> getLikedIdsOfUser() async {
  List<String> listIds = <String>[];

  await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("likedRoutes")
      .get()
      .then(
        (res) => {
      res.docs.forEach((element) {
        String toAdd = element.id;
        listIds.add(toAdd);
      })
    },
    onError: (e) => print("Error completing: $e"),
  );
  for (var value in listIds) {
    print("getLikedIdsOfUser() list id : $value");
  }
  List<Routes> routes = <Routes>[];

  return listIds;
}

Future<List<Routes>> getListOfLikedRoutes(List<String> listIds) async {
  List<Routes> listOfRoutes = <Routes>[];

  for (var element in listIds) {
    await FirebaseFirestore.instance
        .collection("Routes")
        .doc(element)
        .get()
        .then(
          (DocumentSnapshot doc) {
        print("getListOfLikedRoutes element is : " + element);
        var data = doc.data() as Map<String, dynamic>;
        listOfRoutes.add(Routes.fromDocSnap(doc));
        //  listOfRoutes.add(Routes.fromJson(data));
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
  return listOfRoutes;
}

