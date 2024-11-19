import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'dart:async';
import 'talk_to_theera.dart';
import 'chat_with_theera.dart';
import 'dashboard.dart';
import 'option_card.dart';
import 'tip_of_the_day.dart';
import 'package:therapify/main/Features/feature_card.dart'; 
import 'package:therapify/main/Features/cbt_exercise.dart'; 
import 'package:therapify/main/Features/breathing.dart'; 
import 'package:therapify/main/Features/meditation.dart'; 
import 'package:therapify/main/Features/journal.dart'; 
import 'package:therapify/main/Features/calming_music.dart'; 
import 'package:therapify/main/Features/sleep_stories.dart'; 




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
final List<Map<String, dynamic>> _features = [
  {
    'icon': FontAwesomeIcons.music,
    'title': 'Calming Music',
    'color': Color(0xFF7B68EE),
    'route': 'calming_music.dart'
  },
  {
    'icon': FontAwesomeIcons.om,
    'title': 'Meditation',
    'color': Color(0xFF4CAF50),
    'route': 'meditation.dart'
  },
  {
    'icon': FontAwesomeIcons.book,
    'title': 'Journal',
    'color': Color(0xFFFF7043),
    'route': 'journal.dart'
  },
  {
    'icon': FontAwesomeIcons.brain,
    'title': 'CBT Exercise',
    'color': Color(0xFF42A5F5),
    'route': 'cbt_exercise.dart'
  },
  {
    'icon': FontAwesomeIcons.solidHeart,
    'title': 'Breathing',
    'color': Color(0xFF66BB6A),
    'route': 'breathing.dart'
  },
  {
    'icon': FontAwesomeIcons.bed,
    'title': 'Sleep Stories',
    'color': Color(0xFF8E24AA),
    'route': 'sleep_stories.dart'
  },
  {
    'icon': FontAwesomeIcons.brain,
    'title': 'Games',
    'color': Colors.teal,
    
  },
];


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _showTip = false;
  String _tip = '';
  final List<String> _tips = [
    'Take a deep breath and smile.',
    'Remember to stay hydrated.',
    'Try to get at least 30 minutes of exercise daily.',
    'Take a break and listen to your favorite music.',
    'Practice mindfulness for a few minutes each day.',
  ];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showRandomTip() {
    setState(() {
      _tip = (_tips..shuffle()).first;
      _showTip = true;
    });

    _animationController.forward(from: 0.0);

    Timer(Duration(seconds: 5), () {
      setState(() {
        _showTip = false;
      });
      _animationController.reverse();
    });
  }

  Widget _buildFeatureSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Wellness Tools',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      SizedBox(height: 16),
      Container(
        height: 120,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _features.length,
          itemBuilder: (context, index) {
            final feature = _features[index];
            return FeatureCard(
              icon: feature['icon'],
              title: feature['title'],
              color: feature['color'],
              onTap: () {
                if (index == 3) { // Check if it's the 4th icon (index 3)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CBTTestPage()),
                  );
                } else if (index == 4) { // Check if it's the 4th icon (index 3)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BreathingScreen()),
                  );
                }
                else if (index == 2) { // Check if it's the 4th icon (index 3)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JournalScreen()),
                  );
                }
                else if (index == 1) { // Check if it's the 4th icon (index 3)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MeditationScreen()),
                  );
                } 
                else if (index == 0) { // Check if it's the 4th icon (index 3)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalmingMusicScreen()),
                  );
                }  
                else if (index == 5) { // Check if it's the 4th icon (index 3)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SleepStoriesScreen()),
                  );
                }  

                 else
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${feature['title']} coming soon!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    ],
  );
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
                    color: Colors.teal,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 11),
                  GestureDetector(
                    onTap: _showRandomTip,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "  Tips by Dr. Theera",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TalkToTheeraScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 0),

                  _buildDashboard(),
                  SizedBox(height: 0),
                  _buildFeatureSection(),
                  SizedBox(height: 27),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildOptionCard(
                        FontAwesomeIcons.phoneAlt,
                        "Talk with Theera",
                      ),
                      SizedBox(width: 0),
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
                ],
              ),
            ),
          ),
          if (_showTip)
            TipOfTheDay(
              tip: _tip,
              animationController: _animationController,
              onDismiss: () {
                setState(() {
                  _showTip = false;
                });
                _animationController.reverse();
              },
            ),
        ],
      ),
    );
  }

Widget _buildDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Dashboard(),
    );
  }
  Widget _buildOptionCard(IconData icon, String title) {
    return OptionCard(
      icon: icon,
      title: title,
      onTap: () {
        if (title == "Talk with Theera") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TalkToTheeraScreen()),
          );
        } else if (title == "Chat with Theera") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatWithTheeraScreen()),
          );
        }
      },
    );
  }
}
