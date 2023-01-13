import 'package:cyclingproject/admin/created_routes.dart';
import 'package:cyclingproject/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../pages/new_route.dart';
import '../pages/profile.dart';

class AdminNav extends StatelessWidget {
  const AdminNav({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.soraTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true),
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
    MyCreatedRoutes(),
    NewRoutePage(
      canEdit: true,
    ),
    Profile()
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: _pages[currentPage],
      bottomNavigationBar: Container(
        color: const Color(0XFF1f1f1f),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: GNav(
              backgroundColor: const Color(0xFF1F1F1F),
              color: Colors.white,
              activeColor: const Color(0XFFB61818),
              tabBackgroundColor: kPrimaryLightColor,
              tabBorderRadius: 4,
              gap: 8,
              onTabChange: (index) {
                _navigateBottomBar(index);
              },
              padding: const EdgeInsets.all(6),
              tabs: const [
                GButton(icon: Icons.home, text: 'My routes'),
                GButton(icon: Icons.add, text: 'Add route'),
                GButton(icon: Icons.person, text: 'Profile'),
              ]),
        ),
      ),
      /*floatingActionButton: SizedBox(
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentPage = 1;
            });
          },
          backgroundColor: const Color(0XFF1f1f1f),
          tooltip: 'Add',
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
    );
  }
}
