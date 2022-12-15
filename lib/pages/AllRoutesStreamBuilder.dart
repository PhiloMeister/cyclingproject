import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../BusinessObject/Routes.dart';
import '../../BusinessObjectManager/RouteManager.dart';

class AllRoutesStreamBuilder extends StatefulWidget {
  const AllRoutesStreamBuilder({super.key});

  @override
  State<AllRoutesStreamBuilder> createState() => _AllRoutesStreamBuilderState();
}

class _AllRoutesStreamBuilderState extends State<AllRoutesStreamBuilder> {
  var checkTextField;
  List<Routes> listOfAllRoutes = <Routes>[];
  List<Routes> listOfFilteredRoutes = <Routes>[];
  bool lengthSwitch = false;
  bool durationSwitch= false;
  bool likedSwitch= false;

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
    return "Gandhi was good";
  }

  Widget buildRoutes(Routes routes) => ListTile(
    onLongPress: () {
      openDialogLikedRoutes(routes);
    },
    onTap: () {
      addToLikedRoutes(routes);
      print("Pressed on LIKE");
    },
    trailing: routes.routeLiked!
        ? const Icon(Icons.favorite,shadows: [Shadow(color: Colors.black26)],)
        : const Icon(Icons.favorite_border),
    leading: const CircleAvatar(child: Text("test")),
    title: Text(routes.routeName.toString()),
    subtitle: Text(
        "length: ${routes.routeLenght.toString()} km / Duration: ${routes.routeDuration.toString()}"),
  );

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
                  if(lengthSwitch == false){
                    filterByLengthASC();
                    lengthSwitch = !lengthSwitch;
                  }else{
                    filterByLengthDES();
                    lengthSwitch = !lengthSwitch;
                  }
                },
                child: const Text("Length")),
            ElevatedButton(
                onPressed: () {
                  if(durationSwitch == false){
                    filterByDurationASC();
                    durationSwitch = !durationSwitch;
                  }else{
                    filterByDurationDES();
                    durationSwitch = !durationSwitch;
                  }
                },
                child: const Text("Duration")),
            ElevatedButton(
                onPressed: () {
                  filterByLiked();
                },
                child: const Text("Liked")),
          ],
        ),
      ],
    ));
  }

  void openDialogLikedRoutes(Routes route) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Actions available"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    addToLikedRoutes(route);
                  },
                  child: const Text("Like the route")),
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

  void filterByLengthASC() {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => a.routeLenght!.compareTo(b.routeLenght!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeLenght}");
      }
      setState(() {});
    }
  }
  void filterByLengthDES() {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => b.routeLenght!.compareTo(a.routeLenght!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeLenght}");
      }
      setState(() {});
    }
  }

  void filterByDurationASC() {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => a.routeDuration!.compareTo(b.routeDuration!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeDuration}");
      }
      setState(() {});
    }
  }
  void filterByDurationDES() {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => b.routeDuration!.compareTo(a.routeDuration!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeDuration}");
      }
      setState(() {});
    }
  }
  void filterByLiked() {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => b.routeLiked!.toString().compareTo(a.routeLiked!.toString()));
      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeDuration}");
      }
      setState(() {});
    }
  }

}