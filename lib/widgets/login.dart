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
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          addVerticalSpace(150),
          Image.asset("assets/images/logo-bikevs-cropped.png", height: 100),
          addVerticalSpace(120),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              contentPadding: const EdgeInsets.all(25.0),
              labelText: "Email",
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
          addVerticalSpace(20),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              contentPadding: const EdgeInsets.all(25.0),
              labelText: "Password",
              filled: true,
              fillColor: const Color(0XFF1f1f1f),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            obscureText: true,
          ),
          addVerticalSpace(40),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFFB61818),
                minimumSize: const Size.fromHeight(70),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            icon: Icon(color: Colors.grey[200]!, Icons.login, size: 24),
            label: Text(
              'Sign in',
              style: TextStyle(color: Colors.grey[200]!, fontSize: 24),
            ),
            onPressed: signIn,
          ),
          addVerticalSpace(20),
          GestureDetector(
            child: Text(
              "Forgot Password",
              style: TextStyle(color: Colors.grey[600]!, fontSize: 15),
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
                style: TextStyle(color: Colors.grey[600]!),
                text: "No Account?  ",
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: "Sign Up",
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0XFFB61818),
                      ))
                ]),
          )
        ]));
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
