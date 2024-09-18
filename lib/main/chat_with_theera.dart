import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatWithTheeraScreen extends StatefulWidget {
  @override
  _ChatWithTheeraScreenState createState() => _ChatWithTheeraScreenState();
}

class _ChatWithTheeraScreenState extends State<ChatWithTheeraScreen> {
  // A list to hold chat messages
  List<Map<String, dynamic>> messages = [
    {"isUser": false, "message": "Hello! How can I assist you today?"},
  ];

  // A TextEditingController to control the message input field
  final TextEditingController _messageController = TextEditingController();

  // ScrollController to manage scrolling
  final ScrollController _scrollController = ScrollController();

  // Function to send a message to the API and get a response
  Future<void> _sendMessage() async {
    String userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    // Add the user's message to the chat list
    setState(() {
      messages.add({"isUser": true, "message": userMessage});
    });

    // Clear the input field
    _messageController.clear();

    // Replace with your API endpoint URL
    const apiUrl = 'http://127.0.0.1:8000/therapist'; 

    // Prepare request payload
    var requestBody = jsonEncode({
      "context": messages.map((msg) => msg["message"]).toList(),
      "question": userMessage,
    });

    try {
      // Send POST request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      // If the request is successful, get the response message
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String responseMessage = data['answer'];

        // Add the API response to the chat list
        setState(() {
          messages.add({"isUser": false, "message": responseMessage});
        });

        // Scroll to the bottom
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        // Handle errors
        setState(() {
          messages.add({
            "isUser": false,
            "message": "Something went wrong. Please try again later."
          });
        });
      }
    } catch (e) {
      // Handle network errors
      setState(() {
        messages.add({
          "isUser": false,
          "message": "Network error. Please check your connection."
        });
      });
    }
  }

  // Widget to build the chat bubbles
  Widget _buildMessageBubble(String message, bool isUser) {
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
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Custom back button widget
  Widget _buildBackButton() {
    return IconButton(
      icon: Icon(
        FontAwesomeIcons.arrowLeft, // Font Awesome back icon
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
        leading: _buildBackButton(), // Custom back button
      ),
      body: Column(
        children: [
          // Chat messages list with bottom padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0), // Add bottom padding
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(
                    messages[index]["message"],
                    messages[index]["isUser"],
                  );
                },
              ),
            ),
          ),

          // Input field for typing new messages
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // Text field for message input
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

                // Send button with Font Awesome icon
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF269D9D),
                    radius: 25,
                    child: FaIcon(
                      FontAwesomeIcons.paperPlane, // Font Awesome icon
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
