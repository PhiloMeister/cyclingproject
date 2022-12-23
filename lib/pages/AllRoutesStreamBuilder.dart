import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../BusinessObject/Routes.dart';
import '../../BusinessObjectManager/RouteManager.dart';
import '../theme/constants.dart';

class AllRoutesStreamBuilder extends StatefulWidget {
  const AllRoutesStreamBuilder({super.key});

  @override
  State<AllRoutesStreamBuilder> createState() => _AllRoutesStreamBuilderState();
}

class _AllRoutesStreamBuilderState extends State<AllRoutesStreamBuilder> {
  var checkTextField = "";
  List<Routes> listOfAllRoutes = <Routes>[];
  List<Routes> listOfFilteredRoutes = <Routes>[];
  var lengthSwitch = "null";
  var durationSwitch = "null";
  var likedSwitch = "null";

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
        onTap: () async {
          if (routes.routeLiked == false) {
            await addToLikedRoutes(routes);
            setState(() {});
          } else {
            await removeToLikedRoutes(routes);
            setState(() {});
          }
          print("Pressed on LIKE");
        },
        trailing: routes.routeLiked!
            ? const Icon(
                Icons.favorite,
              )
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
                checkTextField = value.toString();
                setState(() {});
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
                  if (lengthSwitch == "null" || lengthSwitch == "DESC") {
                    lengthSwitch = "ASC";
                  } else {
                    lengthSwitch = "DESC";
                  }
                  //reset the others
                  durationSwitch = "null";
                  likedSwitch = "null";
                  setState(() {});
                },
                child: const Text("Length")),
            ElevatedButton(
                onPressed: () {
                  if (durationSwitch == "null" || durationSwitch == "DESC") {
                    durationSwitch = "ASC";
                  } else {
                    durationSwitch = "DESC";
                  }
                  //reset the others
                  lengthSwitch = "null";
                  likedSwitch = "null";
                  setState(() {});
                },
                child: const Text("Duration")),
            ElevatedButton(
                onPressed: () {
                  if (likedSwitch == "null") {
                    likedSwitch = "YES";
                  } else {
                    likedSwitch = "null";
                  }
                  //reset the others
                  lengthSwitch = "null";
                  durationSwitch = "null";
                  setState(() {});
                },
                child: const Text("Liked")),
          ],
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Routes")
                .snapshots()
                .asyncMap(
              (snapshot) async {
                //test
                // Perform asynchronous data manipulation here
                List<Routes> routes = snapshot.docs.map((document) {
                  print("get data");
                  Map<String, dynamic> e =
                      document.data() as Map<String, dynamic>;
                  return Routes.fromJson(e);
                }).toList();
                routes = await addLikedOrNotToListOfRoutes(routes);
// TODO extract all thoses switch's into a method

                if (checkTextField.isEmpty) {
                } else {
                  routes = routes
                      .where((route) => route.routeName
                          .toString()
                          .toLowerCase()
                          .contains(checkTextField.toLowerCase()))
                      .toList();
                  routes.forEach((element) {
                    print(element.routeName.toString());
                  });
                }

                switch (lengthSwitch) {
                  case "ASC":
                    print("ASC");
                    routes = filterByLengthASCV2(routes);
                    break;
                  case "DESC":
                    print("DESC");
                    routes = filterByLengthDESV2(routes);
                    break;
                  default:
                    print("DEFAULT");
                    break;
                }
                switch (durationSwitch) {
                  case "ASC":
                    print("ASC");
                    routes = filterByDurationASCV2(routes);
                    break;
                  case "DESC":
                    print("DESC");
                    routes = filterByDurationDESV2(routes);
                    break;
                  default:
                    print("DEFAULT");
                    break;
                }
                switch (likedSwitch) {
                  case "YES":
                    print("LIKED FILTER ON");
                    routes = filterByLikedV2(routes);
                    break;
                  default:
                    print("DEFAULT");
                    break;
                }
                return routes;
              },
            ),
            builder: (context, AsyncSnapshot<List<Routes>> snapshot) {
              if (snapshot.error != null) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (snapshot.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ],
                  ),
                );
              }
              return ListView(
                children: snapshot.data!.map(
                  (route) {
                    return buildRoutes(route);
                  },
                ).toList(),
              );
            },
          ),
        )
      ],
    ));
  }

  Widget BuildRoutesStream(Routes routes) => ListTile(
        onLongPress: () {
          openDialogLikedRoutes(routes);
        },
        onTap: () {
          print("Pressed on LIKE");
          addToLikedRoutes(routes);
        },
        trailing: routes.routeLiked!
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border),
        leading: const CircleAvatar(child: Text("test")),
        title: Text(routes.routeName.toString()),
        subtitle: Text(
            "Length: ${routes.routeLenght?.toStringAsFixed(2)} meters / Duration: ${routes.routeDuration?.toStringAsFixed(2)} min"),
      );

  void openDialogLikedRoutes(Routes route) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Actions available"),
            actions: [
              ElevatedButton(
                  onPressed: () {}, child: const Text("delete route")),
              BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ));

  Stream<List<Routes>> readRoutes() => FirebaseFirestore.instance
      .collection("Routes")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Routes.fromJson(doc.data())).toList());

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

  List<Routes> filterByLengthASCV2(List<Routes> listOfFilteredRoutes) {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => a.routeLenght!.compareTo(b.routeLenght!));
      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeLenght}");
      }
    }
    return listOfFilteredRoutes;
  }

  List<Routes> filterByLengthDESV2(List<Routes> listOfFilteredRoutes) {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => b.routeLenght!.compareTo(a.routeLenght!));
      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeLenght}");
      }
    }
    return listOfFilteredRoutes;
  }

/*  void filterByLengthDES() {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => b.routeLenght!.compareTo(a.routeLenght!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeLenght}");
      }
      setState(() {});
    }
  }*/

  List<Routes> filterByDurationASCV2(List<Routes> listOfFilteredRoutes) {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => a.routeDuration!.compareTo(b.routeDuration!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeDuration}");
      }
    }
    return listOfFilteredRoutes;
  }

  List<Routes> filterByDurationDESV2(List<Routes> listOfFilteredRoutes) {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes
          .sort((a, b) => b.routeDuration!.compareTo(a.routeDuration!));

      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeDuration}");
      }
    }
    return listOfFilteredRoutes;
  }

  List<Routes> filterByLikedV2(List<Routes> listOfFilteredRoutes) {
    if (listOfFilteredRoutes.isNotEmpty) {
      listOfFilteredRoutes.sort((a, b) =>
          b.routeLiked!.toString().compareTo(a.routeLiked!.toString()));
      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeDuration}");
      }
    }
    return listOfFilteredRoutes;
  }
}
