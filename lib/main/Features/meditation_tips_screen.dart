import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MeditationTipsScreen extends StatelessWidget {
  final List<MeditationTip> tips = [
    MeditationTip(
      icon: FontAwesomeIcons.chair,
      title: 'Find a Comfortable Position',
      description: 'Sit in a position that allows you to be both comfortable and alert. Keep your spine straight but not rigid.',
      color: Color(0xFF2A9D8F),
    ),
    MeditationTip(
      icon: FontAwesomeIcons.clock,
      title: 'Start Small',
      description: "Begin with just 5-10 minutes daily. It's better to meditate consistently for a short time than irregularly for longer periods.",
      color: Color(0xFF264653),
    ),
    MeditationTip(
      icon: FontAwesomeIcons.wind,
      title: 'Focus on Your Breath',
      description: 'Use your breath as an anchor. Notice the sensation of breathing in and out without trying to change it.',
      color: Color(0xFFE9C46A),
    ),
    MeditationTip(
      icon: FontAwesomeIcons.brain,
      title: "Don't Fight Your Thoughts",
      description: "When your mind wanders, gently bring your attention back to your breath. Don't judge yourself for getting distracted.",
      color: Color(0xFFF4A261),
    ),
    MeditationTip(
      icon: FontAwesomeIcons.gear,
      title: 'Create a Routine',
      description: 'Meditate at the same time and place each day. This helps build a sustainable practice.',
      color: Color(0xFFE76F51),
    ),
    MeditationTip(
      icon: FontAwesomeIcons.heart,
      title: 'Be Kind to Yourself',
      description: "There's no such thing as a \"perfect\" meditation. Every session is valuable, even if it feels challenging.",
      color: Color(0xFF2A9D8F),
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
          'Meditation Tips',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: tip.color.withOpacity(0.2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Show detailed tip in bottom sheet
                  _showTipDetails(context, tip);
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: tip.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FaIcon(
                              tip.icon,
                              color: tip.color,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              tip.title,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.angleRight,
                            size: 16,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        tip.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTipDetails(BuildContext context, MeditationTip tip) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: tip.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: FaIcon(
                            tip.icon,
                            color: tip.color,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            tip.title,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      tip.description,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                    // Add more detailed content here
                  ],
                ),
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
  final Color color;

  const MeditationTip({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}