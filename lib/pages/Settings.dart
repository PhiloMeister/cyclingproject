import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Settings"),
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
