import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controllers/DbProviders/fav_db_controller.dart';

class FavButton extends StatelessWidget {
  const FavButton({
    super.key,
    required this.songFavorite,
  });
  final SongModel songFavorite;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteDb>(
      builder: (ctx, favoriteData, child) {
        return InkWell(
          child: favoriteData.isFavor(songFavorite)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.greenAccent,
                )
              : const Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.greenAccent,
                ),
          onTap: () async {
            if (favoriteData.isFavor(songFavorite)) {
              favoriteData.delete(songFavorite.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 350),
                  content: Text('Removed From Favourite'),
                ),
              );
            } else {
              favoriteData.add(songFavorite);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(milliseconds: 350),
                  content: Text('Added To Favourite')));
            }
          },
        );
      },
    );
  }
}
