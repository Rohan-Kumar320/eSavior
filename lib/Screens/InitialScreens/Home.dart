import 'package:e_savior/Patient/UserForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://cdn3d.iconscout.com/3d/premium/thumb/man-3d-icon-download-in-png-blend-fbx-gltf-file-formats--male-person-happy-people-human-avatar-pack-icons-7590876.png?f=webp'),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Handle item 1 action
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle item 2 action
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildServiceCategories(),
          _buildServiceStacks(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Always ready",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            "anytime & anywhere!",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.search),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  // Handle filter action here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategories() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Services by category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryButton(Icons.local_hotel, 'Ambulance'),
                SizedBox(width: 16.0),
                _buildCategoryButton(Icons.local_hospital, 'First Aid'),
                SizedBox(width: 16.0),
                _buildCategoryButton(Icons.local_hospital, 'Service 3'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        minimumSize: Size(90, 50),
      ),
    );
  }

  Widget _buildServiceStacks() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserAmbulanceFormScreen(),));
            } ,
            child: _buildStack(
              imageUrl: 'https://media.istockphoto.com/id/1423103191/vector/ambulance-solid-icon.jpg?s=612x612&w=0&k=20&c=o4VWSaC9qjQezsjR00fy4nUT3YBx-9T9B6ptc-moB9M=',
              title: 'Book An Ambulance',
              count: '20 ambulances',
            ),
          ),
          SizedBox(height: 16.0),
          _buildStack(
            imageUrl: 'https://static.vecteezy.com/system/resources/thumbnails/018/865/413/small/car-driver-simple-flat-icon-illustration-free-vector.jpg',
            title: 'Driver',
            count: '23 Drivers',
          ),
          SizedBox(height: 16.0),
          _buildStack(
            imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEWWzkhEbw_c7_j2jS98jXGTX4MTZRbqmUuaVVpcqfn6sR-XPaMg8ucnM1gvGbuJIiPWs&usqp=CAU',
            title: 'Staff',
            count: '27 Employees',
          ),
        ],
      ),
    );
  }

  Widget _buildStack({required String imageUrl, required String title, required String count}) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            child: Image.network(
              imageUrl,
              width: 60.0,
              height: 60.0,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.redAccent[100],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: () {
                // Handle arrow icon press
              },
            ),
          ),
        ],
      ),
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
