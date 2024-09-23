import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAmbulances extends StatefulWidget {
  const ViewAmbulances({Key? key}) : super(key: key);

  @override
  _ViewAmbulancesState createState() => _ViewAmbulancesState();
}

class _ViewAmbulancesState extends State<ViewAmbulances> {
  String _searchText = ""; // Holds the value entered in the search bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View Ambulances",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.redAccent, // Change to redAccent
          ),
        ),
        elevation: 0.0, // Keep the AppBar flat for a more minimal design
      ),
      backgroundColor: Colors.grey[200], // Light background for a clean look
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search by Hospital Name",
                hintText: "Enter hospital name",
                prefixIcon: Icon(Icons.search, color: Colors.redAccent), // Change to redAccent
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.redAccent, // Change to redAccent
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.redAccent, // Change to redAccent
                    width: 2.0,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase(); // Update search text
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ambulances')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No ambulances found",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                // Filter the ambulances based on the search text
                var filteredAmbulances = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  var hospitalName = data['hospital_name']?.toString().toLowerCase() ?? '';
                  return hospitalName.contains(_searchText);
                }).toList();

                if (filteredAmbulances.isEmpty) {
                  return const Center(
                    child: Text(
                      "No ambulances match your search",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredAmbulances.length,
                  itemBuilder: (context, index) {
                    var ambulanceData = filteredAmbulances[index].data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Softer corners for the card
                        ),
                        elevation: 5.0,
                        shadowColor: Colors.grey.withOpacity(0.3), // Softer shadow
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white, // White background for a clean look
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.redAccent, size: 30), // Change to redAccent
                                  const SizedBox(width: 12),
                                  Text(
                                    "Driver: ${ambulanceData['driver_name']}",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4D4D4D), // Softer black for text
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const Divider(color: Colors.grey, thickness: 1.0), // Softer divider

                              // Mobile
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.redAccent, size: 22), // Change to redAccent
                                  const SizedBox(width: 10),
                                  Text(
                                    "Mobile: ${ambulanceData['driver_mobile']}",
                                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Email
                              Row(
                                children: [
                                  const Icon(Icons.email, color: Colors.redAccent, size: 22), // Change to redAccent
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Email: ${ambulanceData['driver_email']}",
                                      style: const TextStyle(fontSize: 18, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Hospital Name
                              Row(
                                children: [
                                  const Icon(Icons.local_hospital, color: Colors.redAccent, size: 22), // Change to redAccent
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Hospital: ${ambulanceData['hospital_name']}",
                                      style: const TextStyle(fontSize: 18, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Hospital Address
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.redAccent, size: 22), // Change to redAccent
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Address: ${ambulanceData['hospital_address']}",
                                      style: const TextStyle(fontSize: 18, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Ambulance Type
                              Row(
                                children: [
                                  const Icon(Icons.directions_car, color: Colors.redAccent, size: 22), // Change to redAccent
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Type: ${ambulanceData['ambulance_type']}",
                                      style: const TextStyle(fontSize: 18, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Availability
                              Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.redAccent, size: 22), // Change to redAccent
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Availability: ${ambulanceData['driver_availability']}",
                                      style: const TextStyle(fontSize: 18, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              const Divider(color: Colors.grey, thickness: 1.0), // Softer divider

                              // Date and Time Added
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.redAccent, size: 22), // Change to redAccent
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Date Added: ${ambulanceData['date_added']}",
                                      style: const TextStyle(fontSize: 18, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, color: Colors.redAccent, size: 22), // Change to redAccent
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Time Added: ${ambulanceData['time_added']}",
                                      style: const TextStyle(fontSize: 18, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
}
