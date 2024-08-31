import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Center align content horizontally
        children: [
          Image.asset('assets/ob2.png'), // Ensure the image is in the assets folder
          SizedBox(height: 20),
          Text(
            "Your Mental Health is a Priority",
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ).copyWith(
              fontFamilyFallback: ['Inter'], // Fall back to Inter if Lato is not available
            ),
            textAlign: TextAlign.center, // Center align text
          ),
          SizedBox(height: 10),
          Text(
            "Streamlining data collection and analysis in clinical settings, improving efficiency and accuracy.",
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
