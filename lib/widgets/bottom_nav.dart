import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:musicly/screens/MyMusic/my_music.dart';
import 'package:musicly/screens/playlists/play_lists_screen.dart';
import 'package:musicly/screens/settings/settings.dart';

import 'package:provider/provider.dart';
import '../controllers/DbProviders/fav_db_controller.dart';
import '../controllers/providers/bottom_nav_controller.dart';

import '../screens/favourites/favourite_screen.dart';

class BottomNav extends StatelessWidget {
  BottomNav({super.key});

  final int _currentSelectedIndex = 0;

  final pages = [
    const MyMusic(),
    const FavouriteScreen(),
    const PlayListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<FavouriteDb, BottomNavControll>(
          builder: (context, value, value2, child) {
        return PageView(
          children: [
            pages[value2.currentSelectedIndex],
          ],
        );
      }),
      bottomNavigationBar: GNav(
        selectedIndex: _currentSelectedIndex,
        onTabChange: (newIndex) {
          Provider.of<BottomNavControll>(context, listen: false)
              .bottomSwitch(newIndex);
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
