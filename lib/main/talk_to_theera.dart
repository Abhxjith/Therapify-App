import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TalkToTheeraScreen extends StatefulWidget {
  @override
  _TalkToTheeraScreenState createState() => _TalkToTheeraScreenState();
}

class _TalkToTheeraScreenState extends State<TalkToTheeraScreen>
    with SingleTickerProviderStateMixin {
  final String apiKey = 'AIzaSyANL6EVg3e7yuJmBV70m8v_LwKgyohx_h8'; // Change this
  late GenerativeModel model;
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool isListening = true;
  bool isPaused = false;
  bool isSpeaking = false;
  String? lastResponse;
  String currentText = '';
  
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    
    _initTts();
    listenAndRespond();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
      if (isListening && !isPaused) {
        Future.delayed(Duration(seconds: 2), listenAndRespond);
      }
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $msg")),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> listenAndRespond() async {
    if (isSpeaking || isPaused) return;

    // Capture user input here (could be from a voice input or button press)

    try {
      final content = [
        Content.text(
          'You are Theera, a friendly AI therapist. Give brief responses (1-2 sentences).' +
          (lastResponse != null ? ' Previous response: $lastResponse' : '')
        )
      ];

      final response = await model.generateContent(content);
      final responseText = response.text;

      if (responseText != null && !isPaused && mounted) {
        setState(() {
          lastResponse = responseText;
          currentText = responseText;
        });
        await flutterTts.speak(responseText);
      }
    } catch (e) {
      print('Error communicating with Gemini API: $e');
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void pauseListening() async {
    if (isPaused) {
      if (currentText.isNotEmpty && !isSpeaking) {
        setState(() {
          isPaused = false;
        });
        await flutterTts.speak(currentText);
      }
    } else {
      await flutterTts.stop();
      setState(() {
        isPaused = true;
        isSpeaking = false;
      });
    }
  }

  void cancelListening() async {
    await flutterTts.stop();
    setState(() {
      isListening = false;
      isPaused = false;
      isSpeaking = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF269D9D),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Container(
                  width: 200 + (_controller.value * 20),
                  height: 200 + (_controller.value * 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 100,
            child: Text(
              isPaused ? 'Paused' : (isSpeaking ? 'Speaking' : 'Listening'),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(isPaused ? FontAwesomeIcons.playCircle : FontAwesomeIcons.pauseCircle),
                  iconSize: 50,
                  color: Colors.white,
                  onPressed: pauseListening,
                ),
                SizedBox(width: 60),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.timesCircle),
                  iconSize: 50,
                  color: Colors.red,
                  onPressed: cancelListening,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
