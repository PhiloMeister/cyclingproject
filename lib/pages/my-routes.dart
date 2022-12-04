import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRoutes extends StatefulWidget {
  const MyRoutes({super.key});

  @override
  State<MyRoutes> createState() => _MyRoutesState();
}

class _MyRoutesState extends State<MyRoutes> {
  List<Routes> listOfLikedRoutes = <Routes>[
  ];
  List<String> listOfIds = <String>[];
  late List test;
  var indexedd;

  @override
  initState() {
    super.initState();
  }

  Future<String> initVariables() async {
    print("object");
    listOfIds = await getLikedIdsOfUser();
    for (var element in listOfIds) {
      print("initVariables list of id $element");
    }
    listOfLikedRoutes = await getListOfLikedRoutes(listOfIds);
    for (var element in listOfLikedRoutes) {
      print("listOfLikedRoutes  ${element.routeName.toString()}");
    }
    indexedd = 2;
    return "Ghandi was good";
  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: initVariables(),
      builder: (context,  snapshot) {
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
        }else if (snapshot.hasError) {
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
        trailing: Icon(Icons.heart_broken),
        leading: const CircleAvatar(child: Text("test")),
        title:  Text(routes.routeName.toString()),
        onTap: () {
          print("route "+routes.routeName.toString() +" clicked");
        },
    onLongPress: () {
      deleteLikedRoute(routes);
    },
        subtitle: Text(
            "length: ${routes.routeLenght} km  Difficulty : ${routes.routeDifficulty}"),
      );

  void refresh(){
    setState(() {});
  }
}

