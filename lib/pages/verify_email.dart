import 'dart:async';
import 'package:cyclingproject/services/user_management.dart';
import 'package:cyclingproject/utils/helper_widgets.dart';
import 'package:cyclingproject/widgets/introduction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/constants.dart';
import '../utils/snackbar.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    //isEmailVerified = true;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      Utils.showSnackBar(e.toString(), true);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? UserManagement().authorizeAccess()
      : Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_sharp,
                color: kTextColor,
                size: 15,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              "Verify Email",
              style: TextStyle(color: kTextColor),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A verification email has been sent! Please check your Emails!',
                  style: TextStyle(
                    color: kTitleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                addVerticalSpace(24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  icon: const Icon(
                      color: kPrimaryLightColor, Icons.mail, size: 24),
                  label: const Text(
                    'Resent Email',
                    style: TextStyle(color: kPrimaryLightColor, fontSize: 18),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
              ],
            ),
          ),
        );
}
