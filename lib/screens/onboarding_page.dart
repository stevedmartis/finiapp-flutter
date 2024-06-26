import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/signup-vector.svg",
      "title": "Choose Your Product",
      "description":
          "Welcome to a World of Limitless Choices - Your Perfect Product Awaits!"
    },
    {
      "image": "assets/images/signup-vector.svg",
      "title": "Easy Payment",
      "description":
          "Fast and Secure Payment Options Available at Your Fingertips."
    },
    {
      "image": "assets/images/signup-vector.svg",
      "title": "Quick Delivery",
      "description":
          "Get Your Products Delivered Quickly and Safely to Your Doorstep."
    }
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [logoCOLOR1, logoCOLOR2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) => OnboardingPage(
                image: _onboardingData[index]['image']!,
                title: _onboardingData[index]['title']!,
                description: _onboardingData[index]['description']!,
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity:
                        _currentIndex == _onboardingData.length - 1 ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [logoCOLOR1, logoCOLOR1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          if (_currentIndex == _onboardingData.length - 1) {
                            Navigator.of(context)
                                .pushReplacementNamed('/mainScreen');
                          } else {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 12,
      width: 12,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.white : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          SvgPicture.asset(
            image,
            height: 300,
          ),
          SizedBox(height: 30),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
