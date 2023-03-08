import 'package:flutter/material.dart';
import 'package:musicly/screens/Nowplay/now_playing.dart';
import 'package:musicly/widgets/song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../controllers/providers/all_songs.dart';
import '../controllers/DbProviders/fav_db_controller.dart';
import '../screens/MyMusic/my_music.dart';
import 'fav_button.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();
bool sizedBoxSpacing = false;
List<SongModel> allSongs = [];

class AllSongsView with ChangeNotifier {
  bool gridopt = false;
  void viewChange() {
    if (gridopt) {
      listShow;
      notifyListeners();
    } else {
      gridShow;
      notifyListeners();
    }
    gridopt = !gridopt;
    notifyListeners();
  }

  FutureBuilder<List<SongModel>> listShow = FutureBuilder<List<SongModel>>(
    future: _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL),
    builder: ((context, items) {
      if (items.data == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (items.data!.isEmpty) {
        return const Center(
          child: Text(
            'No Songs found',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      startSong = items.data!;
      if (!FavouriteDb.isInitialized) {
        Provider.of<FavouriteDb>(context, listen: false)
            .initialize(items.data!);
      }
      GetAllSongController.songscopy = items.data!;

      return ListView.builder(
        itemBuilder: ((context, index) {
          allSongs.addAll(items.data!);
          return Card(
            elevation: 5,
            shadowColor: const Color.fromARGB(255, 98, 255, 103),
            color: const Color.fromARGB(255, 27, 28, 27),
            child: ListTile(
              leading: QueryArtworkWidget(
                id: items.data![index].id,
                type: ArtworkType.AUDIO,
              ),
              title: Text(
                items.data![index].displayNameWOExt,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis, color: Colors.white),
              ),
              subtitle: Text(
                items.data![index].artist.toString() == "<unknown>"
                    ? "Unknown Artist"
                    : items.data![index].artist.toString(),
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'poppins',
                    fontSize: 12,
                    color: Colors.blueGrey),
              ),
              trailing: FavButton(
                songFavorite: startSong[index],
              ),
              onTap: () {
                GetAllSongController.audioPlayer.setAudioSource(
                    GetAllSongController.createSongList(items.data!),
                    initialIndex: index);

                context.read<SongModelProvider>().setId(items.data![index].id);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NowPlaying(
                      songModelList: items.data!,
                      count: items.data!.length,
                    );
                  }),
                );
              },
            ),
          );
        }),
        itemCount: items.data!.length,
      );
    }),
  );

  //Grid Show--------------------

  FutureBuilder<List<SongModel>> gridShow = FutureBuilder<List<SongModel>>(
    future: _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL),
    builder: ((context, items) {
      if (items.data == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (items.data!.isEmpty) {
        return const Center(
          child: Text(
            'No Songs found',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      startSong = items.data!;
      if (!FavouriteDb.isInitialized) {
        Provider.of<FavouriteDb>(context, listen: false)
            .initialize(items.data!);
      }
      GetAllSongController.songscopy = items.data!;

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (1 / 0.7),
            crossAxisSpacing: 2,
            crossAxisCount: 2),
        itemBuilder: ((context, index) {
          allSongs.addAll(items.data!);
          return InkWell(
            onTap: () {
              GetAllSongController.audioPlayer.setAudioSource(
                  GetAllSongController.createSongList(items.data!),
                  initialIndex: index);

              context.read<SongModelProvider>().setId(items.data![index].id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NowPlaying(
                      songModelList: items.data!,
                      count: items.data!.length,
                    );
                  },
                ),
              );
            },
            child: Card(
              elevation: 5,
              shadowColor: const Color.fromARGB(255, 98, 255, 103),
              color: const Color.fromARGB(255, 27, 28, 27),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QueryArtworkWidget(
                        id: items.data![index].id,
                        type: ArtworkType.AUDIO,
                      ),
                      FavButton(
                        songFavorite: startSong[index],
                      ),
                    ],
                  ),
                  Text(
                    items.data![index].displayNameWOExt,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis, color: Colors.white),
                  ),
                  Text(
                    items.data![index].artist.toString() == "<unknown>"
                        ? "Unknown Artist"
                        : items.data![index].artist.toString(),
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'poppins',
                        fontSize: 12,
                        color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          );
        }),
        itemCount: items.data!.length,
      );
    }),
  );
}
