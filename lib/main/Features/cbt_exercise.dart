import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapify/main/navbar.dart';
import 'package:therapify/main/home.dart';

class CBTTestPage extends StatefulWidget {
  @override
  _CBTTestPageState createState() => _CBTTestPageState();
}

class _CBTTestPageState extends State<CBTTestPage> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  
  // Initialize selectedAnswers immediately with the list
  late List<int?> selectedAnswers = List.filled(questions.length, null);

  // List of questions grouped by category
  final List<Map<String, dynamic>> questions = [
    // Emotional State
    {
      'category': 'Emotional State',
      'question': 'How often do you feel anxious or worried?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Consider your feelings over the past two weeks'
    },
    {
      'category': 'Emotional State',
      'question': 'How frequently do you feel overwhelmed by your emotions?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Think about your ability to manage your feelings'
    },
    {
      'category': 'Emotional State',
      'question': 'How often do you experience sudden mood changes?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Consider any unexpected shifts in your mood'
    },
    // Sleep & Energy
    {
      'category': 'Sleep & Energy',
      'question': 'Do you have trouble falling or staying asleep?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Think about your sleep patterns in the past week'
    },
    {
      'category': 'Sleep & Energy',
      'question': 'How often do you feel tired during the day?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Consider your energy levels throughout the day'
    },
    // Cognitive Function
    {
      'category': 'Cognitive Function',
      'question': 'How often do you have difficulty concentrating?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Think about your ability to focus on tasks'
    },
    {
      'category': 'Cognitive Function',
      'question': 'Do you find it hard to make decisions?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Consider both small and important decisions'
    },
    // Social Interactions
    {
      'category': 'Social Interactions',
      'question': 'How often do you avoid social situations?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Think about your comfort in social settings'
    },
    {
      'category': 'Social Interactions',
      'question': 'Do you feel disconnected from others?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Consider your relationships with friends and family'
    },
    // Physical Symptoms
    {
      'category': 'Physical Symptoms',
      'question': 'How often do you experience physical tension or pain?',
      'answers': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
      'helper': 'Consider headaches, muscle tension, or other physical discomfort'
    }
  ];

  @override
  void initState() {
    super.initState();
    // No need to initialize selectedAnswers here anymore since we did it above
  }

  void _submitAnswers() {
    if (selectedAnswers.contains(null)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Incomplete Assessment',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Please answer all questions before submitting.',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: GoogleFonts.inter(
                  color: Color(0xFF2A9D8F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Increment exercise count
    _incrementExerciseCount();
    
    // Show a brief success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assessment completed successfully!'),
        backgroundColor: Color(0xFF2A9D8F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navigate directly to home screen with navbar
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
        (route) => false,
      );
    });
  }

  Future<void> _incrementExerciseCount() async {
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('exerciseCount') ?? 0;
    await prefs.setInt('exerciseCount', currentCount + 1);
  }

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
          'CBT Assessment',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentPageIndex + 1} of ${questions.length}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A9D8F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        questions[_currentPageIndex]['category'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2A9D8F),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentPageIndex + 1) / questions.length,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2A9D8F)),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questions[index]['question'],
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      if (questions[index]['helper'] != null) ...[
                        SizedBox(height: 8),
                        Text(
                          questions[index]['helper'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                      SizedBox(height: 24),
                      ...List.generate(
                        questions[index]['answers'].length,
                        (answerIndex) {
                          final isSelected = selectedAnswers[index] == answerIndex;
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected 
                                    ? Color(0xFF2A9D8F) 
                                    : Colors.grey[200]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected
                                  ? Color(0xFF2A9D8F).withOpacity(0.1)
                                  : Colors.white,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setState(() {
                                  selectedAnswers[index] = answerIndex;
                                  if (index < questions.length - 1) {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected 
                                              ? Color(0xFF2A9D8F) 
                                              : Colors.grey[400]!,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? Color(0xFF2A9D8F)
                                            : Colors.white,
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      questions[index]['answers'][answerIndex],
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: isSelected
                                            ? Color(0xFF2A9D8F)
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPageIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Color(0xFF2A9D8F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.angleLeft,
                            size: 16,
                            color: Color(0xFF2A9D8F),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Previous',
                            style: GoogleFonts.inter(
                              color: Color(0xFF2A9D8F),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox.shrink(),
                if (_currentPageIndex < questions.length - 1)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: _currentPageIndex > 0 ? 12 : 0),
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2A9D8F),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            FaIcon(
                              FontAwesomeIcons.angleRight,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitAnswers,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2A9D8F),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Submit',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          FaIcon(
                            FontAwesomeIcons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}