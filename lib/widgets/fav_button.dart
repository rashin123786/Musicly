import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../db/favourite_db.dart';

class FavButton extends StatefulWidget {
  const FavButton({
    super.key,
    required this.songFavorite,
  });
  final SongModel songFavorite;

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDb.favoriteSongs,
      builder: (BuildContext ctx, List<SongModel> favoriteData, Widget? child) {
        return InkWell(
          child: FavoriteDb.isFavor(widget.songFavorite)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.greenAccent,
                )
              : const Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.greenAccent,
                ),
          onTap: () async {
            if (FavoriteDb.isFavor(widget.songFavorite)) {
              FavoriteDb.delete(widget.songFavorite.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(milliseconds: 350),
                  content: Text('Removed From Favourite'),
                ),
              );
            } else {
              FavoriteDb.add(widget.songFavorite);
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
