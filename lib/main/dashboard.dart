import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Set the container's background color to white
        borderRadius: BorderRadius.circular(16), // Rounded edges with a radius of 16
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Shadow color
            blurRadius: 2, // Spread of the shadow
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      padding: EdgeInsets.all(16), // Add some padding for better spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDashboardItem("   Sessions", "5", FontAwesomeIcons.solidClipboard),
          _buildDashboardItem("Exercise", "2", FontAwesomeIcons.spa),
          _buildDashboardItem("Goals Met", "1", FontAwesomeIcons.checkCircle),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(String title, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: Colors.teal, size: 36),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
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
