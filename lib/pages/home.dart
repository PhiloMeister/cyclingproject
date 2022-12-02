import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return //FutureBuilder(
        //future: FirebaseFirestore.instance
        //    .collection('Users')
        //    .doc(FirebaseAuth.instance.currentUser!.uid)
        //    .get(),
        //builder: (context, snapshot) {
        //  if (snapshot.hasData) {
        //    UserManagement()
        //        .authorizeAccess((snapshot.data as DocumentSnapshot)['role']);
        //  }
        //return
        Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.topLeft,
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0XFFD9D9D9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "MY HOME",
                      style: TextStyle(
                        color: Color(0XFF1f1f1f),
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Welcome back, ${user.email!}",
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 800.0,
            )
          ],
        ),
      ),
    );
//      },
//    );
  }
}
