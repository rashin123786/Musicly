import 'package:flutter/material.dart';

import 'package:musicly/screens/search/search.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:provider/provider.dart';

import '../../controllers/providers/all_songs.dart';
import '../../controllers/providers/my_music_controller.dart';
import '../../widgets/all_songs_view.dart';
import '../../widgets/styles.dart';

List<SongModel> startSong = [];

class MyMusic extends StatefulWidget {
  const MyMusic({super.key});

  @override
  State<MyMusic> createState() => _MyMusicState();
}

bool gridopt = false;

class _MyMusicState extends State<MyMusic> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyMusicController>(context, listen: false)
          .reqeustStoragePermission();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetAllSongController.audioPlayer.currentIndexStream.listen((index) {});
    });
    return Consumer<MyMusicController>(
      builder: (context, value, child) {
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
                          GestureDetector(
                            child: const Icon(
                              Icons.grid_view,
                              color: Colors.greenAccent,
                            ),
                            onTap: () {
                              setState(() {
                                if (gridopt) {
                                  ViewType().listShow;
                                } else {
                                  ViewType().gridShow;
                                }
                                gridopt = !gridopt;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: gridopt
                              ? ViewType().gridShow
                              : ViewType().listShow),
                    ]),
              ),
            ));
      },
    );
  }
}

bool sizedBoxSpacing = false;
