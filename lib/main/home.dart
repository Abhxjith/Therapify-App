import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therapy App',
      theme: appTheme,
      home: HomePage(),
    );
  }
}

final ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF269D9D),
  primarySwatch: MaterialColor(
    0xFF269D9D,
    <int, Color>{
      50: Color(0xFFE0F7F7),
      100: Color(0xFFB3ECEC),
      200: Color(0xFF80E0E0),
      300: Color(0xFF4DD4D4),
      400: Color(0xFF26C9C9),
      500: Color(0xFF269D9D),
      600: Color(0xFF238E8E),
      700: Color(0xFF1F7C7C),
      800: Color(0xFF1A6A6A),
      900: Color(0xFF134F4F),
    },
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.interTextTheme(),
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showTip = false;
  String _tip = '';
  final List<String> _tips = [
    'Take a deep breath and smile.',
    'Remember to stay hydrated.',
    'Try to get at least 30 minutes of exercise daily.',
    'Take a break and listen to your favorite music.',
    'Practice mindfulness for a few minutes each day.',
  ];

  void _showRandomTip() {
    setState(() {
      _tip = (_tips..shuffle()).first;
      _showTip = true;
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        _showTip = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey,',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "What Happened?",
                  style: TextStyle(
                    color: appTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color: appTheme.primaryColor,
            ),
            onPressed: () {
              // Action to perform when the notification icon is pressed
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 11),
              InkWell(
                onTap: _showRandomTip,
                child: Container(
                  padding: EdgeInsets.all(16),
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color(0xFF80D2D2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "  Tips by Doctor X",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      SvgPicture.asset(
                        'assets/meditation.svg',
                        height: 64,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              SlideAction(
                height: 55,
                elevation: 0,
                text: "        Slide to start your session",
                textStyle: TextStyle(
                  color: appTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                innerColor: appTheme.primaryColor,
                outerColor: Color(0xFFE0F7F7),
                sliderButtonYOffset: 0,
                borderRadius: 11,
                sliderButtonIcon: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: appTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.angleRight,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                onSubmit: () {
                  // Action to perform after sliding
                },
              ),
              SizedBox(height: 25),
              _buildDashboard(),
              SizedBox(height: 20),
              Text(
                "Nearby Therapists",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTherapistCard(),
                  _buildTherapistCard(),
                  _buildTherapistCard(),
                  _buildTherapistCard(),
                ],
              ),
              SizedBox(height: 27),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOptionCard(
                    FontAwesomeIcons.phoneAlt,
                    "Talk with Theera",
                  ),
                  SizedBox(width: 17),
                  _buildOptionCard(
                    FontAwesomeIcons.comments,
                    "Chat with Theera",
                  ),
                ],
              ),
              SizedBox(height: 27),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "How do you feel today?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 9),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.smile,
                              color: Colors.yellow,
                              size: 36,
                            ),
                            FaIcon(
                              FontAwesomeIcons.smileBeam,
                              color: Colors.yellow,
                              size: 36,
                            ),
                            FaIcon(
                              FontAwesomeIcons.smile,
                              color: Colors.yellow,
                              size: 36,
                            ),
                            FaIcon(
                              FontAwesomeIcons.frownOpen,
                              color: Colors.red,
                              size: 36,
                            ),
                            FaIcon(
                              FontAwesomeIcons.frown,
                              color: Colors.red,
                              size: 36,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_showTip) ...[
                AnimatedOpacity(
                  opacity: _showTip ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFF80D2D2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _tip,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(IconData icon, String title) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            // Add action when tapped
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FaIcon(icon, color: appTheme.primaryColor, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTherapistCard() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xFF80E0E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appTheme.primaryColor,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/therapist.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDashboardItem(
                'Total Sessions',
                '12',
                FontAwesomeIcons.calendarCheck,
              ),
              _buildDashboardItem(
                'Progress',
                '85%',
                FontAwesomeIcons.chartLine,
              ),
              _buildDashboardItem(
                'Goals Met',
                '5/6',
                FontAwesomeIcons.flagCheckered,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(String title, String value, IconData icon) {
    return Column(
      children: [
        FaIcon(
          icon,
          color: appTheme.primaryColor,
          size: 36,
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appTheme.primaryColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
