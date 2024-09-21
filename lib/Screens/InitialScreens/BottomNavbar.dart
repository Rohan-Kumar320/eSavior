import 'package:e_savior/Screens/InitialScreens/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() =>
      _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add your main body content here
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        height: 70,
        decoration: BoxDecoration(
          color: Color(0xCC232C40).withOpacity(0.8),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNavBarItem(icon: CupertinoIcons.home, index: 0),
            _buildNavBarItem(icon: CupertinoIcons.timer, index: 1),
            _buildNavBarItem(icon: CupertinoIcons.bell, index: 2),
            _buildNavBarItem(icon: CupertinoIcons.calendar, index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem({required IconData icon, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentIndex == index ? Colors.white : Colors.white,
            size: 25,
          ),
          if (currentIndex == index)
            Container(
              margin: EdgeInsets.only(top: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
