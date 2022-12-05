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
    var idOfgodamnRoute =
        await getIdOfRouteByName(routeInput.routeName.toString());
    print("addToLikedRoute id  : " + idOfgodamnRoute);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("likedRoutes")
        .doc(idOfgodamnRoute.toString())
        .set(e);

}
//not used atm
Future<bool> isAlreadyLiked(Routes routeInput) async {
  //get the id of the route based on the route name
  var idOfRoute = await getIdOfRouteByName(routeInput.routeName.toString());
  //do a query in the likedRoutes collection of the user
  //if query is not empty => return false
  var query = await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("likedRoutes")
      .where("id", isEqualTo: idOfRoute)
      .get();

  if (query == null) {
    print("NOT LIKED");
    return true;
  } else {
    print("ALREADY LIKED");
    return false;
  }
}

Future<String> getIdOfRouteByName(String nameInput) async {
  var nameFound;
  await FirebaseFirestore.instance
      .collection("Routes")
      .where("name", isEqualTo: nameInput)
      .get()
      .then((value) {
    //routeSearched = Routes.fromJson(value.docs.first.data());
    nameFound = value.docs.first.reference.id;
  });
  print("nameFound  " + nameFound);
  return nameFound;
}

Future<void> deleteLikedRoute(Routes routes) async {
  var idOfRoute = await getIdOfRouteByName(routes.routeName.toString());
  print("id of route to delete => " + idOfRoute.toString());
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid.toString())
      .collection("likedRoutes")
      .doc(idOfRoute.toString())
      .delete();
}

Future<List<Routes>> getCreatedRoutesOfUser() async {
  List<Routes> listOfRoutes = <Routes>[];
  await FirebaseFirestore.instance
      .collection("Routes")
      .where("creator", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .get()
      .then(
          (elements) => {
                elements.docs.forEach(
                  (element) {
                    listOfRoutes.add(Routes.fromJson(element.data()));
                    print("USER ROUTE : ${element.data()['name']}");
                  },
                )
              },
          onError: (e) => print("Error completing: $e"));

  if (listOfRoutes == null) {
    print("List of created routes is NULL");
  }
  return listOfRoutes;
}
Future<void> deleteCreatedRoute(Routes routes) async {
  var idOfRoute = await getIdOfRouteByName(routes.routeName.toString());
  //delete from Routes collection
  await FirebaseFirestore
      .instance
      .collection("Routes").doc(idOfRoute).delete();
  //delete from the user likedRoutes collection
  await FirebaseFirestore
      .instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("likedRoutes")
  .doc(idOfRoute).delete();

}
