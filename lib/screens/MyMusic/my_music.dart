import 'package:flutter/material.dart';

import 'package:musicly/screens/search/search.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../widgets/all_songs_view.dart';
import '../../widgets/styles.dart';

List<SongModel> startSong = [];

class MyMusic extends StatelessWidget {
  const MyMusic({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_element
    Future<void> reqeustStoragePermission() async {
      Permission.storage.request();
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Musicly',
            style: AppStyles().myMusicStyleHead,
          ),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchSongs(),
                    ));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Songs',
                      style: AppStyles().myMusicStyleHead,
                    ),
                    Consumer<AllSongsView>(
                      builder: (context, value, child) {
                        return GestureDetector(
                          child: const Icon(
                            Icons.grid_view,
                            color: Colors.greenAccent,
                          ),
                          onTap: () {
                            value.viewChange();
                          },
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<AllSongsView>(
                  builder: (context, value, child) {
                    return Expanded(
                        child: value.gridopt ? value.gridShow : value.listShow);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
