import 'package:e_savior/Models/user_model.dart';
import 'package:e_savior/Screens/InitialScreens/Home.dart';
import 'package:e_savior/Screens/InitialScreens/contactus.dart';
import 'package:e_savior/Screens/InitialScreens/profilepage.dart';
import 'package:e_savior/Screens/InitialScreens/viewAmbulancesUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Firestore

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentIndex = 0;
  // String? userEmail; // Variable to store the user's email

  // Get the current user's email from Firestore
  // void getUserEmailFromFirestore() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     // Fetch user data from 'users' collection in Firestore based on UID
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();
  //
  //     // Check if the document exists and fetch the email
  //     if (userDoc.exists) {
  //       setState(() {
  //         userEmail = userDoc['email']; // Fetch the 'email' field from Firestore
  //       });
  //     } else {
  //       // Handle case where user document does not exist
  //       print("User document does not exist");
  //     }
  //   }
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   getUserEmailFromFirestore();
  //   // Fetch user email from Firestore on init
  //
  // }
  final UserModel userModel =UserModel();
  // List of pages corresponding to each index
  String? email;
  getString()async{
    final SharedPreferences _prefs =await SharedPreferences.getInstance();
    email= _prefs.getString("userEmail");
  }
  List<Widget> _screens() {
    return [
      HomeScreen(), // Index 0 - Home Screen
      ViewAmbulances(),
      UserProfilePage(),// Index 1 - Timer Screen
      Contactus(), // Index 3 - Contact Us Screen
    ];
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens()[currentIndex], // Display the screen based on current index
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        height: 70,
        decoration: BoxDecoration(
          color: Color(0xCC232C40).withOpacity(0.8),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavBarItem(icon: CupertinoIcons.home, index: 0),
            _buildNavBarItem(icon: CupertinoIcons.timer, index: 1),
            _buildNavBarItem(icon: CupertinoIcons.person, index: 2),
            _buildNavBarItem(icon: CupertinoIcons.calendar, index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem({required IconData icon, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentIndex == index ? Colors.white : Colors.white,
            size: 25,
          ),
          if (currentIndex == index)
            Container(
              margin: EdgeInsets.only(top: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
