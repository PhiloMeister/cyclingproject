import 'package:cyclingproject/admin/AdminNav.dart';
import 'package:cyclingproject/pages/VerifyEmailPage.dart';
import 'package:cyclingproject/pages/AllRoutes.dart';
import 'package:cyclingproject/pages/Navigation.dart';
import 'package:cyclingproject/widgets/auth.dart';
import 'package:cyclingproject/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../globals.dart' as globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';

class UserManagement {
  Widget handleAuth(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            return const AuthPage();
          }
        },
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  authorizeAccess() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data.data();
          if (user['role'] == 'admin') {
            return const AdminNav();
          } else {
            return const HomePage();
          }
        }
        return const Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut().then((value) => globals.role = "");
  }
}
