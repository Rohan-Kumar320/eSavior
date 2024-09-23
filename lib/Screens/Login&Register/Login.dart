// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_savior/Models/user_model.dart';
// import 'package:e_savior/Patient/UserForm.dart';
// import 'package:e_savior/Screens/InitialScreens/BottomNavbar.dart';
// import 'package:e_savior/Screens/InitialScreens/Home.dart';
// import 'package:e_savior/Screens/Login&Register/Driver_login.dart';
// import 'package:e_savior/Screens/Login&Register/Register.dart';
// import 'package:e_savior/Screens/Login&Register/forgetPassword.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   bool isHide = true;
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//   final FirebaseAuth auth =FirebaseAuth.instance;
//   Future<void> patientLogin() async {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//
//     await auth.signInWithEmailAndPassword(email: email, password: password);
//     // Firestore query to check if driver with given email and password exists
//     QuerySnapshot snapshot = await _firestore
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .get();
//    final UserModel userModel =UserModel();
//    userModel.email = email;
//    print(userModel.email);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userEmail', email);
//     await prefs.setString('usertype', 'user');
//
//
//     String? value = prefs.getString('usertype');
//
//     if (snapshot.docs.isNotEmpty) {
//       // Login successful
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login successful $value , $email")),
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => BottomNavbar()),
//       );
//       // Navigate to driver panel or home screen
//     } else {
//       // Login failed
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid email or password")),
//       );
//     }
//   }
//
//   void goToRegister() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => RegisterScreen()),
//     );  }
//
//   void goToDriver(){
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => DriverLoginScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = mediaQuery.size.width;
//     final screenHeight = mediaQuery.size.height;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             bottom: 100,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: screenHeight * 0.999,
//               child: Center(
//                 child: Image.network(
//                   "https://cdn.pixabay.com/photo/2021/09/17/21/39/nurse-6633761_960_720.png",
//                   height: screenWidth * 0.99,
//                   width: screenWidth * 0.9,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: screenHeight * 0.1,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//               child: Center(
//                 child: RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: 'Welcome to ',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.07,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                           fontStyle: FontStyle.normal,
//                         ),
//                       ),
//                       TextSpan(
//                         text: 'eSavior Login!',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.07,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.redAccent,
//                           fontStyle: FontStyle.italic,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: screenHeight * 0.26,
//             left: screenWidth * 0.05,
//             right: screenWidth * 0.05,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: emailController,
//                       decoration: InputDecoration(
//                         labelText: 'Email Address',
//                         labelStyle: TextStyle(color: Colors.black),
//                         prefixIcon: Icon(Icons.email, color: Colors.black),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: passwordController,
//                       obscureText: isHide,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         labelStyle: TextStyle(color: Colors.black),
//                         prefixIcon: Icon(Icons.lock, color: Colors.black),
//                         suffixIcon: IconButton(
//                           icon: isHide ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
//                           onPressed: () {
//                             setState(() {
//                               isHide = !isHide;
//                             });
//                           },
//                           color: Colors.black,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: screenHeight * 0.01,
//             left: screenWidth * 0.05,
//             right: screenWidth * 0.05,
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: patientLogin,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     padding: EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 5,
//                     minimumSize: Size(140, 60),
//                   ),
//                   child: Text(
//                     'Login',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ForgotPassword()),
//                     );
//                   },
//
//                   child: Text(
//                     "Forgot password?",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextButton(
//                   onPressed: goToRegister,
//                   child: Text(
//                     "Not a user? Register here",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextButton(
//                   onPressed: goToDriver,
//                   child: Text(
//                     "If you are a driver? Login here",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_savior/Models/user_model.dart';
import 'package:e_savior/Patient/UserForm.dart';
import 'package:e_savior/Screens/InitialScreens/BottomNavbar.dart';
import 'package:e_savior/Screens/Login&Register/Driver_login.dart';
import 'package:e_savior/Screens/Login&Register/Register.dart';
import 'package:e_savior/Screens/Login&Register/ForgetPassword.dart'; // Ensure correct import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isHide = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> patientLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      QuerySnapshot snapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();

      if (snapshot.docs.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);
        await prefs.setString('usertype', 'user');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login successful: $email")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavbar()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid email or password")));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code == 'user-not-found' ? "No user found for that email." : "Wrong password provided.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void goToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void goToDriver() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DriverLoginScreen()));
  }

  void goToForgotPassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword())); // Correct import
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.999,
              child: Center(
                child: Image.network(
                  "https://cdn.pixabay.com/photo/2021/09/17/21/39/nurse-6633761_960_720.png",
                  height: screenWidth * 0.9,
                  width: screenWidth * 0.9,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome to ',
                        style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: 'eSavior Login!',
                        style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.26,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextField(emailController, 'Email Address', Icons.email, false),
                  SizedBox(height: 20),
                  _buildTextField(passwordController, 'Password', Icons.lock, true),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.01,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Column(
              children: [
                _buildElevatedButton('Login', patientLogin),
                SizedBox(height: 10),
                _buildTextButton("Forgot your password? Reset it here.", goToForgotPassword),
                SizedBox(height: 10),
                _buildTextButton("Don't have an account? Register now.", goToRegister),
                SizedBox(height: 10),
                _buildTextButton("Driver Login", goToDriver),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool obscure) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure && isHide,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.black),
          suffixIcon: obscure
              ? IconButton(
            icon: isHide ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                isHide = !isHide;
              });
            },
            color: Colors.black,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildElevatedButton(String text, VoidCallback onPressed) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _hovering ? Colors.redAccent : Colors.red[700],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            minimumSize: Size(140, 60),
            backgroundColor  : Colors.transparent, // Set to transparent to use the background color
          ),
          child: Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildTextButton(String text, VoidCallback onPressed) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveringText = true),
      onExit: (_) => setState(() => _hoveringText = false),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: _hoveringText ? Colors.redAccent : Colors.black,
            fontSize: 16,
            decoration: _hoveringText ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }

  bool _hovering = false;
  bool _hoveringText = false;
}
