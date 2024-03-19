
import 'package:flutter/material.dart';

import '../../models/skibble_post.dart';
import '../../models/skibble_user.dart';

class SkibsData with ChangeNotifier {
  Map<String, List<SkibbleUser>> skibLikesUsers = {};

  SkibblePost? _currentSkibLikesBeingViewed;

  //the current skib that is currently being viewed
  SkibblePost? _currentSkibBeingViewed;

  SkibblePost? get currentSkibLikesBeingViewed => _currentSkibLikesBeingViewed;
  SkibblePost? get currentSkibBeingViewed => _currentSkibBeingViewed;


  void set currentSkibLikesBeingViewed(SkibblePost? post) {
    _currentSkibLikesBeingViewed = post;
    notifyListeners();
  }


  void set currentSkibBeingViewed(SkibblePost? post) {
    _currentSkibBeingViewed = post;
    notifyListeners();
  }

  void addUserLikesForSkibs (String postId, List<SkibbleUser> users) {
    if(skibLikesUsers[postId] == null) {
      skibLikesUsers[postId] = [];
    }

    skibLikesUsers[postId]?.addAll(users);
    notifyListeners();
  }

  List<SkibbleUser> getLikesForPost(String postId) {
    return skibLikesUsers[postId] ?? [];
  }
}