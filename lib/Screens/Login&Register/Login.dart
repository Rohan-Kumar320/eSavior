import 'package:e_savior/DriverPanel/DriverPanel.dart';
import 'package:e_savior/Screens/InitialScreens/Home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen_driver extends StatefulWidget {
  @override
  _LoginScreen_driverState createState() => _LoginScreen_driverState();
}

class _LoginScreen_driverState extends State<LoginScreen_driver> {
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
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => Admindashboard()),
      // );
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);

        emailController.clear();
        passwordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
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

  void goToRegister() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => RegisterScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Ambulance!'),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: isHide,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(isHide ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: userLogin,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
