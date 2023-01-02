import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/services/UserManagement.dart';
import 'package:cyclingproject/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../BusinessObject/Routes.dart';
import '../BusinessObjectManager/RouteManager.dart';
import '../theme/constants.dart';
import 'MapPage.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class MyCreatedRoutes extends StatefulWidget {
  const MyCreatedRoutes({super.key});

  @override
  State<MyCreatedRoutes> createState() => _MyCreatedRoutesState();
}

class _MyCreatedRoutesState extends State<MyCreatedRoutes> {
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

  Widget buildRoutes(Routes routes) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        tileColor: kPrimaryColor.withOpacity(0.1),
        /*onTap: () {
          displayRouteOnMap(routes, context);
          //print("Pressed on LIKE");
        },*/
        leading: CircleAvatar(
          backgroundColor: kPrimaryColor,
          child: Text(
            (routes.routeName.toString()[0] + routes.routeName.toString()[1])
                .toUpperCase(),
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
        title: Text(
          routes.routeName.toString(),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "${(routes.routeLenght! / 1000).toStringAsFixed(2)} km | ${(routes.routeDuration! / 60).toStringAsFixed(2)} min",
          style: const TextStyle(fontSize: 10),
        ),
      );

  List<Routes> items = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          children: [
            addVerticalSpace(20),
            HomeHeader(size, context),
            addVerticalSpace(30),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Title(text: "All my routes"),
                  PopUpMenu(),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
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
                        return routes;
                      },
                    ),
                    builder: (context, AsyncSnapshot<List<Routes>> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return  buildRoute(listOfLikedRoutes[index]);
                            return Slidable(
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.red,
                                      icon: Icons.delete_sharp,
                                      label: "Delete route",
                                      onPressed: (context) =>
                                          deleteCreatedRouteOfUser(
                                              snapshot.data![index]),
                                    )
                                  ],
                                ),
                                child: buildRoutes(snapshot.data![index]));
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
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
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<Menu> PopUpMenu() {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.filter_alt),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        PopupMenuItem<Menu>(
          onTap: () {
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
          child: const ListTile(
            leading: Icon(
              Icons.social_distance_sharp,
              size: 20,
            ), // your icon
            title: Text(
              "Length",
              style: TextStyle(fontSize: 11, color: kTextColor),
            ),
          ),
        ),
        PopupMenuItem<Menu>(
          onTap: () {
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
          child: const ListTile(
            leading: Icon(
              Icons.timelapse,
              size: 20,
            ), // your icon
            title: Text(
              "Duration",
              style: TextStyle(fontSize: 11, color: kTextColor),
            ),
          ),
        ),
        PopupMenuItem<Menu>(
          onTap: () {
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
          child: const ListTile(
            leading: Icon(Icons.heart_broken), // your icon
            title: Text("Liked"),
          ),
        ),
      ],
    );
  }

  Container RouteOfTheDayBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: double.infinity,
      //height: 90,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text.rich(
        TextSpan(
            text: "Route of the day\n",
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(
                text: "Test",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              )
            ]),
      ),
    );
  }

  Padding HomeHeader(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.6,
            height: 50,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              onChanged: (value) {
                filterList(value);
                checkTextField = value.toString();
              },
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Search routes",
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              UserManagement().signOut();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout),
            ),
          ),
          /*InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout),
            ),
          ),*/
        ],
      ),
    );
  }

  void displayRouteOnMap(Routes myRoute, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Map_Page(myRoute: myRoute)));
  }

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
}

class Title extends StatelessWidget {
  const Title({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: kTextColor,
      ),
    );
  }
}

/*
Container HeaderWithSearchbox(Size size) {
  return Container(
    margin: const EdgeInsets.only(bottom: 23 * 2.5),
    height: size.height * 0.35,
    child: Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 0),
          height: size.height * 0.35 - 27,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Row(
            children: [
              /*Text(
                    "Home",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),*/
              Image.asset(
                "assets/images/logo_vs_background.png",
                width: 140,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 50,
                  color: kPrimaryColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: kTextColor),
                      suffixIcon: Icon(
                        Icons.search,
                        color: kTextColor,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      //filterList(value);
                      //checkTextField = value.toString();
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}*/
