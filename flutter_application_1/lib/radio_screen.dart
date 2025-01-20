import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'search_screen.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> radioStations = [
      {
        'title': 'Radio Javan',
        'url': 'https://player.iranseda.ir/live-player/?VALID=TRUE&CH=13&t=b&auto=true&SAVE=TRUE',
        'image': 'assets/radio images/radio-javan.png',
      },
      {
        'title': 'Radio Avaa',
        'url': 'https://player.iranseda.ir/live-player/?VALID=TRUE&CH=21&t=b&auto=true&SAVE=TRUE',
        'image': 'assets/radio images/radio-avaa.png',
      },
      {
        'title': 'Radio Salamat',
        'url': 'https://player.iranseda.ir/live-player/?VALID=TRUE&CH=17&t=b&auto=true&SAVE=TRUE',
        'image': 'assets/radio images/radio-salamat.png',
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Radio Stations'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          itemCount: radioStations.length,
          itemBuilder: (context, index) {
            final station = radioStations[index];
            return ListTile(
              leading: Image.asset(station['image']!, width: 50, height: 50),
              title: Text(station['title']!),
              subtitle: Text(station['url']!),
              onTap: () {
                _launchURL(station['url']!);
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
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

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
