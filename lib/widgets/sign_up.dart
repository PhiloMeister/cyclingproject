import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../theme/constants.dart';
import '../utils/helper_widgets.dart';
import '../utils/snackbar.dart';
import '../BusinessObject/user_model.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key, required this.onClickedSignIn});

  final VoidCallback onClickedSignIn;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool valueSwitch = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
        child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              addVerticalSpace(100),
              Image.asset("assets/images/logo-bikevs-cropped.png", height: 100),
              addVerticalSpace(75),
              TextFormField(
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: kTextColor),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  labelText: "Firstname",
                  hintText: "Enter your firstname",
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
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 14,
                ),
                cursorColor: kTextColor,
                controller: firstNameController,
                textInputAction: TextInputAction.next,
              ),
              addVerticalSpace(30),
              TextFormField(
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: kTextColor),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  labelText: "Lastname",
                  hintText: "Enter your lastname",
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
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 14,
                ),
                cursorColor: kTextColor,
                controller: lastNameController,
                textInputAction: TextInputAction.next,
              ),
              addVerticalSpace(30),
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
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 14,
                ),
                cursorColor: kTextColor,
                controller: emailController,
                textInputAction: TextInputAction.next,
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                //validator: (email) =>
                //    email != null && !EmailValidator.validate(email)
                //        ? 'Enter a valid email'
                //        : null,
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
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 14,
                ),
                cursorColor: kTextColor,
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                //validator: (value) => value != null && value.length < 6
                //    ? 'Enter min. 6 characters'
                //    : null,
              ),
              addVerticalSpace(40),
              /*    Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Admin"),
                  Switch(
                    activeColor: Colors.redAccent,
                    inactiveThumbColor: Colors.redAccent,
                    value: valueSwitch,
                    onChanged: (value) {
                      setState(() {
                        valueSwitch = value;
                        print("value is" + valueSwitch.toString());
                        // isfalse = admin
                        // istrue = user
                      });
                    },
                  ),
                  const Text("User")
                ],
              )),*/
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                icon: const Icon(
                    color: kPrimaryLightColor, Icons.login, size: 24),
                label: const Text(
                  'Sign up',
                  style: TextStyle(color: kPrimaryLightColor, fontSize: 18),
                ),
                onPressed: signUp,
              ),
              addVerticalSpace(20),
              RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.grey[600]!,
                      fontSize: 12,
                    ),
                    text: "Already have an account?  ",
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignIn,
                          text: "Sign In",
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            color: Color(0XFFB61818),
                          ))
                    ]),
              )
            ])));
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = UserModel(
        firstname: firstNameController.text,
        lastname: lastNameController.text,
        email: emailController.text,
        role: "biker",
      );

      addUsername(user);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, true);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  addUsername(UserModel user) async {
    final docUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await docUser.set(user.toJson());

    Utils.showSnackBar("save", false);
  }
}
