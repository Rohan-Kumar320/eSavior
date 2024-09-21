import 'package:e_savior/Screens/Login&Register/Login.dart';
import 'package:flutter/material.dart';
import 'onBoardingMaterial.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 800, // Set a fixed height for the PageView
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      Container(
                        height: 489,
                        width: double.infinity,
                        child: ClipRRect(
                          child: Image.asset(
                            contents[i].image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 40,
                        child: Text(
                          contents[i].title1,
                          style: TextStyle(
                            fontFamily: 'Libre',
                            fontSize: 30,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Libre',
                              fontSize: 30,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: contents[i].title2,
                                style: TextStyle(color: Colors.black87),
                              ),
                              TextSpan(
                                text: contents[i].subtitle,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 400,
                          child: Center(
                            child: Text(
                              contents[i].discription,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Libre',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            contents.length,
                                (index) => buildDot(index, context),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.all(40),
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            currentIndex == contents.length - 1
                                ? "Continue"
                                : "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Libre',
                            ),
                          ),
                          onPressed: () {
                            if (currentIndex == contents.length - 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            }
                            _controller.nextPage(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.bounceIn,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index
            ? Colors.red
            : Colors.grey, // Red for active, grey for inactive
      ),
    );
  }
}
