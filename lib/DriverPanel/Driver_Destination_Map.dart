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
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAcceptedBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _bookings.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> booking = _bookings[index];
                      final lat = booking['latitude'];
                      final lng = booking['longitude'];

                      return ListTile(
                        title: Text('Destination: ${booking['address']}'),
                        subtitle: Text('Hospital: ${booking['hospitalName']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.phone_outlined),
                              onPressed: () {
                                String phoneNumber = booking['mobileNumber'];
                                _launchPhoneDialer(
                                    phoneNumber); // Call to launch dialer
                                log(phoneNumber);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.directions),
                              onPressed: () {
                                _launchGoogleMapsDirections(
                                    context, '$lat,$lng');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('ambulance_requests')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching requests'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No ambulance requests available'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request =
                        requests[index].data() as Map<String, dynamic>;
                    final lat = request['latitude'];
                    final lng = request['longitude'];
                    final details = request['details'];
                    final location = request['address'];

                    return ListTile(
                      title: Text('Request from $location'),
                      subtitle:
                          Text('Details: $details\nLat: $lat, Long: $lng'),
                      trailing: IconButton(
                        icon: const Icon(Icons.directions),
                        onPressed: () {
                          _launchGoogleMapsDirections(context, '$lat,$lng');
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to launch Google Maps with directions
  Future<void> _launchGoogleMapsDirections(
      BuildContext context, String latLng) async {

    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/$currentPositionLatitude,$currentPositionLongitude/$latLng');

    if (await launchUrl(url)) {
      debugPrint(currentPositionLatitude + "  " + currentPositionLongitude);
      print("object");
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
