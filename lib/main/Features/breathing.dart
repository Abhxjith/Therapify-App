import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapify/main/navbar.dart';
import 'package:therapify/main/home.dart';

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
  
  int _selectedDuration = 1; // Duration in minutes
  int _remainingSeconds = 0;
  Timer? _countdownTimer;

  final List<int> _availableDurations = [1, 2, 5, 10, 15, 20];

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
      _remainingSeconds = _selectedDuration * 60;
    });
    
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        _isInhaling = !_isInhaling;
        _circleSize = _isInhaling ? 200 : 300;
        _animationController.reset();
        _animationController.forward();
      });
    });

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopExercise();
        }
      });
    });
    
    _animationController.forward();
  }

  void _stopExercise() {
    _timer.cancel();
    _countdownTimer?.cancel();
    setState(() {
      _isExerciseStarted = false;
      _isInhaling = true;
      _circleSize = 200;
    });
    _animationController.reset();
    
    // Increment exercise count
    _completeExercise();
  }
  
  void _completeExercise() async {
    // Increment exercise count
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('exerciseCount') ?? 0;
    await prefs.setInt('exerciseCount', currentCount + 1);

    // Show a brief success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Breathing exercise completed successfully!'),
        backgroundColor: Color(0xFF2A9D8F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate directly to home screen with navbar
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
        (route) => false,
      );
    });
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    if (_isExerciseStarted) {
      _timer.cancel();
      _countdownTimer?.cancel();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleLeft, size: 20, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mindful Breathing',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            if (!_isExerciseStarted) ...[
              SizedBox(height: 40),
              Text(
                'Select Duration',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableDurations.length,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final duration = _availableDurations[index];
                    final isSelected = duration == _selectedDuration;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDuration = duration;
                        });
                      },
                      child: Container(
                        width: 70,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Color(0xFF2A9D8F).withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xFF2A9D8F)
                                : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${duration}m',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Color(0xFF2A9D8F) : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _isExerciseStarted ? 1.0 : 0.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A9D8F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        _isInhaling ? 'Exhale...' : 'Inhale...',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2A9D8F),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  
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
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFF2A9D8F).withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2A9D8F).withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A9D8F).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.wind,
                          size: 40,
                          color: Color(0xFF2A9D8F),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _isExerciseStarted ? 1.0 : 0.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.clock,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 8),
                          Text(
                            '4 seconds',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExerciseStarted) ...[
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A9D8F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatDuration(_remainingSeconds),
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2A9D8F),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_isExerciseStarted)
                    TextButton(
                      onPressed: _stopExercise,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.stop,
                            size: 16,
                            color: Colors.red[400],
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Stop Exercise',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2A9D8F), Color(0xFF264653)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _startBreathingCycle,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.play,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Start Breathing',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
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