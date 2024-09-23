import 'package:flutter/material.dart';

class Galley extends StatefulWidget {
  const Galley({super.key});

  @override
  State<Galley> createState() => _GalleyState();
}

class _GalleyState extends State<Galley> {
  // Sample list of images (you can replace this with your own assets or network images)
  final List<String> galleryImages = [
    'assets/images/h5.jpg',
    'assets/images/h6.jpg',
    'assets/images/h11.jpg',
    'assets/images/h12.jpg',
    'assets/images/h9.jpg',
    'assets/images/h3.jpg',
    'assets/images/h4.jpg',
    'assets/images/h1.jpg',
    'assets/images/h7.jpg',
    'assets/images/h8.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ambulance Gallery',
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: galleryImages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // You can change the number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2, // Adjust for the aspect ratio of images
          ),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                galleryImages[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}