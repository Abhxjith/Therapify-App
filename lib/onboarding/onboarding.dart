import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:therapify/onboarding/ob1.dart';
import 'package:therapify/onboarding/ob2.dart';
import 'package:therapify/onboarding/ob3.dart';
import 'package:therapify/main/navbar.dart'; // Import Navbar
import 'package:therapify/Login/login.dart'; 


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7), // Updated background color
      body: Padding(
        padding: const EdgeInsets.all(44.0), // Padding on all sides
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  OnboardingPage1(),
                  OnboardingPage2(),
                  OnboardingPage3(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0), // Padding for bottom controls
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(3);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17, // Font size for Skip button
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: WormEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controller.page == 2) {
                        // Navigate to the Navbar when on the last page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } else {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17, // Font size for Next button
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
}
