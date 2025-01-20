import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Import the Google Mobile Ads package
import 'audio_player.dart'; // Import the audio player screen
import 'radio_screen.dart';
import 'search_screen.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String title;
  final String artist;
  final String albumArt;
  final String genres;
  final String dateTime;
  final String mediaSource; // Path to the audio file

  const MusicPlayerScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.genres,
    required this.dateTime,
    required this.mediaSource, // Path to the audio file
  });

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd(); // Load the banner ad when the screen is initialized
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Dispose the banner ad when the screen is disposed
    super.dispose();
  }

  // Load the banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Replace with your actual ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdReady = true; // Set the ad as ready
          });
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Column(
        children: [
          // Now Playing Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(widget.albumArt),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.artist,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text('Genres: ${widget.genres}'),
                    Text('Publish: ${widget.dateTime}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Playback controls with play button linked to AudioPlayerScreen
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // You can add functionality for skipping to previous track
                },
                icon: const Icon(Icons.skip_previous),
                iconSize: 40,
              ),
              IconButton(
                onPressed: () {
                  // Navigate to the AudioPlayerScreen (audio player)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioPlayerScreen(
                        title: widget.title,
                        artist: widget.artist,
                        albumArt: widget.albumArt,
                        genres: widget.genres,
                        dateTime: widget.dateTime,
                        mediaSource: widget.mediaSource,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                iconSize: 60,
              ),
              IconButton(
                onPressed: () {
                  // You can add functionality for skipping to next track
                },
                icon: const Icon(Icons.skip_next),
                iconSize: 40,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Check if banner ad is ready and display it
          if (_isBannerAdReady)
            Container(
              alignment: Alignment.center,
              child: AdWidget(ad: _bannerAd!),
              width: _bannerAd?.size.width.toDouble(),
              height: _bannerAd?.size.height.toDouble(),
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
          if (index == 0) {
            // Handle Library Navigation
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
    );
  }
}
