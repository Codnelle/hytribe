import 'package:flutter/material.dart';
import 'JoinGroupScreen.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allHives = [
    {
      'title': 'Tech Enthusiasts',
      'subtitle': 'Latest trends in technology and innovation.',
      'image':
          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=2940&auto=format&fit=crop',
      'members': 120,
      'isJoined': false,
      'category': 'Technology',
    },
    {
      'title': 'Fitness Freaks',
      'subtitle': 'Daily workouts, diets, and fitness tips.',
      'image':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=2940&auto=format&fit=crop',
      'members': 95,
      'isJoined': false,
      'category': 'Health',
    },
    {
      'title': 'Book Lovers',
      'subtitle': 'Discuss and explore the world of books.',
      'image':
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=2940&auto=format&fit=crop',
      'members': 150,
      'isJoined': false,
      'category': 'Entertainment',
    },
  ];

  final List<Map<String, dynamic>> filterOptions = [
    {'label': 'All', 'color': Colors.grey[200]},
    {'label': 'Trending', 'color': Colors.grey},
    {'label': 'Health', 'color': Colors.grey[200]},
    {'label': 'Sports', 'color': Colors.grey[200]},
    {'label': 'Technology', 'color': Colors.grey[200]},
    {'label': 'Entertainment', 'color': Colors.grey[200]},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Map<String, dynamic>> _getFilteredHives(
      List<Map<String, dynamic>> hives) {
    return hives.where((hive) {
      final matchesSearch =
          hive['title']!.toLowerCase().contains(_searchQuery) ||
              hive['subtitle']!.toLowerCase().contains(_searchQuery);

      final matchesFilter = _selectedFilter == 'All' ||
          hive['category'] == _selectedFilter ||
          (_selectedFilter == 'All' && hive['members'] > 100);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void toggleJoinGroup(int index) {
    setState(() {
      allHives[index]['isJoined'] = !allHives[index]['isJoined'];
      if (allHives[index]['isJoined']) {
        allHives[index]['members'] += 1;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined ${allHives[index]['title']}!')),
        );
      } else {
        allHives[index]['members'] -= 1;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Left ${allHives[index]['title']}')),
        );
      }
    });
  }

  void navigateToJoinGroup(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinGroupScreen(
          groupTitle: allHives[index]['title']!,
          groupImage: allHives[index]['image']!,
          groupMembers: allHives[index]['members'],
        ),
      ),
    );
  }

  Widget _buildGroupList(List<Map<String, dynamic>> hives) {
    final filteredHives = _getFilteredHives(hives);

    if (filteredHives.isEmpty) {
      return Center(
        child: Text(
          'No tribes found matching "${_searchController.text}"',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: filteredHives.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => navigateToJoinGroup(context, index),
          child: Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(filteredHives[index]['image']!),
                  ),
                  title: Text(filteredHives[index]['title']!),
                  subtitle: Text(filteredHives[index]['subtitle']!),
                  trailing: IconButton(
                    icon: Icon(
                      filteredHives[index]['isJoined']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          filteredHives[index]['isJoined'] ? Colors.red : null,
                    ),
                    onPressed: () => toggleJoinGroup(index),
                  ),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(filteredHives[index]['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage:
                                  NetworkImage(filteredHives[index]['image']!),
                            ),
                            Positioned(
                              left: 15,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                    filteredHives[index]['image']!),
                              ),
                            ),
                            Positioned(
                              left: 30,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                    filteredHives[index]['image']!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${filteredHives[index]['members']} Members'),
                      const Spacer(),
                      Chip(
                        label: Text(
                          filteredHives[index]['category']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => toggleJoinGroup(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: filteredHives[index]['isJoined']
                              ? Colors.grey
                              : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          filteredHives[index]['isJoined'] ? 'Leave' : 'Join',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final joinedTribes =
        allHives.where((hive) => hive['isJoined'] == true).toList();
    final discoverTribes =
        allHives.where((hive) => hive['isJoined'] == false).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tribes',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Discover'),
                  Tab(text: 'My Tribes'),
                ],
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Find...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: filterOptions
                    .map((filter) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(filter['label']),
                            selected: _selectedFilter == filter['label'],
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter =
                                    selected ? filter['label'] : 'All';
                              });
                            },
                            backgroundColor: filter['color'],
                            selectedColor: Colors.blue,
                            labelStyle: TextStyle(
                              color: _selectedFilter == filter['label']
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Discover Tab
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Tribes you might like',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(child: _buildGroupList(discoverTribes)),
                    ],
                  ),
                  // My Tribes Tab
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Your Tribes',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (joinedTribes.isEmpty)
                        const Expanded(
                          child: Center(
                            child: Text(
                              'You haven\'t joined any tribes yet.\nExplore tribes in the Discover tab!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        Expanded(child: _buildGroupList(joinedTribes)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
