import 'package:flutter/material.dart';

import 'package:musicly/screens/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../controllers/all_songs.dart';
import '../../db/favourite_db.dart';
import '../../widgets/styles.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
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
                      child: ValueListenableBuilder(
                          valueListenable: FavoriteDb.favoriteSongs,
                          builder: (BuildContext ctx,
                              List<SongModel> favoriteData, Widget? child) {
                            if (favoriteData.isEmpty) {
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
                                        padding: const EdgeInsets.only(
                                            left: 6, right: 6),
                                        child: Card(
                                          elevation: 5,
                                          shadowColor: const Color.fromARGB(
                                              255, 98, 255, 103),
                                          color: const Color.fromARGB(
                                              255, 27, 28, 27),
                                          child: ListTile(
                                            leading: QueryArtworkWidget(
                                              id: favoriteData[index].id,
                                              type: ArtworkType.AUDIO,
                                            ),
                                            title: Text(
                                              favoriteData[index]
                                                  .displayNameWOExt,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                              favoriteData[index]
                                                  .artist
                                                  .toString(),
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 12,
                                                  color: Colors.blueGrey),
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.favorite,
                                                color: Colors.greenAccent,
                                              ),
                                              onPressed: () {
                                                FavoriteDb.favoriteSongs
                                                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                                    .notifyListeners();
                                                FavoriteDb.delete(
                                                    favoriteData[index].id);
                                                const snackbar = SnackBar(
                                                  content: Text(
                                                    'Song Deleted From your Favourites',
                                                  ),
                                                  duration:
                                                      Duration(seconds: 1),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 0, 0, 0),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackbar);
                                              },
                                            ),
                                            onTap: () {
                                              List<SongModel> favoriteList = [
                                                ...favoriteData
                                              ];
                                              GetAllSongController.audioPlayer
                                                  .stop();
                                              GetAllSongController.audioPlayer
                                                  .setAudioSource(
                                                      GetAllSongController
                                                          .createSongList(
                                                              favoriteList),
                                                      initialIndex: index);
                                              GetAllSongController.audioPlayer
                                                  .play();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        NowPlaying(
                                                            songModelList:
                                                                favoriteList),
                                                  ));
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                                    itemCount: favoriteData.length,
                                  ));
                            }
                          }),
                    )
                  ],
                ),
              ));
        });
  }
}
