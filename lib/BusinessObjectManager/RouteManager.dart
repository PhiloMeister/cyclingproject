import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Marker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:flutter/services.dart';

// Return a list of all routes
Future<List<Routes>> getAllRoutes() async {

  List<Routes> listOfRoutes = <Routes>[];

  await FirebaseFirestore.instance
      .collection("Routes")
      .get()
      .then((values) => values.docs.forEach((element) {
            listOfRoutes.add(Routes.fromJson(element.data()));
            Routes routes = Routes.fromJson(element.data());
            print("route id${element.reference.id}");
          }));
  return listOfRoutes;
}

// Add a route to the database
Future<void> addRoute(Routes route) async {
  await FirebaseFirestore.instance.collection("Routes").add(route.toJson());
}

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
      (DocumentSnapshot doc) async {
        if (doc.data() != null) {
          var data = doc.data() as Map<String, dynamic>;
          listOfRoutes.add(Routes.fromJson(data));
        } else {
          //remove that id from the likedRoute list of the user
          // this is an id of a  route who does not exist anymore
          await deleteIdFromLikedRouteList(element.toString());
        }
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

Future<void> removeToLikedRoutes(Routes routeInput) async {
  Map<String, dynamic> e = <String, dynamic>{};
  var idOfgodamnRoute = await getIdOfRouteByName(routeInput.routeName.toString());
  print("addToLikedRoute id  : " + idOfgodamnRoute);
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("likedRoutes")
      .doc(idOfgodamnRoute.toString())
      .delete();
}

Future<String> getIdOfRouteByName(String nameInput) async {
  var nameFound;
  await FirebaseFirestore.instance
      .collection("Routes")
      .where("name", isEqualTo: nameInput)
      .get()
      .then((value) {
    try {
      nameFound = value.docs.first.reference.id;
    } catch (e) {
      nameFound = null;
    }
  });
  return nameFound;
}

Future<void> deleteIdFromLikedRouteList(String idRoute) async {
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid.toString())
      .collection("likedRoutes")
      .doc(idRoute.toString())
      .delete();
}

Future<List<Routes>> getCreatedRoutesOfUserList() async {
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

Future<void> deleteCreatedRouteOfUser(Routes routes) async {
  var idOfRoute = await getIdOfRouteByName(routes.routeName.toString());
  // Delete from Routes collection
  await FirebaseFirestore.instance.collection("Routes").doc(idOfRoute).delete();
  // Delete from the user likedRoutes collection
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("likedRoutes")
      .doc(idOfRoute)
      .delete();
}

// Edit the route by updating its name
Future<void> editRoute(Routes routes, String newName) async {
  var idOfRoute = await getIdOfRouteByName(routes.routeName.toString());
  //Edit from Routes collection
  await FirebaseFirestore.instance
      .collection("Routes")
      .doc(idOfRoute)
      .update({"name": newName});
}

// Deprecated but dont delete
Future<void> deleteLikedRoute(Routes routes) async {
  var idOfRoute = await getIdOfRouteByName(routes.routeName.toString());
  // Delete from Routes collection
  await FirebaseFirestore.instance.collection("Routes").doc(idOfRoute).delete();
  // Delete from the user likedRoutes collection
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("likedRoutes")
      .doc(idOfRoute)
      .delete();
}

Future<List<Routes>> addLikedOrNotToListOfRoutes(List<Routes> listOfAllroutes) async {
  List<Routes> listOfLikedRoutes = <Routes>[];
  //get list of liked routes
  var listOfIds = await getLikedIdsOfUser();
  listOfLikedRoutes = await getListOfLikedRoutes(listOfIds);
  //get list of all routes
  listOfLikedRoutes.forEach((routeLiked) {
    listOfAllroutes.forEach((route) {
      if (routeLiked.routeName == route.routeName) {
        route.routeLiked = true;
      }
    });
  });

  return listOfAllroutes;
}
Future<Routes> addLikedOrNotToListOfRoutesButForOneRoute(Routes route) async {
  List<Routes> listOfLikedRoutes = <Routes>[];
  //get list of liked routes
  var listOfIds = await getLikedIdsOfUser();
  listOfLikedRoutes = await getListOfLikedRoutes(listOfIds);
  //get list of all routes
  listOfLikedRoutes.forEach((routeLiked) {

      if (routeLiked.routeName == route.routeName) {
        route.routeLiked = true;
      }

  });

  return route;
}

