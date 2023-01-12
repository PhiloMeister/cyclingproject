import 'dart:ui';

import 'package:cyclingproject/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user_management.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  Future<void> onDone() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("_seen", false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => UserManagement().handleAuth(context, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                Image.asset(
                  "assets/images/logo-bikevs-cropped.png",
                  height: 70,
                ),
              ],
            ),
          ),
          bodyWidget: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Text(
                    "With this app you can find the best and most beautiful biking routes in Valais and the whole of Switzerland.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Image.asset('assets/images/intro_screen_1.jpg')
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              children: const [
                SizedBox(
                  height: 120,
                ),
                Text(
                  "Find new nice bike routes",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          bodyWidget: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 35),
                  child: Text(
                    "On the first page you can display a route with one click on the list element.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Image.asset('assets/images/intro_screen_2.jpg')
              ],
            ),
          ),
        ),
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              children: const [
                SizedBox(
                  height: 120,
                ),
                Text(
                  "Have your favourites routes",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          bodyWidget: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 35),
                  child: Text(
                    "You can like a route and then only your favorite routes will be shown on the app.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Image.asset('assets/images/intro_screen_3.jpg')
              ],
            ),
          ),
        ),
      ],
      dotsDecorator: const DotsDecorator(activeColor: kPrimaryColor),
      onDone: () => {onDone()},
      onSkip: () => {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UserManagement().authorizeAccess(),
          ),
        ),
      },
      showNextButton: true,
      showDoneButton: true,
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: TextStyle(fontWeight: FontWeight.w600, color: kPrimaryColor),
      ),
      next: const Icon(
        Icons.navigate_next_sharp,
        color: kPrimaryColor,
        size: 30,
      ),
      done: const Text(
        'Done',
        style: TextStyle(fontWeight: FontWeight.w600, color: kPrimaryColor),
      ),
    );
  }
}
