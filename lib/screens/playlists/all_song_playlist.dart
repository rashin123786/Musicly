import 'package:flutter/material.dart';

import 'package:musicly/model/musicly_model.dart';
import 'package:musicly/providers/DbProviders/playlist_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../widgets/styles.dart';
import '../../search/search.dart';

class PlayListAdd extends StatelessWidget {
  final MusiclyModel playlist;
  const PlayListAdd({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
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
                      Text(
                        'Add Songs To Playlist',
                        style: AppStyles().myMusicStyleHead,
                      ),
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
                      child: SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: FutureBuilder<List<SongModel>>(
                              future: audioQuery.querySongs(
                                  sortType: null,
                                  orderType: OrderType.ASC_OR_SMALLER,
                                  uriType: UriType.EXTERNAL,
                                  ignoreCase: true),
                              builder: (context, item) {
                                if (item.data == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (item.data!.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No Song Available',
                                      style: AppStyles().myMusicStyleHead,
                                    ),
                                  );
                                }
                                return ListView.builder(
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
                                                id: item.data![index].id,
                                                type: ArtworkType.AUDIO,
                                              ),
                                              title: Text(
                                                item.data![index]
                                                    .displayNameWOExt,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                '${item.data![index].artist == "<unknown>" ? "Unknown Artist" : item.data![index].artist}',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blueGrey),
                                              ),
                                              trailing: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Consumer<PlayListDb>(
                                                    builder: (context, value,
                                                        child) {
                                                      return Wrap(children: [
                                                        !playlist.isValueIn(item
                                                                .data![index]
                                                                .id)
                                                            ? IconButton(
                                                                onPressed: () {
                                                                  songAddPlaylist(
                                                                      item.data![
                                                                          index],
                                                                      context);
                                                                  value
                                                                      .notifyListeners();
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .green,
                                                                ))
                                                            : IconButton(
                                                                onPressed: () {
                                                                  playlist.deleteData(item
                                                                      .data![
                                                                          index]
                                                                      .id);
                                                                  value
                                                                      .notifyListeners();

                                                                  const snackBar =
                                                                      SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'Song deleted from playlist',
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            350),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                },
                                                                icon:
                                                                    const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              25),
                                                                  child: Icon(
                                                                    Icons
                                                                        .minimize,
                                                                    color: Colors
                                                                        .greenAccent,
                                                                  ),
                                                                ))
                                                      ]);
                                                    },
                                                  )),
                                            )));
                                  }),
                                  itemCount: item.data!.length,
                                );
                              })),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void songAddPlaylist(SongModel data, context) {
    playlist.add(data.id);

    const snackBar1 = SnackBar(
        duration: Duration(milliseconds: 300),
        content: Text(
          'Song added to Playlist',
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  }
}
