import 'dart:ui';
import 'package:e_savior/Screens/InitialScreens/BottomNavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  // Defining required lists
  final List<String> reasons = [
    "Fast Response Times",
    "Highly Trained Staff",
    "Modern Equipment",
    "24/7 Service"
  ];

  final List<String> reasondescription = [
    "We ensure prompt arrival at emergency scenes.",
    "Our paramedics and drivers are certified and experienced.",
    "Our ambulances are equipped with the latest life-saving technology.",
    "We are available at any time, day or night."
  ];

  final List<String> services = [
    "Emergency Transport",
    "Non-Emergency Transport",
    "Patient Transfer Services",
    "Medical Equipment Support"
  ];

  final List<String> servicesDescription = [
    "Immediate medical transport for critical patients.",
    "Scheduled transport for non-urgent medical needs.",
    "Safe transfer of patients between facilities.",
    "Support with advanced medical equipment during transport."
  ];

  final List<String> team = [
    "John Doe",
    "Jane Smith",
    "Emily Johnson"
  ];

  final List<String> designation = [
    "Chief Medical Officer",
    "Lead Paramedic",
    "Head of Operations"
  ];

  @override
  Widget build(BuildContext context) {
    final reswidth = MediaQuery.of(context).size.width;
    final resheight = MediaQuery.of(context).size.height;
    final ScrollController _scrollController = ScrollController();

    void _scrollToTop() {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavbar(),));
          },
        ),
        title: const Text('About us',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.red[500],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: resheight * 0.04),
            Center(
                child: Text(
                  "OUR MISSION",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      decoration: TextDecoration.underline),
                )),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: reswidth * 0.1, vertical: resheight * 0.02),
              child: Center(
                child: Text(
                  "'To provide timely, efficient, and compassionate care during medical emergencies.'",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(height: resheight * 0.01),
            Container(
              width: reswidth * 0.8,
              height: resheight * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                  NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3v0NboDSefbnqeWmHmHooZslpkDSf9Y-3WQ&s'),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: reswidth * 0.1, vertical: resheight * 0.02),
              child: Center(
                child: Text(
                  "Welcome to Our Ambulance Service!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: reswidth * 0.1, vertical: resheight * 0.02),
              child: Center(
                child: Text(
                  "We are dedicated to saving lives by providing fast, reliable, and top-notch emergency medical services. Whether you need emergency transportation or non-emergency assistance, our team is here to ensure you receive the best care.",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: resheight * 0.01),
            Container(
              width: reswidth * 0.8,
              height: resheight * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                  NetworkImage('https://media.istockphoto.com/id/464561927/photo/empty-ambulance-interior.jpg?s=612x612&w=0&k=20&c=Vowne_DIOP3PDgUF9mFvuw5kAPCe4UWFRbNuMMCa65I='),
                ),
              ),
            ),
            SizedBox(height: resheight * 0.02),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: reswidth * 0.1, vertical: resheight * 0.02),
              child: Center(
                child: Text(
                  "Why Choose Us?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reasons.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: reswidth * 0.1, vertical: resheight * 0.02),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "\u2022  ${reasons[index]}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "  ${reasondescription[index]}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: resheight * 0.01),
            Container(
              width: reswidth * 0.8,
              height: resheight * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                  NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUr67PAVerlNBfh3jht9LVHO--zHAkNhD5Eg&s'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: reswidth * 0.1, vertical: resheight * 0.02),
              child: Center(
                child: Text(
                  "Our Services",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: reswidth * 0.1, vertical: resheight * 0.02),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "\u2022  ${services[index]}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: " ${servicesDescription[index]}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: resheight * 0.01),
            Container(
              width: reswidth * 0.8,
              height: resheight * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                  NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2R-b43HyIkRfjcNHiPqTXxhd_Fh_C2ohieA&s'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: reswidth * 0.1, vertical: resheight * 0.02),
              child: Center(
                child: Text(
                  "Our Team",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: team.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: reswidth * 0.1, vertical: resheight * 0.02),
                  child: Center(
                    child: Text(
                      "${team[index]} - ${designation[index]}",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}