import 'dart:async';
import 'dart:developer';
import 'package:e_savior/DriverPanel/DriverPanel.dart';
import 'package:e_savior/Screens/InitialScreens/BottomNavbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'OnBoarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> getUserAndNavigate() async {
    // Check if a user is signed in
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.email != null) {
      String userEmail = currentUser.email!;

      log(userEmail);
      try {
        // Query 'users' collection where email matches
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        // Query 'drivers' collection where email matches
        QuerySnapshot driverSnapshot = await FirebaseFirestore.instance
            .collection('drivers')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // User found in the 'users' collection
          Timer(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavbar()),
            );
          });
        } else if (driverSnapshot.docs.isNotEmpty) {
          // User found in the 'drivers' collection
          Timer(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DriverAdminPage()),
            );
          });
        } else {
          // No user found in either collection, go to OnBoarding
          Timer(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OnBoarding()),
            );
          });
        }
      } catch (e) {
        print("Error checking user: $e");
        // If there was an error, navigate to OnBoarding
        Timer(const Duration(milliseconds: 3000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnBoarding()),
          );
        });
      }
    } else {
      // No user signed in, navigate to OnBoarding
      Timer(const Duration(milliseconds: 3000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoarding()),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserAndNavigate(); // Call the method on initState
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
                width: double.infinity,
                child: Lottie.network(
                  'https://lottie.host/25960982-183a-4ff1-87e9-87fd8bf9bb41/UfqxTWhfdU.json',
                ),
              ),
            ),
            const Center(
              child: Text(
                'eAmbulace',
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
