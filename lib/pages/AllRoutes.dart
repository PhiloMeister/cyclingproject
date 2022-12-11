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
  final firstNameController = TextEditingController();
  List<Routes> listOfAllRoutes = <Routes>[];
  List<Routes> listOfFilteredRoutes = <Routes>[];

  @override
  initState() {
    super.initState();
  }

  Future<String> initVariables() async {
    listOfAllRoutes = await getAllRoutes();
    listOfFilteredRoutes = listOfAllRoutes;

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
                ElevatedButton(onPressed: () {}, child: const Text("Length")),
                ElevatedButton(onPressed: () {}, child: const Text("Duration")),
                ElevatedButton(onPressed: () {}, child: const Text("Liked")),
              ],
            ),
            Expanded(child: FutureBuilder<String>(
              future: initVariables(),
              builder: (context, snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  return Scaffold(
                    body: ListView.builder(
                      itemCount: listOfFilteredRoutes.length,
                      itemBuilder: (BuildContext context, int index) {
                        // return  buildRoute(listOfLikedRoutes[index]);
                        return buildRoutes(listOfFilteredRoutes[index]);
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
            ))
          ],
        ));
  }

/*class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<List<Routes>>(
        stream: readRoutes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error");
          } else if (snapshot.hasData) {
            final routes = snapshot.data!;
            return ListView(
              children: routes.map(buildRoutes).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }*/


  Widget buildRoutes(Routes routes) =>
      ListTile(
        onLongPress: () {
          openDialogLikedRoutes(routes);
        },
        leading: const CircleAvatar(child: Text("test")),
        title: Text(routes.routeName.toString()),
        subtitle: Text("length: ${routes.routeLenght} km"),
      );

  Stream<List<Routes>> readRoutes() =>
      FirebaseFirestore.instance
          .collection("Routes")
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Routes.fromJson(doc.data())).toList());

  void openDialogLikedRoutes(Routes route) =>
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
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
    List<Routes> routesFound = <Routes>[];
    if (value.isEmpty) {
      listOfFilteredRoutes = listOfAllRoutes;
    } else {
      listOfFilteredRoutes = listOfAllRoutes.where((route) =>
          route.routeName.toString().toLowerCase().contains(
              value.toLowerCase())).toList();
      listOfFilteredRoutes.forEach((element) {
        print(element.routeName.toString());
      });
      setState(() {
      });
    }
  }
}