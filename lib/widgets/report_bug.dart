import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/services/UserManagement.dart';
import 'package:cyclingproject/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/constants.dart';
import '../utils/helper_widgets.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({super.key});

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  final _recipientController = TextEditingController(
    text: 'testtest@byom.de',
  );

  final _subjectController = TextEditingController(text: 'The subject');

  final _bodyController = TextEditingController(
    text: 'Mail body.',
  );

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
    );

    try {
      await FlutterEmailSender.send(email);
      Utils.showSnackBar("success");
    } catch (error) {
      Utils.showSnackBar(error.toString());
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Report bug",
            style: TextStyle(color: kTextColor),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Center(
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
                      return Column(
                        children: [
                          TextFormField(
                            readOnly: true,
                            initialValue: user['email'],
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: kTextColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              labelText: "Email",
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
                            //controller: firstNameController,
                            textInputAction: TextInputAction.next,
                          ),
                          addVerticalSpace(30),
                          TextFormField(
                            readOnly: false,
                            controller: _subjectController,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: kTextColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              labelText: "Bug Title",
                              hintText: "Enter a title for the bug",
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
                            //controller: lastNameController,
                            textInputAction: TextInputAction.next,
                          ),
                          addVerticalSpace(30),
                          TextFormField(
                            controller: _bodyController,
                            readOnly: false,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: kTextColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              labelText: "Bug Description",
                              hintText: "Enter a description for the bug",
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
                            //controller: lastNameController,
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
                                Icons.send_sharp,
                                size: 24),
                            label: const Text(
                              'Submit',
                              style: TextStyle(
                                  color: kPrimaryLightColor, fontSize: 18),
                            ),
                            onPressed: send,
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
        ));
  }

  Future getUser() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic>? docData = userDoc.data() as Map<String, dynamic>?;
    var userName = docData!['lastname'];
    debugPrint(userName);
  }
}
