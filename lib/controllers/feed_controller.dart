import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/features/communities/models/community.dart';
import 'package:skibble/models/kitchen.dart';
import 'package:skibble/models/skibble_post.dart';
import 'package:skibble/services/change_data_notifiers/feed_data.dart';
import 'package:skibble/services/firebase/database/community_database.dart';

import '../models/feed_post.dart';
import '../models/recipe.dart';
import '../models/skibble_user.dart';
import '../services/firebase/database/feed_database.dart';
import '../services/firebase/database/recipe_database.dart';



///
/// Possible function calls on the feed
/// Get SkibblePosts for user feed - posts_feed
/// Get friend suggestions - friend_suggestions
/// Get Get recipe suggestions - recipes_feed
/// Get community suggestions - community_suggestions
/// Get kitchen suggestions - kitchen_suggestions
/// Get spot suggestions - spots_suggestions
class FeedController with ChangeNotifier{
  List<FeedPost> feedList = [];
  List<FeedPost> postsFeedList = [];
  List<FeedPost> friendSuggestionsList = [];
  List<FeedPost> recipesList = [];
  List<FeedPost> communitiesList = [];
  List<Kitchen> kitchensList = [];

  static const _maxPageSize = 20;
  static const _minPageSize = 5;

  late PagingController<int, FeedPost> _pagingController;
  late ScrollController _feedPageScrollController;
  late BuildContext _context;
  int _nextFunction = 0;
  int _lastPostFetched = 0;
  int _lastRecipeFetched = 0;
  int _lastCommunityFetched = 0;
  int _lastSuggestionsFetched = 0;


  bool _doneFetchingPosts = false;
  bool _doneFetchingRecipes = false;
  bool _doneFetchingCommunities = false;
  bool _doneFetchingSuggestions = false;

  PagingController<int, FeedPost> get pagingController => _pagingController;
  ScrollController get feedPageScrollController => _feedPageScrollController;

  int maxToFetch = 5;

  ///Change this for each programs added to the list
  int maxPrograms = 3;


  String? _currentUserId;

  FeedController(ScrollController controller) {
    _feedPageScrollController = controller;
  }


  initPageController(String currentUserId, BuildContext context) {
    _pagingController = PagingController(firstPageKey: 0);
    _context = context;
    _currentUserId = currentUserId;
    _pagingController.addPageRequestListener((pageKey) {
      // print('refreshing');
      feedHandler(pageKey,);
    });
  }

  refreshController() {
    feedList = [];
    postsFeedList = [];
    friendSuggestionsList = [];
    recipesList = [];
    communitiesList = [];
    kitchensList = [];
    _nextFunction = 0;
    _lastPostFetched = 0;
    _lastRecipeFetched = 0;
    _lastCommunityFetched = 0;
    _lastSuggestionsFetched = 0;
    _pagingController.refresh();
  }

  reset() {
    feedList = [];
    postsFeedList = [];
    friendSuggestionsList = [];
    recipesList = [];
    communitiesList = [];
    kitchensList = [];

    _nextFunction = 0;
    _lastPostFetched = 0;
    _lastRecipeFetched = 0;
    _lastCommunityFetched = 0;
    _lastSuggestionsFetched = 0;
    try{
      _pagingController?.dispose();
      _feedPageScrollController?.dispose();
    } catch(e) {}
  }

