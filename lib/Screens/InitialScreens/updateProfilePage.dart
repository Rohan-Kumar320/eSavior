import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String userId;

  UpdateProfileScreen({required this.userId});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  // String userAge = '';
  String userGender = '';
  String userContact = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      setState(() {
        userName = userDoc['name'];
        // userAge = userDoc['age'];
        userGender = userDoc['gender'];
        userContact = userDoc['contact'];
        userEmail = userDoc['email'];
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
          'name': userName,
          // 'age': userAge,
          'gender': userGender,
          'contact': userContact,
          'email': userEmail,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        Navigator.pop(context); // Go back after update
      } catch (e) {
        print('Failed to update profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: userName,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => userName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // TextFormField(
              //   initialValue: userAge,
              //   decoration: InputDecoration(labelText: 'Age'),
              //   onChanged: (value) => userAge = value,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter your age';
              //     }
              //     return null;
              //   },
              // ),
              DropdownButtonFormField<String>(
                value: userGender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female',]
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
                onChanged: (value) => userGender = value!,
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: userContact,
                decoration: InputDecoration(labelText: 'Contact'),
                onChanged: (value) => userContact = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: userEmail,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => userEmail = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Update Profile',style: TextStyle(color:Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}