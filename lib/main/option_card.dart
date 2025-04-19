import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  OptionCard({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150, // Increased width for a rectangular look
        height: 50, // Added height for a rectangular look
        padding: EdgeInsets.symmetric(horizontal: 11, vertical: 15),
        decoration: BoxDecoration(
          color: Color(0xFF4DB6AC), // Updated background color for a professional look
          borderRadius: BorderRadius.circular(10), // Slightly more rounded corners
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black26, // Subtle shadow for depth
        //       offset: Offset(0, 4),
        //       blurRadius: 8,
        //     ),
        //   ],
        ),
        child: Row( // Changed to Row to align icon and text horizontally
          mainAxisAlignment: MainAxisAlignment.center, // Centered content
          children: [
            FaIcon(icon, color: Colors.white, size: 20), // Slightly larger icon
            SizedBox(width: 10), // Increased space between icon and text
            Expanded( // Expands to fill remaining space
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600, // Bolder font for title
                  fontSize: 15, // Larger font size
                  overflow: TextOverflow.ellipsis, // Handles long text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
