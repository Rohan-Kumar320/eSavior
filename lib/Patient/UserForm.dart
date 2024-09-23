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
  final TextEditingController _detailsController = TextEditingController();

  String? _selectedIdCard; // To store selected ID card
  String? _selectedRequestType; // To store selected emergency type
  List<String> _idCardList = []; // To store fetched ID cards
  bool _isLoading = true; // To show loading state
  final Uuid uuid = Uuid(); // UUID generator

  // Predefined locations with latitudes and longitudes
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

  // Custom VIP alert dialog
  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), // Rounded corners for the dialog
          elevation: 12,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white, // Background color for the dialog
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the dialog compact
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ), // Success icon
                SizedBox(height: 20),
                Text(
                  'Request Submitted',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ), // TextStyle for the title
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'Your request is pending. Please wait for approval.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ), // TextStyle for the message
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.blue, // Button color
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ), // Button text style
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Submit form and save request in Firestore
  void _submitForm() async {
    if (_selectedIdCard == null || _selectedLocation == null || _selectedRequestType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an ambulance, location, and request type')),
      );
      return;
    }

    String generatedUserId = uuid.v4(); // Generate a unique userId

    // Get current date and time
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

    await FirebaseFirestore.instance.collection('pendingRequests').add({
      'userId': generatedUserId,
      'patientName': _patientNameController.text,
      'hospitalName': _hospitalNameController.text,
      'mobileNumber': _mobileNumberController.text,
      'zipCode': _zipCodeController.text,
      'ambulance_type': _selectedIdCard,
      'location': _selectedLocation,
      'latitude': _selectedLat,
      'longitude': _selectedLng,
      'request_type': _selectedRequestType,
      'details': _detailsController.text,
      'status': 'pending',
      'date_added': formattedDate,
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
      _selectedLocation = null;
      _selectedRequestType = null; // Reset selected fields
    });

    // Show the custom VIP dialog
    _showCustomDialog();
  }

  // Logout function
  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DriverLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Ambulance Request'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logoutUser,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Details',
                        style: theme.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _patientNameController,
                        decoration: InputDecoration(
                          labelText: 'Patient Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _hospitalNameController,
                        decoration: InputDecoration(
                          labelText: 'Hospital Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _mobileNumberController,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _zipCodeController,
                        decoration: InputDecoration(
                          labelText: 'Zip Code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _detailsController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Details',
                          hintText: 'Enter additional details...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        decoration: InputDecoration(
                          labelText: 'Select Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
                      DropdownButtonFormField<String>(
                        value: _selectedIdCard,
                        hint: Text('Select Ambulance'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
                      DropdownButtonFormField<String>(
                        value: _selectedRequestType,
                        hint: Text('Select Request Type'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedRequestType = value;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Emergency',
                            child: Text('Emergency'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Non-Emergency',
                            child: Text('Non-Emergency'),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: Text('Submit Request', style: TextStyle(fontSize: 18,color: Colors.white)),
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
    );
  }
}