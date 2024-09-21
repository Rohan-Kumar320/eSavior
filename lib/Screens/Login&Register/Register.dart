import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Hospital Logo
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://cdn2.iconfinder.com/data/icons/covid-19-1/64/30-Doctor-512.png'), // Replace with hospital logo
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Title with subtitle
                  Column(
                    children: [
                      Text(
                        'eSavior Hospital',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Patient Registration',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Name Field
                  TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person, color: Colors.redAccent),
                      filled: true,
                      fillColor: Colors.redAccent.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                  SizedBox(height: 16),
                  // Email Field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.redAccent),
                      filled: true,
                      fillColor: Colors.redAccent.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                  SizedBox(height: 16),
                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.redAccent),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.redAccent.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                  SizedBox(height: 16),
                  // Confirm Password Field
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: isConfirmPasswordHidden,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.redAccent),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordHidden ? Icons.visibility : Icons.visibility_off,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordHidden = !isConfirmPasswordHidden;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.redAccent.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                  SizedBox(height: 16),
                  // Contact Field
                  TextFormField(
                    controller: contactController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      prefixIcon: Icon(Icons.phone, color: Colors.redAccent),
                      filled: true,
                      fillColor: Colors.redAccent.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                  SizedBox(height: 16),
                  // Gender Dropdown
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
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.transgender, color: Colors.redAccent),
                      filled: true,
                      fillColor: Colors.redAccent.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Age Field
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      prefixIcon: Icon(Icons.cake, color: Colors.redAccent),
                      filled: true,
                      fillColor: Colors.redAccent.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                  SizedBox(height: 30),
                  // Register Button
                  ElevatedButton(
                    onPressed: userRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Login Redirect
                  TextButton(
                    onPressed: goToLogin,
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}