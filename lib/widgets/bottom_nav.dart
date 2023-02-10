import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:musicly/screens/my_music.dart';
import 'package:musicly/screens/playlists/play_lists_screen.dart';
import 'package:musicly/screens/settings/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/favourite_db.dart';
import '../screens/favourites/favourite_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentSelectedIndex = 0;
  final pages = const [
    MyMusic(),
    FavouriteScreen(),
    PlayListScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: FavoriteDb.favoriteSongs,
          builder:
              (BuildContext context, List<SongModel> music, Widget? child) {
            return PageView(
              children: [
                pages[_currentSelectedIndex],
              ],
            );
          }),
      bottomNavigationBar: GNav(
        selectedIndex: _currentSelectedIndex,
        onTabChange: (newIndex) {
          setState(() {
            _currentSelectedIndex = newIndex;
          });
        },
        tabBorderRadius: 30,
        tabActiveBorder: Border.all(color: Colors.green),
        padding: const EdgeInsets.all(11),
        tabBackgroundColor: const Color.fromARGB(255, 33, 42, 33),
        gap: 8,
        activeColor: const Color.fromARGB(255, 13, 255, 0),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        tabs: const [
          GButton(
            icon: Icons.music_note,
            text: 'My Music',
            iconColor: Colors.white,
          ),
          GButton(
            icon: Icons.favorite_outline,
            text: 'Favourites',
            iconColor: Colors.white,
          ),
          GButton(
            icon: Icons.playlist_add,
            text: 'PlayLists',
            iconColor: Colors.white,
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
            iconColor: Colors.white,
          )
        ],
      ),
    );
  }
}
