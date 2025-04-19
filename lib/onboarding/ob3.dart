import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Center align content horizontally
        children: [
          Image.asset('assets/ob3.png'), // Ensure the image is in the assets folder
          SizedBox(height: 20),
          Text(
            "Anytime, Anywhere",
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ).copyWith(
              fontFamilyFallback: ['Inter'], // Fall back to Inter if Lato is not available
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Share your thoughts, feelings, and experiences with a non-judgmental companion.",
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.grey[600],
            ).copyWith(
              fontFamilyFallback: ['Inter'], // Fall back to Inter if Lato is not available
            ),
          ),
        ],
      ),
    );
  }
}
