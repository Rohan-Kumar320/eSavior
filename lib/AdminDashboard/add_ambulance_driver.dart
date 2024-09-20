import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AddAmbulanceDriver extends StatefulWidget {
  const AddAmbulanceDriver({super.key});

  @override
  State<AddAmbulanceDriver> createState() => _AddAmbulanceDriverState();
}

class _AddAmbulanceDriverState extends State<AddAmbulanceDriver> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  String? _selectedGender;
  bool _obscurePassword = true; // To toggle password visibility
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  // Add driver in Firestore and Authentication
  void _addDriver() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop the function if validation fails
    }

    final uuid = Uuid();
    final now = DateTime.now().toLocal();
    final date = '${now.year}-${now.month}-${now.day}';
    final time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    try {
      // Register the user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final userId = userCredential.user?.uid ?? uuid.v4();

      // Save additional driver details in Firestore
      await _firestore.collection('drivers').doc(userId).set({
        'userId': userId,
        'name': _nameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'gender': _selectedGender,
        'address': _addressController.text,
        'area': _areaController.text,
        'id_card': _idCardController.text,
        'date': date,
        'time': time,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Driver added successfully!')),
      );

      // Clear the form after submission
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _mobileController.clear();
      _addressController.clear();
      _areaController.clear();
      _idCardController.clear();
      setState(() {
        _selectedGender = null;
      });
    } catch (e) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add driver: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Drivers"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: width * 0.1),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.06),
                Text("Add Driver Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: height * 0.08),

                // Name Field
                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(label: Text("Enter Your Name")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        return 'Name must contain only alphabets';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.06),

                // Email Field
                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(label: Text('Enter Your Email')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      final regex = RegExp(pattern);
                      if (!regex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.06),

                // Password Field
                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      label: Text('Enter Your Password'),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.06),

                // Mobile Number Field
                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(label: Text('Enter Your Mobile Number')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      } else if (value.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please enter a valid 11-digit mobile number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.06),

                // Gender Dropdown
                SizedBox(
                  width: width * 0.8,
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: ['Male', 'Female'].map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    decoration: InputDecoration(label: Text('Select Your Gender')),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.06),

                // Address Field
                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(label: Text('Enter Your Address')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.06),

                // Area Field
                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _areaController,
                    decoration: InputDecoration(label: Text('Enter Your Area')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your area';
                      } else if (value.length > 30 || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Area must contain only alphabets and be up to 30 characters';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.06),

                // ID Card Number Field
                SizedBox(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: _idCardController,
                    decoration: InputDecoration(label: Text('Enter Your ID Card Number')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID card number';
                      } else if (value.length != 8 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'ID card number must be 8 digits';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: height * 0.06),

                ElevatedButton(
                  onPressed: _addDriver,
                  child: Text("Add Driver"),
                ),
                SizedBox(height: height * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
