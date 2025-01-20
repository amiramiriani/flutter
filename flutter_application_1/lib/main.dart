import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'music_player_screen.dart';
import 'music_list.dart';
import 'radio_screen.dart'; 
import 'search_screen.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iTunes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 0, 0)),
        useMaterial3: true,
      ),
      home: const MusicSelectorScreen(),
    );
  }
}

int _selectedIndex = 0;

List<String> _getUniqueGenres() {
  final genres = <String>{};
  for (var song in musicList) {
    genres.add(song['genres']!);
  }
  return genres.toList();
}

class MusicSelectorScreen extends StatefulWidget {
  const MusicSelectorScreen({super.key});

  @override
  _MusicSelectorScreenState createState() => _MusicSelectorScreenState();
}

class _MusicSelectorScreenState extends State<MusicSelectorScreen> {
  String? selectedGenre;
  String? selectedArtist;

  @override
  Widget build(BuildContext context) {
    final screenWidthInInches = calculateScreenWidthInInches(context);
    final itemsPerInch = 1.5;
    final crossAxisCount = (screenWidthInInches * itemsPerInch).floor();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              'assets/icons/itunes.svg',
              height: 36,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Library',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  _buildGenreSelection(),
                  const Divider(),
                  _buildArtistSelection(),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: selectedGenre == null && selectedArtist == null
                  ? _buildAllMusic(screenWidthInInches, crossAxisCount) 
                  : _buildSongsForSelectedGenreAndArtist(screenWidthInInches, crossAxisCount),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          ],
          onTap: (index) {
            _selectedIndex = index;

            if (index == 0) {

            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RadioPage(),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            }
          },
        ),
      ),
    );
  }


  double calculateScreenWidthInInches(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final widthInPixels = size.width;
    final dpi = pixelRatio * 160;
    final widthInInches = widthInPixels / dpi;
    return widthInInches;
  }

  Widget _buildGenreSelection() {
    final genres = _getUniqueGenres();
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedGenre = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: selectedGenre == null ? Colors.red : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              'All',
              style: TextStyle(
                color: selectedGenre == null ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        ...genres.map((genre) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedGenre = genre;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: selectedGenre == genre ? Colors.red : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                genre,
                style: TextStyle(
                  color: selectedGenre == genre ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildArtistSelection() {
    final artists = _getUniqueArtists();
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedArtist = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: selectedArtist == null ? Colors.red : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              'All',
              style: TextStyle(
                color: selectedArtist == null ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        ...artists.map((artist) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedArtist = artist;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: selectedArtist == artist ? Colors.red : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                artist,
                style: TextStyle(
                  color: selectedArtist == artist ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAllMusic(double screenWidthInInches, int crossAxisCount) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      padding: const EdgeInsets.all(30),
      itemCount: musicList.length,
      itemBuilder: (context, index) {
        final song = musicList[index];
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
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSongsForSelectedGenreAndArtist(double screenWidthInInches, int crossAxisCount) {
    final filteredSongs = musicList.where((song) {
      final genreMatch = selectedGenre == null || song['genres'] == selectedGenre;
      final artistMatch = selectedArtist == null || song['artist'] == selectedArtist;
      return genreMatch && artistMatch;
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      padding: const EdgeInsets.all(30),
      itemCount: filteredSongs.length,
      itemBuilder: (context, index) {
        final song = filteredSongs[index];
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
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> _getUniqueArtists() {
    final artists = <String>{};
    for (var song in musicList) {
      artists.add(song['artist']!);
    }
    return artists.toList();
  }
}
