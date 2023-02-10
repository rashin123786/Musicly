import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';

import '../../db/favourite_db.dart';

class FavMusicPlay extends StatefulWidget {
  const FavMusicPlay({super.key, required this.songFavoriteMusicPlaying});
  final SongModel songFavoriteMusicPlaying;

  @override
  State<FavMusicPlay> createState() => _FavMusicPlayState();
}

class _FavMusicPlayState extends State<FavMusicPlay> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
          return IconButton(
            onPressed: () {
              setState(() {
                if (FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)) {
                  FavoriteDb.delete(widget.songFavoriteMusicPlaying.id);
                  const Icon(
                    Icons.favorite_outline,
                    color: Colors.greenAccent,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(milliseconds: 350),
                      content: Text('Removed From Favourite'),
                    ),
                  );
                } else {
                  FavoriteDb.add(widget.songFavoriteMusicPlaying);
                  const Icon(
                    Icons.favorite,
                    color: Colors.greenAccent,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(milliseconds: 350),
                      content: Text('Added To Favourite'),
                    ),
                  );
                }
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                FavoriteDb.favoriteSongs.notifyListeners();
              });
            },
            icon: FavoriteDb.isFavor(widget.songFavoriteMusicPlaying)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.greenAccent,
                  )
                : const Icon(
                    Icons.favorite_outline,
                    color: Colors.greenAccent,
                  ),
          );
        });
  }
}
