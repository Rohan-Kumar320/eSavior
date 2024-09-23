import 'dart:async';
import 'package:e_savior/DriverPanel/DriverPanel.dart'; // Driver's home page
import 'package:e_savior/Screens/InitialScreens/BottomNavbar.dart';
import 'package:e_savior/Screens/InitialScreens/Home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OnBoarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');
    String? userType = prefs.getString('usertype');

    // Delay to simulate a splash screen duration
    await Future.delayed(Duration(seconds: 3));

    if (email != null && userType != null) {
      if (userType == 'driver') {
        // Navigate to Driver home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverAdminPage()),
        );
      } else if (userType == 'user') {
        // Navigate to User home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavbar()),
        );
      }
    } else {
      // If no user is logged in, navigate to the OnBoarding page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade300,
              Colors.red.shade500,
              Colors.red.shade800,
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: SizedBox(
                height: 499,
                width: double.infinity, // Adapt width to screen size
                child: Lottie.network(
                  'https://lottie.host/25960982-183a-4ff1-87e9-87fd8bf9bb41/UfqxTWhfdU.json',
                ),
              ),
            ),
            const Center(
              child: Text(
                'e-Savior',
                style: TextStyle(
                  fontFamily: 'Libre',
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
