import 'package:flutter/material.dart';

import 'all_songs.dart';

class MyMusicController with ChangeNotifier {
  bool sizedBoxSpacing = false;

  void onInit() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        sizedBoxSpacing = true;
      }
    });
    notifyListeners();
  }
}
