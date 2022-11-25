import 'package:cyclingproject/pages/profile.dart';
import 'package:cyclingproject/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'home.dart';
import 'mapPage.dart';
import 'my-routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

  final List<Widget> _pages = const [Home(), MyMap(), MyRoutes(), Settings()];

  void _navigateBottomBar(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: const Color(0XFFD9D9D9),
        title: SizedBox(
            width: 120,
            child: Image.asset("assets/images/logo-bikevs-cropped.png")),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              icon:
                  const Icon(Icons.account_circle_rounded, color: Colors.white))
        ],
      ),
      body: _pages[currentPage],
      bottomNavigationBar: Container(
        color: const Color(0XFF1f1f1f),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: GNav(
              backgroundColor: const Color(0XFF1f1f1f),
              color: Colors.white,
              activeColor: const Color(0XFFB61818),
              tabBackgroundColor: Colors.grey.shade200,
              tabBorderRadius: 15,
              gap: 8,
              onTabChange: (index) {
                _navigateBottomBar(index);
              },
              padding: const EdgeInsets.all(12),
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.pedal_bike_outlined, text: 'Routes'),
                GButton(icon: Icons.favorite, text: 'Likes'),
                GButton(icon: Icons.settings, text: 'Settings'),
              ]),
        ),
      ),
      floatingActionButton: SizedBox(
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentPage = 3;
            });
          },
          backgroundColor: const Color(0XFF1f1f1f),
          tooltip: 'Add',
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}