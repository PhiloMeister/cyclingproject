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
      theme: ThemeData(useMaterial3: true),
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
        backgroundColor: const Color(0XFFE84444),
        title: const Text(
          "The best cycling Application",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings, color: Color(0XFFB61818)))
        ],
      ),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
          color: const Color(0XFFE84444),
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MaterialButton(
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
                          color: currentPage == 0
                              ? Colors.white
                              : const Color(0XFFB61818)),
                      Text('Routes',
                          style: TextStyle(
                              color: currentPage == 0
                                  ? Colors.white
                                  : const Color(0XFFB61818)))
                    ],
                  ),
                ),
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
                          color: currentPage == 1
                              ? Colors.white
                              : const Color(0XFFB61818)),
                      Text('Map',
                          style: TextStyle(
                              color: currentPage == 1
                                  ? Colors.white
                                  : const Color(0XFFB61818)))
                    ],
                  ),
                ),
              ],
            ),
          )),
      floatingActionButton: SizedBox(
        height: 65.0,
        width: 65.0,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentScreen = const MyRoutes();
              currentPage = 2;
            });
          },
          backgroundColor: const Color(0XFFB61818),
          tooltip: 'Add',
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
