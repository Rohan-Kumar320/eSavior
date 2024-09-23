import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_savior/Screens/InitialScreens/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AboutUs.dart';
import 'ContactUs.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Stack(
                children: [
                  Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'e-Savior',
                          textStyle: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                          colors: [
                            Colors.white,
                            Colors.black,
                            Colors.blue,
                            Colors.pink,
                          ],
                        ),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the drawer
                      },
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            _buildMenuItem(
              context,
              icon: CupertinoIcons.home,
              text: 'Home',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: CupertinoIcons.info,
              text: 'About',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Aboutus()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: CupertinoIcons.phone,
              text: 'Contact',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Contactus()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: CupertinoIcons.clock,
              text: 'History',
              onTap: () {},
            ),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              thickness: 1,
            ),
            _buildMenuItem(
              context,
              icon: CupertinoIcons.settings,
              text: 'Settings',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.black, size: 28),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        tileColor: Colors.grey.shade200,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}