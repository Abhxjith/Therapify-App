import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SleepStoriesScreen extends StatelessWidget {
  final List<StoryItem> stories = [
    StoryItem(
      title: 'Peaceful Forest',
      duration: '15 min',
      narrator: 'Sarah Johnson',
      icon: FontAwesomeIcons.tree,
      category: 'Nature',
      backgroundColor: Colors.green.shade800,
    ),
    StoryItem(
      title: 'Ocean Waves',
      duration: '20 min',
      narrator: 'Michael Chen',
      icon: FontAwesomeIcons.water,
      category: 'Nature',
      backgroundColor: Colors.blue.shade800,
    ),
    StoryItem(
      title: 'Starry Night',
      duration: '18 min',
      narrator: 'Emma Wilson',
      icon: FontAwesomeIcons.star,
      category: 'Fantasy',
      backgroundColor: Colors.indigo.shade800,
    ),
    StoryItem(
      title: 'Cozy Fireplace',
      duration: '22 min',
      narrator: 'David Brown',
      icon: FontAwesomeIcons.fire,
      category: 'Ambient',
      backgroundColor: Colors.orange.shade800,
    ),
    StoryItem(
      title: 'Rain on Leaves',
      duration: '25 min',
      narrator: 'Lisa Anderson',
      icon: FontAwesomeIcons.cloudRain,
      category: 'Nature',
      backgroundColor: Colors.teal.shade800,
    ),
    StoryItem(
      title: 'Mountain Cabin',
      duration: '20 min',
      narrator: 'James Wilson',
      icon: FontAwesomeIcons.mountain,
      category: 'Adventure',
      backgroundColor: Colors.brown.shade800,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sleep Stories',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.sliders, color: Colors.white),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories horizontal list
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('All', true),
                _buildCategoryChip('Nature', false),
                _buildCategoryChip('Fantasy', false),
                _buildCategoryChip('Ambient', false),
                _buildCategoryChip('Adventure', false),
              ],
            ),
          ),
          // Stories grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return _buildStoryCard(stories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[300],
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          // Implement category filter
        },
        backgroundColor: const Color(0xFF2D2D44),
        selectedColor: const Color(0xFF4A4A6A),
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildStoryCard(StoryItem story) {
    return GestureDetector(
      onTap: () {
        // Navigate to story detail page
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D44),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Story icon section (replaced image)
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: story.backgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    // Centered icon
                    Center(
                      child: Icon(
                        story.icon,
                        size: 48,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    // Duration chip
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          story.duration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Story details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          story.icon,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          story.category,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${story.narrator}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

class StoryItem {
  final String title;
  final String duration;
  final String narrator;
  final IconData icon;
  final String category;
  final Color backgroundColor;

  StoryItem({
    required this.title,
    required this.duration,
    required this.narrator,
    required this.icon,
    required this.category,
    required this.backgroundColor,
  });
}