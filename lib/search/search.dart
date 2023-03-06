import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicly/controllers/all_songs.dart';
import 'package:musicly/screens/now_playing.dart';
import 'package:musicly/providers/search_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../widgets/fav_button.dart';
import '../screens/my_music.dart';
import '../widgets/song_model.dart';

class SearchSongs extends StatelessWidget {
  const SearchSongs({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SearchController>(context, listen: false).songsLoadings();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<SearchController>(
          builder: (context, values, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                      controller: searchEditingController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => values.updateList(value),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                        hintText: 'Search here...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search_outlined),
                      )),
                  values.foundSongs.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: values.foundSongs.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              shadowColor:
                                  const Color.fromARGB(255, 98, 255, 103),
                              color: const Color.fromARGB(255, 27, 28, 27),
                              child: ListTile(
                                title: Text(
                                  values.foundSongs[index].displayNameWOExt,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                subtitle: Text(
                                  values.foundSongs[index].artist == "<unknown>"
                                      ? "Unknown Artist"
                                      : values.foundSongs[index].artist
                                          .toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  GetAllSongController.audioPlayer
                                      .setAudioSource(
                                          GetAllSongController.createSongList(
                                              values.foundSongs),
                                          initialIndex: index);
                                  GetAllSongController.audioPlayer.play();
                                  context
                                      .read<SongModelProvider>()
                                      .setId(values.foundSongs[index].id);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return NowPlaying(
                                          songModelList: values.foundSongs);
                                    },
                                  ));
                                },
                                trailing: FavButton(
                                  songFavorite: startSong[index],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No Results Found',
                            style: TextStyle(
                                fontSize: 24, color: Colors.greenAccent),
                          ),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

List<SongModel> allsongs = [];
List<SongModel> foundSongs = [];
final audioPlayer = AudioPlayer();
final audioQuery = OnAudioQuery();
TextEditingController searchEditingController = TextEditingController();
