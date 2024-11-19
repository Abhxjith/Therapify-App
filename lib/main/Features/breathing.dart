import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BreathingScreen extends StatefulWidget {
  @override
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  bool _isInhaling = true;
  double _circleSize = 200;
  late Timer _timer;
  late AnimationController _animationController;
  bool _isExerciseStarted = false;

  // Custom colors
  final Color primaryColor = Color(0xFF269D9D);
  final Color secondaryColor = Color(0xFFB2E0E2);
  final Color accentColor = Color(0xFFE4F6F8);
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
  }

  void _startBreathingCycle() {
    setState(() {
      _isExerciseStarted = true;
    });
    
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        _isInhaling = !_isInhaling;
        _circleSize = _isInhaling ? 200 : 300; // Increased size difference
        
        // Reset and restart animation
        _animationController.reset();
        _animationController.forward();
      });
    });
    
    // Start initial animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Mindful Breathing',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Breathing status text
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: _isExerciseStarted ? 1.0 : 0.0,
                        child: Text(
                          _isInhaling ? 'Exhale...' : 'Inhale...',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      
                      // Animated breathing circle
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: Duration(seconds: 4),
                            curve: Curves.easeInOut,
                            width: _circleSize,
                            height: _circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accentColor.withOpacity(0.3),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            FontAwesomeIcons.wind,
                            size: 50,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      
                      // Timer text
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: _isExerciseStarted ? 1.0 : 0.0,
                        child: Text(
                          '4 seconds',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom button
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: _isExerciseStarted ? null : _startBreathingCycle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: primaryColor.withOpacity(0.5),
                  ),
                  child: Text(
                    _isExerciseStarted ? 'Exercise in Progress' : 'Start Breathing',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}