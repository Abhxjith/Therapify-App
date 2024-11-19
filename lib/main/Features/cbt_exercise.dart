import 'package:flutter/material.dart';

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
          title: Text('Incomplete Questionnaire'),
          content: Text('Please answer all questions before submitting.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Calculate scores and show results
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assessment Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for completing the assessment.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Your responses have been recorded. Please discuss these results with a qualified mental health professional for proper interpretation.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentPageIndex + 1) / questions.length,
              backgroundColor: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentPageIndex + 1} of ${questions.length}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    questions[_currentPageIndex]['category'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
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
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              questions[index]['question'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (questions[index]['helper'] != null) ...[
                              SizedBox(height: 8),
                              Text(
                                questions[index]['helper'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            SizedBox(height: 16),
                            ...List.generate(
                              questions[index]['answers'].length,
                              (answerIndex) {
                                return Card(
                                  elevation: 0,
                                  color: selectedAnswers[index] == answerIndex
                                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                                      : null,
                                  child: RadioListTile<int>(
                                    title: Text(
                                      questions[index]['answers'][answerIndex],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    value: answerIndex,
                                    groupValue: selectedAnswers[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswers[index] = value;
                                        if (index < questions.length - 1) {
                                          _pageController.nextPage(
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      });
                                    },
                                    activeColor: Theme.of(context).primaryColor,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPageIndex > 0)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back, size: 20),
                          SizedBox(width: 8),
                          Text('Previous'),
                        ],
                      ),
                    )
                  else
                    SizedBox.shrink(),
                  if (_currentPageIndex < questions.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Row(
                        children: [
                          Text('Next'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _submitAnswers,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          Text('Submit'),
                          SizedBox(width: 8),
                          Icon(Icons.check, size: 20),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}