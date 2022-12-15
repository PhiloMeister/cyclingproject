import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCreatedRoutes extends StatefulWidget {
  const MyCreatedRoutes({super.key});

  @override
  State<MyCreatedRoutes> createState() => _MyCreatedRoutesState();
}

class _MyCreatedRoutesState extends State<MyCreatedRoutes> {
  List<Routes> listOfCreatedRoutes = <Routes>[];

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
        leading: const CircleAvatar(child: Text("test")),
        title: Text(routes.routeName.toString()),
        onTap: () {
          print("route " + routes.routeName.toString() + " clicked");
        },
        onLongPress: () {
          openDialogCreatedRoute(routes);
        },
        subtitle: Text(
            "Length: ${routes.routeLenght?.toStringAsFixed(2)} meters / Duration: ${routes.routeDuration?.toStringAsFixed(2)} min"),
      );

  void refresh() {
    setState(() {});
  }

  void openDialogCreatedRoute(Routes route) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.all(50),
            titlePadding: EdgeInsets.all(10),
            title: Center(child: Text("Actions available")),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    deleteCreatedRouteOfUser(route);
                  },
                  child: const Text("Delete route")),
              ElevatedButton(
                  onPressed: () {
                    //TODO insert method to display route
                  },
                  child: const Text("Display route")),
              ElevatedButton(
                  onPressed: () {
                    //TODO insert method to display route
                  },
                  child: const Text("Modify route")),
              BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));

}
