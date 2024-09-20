import 'package:e_savior/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginRegister/Login.dart';
import 'SplashScreens/SplashScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString('userEmail');

  runApp(MyApplication(startScreen: userEmail == null ? LoginScreen() : Home()));
}

class MyApplication extends StatelessWidget {
  final Widget startScreen;

  MyApplication({required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BabyShopHub",
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
