import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicly/screens/search.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/all_songs.dart';
import '../widgets/all_songs_view.dart';
import '../widgets/styles.dart';

class MyMusic extends StatefulWidget {
  const MyMusic({super.key});

  @override
  State<MyMusic> createState() => _MyMusicState();
}

List<SongModel> startSong = [];

class _MyMusicState extends State<MyMusic> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool sizedBoxSpacing = false;
  List<SongModel> allSongs = [];
  bool gridopt = false;
  void playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log('Error parsing Song');
    }
  }

  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          sizedBoxSpacing = true;
        });
      }
    });
    super.initState();

    reqeustStoragePermission();
  }

  Future<void> reqeustStoragePermission() async {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
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
                            ListShow().listShow;
                          } else {
                            GridShow().gridShow;
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
                  child: gridopt ? GridShow().gridShow : ListShow().listShow,
                )
              ],
            ),
          ),
        ));
  }
}
