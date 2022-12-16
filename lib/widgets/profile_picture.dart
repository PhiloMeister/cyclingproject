import 'package:cyclingproject/theme/constants.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile.jpg"),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.all(
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
                onPressed: () {},
                child: const Icon(Icons.camera_alt_outlined),
              ),
            ),
          )
        ],
      ),
    );
  }
}
