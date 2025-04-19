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
import 'Features/game.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifications.dart';
import 'all_wellness_tools.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  HomePageState createState() => HomePageState();
}
final List<Map<String, dynamic>> _features = [
  {
    'icon': FontAwesomeIcons.brain,
    'title': 'CBT Exercise',
    'color': Color(0xFF2A9D8F),
    'route': 'cbt_exercise.dart'
  },
  {
    'icon': FontAwesomeIcons.wind,
    'title': 'Breathing',
    'color': Color(0xFF2A9D8F),
    'route': 'breathing.dart'
  },
  {
    'icon': FontAwesomeIcons.book,
    'title': 'Journal',
    'color': Color(0xFF2A9D8F),
    'route': 'journal.dart'
  },
  {
    'icon': FontAwesomeIcons.om,
    'title': 'Meditation',
    'color': Color(0xFF2A9D8F),
    'route': 'meditation.dart'
  },
  {
    'icon': FontAwesomeIcons.music,
    'title': 'Calming Music',
    'color': Color(0xFF2A9D8F),
    'route': 'calming_music.dart'
  },
  {
    'icon': FontAwesomeIcons.moon,
    'title': 'Sleep Stories',
    'color': Color(0xFF2A9D8F),
    'route': 'sleep_stories.dart'
  },
  {
    'icon': FontAwesomeIcons.gamepad,
    'title': 'Games',
    'color': Color(0xFF2A9D8F),
  },
];


