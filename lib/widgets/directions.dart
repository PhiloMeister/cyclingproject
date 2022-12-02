import 'package:cyclingproject/pages/new_route_page.dart';
import 'package:flutter/material.dart';

class directions extends StatefulWidget {
  const directions({super.key});

  @override
  State<directions> createState() => _directionsState();
}

class _directionsState extends State<directions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: const [
              Text("Distance"), 
              Text("Duration")
              ],
          ),
          const NewRoutePage()
        ],
      ),
    );
  }
}
