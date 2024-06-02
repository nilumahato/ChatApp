import 'dart:developer';
import 'dart:io';
import 'package:bolchaal/Screens/homepage.dart';
import 'package:bolchaal/api/api.dart';
import 'package:bolchaal/helper/dialogs.dart';
import 'package:bolchaal/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//handle google login button click
  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogl: $e');
      Dialogs.showSnackbar(context, 'Something went wrong(Check Internet!)');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to BolChaal...!'),
      ),
      //body
      body: Stack(
        children: [
          // App logo with scaling and translation
          FractionalTranslation(
            translation: const Offset(0.0, -0.1), // Adjust the Y value here
            child: Center(
              child: ScaleTransition(
                scale: _animation,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'images/icon.png',
                    width: mq.width * 0.7,
                    height: mq.width * 0.7,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 900,
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                _handleGoogleBtnClick();
              },
              icon: Image.asset('images/google.png', height: mq.height * .03),
              label: RichText(
                text: const TextSpan(
                    style: TextStyle(color: Colors.brown, fontSize: 16),
                    children: [
                      TextSpan(text: 'Login with '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
