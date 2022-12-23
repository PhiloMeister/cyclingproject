import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:cyclingproject/pages/New_route_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'map_page.dart';

class MyCreatedRoutes extends StatefulWidget {
  const MyCreatedRoutes({super.key});

  @override
  State<MyCreatedRoutes> createState() => _MyCreatedRoutesState();
}

class _MyCreatedRoutesState extends State<MyCreatedRoutes> {
  List<Routes> listOfCreatedRoutes = <Routes>[];
  var newName = "";

  @override
  initState() {
    super.initState();
  }

  Future<String> initVariables() async {
    listOfCreatedRoutes = await getCreatedRoutesOfUserList();
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
              itemCount: listOfCreatedRoutes.length,
              itemBuilder: (BuildContext context, int index) {
                // return  buildRoute(listOfLikedRoutes[index]);
                return buildRoute(listOfCreatedRoutes[index]);
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
        onTap: () {
          displayRouteOnMap(routes, context);
        },
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  onPressed: () => {editRouteDialog(routes)}),
            ),
            PopupMenuItem(
              value: 2,
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  onPressed: () => {deleteCreatedRouteOfUser(routes)}),
            )
          ],
        ),
        leading: const CircleAvatar(child: Text("test")),
        title: Text(routes.routeName.toString()),
        subtitle: Text(
            "Length: ${routes.routeLenght?.toStringAsFixed(2)} meters / Duration: ${routes.routeDuration?.toStringAsFixed(2)} min"),
      );

  void refresh() {
    setState(() {});
  }

  void displayRouteOnMap(Routes myRoute, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => map_page(myRoute: myRoute)));
  }

  // After clicking on save button, shows a dialog view to enter the name of the route
  void editRouteDialog(Routes myRoute) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: const Text("Enter a name for the route"),
              content: TextField(
                controller: TextEditingController(text: myRoute.routeName),
                onChanged: (routeName) {
                  setState(() {
                    newName = routeName;
                  });
                },
              ),
              actions: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    editRoute(myRoute, newName);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Your route has been saved!"),
                      backgroundColor: Colors.red,
                      duration: Duration(milliseconds: 1500),
                    ));
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.save),
                )
              ]));

  // void openDialogCreatedRoute(Routes route) => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           contentPadding: EdgeInsets.all(50),
  //           titlePadding: EdgeInsets.all(10),
  //           title: Center(child: Text("Actions available")),
  //           actions: [
  //             ElevatedButton(
  //                 onPressed: () {
  //                   deleteCreatedRouteOfUser(route);
  //                 },
  //                 child: const Text("Delete route")),
  //             ElevatedButton(
  //                 onPressed: () {
  //                   //TODO insert method to display route
  //                 },
  //                 child: const Text("Modify route")),
  //             BackButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ));
}
