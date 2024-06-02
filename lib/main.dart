import 'dart:developer';
import 'package:bolchaal/Screens/splash_screen.dart';
import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'firebase_options.dart';

//global object for accessing device screen size
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(const MyBolChaal());
  });
}

class MyBolChaal extends StatelessWidget {
  const MyBolChaal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BolChaal",
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 1,
            iconTheme: IconThemeData(color: Colors.brown),
            titleTextStyle: TextStyle(
                color: Colors.brown, fontWeight: FontWeight.w600, fontSize: 20),
            backgroundColor: Colors.white,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.brown,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)))),
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  log('\nNotification Channel Result: $result');
}
