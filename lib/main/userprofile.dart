import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapify/models/onboarding_form_data.dart';
import 'package:therapify/services/onboarding_form_service.dart';
import 'package:therapify/services/cbt_questions_service.dart';
import 'package:therapify/Login/login.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String userName = "User";
  String userEmail = "";
  int sessionCount = 0;
  Map<String, dynamic> cbtResponses = {};
  final OnboardingFormService _formService = OnboardingFormService();

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final formData = await _formService.getFormData();
    
    if (formData != null) {
      setState(() {
        userName = formData.name ?? "User";
        userEmail = formData.email ?? "";
        sessionCount = prefs.getInt('sessionCount') ?? 0;
        cbtResponses = formData.cbtResponses;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2A9D8F), Color(0xFF264653)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.user,
                                size: 40,
                                color: Color(0xFF2A9D8F),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            userName,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildInfoCard(
                            icon: FontAwesomeIcons.envelope,
                            label: 'Email',
                            value: userEmail,
                          ),
                          _buildInfoCard(
                            icon: FontAwesomeIcons.calendar,
                            label: 'Member Since',
                            value: 'March 2024',
                          ),
                          _buildInfoCard(
                            icon: FontAwesomeIcons.brain,
                            label: 'Therapy Sessions',
                            value: '$sessionCount sessions completed',
                          ),
                          SizedBox(height: 24),
                          _buildCBTInsights(),
                          SizedBox(height: 24),
                          _buildActionButton(
                            icon: FontAwesomeIcons.penToSquare,
                            label: 'Edit Profile',
                            onTap: () {
                              // Handle edit profile
                            },
                          ),
                          SizedBox(height: 12),
                          _buildActionButton(
                            icon: FontAwesomeIcons.gear,
                            label: 'Settings',
                            onTap: () {
                              // Handle settings
                            },
                            isSecondary: true,
                          ),
                          SizedBox(height: 12),
                          _buildActionButton(
                            icon: FontAwesomeIcons.rightFromBracket,
                            label: 'Logout',
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', false);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                                (route) => false,
                              );
                            },
                            isSecondary: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCBTInsights() {
    if (cbtResponses.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your CBT Insights',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        ...cbtResponses.entries.map((entry) {
          final question = CBTQuestionsService.getQuestions()
              .firstWhere((q) => q.id == entry.key);
          final responses = entry.value is List ? entry.value as List : [entry.value];
          
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF2A9D8F).withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                ...responses.map((response) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xFF2A9D8F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          response.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF2A9D8F).withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF2A9D8F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              icon,
              size: 16,
              color: Color(0xFF2A9D8F),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSecondary ? Colors.white : Color(0xFF2A9D8F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSecondary ? Color(0xFF2A9D8F) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 16,
                color: isSecondary ? Color(0xFF2A9D8F) : Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSecondary ? Color(0xFF2A9D8F) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
