import 'dart:async';
import 'package:e_savior/DriverPanel/DriverPanel.dart';
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
  Future getUser() async {
    //   Using Shared Prefrenes
    SharedPreferences userCred = await SharedPreferences.getInstance();
    var userEmail = userCred.getString("email");
    debugPrint('user Email: $userEmail');
    return userEmail;
  }

  @override
  void initState() {
    getUser().then((value) => {
      if (value != null)
        {
          // Mean  3_Second
          Timer(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => DriverAdminPage()));
          })
        }
      else
        {
          Timer(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => OnBoarding()));
          })
        }
    });
    super.initState();
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
                ])),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Center(
              child: SizedBox(
                height: 499,
                width: double.infinity, // Adapt width to screen size
                child: Lottie.network(
                    'https://lottie.host/25960982-183a-4ff1-87e9-87fd8bf9bb41/UfqxTWhfdU.json'),
              ),
            ),
            const Center(
              child: Text(
                'eAmbulace',
                style: TextStyle(
                  fontFamily: 'Libre',
                  fontWeight: FontWeight.bold, // Uncommented to make text bold
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
