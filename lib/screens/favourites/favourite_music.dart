import 'package:musicly/controllers/DbProviders/fav_db_controller.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/fav_music_play_controller.dart';

class FavMusicPlay extends StatelessWidget {
  const FavMusicPlay({super.key, required this.songFavoriteMusicPlaying});
  final SongModel songFavoriteMusicPlaying;

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavouriteDb, FavMusicPlayController>(
      builder: (context, value, value2, child) {
        return IconButton(
          onPressed: () {
            value2.favButtons(context);
          },
          icon: value.isFavor(songFavoriteMusicPlaying)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.greenAccent,
                )
              : const Icon(
                  Icons.favorite_outline,
                  color: Colors.greenAccent,
                ),
        );
      },
    );
  }
}
