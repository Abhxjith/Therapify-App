import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Define your custom app theme with enhanced colors
final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF2A9D8F),
  primarySwatch: MaterialColor(
    0xFF2A9D8F,
    <int, Color>{
      50: const Color(0xFFE6F5F3),
      100: const Color(0xFFCCEBE7),
      200: const Color(0xFF99D7CF),
      300: const Color(0xFF66C3B7),
      400: const Color(0xFF33AF9F),
      500: const Color(0xFF2A9D8F),
      600: const Color(0xFF238E81),
      700: const Color(0xFF1C7F73),
      800: const Color(0xFF156F65),
      900: const Color(0xFF0E6057),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFF8F9FA),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: GoogleFonts.interTextTheme(),
);

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<JournalEntry> _journalEntries = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  String _selectedMood = 'Neutral';
  final List<Map<String, dynamic>> _moods = [
    {'name': 'Happy', 'icon': FontAwesomeIcons.faceSmileBeam},
    {'name': 'Calm', 'icon': FontAwesomeIcons.faceSmile},
    {'name': 'Neutral', 'icon': FontAwesomeIcons.faceMeh},
    {'name': 'Anxious', 'icon': FontAwesomeIcons.faceFrown},
    {'name': 'Sad', 'icon': FontAwesomeIcons.faceSadTear},
  ];

  // Add storage methods
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _journalEntries.map((entry) => entry.toJson()).toList(),
    );
    await prefs.setString('journal_entries', encodedData);
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('journal_entries');
    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      setState(() {
        _journalEntries = decodedData
            .map((item) => JournalEntry.fromJson(item))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEntries(); // Load saved entries
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildMoodSelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4),
        itemCount: _moods.length,
        itemBuilder: (context, index) {
          final mood = _moods[index];
          final isSelected = _selectedMood == mood['name'];
          return Container(
            width: 80,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMood = mood['name'];
                });
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Color(0xFF2A9D8F).withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                            ? Color(0xFF2A9D8F)
                            : Colors.grey[200]!,
                        width: 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Color(0xFF2A9D8F).withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: FaIcon(
                      mood['icon'],
                      color: isSelected ? Color(0xFF2A9D8F) : Colors.grey[400],
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    mood['name'],
                    style: GoogleFonts.inter(
                      color: isSelected ? Color(0xFF2A9D8F) : Colors.grey[600],
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF5F5F7),
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleLeft, size: 20, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Journal',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.sliders, size: 20, color: Colors.black54),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
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
                  'How are you feeling?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                _buildMoodSelector(),
              ],
            ),
          ),
          Expanded(
            child: _journalEntries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.bookOpen,
                                size: 48,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No entries yet',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap the + button to start journaling',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: _journalEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _journalEntries[index];
                      return _buildJournalCard(entry);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2A9D8F).withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (_isExpanded) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          backgroundColor: Color(0xFF2A9D8F),
          icon: FaIcon(
            FontAwesomeIcons.pen,
            size: 20,
            color: Colors.white,
          ),
          label: Text(
            'New Entry',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      bottomSheet: _buildEntrySheet(),
    );
  }

  Widget _buildEntrySheet() {
    return SizeTransition(
      sizeFactor: _animation,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Entry',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.xmark, size: 20),
                  onPressed: () {
                    _animationController.reverse();
                    _isExpanded = false;
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 5,
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Write your thoughts...',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color(0xFF2A9D8F)),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      _journalEntries.insert(0, JournalEntry(
                        content: _controller.text,
                        timestamp: DateTime.now(),
                        mood: _selectedMood,
                      ));
                      _controller.clear();
                    });
                    await _saveEntries();
                    _animationController.reverse();
                    _isExpanded = false;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A9D8F),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Entry',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalCard(JournalEntry entry) {
    IconData getMoodIcon() {
      switch (entry.mood) {
        case 'Happy': return FontAwesomeIcons.faceSmileBeam;
        case 'Calm': return FontAwesomeIcons.faceSmile;
        case 'Anxious': return FontAwesomeIcons.faceFrown;
        case 'Sad': return FontAwesomeIcons.faceSadTear;
        default: return FontAwesomeIcons.faceMeh;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A9D8F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(
                        getMoodIcon(),
                        size: 18,
                        color: Color(0xFF2A9D8F),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      DateFormat('MMM d, y').format(entry.timestamp),
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  DateFormat('h:mm a').format(entry.timestamp),
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              entry.content,
              style: GoogleFonts.inter(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JournalEntry {
  final String content;
  final DateTime timestamp;
  final String mood;

  JournalEntry({
    required this.content,
    required this.timestamp,
    required this.mood,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'mood': mood,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    mood: json['mood'],
  );
}

void main() {
  runApp(MaterialApp(
    title: 'Reflections Journal',
    theme: appTheme,
    home: const JournalScreen(),
  ));
}