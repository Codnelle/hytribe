import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class TribeMatchingScreen extends StatefulWidget {
  const TribeMatchingScreen({super.key});

  @override
  _TribeMatchingScreenState createState() => _TribeMatchingScreenState();
}

class _TribeMatchingScreenState extends State<TribeMatchingScreen>
    with SingleTickerProviderStateMixin {
  final CardSwiperController controller = CardSwiperController();
  late AnimationController _animationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> tribes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadTribes();
  }

  Future<void> _loadTribes() async {
    try {
      final QuerySnapshot tribeSnapshot =
          await _firestore.collection('tribes').get();
      setState(() {
        tribes = tribeSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // Add sample data if no tribes are found
        if (tribes.isEmpty) {
          tribes = [
            {
              'name': 'Tech Enthusiasts',
              'description': 'A community of tech lovers and innovators',
              'imageUrl':
                  'https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-4.0.3',
              'interests': ['Technology', 'Coding', 'AI', 'Innovation'],
              'id': 'tech-tribe-1'
            },
            {
              'name': 'Art & Design',
              'description': 'Creative minds sharing inspiration and ideas',
              'imageUrl':
                  'https://images.unsplash.com/photo-1513364776144-60967b0f800f?ixlib=rb-4.0.3',
              'interests': ['Art', 'Design', 'Creativity', 'Photography'],
              'id': 'art-tribe-1'
            },
            {
              'name': 'Fitness Warriors',
              'description': 'Stay fit, stay healthy, stay motivated',
              'imageUrl':
                  'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3',
              'interests': ['Fitness', 'Health', 'Sports', 'Wellness'],
              'id': 'fitness-tribe-1'
            }
          ];
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading tribes: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildTribeCard(Map<String, dynamic> tribe) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image
            Image.network(
              tribe['imageUrl'] ?? 'https://via.placeholder.com/400',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    tribe['name'] ?? 'Tribe Name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tribe['description'] ?? 'Tribe Description',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: (tribe['interests'] as List<dynamic>? ?? [])
                        .map((interest) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                interest.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (tribes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Find Your Tribe'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(
          child: Text(
            'No tribes found',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Tribe'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: CardSwiper(
              controller: controller,
              cardsCount: tribes.length,
              onSwipe: (previousIndex, currentIndex, direction) {
                if (direction == CardSwiperDirection.right) {
                  // Like action
                  _handleLike(tribes[previousIndex]);
                }
                return true;
              },
              numberOfCardsDisplayed: 3,
              backCardOffset: const Offset(40, 40),
              padding: const EdgeInsets.all(24.0),
              cardBuilder: (context, index, horizontalOffsetPercentage,
                  verticalOffsetPercentage) {
                return _buildTribeCard(tribes[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.close,
                  Colors.red,
                  () => controller.swipeLeft(),
                ),
                _buildActionButton(
                  Icons.favorite,
                  Colors.green,
                  () => controller.swipeRight(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }

  Future<void> _handleLike(Map<String, dynamic> tribe) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return;

      await _firestore.collection('matches').add({
        'userId': userId,
        'tribeId': tribe['id'],
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Liked ${tribe['name']}!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error handling like: $e');
    }
  }
}
