import 'package:flutter/material.dart';
import 'package:musicly/providers/DbProviders/fav_db_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavMusicPlayController with ChangeNotifier {
  late final SongModel songFavoriteMusicPlaying;
  void favButtons(context) {
    if (Provider.of<FavouriteDb>(context).isFavor(songFavoriteMusicPlaying)) {
      Provider.of<FavouriteDb>(context).delete(songFavoriteMusicPlaying.id);
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
      Provider.of<FavouriteDb>(context).add(songFavoriteMusicPlaying);
      const Icon(
        Icons.favorite,
        color: Colors.greenAccent,
      );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 350),
            content: Text('Added To Favourite'),
          ),
        );
      });
    }
    notifyListeners();
  }
}
