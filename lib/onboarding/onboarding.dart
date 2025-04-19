import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:therapify/onboarding/ob1.dart';
import 'package:therapify/onboarding/ob2.dart';
import 'package:therapify/onboarding/ob3.dart';
import 'package:therapify/onboarding_form/onboarding_form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    
    if (!isFirstTime) {
      // If not first time, navigate directly to form
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingFormScreen()),
        );
      });
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

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
                    onPressed: () async {
                      await _completeOnboarding();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => OnboardingFormScreen()),
                      );
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
                    onPressed: () async {
                      if (_controller.page == 2) {
                        // Complete onboarding and navigate to form
                        await _completeOnboarding();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OnboardingFormScreen()),
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
