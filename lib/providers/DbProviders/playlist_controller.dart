import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../model/musicly_model.dart';

class PlayListDb with ChangeNotifier {
  List<MusiclyModel> playlistNotifiier = [];
  final playlistDb = Hive.box<MusiclyModel>('playlistDb');

  Future<void> addPlaylist(MusiclyModel value) async {
    final playlistDb = Hive.box<MusiclyModel>('playlistDb');
    await playlistDb.add(value);
    playlistNotifiier.add(value);
    notifyListeners();
  }

  Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusiclyModel>('playlistDb');
    playlistNotifiier.clear();
    playlistNotifiier.addAll(playlistDb.values);

    notifyListeners();
  }

  Future<void> deletePlaylist(int index) async {
    final playlistDb = Hive.box<MusiclyModel>('playlistDb');
    await playlistDb.deleteAt(index);

    getAllPlaylist();
    notifyListeners();
  }

  Future<void> editPlaylist(int index, MusiclyModel value) async {
    final PlaylistDb = Hive.box<MusiclyModel>('playlistDb');
    await playlistDb.putAt(index, value);

    notifyListeners();
  }
}
