import 'package:e_savior/AdminDashboard/add_ambulances.dart';
import 'package:e_savior/Screens/InitialScreens/aboutus.dart';
import 'package:e_savior/SplashScreens/OnBoarding.dart';
import 'package:e_savior/SplashScreens/SplashScreen.dart';
import 'package:e_savior/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_savior/AdminDashboard/add_ambulance_driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Login&Register/Driver_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure this is configured correctly
  );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
