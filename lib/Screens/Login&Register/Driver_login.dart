// import 'package:e_savior/DriverPanel/DriverPanel.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class DriverLoginScreen extends StatefulWidget {
//   @override
//   _DriverLoginScreenState createState() => _DriverLoginScreenState();
// }
//
// class _DriverLoginScreenState extends State<DriverLoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   void _loginDriver() async {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     // Firestore query to check if driver with given email and password exists
//     QuerySnapshot snapshot = await _firestore
//         .collection('drivers')
//         .where('email', isEqualTo: email)
//         .get();
//
//     if (snapshot.docs.isNotEmpty) {
//       // Login successful
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login successful")),
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => DriverAdminPage()),
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 50),
//                 Image.network('data:image/jpeg;base64,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'),
//                 SizedBox(height: 30),
//                 Text(
//                   'Ambulance Driver Login',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.redAccent ,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Please enter your credentials to continue',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 SizedBox(height: 40),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 15,
//                         offset: Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         TextField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             labelStyle: TextStyle(color: Colors.redAccent ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.redAccent ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.redAccent ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.redAccent , width: 2),
//                             ),
//                             prefixIcon: Icon(
//                               Icons.email,
//                               color: Colors.redAccent ,
//                             ),
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         SizedBox(height: 20),
//                         TextField(
//                           controller: _passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             labelStyle: TextStyle(color: Colors.redAccent ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.redAccent ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.redAccent ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.redAccent , width: 2),
//                             ),
//                             prefixIcon: Icon(
//                               Icons.lock,
//                               color: Colors.redAccent ,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                         ElevatedButton(
//                           onPressed: _loginDriver,
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.white, backgroundColor: Colors.redAccent , padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ), // Text color
//                             elevation: 5,
//                           ),
//                           child: Text(
//                             'Login',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:e_savior/DriverPanel/DriverPanel.dart';
import 'package:e_savior/Screens/InitialScreens/Home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverLoginScreen extends StatefulWidget {
  @override
  _DriverLoginScreenState createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isHide = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> userLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email == "admin@gmail.com" && password == "admin@123") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);
        await prefs.setString('usertype', 'driver');

        String? value = prefs.getString('usertype');

        emailController.clear();
        passwordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful $value')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverAdminPage()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  void goToRegister() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.network('data:image/jpeg;base64,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'), // Insert the correct image URL
                SizedBox(height: 30),
                Text(
                  'Ambulance Driver Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Please enter your credentials to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.redAccent, width: 2),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.redAccent,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: isHide,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.redAccent, width: 2),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.redAccent,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(isHide
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isHide = !isHide;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: userLogin,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}