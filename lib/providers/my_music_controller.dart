import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/all_songs.dart';

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
