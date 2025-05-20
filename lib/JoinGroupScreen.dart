import 'package:flutter/material.dart';

class JoinGroupScreen extends StatefulWidget {
  final String groupTitle;
  final String groupImage;
  final int groupMembers;

  const JoinGroupScreen({
    super.key,
    required this.groupTitle,
    required this.groupImage,
    required this.groupMembers,
  });

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  bool _isJoined = false;
  bool _isLoading = false;

  Future<void> _toggleGroupMembership() async {
    setState(() => _isLoading = true);

    try {
      // Replace with your actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      setState(() {
        _isJoined = !_isJoined;
        if (_isJoined) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully joined the group!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Left the group')),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.groupImage),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.groupTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Tap to view about tribe',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.grid_view),
                  const SizedBox(width: 12),
                  const Icon(Icons.more_horiz),
                ],
              ),
            ),

            // Topic Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('Topic'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text('understanding ${widget.groupTitle}'),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sort Posts Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort Posts',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', true),
                        _buildFilterChip('Comments', false),
                        _buildFilterChip('Media', false),
                        _buildFilterChip('Liked', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Post List Section
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(child: Icon(Icons.person)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'User $index',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '@user$index',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${index + 1}h ago',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getPostDescription(index),
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildInteractionButton(
                                  Icons.favorite_border, '2k'),
                              const SizedBox(width: 24),
                              _buildInteractionButton(
                                  Icons.chat_bubble_outline, '140'),
                              const SizedBox(width: 24),
                              _buildInteractionButton(
                                  Icons.remove_red_eye_outlined, '24k'),
                              const Spacer(),
                              const Icon(Icons.bookmark_border),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Join/Leave Button
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _toggleGroupMembership,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: _isJoined ? Colors.grey : null,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_isJoined ? 'Leave Group' : 'Join Group'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {},
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 4),
        Text(count),
      ],
    );
  }

  String _getPostDescription(int index) {
    switch (index) {
      case 0:
        return 'Just joined this group! Excited to be a part of the discussions here. I’ve been following this space for a while, and it’s great to finally contribute.';
      case 1:
        return 'Anyone else feeling the new changes in ${widget.groupTitle}? I’m not sure if it’s the right direction, but I’m open to hearing thoughts from the rest of the community!';
      case 2:
        return 'Just finished reading the new post on ${widget.groupTitle}. Some interesting points there, especially around the impact of the upcoming updates. Can’t wait to see how it all unfolds.';
      case 3:
        return 'It’s been amazing seeing everyone share their perspectives on ${widget.groupTitle}. There’s so much to learn from all the discussions happening here!';
      case 4:
        return 'Loving the vibe in this group. Some truly insightful comments on the recent topic. Can’t wait to contribute more and learn from everyone!';
      default:
        return 'A random post in the group to keep the conversation going!';
    }
  }
}
