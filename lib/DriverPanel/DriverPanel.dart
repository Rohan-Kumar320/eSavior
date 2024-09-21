// import 'package:e_savior/Screens/Login&Register/Driver_login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class DriverAdminPage extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<void> _fetchDriverInfo() async {
//     try {
//       User? currentUser = _auth.currentUser;
//
//       if (currentUser == null) {
//         throw 'No user is logged in';
//       }
//
//       // Get the current driver's userId (UID)
//       String userId = currentUser.uid;
//
//       // Fetch driver's info from Firestore based on userId
//       DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
//           .collection('drivers')
//           .doc(userId) // assuming the document ID is the userId
//           .get();
//
//       if (!driverSnapshot.exists) {
//         throw 'Driver not found in the database';
//       }
//
//       // Extract driver's data from Firestore document
//       Map<String, dynamic> driverData = driverSnapshot.data() as Map<String, dynamic>;
//       String name = driverData['name'];
//       String contact = driverData['mobile'];
//       String email = driverData['email'];
//       String cardId = driverData['id_card'];
//
//       // Save driver info in SharedPreferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('userId', userId);
//       await prefs.setString('name', name);
//       await prefs.setString('mobile', contact);
//       await prefs.setString('email', email);
//       await prefs.setString('id_card', cardId);
//     } catch (e) {
//       print('Error fetching driver information: $e');
//       throw e;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Driver Admin Panel'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () => logoutUser(context), // Pass the context to logoutUser function
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: _fetchDriverInfo(), // Fetch driver info when building the page
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           // Now the driver's information is saved in SharedPreferences, proceed with your StreamBuilder
//           return StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('pendingRequests')
//                 .where('status', isEqualTo: 'pending')
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               final requests = snapshot.data!.docs;
//               return ListView.builder(
//                 itemCount: requests.length,
//                 itemBuilder: (context, index) {
//                   var request = requests[index].data() as Map<String, dynamic>;
//                   var requestId = requests[index].id;
//
//                   return ListTile(
//                     title: Text(request['patientName']),
//                     subtitle: Text(request['hospitalName']),
//                     trailing: ElevatedButton(
//                       onPressed: () => _acceptRequest(context, requestId, request), // Call the accept method
//                       child: Text('Accept'),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // Accept request method (already provided)
//   void _acceptRequest(BuildContext context, String requestId, Map<String, dynamic> patientInfo) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       // Retrieve driver's personal information from SharedPreferences
//       String? driverId = prefs.getString('userId');
//       String? driverName = prefs.getString('name');
//       String? driverContact = prefs.getString('mobile');
//       String? driverEmail = prefs.getString('email');
//       String? cardId = prefs.getString('id_card'); // Card ID
//
//       // Check if driver information exists in SharedPreferences
//       if (driverId == null || driverName == null || driverContact == null || driverEmail == null || cardId == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Driver information is missing. Please log in again.')),
//         );
//         return;
//       }
//
//       // Get current date and time
//       String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//       String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
//
//       // Save the combined driver and patient information in the 'Ambulance_book' collection
//       await FirebaseFirestore.instance.collection('Ambulance_book').add({
//         'patientName': patientInfo['patientName'],
//         'hospitalName': patientInfo['hospitalName'],
//         'mobileNumber': patientInfo['mobileNumber'],
//         'address': patientInfo['address'],
//         'zipCode': patientInfo['zipCode'],
//         'driverId': driverId,
//         'driverName': driverName,
//         'driverContact': driverContact,
//         'driverEmail': driverEmail,
//         'cardId': cardId, // Adding the card ID here
//         'status': 'accepted',// Mark the request as accepted
//         'date_added': formattedDate,   // Store date separately
//         'time_added': formattedTime,
//       });
//
//       // Update the original request status to 'accepted'
//       await FirebaseFirestore.instance.collection('pendingRequests').doc(requestId).update({
//         'status': 'accepted',
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Request accepted and information saved')),
//       );
//     } catch (e) {
//       // Error handling
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error accepting request: ${e.toString()}')),
//       );
//     }
//   }
//
//   // Logout function
//   void logoutUser(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen_Driver()), // Navigate to login screen
//     );
//   }
// }

