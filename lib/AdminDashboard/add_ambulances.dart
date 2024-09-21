import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAmbulances extends StatefulWidget {
  const AddAmbulances({super.key});

  @override
  State<AddAmbulances> createState() => _AddAmbulancesState();
}

class _AddAmbulancesState extends State<AddAmbulances> {

  // Define the mappings for ambulance type, size, and equipment
  final Map<String, Map<String, String>> ambulanceDetails = {
    "Life Support": {
      "size": "Medium",
      "equipments": "Oxygen cylinder, Basic life support tools",
    },
    "Isolation Ambulance": {
      "size": "Large",
      "equipments": "Isolation ward, Oxygen cylinder, PPE kits",
    },
    "Mobile ICU ambulance": {
      "size": "Extra Large",
      "equipments": "ICU equipment, Ventilator, Defibrillator",
    },
    "Helicopter": {
      "size": "Small",
      "equipments": "Emergency medical kit, Oxygen support",
    },
    "Mva logistics unit": {
      "size": "Large",
      "equipments": "First aid, Triage kits, Extrication tools",
    },
  };

  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _driverMobileController = TextEditingController();
  final TextEditingController _driverEmailController = TextEditingController();
  final TextEditingController _ambulanceSizeController = TextEditingController();
  final TextEditingController _ambulanceEquipmentsController = TextEditingController();

  // Other fields that remain editable
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _hospitalAddressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _ambulanceCostController = TextEditingController();

