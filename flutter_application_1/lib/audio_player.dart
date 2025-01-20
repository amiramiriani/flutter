import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String title;
  final String artist;
  final String albumArt;
  final String genres ;
  final String dateTime;
  final String mediaSource;

  const AudioPlayerScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.genres ,
    required this.dateTime,
    required this.mediaSource,
  });

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double currentProgress = 0.0;
  double currentVolume = 1.0; // Default volume
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen for duration changes and update totalDuration
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        totalDuration = duration ?? Duration.zero;
      });
    });

    // Initialize the audio source
    _audioPlayer.setUrl(widget.mediaSource);

    // Listen for position changes to update current progress
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        if (totalDuration.inMilliseconds > 0) {
          currentProgress = position.inMilliseconds / totalDuration.inMilliseconds;
        } else {
          currentProgress = 0.0;
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void togglePlayPause() async {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
       _audioPlayer.play();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void seekTo(double value) {
    final position = Duration(
      milliseconds: (value * totalDuration.inMilliseconds).toInt(),
    );
    _audioPlayer.seek(position);
  }

  void setVolume(double value) {
    _audioPlayer.setVolume(value);
    setState(() {
      currentVolume = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300), // Animation duration
            curve: Curves.easeInOut, // Optional: Customize the animation curve
            margin: const EdgeInsets.all(25),
            width: isPlaying ? 300 : 280, // Dynamic size with animation
            height: isPlaying ? 300 : 280, // Dynamic size with animation
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
            image: DecorationImage(
                image: AssetImage(widget.albumArt),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Seek Bar
          if (totalDuration > Duration.zero) ...[
            Slider(
              value: currentProgress,
              onChanged: (double value) {
                if (totalDuration.inMilliseconds > 0) {
                  seekTo(value);
                }
              },
              min: 0.0,
              max: 1.0,
              activeColor: const Color.fromARGB(255, 100, 100, 100),
              inactiveColor: const Color.fromARGB(255, 160, 160, 160),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    formatDuration(
                      Duration(
                        milliseconds: (currentProgress * totalDuration.inMilliseconds).toInt(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(formatDuration(totalDuration)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          
          
          // Volume Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0), // Padding to center the volume slider
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.volume_down, color: Color.fromARGB(255, 136, 136, 136)),
                Expanded(
                  child: Slider(
                    value: currentVolume,
                    onChanged: (value) {
                      setVolume(value);
                    },
                    min: 0.0,
                    max: 1.0,
                    activeColor: const Color.fromARGB(255, 100, 100, 100),
                    inactiveColor: const Color.fromARGB(255, 185, 185, 185),
                  ),
                ),
                const Icon(Icons.volume_up, color: Colors.black),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Song Information
          Text(
            widget.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            widget.artist,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 5),
          // Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // Implement skip to previous track functionality
                },
                icon: const Icon(Icons.skip_previous),
                iconSize: 30,
                color: Colors.black,
              ),
              IconButton(
                onPressed: togglePlayPause,
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Implement skip to next track functionality
                },
                icon: const Icon(Icons.skip_next),
                iconSize: 30,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Utility function to format the duration to mm:ss
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
