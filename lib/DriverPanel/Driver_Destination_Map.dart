//Old Code
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_savior/DriverPanel/driverContact.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class DriveMap extends StatefulWidget {
//   const DriveMap({super.key});
//
//   @override
//   State<DriveMap> createState() => _DriveMapState();
// }
//
// class _DriveMapState extends State<DriveMap> {
//   // Firestore and FirebaseAuth instances
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Example current latitude and longitude of the driver
//   final String currentPositionLatitude = "24.872268533546208";
//   final String currentPositionLongitude = "67.07051700494749";
//
//   // List to store fetched accepted bookings for the current user
//   List<Map<String, dynamic>> _bookings = [];
//
//   // Function to fetch bookings with status 'accepted' for the current user
//   Future<void> _fetchAcceptedBookings() async {
//     try {
//       // Get the current user ID
//       String? userId = _auth.currentUser?.uid;
//
//       if (userId != null) {
//         // Query Firestore to get bookings where status is 'accepted' and belongs to the current user
//         QuerySnapshot snapshot = await _firestore
//             .collection('Ambulance_book')
//             .where('status', isEqualTo: 'accepted')
//             .where('driverId', isEqualTo: userId)
//             .get();
//
//         setState(() {
//           // Convert each document into a map and add it to the list
//           _bookings = snapshot.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching bookings: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAcceptedBookings(); // Fetch bookings when the widget is initialized
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Accepted bookings list
//           Expanded(
//             child: _bookings.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               itemCount: _bookings.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> booking = _bookings[index];
//                 final lat = booking['latitude'];
//                 final lng = booking['longitude'];
//                 return ListTile(
//                   title: Text('Destination: ${booking['address']}'),
//                   subtitle: Text('Hospital: ${booking['hospitalName']}'),
//                   // Icon on the right to open Google Maps
//                   trailing: Row(
//                     children: [
//                       IconButton(
//
//                         icon: const Icon(Icons.phone_outlined),
//                         onPressed: () {
//
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.directions),
//                         onPressed: () {
//                           _launchGoogleMapsDirections(context, '$lat,$lng');
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // Stream of ambulance requests ordered by timestamp
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('ambulance_requests')
//                   .orderBy('timestamp', descending: true) // Order by timestamp
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('Error fetching requests'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No ambulance requests available'));
//                 }
//
//                 final requests = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   itemCount: requests.length,
//                   itemBuilder: (context, index) {
//                     final request =
//                     requests[index].data() as Map<String, dynamic>;
//                     final lat = request['latitude'];
//                     final lng = request['longitude'];
//                     final details = request['details'];
//                     final location = request['address'];
//
//                     return ListTile(
//                       title: Text('Request from $location'),
//                       subtitle: Text('Details: $details\nLat: $lat, Long: $lng'),
//                       // Icon on the right to open Google Maps
//                       trailing: IconButton(
//                         icon: const Icon(Icons.directions),
//                         onPressed: () {
//                           _launchGoogleMapsDirections(context, '$lat,$lng');
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to launch Google Maps with directions
//   Future<void> _launchGoogleMapsDirections(
//       BuildContext context, String latLang) async {
//     final Uri url = Uri.parse(
//         'https://www.google.com/maps/dir/$currentPositionLatitude,$currentPositionLongitude/$latLang');
//
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch $url')),
//       );
//     }
//   }
//

//latest Code

// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class DriveMap extends StatefulWidget {
//   const DriveMap({super.key});
//
//   @override
//   State<DriveMap> createState() => _DriveMapState();
// }
//
// class _DriveMapState extends State<DriveMap> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final String currentPositionLatitude = "24.872268533546208";
//   final String currentPositionLongitude = "67.07051700494749";
//
//   List<Map<String, dynamic>> _bookings = [];
//
//   Future<void> _fetchAcceptedBookings() async {
//     try {
//       String? userId = _auth.currentUser?.uid;
//
//       if (userId != null) {
//         QuerySnapshot snapshot = await _firestore
//             .collection('Ambulance_book')
//             .where('status', isEqualTo: 'accepted')
//             .where('driverId', isEqualTo: userId)
//             .get();
//
//         setState(() {
//           _bookings = snapshot.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching bookings: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAcceptedBookings();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _bookings.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _bookings.length,
//                     itemBuilder: (context, index) {
//                       Map<String, dynamic> booking = _bookings[index];
//                       final lat = booking['latitude'];
//                       final lng = booking['longitude'];
//
//                       return ListTile(
//                         title: Text('Destination: ${booking['address']}'),
//                         subtitle: Text('Hospital: ${booking['hospitalName']}'),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.phone_outlined),
//                               onPressed: () {
//                                 String phoneNumber = booking['mobileNumber'];
//                                 _launchPhoneDialer(
//                                     phoneNumber); // Call to launch dialer
//                                 log(phoneNumber);
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.directions),
//                               onPressed: () {
//                                 _launchGoogleMapsDirections(
//                                     context, '$lat,$lng');
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('ambulance_requests')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('Error fetching requests'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                       child: Text('No ambulance requests available'));
//                 }
//
//                 final requests = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   itemCount: requests.length,
//                   itemBuilder: (context, index) {
//                     final request =
//                         requests[index].data() as Map<String, dynamic>;
//                     final lat = request['latitude'];
//                     final lng = request['longitude'];
//                     final details = request['details'];
//                     final location = request['address'];
//
//                     return ListTile(
//                       title: Text('Request from $location'),
//                       subtitle:
//                           Text('Details: $details\nLat: $lat, Long: $lng'),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.directions),
//                         onPressed: () {
//                           _launchGoogleMapsDirections(context, '$lat,$lng');
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to launch Google Maps with directions
//   Future<void> _launchGoogleMapsDirections(
//       BuildContext context, String latLng) async {
//
//     final Uri url = Uri.parse(
//         'https://www.google.com/maps/dir/$currentPositionLatitude,$currentPositionLongitude/$latLng');
//
//     if (await launchUrl(url)) {
//       debugPrint(currentPositionLatitude + "  " + currentPositionLongitude);
//       print("object");
//       await launchUrl(url, mode: LaunchMode.inAppWebView);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not launch Google Maps')),
//       );
//     }
//   }
//
//   // Function to launch the phone dialer
//   Future<void> _launchPhoneDialer(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch dialer for $phoneNumber')),
//       );
//     }
//   }
// }

// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class DriveMap extends StatefulWidget {
//   const DriveMap({super.key});
//
//   @override
//   State<DriveMap> createState() => _DriveMapState();
// }
//
// class _DriveMapState extends State<DriveMap> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final String currentPositionLatitude = "24.872268533546208";
//   final String currentPositionLongitude = "67.07051700494749";
//
//   List<Map<String, dynamic>> _bookings = [];
//   List<Map<String, dynamic>> _completedBookings = [];
//
//   Future<void> _fetchAcceptedBookings() async {
//     try {
//       String? userId = _auth.currentUser?.uid;
//
//       if (userId != null) {
//         QuerySnapshot snapshot = await _firestore
//             .collection('Ambulance_book')
//             .where('status', isEqualTo: 'accepted')
//             .where('driverId', isEqualTo: userId)
//             .get();
//
//         setState(() {
//           _bookings = snapshot.docs
//               .map((doc) => {
//             'id': doc.id, // Document ID to handle removal later
//             ...doc.data() as Map<String, dynamic>,
//           })
//               .toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching bookings: $e');
//     }
//   }
//
//   Future<void> _fetchCompletedBookings() async {
//     try {
//       String? userId = _auth.currentUser?.uid;
//
//       if (userId != null) {
//         QuerySnapshot snapshot = await _firestore
//             .collection('completed_request')
//             .where('driverId', isEqualTo: userId)
//             .get();
//
//         setState(() {
//           _completedBookings = snapshot.docs
//               .map((doc) => {
//             'id': doc.id, // Document ID
//             ...doc.data() as Map<String, dynamic>,
//           })
//               .toList();
//         });
//       }
//     } catch (e) {
//       print('Error fetching completed bookings: $e');
//     }
//   }
//
//   Future<void> _markAsCompleted(Map<String, dynamic> booking, String bookingId) async {
//     try {
//       // Move the booking data to the `completed_request` collection with autogenerated ID
//       await _firestore.collection('completed_request').add({
//         ...booking, // Copy the booking data
//         'status': 'completed', // Set status to completed
//         'completedAt': FieldValue.serverTimestamp(), // Add timestamp when marked completed
//       });
//
//       // Remove the booking from the `Ambulance_book` collection
//       await _firestore.collection('Ambulance_book').doc(bookingId).delete();
//
//       // Remove the completed booking from the active list
//       setState(() {
//         _bookings.removeWhere((b) => b['id'] == bookingId);
//       });
//
//       // Fetch updated completed bookings
//       _fetchCompletedBookings();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Booking marked as completed')),
//       );
//     } catch (e) {
//       print('Error marking as completed: $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAcceptedBookings();
//     _fetchCompletedBookings();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _bookings.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               itemCount: _bookings.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> booking = _bookings[index];
//                 final lat = booking['latitude']?.toString() ?? '0.0';  // Null-safety check with fallback
//                 final lng = booking['longitude']?.toString() ?? '0.0'; // Null-safety check with fallback
//                 final String bookingId = booking['id'] ?? 'unknown';   // Ensure booking ID isn't null
//
//                 String _status = "Active"; // Default status
//
//                 return ListTile(
//                   title: Text('Destination: ${booking['address'] ?? 'Unknown Address'}'),  // Null check
//                   subtitle: Text('Hospital: ${booking['hospitalName'] ?? 'Unknown Hospital'}'), // Null check
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.phone_outlined),
//                         onPressed: () {
//                           String phoneNumber = booking['mobileNumber'] ?? '0000000000'; // Fallback for phone number
//                           _launchPhoneDialer(phoneNumber);
//                           log(phoneNumber);
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.directions),
//                         onPressed: () {
//                           _launchGoogleMapsDirections(context, '$lat,$lng');
//                         },
//                       ),
//                       DropdownButton<String>(
//                         value: _status,
//                         items: _status == "Active"
//                             ? const [
//                           DropdownMenuItem(
//                             value: 'Active',
//                             child: Text('Active'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Completed',
//                             child: Text('Completed'),
//                           ),
//                         ]
//                             : const [
//                           DropdownMenuItem(
//                             value: 'Completed',
//                             child: Text('Completed (Read-only)'),
//                           ),
//                         ],
//                         onChanged: (String? newStatus) async {
//                           if (newStatus == 'Completed') {
//                             await _markAsCompleted(booking, bookingId);
//                             setState(() {
//                               _status = newStatus!;
//                             });
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 20), // Spacer for UI separation
//           const Text(
//             'Completed Bookings',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: _completedBookings.isEmpty
//                 ? const Center(child: Text('No completed bookings available'))
//                 : ListView.builder(
//               itemCount: _completedBookings.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> completedBooking = _completedBookings[index];
//                 return ListTile(
//                   title: Text('Destination: ${completedBooking['address'] ?? 'Unknown Address'}'),
//                   subtitle: Text('Hospital: ${completedBooking['hospitalName'] ?? 'Unknown Hospital'}'),
//                   trailing: const Icon(Icons.check_circle, color: Colors.green),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Function to launch Google Maps with directions
//   Future<void> _launchGoogleMapsDirections(
//       BuildContext context, String latLng) async {
//     final Uri url = Uri.parse(
//         'https://www.google.com/maps/dir/$currentPositionLatitude,$currentPositionLongitude/$latLng');
//
//     if (await launchUrl(url)) {
//       debugPrint(currentPositionLatitude + "  " + currentPositionLongitude);
//       await launchUrl(url, mode: LaunchMode.inAppWebView);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not launch Google Maps')),
//       );
//     }
//   }
//
//   // Function to launch the phone dialer
//   Future<void> _launchPhoneDialer(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch dialer for $phoneNumber')),
//       );
//     }
//   }
// }

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_savior/DriverPanel/DriverPanel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DriveMap extends StatefulWidget {
  const DriveMap({super.key});

  @override
  State<DriveMap> createState() => _DriveMapState();
}

