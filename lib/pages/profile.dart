import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFD9D9D9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: firstNameController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.all(25.0),
                labelText: "Firstname",
                filled: true,
                fillColor: const Color(0XFF1f1f1f),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: lastNameController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.all(25.0),
                labelText: "Lastname",
                filled: true,
                fillColor: const Color(0XFF1f1f1f),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFB61818),
                  minimumSize: const Size.fromHeight(70),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              icon: Icon(
                  color: Colors.grey[200]!, Icons.app_registration, size: 24),
              label: Text(
                'Add',
                style: TextStyle(color: Colors.grey[200]!, fontSize: 24),
              ),
              onPressed: () {
                final user = User(
                  firstname: firstNameController.text,
                  lastname: lastNameController.text,
                );

                addUsername(user);
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => {FirebaseAuth.instance.signOut()},
                    child: const Text("sign out"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  addUsername(User user) async {
    final docUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await docUser.set(user.toJson());

    rootScaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text("save"),
      backgroundColor: Colors.red,
    ));
  }
}

class User {
  final String lastname;
  final String firstname;

  User({required this.firstname, required this.lastname});

  Map<String, dynamic> toJson() =>
      {"firsname": firstname, "lastname": lastname};

  static User fromJson(Map<String, dynamic> json) =>
      User(firstname: json['firstname'], lastname: json['lastname']);
}
