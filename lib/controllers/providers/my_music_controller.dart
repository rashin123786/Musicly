import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'all_songs.dart';

class MyMusicController with ChangeNotifier {
  bool sizedBoxSpacing = false;
  Future<void> reqeustStoragePermission() async {
    await Permission.storage.request();
    notifyListeners();
    FocusManager.instance.primaryFocus?.unfocus();
    notifyListeners();
  }

  void onInit() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        sizedBoxSpacing = true;
        notifyListeners();
      }
    });
    notifyListeners();
  }
}
