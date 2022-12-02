import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  }

  Widget buildRoutes(Routes routes) => ListTile(
    leading: const CircleAvatar(child: Text("test")),
    title: Text(routes.routeName),
    subtitle: Text("length: ${routes.routeLenght} km"),
  );

  Stream<List<Routes>> readRoutes() => FirebaseFirestore.instance
      .collection("Routes")
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Routes.fromJson(doc.data())).toList());
}

class Routes {
  final String routeName;
  final String routeLenght;

  Routes({required this.routeName, required this.routeLenght});

  Map<String, dynamic> toJson() =>
      {"firsname": routeName, "routeLenght": routeLenght};

  static Routes fromJson(Map<String, dynamic> json) =>
      Routes(routeName: json['name'], routeLenght: json['length']);
}