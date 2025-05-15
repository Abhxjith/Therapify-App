import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int totalSessions = 0;
  int exerciseCount = 0;
  DateTime? lastSessionDate;
  bool isFirstSession = true;

  Future<void> loadSessionStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstSession = prefs.getBool('isFirstSession') ?? true;
      totalSessions = prefs.getInt('sessionCount') ?? 0;
      exerciseCount = prefs.getInt('exerciseCount') ?? 0;
      String? lastSessionDateStr = prefs.getString('lastSessionDate');
      if (lastSessionDateStr != null) {
        lastSessionDate = DateTime.parse(lastSessionDateStr);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadSessionStats();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show dashboard if it's the first session
    if (isFirstSession) {
      return SizedBox.shrink();
    }

    return Container(
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
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDashboardItem("Sessions", totalSessions.toString(), FontAwesomeIcons.notesMedical),
          Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.2)),
          _buildDashboardItem("Exercise", exerciseCount.toString(), FontAwesomeIcons.leaf),
          Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.2)),
          _buildDashboardItem("Goals Met", "1", FontAwesomeIcons.circleCheck),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(String title, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF2A9D8F).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FaIcon(
            icon,
            color: Color(0xFF2A9D8F),
            size: 24,
          ),
        ),
        SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}
