import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicly/screens/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../widgets/fav_button.dart';
import 'my_music.dart';

class SearchSongs extends StatefulWidget {
  const SearchSongs({super.key});

  @override
  State<SearchSongs> createState() => _SearchSongsState();
}

List<SongModel> allsongs = [];
List<SongModel> foundSongs = [];
final audioPlayer = AudioPlayer();
final audioQuery = OnAudioQuery();

class _SearchSongsState extends State<SearchSongs> {
  @override
  void initState() {
    songsLoading();

    super.initState();
  }

  playSong(String? uri) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
    } on Exception {
      log('Error parsing song');
    }
  }

  void updateList(String enteredText) async {
    List<SongModel> results = [];
    if (enteredText.isEmpty) {
      results = allsongs;
    } else {
      results = allsongs
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredText.toLowerCase()))
          .toList();
    }
    setState(() {
      foundSongs = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: [
            TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => updateList(value),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.grey,
                  hintText: 'Search here...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search_outlined),
                )),
            foundSongs.isEmpty
                ? const Center(
                    child: Text(
                      'No Results Found',
                      style: TextStyle(fontSize: 24, color: Colors.greenAccent),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: foundSongs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shadowColor: const Color.fromARGB(255, 98, 255, 103),
                        color: const Color.fromARGB(255, 27, 28, 27),
                        child: ListTile(
                          title: Text(
                            foundSongs[index].displayNameWOExt,
                            style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis),
                          ),
                          subtitle: Text(
                            foundSongs[index].artist == "<unknown>"
                                ? "Unknown Artist"
                                : foundSongs[index].artist.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            playSong(foundSongs[index].uri);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NowPlaying(
                                    songModelList: foundSongs,
                                  );
                                },
                              ),
                            );
                          },
                          trailing: FavButton(
                            songFavorite: startSong[index],
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }

  void songsLoading() async {
    allsongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    foundSongs = allsongs;
  }
}