class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  String selectedMood = '';  // Store the selected mood
  
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
  final GlobalKey<DashboardState> _dashboardKey = GlobalKey<DashboardState>();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh dashboard when returning to this screen
    _refreshDashboard();
  }

  void _refreshDashboard() {
    if (_dashboardKey.currentState != null) {
      _dashboardKey.currentState!.loadSessionStats();
    }
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

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Emergency Help',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Are you having thoughts of self-harm or suicide?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'You will be connected to a 24/7 suicide prevention helpline.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _makeEmergencyCall();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.phone,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Call Now',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _makeEmergencyCall() async {
    const emergencyNumber = 'tel:+917738925429'; // AASRA 24x7 Helpline number
    try {
      final Uri phoneUri = Uri.parse(emergencyNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $emergencyNumber';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not initiate emergency call. Please dial 7738925429',
            style: GoogleFonts.inter(),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Widget _buildFeatureSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
          'Wellness Tools',
          style: TextStyle(
                  fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllWellnessTools()),
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Color(0xFF2A9D8F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
        ),
      ),
      SizedBox(height: 16),
      Container(
          height: 145,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _features.length,
          itemBuilder: (context, index) {
            final feature = _features[index];
              return Container(
                margin: EdgeInsets.only(right: 16),
                width: 110,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
              onTap: () {
                      // Handle navigation based on feature
                      switch (feature['title']) {
                        case 'Calming Music':
                  Navigator.push(
                    context,
                            MaterialPageRoute(builder: (context) => CalmingMusicScreen()),
                  );
                          break;
                        case 'Meditation':
                  Navigator.push(
                    context,
                            MaterialPageRoute(builder: (context) => MeditationScreen()),
                  );
                          break;
                        case 'Journal':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JournalScreen()),
                  );
                          break;
                        case 'CBT Exercise':
                  Navigator.push(
                    context,
                            MaterialPageRoute(builder: (context) => CBTTestPage()),
                  );
                          break;
                        case 'Breathing':
                  Navigator.push(
                    context,
                            MaterialPageRoute(builder: (context) => BreathingScreen()),
                  );
                          break;
                        case 'Sleep Stories':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SleepStoriesScreen()),
                  );
                          break;
                        case 'Games':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MemoryGameScreen()),
                          );
                          break;
                        default:
                          // Show coming soon message for unimplemented features
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${feature['title']} coming soon!'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                    ),
                  );
                }
              },
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xFF2A9D8F).withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2A9D8F).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FaIcon(
                                  feature['icon'],
                                  color: Color(0xFF2A9D8F),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          feature['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey,',
                  style: TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                "What's on your mind?",
                  style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color: Colors.black54,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          SizedBox(width: 8),
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2A9D8F), Color(0xFF264653)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Daily Wisdom",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Tips by Dr. Theera",
                              style: TextStyle(
                                color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/meditation.svg',
                            height: 50,
                            color: Colors.white.withOpacity(0.9),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF2A9D8F).withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: SlideAction(
                            height: 60,
                    elevation: 0,
                            text: "",
                            innerColor: Color(0xFF2A9D8F),
                            outerColor: Colors.grey[50],
                            sliderButtonYOffset: 0,
                            borderRadius: 20,
                            sliderRotate: false,
                            submittedIcon: FaIcon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // FaIcon(
                                //   FontAwesomeIcons.arrowRight,
                                //   color: Colors.black26,
                                //   size: 16,
                                // ),
                                SizedBox(width: 9),
                                Text(
                                  "Slide to start session",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                    sliderButtonIcon: Container(
                              width: 40,
                              height: 40,
                      decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF2A9D8F), Color(0xFF264653)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF2A9D8F).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                      ),
                      child: Center(
                        child: FaIcon(
                                  FontAwesomeIcons.solidCircleCheck,
                          color: Colors.white,
                                  size: 22,
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
                        ),
                        // Add subtle animation hint
                        Positioned(
                          left: 70,
                          top: 0,
                          bottom: 0,
                          child: AnimatedOpacity(
                            opacity: 0.5,
                            duration: Duration(milliseconds: 1500),
                            child: Row(
                              children: List.generate(3, (index) => 
                                Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    color: Colors.black12,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                        FontAwesomeIcons.phone,
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
                  _buildMoodTracker(),
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2A9D8F).withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _showEmergencyDialog,
          backgroundColor: Color(0xFF2A9D8F),
          extendedPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          icon: FaIcon(
            FontAwesomeIcons.phone,
            color: Colors.white,
            size: 16,
          ),
          label: Text(
            'Help',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          elevation: 2,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

Widget _buildDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Dashboard(key: _dashboardKey),
    );
  }
  Widget _buildOptionCard(IconData icon, String title) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF2A9D8F).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A9D8F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(
                    title.contains('Talk') ? FontAwesomeIcons.phone : FontAwesomeIcons.comments,
                    color: Color(0xFF2A9D8F),
                    size: 24,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodTracker() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFF2A9D8F).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "How are you feeling?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Today",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMoodIcon(FontAwesomeIcons.faceGrinBeam, "Great", Color(0xFF4CAF50)),
              _buildMoodIcon(FontAwesomeIcons.faceSmile, "Good", Color(0xFF8BC34A)),
              _buildMoodIcon(FontAwesomeIcons.faceMeh, "Okay", Color(0xFFFFC107)),
              _buildMoodIcon(FontAwesomeIcons.faceFrown, "Bad", Color(0xFFFF9800)),
              _buildMoodIcon(FontAwesomeIcons.faceSadTear, "Awful", Color(0xFFF44336)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIcon(IconData icon, String label, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            selectedMood = label;
          });
          _showMoodDialog(context, label.toLowerCase());
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: FaIcon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoodDialog(BuildContext context, String mood) {
    String message;
    Color messageColor;
    bool showChatOptions = false;
    String lottieAsset = '';

    switch (mood.toLowerCase()) {
      case 'awful':
        message = "I'm here to listen and support you through this difficult time.";
        messageColor = Colors.red[700]!;
        showChatOptions = true;
        break;
      case 'bad':
        message = "Sometimes talking can help lighten the weight we carry.";
        messageColor = Colors.orange[700]!;
        showChatOptions = true;
        break;
      case 'okay':
        message = "Would you like to talk? I'm here to listen.";
        messageColor = Colors.blue[700]!;
        showChatOptions = true;
        break;
      case 'good':
        message = "That's wonderful! Keep nurturing this positive energy.";
        messageColor = Colors.green[700]!;
        lottieAsset = 'assets/happy.json';
        break;
      case 'great':
        message = "Fantastic! Your joy brightens the day!";
        messageColor = Colors.green[700]!;
        lottieAsset = 'assets/celebration.json';
        break;
      default:
        message = "Would you like to share how you're feeling?";
        messageColor = Colors.grey[700]!;
        showChatOptions = true;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.fromLTRB(24, 24, 24, showChatOptions ? 16 : 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lottieAsset.isNotEmpty) ...[
                  SizedBox(
                    height: 120,
                    child: Lottie.asset(
                      lottieAsset,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: messageColor,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showChatOptions) ...[
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionButton(
                          icon: FontAwesomeIcons.phone,
                          label: 'Talk',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TalkToTheeraScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildOptionButton(
                          icon: FontAwesomeIcons.comments,
                          label: 'Chat',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatWithTheeraScreen(),
                              ),
                            );
                          },
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Close',
                      style: GoogleFonts.inter(
                        color: Color(0xFF2A9D8F),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      color: isPrimary ? Color(0xFF2A9D8F) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: isPrimary ? null : Border.all(color: Color(0xFF2A9D8F)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 16,
                color: isPrimary ? Colors.white : Color(0xFF2A9D8F),
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isPrimary ? Colors.white : Color(0xFF2A9D8F),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

