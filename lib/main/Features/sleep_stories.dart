import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'story_detail_screen.dart';

class SleepStoriesScreen extends StatelessWidget {
  final List<StoryItem> stories = [
    StoryItem(
      title: 'Peaceful Forest',
      duration: '15 min',
      narrator: 'Sarah Johnson',
      icon: FontAwesomeIcons.tree,
      category: 'Nature',
      color: Color(0xFF2A9D8F),
      description: 'Take a calming journey through an ancient forest, where gentle breezes whisper through towering pines and soft moonlight filters through the canopy.',
      story: '''Deep in the heart of an ancient forest, where moss-covered trees reach toward the stars, there lies a hidden path known only to those who seek true peace. The gentle rustling of leaves creates a natural lullaby, while distant owls add their soft melody to the night's symphony.

As you walk deeper into this enchanted woodland, each step takes you further from your daily concerns. The air is filled with the sweet scent of pine and wild flowers, and the soft carpet of fallen leaves cushions your every step.

A small stream meanders nearby, its crystal-clear waters dancing over smooth stones, creating a perpetual song of tranquility. Moonlight streams through the canopy above, casting intricate shadows that dance slowly in the evening breeze...''',
    ),
    StoryItem(
      title: 'Ocean Waves',
      duration: '20 min',
      narrator: 'Michael Chen',
      icon: FontAwesomeIcons.water,
      category: 'Nature',
      color: Color(0xFF264653),
      description: 'Let the rhythmic sounds of gentle ocean waves transport you to a peaceful shoreline, where your worries drift away with the tide.',
      story: '''Along a secluded beach, where soft sand meets the endless blue horizon, waves roll in with a timeless rhythm. Each wave brings with it a gentle reminder to breathe, to release, to let go.

The salt-laden air carries stories of distant shores, while seabirds glide silently overhead. White foam edges each wave like delicate lace, spreading across the sand before retreating back to the vast ocean.

As the sun sets, the sky transforms into a canvas of soft oranges and purples, reflecting off the water's surface like nature's own lullaby. The steady percussion of waves creates a perfect backdrop for peaceful dreams...''',
    ),
    StoryItem(
      title: 'Starry Night',
      duration: '18 min',
      narrator: 'Emma Wilson',
      icon: FontAwesomeIcons.moon,
      category: 'Fantasy',
      color: Color(0xFFE9C46A),
      description: 'Embark on a magical journey through the cosmos, where shooting stars and distant galaxies paint stories across the night sky.',
      story: '''High above the sleeping world, countless stars twinkle like diamonds scattered across black velvet. Each one holds a story, a dream, a wish waiting to be discovered.

The Milky Way stretches across the sky like a river of stardust, its gentle light casting a soft glow over the quiet landscape below. Shooting stars streak across the darkness, leaving trails of golden light in their wake.

In this vast cosmic dance, constellations tell their ancient tales, while the moon watches over all, its serene light bringing peace to restless minds. Here, under the infinite canopy of stars, every worry seems small against the grand tapestry of the universe...''',
    ),
    StoryItem(
      title: 'Cozy Fireplace',
      duration: '22 min',
      narrator: 'David Brown',
      icon: FontAwesomeIcons.fire,
      category: 'Ambient',
      color: Color(0xFFF4A261),
      description: 'Find comfort by a warm hearth, where crackling flames and soft shadows create the perfect atmosphere for peaceful rest.',
      story: '''In a snug corner of a wooden cabin, a fireplace casts its warm, golden light across the room. The flames dance and weave, telling stories without words, while logs crackle softly like nature's own lullaby.

Comfortable armchairs embrace you like old friends, their soft fabric holding memories of countless peaceful evenings. Outside, snow falls silently, making the warmth inside feel even more precious.

The scent of cedar mingles with the sweet smoke from the fire, creating an atmosphere of perfect contentment. As shadows play across the walls, each flicker of flame brings a deeper sense of peace and tranquility...''',
    ),
    StoryItem(
      title: 'Rain on Leaves',
      duration: '25 min',
      narrator: 'Lisa Anderson',
      icon: FontAwesomeIcons.cloudRain,
      category: 'Nature',
      color: Color(0xFF2A9D8F),
      description: 'Experience the soothing rhythm of raindrops as they create a natural symphony on forest leaves.',
      story: '''Gentle rain falls from gray clouds above, creating a peaceful percussion on countless green leaves. Each droplet adds its voice to nature's lullaby, while distant thunder rumbles softly like a contented cat's purr.

The forest seems to come alive with the rain, as leaves dance under the weight of falling drops, and small streams form between moss-covered stones. The air is fresh and clean, filled with the earthy scent of rain-soaked soil.

Tiny rivulets trace patterns down tree trunks, while birds find shelter in the dense canopy above. In this moment, the rain creates a cocoon of tranquility, washing away the day's concerns...''',
    ),
    StoryItem(
      title: 'Mountain Cabin',
      duration: '20 min',
      narrator: 'James Wilson',
      icon: FontAwesomeIcons.mountain,
      category: 'Adventure',
      color: Color(0xFFE76F51),
      description: 'Retreat to a peaceful mountain hideaway, where crisp alpine air and distant peaks create a perfect sanctuary.',
      story: '''High in the mountains, where the air is crisp and clean, stands a small cabin with windows that frame majestic peaks. Snow-capped summits pierce the clouds like ancient guardians, while valleys below are blanketed in misty morning light.

Inside the cabin, a kettle whistles softly on the stove, its steam carrying the aroma of mountain herbs. Wooden beams overhead hold stories of countless peaceful nights, while a gentle breeze carries the distant song of alpine birds.

As the sun sets behind distant peaks, the sky transforms into a canvas of pink and gold, painting the mountains in warm, gentle hues. Here, far above the busy world below, time seems to slow to a peaceful crawl...''',
    ),
  ];

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
          'Sleep Stories',
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
                    FontAwesomeIcons.moon,
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
                        'Bedtime Stories',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Let stories guide you to peaceful sleep',
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
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('All', true),
                _buildCategoryChip('Nature', false),
                _buildCategoryChip('Fantasy', false),
                _buildCategoryChip('Ambient', false),
                _buildCategoryChip('Adventure', false),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: stories.length,
              itemBuilder: (context, index) => _buildStoryCard(context, stories[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Color(0xFF2A9D8F) : Colors.black54,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          // Implement category filter
        },
        backgroundColor: Colors.white,
        selectedColor: Color(0xFF2A9D8F).withOpacity(0.1),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? Color(0xFF2A9D8F) : Colors.grey[300]!,
          ),
        ),
        showCheckmark: false,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildStoryCard(BuildContext context, StoryItem story) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: story.color.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryDetailScreen(story: story),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: story.color.withOpacity(0.1),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: FaIcon(
                          story.icon,
                          size: 40,
                          color: story.color,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.clock,
                                size: 10,
                                color: story.color,
                              ),
                              SizedBox(width: 4),
                              Text(
                                story.duration,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: story.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          story.icon,
                          size: 12,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 4),
                        Text(
                          story.category,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      story.title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'by ${story.narrator}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryItem {
  final String title;
  final String duration;
  final String narrator;
  final IconData icon;
  final String category;
  final Color color;
  final String description;
  final String story;

  StoryItem({
    required this.title,
    required this.duration,
    required this.narrator,
    required this.icon,
    required this.category,
    required this.color,
    required this.description,
    required this.story,
  });
}

class StoryDetailScreen extends StatefulWidget {
  final StoryItem story;

  const StoryDetailScreen({Key? key, required this.story}) : super(key: key);

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
          'Story Details',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: widget.story.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.story.color.withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        widget.story.icon,
                        size: 80,
                        color: widget.story.color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.story.title,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.user,
                              size: 14,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.story.narrator,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 16),
                            FaIcon(
                              FontAwesomeIcons.clock,
                              size: 14,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 8),
                            Text(
                              widget.story.duration,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.story.description,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Story',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.story.story,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isPlaying ? 1.0 : _animation.value,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.story.color,
                          Color.lerp(widget.story.color, Colors.black, 0.2)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: widget.story.color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              isPlaying ? 'Pause Story' : 'Start Listening',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}