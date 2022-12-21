import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/pages/AppSettings.dart';
import 'package:cyclingproject/services/usermanagement.dart';
import 'package:cyclingproject/widgets/my_account.dart';
import 'package:cyclingproject/widgets/report_bug.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;

import '../main.dart';
import '../theme/constants.dart';
import '../widgets/profile_item.dart';
import '../widgets/profile_picture.dart';

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
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: kTextColor),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              const ProfilePic(),
              const SizedBox(height: 40),
              ProfileList(
                text: "My Account",
                icon: Icons.admin_panel_settings,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAccount(),
                    ),
                  );
                },
              ),
              /*ProfileMenu(
                text: "Notifications",
                icon: Icons.notifications,
                press: () {},
              ),*/
              ProfileList(
                text: "Settings",
                icon: Icons.settings,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppSettings(),
                    ),
                  );
                },
              ),
              ProfileList(
                text: "Report bug",
                icon: Icons.bug_report,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportBug(),
                    ),
                  );
                },
              ),
              ProfileList(
                text: "Log Out",
                icon: Icons.logout_outlined,
                press: () => UserManagement().signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
