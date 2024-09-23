// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_savior/Models/user_model.dart';
// import 'package:e_savior/Screens/InitialScreens/updateProfilePage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late String userName;
//   late String userAge;
//   late String userGender;
//   late String userContact;
//   late String userEmail;
//   final UserModel userModel = UserModel();
//
//   // Future<void> _deleteUserProfile(String userId) async {
//   //   try {
//   //     // Delete user document from Firestore
//   //     await FirebaseFirestore.instance.collection("users").doc(userId).delete();
//   //     // Sign out the user
//   //     await FirebaseAuth.instance.signOut();
//   //     // Navigate to login screen
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => DriverLoginScreen()), // Adjust as needed
//   //     );
//   //   } catch (e) {
//   //     print('Failed to delete user profile: $e');
//   //   }
//   // }
//
//   Future<void> _logout() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => UserProfileScreen()),
//       );
//     } catch (e) {
//       print('Failed to logout: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Profile',
//           style: TextStyle(fontSize: 24, color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//         centerTitle: true,
//         elevation: 5.0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.red.shade900, Colors.red.shade50],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("users")
//               .where('email', isEqualTo: userModel.email)
//               .snapshots(),
//           builder: (BuildContext context, snapshot) {
//             print(userModel.email);
//             if (snapshot.hasData) {
//               var dataLength = snapshot.data!.docs.length;
//               return ListView.builder(
//                 padding: const EdgeInsets.all(16.0),
//                 itemCount: dataLength,
//                 itemBuilder: (context, index) {
//                   var userDoc = snapshot.data!.docs[index];
//                   String userID = userDoc['id'];
//                   userName = userDoc['name'];
//                   userAge = userDoc['age'];
//                   userGender = userDoc['gender'];
//                   userContact = userDoc['contact'];
//                   userEmail = userDoc['email'];
//
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 16.0),
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CircleAvatar(
//                               radius: 50,
//                               backgroundImage: userGender != 'Male'
//                                   ? NetworkImage(
//                                       'data:image/png;base64,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')
//                                   : NetworkImage(
//                                       'data:image/jpeg;base64,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'),
//                             ),
//                             SizedBox(height: 16),
//                             TextFormField(
//                               initialValue: userName,
//                               decoration: InputDecoration(labelText: 'Name'),
//                               onChanged: (value) {
//                                 userName = value;
//                               },
//                             ),
//                             TextFormField(
//                               initialValue: userAge,
//                               decoration: InputDecoration(labelText: 'Age'),
//                               onChanged: (value) {
//                                 userAge = value;
//                               },
//                             ),
//                             TextFormField(
//                               initialValue: userGender,
//                               decoration: InputDecoration(labelText: 'Gender'),
//                               onChanged: (value) {
//                                 userGender = value;
//                               },
//                             ),
//                             TextFormField(
//                               initialValue: userContact,
//                               decoration: InputDecoration(labelText: 'Contact'),
//                               onChanged: (value) {
//                                 userContact = value;
//                               },
//                             ),
//                             TextFormField(
//                               initialValue: userEmail,
//                               decoration: InputDecoration(labelText: 'Email'),
//                               enabled: false, // Email is typically not editable
//                             ),
//                             SizedBox(height: 20),
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           UpdateProfileScreen(userId: userID)),
//                                 );
//
//                                 // FirebaseFirestore.instance.collection("users").doc(userID).update({
//                                 //   'name': userName,
//                                 //   'age': userAge,
//                                 //   'gender': userGender,
//                                 //   'contact': userContact,
//                                 // });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 24),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                               child: Text(
//                                 'Update Profile',
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white),
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             ElevatedButton(
//                               onPressed: _logout,
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 24),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                               child: Text(
//                                 'Logout',
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white),
//                               ),
//                             ),
//
//                             // SizedBox(height: 20),
//                             // ElevatedButton(
//                             //   onPressed: () {
//                             //     // Confirm deletion
//                             //     showDialog(
//                             //       context: context,
//                             //       builder: (BuildContext context) {
//                             //         return AlertDialog(
//                             //           title: Text('Delete Account'),
//                             //           content: Text('Are you sure you want to delete your account?'),
//                             //           actions: [
//                             //             TextButton(
//                             //               child: Text('Cancel'),
//                             //               onPressed: () {
//                             //                 Navigator.of(context).pop();
//                             //               },
//                             //             ),
//                             //             TextButton(
//                             //               child: Text('Delete'),
//                             //               onPressed: () {
//                             //                 _deleteUserProfile(userDoc.id);
//                             //                 Navigator.of(context).pop();
//                             //               },
//                             //             ),
//                             //           ],
//                             //         );
//                             //       },
//                             //     );
//                             //   },
//                             //   child: Text('Delete Account'),
//                             //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//             if (snapshot.hasData) {
//               return Center(
//                   child: Text('User Does Not Exist: ${snapshot.error}'));
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             return Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_savior/Screens/InitialScreens/updateProfilePage.dart';
// import 'package:e_savior/Screens/Login&Register/Driver_login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   final String userId;
//
//   UserProfileScreen({required this.userId});
//
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   CollectionReference users = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
//
//   final _formKey = GlobalKey<FormState>();
//   late String userName;
//   late String userAge;
//   late String userGender;
//   late String userContact;
//   late String userEmail;
//
//   Future<void> _logout() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => UserProfileScreen(userId: userEmail)),
//       );
//     } catch (e) {
//       print('Failed to logout: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Profile',
//           style: TextStyle(fontSize: 24, color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//         centerTitle: true,
//         elevation: 5.0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.red.shade900, Colors.red.shade50],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("users")
//               .where('email', isEqualTo: widget.userId)
//               .snapshots(),
//           builder: (BuildContext context, snapshot) {
//             if (snapshot.hasData) {
//               var dataLength = snapshot.data!.docs.length;
//               return ListView.builder(
//                 padding: const EdgeInsets.all(16.0),
//                 itemCount: dataLength,
//                 itemBuilder: (context, index) {
//                   var userDoc = snapshot.data!.docs[index];
//                   String userID = userDoc['id'];
//                   userName = userDoc['name'];
//                   userAge = userDoc['age'];
//                   userGender = userDoc['gender'];
//                   userContact = userDoc['contact'];
//                   userEmail = userDoc['email'];
//
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 16.0),
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CircleAvatar(
//                               radius: 50,
//                               backgroundImage: userGender != 'Male' ? NetworkImage('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAABLFBMVEX///+q3/FDQ03/69L+qmROTlr/37mr4PKt5Pam3vH+qGD/16VERE4/QEv/79X4/P1JRVFMSlY9OEKy4vPl9frT7vi95vTx+vw7PUr/rmX+pVnH6fbg8/k8N0H/47z/8tj+7eCMssJGP0ubyNlZYW4zN0c6P0z859P99u5hbntpe4iVv89zipik1udLUFqdy9z/6sj/37C4rJ/Nv64yNEPi075+nq3Ks5rs0K9NSU79tHX8wIj9xJn8z6r8uID82Lp3kZ9VWmZcV1eSgXCmkHrBpoZsYl3tzKHevpaFd2vRs423nYFzZ1+gjnuGqLjcw6eYj4jXyLWDfHlzb26lmpBnY2coLUCzn4x3XlG8mnrCiVzuoWKQcl1mVFDSk1+qfFq5hFzIzsW51tvquI1CSAy3AAANC0lEQVR4nO2de1vaSBuHy8mEQEBAEVBRWxAVUbFqFazHWm3dta3abd+edrf7/b/DOwmQ40zyTGZC8Lrm90+r9ZC7z3Emc3j2TEhISEhISEhISEhISEhISEhISEhISEhIyKF8fm6kfD7qh+Gq/MzC7Hy5JEmxWCytCf0pSaXy/OzCzJMnzc/MlqX0CMuuwael8uyTxcwvzJewaG7Q0vzCk6PMz5b94WyY5dknBDlHh2eBnIv60SHKL5Sp6UzK8sS769xsKTDfgLE00Yacm4+x4A0hY/OTyjgX3D0djOnyJDJy45tQxvw8R74B4/xE5ZxZDvHnYozNRo1laKbEn09nLM1EjaYLOWgofDrjJLhqWAYcIkZvxhANOGScj5RvLlQDDhFLERaOhfD5dMaFqABD91ADMRpPzZfHBYgQyxHk1HGEoAVx/ME4I40TECFKYy4bM2PFG2isiDPjNeBA6TEiRgI4TsSIAMeHGBnguBCjSDKmxoA4J0VKKIVeF/NjLfRupUthdzdjbNUIiOVwAdmbbUkXC2KobTjDcEmSZCSNrdMxPgqGGOJgai4goMYT21452Fw/T00/R5pONTY279qdWCDKdHjZphQID9G9ONg4fz49XSikDBUK6OP1s3YnAGQpLMAgQSjJsfZmA8GkcEKU55ttiZYxrFAM0MvI8vZBg0BnUq7fxWRKxFAKf57aR2W5vZGa9sQbMp7fUabXUKoirY9Kcnvdx3ymiudtKlcNw08pfVSSt9efQ/lSqWx8caND46oh+Cmdj8qxMwo+jTBejK/QmJF7Pp2lMSFy0HNA/FkU17S4GYMjpjm/mcrTAMqdTTdfoZDVVShgbJuNDxAbHQpEvsmGJs3ILxp2QMQWtylrpywY/1Dc2gYHI99kQ9OuySu253fhjSgHmMi01s+q2RdwRJ7NG3zMJMln0zY+LB5ZFIg8x1FwE0qSNQSp+XTEbWgscjQi2IRSbN0CGIBPQ9yCpht+RgSb0AZY8IfBq9iAFg1uRoQmUhtgMAPqWtwEhiKvdDoH+3UoBjemmQ04QFyBZhs+RoS2M7KZZBgMOBDQT/k0NtBRk3zAD7C4ATQil1EUcPZJXuEHiBDbMEQus1KwUiFvFzgCxtUGkJBDwYCVCinWKOAA1UqlogYyIjDZcCgYsDxj9mpWQLVycfnm8qIZgFFtjC3XlEGA7RGgtUxUjq669Xo3cxWEERqJzG4KclKpM/JRG+Db650E0k43c5utUBMC0ymzm4KcFOujlbfdxFD17vW7Ji1jFtaeMrspJJNK2xhA9SiTMFXP3FxW6CCBjQ1rNgXNXsjrGB9t3uQSCRtj5updpdkEp1YV6qZsRR8yhyi3nw9NaAV8s5NwaKfe7d5cXb7NImNCOIGjKMZ5RciwQj5351H1YsoJaFBmrt/fXl5kfSkXX8AI2QYYgJ7UbNesJrzKYQkHmBrn9fs3f2Q9q0jxDuamTDOnkDCUR5XCmmYIJnRY8/rWq1IWgcNEpkAEhKGENeGthwkt2Qd1A0fEBKuuA9salkAEVENsIs0eQgA1S2qVkkR4DgJkq4j+1VB6UXCbUP3DlUiJmsq8ISFmYeNgporo/xvkTVy/9ifISYeumrklIBaBI30pOKB/opE6uFFh8xUFIYrGS3wsLgKnFRlSjX/bLd9h8ky88oGGMFG/xidUMGHw5tt/AkPC5Zn4ETTRDNV9hzUimDD4VIZvKsX23KgawhONrqn3bITBk6lvz2bOr9mc9HKJjnAnc4HzUzBh8L7Nv1hgnXSPLgyRuth0CiYMXi78ulKp8xzjpHvvKE2oGZGFkKEz9fsFOCdV9x5oLTg0ouocbEDrYfCCmPcldDmpGn/YDQCIyv7FXuHjZ0fCARMGLYh5vx8cc2ZS9Wh/KQhgIrdz+BJ966PVWVVg14YUlNDvpZM5MjQIP1GHoAmJ/muWbIhbYMKgJd+X8MzRdVfugwMOZQlFNLYIndCnWLimL5ovA7moRUsfzVBUG0C+4G2bD6G7Vqj7rCbM7TYthKEvWfAjdIVhdp/VhrmXeyYhcIwfHqExNDSqIQfC3YkidM0i8vDSylgJPX+sZLwTNQg5ZJr7IIQhVQt3GMYrH1mrRc5aLcCZJjChd0/jDkM0MGQFtCQamnoYuGvz/AUy5p0hq5sufbY23+CuLXBf6jm2MOegrK8rPjMR2kw4jrGF5/hQauOWJuztMkRiLlGwjZ8WoasUg48Pvcb45iybffEFQ0nM3dtHT4sroY/xveZpMIlGJ9wKjJj7aPNR5KVnwFczwedpvObajNGvnTBe2doP5Ki51r0DEBVEIGHwuTaP+VIp1khhCeOq+hiEcHfLPaNYhO0VYpgv9WjbpM45gRClmwdqKy593sPMJ0IXKwSf8/Z4b2G+c3ITqkfUFsz95eYDL1ZgeUVKdhLJWAXlJoxXaDvw3CdnDA7dFDSfyPDuyaNcWBZbuh+sSTvflnvEv30CZVOm94fkZGqWQwyhSjtluoSd1Y/DFkYxvQMmv8f3XhFMO1DcJ73Mh6xWYHqPT041lq0xGMLKI1U2tc4/OeXfubEtiiJ2pmZLg7XhUYvGT1tZ4poTwDCYbScisW+zEOJ2HjQfKQi9TOi/WJhxTRQxEC2EmFSDEOHtaW7fa2WUmvJJNozr2oiBaCXELV2nGe6TEunQiD5ln3WnJakimjP6hA0yFWDrlks43zg5tdj2MiLzan1SRbRtM8Q+2N49xE9zLT9ANCDzGuszrxEmNd+WekjaYdF88E+oS59S/guHPTsb9u0IhLX65lwiyU2Ro6Z8urdcbhe0ZNjrdTf7lhKCm5r7D8iEcbV57zUcXtp/IC1pc/wccrLhsN+C4KaW0RMpEHUzouEwgXEp8bECXdpeJC4X5rHJEp9NLSNgL0LEWHlMYHw1l3gE83kYkctGWcJUhtSwGNFzM1dz75V7Vfurv+j2XxDaUy571wj7D+WNAsiGGuJtplu38tW7xBWXBBUP8Ebkc4oLPtfYyoUP4VUGqVsf7BFCeEhXdISE3XqcDsfAv4KyJlOfXb/N95mhut3R3ygJSUNhTpu5sQMM872F755Kk9AULWER17pxOxoDXzDMKWG/TaOVD1Om8QamrL+iJcRtvuB3qAK2YBiB6LszHRE6RU+I6dw4HoyBNeJo9az/tl/1Q52dEDNhw/NwE7wRUUUEne2RPXQTfmAn5HpGJNaI8kER9nQ4wkPsJDcdIdfDBXHpVOosgh5OPTp0xeFUnXJLqZuQ84Fm2NkMeQO0W1K9cANO1fHL88mErqaG8zlR2MZGaoOM2PziclItEOnc1PU+mPdZX/iZU7nhb0R17wFjQoT4QGVEV8Xnf/4lbl5R9jOi2mymcBbURbVLv+Do2sI4GxKbbNbJD6mqTfXtl8M6CbA+9eVChW58dnbeoZzviRtFyW1CwVBXm9mv/0N4JD6dsX746vIi3lz1p3Sm0nBOhMb5qbSBQUR4R1+/fa9W+158A0aN8sdPX0rHGRJhnc2O8VNpG4f3Q8NLJpPKiQ+hpm6vmvz+7cfPVS9K+5RpeMdB4/z0rOjE+/Vdo9Ol9Pz46sdJBX1hdUBJgnQ4aWjnCOOaNyl2bjyUjpc08HTE5GvPSJw6UYyv1Sj/xidY+1xbiGdB42alRmVfba5qeDY+nfGYjFjPJBX7V1erv766Ge2ZNNzLkTChOPDT1aN/qm48HZGcb04U95dXq99/rjoIF615JuyrkTDjKNTZqKs/klg8r2B0GdBg/NsejjYThn2uPu5uBKkTV78R+XTEDAawj+fTGX/ZXntbD8gI/24E3P0WcvuXF6CWbzIOT61nemRAhPj9yES0JdLw77fA3VGS/s/raQeMjmDsK97fUv0VHyHal3uP5xoWh5+mb2p+gI7i723AAeI3Y5rDcmRrNFfppP8FAFrzzbDI+yH+GGRU61qMaK5DkkoQvqQRjPUpfwPqGoTi4l0UgDZEkI8OGXv9437PJwINVb+txtViRICWdJP+DXzgAaMC5dP0s5iylvpxXy03vDsvfUNDSKXqP5aj9sd+d97o/kOp7F0J2WQu847kMlL9DktgIg2m2r+jcI/kDstnehsOKPbBpdwMCaO7MXch3emFB4g0jPXI7pJFwfg7RCdFbvpbivg+4GfP1o5rIbqpFogR3+mM1AK2KEGkfJiAe7lDNWPtv4hyqFOtXjjRWOu1okYzdErTjAGlKKdRY1nF3VWV2vFa1FAOLfc5Miq1/nLUQBgtn3DyVUWZSD5Ny8dJZkOi/6Xj5ahBPLT2usfEqNR6ryct/lxq9ZWAkOj7+q2J59O0dnpSo4ZUarWT0yeBN9DaaR9BQikVhNd/SnhDtVBM+mIqGl3v9eQ0L5Raa532dQu5pqAUZfDpZP/0ydIZWltunR6f9EZcQ9beyfFpa/npeaaX1tbWlgdCf4v6YYSEhISEhISEhISEhISEhISEhISEhISEJk//B8lXvc98XVDZAAAAAElFTkSuQmCC') : NetworkImage('data:image/jpeg;base64,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'),
//                             ),
//                             SizedBox(height: 16),
//                             TextFormField(
//                               initialValue: userName,
//                               decoration: InputDecoration(labelText: 'Name'),
//                               onChanged: (value) {
//                                 userName = value;
//                               },
//                             ),
//                             TextFormField(
//                               initialValue: userAge,
//                               decoration: InputDecoration(labelText: 'Age'),
//                               onChanged: (value) {
//                                 userAge = value;
//                               },
//                             ),
//                             TextFormField(
//                               initialValue: userGender,
//                               decoration: InputDecoration(labelText: 'Gender'),
//                               onChanged: (value) {
//                                 userGender = value;
//                               },
//                             ),
//                             TextFormField(
//                               initialValue: userContact,
//                               decoration: InputDecoration(labelText: 'Contact'),
//                               onChanged: (value) {
//                                 userContact = value;
//                               },
//                             ),
//                             TextFormField(
//                               initialValue: userEmail,
//                               decoration: InputDecoration(labelText: 'Email'),
//                               enabled: false, // Email is typically not editable
//                             ),
//                             SizedBox(height: 20),
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => UpdateProfileScreen(userId: userID)),
//                                 );
//
//                                 // FirebaseFirestore.instance.collection("users").doc(userID).update({
//                                 //   'name': userName,
//                                 //   'age': userAge,
//                                 //   'gender': userGender,
//                                 //   'contact': userContact,
//                                 // });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                               child: Text(
//                                 'Update Profile',
//                                 style: TextStyle(fontSize: 18, color: Colors.white),
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             ElevatedButton(
//                               onPressed: _logout,
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                               child: Text(
//                                 'Logout',
//                                 style: TextStyle(fontSize: 18, color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_savior/Screens/InitialScreens/updateProfilePage.dart';
import 'package:e_savior/Screens/Login&Register/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch user data from Firestore using email
  Future<void> fetchUserData() async {
    user = _auth.currentUser;

    if (user != null) {
      try {
        // Query Firestore collection using the email as the identifier
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user!.email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          setState(() {
            userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
          });
        } else {
          setState(() {
            userData = {'error': 'No user data found for this email.'};
          });
        }
      } catch (e) {
        setState(() {
          userData = {'error': 'Error fetching data: $e'};
        });
      }
    } else {
      setState(() {
        userData = {'error': 'User not signed in.'};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.blueGrey,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : userData!.containsKey('error')
          ? Center(
        child: Text(
          userData!['error'] ?? 'Error occurred',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Name
                    _buildProfileInfoRow(
                      icon: Icons.person_outline,
                      title: 'Name',
                      value: userData!['name'] ?? 'N/A',
                    ),

                    // Email
                    _buildProfileInfoRow(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: user!.email ?? 'N/A',
                    ),

                    // Phone
                    _buildProfileInfoRow(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: userData!['contact'] ?? 'N/A',
                    ),

                    // Gender
                    _buildProfileInfoRow(
                      icon: Icons.wc,
                      title: 'Gender',
                      value: userData!['gender'] ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Update Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(userId: user!.email!),
                  ),
                );

              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Text(
                'Update Profile',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Sign Out Button
            // Sign Out Button
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your LoginScreen widget
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Helper function to build profile information rows
  Widget _buildProfileInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 28),
          SizedBox(width: 10),
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // // Show dialog for updating profile information
  // void _showUpdateDialog() {
  //   // You can implement this function to show a dialog with form fields for updating user data
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Update Profile'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Add TextFields for updating user information
  //             TextField(
  //               decoration: InputDecoration(labelText: 'Name'),
  //               // Controller for capturing input can be added here
  //             ),
  //             TextField(
  //               decoration: InputDecoration(labelText: 'Phone'),
  //               // Controller for capturing input can be added here
  //             ),
  //             // Add more fields as necessary
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //                            Navigator.of(context).pop(); // Close the dialog after handling
  //             },
  //             child: Text('Update'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
