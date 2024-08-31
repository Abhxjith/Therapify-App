import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therapy App',
      theme: appTheme,
      home: HomePage(),
    );
  }
}

final ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF269D9D),
  primarySwatch: MaterialColor(
    0xFF269D9D,
    <int, Color>{
      50: Color(0xFFE0F7F7),
      100: Color(0xFFB3ECEC),
      200: Color(0xFF80E0E0),
      300: Color(0xFF4DD4D4),
      400: Color(0xFF26C9C9),
      500: Color(0xFF269D9D),
      600: Color(0xFF238E8E),
      700: Color(0xFF1F7C7C),
      800: Color(0xFF1A6A6A),
      900: Color(0xFF134F4F),
    },
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.interTextTheme(),  // Using Inter font
);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hey,', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What Happened?",
                style: TextStyle(
                  color: appTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFE0F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.tips_and_updates, color: appTheme.primaryColor, size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Tips by Doctor X",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFB3ECEC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "Swipe to start your session",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildOptionCard(Icons.chat_bubble, "Talk with Theera"),
                  _buildOptionCard(Icons.chat, "Chat with Theera"),
                ],
              ),
              SizedBox(height: 24),
              Text(
                "Nearby Therapists",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTherapistCard(),
                  _buildTherapistCard(),
                  _buildTherapistCard(),
                  _buildTherapistCard(),
                ],
              ),
              SizedBox(height: 24),
              Text(
                "How do you feel today?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.emoji_emotions,
                    color: index == 4 ? Colors.red : Colors.yellow,
                    size: 36,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(IconData icon, String title) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: appTheme.primaryColor, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTherapistCard() {
    return CircleAvatar(
      radius: 32,
      backgroundColor: Color(0xFF80E0E0),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage('assets/therapist.jpg'),
      ),
    );
  }
}
