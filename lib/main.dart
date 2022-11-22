import 'package:flutter/material.dart';
import 'pages/routes.dart';
import 'pages/profile.dart';
import 'pages/my-routes.dart';
import 'pages/mapPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  final List<Widget> pages = const [Routes(), Profile(), MyRoutes(), MyMap()];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Routes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The best cycling Application"),
      ),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.orange,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  minWidth: 40.0,
                  onPressed: () {
                    setState(() {
                      currentScreen = const Routes();
                      currentPage = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pedal_bike,
                          color:
                              currentPage == 0 ? Colors.white : Colors.black),
                      Text('All Routes',
                          style: TextStyle(
                              color: currentPage == 0
                                  ? Colors.white
                                  : Colors.black))
                    ],
                  ),
                ),
                // MaterialButton(
                //   minWidth: 40.0,
                //   onPressed: () {
                //     setState(() {
                //       currentScreen = const Profile();
                //       currentPage = 1;
                //     });
                //   },
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(Icons.pedal_bike,
                //           color:
                //               currentPage == 1 ? Colors.white : Colors.black),
                //       Text('Profile',
                //           style: TextStyle(
                //               color: currentPage == 1
                //                   ? Colors.white
                //                   : Colors.black))
                //     ],
                //   ),
                // ),
                MaterialButton(
                  minWidth: 40.0,
                  onPressed: () {
                    setState(() {
                      currentScreen = const MyMap();
                      currentPage = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map,
                          color:
                              currentPage == 1 ? Colors.white : Colors.black),
                      Text('Map',
                          style: TextStyle(
                              color: currentPage == 1
                                  ? Colors.white
                                  : Colors.black))
                    ],
                  ),
                ),
              ],
            ),
          )),
      floatingActionButton: SizedBox(
        height: 75.0,
        width: 75.0,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentScreen = const MyRoutes();
              currentPage = 2;
            });
          },
          backgroundColor: Colors.orange,
          tooltip: 'Add',
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
