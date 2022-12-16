import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/pages/Home.dart';
import 'package:cyclingproject/pages/AppSettings.dart';
import 'package:cyclingproject/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../globals.dart' as globals;

import 'AllRoutes.dart';
import 'AllRoutesStreamBuilder.dart';
import 'New_route_page.dart';
import 'MyCreatedRoutes.dart';
import 'ProfileMenu.dart';
import 'AppSettings.dart';
import 'LikedRoutes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
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

  final List<Widget> _pages = const [
    Home(),
    AllRoutes(),
    AllRoutesStreamBuilder(),
    NewRoutePage(canEdit: false),
    Profile()
    //LikedRoutes()
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          backgroundColor: kPrimaryColor,
        ),*/
        resizeToAvoidBottomInset: false,
        body: _pages[currentPage],
        bottomNavigationBar: Container(
          color: const Color(0XFF1f1f1f),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: GNav(
                backgroundColor: const Color(0xFF1F1F1F),
                color: Colors.white,
                activeColor: const Color(0XFFB61818),
                tabBackgroundColor: Colors.grey.shade200,
                tabBorderRadius: 4,
                gap: 8,
                onTabChange: (index) {
                  _navigateBottomBar(index);
                },
                padding: const EdgeInsets.all(6),
                tabs: const [
                  GButton(icon: Icons.home, text: 'All routes'),
                  GButton(icon: Icons.home, text: 'All routes'),
                  GButton(
                      icon: Icons.diamond_outlined, text: 'All routes stream'),
                  GButton(icon: Icons.map, text: 'Map'),
                  GButton(icon: Icons.person_off_outlined, text: 'Profile'),
                  //GButton(icon: Icons.heart_broken, text: 'Liked routes'),
                ]),
          ),
        ));
  }
}
