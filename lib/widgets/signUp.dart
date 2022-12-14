import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/globals.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/helper_widgets.dart';
import '../utils/snackbar.dart';
import '../BusinessObject/UserModel.dart';

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
              addVerticalSpace(150),
              Image.asset("assets/images/logo-bikevs-cropped.png", height: 100),
              addVerticalSpace(75),
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
              addVerticalSpace(20),
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
              addVerticalSpace(20),
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
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                //validator: (email) =>
                //    email != null && !EmailValidator.validate(email)
                //        ? 'Enter a valid email'
                //        : null,
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
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                //validator: (value) => value != null && value.length < 6
                //    ? 'Enter min. 6 characters'
                //    : null,
              ),
              addVerticalSpace(40),
              Center(
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
              )),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFB61818),
                    minimumSize: const Size.fromHeight(70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                icon: Icon(
                    color: Colors.grey[200]!, Icons.app_registration, size: 24),
                label: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.grey[200]!, fontSize: 24),
                ),
                onPressed: signUp,
              ),
              addVerticalSpace(20),
              RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.grey[600]!),
                    text: "Already have an account?  ",
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignIn,
                          text: "Sign In",
                          style: const TextStyle(
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
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  addUsername(UserModel user) async {
    final docUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await docUser.set(user.toJson());

    Utils.showSnackBar("save");
  }
}

/*
Future<String> isAdminOrUser(bool valueSwitch) async {
  String roleGiven = "";

  if(valueSwitch == true){
    await FirebaseFirestore
        .instance
        .collection("Roles").where("nomRole",isEqualTo: "user")
        .get()
        .then((documents) =>
        documents
            .docs
            .forEach((element) {
          roleGiven = element.id;
          print("roleGiven is : "+ roleGiven.toString());
        }));
    return roleGiven;
  }else{
    await FirebaseFirestore
        .instance
        .collection("Roles").where("nomRole",isEqualTo: "admin")
        .get()
        .then((documents) =>
        documents
            .docs
            .forEach((element) {
          roleGiven = element.id;
          print("roleGiven is : "+ roleGiven.toString());
        }));
    return roleGiven;
  }
}*/
