import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:therapify/models/session_report.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

// Update to use gemini-2.0-flash model
const String GEMINI_API_KEY = 'AIzaSyABB65jOTH78JDzI1FE9oijGwrB6BvBk9Y';
const String GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

// Add these constants at the top
const EMERGENCY_CONTACT = '+917738925429';
const HIGH_RISK_KEYWORDS = [
  'kill myself', 'suicide', 'end my life', 'want to die', 
  'better off dead', 'no reason to live', 'can\'t go on',
  'hurt myself', 'end it all', 'goodbye forever', 'i am ending it all', 'kms',
  'bye forever', 'final goodbye', 'this is the end', 'ending everything',
  'last message', 'won\'t be here', 'don\'t want to live', 'going to end',
  'bye bye forever', 'no point living', 'time to go forever'
];

class ChatWithTheeraScreen extends StatefulWidget {
  @override
  _ChatWithTheeraScreenState createState() => _ChatWithTheeraScreenState();
}

class _ChatWithTheeraScreenState extends State<ChatWithTheeraScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> messages = [];
  
  // Add variables for session tracking
  int sessionCount = 0;
  String userName = "";
  Map<String, dynamic> userInfo = {};
  bool isFirstSession = true;
  
  // Add SharedPreferences for persistence
  late SharedPreferences prefs;

  // Add session reports list
  List<Map<String, dynamic>> sessionReports = [];

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Add these variables to the class
  Timer? _inactivityTimer;
  bool _waitingForUserResponse = false;

  // Add this variable to track session progress
  int _sessionProgress = 0;
  bool _concludingSession = false;

  // Add these variables to track session time
  DateTime _sessionStartTime = DateTime.now();
  Timer? _sessionTimeoutTimer;

  // Add these variables to track session topics
  List<String> _sessionTopics = [];

  // Add these variables to track session context
  String _previousSessionContext = "";
  String _currentSessionContext = "";
  List<String> _sessionContexts = [];

  // Function to call Gemini API
  Future<String> _getGeminiResponse(String userMessage) async {
    try {
      String sessionContext = isFirstSession 
          ? "This is the user's first therapy session."
          : "This is session #$sessionCount with this user.";
      
      // Add previous session context if available
      String contextInfo = "";
      if (_previousSessionContext.isNotEmpty) {
        contextInfo = "\nPrevious session context: $_previousSessionContext";
      }
      
      // Create conversation history with more context
      String conversationHistory = "";
      int messageCount = messages.length;
      int contextSize = messageCount > 15 ? 15 : messageCount; // Increased context window
      
      for (int i = messageCount - contextSize; i < messageCount; i++) {
        if (i >= 0) {
          String role = messages[i]['isUser'] ? "User" : "Therapist";
          conversationHistory += "$role: ${messages[i]['message']}\n";
        }
      }

      final requestBody = {
        "contents": [{
          "parts":[{
            "text": """You are Theera, a warm and empathetic Indian therapist with 20 years of experience.

IMPORTANT GUIDELINES:
1. Respond exactly like a real human therapist would in a text message conversation
2. Keep messages conversational and natural
3. Show genuine care and empathy
4. Be extra vigilant about safety concerns
5. Ask only ONE question at a time and wait for the user's response
6. Keep responses focused and concise
7. Reference previous context naturally without explicitly mentioning it
8. Build upon previous responses to maintain conversation flow

$sessionContext$contextInfo

Previous conversation context:
$conversationHistory

The person has just said: $userMessage

Respond as Theera, keeping in mind all safety guidelines and ensuring you only ask one question at a time:"""
          }]
        }]
      };
      
      final response = await http.post(
        Uri.parse('$GEMINI_API_URL?key=$GEMINI_API_KEY'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error with Gemini API: $e');
      return 'I\'m here to listen. Would you like to tell me more about what\'s on your mind?';
    }
  }

  // Update the _sendMessage method to handle the session end marker
  Future<void> _sendMessage() async {
    _inactivityTimer?.cancel();
    _waitingForUserResponse = false;
    
    String userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"isUser": true, "message": userMessage});
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Get response from Gemini
      String responseMessage = await _getGeminiResponse(userMessage);
      
      // Check for session conclusion before processing the message
      bool shouldEndSession = responseMessage.contains("END_SESSION_SAFELY:");
      
      // Remove the end session marker from the message
      responseMessage = responseMessage.replaceAll("END_SESSION_SAFELY:", "").trim();
      
      // Split response into natural paragraphs
      List<String> messageParts = responseMessage
          .split(RegExp(r'(?<=[\.\?\!])\s+(?=[A-Z])'))
          .where((part) => part.trim().isNotEmpty)
          .toList();

      // Process each message part with natural typing delays
      for (int i = 0; i < messageParts.length; i++) {
        String part = messageParts[i].trim();
        
        setState(() {
          messages.removeWhere((message) => message['isTyping'] == true);
          messages.add({"isUser": false, "message": "typing...", "isTyping": true});
        });
        _scrollToBottom();

        await _simulateNaturalTypingTime(part);

        setState(() {
          messages.removeWhere((message) => message['isTyping'] == true);
          messages.add({"isUser": false, "message": part});
        });
        _scrollToBottom();

        if (i < messageParts.length - 1) {
          await Future.delayed(Duration(milliseconds: 800));
        }
      }

      // Handle session ending if needed
      if (shouldEndSession) {
        // Calculate session duration
        final sessionDuration = DateTime.now().difference(_sessionStartTime).inMinutes;
        
        // Extract topics from the conversation
        _extractTopicsFromConversation();
        
        // Generate a summary of the session
        String summary = await _generateSessionSummary();
        
        // Create a session report
        final report = SessionReport(
          date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          summary: summary,
          sessionNumber: sessionCount + 1,
          duration: sessionDuration,
          topics: _sessionTopics,
          therapist: "Theera",
        );
        
        // Save the session report
        await _saveSessionReport(report);
        
        // Save session information
        await _saveSessionInfo();
        
        // Increment session count
        _incrementSessionCount();
        
        // Show completion dialog and navigate back
        Future.delayed(Duration(seconds: 4), () {
          if (mounted) {
            Navigator.pop(context);
            _showSessionCompletionDialog(context);
          }
        });
      }

      _startInactivityTimer();
    } catch (e) {
      setState(() {
        messages.removeWhere((message) => message['isTyping'] == true);
        messages.add({
          "isUser": false,
          "message": "I'm here to listen. Would you like to tell me more about what's on your mind?"
        });
      });
      _scrollToBottom();
    }
  }

  // Add a more sophisticated typing time simulation
  Future<void> _simulateNaturalTypingTime(String message) async {
    // Base typing speed (characters per minute)
    const baseSpeed = 300;
    
    // Calculate base time needed
    int charCount = message.length;
    
    // Add thinking time for complex messages
    int thinkingTime = 0;
    if (message.contains("?")) thinkingTime += 500; // Questions need thought
    if (message.contains(",")) thinkingTime += 300; // Complex sentences
    if (message.length > 100) thinkingTime += 800; // Long messages
    
    // Calculate typing time in milliseconds
    int typingTime = (charCount * 60000 ~/ baseSpeed) + thinkingTime;
    
    // Add some natural variation (±20%)
    final random = Random();
    double variation = 0.8 + (random.nextDouble() * 0.4); // 0.8 to 1.2
    typingTime = (typingTime * variation).toInt();
    
    // Clamp to reasonable limits
    int finalTime = typingTime.clamp(800, 4000);
    
    await Future.delayed(Duration(milliseconds: finalTime));
  }

  // Add this method to simulate typing time based on message length
  Future<void> _simulateTypingTime(String message) async {
    // Calculate a reasonable typing time based on message length
    // Average person types about 40 words per minute, or ~200 characters per minute
    // So we'll use 200 chars per minute as a baseline
    final int charCount = message.length;
    final int baseTimeMs = 1000; // Minimum time to show typing indicator
    final int typingTimeMs = baseTimeMs + (charCount * 60000 ~/ 200);
    
    // Cap the maximum typing time at 5 seconds to keep the app responsive
    final int cappedTimeMs = typingTimeMs.clamp(1000, 5000);
    
    await Future.delayed(Duration(milliseconds: cappedTimeMs));
  }

  // Add this method to handle user inactivity
  void _startInactivityTimer() {
    // Cancel any existing timer
    _inactivityTimer?.cancel();
    
    // Set waiting flag
    _waitingForUserResponse = true;
    
    // Start a new timer
    _inactivityTimer = Timer(Duration(seconds: 40), () {
      if (_waitingForUserResponse && mounted) {
        // Send a gentle prompt if the user hasn't responded
        setState(() {
          messages.add({
            "isUser": false, 
            "message": "Are you still there? Feel free to take your time. I'm here whenever you're ready to continue our conversation."
          });
        });
        _scrollToBottom();
        
        // Start another timer for a follow-up message if needed
        _inactivityTimer = Timer(Duration(seconds: 40), () {
          if (_waitingForUserResponse && mounted) {
            setState(() {
              messages.add({
                "isUser": false, 
                "message": "No pressure at all. Whenever you're comfortable sharing, I'm here to listen."
              });
            });
            _scrollToBottom();
          }
        });
      }
    });
  }

  // Save session information for continuity
  Future<void> _saveSessionInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Generate current session context
      _currentSessionContext = await _generateSessionContext();
      
      // Add to contexts list
      _sessionContexts.add(_currentSessionContext);
      
      // Save all contexts
      await prefs.setStringList('sessionContexts', _sessionContexts);
      
      // Save other session info
      await prefs.setInt('sessionCount', sessionCount + 1);
      await prefs.setBool('isFirstSession', false);
      if (userName.isNotEmpty) {
        await prefs.setString('userName', userName);
      }
      
      print('Saved session info: count=${sessionCount + 1}, context=$_currentSessionContext'); // Debug log
    } catch (e) {
      print('Error saving session info: $e');
    }
  }

  // Helper method to extract name
  String _extractName(String message, int startIndex) {
    if (startIndex >= message.length) return "";
    
    // Skip spaces after the phrase
    while (startIndex < message.length && message[startIndex] == ' ') {
      startIndex++;
    }
    
    // Extract the name (first word after the phrase)
    String name = "";
    while (startIndex < message.length && message[startIndex] != ' ' && 
           message[startIndex] != '.' && message[startIndex] != ',' && 
           message[startIndex] != '!') {
      name += message[startIndex];
      startIndex++;
    }
    
    // Capitalize first letter
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1);
    }
    
    return name;
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(String message, bool isUser, {bool isTyping = false}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUser ? Color(0xFF269D9D) : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isUser ? Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : Radius.circular(16),
          ),
        ),
        child: isTyping
            ? SizedBox(
                width: 40,
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => _buildDot(),
                  ),
                ),
              )
            : Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Icon(
        FontAwesomeIcons.arrowLeft,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSessionCount();
    _loadSessionReports();
    _initializeChat();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _sessionTimeoutTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF269D9D),
        title: Text(
          '',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        leading: _buildBackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageBubble(
                    message["message"],
                    message["isUser"],
                    isTyping: message['isTyping'] ?? false,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF269D9D),
                    radius: 25,
                    child: FaIcon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.white,
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

  // Update the _initializeChat method to load previous context
  Future<void> _initializeChat() async {
    // Initialize SharedPreferences
    prefs = await SharedPreferences.getInstance();
    
    isFirstSession = prefs.getBool('isFirstSession') ?? true;
    sessionCount = prefs.getInt('sessionCount') ?? 0;
    userName = prefs.getString('userName') ?? "";
    
    // Load previous session context
    _sessionContexts = prefs.getStringList('sessionContexts') ?? [];
    if (_sessionContexts.isNotEmpty) {
      _previousSessionContext = _sessionContexts.last;
    }
    
    _sessionStartTime = DateTime.now();
    _startSessionTimeoutTimer();

    if (isFirstSession) {
      // Send messages one by one, waiting for each to complete
      await _addTherapistMessage("Hi there! I'm Theera, your AI therapy assistant.");
      await _addTherapistMessage("I'm here to provide a safe space for you to talk about whatever's on your mind.");
      await _addTherapistMessage("Before we begin, could you tell me your name and a little bit about what brought you here today?");
    } else {
      // Send returning user messages with context
      if (userName.isNotEmpty) {
        await _addTherapistMessage("Welcome back, $userName! It's good to see you again.");
      } else {
        await _addTherapistMessage("Welcome back! It's good to see you again.");
      }
      
      // Add follow-up based on previous session
      if (_previousSessionContext.isNotEmpty) {
        await _addTherapistMessage("In our last session, we discussed: $_previousSessionContext");
        await _addTherapistMessage("How have things been since then?");
      } else {
        await _addTherapistMessage("How have you been since our last conversation?");
      }
    }
    
    _startInactivityTimer();
  }

  // Add this helper method to handle adding therapist messages
  Future<void> _addTherapistMessage(String message) async {
    setState(() {
      messages.add({"isUser": false, "message": "typing...", "isTyping": true});
    });
    _scrollToBottom();

    await _simulateNaturalTypingTime(message);

    setState(() {
      messages.removeWhere((message) => message['isTyping'] == true);
      messages.add({"isUser": false, "message": message});
    });
    _scrollToBottom();

    // Add a small pause between multiple messages
    await Future.delayed(Duration(milliseconds: 800));
  }

  // Add this method to show the session completion dialog
  void _showSessionCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie animation
                Container(
                  height: 200,
                  width: 200,
                  child: _buildLottieAnimation(),
                ),
                SizedBox(height: 15),
                Text(
                  "Session Completed!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF269D9D),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  isFirstSession 
                      ? "Congratulations on completing your first therapy session!"
                      : "Great job on completing another therapy session!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 20),
                // Text(
                //   "Your journey to better mental health continues...",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontStyle: FontStyle.italic,
                //     color: Colors.grey[600],
                //   ),
                // ),
                SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF269D9D),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Let's Go!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Update the Lottie animation method to use the local tick.json file
  Widget _buildLottieAnimation() {
    if (kIsWeb) {
      // Use HtmlElementView on web with the specific URL
      return Container(
        width: 200,
        height: 200,
        child: const HtmlElementView(
          viewType: 'lottie-animation',
        ),
      );
    } else {
      // For mobile, use the local tick.json file
      try {
        return Lottie.asset(
          'assets/tick.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          repeat: true,
          animate: true,
        );
      } catch (e) {
        print('Error loading Lottie animation: $e');
        // Fallback to a simple animation using Flutter widgets
        return _buildFallbackAnimation();
      }
    }
  }

  // Update the fallback animation method
  Widget _buildFallbackAnimation() {
    // Create a proper animation controller
    final AnimationController controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();
    
    // Make sure to dispose the controller when the widget is disposed
    // by adding it to the State's disposables
    
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE8F5E9),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Icon(
              Icons.check_circle,
              color: Color(0xFF269D9D),
              size: 100,
            );
          },
        ),
      ),
    );
  }

  // Add method to start session timeout timer
  void _startSessionTimeoutTimer() {
    // Cancel any existing timer
    _sessionTimeoutTimer?.cancel();
    
    // Start a new timer for 15 minutes
    _sessionTimeoutTimer = Timer(Duration(minutes: 15), () {
      if (mounted && !_concludingSession) {
        _initiateSessionConclusion();
      }
    });
  }

  // Add method to initiate session conclusion
  void _initiateSessionConclusion() {
    if (_concludingSession) return; // Already concluding
    
    _concludingSession = true;
    
    setState(() {
      messages.add({
        "isUser": false,
        "message": "We've been talking for a while now. How are you feeling about our conversation today? Would you like to wrap up for now?"
      });
    });
    _scrollToBottom();
  }

  // Method to extract topics from conversation
  void _extractTopicsFromConversation() {
    _sessionTopics = [];
    Set<String> topicsSet = {};
    
    // Extract potential topics from user messages
    for (var message in messages) {
      if (message['isUser'] == true) {
        String msg = message['message'].toString().toLowerCase();
        
        // Look for common therapy topics in messages
        if (msg.contains('anxiet') || msg.contains('worry') || msg.contains('stress')) {
          topicsSet.add('Anxiety');
        }
        if (msg.contains('depress') || msg.contains('sad') || msg.contains('low mood')) {
          topicsSet.add('Depression');
        }
        if (msg.contains('sleep') || msg.contains('insomnia') || msg.contains('tired')) {
          topicsSet.add('Sleep Issues');
        }
        if (msg.contains('relation') || msg.contains('partner') || msg.contains('marriage')) {
          topicsSet.add('Relationships');
        }
        if (msg.contains('work') || msg.contains('job') || msg.contains('career')) {
          topicsSet.add('Work Stress');
        }
        if (msg.contains('family') || msg.contains('parent') || msg.contains('child')) {
          topicsSet.add('Family');
        }
      }
    }
    
    // If no specific topics were found, add a general one
    if (topicsSet.isEmpty) {
      topicsSet.add('General Wellbeing');
    }
    
    _sessionTopics = topicsSet.toList();
  }

  // Method to generate a concise session summary using Gemini
  Future<String> _generateSessionSummary() async {
    try {
      // Create a condensed version of the conversation for the AI
      String conversationText = "";
      for (var message in messages) {
        String role = message['isUser'] == true ? "User" : "Therapist";
        conversationText += "$role: ${message['message']}\n";
      }
      
      // Prompt for Gemini to generate a concise summary
      String prompt = """
      Based on the following therapy conversation, write a VERY CONCISE summary (maximum 75 words) 
      that captures the essential points discussed. This summary will be used as context for future 
      therapy sessions, so focus on:
      1. Key issues or concerns the patient mentioned
      2. Any insights or breakthroughs
      3. Specific coping strategies or action items discussed
      4. The patient's emotional state
      
      Be precise and factual. Avoid general statements. Do not include any greeting or sign-off.
      
      Conversation:
      $conversationText
      """;
      
      // Call Gemini API
      final response = await http.post(
        Uri.parse('$GEMINI_API_URL?key=$GEMINI_API_KEY'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.1,
            'maxOutputTokens': 150,
          },
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String summary = data['candidates'][0]['content']['parts'][0]['text'];
        return summary.trim();
      } else {
        print('Error generating summary: ${response.statusCode}');
        return "Patient discussed personal challenges and explored potential coping strategies. Key emotions included anxiety and uncertainty. We identified specific triggers and discussed practical steps for managing stress in daily situations.";
      }
    } catch (e) {
      print('Error in summary generation: $e');
      return "Patient discussed personal challenges and explored potential coping strategies. Key emotions included anxiety and uncertainty. We identified specific triggers and discussed practical steps for managing stress in daily situations.";
    }
  }

  // Method to save the session report
  Future<void> _saveSessionReport(SessionReport report) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> reportsJson = prefs.getStringList('sessionReports') ?? [];
      reportsJson.add(jsonEncode(report.toJson()));
      await prefs.setStringList('sessionReports', reportsJson);
      print('Saved session report: ${report.toJson()}'); // Debug log
    } catch (e) {
      print('Error saving session report: $e');
    }
  }

  // Update the _getPreviousSessionContext method to remove the reference to _checkForSessionConclusion
  Future<String> _getPreviousSessionContext() async {
    try {
      // Get existing reports
      List<String> reportsJson = prefs.getStringList('sessionReports') ?? [];
      
      if (reportsJson.isEmpty) {
        return ""; // No previous sessions
      }
      
      // Get the most recent session report
      final reportMap = jsonDecode(reportsJson.last);
      final lastReport = SessionReport.fromJson(reportMap);
      
      // Create context from the last session
      return """
In your previous session (Session #${lastReport.sessionNumber}), you discussed:
- Topics: ${lastReport.topics.join(', ')}
- Summary: ${lastReport.summary}

Remember this context, but don't explicitly mention "your previous session" unless the user brings it up first. Instead, naturally reference relevant points from the previous session when appropriate during the conversation.
""";
    } catch (e) {
      print('Error getting previous session context: $e');
      return "";
    }
  }

  // Update the suicide risk check method to use both keyword matching and Gemini
  Future<bool> _checkSuicideRisk(String message) async {
    // First do quick keyword check
    String lowercaseMsg = message.toLowerCase();
    bool keywordMatch = HIGH_RISK_KEYWORDS.any((keyword) => lowercaseMsg.contains(keyword));
    
    // If keywords found, immediately return true
    if (keywordMatch) return true;
    
    // Otherwise, use Gemini for more nuanced detection
    try {
      String prompt = """
      Analyze this message for suicide risk. Consider both explicit and implicit signs of:
      1. Suicidal ideation
      2. Self-harm intentions
      3. Severe hopelessness
      4. Goodbye messages
      5. Plans to end their life
      6. Giving away possessions
      7. Extreme feelings of worthlessness

      Respond ONLY with "HIGH_RISK" if you detect serious suicide risk, or "LOW_RISK" if not.
      Do not explain your reasoning, just respond with one of those two options.

      Message to analyze: "$message"
      """;

      final response = await http.post(
        Uri.parse('$GEMINI_API_URL?key=$GEMINI_API_KEY'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }],
          'generationConfig': {
            'temperature': 0.1,
            'maxOutputTokens': 10,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String analysis = data['candidates'][0]['content']['parts'][0]['text'].trim();
        return analysis == "HIGH_RISK";
      }
    } catch (e) {
      print('Error in Gemini suicide risk analysis: $e');
    }
    
    // If Gemini call fails, fall back to keyword match result
    return keywordMatch;
  }

  // Update the handleUserMessage method to use the new session ending logic
  void _handleUserMessage(String message) async {
    setState(() {
      messages.add({
        "isUser": true,
        "message": message
      });
      _messageController.clear();
    });
    _scrollToBottom();

    try {
      setState(() {
        messages.add({"isUser": false, "message": "typing...", "isTyping": true});
      });
      _scrollToBottom();

      String response = await _getGeminiResponse(message);
      
      // Check for session conclusion before processing the message
      bool shouldEndSession = response.contains("END_SESSION_SAFELY:");
      
      // Remove the end session marker from the message
      response = response.replaceAll("END_SESSION_SAFELY:", "").trim();

      setState(() {
        messages.removeWhere((message) => message['isTyping'] == true);
        messages.add({
          "isUser": false,
          "message": response
        });
      });
      _scrollToBottom();

      // Handle session ending if needed
      if (shouldEndSession) {
        _saveSessionInfo();
        Future.delayed(Duration(seconds: 4), () {
          if (mounted) {
            Navigator.pop(context);
            _showSessionCompletionDialog(context);
          }
        });
      }

      _startInactivityTimer();
    } catch (e) {
      setState(() {
        messages.removeWhere((message) => message['isTyping'] == true);
        messages.add({
          "isUser": false,
          "message": "I'm here to listen. Would you like to tell me more about what's on your mind?"
        });
      });
      _scrollToBottom();
    }
  }

  // Add this method to handle emergency situations
  void _handleEmergencySituation() {
    // Immediately make the emergency call
    if (Platform.isAndroid || Platform.isIOS) {
      _makeEmergencyCall();
    }

    // Show crisis dialog
    _showCrisisResourcesDialog();

    // Add supportive messages
    setState(() {
      messages.add({
        "isUser": false,
        "message": "I'm very concerned about your safety right now. I'm connecting you with emergency support immediately.",
        "isEmergency": true
      });
    });
    _scrollToBottom();

    // Add follow-up message after a short delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          messages.add({
            "isUser": false,
            "message": "Please stay on the line - help is on the way. Your life is valuable and there are people who want to help.",
            "isEmergency": true
          });
        });
        _scrollToBottom();
      }
    });
  }

  // Add method to make emergency call
  void _makeEmergencyCall() async {
    final Uri url = Uri.parse('tel:$EMERGENCY_CONTACT');
    try {
      await launchUrl(url);
    } catch (e) {
      print('Error making emergency call: $e');
    }
  }

  // Add crisis resources dialog
  void _showCrisisResourcesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Emergency Support',
            style: TextStyle(color: Colors.red),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('We\'re connecting you with emergency support.'),
              SizedBox(height: 16),
              Text('Emergency Contact: $EMERGENCY_CONTACT'),
              SizedBox(height: 16),
              Text('Please don\'t leave - help is on the way.'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Call Now'),
              onPressed: _makeEmergencyCall,
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionCount = prefs.getInt('sessionCount') ?? 0;
      print('Loaded session count: $sessionCount'); // Debug log
    });
  }

  Future<void> _loadSessionReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList('sessionReports') ?? [];
    print('Loaded session reports: $reportsJson'); // Debug log
    
    List<SessionReport> reports = [];
    for (var reportJson in reportsJson) {
      try {
        final reportMap = jsonDecode(reportJson);
        reports.add(SessionReport.fromJson(reportMap));
      } catch (e) {
        print('Error parsing report: $e');
      }
    }
    
    setState(() {
      sessionReports = reports.map((report) => report.toJson()).toList();
    });
  }

  Future<void> _saveSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sessionCount', sessionCount);
    print('Saved session count: $sessionCount'); // Debug log
  }

  Future<void> _saveSessionReports() async {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = sessionReports.map((report) => jsonEncode(report)).toList();
    await prefs.setStringList('sessionReports', reportsJson);
    print('Saved session reports: $reportsJson'); // Debug log
  }

  void _incrementSessionCount() {
    setState(() {
      sessionCount++;
      _saveSessionCount();
    });
  }

  // Add method to generate session context
  Future<String> _generateSessionContext() async {
    try {
      // Create a condensed version of the conversation for the AI
      String conversationText = "";
      for (var message in messages) {
        String role = message['isUser'] == true ? "User" : "Therapist";
        conversationText += "$role: ${message['message']}\n";
      }
      
      // Prompt for Gemini to generate a concise context
      String prompt = """
      Based on the following therapy conversation, write a VERY CONCISE summary (maximum 50 words) 
      that captures the essential points discussed. This summary will be used as context for future 
      therapy sessions, so focus on:
      1. Key issues or concerns the patient mentioned
      2. Any insights or breakthroughs
      3. Specific coping strategies or action items discussed
      4. The patient's emotional state
      
      Be precise and factual. Avoid general statements. Do not include any greeting or sign-off.
      Format the summary as a single paragraph.
      
      Conversation:
      $conversationText
      """;
      
      // Call Gemini API
      final response = await http.post(
        Uri.parse('$GEMINI_API_URL?key=$GEMINI_API_KEY'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.1,
            'maxOutputTokens': 100,
          },
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String context = data['candidates'][0]['content']['parts'][0]['text'];
        return context.trim();
      } else {
        print('Error generating context: ${response.statusCode}');
        return "Patient discussed personal challenges and explored potential coping strategies. Key emotions included anxiety and uncertainty. We identified specific triggers and discussed practical steps for managing stress.";
      }
    } catch (e) {
      print('Error in context generation: $e');
      return "Patient discussed personal challenges and explored potential coping strategies. Key emotions included anxiety and uncertainty. We identified specific triggers and discussed practical steps for managing stress.";
    }
  }
}