  scrollToTop() {
    if (_feedPageScrollController.hasClients) {
      final position = _feedPageScrollController.position.minScrollExtent;
      _feedPageScrollController.animateTo(
        position,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    }
  }

  scrollToBottom() {
    if (_feedPageScrollController.hasClients) {
      final position = _feedPageScrollController.position.maxScrollExtent;
      _feedPageScrollController.jumpTo(position);
    }
  }
  //TODO: Start from here
  deleteSkibInFeed(SkibblePost skib) {
    _pagingController.itemList!.removeWhere((element) => element.post != null && element.post!.postId == skib.postId, );
    postsFeedList.removeWhere((element) => element.post != null && element.post!.postId == skib.postId, );
    feedList.removeWhere((element) => element.post != null && element.post!.postId == skib.postId, );

    notifyListeners();
  }

  feedHandler(int pageKey) async{
    List<FeedPost> itemsToAppend = [];
    List<FeedPost> fetchResult = [];


    switch(_nextFunction) {
      case 0:
        // fetchResult = await _fetchPosts();
        itemsToAppend = await _helper(_nextFunction);
        _nextFunction += 1;
        break;
      case 1:
        // fetchResult = await _fetchRecipes();
        itemsToAppend = await _helper(_nextFunction);

        _nextFunction += 1;

        break;

      case 2:
        // fetchResult = await _fetchCommunities();
        itemsToAppend = await _helper(_nextFunction);

        _nextFunction = 0;

        break;
    }

    final isLastPage = itemsToAppend.length < _minPageSize;

    itemsToAppend.shuffle();
    if (isLastPage) {
      _pagingController.appendLastPage(itemsToAppend);
    }

    else {
      final nextPageKey = (pageKey + itemsToAppend.length).toInt();
      _pagingController.appendPage(itemsToAppend, nextPageKey);
    }
  }

  Future<List<FeedPost>> _helper(int next) async{
   try {
     int tracker = next;
     List<int> trackerList = [];
     while(tracker <= maxPrograms) {
       if(!trackerList.contains(tracker)) {
         if(tracker == 0) {
           var result = _lastPostFetched >= postsFeedList.length ? <FeedPost>[] : postsFeedList.sublist(_lastPostFetched, (_lastPostFetched + 5) < postsFeedList.length ? (_lastPostFetched + 5) : null);

           if(result.isNotEmpty ) {
             _lastPostFetched += result.length;
             return result;
           }
           //try fetching new posts from database
          var newResults = await _fetchPosts();

           if(newResults.isNotEmpty) {
             result = _lastPostFetched >= postsFeedList.length ? <FeedPost>[] : postsFeedList.sublist(_lastPostFetched, (_lastPostFetched + 5) < postsFeedList.length ? (_lastPostFetched + 5) : null);
             _lastPostFetched += result.length;
             return result;
           }

           else {
             trackerList.add(tracker);
             tracker += 1;
           }
         }

         else if(tracker == 1) {
           var result = _lastRecipeFetched >= recipesList.length ? <FeedPost>[] : recipesList.sublist(_lastRecipeFetched, (_lastRecipeFetched + 5) < recipesList.length ? (_lastRecipeFetched + 5) : null);

           if(result.isNotEmpty) {
             _lastRecipeFetched += 1;
             return result;
           }
           //try fetching new recipes from database
           var newResults = await _fetchRecipes();

           if(newResults.isNotEmpty) {
              result = _lastRecipeFetched >= recipesList.length ? <FeedPost>[] : recipesList.sublist(_lastRecipeFetched, (_lastRecipeFetched + 5) < recipesList.length ? (_lastRecipeFetched + 5) : null);
              _lastRecipeFetched += 1;
             return result;
           }

           else {
             trackerList.add(tracker);
             tracker += 1;
           }
         }

         else {
           if(tracker == maxPrograms) {
             if(next == 0) {
               return [];
             }

             tracker = 0;

           }
           else {
             trackerList.add(tracker);
             tracker += 1;
           }
         }
       }
       else {
         return [];
       }
     }

     return [];
   }
   catch(e) {
     print(e);
     return [];
   }
    // switch(next) {
    //   case 0:
    //     var result = _lastPostFetched >= postsFeedList.length ? <FeedPost>[] : postsFeedList.sublist(_lastPostFetched, (_lastPostFetched + 5) < postsFeedList.length ? (_lastPostFetched + 5) : null);
    //
    //     if(result.isEmpty) {
    //       _helper(next + 1);
    //     }
    //     else {
    //       _lastPostFetched += result.length;
    //       return result;
    //     }
    //     break;
    //
    //   case 1:
    //     var result = _lastRecipeFetched >= recipesList.length ? <FeedPost>[] : recipesList.sublist(_lastRecipeFetched, (_lastRecipeFetched + 5) < recipesList.length ? (_lastRecipeFetched + 5) : null);
    //
    //     if(result.isEmpty) {
    //       _helper(next + 1);
    //     }
    //     else {
    //       return result;
    //     }
    //     break;
    //   default:
    //     return [];
    // }
    // return [];

  }

  Future<List<FeedPost>> _fetchPosts() async {
    try {
      List<FeedPost> newPostsFeedList = [];

      if(postsFeedList.isEmpty) {
        newPostsFeedList = await fetchUserFeedPosts(_currentUserId!, _context) ?? [];
      }
      else {
        newPostsFeedList = await fetchOlderUserFeedPosts(_currentUserId!, postsFeedList.last.feedPostId, _context) ?? [];
      }
      if(newPostsFeedList.isEmpty) {
        _doneFetchingPosts = true;
      }

      postsFeedList.addAll(newPostsFeedList);
      return newPostsFeedList;
    }

    catch (error) {
      debugPrint(error.toString());
      // _pagingController.error = error;
      return [];
    }
  }


  Future<List<FeedPost>>  _fetchRecipes() async {
    try {
      List<FeedPost> newPostsFeedList = [];

      if(recipesList.isEmpty) {

        newPostsFeedList = await fetchUserFeedRecipes(_currentUserId!, _context) ?? [];
      }
      else {

        newPostsFeedList = await fetchOlderUserFeedRecipes(_currentUserId!, recipesList.last.feedPostId, _context) ?? [];
      }

      if(newPostsFeedList.isEmpty) {
        _doneFetchingRecipes = true;
      }
      recipesList.addAll(newPostsFeedList);
      return newPostsFeedList;
    }

    catch (error) {
      debugPrint(error.toString());
      // _pagingController.error = error;
      return [];
    }
  }



  /**
   * Feed Contents
   */
  Future<List<FeedPost>>? fetchUserFeedPosts(String currentUserId, context) async{

    var feedList = await FeedDatabaseService().fetchUserFeedPosts(currentUserId, context);
    Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedList!);
    return feedList;
  }