import 'package:e_savior/DriverPanel/Driver_Destination_Map.dart';
import 'package:e_savior/Screens/Login&Register/Driver_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverAdminPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _fetchDriverInfo() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw 'No user is logged in';
      }

      // Get the current driver's userId (UID)
      String userId = currentUser.uid;

      // Fetch driver's info from Firestore based on userId
      DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(userId) // assuming the document ID is the userId
          .get();

      if (!driverSnapshot.exists) {
        throw 'Driver not found in the database';
      }

      // Extract driver's data from Firestore document
      Map<String, dynamic> driverData = driverSnapshot.data() as Map<String, dynamic>;
      String name = driverData['name'];
      String contact = driverData['mobile'];
      String email = driverData['email'];
      String cardId = driverData['id_card'];

      // Save driver info in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('name', name);
      await prefs.setString('mobile', contact);
      await prefs.setString('email', email);
      await prefs.setString('id_card', cardId);
    } catch (e) {
      print('Error fetching driver information: $e');
      throw e;
    }
  }

  // Accept request method
  void _acceptRequest(BuildContext context, String requestId, Map<String, dynamic> patientInfo) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve driver's personal information from SharedPreferences
      String? driverId = prefs.getString('userId');
      String? driverName = prefs.getString('name');
      String? driverContact = prefs.getString('mobile');
      String? driverEmail = prefs.getString('email');
      String? cardId = prefs.getString('id_card'); // Card ID

      // Check if driver information exists in SharedPreferences
      if (driverId == null || driverName == null || driverContact == null || driverEmail == null || cardId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Driver information is missing. Please log in again.')),
        );
        return;
      }

      // Get current date and time
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

      // Save the combined driver and patient information in the 'Ambulance_book' collection
      await FirebaseFirestore.instance.collection('Ambulance_book').add({
        'patientName': patientInfo['patientName'],
        'hospitalName': patientInfo['hospitalName'],
        'mobileNumber': patientInfo['mobileNumber'],
        'address': patientInfo['location'],
        'zipCode': patientInfo['zipCode'],
        'longitude' : patientInfo['longitude'],
        'latitude' : patientInfo['latitude'],
        'details' : patientInfo['details'],
        'driverId': driverId,
        'driverName': driverName,
        'driverContact': driverContact,
        'driverEmail': driverEmail,
        'id_card': cardId, // Adding the card ID here
        'status': 'accepted', // Mark the request as accepted
        'date_added': formattedDate,   // Store date separately
        'time_added': formattedTime,   // Store time separately
      });

      // Update the original request status to 'accepted'
      await FirebaseFirestore.instance.collection('pendingRequests').doc(requestId).update({
        'status': 'accepted',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request accepted and information saved')),
      );
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting request: ${e.toString()}')),
      );
    }
  }

  // Reject request method
  void _rejectRequest(BuildContext context, String requestId, Map<String, dynamic> patientInfo) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve driver's personal information from SharedPreferences
      String? driverId = prefs.getString('userId');
      String? driverName = prefs.getString('name');
      String? driverContact = prefs.getString('mobile');
      String? driverEmail = prefs.getString('email');
      String? cardId = prefs.getString('id_card'); // Card ID

      // Check if driver information exists in SharedPreferences
      if (driverId == null || driverName == null || driverContact == null || driverEmail == null || cardId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Driver information is missing. Please log in again.')),
        );
        return;
      }

      // Get current date and time
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

      // Save the rejected request information in the 'request_booking_rejected' collection
      await FirebaseFirestore.instance.collection('request_booking_rejected').add({
        'patientName': patientInfo['patientName'],
        'hospitalName': patientInfo['hospitalName'],
        'mobileNumber': patientInfo['mobileNumber'],
        'address': patientInfo['location'],
        'zipCode': patientInfo['zipCode'],
        'longitude' : patientInfo['longitude'],
        'latitude' : patientInfo['latitude'],
        'details' : patientInfo['details'],
        'driverId': driverId,
        'driverName': driverName,
        'driverContact': driverContact,
        'driverEmail': driverEmail,
        'id_card': cardId, // Adding the card ID here
        'status': 'rejected', // Mark the request as rejected
        'date_added': formattedDate,   // Store date separately
        'time_added': formattedTime,
      });

      // Update the original request status to 'rejected'
      await FirebaseFirestore.instance.collection('pendingRequests').doc(requestId).update({
        'status': 'rejected',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request rejected and information saved')),
      );
    } catch (e) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting request: ${e.toString()}')),
      );
    }
  }

  // Logout function
  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen_Driver()), // Navigate to login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logoutUser(context), // Pass the context to logoutUser function
          ),

          SizedBox(width: 10),

          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DriveMap(),));
          }, icon: Icon(Icons.access_time_rounded))
        ],
      ),
      body: FutureBuilder(
        future: _fetchDriverInfo(), // Fetch driver info when building the page
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Now the driver's information is saved in SharedPreferences, proceed with your StreamBuilder
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('pendingRequests')
                .where('status', isEqualTo: 'pending')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final requests = snapshot.data!.docs;
              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  var request = requests[index].data() as Map<String, dynamic>;
                  var requestId = requests[index].id;

                  return ListTile(
                    title: Column(
                      children: [
                        Text("Name: ${request['patientName'] ?? 'Unknown'}",style: TextStyle(fontWeight: FontWeight.bold),), // Default to 'Unknown' if null
                        Text("Hospital: ${request['hospitalName'] ?? 'Unknown'}",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("Mobile: ${request['mobileNumber'] ?? 'N/A'}",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("Address: ${request['location'] ?? 'Unknown'}",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("Zip Code: ${request['zipCode'] ?? 'Unknown'}",style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),


                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => _acceptRequest(context, requestId, request), // Call the accept method
                          child: Text('Accept'),
                        ),
                        SizedBox(width: 8), // Add spacing between the buttons
                        ElevatedButton(
                          onPressed: () => _rejectRequest(context, requestId, request), // Call the reject method
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // Red button for rejection
                          child: Text('Reject'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
