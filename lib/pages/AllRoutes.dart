import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../BusinessObject/Routes.dart';
import '../../BusinessObjectManager/RouteManager.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var checkTextField;
  List<Routes> listOfAllRoutes = <Routes>[];
  List<Routes> listOfFilteredRoutes = <Routes>[];

  @override
  initState() {
    super.initState();
  }

  Future<String> initVariables() async {
    print("REFRESHED");
    listOfAllRoutes = await getAllRoutes();
    listOfAllRoutes = await addLikedOrNotToListOfRoutes(listOfAllRoutes);
    if (listOfFilteredRoutes.isEmpty) {
      print("list Is empty");
    } else {
      print("list Is NOT empty");
    }

    if (listOfFilteredRoutes.isEmpty) {
      if (checkTextField == null || checkTextField.toString().isEmpty) {
        listOfFilteredRoutes = listOfAllRoutes;
      }
    }

    return "Ghandi was good";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
              onChanged: (value) {
                filterList(value);
                checkTextField = value.toString();
              },
              decoration: const InputDecoration(
                  labelText: 'Search a route..',
                  suffixIcon: Icon(Icons.search)),
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  filterByLength();
                },
                child: const Text("Length")),
            ElevatedButton(
                onPressed: () {
                  filterByDuration();
                },
                child: const Text("Duration")),
            ElevatedButton(onPressed: () {
              //TODO filter by liked
            }, child: const Text("Liked")),
          ],
        ),
        Expanded(
            child: FutureBuilder<String>(
          future: initVariables(),
          builder: (context, snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: listOfFilteredRoutes.length,
                itemBuilder: (BuildContext context, int index) {
                  // return  buildRoute(listOfLikedRoutes[index]);
                  return buildRoutes(listOfFilteredRoutes[index]);
                },
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
        ))
      ],
    ));
  }

  Widget buildRoutes(Routes routes) => ListTile(
        onLongPress: () {
          openDialogLikedRoutes(routes);
        },
    onTap: () {
      addToLikedRoutes(routes);
    },
        trailing: routes.routeLiked! ? Icon(Icons.favorite):Icon(Icons.favorite_border),
        leading: const CircleAvatar(child: Text("test")),
        title: Text(routes.routeName.toString()),
        subtitle: Text(
            "length: ${routes.routeLenght.toString()} km / Duration: ${routes.routeDuration.toString()}"),
      );


  void openDialogLikedRoutes(Routes route) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Actions available"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    addToLikedRoutes(route);
                  },
                  child: Text("Like the route")),
              ElevatedButton(
                  onPressed: () {
                    //TODO insert method to display route
                  },
                  child: const Text("Display route")),
              BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));

  void filterList(String value) {
    if (value.isEmpty) {
      setState(() {
        listOfFilteredRoutes.clear();
      });
    } else {
      setState(() {
        listOfFilteredRoutes = listOfAllRoutes
            .where((route) => route.routeName
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
        listOfFilteredRoutes.forEach((element) {
          print(element.routeName.toString());
        });
      });
    }
  }

  void filterByLength() {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => a.routeLenght!.compareTo(b.routeLenght!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeLenght}");
      }
      setState(() {});
    }
  }

  void filterByDuration() {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => a.routeLenght!.compareTo(b.routeLenght!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeLenght}");
      }
      setState(() {});
    }
  }
}
