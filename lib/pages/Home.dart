import 'package:cyclingproject/services/usermanagement.dart';
import 'package:cyclingproject/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

import '../BusinessObject/Routes.dart';
import '../BusinessObjectManager/RouteManager.dart';
import '../theme/constants.dart';
import 'map_page.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  var checkTextField;
  List<Routes> listOfAllRoutes = <Routes>[];
  List<Routes> listOfFilteredRoutes = <Routes>[];
  bool lengthSwitch = false;
  bool durationSwitch = false;
  bool likedSwitch = false;

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        tileColor: kPrimaryColor.withOpacity(0.1),
        onTap: () {
          displayRouteOnMap(routes, context);
          //print("Pressed on LIKE");
        },
        trailing: IconButton(
          icon: routes.routeLiked!
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          onPressed: () {
            addToLikedRoutes(routes);
          },
        ),
        leading: CircleAvatar(
          backgroundColor: kPrimaryColor,
          child: Text(
            (routes.routeName.toString()[0] + routes.routeName.toString()[1])
                .toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(routes.routeName.toString()),
        subtitle: Text(
            "Length: ${routes.routeLenght?.toStringAsFixed(2)} meters / Duration: ${routes.routeDuration?.toStringAsFixed(2)} min"),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(20),
            HomeHeader(size, context),
            addVerticalSpace(30),
            RouteOfTheDayBanner(),
            addVerticalSpace(30),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Title(text: "All Routes"),
                  PopUpMenu(),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: FutureBuilder<String>(
                    future: initVariables(),
                    builder: (context, snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: listOfFilteredRoutes.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return  buildRoute(listOfLikedRoutes[index]);
                            return buildRoutes(listOfFilteredRoutes[index]);
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
      icon: const Icon(Icons.filter_list),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        PopupMenuItem<Menu>(
          onTap: () {
            if (lengthSwitch == false) {
              filterByLengthASC();
              lengthSwitch = !lengthSwitch;
            } else {
              filterByLengthDES();
              lengthSwitch = !lengthSwitch;
            }
          },
          child: const ListTile(
            leading: Icon(Icons.social_distance), // your icon
            title: Text("Length"),
          ),
        ),
        PopupMenuItem<Menu>(
          onTap: () {
            if (durationSwitch == false) {
              filterByDurationASC();
              durationSwitch = !durationSwitch;
            } else {
              filterByDurationDES();
              durationSwitch = !durationSwitch;
            }
          },
          child: const ListTile(
            leading: Icon(Icons.timelapse), // your icon
            title: Text(
              "Duration",
              style: TextStyle(color: kTextColor),
            ),
          ),
        ),
        PopupMenuItem<Menu>(
          onTap: () {
            filterByLiked();
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
        MaterialPageRoute(builder: (context) => map_page(myRoute: myRoute)));
  }

  /*
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
  */

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
      listOfFilteredRoutes.sort((a, b) =>
          b.routeLiked!.toString().compareTo(a.routeLiked!.toString()));
      for (var element in listOfFilteredRoutes) {
        print("Element : ${element.routeDuration}");
      }
      setState(() {});
    }
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