import 'package:cyclingproject/admin/admin_nav.dart';
import 'package:cyclingproject/pages/verify_email.dart';
import 'package:cyclingproject/pages/biker_nav.dart';
import 'package:cyclingproject/widgets/auth.dart';
import 'package:cyclingproject/widgets/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/snackbar.dart';

class UserManagement {
  Widget handleAuth(BuildContext context, bool? seen) {
    print("ESTSTST: " + seen.toString());

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
            if (seen == null || seen == true) {
              return const IntroScreen();
            }
            return const AuthPage();
          }
        },
      ),
      backgroundColor: Colors.white,
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
            return const NavigationBiker();
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
    FirebaseAuth.instance
        .signOut()
        .then(Utils.showSnackBar("You are logged out.", false));
  }
}
