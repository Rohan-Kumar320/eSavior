import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../LoginRegister/Login.dart';

class UserAmbulanceFormScreen extends StatefulWidget {
  @override
  _UserAmbulanceFormScreenState createState() =>
      _UserAmbulanceFormScreenState();
}

class _UserAmbulanceFormScreenState extends State<UserAmbulanceFormScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  String? _selectedIdCard; // To store selected ID card
  List<String> _idCardList = []; // To store fetched ID cards
  bool _isLoading = true; // To show loading state
  final Uuid uuid = Uuid(); // UUID generator

  @override
  void initState() {
    super.initState();
    _fetchIdCards();
  }

  // Fetch the list of id_cards from the drivers collection
  Future<void> _fetchIdCards() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('ambulances').get();
      List<String> idCards = snapshot.docs
          .map((doc) => doc['ambulance_type'] as String)
          .toList(); // Fetch id_card values

      setState(() {
        _idCardList = idCards;
        _isLoading = false; // Data fetching complete, stop loading
      });
    } catch (e) {
      print('Error fetching ID cards: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching ID cards: $e')),
      );
      setState(() {
        _isLoading = false; // Stop loading even if an error occurs
      });
    }
  }

  // Submit form and save request in Firestore
  void _submitForm() async {
    if (_selectedIdCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an ID card')),
      );
      return;
    }

    String generatedUserId = uuid.v4(); // Generate a unique userId

    await FirebaseFirestore.instance.collection('pendingRequests').add({
      'userId': generatedUserId, // Add generated userId
      'patientName': _patientNameController.text,
      'hospitalName': _hospitalNameController.text,
      'mobileNumber': _mobileNumberController.text,
      'address': _addressController.text,
      'zipCode': _zipCodeController.text,
      'ambulance_type': _selectedIdCard, // Add selected ID card to request
      'status': 'pending', // Initial status
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear the form fields
    _patientNameController.clear();
    _hospitalNameController.clear();
    _mobileNumberController.clear();
    _addressController.clear();
    _zipCodeController.clear();
    setState(() {
      _selectedIdCard = null; // Reset selected ID card
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Your request is pending')),
    );
  }

  // Logout function
  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
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
            onPressed: logoutUser,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading spinner
            : Column(
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
            // Dropdown for ID cards
            DropdownButtonFormField<String>(
              value: _selectedIdCard,
              hint: Text('Select Ambulance'),
              onChanged: (value) {
                setState(() {
                  _selectedIdCard = value;
                });
              },
              items: _idCardList.map((idCard) {
                return DropdownMenuItem<String>(
                  value: idCard,
                  child: Text(idCard),
                );
              }).toList(),
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
