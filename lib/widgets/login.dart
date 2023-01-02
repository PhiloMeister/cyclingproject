import 'package:cyclingproject/theme/constants.dart';
import 'package:cyclingproject/utils/helper_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/snackbar.dart';

import '../main.dart';
import '../pages/ForgotPasswordPage.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key, required this.onClickedSignUp});

  final VoidCallback onClickedSignUp;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addVerticalSpace(100),
            Image.asset("assets/images/logo-bikevs-cropped.png", height: 100),
            addVerticalSpace(75),
            TextFormField(
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: kTextColor),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                labelText: "Email",
                hintText: "Enter your email",
                hintStyle: const TextStyle(color: kTextColor),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: kTextColor),
                  gapPadding: 10,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: kTextColor),
                  gapPadding: 10,
                ),
              ),
              style: const TextStyle(color: kTextColor, fontSize: 14),
              cursorColor: kTextColor,
              controller: emailController,
              textInputAction: TextInputAction.next,
            ),
            addVerticalSpace(30),
            TextFormField(
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: kTextColor),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                labelText: "Password",
                hintText: "Enter your password",
                hintStyle: const TextStyle(color: kTextColor),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: kTextColor),
                  gapPadding: 10,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: kTextColor),
                  gapPadding: 10,
                ),
              ),
              style: const TextStyle(color: kTextColor, fontSize: 14),
              cursorColor: kTextColor,
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
            ),
            addVerticalSpace(40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              icon:
                  const Icon(color: kPrimaryLightColor, Icons.login, size: 24),
              label: const Text(
                'Sign in',
                style: TextStyle(color: kPrimaryLightColor, fontSize: 18),
              ),
              onPressed: signIn,
            ),
            addVerticalSpace(20),
            GestureDetector(
              child: const Text(
                "Forgot Password",
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage(),
                ),
              ),
            ),
            addVerticalSpace(20),
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                    color: kTextColor,
                    fontSize: 12,
                  ),
                  text: "No Account?  ",
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: "Sign Up",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          color: kPrimaryColor,
                        ))
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
