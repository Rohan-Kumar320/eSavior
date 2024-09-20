import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';

import 'Login.dart'; // Import the package

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController pushNotificationController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  String? selectedGender;
  final List<String> _genders = ['Male', 'Female'];

  void userRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      String userId = Uuid().v1();
      String email = emailController.text;
      String password = passwordController.text;

      DateTime now = DateTime.now().toLocal();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedTime = DateFormat('HH:mm:ss').format(now);

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        await FirebaseFirestore.instance.collection("users").doc(userId).set({
          "name": userNameController.text,
          "id": userId,
          "email": email,
          "contact": contactController.text,
          "gender": selectedGender,
          "age": ageController.text,
          "pushNotification": "",
          "registeredAt": {
            "date": formattedDate,
            "time": formattedTime
          },
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);

        userNameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        contactController.clear();
        pushNotificationController.clear();
        ageController.clear();
        setState(() {
          selectedGender = null;
        });


        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.message ?? 'Registration failed',
                style: TextStyle(color: Colors.white),
              ),
            ));
      }
    }
  }

  void goToLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset email sent',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Failed to send password reset email',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  void showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController resetEmailController = TextEditingController();
        return AlertDialog(
          title: Text('Forgot Password'),
          content: TextField(
            controller: resetEmailController,
            decoration: InputDecoration(hintText: 'Enter your email'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetPassword(resetEmailController.text);
              },
              child: Text('Send Email'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/homescreenimages/mama.png"),
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(1900),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome to ',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      TextSpan(
                        text: 'BabyShopHub!',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple, // Purple color
                          fontStyle: FontStyle.italic, // Italic font
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.length > 50) {
                          return 'Name cannot be longer than 50 characters';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Name must contain only alphabets';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isPasswordHidden,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordHidden ? Icons.visibility : Icons.visibility_off, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: isConfirmPasswordHidden,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(isConfirmPasswordHidden ? Icons.visibility : Icons.visibility_off, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordHidden = !isConfirmPasswordHidden;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Confirm your password',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: contactController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.phone, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Enter your contact number',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                          return 'Enter a valid contact number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      items: _genders.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGender = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.transgender, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Select your gender',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.cake, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: 'Enter your age',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        if (int.tryParse(value) == null || int.tryParse(value)! < 0) {
                          return 'Enter a valid age';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: userRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        minimumSize: Size(160, 60),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextButton(
                      onPressed: goToLogin,
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}