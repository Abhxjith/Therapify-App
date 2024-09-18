import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TalkToTheeraScreen extends StatefulWidget {
  @override
  _TalkToTheeraScreenState createState() => _TalkToTheeraScreenState();
}

class _TalkToTheeraScreenState extends State<TalkToTheeraScreen>
    with SingleTickerProviderStateMixin {
  final String apiUrl = 'http://localhost:8000';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isListening = true;
  bool isPaused = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    listenAndRespond();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> listenAndRespond() async {
    while (isListening) { // Ensure the loop continues while listening
      try {
        final response = await http.get(Uri.parse('$apiUrl/listen-and-respond'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          final String? responseText = data['response'] as String?;
          final String? audioBase64 = data['audio'] as String?;

          print('Response Text: $responseText');
          print('Audio Base64: ${audioBase64?.substring(0, 30)}...'); // Print the first 30 characters of the audio data

          if (audioBase64 != null && audioBase64.isNotEmpty) {
            final audioBytes = base64Decode(audioBase64);
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/response.mp3';
            final responseFile = File(filePath);
            await responseFile.writeAsBytes(audioBytes);
            await _audioPlayer.play(responseFile.path, isLocal: true);
            
            setState(() {
              // Do not stop listening; continue the loop
            });
          } else {
            print('Audio data is null or empty');
          }
        } else {
          print('Failed to get response from server. Status code: ${response.statusCode}');
        }

        // Optionally, add a small delay before the next request
        await Future.delayed(Duration(seconds: 1));

      } catch (e) {
        print('Error in communication with the server: $e');
      }
    }
  }

  void pauseListening() {
    if (isPaused) {
      _audioPlayer.resume();
    } else {
      _audioPlayer.pause();
    }
    setState(() {
      isPaused = !isPaused;
    });
  }

  void cancelListening() {
    _audioPlayer.stop();
    setState(() {
      isListening = false;
      isPaused = false;
    });
    // Navigate back to the HomePage
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF269D9D),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Center the AnimatedBuilder
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
          if (isListening) ...[
            // Dots indicating listening
            Positioned(
              bottom: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: 100,
              child: Text(
                'Listening',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ] else ...[
            // Tap to cancel text
            Positioned(
              bottom: 100,
              child: Text(
                'Tap to cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          // Pause and Cancel Buttons
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
