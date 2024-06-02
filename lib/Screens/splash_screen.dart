import 'dart:developer';
import 'package:bolchaal/Screens/homepage.dart';
import 'package:bolchaal/api/api.dart';
import 'package:bolchaal/auth/login_screen.dart';
import 'package:bolchaal/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        //navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //body
      body: Stack(
        children: [
          // App logo
          Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset(
              'images/icon.png',
              width: mq.width * 0.7,
              height: mq.width * 0.7,
            ),
          ),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: const Text(
                'MADE IN NEPAL WITH ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              )),
        ],
      ),
    );
  }
}
