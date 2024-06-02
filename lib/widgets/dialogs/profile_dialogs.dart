import 'package:bolchaal/Screens/view_profile_screen.dart';
import 'package:bolchaal/main.dart';
import 'package:bolchaal/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  final ChatUser user;
  const ProfileDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(children: [
          //user profile picture
          Positioned(
            top: mq.height * .045,
            left: mq.width * .1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .25),
              child: CachedNetworkImage(
                width: mq.width * .5,
                fit: BoxFit.cover,
                imageUrl: user.image,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.brown,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: mq.width * .04,
            top: mq.height * .02,
            width: mq.width * .55,
            child: Text(
              user.name,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),

          Positioned(
            right: 8,
            top: 6,
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewProfileScreen(user: user)));
              },
              minWidth: 0,
              padding: const EdgeInsets.all(0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.info_outline,
                color: Colors.brown,
                size: 30,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
