import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalmingMusicScreen extends StatefulWidget {
  @override
  _CalmingMusicScreenState createState() => _CalmingMusicScreenState();
}

class _CalmingMusicScreenState extends State<CalmingMusicScreen> with SingleTickerProviderStateMixin {
  String currentPlaylist = "";
  bool isPlaying = false;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final Map<String, List<Map<String, dynamic>>> playlists = {
  "Relaxation & Stress Relief": [
    {
      "title": "Ocean Meditation",
      "duration": "10:00",
      "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWZqd5JICZI0u",
      "color": Color(0xFF48CAE4),
      "icon": FontAwesomeIcons.water,  // Updated icon
    },
    {
      "title": "Forest Rain Ambience",
      "duration": "15:00",
      "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX4PP3DA4J0N8",
      "color": Color(0xFF40916C),
      "icon": FontAwesomeIcons.tree,  // Updated icon
    },
    {
      "title": "Gentle Piano Melody",
      "duration": "8:30",
      "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX4sWSpwq3LiO",
      "color": Color(0xFF90E0EF),
      "icon": FontAwesomeIcons.music,  // Updated icon
    },
    {
      "title": "Deep Breathing Guide",
      "duration": "12:00",
      "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWZqd5JICZI0u",
      "color": Color(0xFFADE8F4),
      "icon": FontAwesomeIcons.wind,  // Updated icon
    },
  ],
  "Anxiety Management": [
  {
    "title": "Mindful Breathing",
    "duration": "10:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX0HRj9P7NxeE",
    "color": Color(0xFF6A994E),
    "icon": FontAwesomeIcons.wind
  },
  {
    "title": "Guided Body Scan",
    "duration": "15:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWU0ScTcjJBdj",
    "color": Color(0xFF6D6875),
    "icon": FontAwesomeIcons.user
  },
  {
    "title": "Soothing Music",
    "duration": "7:45",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX4sWSpwq3LiO",
    "color": Color(0xFFC1A3A3),
    "icon": FontAwesomeIcons.headphones
  },
  {
    "title": "Positive Affirmations",
    "duration": "5:30",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX5IDTimEWoTd",
    "color": Color(0xFFBDE0FE),
    "icon": FontAwesomeIcons.quoteLeft
  }
], "Sleep & Relaxation": [
  {
    "title": "Deep Sleep Journey",
    "duration": "20:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWZd79rJ6a7lp",
    "color": Color(0xFF14213D),
    "icon": FontAwesomeIcons.bed
  },
  {
    "title": "Rain Sounds",
    "duration": "30:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWVV27DiNWxkR",
    "color": Color(0xFF264653),
    "icon": FontAwesomeIcons.cloudShowersHeavy
  },
  {
    "title": "Lullaby Melodies",
    "duration": "15:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX0MlK4Dh26uj",
    "color": Color(0xFF2A9D8F),
    "icon": FontAwesomeIcons.music
  },
  {
    "title": "Guided Relaxation",
    "duration": "10:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX1s9knjP51Oa",
    "color": Color(0xFF023E8A),
    "icon": FontAwesomeIcons.solidMoon
  }
],

"Mood Uplifting": [
  {
    "title": "Positive Vibes",
    "duration": "10:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWZjqjZMudx9T",
    "color": Color(0xFFFFA69E),
    "icon": FontAwesomeIcons.smile
  },
  {
    "title": "Feel-Good Music",
    "duration": "12:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DXdPec7aLTmlC",
    "color": Color(0xFFFFD166),
    "icon": FontAwesomeIcons.music
  },
  {
    "title": "Sunshine Beats",
    "duration": "8:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX0XUsuxWHRQd",
    "color": Color(0xFFF4A261),
    "icon": FontAwesomeIcons.sun
  },
  {
    "title": "Morning Motivation",
    "duration": "15:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWTbVQKZGwFZr",
    "color": Color(0xFFE76F51),
    "icon": FontAwesomeIcons.coffee
  }
],

"Focus & Productivity": [
  {
    "title": "Concentration Boost",
    "duration": "12:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWZeKCadgRdKQ",
    "color": Color(0xFF3D405B),
    "icon": FontAwesomeIcons.brain
  },
  {
    "title": "Study Power",
    "duration": "30:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWZIOAPKUdaKS",
    "color": Color(0xFF2A9D8F),
    "icon": FontAwesomeIcons.book
  },
  {
    "title": "Ambient Focus",
    "duration": "25:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DWZqd5JICZI0u",
    "color": Color(0xFF264653),
    "icon": FontAwesomeIcons.headphones
  },
  {
    "title": "Work & Chill",
    "duration": "15:00",
    "spotifyUrl": "https://open.spotify.com/playlist/37i9dQZF1DX8Uebhn9wzrS",
    "color": Color(0xFF8D99AE),
    "icon": FontAwesomeIcons.desktop
  }
]


};

  Future<void> _launchSpotifyUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open Spotify playlist'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildPlaylistCard(Map<String, dynamic> playlist, String category) {
    return GestureDetector(
      onTap: () => _launchSpotifyUrl(playlist['spotifyUrl']),
      child: Card(
        elevation: 8,
        shadowColor: playlist['color'].withOpacity(0.3),
        margin: EdgeInsets.only(right: 16, bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 180,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      playlist['color'].withOpacity(0.7),
                      playlist['color'].withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    playlist['icon'],
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                playlist['title'],
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: playlist['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      playlist['duration'],
                      style: GoogleFonts.inter(
                        color: playlist['color'],
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.play_circle_fill,
                      color: playlist['color'],
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        currentPlaylist = playlist['title'];
                        isPlaying = true;
                        _animationController.forward();
                      });
                      _launchSpotifyUrl(playlist['spotifyUrl']);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          '',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Text(
                "Select a playlist that matches your current emotional state",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  String category = playlists.keys.elementAt(index);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category,
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Implement view all functionality
                              },
                              child: Text(
                                'View All',
                                style: GoogleFonts.inter(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: playlists[category]!.length,
                          itemBuilder: (context, songIndex) {
                            return _buildPlaylistCard(
                              playlists[category]![songIndex],
                              category,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (currentPlaylist.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Now Playing",
                              style: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              currentPlaylist,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _animationController,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}