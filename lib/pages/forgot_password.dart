import 'package:cyclingproject/theme/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/helper_widgets.dart';
import '../utils/snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Forgot Password",
          style: TextStyle(color: kTextColor),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
          child: Column(
            children: [
              addVerticalSpace(60),
              const Text(
                "Receive an Email",
                style: TextStyle(
                  fontSize: 28,
                  color: kTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              addVerticalSpace(15),
              const Text(
                  "Please enter your email and we will send \nyou a link to return to your account"),
              const SizedBox(height: 120),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: kTextColor),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
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
                      style: const TextStyle(color: kTextColor),
                      controller: emailController,
                      textInputAction: TextInputAction.done,
                    ),
                    addVerticalSpace(40),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      icon: const Icon(
                          color: kPrimaryLightColor, Icons.restore, size: 24),
                      label: const Text(
                        'Reset Password',
                        style:
                            TextStyle(color: kPrimaryLightColor, fontSize: 24),
                      ),
                      onPressed: resetPassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar("reset password email send", false);

      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, true);
      Navigator.of(context).pop();
    }
  }
}
