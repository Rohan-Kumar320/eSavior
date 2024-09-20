import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../LoginRegister/Login.dart';

class UserAmbulanceFormScreen extends StatefulWidget {
  @override
  _UserAmbulanceFormScreenState createState() => _UserAmbulanceFormScreenState();
}

class _UserAmbulanceFormScreenState extends State<UserAmbulanceFormScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  void _submitForm() async {
    // Save the request data in Firestore
    await FirebaseFirestore.instance.collection('pendingRequests').add({
      'patientName': _patientNameController.text,
      'hospitalName': _hospitalNameController.text,
      'mobileNumber': _mobileNumberController.text,
      'address': _addressController.text,
      'zipCode': _zipCodeController.text,
      'status': 'pending', // Initial status
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show a message to the user that their request is pending
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Your request is pending')),
    );
  }

  // Logout function
  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ambulance Request Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logoutUser, // Call logout method on button press
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _patientNameController,
              decoration: InputDecoration(labelText: 'Patient Name'),
            ),
            TextFormField(
              controller: _hospitalNameController,
              decoration: InputDecoration(labelText: 'Hospital Name'),
            ),
            TextFormField(
              controller: _mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _zipCodeController,
              decoration: InputDecoration(labelText: 'Zip Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
