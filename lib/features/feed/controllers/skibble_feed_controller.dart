
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/firebase/database/feed_database.dart';
import 'package:skibble/features/feed/models/feed_component.dart';

import '../../../models/feed_post.dart';
import '../../../models/kitchen.dart';
import '../../../services/change_data_notifiers/feed_data.dart';
import '../../../services/firebase/database/community_database.dart';
import '../../../services/firebase/database/recipe_database.dart';
import '../../../services/firebase/database/user_database.dart';

class SkibbleFeedController with ChangeNotifier{
  static const _maxPageSize = 20;
  static const _minPageSize = 5;

  late final Map<FeedPostType, FeedComponent> feedComponentsMap;
  late final Map<FeedPostType, List<FeedPost>> feedMap;


  Map<FeedPostType, int> lastIndexFetched = {};
  Map<FeedPostType, bool> isDoneTracker = {};



  late FeedPostType globalNextType;


  static late PagingController<int, FeedPostGroup> _pagingController;
  static late ScrollController _feedPageScrollController;


  PagingController<int, FeedPostGroup> get pagingController => _pagingController;
  ScrollController get feedPageScrollController => _feedPageScrollController;

  String? _currentUserId;
  late BuildContext _context;

  //contains a list of items that are no longer fetching data or their items have been exhausted from the database
  List<int> blackList = [];


  int _nextFunction = 0;

  int maxToFetch = 5;

  ///Change this for each programs added to the list
  int maxPrograms = 0;


  List<FeedPost> feedList = [];
  List<FeedPost> postsFeedList = [];
  List<FeedPost> friendSuggestionsList = [];
  List<FeedPost> recipesList = [];
  List<FeedPost> communitiesList = [];
  List<Kitchen> kitchensList = [];

  refreshController() {
    // feedList = [];
    // postsFeedList = [];
    // friendSuggestionsList = [];
    // recipesList = [];
    // communitiesList = [];
    // kitchensList = [];
    // _nextFunction = 0;
    // _lastPostFetched = 0;
    // _lastRecipeFetched = 0;
    // _lastCommunityFetched = 0;
    // _lastSuggestionsFetched = 0;
    _nextFunction = 0;
    lastIndexFetched = {};
    isDoneTracker = {};
    blackList = [];
    globalNextType = feedComponentsMap.keys.first;
    _pagingController.refresh();
  }

