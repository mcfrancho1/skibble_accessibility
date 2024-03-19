// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:property_change_notifier/property_change_notifier.dart';
// import 'package:rxdart/rxdart.dart';
//
// import '../../models/feed_post.dart';
// import '../../models/skibble_post.dart';
//
// class CustomFeedData extends ChangeNotifier {
//   static StreamController<SkibblePost?> controller = StreamController<SkibblePost?>.broadcast();
//
//   // CustomFeedData() {
//   //   controller = StreamController<List<FeedPost>>.broadcast();
//   // }
//
//   StreamController<SkibblePost?>? getControllerInstance() {
//     return controller;
//   }
//   List<FeedPost> _userFeed = [];
//   SkibblePost? currentUserRecentPost;
//
//   List<FeedPost> get userFeed => _userFeed;
//
//
//   void disposeController() {
//     controller.close();
//   }
//   void updateUserFeed(List<FeedPost> newFeed) {
//     _userFeed = newFeed;
//     // controller.sink.add(newFeed);
//     // notifyListeners();
//   }
//
//   void addNewPostsToUserFeed(List<FeedPost> newFeed) {
//     _userFeed.insertAll(0, newFeed);
//     // controller.sink.add(newFeed);
//     // notifyListeners();
//   }
//
//   void addOldPostsToUserFeed(List<FeedPost> newFeed) {
//     _userFeed.addAll(newFeed);
//     // controller.sink.add(newFeed);
//     // notifyListeners();
//   }
//
//   void deleteFeedPost(SkibblePost post) {
//     _userFeed.removeWhere((element) => element.feedPostId == post.postId);
//     // notifyListeners();
//   }
//
//   ///Handlers for current user posts
//   void addCurrentUserNewPost(SkibblePost newPost) {
//     currentUserRecentPost = newPost;
//     addNewPostsToUserFeed([FeedPost(feedPostType: FeedPostType.skib, feedPostId: newPost.postId!, timeCreated: newPost.timePosted, post: newPost)]);
//     controller.sink.add(newPost);
//     // notifyListeners();
//   }
//
//   void deleteCurrentUserNewPost() {
//     currentUserRecentPost = null;
//     controller.sink.add(null);
//
//     // notifyListeners();
//   }
//
//   // void addNewPostsToUserPosts(SkibblePost newPost) {
//   //   currentUserPosts.insert(0, newPost);
//   //   notifyListeners();
//   // }
//   //
//   // void deleteCurrentUserSkibPost(SkibblePost post) {
//   //   currentUserPosts.removeWhere((element) => element.postId == post.postId);
//   //
//   //   notifyListeners();
//   // }
// }