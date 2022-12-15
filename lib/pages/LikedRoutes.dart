import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedRoutes extends StatefulWidget {
  const LikedRoutes({super.key});

  @override
  State<LikedRoutes> createState() => _LikedRoutesState();
}

class _LikedRoutesState extends State<LikedRoutes> {
  List<Routes> listOfLikedRoutes = <Routes>[];
  List<String> listOfIds = <String>[];
  @override
  initState() {
    super.initState();
  }

  Future<String> initVariables() async {
    listOfIds = await getLikedIdsOfUser();
    for (var element in listOfIds) {
      print("initVariables list of id $element");
    }
    listOfLikedRoutes = await getListOfLikedRoutes(listOfIds);
    for (var element in listOfLikedRoutes) {
      print("listOfLikedRoutes  ${element.routeName.toString()}");
    }
    return "Ghandi was good";
  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: initVariables(),
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          return Scaffold(
            body: ListView.builder(
              itemCount: listOfLikedRoutes.length,
              itemBuilder: (BuildContext context, int index) {
                // return  buildRoute(listOfLikedRoutes[index]);
                return buildRoute(listOfLikedRoutes[index]);
              },
            ),
          );
        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            ),
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  Widget buildRoute(Routes routes) => ListTile(
        leading: const CircleAvatar(child: Text("test")),
        title: Text(routes.routeName.toString()),
        onTap: () {
          print("route " + routes.routeName.toString() + " clicked");
        },
        onLongPress: () {
          openDialogLikedRoutes(routes);
        },
        subtitle: Text(
            "length: ${routes.routeLenght} km  Difficulty : ${routes.routeDifficulty}"),
      );

  void refresh() {
    setState(() {});
  }

  void openDialogLikedRoutes(Routes route) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Actions available"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                      deleteLikedRoute(route);
                      refresh();
                  },
                  child: Text("Unlike the route")),
              ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text("Display route")),
              BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));
}
