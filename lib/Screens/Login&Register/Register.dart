import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Register Here',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                label: 'Username',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              SizedBox(height: 16),
              _buildDropdownField(
                label: 'Gender',
                items: ['Male', 'Female', 'Other'],
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Age',
                icon: Icons.confirmation_number_outlined,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              _buildDropdownField(
                label: 'Role',
                items: ['Patient', 'Driver'],
                icon: Icons.assignment_ind_outlined,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Registration logic here
                  },
                  child: Text('Register', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to Login screen
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.red[400], fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required IconData icon,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required IconData icon,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red[400]),

        filled: true,
        fillColor: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {},
          hint: Text('Select $label'),
        ),
      ),
    );
  }
}
