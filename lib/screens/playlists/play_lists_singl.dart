import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:musicly/model/musicly_model.dart';
import 'package:musicly/screens/Nowplay/now_playing.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../controllers/providers/all_songs.dart';

import '../../widgets/song_model.dart';
import '../../widgets/styles.dart';
import 'all_song_playlist.dart';

class PlayListSingle extends StatelessWidget {
  final MusiclyModel playlist;
  final int findex;
  const PlayListSingle(
      {super.key, required this.playlist, required this.findex});

  @override
  Widget build(BuildContext context) {
    late List<SongModel> songPlaylist = [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.greenAccent,
                    size: 30,
                  ),
                ),
                Text(playlist.name, style: AppStyles().myMusicStyleHead),
                const SizedBox(
                  width: 50,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<MusiclyModel>('playlistDb').listenable(),
                  builder: (context, music, child) {
                    songPlaylist =
                        listPlaylist(music.values.toList()[findex].songId);
                    return SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: songPlaylist.isEmpty
                          ? Center(
                              child: Text(
                                'Add Songs',
                                style: AppStyles().myMusicStyleHead,
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, right: 6),
                                  child: Card(
                                    elevation: 5,
                                    shadowColor:
                                        const Color.fromARGB(255, 98, 255, 103),
                                    color:
                                        const Color.fromARGB(255, 27, 28, 27),
                                    child: ListTile(
                                      leading: QueryArtworkWidget(
                                        id: songPlaylist[index].id,
                                        type: ArtworkType.AUDIO,
                                      ),
                                      title: Text(
                                        songPlaylist[index].title,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        songPlaylist[index].artist!,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueGrey),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          playlist.deleteData(
                                              songPlaylist[index].id);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      onTap: () {
                                        List<SongModel> newMusicList = [
                                          ...songPlaylist
                                        ];
                                        GetAllSongController.audioPlayer.stop();
                                        GetAllSongController.audioPlayer
                                            .setAudioSource(
                                                GetAllSongController
                                                    .createSongList(
                                                        newMusicList),
                                                initialIndex: index);

                                        context
                                            .read<SongModelProvider>()
                                            .setId(newMusicList[index].id);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return NowPlaying(
                                            songModelList: songPlaylist,
                                            count: songPlaylist.length,
                                          );
                                        }));
                                      },
                                    ),
                                  ),
                                );
                              }),
                              itemCount: songPlaylist.length,
                            ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return PlayListAdd(
                playlist: playlist,
              );
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < GetAllSongController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetAllSongController.songscopy[i].id == data[j]) {
          plsongs.add(GetAllSongController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
