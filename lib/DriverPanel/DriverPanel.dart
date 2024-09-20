// import 'package:e_savior/LoginRegister/Login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class DriverAdminPage extends StatelessWidget {
//   void _acceptRequest(BuildContext context, String requestId, Map<String, dynamic> patientInfo) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Retrieve driver's personal information from SharedPreferences
//     String driverId = prefs.getString('driverId') ?? '';
//     String driverName = prefs.getString('driverName') ?? '';
//     String driverContact = prefs.getString('driverContact') ?? '';
//     String driverEmail = prefs.getString('driverEmail') ?? '';
//
//     // Save the combined driver and patient information in the 'Ambulance_book' collection
//     await FirebaseFirestore.instance.collection('Ambulance_book').add({
//       'patientName': patientInfo['patientName'],
//       'hospitalName': patientInfo['hospitalName'],
//       'mobileNumber': patientInfo['mobileNumber'],
//       'address': patientInfo['address'],
//       'zipCode': patientInfo['zipCode'],
//       'driverId': driverId,
//       'driverName': driverName,
//       'driverContact': driverContact,
//       'driverEmail': driverEmail,
//       'status': 'accepted', // Mark the request as accepted
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     // Update the original request status to 'accepted'
//     await FirebaseFirestore.instance.collection('pendingRequests').doc(requestId).update({
//       'status': 'accepted',
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Request accepted and information saved')),
//     );
//   }
//
//   // Logout function
//   void logoutUser(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to login screen
//     );
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
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('pendingRequests')
//             .where('status', isEqualTo: 'pending')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final requests = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               var request = requests[index].data() as Map<String, dynamic>;
//               var requestId = requests[index].id;
//
//               return ListTile(
//                 title: Text(request['patientName']),
//                 subtitle: Text(request['hospitalName']),
//                 trailing: ElevatedButton(
//                   onPressed: () => _acceptRequest(context, requestId, request), // Call the accept method
//                   child: Text('Accept'),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:e_savior/LoginRegister/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverAdminPage extends StatelessWidget {
  void _acceptRequest(BuildContext context, String requestId, Map<String, dynamic> patientInfo) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve driver's personal information from SharedPreferences
      String? driverId = prefs.getString('userId');
      String? driverName = prefs.getString('name');
      String? driverContact = prefs.getString('mobile');
      String? driverEmail = prefs.getString('email');

      // Check if driver information exists in SharedPreferences
      if (driverId == null || driverName == null || driverContact == null || driverEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Driver information is missing. Please log in again.')),
        );
        return;
      }

      // Save the combined driver and patient information in the 'Ambulance_book' collection
      await FirebaseFirestore.instance.collection('Ambulance_book').add({
        'patientName': patientInfo['patientName'],
        'hospitalName': patientInfo['hospitalName'],
        'mobileNumber': patientInfo['mobileNumber'],
        'address': patientInfo['address'],
        'zipCode': patientInfo['zipCode'],
        'driverId': driverId,
        'driverName': driverName,
        'driverContact': driverContact,
        'driverEmail': driverEmail,
        'status': 'accepted', // Mark the request as accepted
        'timestamp': FieldValue.serverTimestamp(),
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

  // Logout function
  void logoutUser(BuildContext context) async {
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
        title: Text('Driver Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logoutUser(context), // Pass the context to logoutUser function
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                title: Text(request['patientName']),
                subtitle: Text(request['hospitalName']),
                trailing: ElevatedButton(
                  onPressed: () => _acceptRequest(context, requestId, request), // Call the accept method
                  child: Text('Accept'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

