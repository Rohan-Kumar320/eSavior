import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class add_ambulance_driver extends StatefulWidget {
  const add_ambulance_driver({super.key});

  @override
  State<add_ambulance_driver> createState() => _add_ambulance_driverState();
}

class _add_ambulance_driverState extends State<add_ambulance_driver> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  String? _selectedGender;
  final _firestore = FirebaseFirestore.instance;

  void _addDriver() async {
    final uuid = Uuid();
    final userId = uuid.v4();
    final now = DateTime.now().toLocal(); // Get the current date and time
    final date = '${now.year}-${now.month}-${now.day}'; // Format date as YYYY-MM-DD
    final time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    try {
      await _firestore.collection('drivers').doc(userId).set({
        'userId': userId,
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'mobile': _mobileController.text,
        'gender': _selectedGender,
        'address': _addressController.text,
        'area': _areaController.text,
        'id_card': _idCardController.text,
        'date': date, // Add the formatted date
        'time': time, // Add the formatted time
      });

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
      print(e);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.06),
              Text("Add Drivers Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: height * 0.08),

              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(label: Text("Enter Your Name")),
                ),
              ),
              SizedBox(height: height * 0.06),

              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(label: Text('Enter Your Email')),
                ),
              ),
              SizedBox(height: height * 0.06),

              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(label: Text('Enter Your Password')),
                ),
              ),
              SizedBox(height: height * 0.06),

              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(label: Text('Enter Your Mobile Number')),
                ),
              ),
              SizedBox(height: height * 0.06),

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
                ),
              ),
              SizedBox(height: height * 0.06),

              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(label: Text('Enter Your Address')),
                ),
              ),
              SizedBox(height: height * 0.06),

              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _areaController,
                  decoration: InputDecoration(label: Text('Enter Your Area')),
                ),
              ),
              SizedBox(height: height * 0.06),

              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _idCardController,
                  decoration: InputDecoration(label: Text('Enter Your ID Card Number')),
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
    );
  }
}
