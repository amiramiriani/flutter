import 'package:flutter/material.dart';
import 'music_list.dart'; // Import your music list here
import 'music_player_screen.dart'; // Import the MusicPlayerScreen
import 'main.dart';
import 'radio_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredMusicList = musicList;
  int _currentIndex = 2; // Start on the 'Search' page

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterMusic);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMusic);
    _searchController.dispose();
    super.dispose();
  }

  void _filterMusic() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredMusicList = musicList.where((song) {
        return song['title']!.toLowerCase().contains(query) ||
               song['artist']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<bool> _onWillPop() async {
    return false; // Prevents the back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Music'),
          centerTitle: true,
          automaticallyImplyLeading: false, // This removes the back button
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by Title or Artist',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: _filteredMusicList.isEmpty
                    ? const Center(child: Text('No results found'))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _filteredMusicList.length,
                        itemBuilder: (context, index) {
                          final song = _filteredMusicList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicPlayerScreen(
                                    title: song['title']!,
                                    artist: song['artist']!,
                                    albumArt: song['albumArt']!,
                                    genres: song['genres']!,
                                    dateTime: song['dateTime']!,
                                    mediaSource: song['mediaSource']!,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        song['albumArt']!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.broken_image, size: 1000, color: Colors.grey);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    song['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    song['artist']!,
                                    style: const TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
       bottomNavigationBar: BottomNavigationBar(
  currentIndex: _currentIndex, // Set the current index to highlight the correct item
  type: BottomNavigationBarType.fixed,
  selectedItemColor: Theme.of(context).colorScheme.primary, // Use the primary color from the theme
  unselectedItemColor: Colors.grey, // Use grey for unselected icons
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
    BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
  ],
  onTap: (index) {
    setState(() {
      _currentIndex = index; // Update the selected index when the user taps on the item
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MusicSelectorScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RadioPage(),
        ),
      );
    } else if (index == 2) {
      // Handle search logic if required
    }
  },
),
      ),
    );
  }
}
