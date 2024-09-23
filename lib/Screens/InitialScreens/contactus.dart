import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_savior/Screens/InitialScreens/Home.dart';
import 'package:e_savior/Screens/InitialScreens/reviewForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'BottomNavBar.dart';

class Contactus extends StatefulWidget {
  const Contactus({super.key});

  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNum = TextEditingController();
  final TextEditingController message = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AddFeedbackData(String name, String email, String phoneNum, String feedback) async {
    if (!_formKey.currentState!.validate()) {
      log("Enter All The Fields Correctly");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Row(
            children: const [
              Icon(Icons.sentiment_dissatisfied_outlined, color: Colors.white),
              SizedBox(width: 5),
              Text("Please fill in all required fields correctly!"),
            ],
          ),
        ),
      );
    } else {
      FirebaseFirestore.instance.collection("Contact").doc(email).set({
        "Name": name,
        "Email": email,
        "Phone": phoneNum,
        "Message": message,
      }).then((value) {
        log("Data Inserted");
        _clearFields();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Row(
              children: const [
                Icon(Icons.tag_faces_outlined, color: Colors.white),
                SizedBox(width: 5),
                Text("Your Feedback Has Been Submitted!"),
              ],
            ),
          ),
        );
      });
    }
  }

  void _clearFields() {
    name.clear();
    email.clear();
    phoneNum.clear();
    message.clear();
  }

  @override
  Widget build(BuildContext context) {
    final reswidth = MediaQuery.of(context).size.width;
    final resheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavbar(),));
          },
        ),
        title: const Text('Contact Us',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.red[500],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: resheight * 0.02),
                _buildCard(
                  child: _buildTextField(
                    controller: name,
                    label: "Enter Your Name",
                    icon: Icons.person_2_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: resheight * 0.03),
                _buildCard(
                  child: _buildTextField(
                    controller: email,
                    label: "Enter Your Email",
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: resheight * 0.03),
                _buildCard(
                  child: _buildTextField(
                    controller: phoneNum,
                    label: "Enter Your Phone Number",
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty || !RegExp(r'^\d{11}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: resheight * 0.03),
                _buildCard(
                  child: _buildTextField(
                    controller: message,
                    label: "Message",
                    icon: Icons.feedback_outlined,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write your Message';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: resheight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildElevatedButton(
                      onPressed: () {
                        AddFeedbackData(
                          name.text.trim(),
                          email.text.trim(),
                          phoneNum.text.trim(),
                          message.text.trim(),
                        );
                      },
                      label: "Submit",
                      color: Colors.red,
                    ),
                    SizedBox(width: reswidth * 0.05),
                    _buildElevatedButton(
                      onPressed: _clearFields,
                      icon: Icons.delete,
                      color: Color(0xCC232C40),
                      isIconButton: true,
                    ),
                    SizedBox(width: reswidth * 0.05),
                    _buildElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReviewForm()),
                        );
                      },
                      label: "Review",
                      color: Color(0xCC232C40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    String? label,
    IconData? icon,
    required Color color,
    bool isIconButton = false,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
      onPressed: onPressed,
      child: isIconButton
          ? Icon(icon, color: Colors.white)
          : Text(label!, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red[400]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}
