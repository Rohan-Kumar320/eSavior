// import 'package:e_savior/Screens/Login&Register/Driver_login.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uuid/uuid.dart';
//
// class UserAmbulanceFormScreen extends StatefulWidget {
//   @override
//   _UserAmbulanceFormScreenState createState() =>
//       _UserAmbulanceFormScreenState();
// }
//
// class _UserAmbulanceFormScreenState extends State<UserAmbulanceFormScreen> {
//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _hospitalNameController = TextEditingController();
//   final TextEditingController _mobileNumberController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _zipCodeController = TextEditingController();
//
//   String? _selectedIdCard; // To store selected ID card
//   List<String> _idCardList = []; // To store fetched ID cards
//   bool _isLoading = true; // To show loading state
//   final Uuid uuid = Uuid(); // UUID generator
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchIdCards();
//   }
//
//   // Fetch the list of id_cards from the drivers collection
//   Future<void> _fetchIdCards() async {
//     try {
//       QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection('ambulances').get();
//       List<String> idCards = snapshot.docs
//           .map((doc) => doc['ambulance_type'] as String)
//           .toList(); // Fetch id_card values
//
//       setState(() {
//         _idCardList = idCards;
//         _isLoading = false; // Data fetching complete, stop loading
//       });
//     } catch (e) {
//       print('Error fetching ID cards: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching ID cards: $e')),
//       );
//       setState(() {
//         _isLoading = false; // Stop loading even if an error occurs
//       });
//     }
//   }
//
//   // Submit form and save request in Firestore
//   void _submitForm() async {
//     if (_selectedIdCard == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select an ID card')),
//       );
//       return;
//     }
//
//     String generatedUserId = uuid.v4(); // Generate a unique userId
//
//     await FirebaseFirestore.instance.collection('pendingRequests').add({
//       'userId': generatedUserId, // Add generated userId
//       'patientName': _patientNameController.text,
//       'hospitalName': _hospitalNameController.text,
//       'mobileNumber': _mobileNumberController.text,
//       'address': _addressController.text,
//       'zipCode': _zipCodeController.text,
//       'ambulance_type': _selectedIdCard, // Add selected ID card to request
//       'status': 'pending', // Initial status
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     // Clear the form fields
//     _patientNameController.clear();
//     _hospitalNameController.clear();
//     _mobileNumberController.clear();
//     _addressController.clear();
//     _zipCodeController.clear();
//     setState(() {
//       _selectedIdCard = null; // Reset selected ID card
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Your request is pending')),
//     );
//   }
//
//   // Logout function
//   void logoutUser() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen_Driver()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ambulance Request Form'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: logoutUser,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _isLoading
//             ? Center(child: CircularProgressIndicator()) // Show loading spinner
//             : Column(
//           children: [
//             TextFormField(
//               controller: _patientNameController,
//               decoration: InputDecoration(labelText: 'Patient Name'),
//             ),
//             TextFormField(
//               controller: _hospitalNameController,
//               decoration: InputDecoration(labelText: 'Hospital Name'),
//             ),
//             TextFormField(
//               controller: _mobileNumberController,
//               decoration: InputDecoration(labelText: 'Mobile Number'),
//             ),
//             TextFormField(
//               controller: _addressController,
//               decoration: InputDecoration(labelText: 'Address'),
//             ),
//             TextFormField(
//               controller: _zipCodeController,
//               decoration: InputDecoration(labelText: 'Zip Code'),
//             ),
//             SizedBox(height: 20),
//             // Dropdown for ID cards
//             DropdownButtonFormField<String>(
//               value: _selectedIdCard,
//               hint: Text('Select Ambulance'),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedIdCard = value;
//                 });
//               },
//               items: _idCardList.map((idCard) {
//                 return DropdownMenuItem<String>(
//                   value: idCard,
//                   child: Text(idCard),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitForm,
//               child: Text('Submit Request'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:e_savior/Screens/Login&Register/Driver_login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class UserAmbulanceFormScreen extends StatefulWidget {
  @override
  _UserAmbulanceFormScreenState createState() =>
      _UserAmbulanceFormScreenState();
}

