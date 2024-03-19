import 'package:flutter/material.dart';

class ChatData extends ChangeNotifier {

  bool isSelectingMessages = false;

  void reset() {
    isSelectingMessages = false;
  }
  updateIsSelectingMessages(bool value) {
    isSelectingMessages = value;
    notifyListeners();
  }

}