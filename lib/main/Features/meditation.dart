import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:therapify/main/Features/breathing.dart';
import 'meditation_tips_screen.dart';

class MeditationScreen extends StatelessWidget {
  // Custom meditation session data
  final List<MeditationSession> sessions = [
  MeditationSession(
    title: 'Mindful Breathing',
    duration: '10 min',
    category: 'Beginner',
    icon: FontAwesomeIcons.wind,
    color: Color(0xFF269D9D),
    route: (context) => BreathingScreen(),
  ),
  MeditationSession(
    title: 'Meditation Tips',
    duration: '15 min',
    category: 'Intermediate',
    icon: FontAwesomeIcons.person,
    color: Color(0xFF269D9D),
    route: (context) => MeditationTipsScreen(), // Updated this line
  ),
];

  final List<String> categories = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Meditate',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF269D9D),
                      Colors.teal,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Icon(
                        FontAwesomeIcons.om,
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Daily Quote
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Wisdom',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF269D9D),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '"Peace comes from within. Do not seek it without."',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    '- Buddha',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    child: FilterChip(
                      label: Text(
                        categories[index],
                        style: TextStyle(
                          color: index == 0 ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      selected: index == 0,
                      selectedColor: Color(0xFF269D9D),
                      backgroundColor: Colors.white,
                      onSelected: (bool selected) {
                        // Handle category selection
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Meditation Sessions
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final session = sessions[index];
                  return _buildMeditationCard(context, session);
                },
                childCount: sessions.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(BuildContext context, MeditationSession session) {
    return Hero(
      tag: 'meditation_${session.title}',
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              if (session.route != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => session.route!(context),
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: session.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      session.icon,
                      color: session.color,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    session.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    session.category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.clock,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        session.duration,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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
    );
  }
}

class MeditationSession {
  final String title;
  final String duration;
  final String category;
  final IconData icon;
  final Color color;
  final Widget Function(BuildContext)? route;

  MeditationSession({
    required this.title,
    required this.duration,
    required this.category,
    required this.icon,
    required this.color,
    this.route,
  });
}