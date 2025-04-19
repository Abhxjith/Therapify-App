import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:therapify/main/Features/cbt_exercise.dart';
import 'package:therapify/main/Features/breathing.dart';
import 'package:therapify/main/Features/journal.dart';
import 'package:therapify/main/Features/meditation.dart';
import 'package:therapify/main/Features/calming_music.dart';
import 'package:therapify/main/Features/sleep_stories.dart';
import 'package:therapify/main/Features/game.dart';
import 'package:google_fonts/google_fonts.dart';

class AllWellnessTools extends StatelessWidget {
  final List<Map<String, dynamic>> _features = [
    {
      'icon': FontAwesomeIcons.brain,
      'title': 'CBT Exercise',
      'subtitle': 'Cognitive Behavioral Therapy',
      'color': Color(0xFF2A9D8F),
      'route': CBTTestPage(),
    },
    {
      'icon': FontAwesomeIcons.wind,
      'title': 'Breathing',
      'subtitle': 'Guided Breathing Exercises',
      'color': Color(0xFF2A9D8F),
      'route': BreathingScreen(),
    },
    {
      'icon': FontAwesomeIcons.book,
      'title': 'Journal',
      'subtitle': 'Reflect & Document',
      'color': Color(0xFF2A9D8F),
      'route': JournalScreen(),
    },
    {
      'icon': FontAwesomeIcons.om,
      'title': 'Meditation',
      'subtitle': 'Mindfulness Practice',
      'color': Color(0xFF2A9D8F),
      'route': MeditationScreen(),
    },
    {
      'icon': FontAwesomeIcons.music,
      'title': 'Calming Music',
      'subtitle': 'Soothing Soundscapes',
      'color': Color(0xFF2A9D8F),
      'route': CalmingMusicScreen(),
    },
    {
      'icon': FontAwesomeIcons.moon,
      'title': 'Sleep Stories',
      'subtitle': 'Bedtime Narratives',
      'color': Color(0xFF2A9D8F),
      'route': SleepStoriesScreen(),
    },
    {
      'icon': FontAwesomeIcons.gamepad,
      'title': 'Games',
      'subtitle': 'Mindful Entertainment',
      'color': Color(0xFF2A9D8F),
      'route': MemoryGameScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(
          'Wellness Tools',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Color(0xFFF5F5F7),
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black54,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'Explore our collection of wellness tools designed to support your mental health journey.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final feature = _features[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => feature['route']),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                color: Color(0xFF2A9D8F).withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: FaIcon(
                                    feature['icon'],
                                    color: Color(0xFF2A9D8F),
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feature['title'],
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    feature['subtitle'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: _features.length,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 24),
          ),
        ],
      ),
    );
  }
} 