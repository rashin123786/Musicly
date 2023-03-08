import 'package:flutter/material.dart';
import 'package:musicly/controllers/DbProviders/fav_db_controller.dart';

import 'package:musicly/screens/Nowplay/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/all_songs.dart';

import '../../widgets/styles.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          title: Text(
            'Favourites',
            style: AppStyles().myMusicStyleHead,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Consumer<FavouriteDb>(builder: (context, value, child) {
                  if (value.favoriteSongs.isEmpty) {
                    return Center(
                      child: Text(
                        'No Favorite Songs',
                        style: AppStyles().myMusicStyleHead,
                      ),
                    );
                  } else {
                    return SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: ListView.builder(
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: Card(
                                elevation: 5,
                                shadowColor:
                                    const Color.fromARGB(255, 98, 255, 103),
                                color: const Color.fromARGB(255, 27, 28, 27),
                                child: ListTile(
                                  leading: QueryArtworkWidget(
                                    id: value.favoriteSongs[index].id,
                                    type: ArtworkType.AUDIO,
                                  ),
                                  title: Text(
                                    value.favoriteSongs[index].displayNameWOExt,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    value.favoriteSongs[index].artist
                                        .toString(),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                        color: Colors.blueGrey),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.greenAccent,
                                    ),
                                    onPressed: () {
                                      value.delete(
                                          value.favoriteSongs[index].id);
                                      const snackbar = SnackBar(
                                        content: Text(
                                          'Song Deleted From your Favourites',
                                        ),
                                        duration: Duration(seconds: 1),
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 0, 0),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    },
                                  ),
                                  onTap: () {
                                    List<SongModel> favoriteList = [
                                      ...value.favoriteSongs
                                    ];
                                    GetAllSongController.audioPlayer.stop();
                                    GetAllSongController.audioPlayer
                                        .setAudioSource(
                                            GetAllSongController.createSongList(
                                                favoriteList),
                                            initialIndex: index);
                                    GetAllSongController.audioPlayer.play();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NowPlaying(
                                              songModelList: favoriteList),
                                        ));
                                  },
                                ),
                              ),
                            );
                          }),
                          itemCount: value.favoriteSongs.length,
                        ));
                  }
                }),
              )
            ],
          ),
        ));
  }
}
