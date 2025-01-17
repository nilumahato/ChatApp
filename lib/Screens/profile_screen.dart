// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:bolchaal/api/api.dart';
import 'package:bolchaal/auth/login_screen.dart';
import 'package:bolchaal/helper/dialogs.dart';
import 'package:bolchaal/main.dart';
import 'package:bolchaal/model/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

//profile screen -- to show signedin user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // app bar
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        //floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
              backgroundColor: Colors.brown,
              onPressed: () async {
                //for showing progress dialog
                Dialogs.showProgressBar(context);

                await APIs.updateActiveStatus(false);

                //sign out from app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //for hiding progress dialog
                    Navigator.pop(context);

                    //for moving to home screen
                    Navigator.pop(context);

                    APIs.auth = FirebaseAuth.instance;

                    //replacing home screen with login screen
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  });
                });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
                selectionColor: Colors.white,
              )),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(children: [
                // for adding some space
                SizedBox(width: mq.width, height: mq.height * .03),

                //user profile picture
                Stack(
                  children: [
                    //profile picture
                    _image != null
                        ?
                        // local image
                        ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: Image.file(
                              File(_image!),
                              width: mq.height * .2,
                              height: mq.height * .2,
                              fit: BoxFit.cover,
                            ),
                          )
                        :
                        // image from server
                        ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: CachedNetworkImage(
                              width: mq.height * .2,
                              height: mq.height * .2,
                              fit: BoxFit.cover,
                              imageUrl: widget.user.image,
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                child: Icon(
                                  CupertinoIcons.person,
                                  color: Colors.brown,
                                ),
                              ),
                            ),
                          ),
                    //edit image button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        elevation: 1,
                        onPressed: () {
                          _showBottomSheet();
                        },
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.brown,
                        ),
                      ),
                    )
                  ],
                ),
                // for adding some space
                SizedBox(height: mq.height * .03),

                Text(
                  widget.user.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),

                // for adding some space
                SizedBox(height: mq.height * .03),

                TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (val) => APIs.me.name = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required field',
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.brown,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg. Albert Einstein',
                      label: const Text("Name")),
                ),
                // for adding some space
                SizedBox(height: mq.height * .03),

                // about input field
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (val) => APIs.me.about = val ?? '',
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : 'Required field',
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.info_outline,
                        color: Colors.brown,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'eg. Feeling Blessed.',
                      label: const Text("About")),
                ),

                // for adding some space
                SizedBox(height: mq.height * .05),

                //update profile button
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: const StadiumBorder(),
                        minimumSize: Size(mq.width * .5, mq.height * .06)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'Profile Update Successfully');
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 28,
                    ),
                    label: const Text(
                      'Update',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  //bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .08),
          children: [
            //pick profile picture label
            const Text(
              'Pick Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),

            // for adding some space
            SizedBox(
              height: mq.height * .02,
            ),

            //bottoms
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //pick from gallery buttom
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(mq.width * .3, mq.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                        setState(() {
                          _image = image.path;
                        });

                        APIs.updateProfilePicture(File(_image!));

                        // for hiding bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    child: const Icon(
                      Icons.image,
                      color: Colors.brown,
                    )),
                //take picture from camera button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .3, mq.height * .15)),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 80);
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });

                      APIs.updateProfilePicture(File(_image!));

                      // for hiding bottom sheet
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.brown,
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