class _DriveMapState extends State<DriveMap> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String currentPositionLatitude = "24.872268533546208";
  final String currentPositionLongitude = "67.07051700494749";

  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _completedBookings = [];

  Future<void> _fetchAcceptedBookings() async {
    try {
      String? userId = _auth.currentUser?.uid;

      if (userId != null) {
        QuerySnapshot snapshot = await _firestore
            .collection('Ambulance_book')
            .where('status', isEqualTo: 'accepted')
            .where('driverId', isEqualTo: userId)
            .get();

        setState(() {
          _bookings = snapshot.docs
              .map((doc) => {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          })
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  Future<void> _fetchCompletedBookings() async {
    try {
      String? userId = _auth.currentUser?.uid;

      if (userId != null) {
        QuerySnapshot snapshot = await _firestore
            .collection('completed_request')
            .where('driverId', isEqualTo: userId)
            .get();

        setState(() {
          _completedBookings = snapshot.docs
              .map((doc) => {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          })
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching completed bookings: $e');
    }
  }

  Future<void> _markAsCompleted(Map<String, dynamic> booking, String bookingId) async {
    try {
      await _firestore.collection('completed_request').add({
        ...booking,
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('Ambulance_book').doc(bookingId).delete();

      setState(() {
        _bookings.removeWhere((b) => b['id'] == bookingId);
      });

      _fetchCompletedBookings();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking marked as completed')),
      );
    } catch (e) {
      print('Error marking as completed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAcceptedBookings();
    _fetchCompletedBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DriverAdminPage()),
            );          },
        ),
        title: const Text(
          "Driver Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader("Active Bookings"),
            const SizedBox(height: 10),
            Expanded(
              child: _bookings.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _bookings.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> booking = _bookings[index];
                  final lat = booking['latitude']?.toString() ?? '0.0';
                  final lng = booking['longitude']?.toString() ?? '0.0';
                  final String bookingId = booking['id'] ?? 'unknown';

                  String _status = "Active";

                  return _buildBookingCard(
                      booking,
                      bookingId,
                      lat,
                      lng,
                      _status
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _sectionHeader('Completed Bookings'),
            const SizedBox(height: 10),
            Expanded(
              child: _completedBookings.isEmpty
                  ? const Center(
                child: Text(
                  'No completed bookings available',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _completedBookings.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> completedBooking = _completedBookings[index];
                  return _buildCompletedBookingCard(completedBooking);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom section header style
  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // Function to build each booking card with clean, modern design
  Widget _buildBookingCard(
      Map<String, dynamic> booking, String bookingId, String lat, String lng, String status) {
    return Card(
      elevation: 6, // Elevated to create depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for a modern look
      ),
      color: Colors.white, // Clean background
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Symmetric margins for better spacing
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for clean spacing inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for patient and driver names
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Patient: ${booking['patientName'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87, // Bold text for emphasis
                    ),
                  ),
                ),
                const Icon(
                  Icons.local_hospital,
                  color: Colors.redAccent,
                  size: 28, // Icon size for visual interest
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Divider for better structure
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),
            // Row for Driver Information
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Driver: ${booking['driverName'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54, // Softer color for less emphasis
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row for Driver Email
            Row(
              children: [
                const Icon(Icons.email, color: Colors.orangeAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Email: ${booking['driverEmail'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row for Hospital Information
            Row(
              children: [
                const Icon(Icons.local_hospital, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hospital: ${booking['hospitalName'] ?? 'Unknown Hospital'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // ID Card Info
            Row(
              children: [
                const Icon(Icons.credit_card, color: Colors.purpleAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ID Card: ${booking['id_card'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Date Added
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Date: ${booking['date_added'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Time Added
            Row(
              children: [
                const Icon(Icons.access_time_outlined, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Time: ${booking['time_added'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Action Icons for Phone, Directions, and Status
            _buildActionIcons(booking, bookingId, lat, lng, status),
          ],
        ),
      ),
    );
  }

  // Function to build action icons (Phone, Directions, Status dropdown)
  Widget _buildActionIcons(Map<String, dynamic> booking, String bookingId, String lat, String lng, String status) {
    return Wrap(
      spacing: 8,
      children: [
        IconButton(
          icon: const Icon(Icons.phone_outlined, color: Colors.green),
          onPressed: () {
            String phoneNumber = booking['mobileNumber'] ?? '0000000000';
            _launchPhoneDialer(phoneNumber);
            log(phoneNumber);
          },
        ),
        IconButton(
          icon: const Icon(Icons.directions, color: Colors.redAccent),
          onPressed: () {
            _launchGoogleMapsDirections(context, '$lat,$lng');
          },
        ),
        DropdownButton<String>(
          value: status,
          icon: const Icon(Icons.more_vert),
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.redAccent,
          ),
          items: status == "Active"
              ? const [
            DropdownMenuItem(
              value: 'Active',
              child: Text('Active'),
            ),
            DropdownMenuItem(
              value: 'Completed',
              child: Text('Completed'),
            ),
          ]
              : const [
            DropdownMenuItem(
              value: 'Completed',
              child: Text('Completed (Read-only)'),
            ),
          ],
          onChanged: (String? newStatus) async {
            if (newStatus == 'Completed') {
              await _markAsCompleted(booking, bookingId);
              setState(() {
                status = newStatus!;
              });
            }
          },
        ),
      ],
    );
  }

  // Function to build the completed booking card design
  Widget _buildCompletedBookingCard(Map<String, dynamic> completedBooking) {
    return Card(
      elevation: 6, // Increased elevation for more depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white, // White background for a clean look
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Symmetric margins for spacing
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Patient Name
                Expanded(
                  child: Text(
                    'Patient: ${completedBooking['patientName'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87, // Strong color for emphasis
                    ),
                  ),
                ),
                // Completed Icon
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 36, // Larger size for prominence
                ),
              ],
            ),
            const SizedBox(height: 8), // Spacing between lines
            Divider(
              color: Colors.grey[300], // Light divider to separate sections
            ),
            const SizedBox(height: 8),
            // Driver Information
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blueAccent), // Icon for driver
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Driver: ${completedBooking['driverName'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54, // Softer color for less emphasis
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Hospital Information
            Row(
              children: [
                const Icon(Icons.local_hospital, color: Colors.redAccent), // Icon for hospital
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hospital: ${completedBooking['hospitalName'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54, // Softer color for less emphasis
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Contact Information
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green), // Icon for phone
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Contact: ${completedBooking['mobileNumber'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Request Type
            Row(
              children: [
                const Icon(Icons.assignment_outlined, color: Colors.orangeAccent), // Icon for request type
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Request Type: ${completedBooking['request_type'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Status Information
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.purple), // Icon for status
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Status: ${completedBooking['status'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Date and Time Information
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.teal), // Icon for date
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Date: ${completedBooking['date_added'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_outlined, color: Colors.deepOrange), // Icon for time
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Time: ${completedBooking['time_added'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch Google Maps with directions
  Future<void> _launchGoogleMapsDirections(
      BuildContext context, String latLng) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/$currentPositionLatitude,$currentPositionLongitude/$latLng');

    if (await launchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Google Maps')),
      );
    }
  }

  // Function to launch the phone dialer
  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch dialer for $phoneNumber')),
      );
    }
  }
}
