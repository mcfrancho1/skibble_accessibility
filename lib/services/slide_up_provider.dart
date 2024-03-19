import 'package:flutter/cupertino.dart';

class SlideUpProvider with ChangeNotifier {
  bool isShown = false;

  void updateState(bool newState) {
    isShown = newState;
    notifyListeners();
  }
}