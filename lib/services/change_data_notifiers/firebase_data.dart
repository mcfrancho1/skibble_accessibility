import 'package:flutter/material.dart';

class FirebaseData extends ChangeNotifier{

  List userFeedIDsToDelete = [];



  void updateFeedIDsToDelete(String idToDelete) {
    userFeedIDsToDelete.add(idToDelete);
  }
}