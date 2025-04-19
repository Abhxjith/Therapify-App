import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:math';

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final List<IconData> _icons = [
    FontAwesomeIcons.leaf,
    FontAwesomeIcons.moon,
    FontAwesomeIcons.star,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.cloud,
    FontAwesomeIcons.sun,
    FontAwesomeIcons.tree,
    FontAwesomeIcons.mountain,
  ];

  late List<CardItem> cards;
  bool isProcessing = false;
  CardItem? selectedCard;
  int matches = 0;
  int moves = 0;
  late Timer _timer;
  int _seconds = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Create pairs of cards
    cards = [];
    for (var icon in _icons) {
      cards.add(CardItem(icon: icon, color: _getRandomColor()));
      cards.add(CardItem(icon: icon, color: _getRandomColor()));
    }
    // Shuffle the cards
    cards.shuffle();
    matches = 0;
    moves = 0;
    _seconds = 0;
    _isPlaying = false;
  }

  Color _getRandomColor() {
    List<Color> colors = [
      Color(0xFF2A9D8F),
      Color(0xFF264653),
      Color(0xFFE9C46A),
      Color(0xFFF4A261),
      Color(0xFFE76F51),
    ];
    return colors[Random().nextInt(colors.length)];
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    _isPlaying = true;
  }

  void _stopTimer() {
    _timer.cancel();
    _isPlaying = false;
  }

  void _handleCardTap(int index) {
    if (isProcessing || cards[index].isMatched || cards[index].isFlipped) return;

    if (!_isPlaying) _startTimer();

    setState(() {
      cards[index].isFlipped = true;
      moves++;

      if (selectedCard == null) {
        selectedCard = cards[index];
      } else {
        isProcessing = true;
        
        if (selectedCard!.icon == cards[index].icon) {
          // Match found
          selectedCard!.isMatched = true;
          cards[index].isMatched = true;
          matches++;
          selectedCard = null;
          isProcessing = false;

          if (matches == _icons.length) {
            // Game completed
            _stopTimer();
            _showCompletionDialog();
          }
        } else {
          // No match
          Future.delayed(Duration(milliseconds: 1000), () {
            setState(() {
              selectedCard!.isFlipped = false;
              cards[index].isFlipped = false;
              selectedCard = null;
              isProcessing = false;
            });
          });
        }
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Congratulations! 🎉',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You completed the game!',
              style: GoogleFonts.inter(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Time: ${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}\nMoves: $moves',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _initializeGame();
              });
            },
            child: Text(
              'Play Again',
              style: GoogleFonts.inter(
                color: Color(0xFF2A9D8F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isPlaying) _timer.cancel();
    super.dispose();
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
          'Mindful Match',
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
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard(
                  'Time',
                  '${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}',
                  FontAwesomeIcons.clock,
                ),
                _buildInfoCard(
                  'Moves',
                  moves.toString(),
                  FontAwesomeIcons.handPointer,
                ),
                _buildInfoCard(
                  'Matches',
                  '$matches/${_icons.length}',
                  FontAwesomeIcons.check,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) => _buildCard(index),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () {
                if (_isPlaying) _stopTimer();
                setState(() {
                  _initializeGame();
                });
              },
              icon: FaIcon(FontAwesomeIcons.rotate, size: 16),
              label: Text(
                'Restart Game',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2A9D8F),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2A9D8F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          FaIcon(
            icon,
            size: 16,
            color: Color(0xFF2A9D8F),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2A9D8F),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    return GestureDetector(
      onTap: () => _handleCardTap(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: cards[index].isFlipped || cards[index].isMatched
              ? cards[index].color.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: cards[index].isFlipped || cards[index].isMatched
                ? cards[index].color
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: cards[index].isFlipped || cards[index].isMatched
              ? FaIcon(
                  cards[index].icon,
                  size: 24,
                  color: cards[index].color,
                )
              : FaIcon(
                  FontAwesomeIcons.question,
                  size: 24,
                  color: Colors.grey[400],
                ),
        ),
      ),
    );
  }
}

class CardItem {
  final IconData icon;
  final Color color;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.icon,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
  });
} 