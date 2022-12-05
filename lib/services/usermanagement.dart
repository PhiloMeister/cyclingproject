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

  authorizeAccess(role) {
    globals.role = role;
  }

  signOut() {
    FirebaseAuth.instance.signOut().then((value) => globals.role = "");
  }
}