  List<String> _idCardList = [];
  String? _selectedIdCard;
  String? _selectedAmbulanceType;
  String? _selectedAvailability;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchIdCards();
  }

  Future<void> _fetchIdCards() async {
    // Fetch the list of id_cards from the drivers collection
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('drivers').get();
    List<String> idCards = snapshot.docs.map((doc) => doc['id_card'] as String).toList();

    setState(() {
      _idCardList = idCards;
    });
  }

  Future<void> _fetchDriverDetails(String idCard) async {
    // Fetch the driver details based on the selected id_card
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('drivers')
        .where('id_card', isEqualTo: idCard)
        .limit(1)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first);

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    setState(() {
      _driverNameController.text = data['name'];
      _driverMobileController.text = data['mobile'];
      _driverEmailController.text = data['email'];
      _isDataLoaded = true;
    });
  }

  Future<void> _saveAmbulanceData() async {
    if (_selectedIdCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a driver ID card')),
      );
      return;
    }


    // Get current date and time
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

    // Prepare the data to be saved
    Map<String, dynamic> ambulanceData = {
      'driver_name': _driverNameController.text,
      'driver_mobile': _driverMobileController.text,
      'driver_email': _driverEmailController.text,
      'hospital_name': _hospitalNameController.text,
      'hospital_address': _hospitalAddressController.text,
      'ambulance_type': _selectedAmbulanceType,
      'ambulance_size': _ambulanceSizeController.text,
      'ambulance_equipments': _ambulanceEquipmentsController.text,
      'ambulance_cost' : _ambulanceCostController.text,
      'zip_code': _zipCodeController.text,
      'driver_availability': _selectedAvailability,
      'id_card': _selectedIdCard,
      'date_added': formattedDate, // Store date separately
      'time_added': formattedTime, // Store time separately
    };


    // Save the data to Firestore under the 'ambulances' collection
    await FirebaseFirestore.instance.collection('ambulances').add(ambulanceData);

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ambulance data saved successfully!')),
    );

    // Clear the form fields
    _clearForm();
  }

  void _clearForm() {
    _driverNameController.clear();
    _driverMobileController.clear();
    _driverEmailController.clear();
    _hospitalNameController.clear();
    _hospitalAddressController.clear();
    _zipCodeController.clear();
    _ambulanceSizeController.clear();
    _ambulanceEquipmentsController.clear();
    _ambulanceCostController.clear();
    setState(() {
      _selectedIdCard = null;
      _selectedAmbulanceType = null;
      _selectedAvailability = null;
      _isDataLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Ambulances",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: width * 0.1),
          child: Column(
            children: [
              SizedBox(height: height * 0.05),
              Text(
                "Add Ambulances Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.06),

              // Dropdown for ID Card
              SizedBox(
                width: width * 0.8,
                child: DropdownButtonFormField<String>(
                  value: _selectedIdCard,
                  hint: Text("Select ID Card"),
                  onChanged: (String? newValue) async {
                    setState(() {
                      _selectedIdCard = newValue;
                    });
                    await _fetchDriverDetails(newValue!);
                  },
                  items: _idCardList.map((String idCard) {
                    return DropdownMenuItem<String>(
                      value: idCard,
                      child: Text(idCard),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: height * 0.06),

              // Driver Name (Auto-filled, non-editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _driverNameController,
                  decoration: InputDecoration(labelText: "Driver Name"),
                  readOnly: true,
                ),
              ),
              SizedBox(height: height * 0.06),

              // Driver Mobile Number (Auto-filled, non-editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _driverMobileController,
                  decoration: InputDecoration(labelText: "Driver Mobile Number"),
                  readOnly: true,
                ),
              ),
              SizedBox(height: height * 0.06),

              // Driver Email (Auto-filled, non-editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _driverEmailController,
                  decoration: InputDecoration(labelText: "Driver Email"),
                  readOnly: true,
                ),
              ),
              SizedBox(height: height * 0.06),

              // Editable fields for user input
              // Hospital Name (Editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _hospitalNameController,
                  decoration: InputDecoration(labelText: "Hospital Name"),
                ),
              ),
              SizedBox(height: height * 0.06),

              // Hospital Address (Editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _hospitalAddressController,
                  decoration: InputDecoration(labelText: "Hospital Address"),
                ),
              ),
              SizedBox(height: height * 0.06),

              // Ambulance Type (Dropdown)
              // Ambulance Type (Dropdown)
              SizedBox(
                width: width * 0.8,
                child: DropdownButtonFormField<String>(
                  value: _selectedAmbulanceType,
                  hint: Text("Select Ambulance Type"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAmbulanceType = newValue;

                      // Auto-fill size and equipment fields based on the selected ambulance type
                      if (newValue != null && ambulanceDetails.containsKey(newValue)) {
                        _ambulanceSizeController.text = ambulanceDetails[newValue]!['size']!;
                        _ambulanceEquipmentsController.text = ambulanceDetails[newValue]!['equipments']!;
                      }
                    });
                  },
                  items: ambulanceDetails.keys.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: height * 0.06),
            // Ambulance Size (Auto-filled, non-editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _ambulanceSizeController,
                  decoration: InputDecoration(labelText: "Ambulance Size"),
                  readOnly: true,
                ),
              ),
              SizedBox(height: height * 0.06),

          // Ambulance Equipments (Auto-filled, non-editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _ambulanceEquipmentsController,
                  decoration: InputDecoration(labelText: "Ambulance Equipments"),
                  readOnly: true,
                ),
              ),

              SizedBox(height: height * 0.06),

              // Zip Code (Editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _ambulanceCostController,
                  decoration: InputDecoration(labelText: "Ambulance Cost"),
                ),
              ),

              SizedBox(height: height * 0.06),

              // Zip Code (Editable)
              SizedBox(
                width: width * 0.8,
                child: TextFormField(
                  controller: _zipCodeController,
                  decoration: InputDecoration(labelText: "Zip Code"),
                ),
              ),
              SizedBox(height: height * 0.06),

              // Driver Availability (Dropdown)
              SizedBox(
                width: width * 0.8,
                child: DropdownButtonFormField<String>(
                  value: _selectedAvailability,
                  hint: Text("Select Availability"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAvailability = newValue;
                    });
                  },
                  items: <String>["Available", "Unavailable"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: height * 0.06),

              // Save Button
              SizedBox(
                width: width * 0.8,
                child: ElevatedButton(
                  onPressed: _saveAmbulanceData,
                  child: Text("Save Ambulance Data"),
                ),
              ),
              SizedBox(height: height * 0.06),
            ],
          ),
        ),
      ),
    );
  }
}
