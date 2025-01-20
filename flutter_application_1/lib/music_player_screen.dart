import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; 
import 'audio_player.dart';
import 'radio_screen.dart';
import 'search_screen.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String title;
  final String artist;
  final String albumArt;
  final String genres;
  final String dateTime;
  final String mediaSource;

  const MusicPlayerScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.genres,
    required this.dateTime,
    required this.mediaSource,
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
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); 
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdReady = true;
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                },
                icon: const Icon(Icons.skip_previous),
                iconSize: 40,
              ),
              IconButton(
                onPressed: () {
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
                },
                icon: const Icon(Icons.skip_next),
                iconSize: 40,
              ),
            ],
          ),
          const SizedBox(height: 20),

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
