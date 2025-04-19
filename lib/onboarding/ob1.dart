import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Center align content horizontally
        children: [
          Image.asset('assets/ob1.png'), // Ensure the image is in the assets folder
          SizedBox(height: 20),
          Text(
            "Therapify",
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ).copyWith(
              fontFamilyFallback: ['Inter'], // Fall back to Inter if Lato is not available
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Discover a new way to care for your mental well-being with our AI-powered therapist.",
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
