import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Marker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:flutter/services.dart';

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
Future<void> addToLikedRoutes(Routes routeInput) async {

  Map<String, dynamic> e = <String, dynamic>{};

  var idOfgodamnRoute = await findIdOfRouteByName(routeInput.routeName.toString());
  print("addToLikedRoute id  : "+idOfgodamnRoute);
  await FirebaseFirestore
      .instance
      .collection("Users")
      .doc(FirebaseAuth
      .instance.currentUser?.uid)
      .collection("likedRoutes")
      .doc(idOfgodamnRoute.toString()).set(e);
}



Future<String> findIdOfRouteByName(String nameInput) async {
  var nameFound;
  await FirebaseFirestore
      .instance
      .collection("Routes")
      .where("name", isEqualTo: nameInput).get().then((value) {
    //routeSearched = Routes.fromJson(value.docs.first.data());
    nameFound =  value.docs.first.reference.id;
  });
  print("nameFound  "+nameFound);
  return nameFound;
}
Future<void> deleteLikedRoute(Routes routes) async {
  var idOfRoute = await findIdOfRouteByName(routes.routeName.toString());
  print("id of route to delete => "+idOfRoute.toString());
  await FirebaseFirestore
      .instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid.toString())
      .collection("likedRoutes")
      .doc(idOfRoute.toString())
      .delete();

}