import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// Add this constant at the top of your file
const String GEMINI_API_KEY = 'AIzaSyANL6EVg3e7yuJmBV70m8v_LwKgyohx_h8';
const String GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

class ChatWithTheeraScreen extends StatefulWidget {
  @override
  _ChatWithTheeraScreenState createState() => _ChatWithTheeraScreenState();
}

class _ChatWithTheeraScreenState extends State<ChatWithTheeraScreen> {
  List<Map<String, dynamic>> messages = [
    {"isUser": false, "message": "Hey! What brings you here?"},
  ];

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Function to call Gemini API
  Future<String> _getGeminiResponse(String userMessage) async {
  try {
    final response = await http.post(
      Uri.parse('$GEMINI_API_URL?key=$GEMINI_API_KEY'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [{
          "parts": [{
            "text": "You are Theera, an Indian therapist with 20 years of experience. Respond to the user as though you are a human therapist in a calm, conversational manner, expressing genuine concern and understanding. Avoid introducing yourself repeatedly. Focus on providing thoughtful, empathetic responses that encourage the user to share their feelings. User: $userMessage"
          }]
        }],
        "generationConfig": {
          "temperature": 0.85,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        }
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      return decodedResponse['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to get response from llama API: ${response.statusCode}');
    }
  } catch (e) {
    print('Error calling llama API: $e');
    return 'I’m here to listen. Please feel free to share your thoughts.';
  }
}


  // Function to send a message and receive a response
  Future<void> _sendMessage() async {
    String userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"isUser": true, "message": userMessage});
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Show typing indicator
      setState(() {
        messages.add({"isUser": false, "message": "typing...", "isTyping": true});
      });
      _scrollToBottom();

      // Get response from Gemini
      String responseMessage = await _getGeminiResponse(userMessage);

      // Remove typing indicator and add actual response
      setState(() {
        messages.removeWhere((message) => message['isTyping'] == true);
        messages.add({"isUser": false, "message": responseMessage});
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        messages.removeWhere((message) => message['isTyping'] == true);
        messages.add({
          "isUser": false,
          "message": "Something went wrong. Please try again later."
        });
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
}