  initFeedController(List<FeedComponent> componentList, BuildContext context, String currentUserId) {
    feedComponentsMap = {};
    feedMap = {};
    lastIndexFetched = {};
    isDoneTracker = {};
    _context = context;
    _currentUserId = currentUserId;

    maxPrograms = componentList.length;

    for(var component in componentList) {
      feedComponentsMap[component.feedPostType] = component;
      feedMap[component.feedPostType] = [];
      lastIndexFetched[component.feedPostType] = 0;
      isDoneTracker[component.feedPostType] = false;
    }

    blackList = [];
    globalNextType = feedComponentsMap.keys.first;


    _feedPageScrollController = ScrollController();
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {

      feedHandler(pageKey);
    });
  }

  feedHandler(int pageKey) async{
    List<FeedPost> itemsToAppend = [];

    // print('_nextfunction: $_nextFunction');


    if(_nextFunction == -1) {
      itemsToAppend = [];
    }

    else if(_nextFunction < maxPrograms) {

      itemsToAppend = await _helper();
      _nextFunction += 1;
      if(_nextFunction < maxPrograms) {
        globalNextType = feedComponentsMap.keys.toList()[_nextFunction];
      }
    }

    else if(_nextFunction >= maxPrograms) {
      _nextFunction = 0;
      globalNextType =feedComponentsMap.keys.toList()[_nextFunction];
      itemsToAppend = await _helper();

    }

    // print('items: $itemsToAppend');
    // print('items to append: ${itemsToAppend.map((e) => e.feedPostId).toList()}');
    // print('items to append: ${itemsToAppend.map((e) => e.feedPostType).toList()}');



    final isLastPage = itemsToAppend.length < _minPageSize;

    itemsToAppend.shuffle();
    if (isLastPage) {
      if(itemsToAppend.isEmpty) {
        _pagingController.appendLastPage([]);
      }
      else {
        _pagingController.appendLastPage([FeedPostGroup(feedPostType: itemsToAppend.last.feedPostType, feedPostList: itemsToAppend)]);
      }
    }

    else {
      final nextPageKey = (pageKey + itemsToAppend.length).toInt();
      _pagingController.appendPage([FeedPostGroup(feedPostType: itemsToAppend.last.feedPostType, feedPostList: itemsToAppend)], nextPageKey);
    }
  }

  //track the next index to fetch items from
  int _fetchIndexNotInBlackList(int start) {

    int initialStart = start;
    do {
      if(blackList.contains(start)) {
        start += 1;

        if(start >= maxPrograms) {
          start = 0;
        }

        //recheck the new value of start
        if(!blackList.contains(start)) {
          return start;
        }
      }

      else {
        return start;
      }

    } while(start < maxPrograms && initialStart != start);


    return -1;


  }

  ///Helper returns a list of next items to append to the paging controller
  Future<List<FeedPost>> _helper() async{
    try {
      _nextFunction = _fetchIndexNotInBlackList(_nextFunction);
      globalNextType = feedComponentsMap.keys.toList()[_nextFunction];


      while(_nextFunction != -1) {

        List<FeedPost>? nextKeyFeedList = feedMap[globalNextType] ?? [];


        int lastIndexOfFeedFetched = lastIndexFetched[globalNextType] ?? 0;

        var result = lastIndexOfFeedFetched >= nextKeyFeedList.length ? <FeedPost>[] : nextKeyFeedList.sublist(lastIndexOfFeedFetched, (lastIndexOfFeedFetched + 5) < nextKeyFeedList.length ? (lastIndexOfFeedFetched + 5) : null);


        if(result.isNotEmpty ) {
          lastIndexOfFeedFetched += result.length;
          lastIndexFetched[globalNextType] = lastIndexOfFeedFetched;
          return result;
        }

        //try fetching new posts from database
        var newResults = await _fetchContent(globalNextType, _nextFunction);

        if(newResults.isNotEmpty) {
          result = lastIndexOfFeedFetched >= nextKeyFeedList.length ? <FeedPost>[] : nextKeyFeedList.sublist(lastIndexOfFeedFetched, (lastIndexOfFeedFetched + 5) < nextKeyFeedList.length ? (lastIndexOfFeedFetched + 5) : null);
          lastIndexOfFeedFetched += result.length;
          lastIndexFetched[globalNextType] = lastIndexOfFeedFetched;

          return result;
        }

        else {
          blackList.add(_nextFunction);
          _nextFunction = _fetchIndexNotInBlackList(_nextFunction);

          if(_nextFunction != -1 && _nextFunction < maxPrograms) {
            globalNextType = feedComponentsMap.keys.toList()[_nextFunction];
          }
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

  Future<List<FeedPost>> _fetchContent(FeedPostType type, int tracker) async {
    try {
      List<FeedPost> newPostsFeedList = [];

      if((feedMap[type] ?? []).isEmpty) {
        newPostsFeedList = await feedComponentsMap[type]?.callFetchFeedFunction(null) ?? [];
            // await fetchUserFeedPosts(_currentUserId!, _context) ?? [];
      }
      else {
        newPostsFeedList = await  feedComponentsMap[type]?.callFetchFeedFunction((feedMap[type] ?? []).last.feedPostId) ?? [];
        // fetchOlderUserFeedPosts(_currentUserId!, (feedMap[type] ?? []).last.feedPostId, _context) ?? [];
      }
      if(newPostsFeedList.isEmpty) {
        isDoneTracker[type] = true;
        // blackList.add(tracker);
      }

      (feedMap[type] ?? []).addAll(newPostsFeedList);
      return newPostsFeedList;
    }

    catch (error) {
      debugPrint(error.toString());
      // _pagingController.error = error;
      return [];
    }
  }


  // Future<List<FeedPost>>  _fetchRecipes() async {
  //   try {
  //     List<FeedPost> newPostsFeedList = [];
  //
  //     if(recipesList.isEmpty) {
  //
  //       newPostsFeedList = await fetchUserFeedRecipes(_currentUserId!, _context) ?? [];
  //     }
  //     else {
  //
  //       newPostsFeedList = await fetchOlderUserFeedRecipes(_currentUserId!, recipesList.last.feedPostId, _context) ?? [];
  //     }
  //
  //     if(newPostsFeedList.isEmpty) {
  //       _doneFetchingRecipes = true;
  //     }
  //     recipesList.addAll(newPostsFeedList);
  //     return newPostsFeedList;
  //   }
  //
  //   catch (error) {
  //     debugPrint(error.toString());
  //     // _pagingController.error = error;
  //     return [];
  //   }
  // }
  //

  /**
   * Feed Contents
   */
  Future<List<FeedPost>?> fetchUserFeedPosts(String currentUserId, context) async{

    return await FeedDatabaseService().fetchUserFeedPosts(currentUserId, context);
    // Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedList!);

  }

  Future<List<FeedPost>?> fetchOlderUserFeedPosts(String currentUserId, String lastPostId, context) async{

    var feedList = await FeedDatabaseService().fetchOlderUserFeedPosts(currentUserId, lastPostId, context);
    // Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);

    return feedList;
  }


  Future<List<FeedPost>>? fetchUserFeedRecipes(String currentUserId, context) async{
    // var feed = Provider.of<FeedData>(context, listen: false).userFeed;

    var feedList = await RecipeDatabaseService().fetchUserFeedRecipes(currentUserId, context);
    // feed.isEmpty ? Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedList!) : Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);
    return feedList ?? [];

  }

  Future<List<FeedPost>?> fetchOlderUserFeedRecipes(String currentUserId, String lastRecipeId, context) async{
    var feedList = await RecipeDatabaseService().fetchOlderUserFeedRecipess(currentUserId, lastRecipeId, context);

    // Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);

    return feedList;

  }


  Future<List<FeedPost>?> fetchUserFeedCommunities(String currentUserId, context) async{
    // var feed = Provider.of<FeedData>(context, listen: false).userFeed;

    var feedList = await CommunityDatabase().fetchUserFeedCommunities(currentUserId, context);
    // feed.isEmpty ? Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedList!) : Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);
    return feedList;

  }

  Future<List<FeedPost>?> fetchOlderUserFeedCommunities(String currentUserId, String lastCommunityId, context) async{
    var feedList = await CommunityDatabase().fetchOlderUserFeedCommunities(currentUserId, lastCommunityId, context);

    // Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);

    return feedList;

  }


  Future<List<FeedPost>>? fetchUserFeedFriendSuggestions(String currentUserId, context) async{
    // var feed = Provider.of<FeedData>(context, listen: false).userFeed;

    var feedList = await UserDatabaseService().fetchUserFeedFriendSuggestionsBasedOnInterests(currentUserId);
    // feed.isEmpty ? Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedList!) : Provider.of<FeedData>(context, listen: false).addOldPostsToUserFeed(feedList!);
    return feedList ?? [];

  }

}