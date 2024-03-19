import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_user.dart';

import '../firebase/database/user_database.dart';

class UsersDataController with ChangeNotifier {

  static const _pageSize = 20;
  late PagingController<int, SkibbleUser> _pagingController;
  late BuildContext _context;
  bool _isCurrentLikesDoneFetching = false;

  SkibbleUser? _userBeingViewed;

  Map<String, List<SkibbleUser>> userFollowers = {};
  Map<String, List<SkibbleUser>> userFollowings = {};



  PagingController<int, SkibbleUser> get pagingController => _pagingController;
  SkibbleUser? get userBeingViewed => _userBeingViewed;

  late List<SkibbleUser> tempFollowers;
  late List<SkibbleUser> tempFollowings;





  initFollowersPageController(CollectionReference reference, BuildContext context) {
    _pagingController = PagingController(firstPageKey: 0);
    // _isCurrentLikesDoneFetching = false;
    _context = context;
    tempFollowers = [];
    _pagingController.addPageRequestListener((pageKey) {
      _fetchFollowersPage(pageKey, reference);
    });
  }

  void set userBeingViewed(SkibbleUser? user) {
    _userBeingViewed = user;
    notifyListeners();
  }


  void addUsersToFollowersList (String userId, List<SkibbleUser> users) {
    if(userFollowers[userId] == null) {
      userFollowers[userId] = [];
    }

    userFollowers[userId]?.addAll(users);
    notifyListeners();
  }

  //gets a list of likes based on the page size
  List<SkibbleUser> getFollowersForUser(String userId, {int? nextPageKey}) {
    if(nextPageKey == null) {
      return [];
    }
    else if(userFollowers[userId] != null) {
      return userFollowers[userId]!;
      // .sublist(nextPageKey, (nextPageKey + _pageSize) > skibLikesUsers[postId]!.length ? skibLikesUsers[postId]!.length : (nextPageKey + _pageSize));
    }
    else {

      return [];
    }
  }

  void disposeController() {
    _pagingController.dispose();
  }

  Future<void> _fetchFollowersPage(int pageKey, CollectionReference reference) async {
    try {
      var user = userBeingViewed != null ? userBeingViewed : null;

      var storedFollowers = getFollowersForUser(user != null ? user.userId! : '', nextPageKey: pageKey);
      List<SkibbleUser> followers = [];

      if(pageKey == 0 && storedFollowers.isEmpty) {
        followers =  await UserDatabaseService().getUsersInfoWithCollectionRef(reference, _pageSize);
        tempFollowers.addAll(followers);
        addUsersToFollowersList(user!.userId!, followers);
      }

      //this runs because storedLikes is empty at first
      else {

        followers =  await UserDatabaseService().getOlderUsersInfoWithCollectionRef(reference, storedFollowers.last.userId!, _pageSize);
        if(followers.isNotEmpty) {
          if(followers.last.userId != storedFollowers.last.userId) {
            addUsersToFollowersList(user!.userId!, followers);
          }
        }
        followers = userFollowers[user!.userId!]!.sublist(pageKey, (pageKey + _pageSize) > userFollowers[user.userId!]!.length ? userFollowers[user.userId!]!.length : (pageKey + _pageSize));;
        tempFollowers.addAll(followers);
      }

      final isLastPage = followers.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(followers);
        _isCurrentLikesDoneFetching = true;

      }

      else {
        final nextPageKey = (pageKey + followers.length).toInt();
        _pagingController.appendPage(followers, nextPageKey);
      }

    } catch (error) {
      debugPrint(error.toString());
      _pagingController.error = error;
    }
  }
}