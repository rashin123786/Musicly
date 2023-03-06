import 'package:flutter/material.dart';

class BottomNavControll with ChangeNotifier {
  int currentSelectedIndex = 0;

  void bottomSwitch(index) {
    currentSelectedIndex = index;
    notifyListeners();
  }
}
