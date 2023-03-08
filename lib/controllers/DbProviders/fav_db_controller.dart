import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavouriteDb with ChangeNotifier {
  static bool isInitialized = false;
  static final musicDb = Hive.box<int>('FavoriteDB');
  List<SongModel> favoriteSongs = [];

  void initialize(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isFavor(song)) {
        favoriteSongs.add(song);
      }
    }
    isInitialized = true;
  }

  isFavor(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      return true;
    }
    return false;
  }

  void add(SongModel song) async {
    musicDb.add(song.id);
    favoriteSongs.add(song);

    notifyListeners();
  }

  void delete(int id) async {
    int deletekey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> favorMap = musicDb.toMap();
    favorMap.forEach((key, value) {
      if (value == id) {
        deletekey = key;
      }
    });
    musicDb.delete(deletekey);
    favoriteSongs.removeWhere((song) => song.id == id);

    notifyListeners();
  }

  void clear() async {
    favoriteSongs.clear();
    notifyListeners();
  }
}
