import 'dart:io';

import 'package:cyclingproject/theme/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String imageUrl = "";
  final Reference storageRef = FirebaseStorage.instance
      .ref()
      .child("${FirebaseAuth.instance.currentUser?.uid}/profilepic.jpg");

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 115,
      maxHeight: 115,
      imageQuality: 75,
    );

    await storageRef.putFile(File(image!.path));

    storageRef.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageUrl == ""
                    ? const AssetImage("assets/images/profile.jpg")
                        as ImageProvider
                    : NetworkImage(imageUrl),
                fit: BoxFit.fill,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          Positioned(
            right: -15,
            bottom: -10,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: kPrimaryLightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: kPrimaryLightColor),
                  ),
                  backgroundColor: kPrimaryColor,
                ),
                onPressed: () {
                  pickUploadImage();
                },
                child: const Icon(Icons.camera_alt_outlined),
              ),
            ),
          )
        ],
      ),
    );
  }
}
