import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import '../model/musicly_model.dart';

class PlaylistDb {
  static ValueNotifier<List<MusiclyModel>> playlistNotifiier =
      ValueNotifier([]);
  static final playlistDb = Hive.box<MusiclyModel>('playlistDb');

  static Future<void> addPlaylist(MusiclyModel value) async {
    final playlistDb = Hive.box<MusiclyModel>('playlistDb');
    await playlistDb.add(value);
    playlistNotifiier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusiclyModel>('playlistDb');
    playlistNotifiier.value.clear();
    playlistNotifiier.value.addAll(playlistDb.values);

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    playlistNotifiier.notifyListeners();
  }

  static Future<void> deletePlaylist(int index) async {
    final playlistDb = Hive.box<MusiclyModel>('playlistDb');
    await playlistDb.deleteAt(index);

    getAllPlaylist();
  }
}
