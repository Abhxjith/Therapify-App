import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class CalmingMusicScreen extends StatefulWidget {
  @override
  _CalmingMusicScreenState createState() => _CalmingMusicScreenState();
}

class _CalmingMusicScreenState extends State<CalmingMusicScreen> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentPlayingTitle;
  bool isPlaying = false;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _initAudioSession();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String audioPath, String title) async {
    try {
      if (currentPlayingTitle == title && isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          isPlaying = false;
          currentPlayingTitle = null;
        });
      } else {
        if (currentPlayingTitle != null) {
          await _audioPlayer.stop();
        }
        await _audioPlayer.setAsset(audioPath);
        await _audioPlayer.play();
        setState(() {
          isPlaying = true;
          currentPlayingTitle = title;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error playing audio: $e',
            style: GoogleFonts.inter(),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final Map<String, List<Map<String, dynamic>>> playlists = {
    "Relaxation & Stress Relief": [
      {
        "title": "Ocean Meditation",
        "duration": "10:00",
        "audioPath": "assets/audio/ocean_meditation.mp3",
        "color": Color(0xFF48CAE4),
        "icon": FontAwesomeIcons.water,
      },
      {
        "title": "Forest Rain Ambience",
        "duration": "15:00",
        "audioPath": "assets/audio/forest_rain.mp3",
        "color": Color(0xFF40916C),
        "icon": FontAwesomeIcons.tree,
      },
      {
        "title": "Gentle Piano Melody",
        "duration": "8:30",
        "audioPath": "assets/audio/piano_melody.mp3",
        "color": Color(0xFF90E0EF),
        "icon": FontAwesomeIcons.music,
      },
      {
        "title": "Deep Breathing Guide",
        "duration": "12:00",
        "audioPath": "assets/audio/breathing_guide.mp3",
        "color": Color(0xFFADE8F4),
        "icon": FontAwesomeIcons.wind,
      },
    ],
    "Anxiety Management": [
      {
        "title": "Mindful Breathing",
        "duration": "10:00",
        "audioPath": "assets/audio/mindful_breathing.mp3",
        "color": Color(0xFF6A994E),
        "icon": FontAwesomeIcons.wind
      },
      {
        "title": "Guided Body Scan",
        "duration": "15:00",
        "audioPath": "assets/audio/body_scan.mp3",
        "color": Color(0xFF6D6875),
        "icon": FontAwesomeIcons.user
      },
      {
        "title": "Soothing Music",
        "duration": "7:45",
        "audioPath": "assets/audio/soothing_music.mp3",
        "color": Color(0xFFC1A3A3),
        "icon": FontAwesomeIcons.headphones
      },
      {
        "title": "Positive Affirmations",
        "duration": "5:30",
        "audioPath": "assets/audio/affirmations.mp3",
        "color": Color(0xFFBDE0FE),
        "icon": FontAwesomeIcons.quoteLeft
      }
    ],
    "Sleep & Relaxation": [
      {
        "title": "Deep Sleep Journey",
        "duration": "20:00",
        "audioPath": "assets/audio/deep_sleep.mp3",
        "color": Color(0xFF14213D),
        "icon": FontAwesomeIcons.bed
      },
      {
        "title": "Rain Sounds",
        "duration": "30:00",
        "audioPath": "assets/audio/rain_sounds.mp3",
        "color": Color(0xFF264653),
        "icon": FontAwesomeIcons.cloudShowersHeavy
      },
      {
        "title": "Lullaby Melodies",
        "duration": "15:00",
        "audioPath": "assets/audio/lullaby.mp3",
        "color": Color(0xFF2A9D8F),
        "icon": FontAwesomeIcons.music
      },
      
      
    ]
  };

  Future<void> _launchSpotifyUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open Spotify playlist',
            style: GoogleFonts.inter(),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF2A9D8F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Widget _buildPlaylistCard(Map<String, dynamic> playlist, String category) {
    final bool isCurrentlyPlaying = currentPlayingTitle == playlist['title'];
    
    return Container(
      margin: EdgeInsets.only(right: 12, bottom: 2),
      width: 160,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _playAudio(playlist['audioPath'], playlist['title']),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: playlist['color'].withOpacity(0.2),
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.6,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          playlist['color'].withOpacity(0.2),
                          playlist['color'].withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FaIcon(
                        playlist['icon'],
                        color: playlist['color'],
                        size: 28,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  playlist['title'],
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                SizedBox(
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: playlist['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.clock,
                              size: 10,
                              color: playlist['color'],
                            ),
                            SizedBox(width: 4),
                            Text(
                              playlist['duration'],
                              style: GoogleFonts.inter(
                                color: playlist['color'],
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: playlist['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FaIcon(
                            isCurrentlyPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                            color: playlist['color'],
                            size: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          'Calming Music',
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
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2A9D8F), Color(0xFF264653)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.headphones,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Peace',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Select music that matches your mood',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                String category = playlists.keys.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        category,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 170,
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
                    SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}