  Future<List<FeedPost>>? fetchOlderUserFeedPosts(String currentUserId, String lastPostId, context) async{

    var feedList = await FeedDatabaseService().fetchOlderUserFeedPosts(currentUserId, lastPostId, context);
    Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);

    return feedList;
  }


  Future<List<FeedPost>>? fetchUserFeedRecipes(String currentUserId, context) async{
    var feed = Provider.of<FeedData>(context, listen: false).userFeed;

    var feedList = await RecipeDatabaseService().fetchUserFeedRecipes(currentUserId, context);
    // feed.isEmpty ? Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedList!) : Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);
    return feedList ?? [];

  }

  Future<List<FeedPost>>? fetchOlderUserFeedRecipes(String currentUserId, String lastRecipeId, context) async{
    var feedList = await RecipeDatabaseService().fetchOlderUserFeedRecipess(currentUserId, lastRecipeId, context);

    Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);

    return feedList;

  }


  Future<List<FeedPost>>? fetchUserFeedCommunities(String currentUserId, context) async{
    var feed = Provider.of<FeedData>(context, listen: false).userFeed;

    var feedList = await CommunityDatabase().fetchUserFeedCommunities(currentUserId, context);
    feed.isEmpty ? Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedList!) : Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);
    return feedList;

  }

  Future<List<FeedPost>>? fetchOlderUserFeedCommunities(String currentUserId, String lastCommunityId, context) async{
    var feedList = await CommunityDatabase().fetchOlderUserFeedCommunities(currentUserId, lastCommunityId, context);

    Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);

    return feedList;

  }


  Future<List<FeedPost>>? fetchUserFeedFriendSuggestions(String currentUserId, context) async{
    var feed = Provider.of<FeedData>(context, listen: false).userFeed;

    var feedList = await UserDatabaseService().fetchUserFeedFriendSuggestionsBasedOnInterests(currentUserId);
    // feed.isEmpty ? Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedList!) : Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);
    return feedList ?? [];

  }

}