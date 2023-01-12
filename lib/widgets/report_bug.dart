import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclingproject/utils/snackbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/constants.dart';
import '../utils/helper_widgets.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({super.key});

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  final _mailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _roleController = TextEditingController();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo? androidInfo;

  Future<AndroidDeviceInfo> getAndroidDeviceInfo() async {
    return await deviceInfo.androidInfo;
  }

  // ignore: prefer_typing_uninitialized_variables
  var dataJson;

  Future sendEmail({
    required String email,
    required String subject,
    required String message,
    required var deviceInfos,
    required String role,
  }) async {
    const serviceId = 'service_z3yxdc6';
    const templateId = 'template_s42tuxl';
    const userId = 'WQGARultyA7nxMQ6D';

    var dataDeviceInfos = jsonDecode(deviceInfos);

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    // ignore: unused_local_variable
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_mail': email,
            'user_role': role,
            'user_subject': subject,
            'user_model': dataDeviceInfos["model"],
            'user_security_patch': dataDeviceInfos["security-patch"],
            'user_hardware': dataDeviceInfos["hardware"],
            'user_version': dataDeviceInfos["version"],
            'user_sdk': dataDeviceInfos["sdk"],
            'user_manufacturer': dataDeviceInfos["manufacturer"],
            'user_message': message,
          },
        },
      ),
    );
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
      body: FutureBuilder<AndroidDeviceInfo>(
        future: getAndroidDeviceInfo(),
        builder: (context, snapshot) {
          final data = snapshot.data!;
          var deviceInfos = {
            'model': data.model,
            'security-patch': data.version.securityPatch,
            'hardware': data.hardware,
            'version': data.version.release,
            'sdk': data.version.sdkInt,
            'manufacturer': data.manufacturer
          };

          dataJson = jsonEncode(deviceInfos);
          return Center(
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
                        _mailController.text = user['email'];
                        _roleController.text = user['role'];
                        return Column(
                          children: [
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
                                  borderSide:
                                      const BorderSide(color: kTextColor),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: kTextColor),
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
                              maxLines: 10,
                              controller: _bodyController,
                              keyboardType: TextInputType.multiline,
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
                                  borderSide:
                                      const BorderSide(color: kTextColor),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: kTextColor),
                                  gapPadding: 10,
                                ),
                              ),
                              style: const TextStyle(color: kTextColor),
                              cursorColor: kTextColor,
                            ),
                            addVerticalSpace(40),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                              icon: const Icon(
                                  color: kPrimaryLightColor,
                                  Icons.send_sharp,
                                  size: 24),
                              label: const Text(
                                'Submit',
                                style: TextStyle(
                                    color: kPrimaryLightColor, fontSize: 18),
                              ),
                              onPressed: () {
                                sendEmail(
                                    role: _roleController.text,
                                    email: _mailController.text,
                                    subject: _subjectController.text,
                                    message: _bodyController.text,
                                    deviceInfos: dataJson);
                                Utils.showSnackBar(
                                    "Bug was send to the BikeVS-Team. Thank you!",
                                    false);
                              },
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
          );
        },
      ),
    );
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
