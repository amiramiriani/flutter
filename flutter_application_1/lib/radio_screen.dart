import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening URLs
import 'main.dart';
import 'search_screen.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  int _currentIndex = 1; // Start with the 'Radio' page

  @override
  Widget build(BuildContext context) {
    // List of radio stations with title, URL, and logo
    final List<Map<String, String>> radioStations = [
      {
        'title': 'Radio Javan',
        'url': 'https://player.iranseda.ir/live-player/?VALID=TRUE&CH=13&t=b&auto=true&SAVE=TRUE',
        'image': 'assets/radio images/radio-javan.png', // Example URL, use actual image URL
      },
      {
        'title': 'Radio Avaa',
        'url': 'https://player.iranseda.ir/live-player/?VALID=TRUE&CH=21&t=b&auto=true&SAVE=TRUE',
        'image': 'assets/radio images/radio-avaa.png', // Example URL, use actual image URL
      },
      {
        'title': 'Radio Salamat',
        'url': 'https://player.iranseda.ir/live-player/?VALID=TRUE&CH=17&t=b&auto=true&SAVE=TRUE',
        'image': 'assets/radio images/radio-salamat.png', // Example URL, use actual image URL
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Radio Stations'),
          centerTitle: true,
          automaticallyImplyLeading: false, // Disable back button in AppBar
        ),
        body: ListView.builder(
          itemCount: radioStations.length,
          itemBuilder: (context, index) {
            final station = radioStations[index];
            return ListTile(
              leading: Image.asset(station['image']!, width: 50, height: 50), // Use local images
              title: Text(station['title']!),
              subtitle: Text(station['url']!),
              onTap: () {
                _launchURL(station['url']!);
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex, // Make sure to set the current index
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MusicSelectorScreen(),
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

  // Function to open the URL using the url_launcher package
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
