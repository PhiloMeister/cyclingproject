import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/services/UserManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/constants.dart';
import '../utils/helper_widgets.dart';
import '../utils/snackbar.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
          "My Account",
          style: TextStyle(color: kTextColor),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final user = snapshot.data.data();
                      firstNameController.text = user['firstname'];
                      lastNameController.text = user['lastname'];
                      return Column(
                        children: [
                          TextFormField(
                            readOnly: false,
                            //initialValue: user['firstname'],
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: kTextColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              labelText: "Firstname",
                              hintText: "Enter your firstname",
                              hintStyle: const TextStyle(color: kTextColor),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                            cursorColor: kTextColor,
                            controller: firstNameController,
                            textInputAction: TextInputAction.next,
                          ),
                          addVerticalSpace(30),
                          TextFormField(
                            readOnly: false,
                            //initialValue: user['lastname'],
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: kTextColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              labelText: "Lastname",
                              hintText: "Enter your lastname",
                              hintStyle: const TextStyle(color: kTextColor),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                            cursorColor: kTextColor,
                            controller: lastNameController,
                            textInputAction: TextInputAction.next,
                          ),
                          addVerticalSpace(40),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            icon: const Icon(
                                color: kPrimaryLightColor,
                                Icons.update,
                                size: 24),
                            label: const Text(
                              'Update your Profile',
                              style: TextStyle(
                                  color: kPrimaryLightColor, fontSize: 18),
                            ),
                            onPressed: update,
                          ),
                        ],
                      );
                    }
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
                /*TextFormField(
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFB61818),
                      minimumSize: const Size.fromHeight(70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  icon: Icon(
                      color: Colors.grey[200]!, Icons.app_registration, size: 24),
                  label: Text(
                    'Add',
                    style: TextStyle(color: Colors.grey[200]!, fontSize: 24),
                  ),
                  onPressed: () {
                    //final user = User(
                    //  firstname: firstNameController.text,
                    //  lastname: lastNameController.text,
                    //);
                    getUser();
                    //addUsername(user);
                  },
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future update() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await documentReference.update(
        {
          "firstname": firstNameController.text.trim(),
          "lastname": lastNameController.text.trim(),
        },
      ).then((value) => Utils.showSnackBar("You updated your profile!", false));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, true);
    }
  }
}
