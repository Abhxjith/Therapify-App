import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:therapify/main/Features/breathing.dart';
import 'meditation_tips_screen.dart';

class MeditationScreen extends StatelessWidget {
  final List<MeditationSession> sessions = [
    MeditationSession(
      title: 'Mindful Breathing',
      duration: '10 min',
      category: 'Beginner',
      icon: FontAwesomeIcons.wind,
      description: 'Focus on your breath to find inner peace',
      color: Color(0xFF2A9D8F),
      route: (context) => BreathingScreen(),
    ),
    MeditationSession(
      title: 'Meditation Tips',
      duration: '15 min',
      category: 'Intermediate',
      icon: FontAwesomeIcons.brain,
      description: 'Learn essential meditation techniques',
      color: Color(0xFF2A9D8F),
      route: (context) => MeditationTipsScreen(),
    ),
  ];

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
          'Meditation',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Session
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2A9D8F),
                    Color(0xFF264653),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BreathingScreen()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.om,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Daily Meditation',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start your day with mindfulness',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.clock,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '10 min',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Section Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Meditation Sessions',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            // Session Cards
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(20),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFF2A9D8F).withOpacity(0.1),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (session.route != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: session.route!),
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: session.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: FaIcon(
                                session.icon,
                                color: session.color,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.title,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    session.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                session.duration,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MeditationSession {
  final String title;
  final String duration;
  final String category;
  final String description;
  final IconData icon;
  final Color color;
  final Widget Function(BuildContext)? route;

  MeditationSession({
    required this.title,
    required this.duration,
    required this.category,
    required this.icon,
    required this.color,
    this.description = '',
    this.route,
  });
}