class _UserAmbulanceFormScreenState extends State<UserAmbulanceFormScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController(); // Controller for request details

  String? _selectedIdCard; // To store selected ID card
  List<String> _idCardList = []; // To store fetched ID cards
  bool _isLoading = true; // To show loading state
  final Uuid uuid = Uuid(); // UUID generator

  // Predefined Karachi locations with latitudes and longitudes
  final List<Map<String, String>> _locations = [
    {'name': 'Clifton', 'lat': '24.8138', 'lng': '67.0281'},
    {'name': 'Gulshan-e-Iqbal', 'lat': '24.9244', 'lng': '67.0822'},
    {'name': 'North Nazimabad', 'lat': '24.9387', 'lng': '67.0722'},
    {'name': 'DHA Phase 5', 'lat': '24.8005', 'lng': '67.0355'},
    {'name': 'Korangi', 'lat': '24.8328', 'lng': '67.1373'},
    {'name': 'Saddar', 'lat': '24.8530', 'lng': '67.0305'},
    {'name': 'Malir', 'lat': '24.8998', 'lng': '67.1889'},
    {'name': 'Nazimabad', 'lat': '24.9242', 'lng': '67.0337'},
    {'name': 'Landhi', 'lat': '24.8467', 'lng': '67.2147'},
    {'name': 'PECHS', 'lat': '24.8615', 'lng': '67.0565'},
    {'name': 'Liaquatabad', 'lat': '24.9137', 'lng': '67.0408'},
    {'name': 'Shah Faisal Colony', 'lat': '24.8895', 'lng': '67.1577'},
    {'name': 'Orangi Town', 'lat': '24.9522', 'lng': '66.9736'},
    {'name': 'Surjani Town', 'lat': '25.0084', 'lng': '66.9606'},
    {'name': 'Keamari', 'lat': '24.8070', 'lng': '66.9731'},
    {'name': 'Manzoor Colony', 'lat': '24.8356', 'lng': '67.0465'},
    {'name': 'Garden', 'lat': '24.8721', 'lng': '67.0271'},
    {'name': 'Gulistan-e-Johar', 'lat': '24.9063', 'lng': '67.1329'},
    {'name': 'University Road', 'lat': '24.9248', 'lng': '67.0978'},
    {'name': 'Karimabad', 'lat': '24.9113', 'lng': '67.0699'}
  ];


  String? _selectedLocation;
  String? _selectedLat;
  String? _selectedLng;

  @override
  void initState() {
    super.initState();
    _fetchIdCards();
  }

  // Fetch the list of id_cards from the ambulances collection
  Future<void> _fetchIdCards() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('ambulances').get();
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
    if (_selectedIdCard == null || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an ID card and a location')),
      );
      return;
    }

    String generatedUserId = uuid.v4(); // Generate a unique userId

    // Get current date and time
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

    await FirebaseFirestore.instance.collection('pendingRequests').add({
      'userId': generatedUserId, // Add generated userId
      'patientName': _patientNameController.text,
      'hospitalName': _hospitalNameController.text,
      'mobileNumber': _mobileNumberController.text,
      'zipCode': _zipCodeController.text,
      'ambulance_type': _selectedIdCard, // Add selected ID card to request
      'location': _selectedLocation, // Add selected location
      'latitude': _selectedLat,
      'longitude': _selectedLng,
      'details': _detailsController.text,
      'status': 'pending', // Initial status
      'date_added': formattedDate, // Store date separately
      'time_added': formattedTime,
    });

    // Clear the form fields
    _patientNameController.clear();
    _hospitalNameController.clear();
    _mobileNumberController.clear();
    _zipCodeController.clear();
    _detailsController.clear();
    setState(() {
      _selectedIdCard = null;
      _selectedLocation = null; // Reset selected fields
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
      MaterialPageRoute(builder: (context) => LoginScreen_Driver()),
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
            : SingleChildScrollView(
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
                controller: _zipCodeController,
                decoration: InputDecoration(labelText: 'Zip Code'),
              ),
              TextField(
                controller: _detailsController,
                decoration: InputDecoration(
                  labelText: 'Details',
                  hintText: 'Enter details about the request',
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: InputDecoration(labelText: 'Select Location'),
                items: _locations.map((location) {
                  return DropdownMenuItem<String>(
                    value: location['name'],
                    child: Text(location['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                    final selected = _locations.firstWhere(
                            (location) => location['name'] == value);
                    _selectedLat = selected['lat'];
                    _selectedLng = selected['lng'];
                  });
                },
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
      ),
    );
  }
}
