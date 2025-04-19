import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/eleven_labs_service.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../models/session_report.dart';

// Update to use gemini-2.0-flash model
const String GEMINI_API_KEY = 'AIzaSyABB65jOTH78JDzI1FE9oijGwrB6BvBk9Y';
const String GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

class TalkToTheeraScreen extends StatefulWidget {
  const TalkToTheeraScreen({Key? key}) : super(key: key);

  @override
  _TalkToTheeraScreenState createState() => _TalkToTheeraScreenState();
}

class _TalkToTheeraScreenState extends State<TalkToTheeraScreen>
    with TickerProviderStateMixin {
  // UI state variables
  bool isListening = false;
  bool isSpeaking = false;
  bool isPaused = false;
  String currentText = 'Starting conversation...';
  String conversationHistory = '';
  
  // Speech recognition and TTS
  final SpeechToText _speechToText = SpeechToText();
  final ElevenLabsService _elevenLabs = ElevenLabsService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final NoiseMeter _noiseMeter = NoiseMeter();
  StreamSubscription<NoiseReading>? _noiseSubscription;
  
  // Animation controllers
  late AnimationController _controller;
  late AnimationController _waveformController;
  
  // Visual feedback variables
  double _soundLevel = 0.0;
  
  // Session variables
  int sessionCount = 0;
  String userName = "";
  bool isFirstSession = true;
  late SharedPreferences prefs;
  DateTime _sessionStartTime = DateTime.now();  // Initialize immediately
  
  // Speech recognition state
  bool _speechEnabled = false;
  bool _isInitialized = false;
  
  // Conversation state
  bool _isConversationActive = false;
  Timer? _silenceTimer;
  String _lastRecognizedText = '';
  bool _isProcessingResponse = false;
  
  // Add messages variable to store conversation history
  List<Map<String, dynamic>> messages = [];
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _waveformController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    // Initialize everything in sequence
    _initializeEverything();
  }

  Future<void> _initializeEverything() async {
    try {
      // First load session info
      await _loadSessionInfo();
      
      // Then initialize speech recognition
      await _initializeSpeech();
      
      // Then initialize TTS
      await _initializeTTS();
      
      // Finally start the conversation
      if (mounted) {
        _startConversation();
      }
    } catch (e) {
      print('Error during initialization: $e');
      if (mounted) {
        setState(() {
          currentText = 'Error initializing conversation';
        });
      }
    }
  }

  Future<void> _initializeSpeech() async {
    if (_isInitialized) return;
    
    try {
      bool available = await _speechToText.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          if (mounted) {
            setState(() {
              _speechEnabled = false;
              currentText = 'Speech recognition error';
            });
          }
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
          if (status == 'done' && mounted) {
            setState(() {
              isListening = false;
            });
          }
        },
      );
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _speechEnabled = available;
          if (!available) {
            currentText = 'Speech recognition not available';
          }
        });
        
        if (available) {
          await _requestPermissions();
        }
      }
    } catch (e) {
      print('Error initializing speech recognition: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _speechEnabled = false;
          currentText = 'Error initializing speech recognition';
        });
      }
    }
  }

  Future<void> _initializeTTS() async {
    try {
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isSpeaking = false;
            // Automatically resume listening after speaking
            if (_isConversationActive && !isPaused) {
              _startListening();
            }
          });
        }
      });
    } catch (e) {
      print('Error initializing TTS: $e');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      var status = await Permission.microphone.request();
      if (mounted) {
        if (status.isDenied) {
          setState(() {
            currentText = 'Microphone permission denied';
            _speechEnabled = false;
          });
        }
      }
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  Future<void> _loadSessionInfo() async {
    try {
      prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          isFirstSession = prefs.getBool('isFirstSession') ?? true;
          sessionCount = prefs.getInt('sessionCount') ?? 0;
          userName = prefs.getString('userName') ?? "";
        });
      }
    } catch (e) {
      print('Error loading session info: $e');
    }
  }

  void _startConversation() {
    if (!mounted || !_speechEnabled || !_isInitialized) {
      print('Cannot start conversation: mounted=$mounted, speechEnabled=$_speechEnabled, initialized=$_isInitialized');
      return;
    }
    
    setState(() {
      _isConversationActive = true;
      isPaused = false;
      currentText = 'Starting conversation...';
    });
    
    // Start with a more natural greeting
    String greeting = isFirstSession 
        ? "Namaste! I'm Thira, your AI therapist. I'm really looking forward to getting to know you. How are you feeling today?"
        : "Welcome back! It's good to see you again. How have you been since our last session?";
    
    _speakResponse(greeting).then((_) {
      // Ensure listening starts after greeting
      if (mounted && !isPaused && _isConversationActive) {
        _startListening();
      }
    });
  }

  Future<void> _startListening() async {
    if (!mounted || !_isConversationActive || isPaused) return;
    
    if (!_speechEnabled || !_isInitialized) {
      setState(() {
        currentText = 'Speech recognition not available';
      });
      return;
    }

    try {
      if (!isListening && !isSpeaking) {
        bool started = await _speechToText.listen(
          onResult: (result) {
            if (mounted && !isPaused) {
              setState(() {
                currentText = result.recognizedWords;
                _lastRecognizedText = result.recognizedWords;
              });
              
              // Reset silence timer when speech is detected
              _resetSilenceTimer();
              
              if (result.finalResult) {
                _processUserSpeech(result.recognizedWords);
              }
            }
          },
          listenFor: Duration(seconds: 20),
          pauseFor: Duration(seconds: 2),
          partialResults: true,
          cancelOnError: true,
          localeId: 'en_US',
        );
        
        if (mounted) {
          setState(() {
            isListening = started;
            isPaused = false;
            currentText = started ? 'Listening...' : 'Failed to start listening';
          });
          
          if (started) {
            _startNoiseMonitoring();
            _startSilenceTimer();
          }
        }
      }
    } catch (e) {
      print('Error starting speech recognition: $e');
      if (mounted) {
        setState(() {
          currentText = 'Error starting speech recognition';
          isListening = false;
        });
      }
    }
  }

  void _startSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(Duration(seconds: 1), () {  // Reduced to 1 second
      if (isListening && !isSpeaking && _lastRecognizedText.isNotEmpty) {
        _processUserSpeech(_lastRecognizedText);
      }
    });
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _startSilenceTimer();
  }

  void _stopListening() {
    if (!mounted) return;
    
    try {
      _speechToText.stop();
      _noiseSubscription?.cancel();
      _silenceTimer?.cancel();
      setState(() {
        isListening = false;
      });
    } catch (e) {
      print('Error stopping speech recognition: $e');
    }
  }

  void _startNoiseMonitoring() {
    try {
      // Create a stream controller for noise monitoring
      final streamController = StreamController<NoiseReading>();
      
      // Start noise monitoring
      _noiseMeter.noise.listen((NoiseReading noiseReading) {
        if (!streamController.isClosed) {
          streamController.add(noiseReading);
        }
      });
      
      // Listen to the stream
      _noiseSubscription = streamController.stream.listen((NoiseReading noiseReading) {
        if (mounted) {
          setState(() {
            _soundLevel = noiseReading.meanDecibel / 100;
          });
        }
      });
    } catch (e) {
      print('Error starting noise monitoring: $e');
    }
  }

  Future<String> _getGeminiResponse(String userMessage) async {
    try {
      String sessionContext = isFirstSession 
          ? "This is the user's first therapy session."
          : "This is session #$sessionCount with this user.";
      
      // Create conversation history with reduced context for faster processing
      String conversationHistory = "";
      int messageCount = messages.length;
      int contextSize = messageCount > 3 ? 3 : messageCount;  // Reduced to 3 messages for faster processing
      
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
1. Keep responses extremely concise (1-2 sentences max)
2. Show genuine care and empathy
3. Be extra vigilant about safety concerns
4. Ask only ONE question at a time
5. Focus on active listening and brief, supportive responses
6. Never use more than 30 words in your response
7. Prioritize speed over elaboration

$sessionContext

Previous conversation context (last 3 messages):
$conversationHistory

The person has just said: $userMessage

Respond as Theera, keeping responses extremely brief and focused:"""
          }]
        }],
        "generationConfig": {
          "temperature": 0.7,
          "maxOutputTokens": 50,  // Reduced token limit for faster responses
          "topP": 0.8,
          "topK": 40,
          "stopSequences": ["\n", ".", "?"]  // Stop at natural sentence boundaries
        }
      };
      
      // Start showing a loading indicator
      if (mounted) {
        setState(() {
          currentText = "Thinking...";
        });
      }
      
      final response = await http.post(
        Uri.parse('$GEMINI_API_URL?key=$GEMINI_API_KEY'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(Duration(seconds: 5));  // Reduced timeout for faster fallback

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        String responseText = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        
        // Clean up the response
        responseText = responseText.trim();
        if (responseText.endsWith(".") || responseText.endsWith("?")) {
          responseText = responseText.substring(0, responseText.length - 1);
        }
        
        return responseText;
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error with Gemini API: $e');
      return 'I\'m here to listen. Would you like to tell me more?';
    }
  }

  Future<void> _processUserSpeech(String speech) async {
    if (!mounted || _isProcessingResponse) return;
    
    _isProcessingResponse = true;
    _stopListening();
    
    try {
      // Handle empty input gracefully
      if (speech.trim().isEmpty) {
        setState(() {
          currentText = "It's okay to take your time. I'm here whenever you're ready to talk.";
        });
        await _speakResponse(currentText);
        _isProcessingResponse = false;
        
        // Continue listening
        if (mounted && !isPaused && _isConversationActive) {
          _startListening();
        }
        return;
      }
      
      // Update conversation history immediately
      setState(() {
        conversationHistory += "\nYou: $speech";
        currentText = "Processing...";
      });
      
      // Add message to history
      messages.add({
        'isUser': true,
        'message': speech,
      });
      
      // Start response generation in background
      String response = await _getGeminiResponse(speech);
      
      // Add AI response to messages
      messages.add({
        'isUser': false,
        'message': response,
      });
      
      // Update conversation history and UI
      if (mounted) {
        setState(() {
          conversationHistory += "\nTheera: $response";
          currentText = response;
        });
      }
      
      // Start speaking immediately
      await _speakResponse(response);
      
      _isProcessingResponse = false;
      
      // Ensure conversation continues
      if (mounted && !isPaused && _isConversationActive) {
        _startListening();
      }
    } catch (e) {
      print('Error processing speech: $e');
      if (mounted) {
        setState(() {
          currentText = 'I\'m here to listen. Would you like to tell me more?';
          _isProcessingResponse = false;
        });
        await _speakResponse(currentText);
        // Ensure conversation continues even after error
        if (!isPaused && _isConversationActive) {
          _startListening();
        }
      }
    }
  }

  Future<void> _speakResponse(String text) async {
    if (!mounted || isPaused) return;
    
    try {
      setState(() {
        isSpeaking = true;
        currentText = text;
      });
      
      try {
        final audioPath = await _elevenLabs.textToSpeech(text);
        await _audioPlayer.setFilePath(audioPath);
        
        if (!isPaused) {
          await _audioPlayer.play();
          
          // Wait for the audio to finish playing
          await _audioPlayer.playerStateStream.firstWhere(
            (state) => state.processingState == ProcessingState.completed
          );
        }
      } catch (e) {
        print('Error in text to speech: $e');
        // If TTS fails, continue without speaking
        // Wait a moment to simulate speaking time
        await Future.delayed(Duration(milliseconds: 500));
      }
      
      // Always continue the conversation after response
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
        
        // Start listening after speaking is complete (or after error)
        if (!isPaused && _isConversationActive) {
          _startListening();
        }
      }
    } catch (e) {
      print('Error in _speakResponse: $e');
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
        // Even if there's an error, try to continue the conversation
        if (!isPaused && _isConversationActive) {
          _startListening();
        }
      }
    }
  }

  void _togglePause() {
    if (isPaused) {
      setState(() {
        isPaused = false;
        currentText = 'Resuming conversation...';
      });
      
      if (isSpeaking) {
        _audioPlayer.play();
      } else {
        _startListening();
      }
      
      _startSilenceTimer();
    } else {
      setState(() {
        isPaused = true;
        currentText = 'Conversation paused';
      });
      
      if (isSpeaking) {
        _audioPlayer.pause();
      }
      
      _stopListening();
      _silenceTimer?.cancel();
    }
  }

  void _endConversation() {
    if (!mounted) return;
    
    // Calculate session duration
    final sessionDuration = DateTime.now().difference(_sessionStartTime).inMinutes;
    
    // Create a session report
    final report = SessionReport(
      date: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      summary: "Voice therapy session with Theera",
      sessionNumber: sessionCount + 1,
      duration: sessionDuration,
      topics: ["Voice Therapy"],
      therapist: "Theera",
    );
    
    // Save the session report
    _saveSessionReport(report);
    
    setState(() {
      _isConversationActive = false;
      isPaused = true;
      currentText = 'Conversation ended';
    });
    
    _stopListening();
    _audioPlayer.stop();
    
    // Show completion dialog and navigate back
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pop();
        _showSessionCompletionDialog(context);
      }
    });
  }

  Future<void> _saveSessionReport(SessionReport report) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> reportsJson = prefs.getStringList('sessionReports') ?? [];
      reportsJson.add(jsonEncode(report.toJson()));
      await prefs.setStringList('sessionReports', reportsJson);
    } catch (e) {
      print('Error saving session report: $e');
    }
  }

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
                Container(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    'assets/tick.json',
                    repeat: true,
                    animate: true,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Session Completed!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A9D8F),
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A9D8F),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _endConversation();
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF2A9D8F),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Back button
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                  onPressed: _endConversation,
                ),
              ),
              
              // Main content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status circle
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle with animation
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (_, child) {
                          return Container(
                            width: 280 + (_controller.value * 20),
                            height: 280 + (_controller.value * 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.95),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      // Waveform animation when listening or speaking
                      if (isListening || isSpeaking)
                        AnimatedBuilder(
                          animation: _waveformController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: Size(260, 260),
                              painter: WaveformPainter(
                                soundLevel: _soundLevel,
                                animationValue: _waveformController.value,
                              ),
                            );
                          },
                        ),
                      
                      // Inner content
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2A9D8F).withOpacity(0.1),
                        ),
                        child: Center(
                          child: FaIcon(
                            isListening 
                                ? FontAwesomeIcons.microphone
                                : (isSpeaking 
                                    ? FontAwesomeIcons.volumeHigh
                                    : (isPaused 
                                        ? FontAwesomeIcons.pause
                                        : FontAwesomeIcons.microphone)),
                            color: Color(0xFF2A9D8F),
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 60),
                  
                  // Status text
                  Text(
                    isPaused 
                        ? 'Paused' 
                        : (isSpeaking 
                            ? 'Speaking' 
                            : (isListening 
                                ? 'Listening...' 
                                : 'Ready to talk')),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  
                  SizedBox(height: 60),
                  
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: isPaused ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
                        onPressed: _togglePause,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 60),
                      _buildControlButton(
                        icon: FontAwesomeIcons.xmark,
                        onPressed: _endConversation,
                        color: Colors.red[300]!,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required double size,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(35),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FaIcon(
            icon,
            color: color,
            size: size,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stopListening();
    _controller.dispose();
    _waveformController.dispose();
    _audioPlayer.dispose();
    _silenceTimer?.cancel();
    super.dispose();
  }
}

// Custom painter for waveform animation
class WaveformPainter extends CustomPainter {
  final double soundLevel;
  final double animationValue;
  
  WaveformPainter({
    required this.soundLevel,
    required this.animationValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..color = Color(0xFF2A9D8F).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    // Draw multiple circles with varying opacity
    for (int i = 0; i < 4; i++) {
      final scale = 0.7 + (i * 0.1) + (soundLevel * 0.3);
      final opacity = 0.8 - (i * 0.15);
      
      paint.color = Color(0xFF2A9D8F).withOpacity(opacity);
      
      canvas.drawCircle(
        center,
        radius * scale,
        paint,
      );
    }
    
    // Draw waveform bars
    final barCount = 16;
    final barWidth = 4.0;
    final maxBarHeight = 40.0;
    
    for (int i = 0; i < barCount; i++) {
      final angle = (i / barCount) * 2 * 3.14159 + (animationValue * 2 * 3.14159);
      final x = center.dx + cos(angle) * (radius * 0.75);
      final y = center.dy + sin(angle) * (radius * 0.75);
      
      final barHeight = maxBarHeight * (0.4 + (soundLevel * 0.6) * sin(angle * 4 + animationValue * 12));
      
      final barPaint = Paint()
        ..color = Color(0xFF2A9D8F).withOpacity(0.8)
        ..style = PaintingStyle.fill;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, y),
            width: barWidth,
            height: barHeight,
          ),
          Radius.circular(barWidth / 2),
        ),
        barPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.soundLevel != soundLevel || 
           oldDelegate.animationValue != animationValue;
  }
}
