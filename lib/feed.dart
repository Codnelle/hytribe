import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String? selectedCategory;
  bool showBanner = true;

  final List<Map<String, dynamic>> posts = List.generate(
    53,
    (index) => {
      'id': index,
      'username': 'User $index',
      'avatarUrl':
          'https://randomuser.me/api/portraits/women/${index % 100}.jpg',
      'imageUrl': 'https://picsum.photos/800/600?random=${index + 1}',
      'caption': 'This is post $index',
      'likes': (index + 1) * 100,
      'comments': (index + 1) * 10,
      'category': index % 5 == 0
          ? 'Technology'
          : index % 5 == 1
              ? 'Fitness'
              : index % 5 == 2
                  ? 'Photography'
                  : index % 5 == 3
                      ? 'Art'
                      : 'Travel',
    },
  );

  final List<Map<String, String>> categories = [
    {'title': 'Technology', 'imageUrl': 'https://picsum.photos/200?random=1'},
    {'title': 'Fitness', 'imageUrl': 'https://picsum.photos/200?random=2'},
    {'title': 'Photography', 'imageUrl': 'https://picsum.photos/200?random=3'},
    {'title': 'Art', 'imageUrl': 'https://picsum.photos/200?random=4'},
    {'title': 'Travel', 'imageUrl': 'https://picsum.photos/200?random=5'},
  ];

  List<Map<String, dynamic>> getFilteredPosts() {
    if (selectedCategory == null) return posts;
    return posts.where((post) => post['category'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = getFilteredPosts();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo-hyt1.png',
          height: 82,
          fit: BoxFit.fill,
        ),
      ),
      body: Column(
        children: [
          if (showBanner)
            Container(
              padding: const EdgeInsets.all(10),
              color: const Color.fromARGB(255, 38, 144, 92),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'If you are feeling distressed, please call the helpline: 1-800-273-TALK (8255)',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() => showBanner = false);
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (selectedCategory != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Showing $selectedCategory posts',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = null;
                              });
                            },
                            child: const Text('Show All'),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(238, 238, 238, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ListView.builder(
                            itemCount: filteredPosts.length,
                            itemBuilder: (context, index) {
                              final post = filteredPosts[index];
                              return _buildRectangularCard(
                                context,
                                post['username'],
                                post['avatarUrl'],
                                post['imageUrl'],
                                post['caption'],
                                post['likes'].toString(),
                                post['comments'].toString(),
                                post['category'],
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedCategory == category['title']) {
                                      selectedCategory = null;
                                    } else {
                                      selectedCategory = category['title'];
                                    }
                                  });
                                },
                                child: _buildCircularCard(
                                  category['imageUrl']!,
                                  category['title']!,
                                  isSelected:
                                      selectedCategory == category['title'],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildRectangularCard(
  BuildContext context,
  String username,
  String avatarUrl,
  String postImageUrl,
  String caption,
  String likes,
  String comments,
  String category,
) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 16, backgroundImage: NetworkImage(avatarUrl)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(category,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(postImageUrl, height: 150, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(caption),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite_border),
              const SizedBox(width: 4),
              Text(likes),
              const SizedBox(width: 16),
              Icon(Icons.comment_outlined),
              const SizedBox(width: 4),
              Text(comments),
            ],
          )
        ],
      ),
    ),
  );
}

Widget _buildCircularCard(String imageUrl, String title,
    {bool isSelected = false}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(
          color: isSelected ? Colors.green : Colors.transparent, width: 2),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      children: [
        ClipOval(
          child:
              Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.green : Colors.black)),
        ),
      ],
    ),
  );
}

// Widget _buildCircularCard(String imageUrl, String title,
//     {bool isSelected = false}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: isSelected ? Colors.blue : Colors.transparent,
//               width: 3,
//             ),
//           ),
//           child: CircleAvatar(
//             radius: 45,
//             backgroundImage: NetworkImage(imageUrl),
//           ),
//         ),
//         Positioned(
//           bottom: 5,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: isSelected ? Colors.blue : Colors.black54,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }
