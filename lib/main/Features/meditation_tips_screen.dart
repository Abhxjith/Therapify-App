import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MeditationTipsScreen extends StatelessWidget {
  final List<MeditationTip> tips = [
    MeditationTip(
      icon: FontAwesomeIcons.chair,
      title: 'Find a Comfortable Position',
      description: 'Sit in a position that allows you to be both comfortable and alert. Keep your spine straight but not rigid.',
    ),
    MeditationTip(
      icon: FontAwesomeIcons.clock,
      title: 'Start Small',
      description: "Begin with just 5-10 minutes daily. It's better to meditate consistently for a short time than irregularly for longer periods.",
    ),
    MeditationTip(
      icon: FontAwesomeIcons.wind,
      title: 'Focus on Your Breath',
      description: 'Use your breath as an anchor. Notice the sensation of breathing in and out without trying to change it.',
    ),
    MeditationTip(
      icon: FontAwesomeIcons.brain,
      title: "Don't Fight Your Thoughts",
      description: "When your mind wanders, gently bring your attention back to your breath. Don't judge yourself for getting distracted.",
    ),
    MeditationTip(
      icon: FontAwesomeIcons.gear,
      title: 'Create a Routine',
      description: 'Meditate at the same time and place each day. This helps build a sustainable practice.',
    ),
    MeditationTip(
      icon: FontAwesomeIcons.heart,
      title: 'Be Kind to Yourself',
      description: "There's no such thing as a \"perfect\" meditation. Every session is valuable, even if it feels challenging.",
    ),
  ];

  MeditationTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Meditation Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
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
                        FontAwesomeIcons.lightbulb,
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tip = tips[index];
                return _buildTipCard(tip);
              },
              childCount: tips.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(MeditationTip tip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF269D9D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                tip.icon,
                color: const Color(0xFF269D9D),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
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

class MeditationTip {
  final IconData icon;
  final String title;
  final String description;

  const MeditationTip({
    required this.icon,
    required this.title,
    required this.description,
  });
}