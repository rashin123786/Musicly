import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchController with ChangeNotifier {
  late List<SongModel> allsong;
  List<SongModel> foundSongs = [];
  final audioQuery = OnAudioQuery();

  void songsLoadings() async {
    allsong = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    notifyListeners();
    foundSongs = allsong;
    notifyListeners();
  }

  void updateList(String enteredtext) {
    List<SongModel> result = [];
    if (enteredtext.isEmpty) {
      result = allsong;
    } else {
      result = allsong
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredtext.toLowerCase().trim()))
          .toList();
    }
    foundSongs = result;
    notifyListeners();
  }
}
