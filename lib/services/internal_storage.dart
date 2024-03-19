import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';

import '../models/feed_post.dart';
import 'change_data_notifiers/feed_data.dart';

class InternalStorageService {

  ///Box name
  static const _storageBox = '_storageBox';


  ///Keys
  static const _followings = 'followings';
  static const _temporaryUsers = 'temporaryUsers';
  // static const _currentNotificationToken = 'currentNotificationToken';
  // static const _currentUserId = 'currentUserId';


  static const _communities = 'communities';
  static const _blockedUsers = 'blockedUsers';

  static const _likedSkibs = 'likedSkibs';
  static const _likedRecipes = 'likedRecipes';
  static const _likedSkibsMap = 'likedSkibsMap';
  static const _likedRecipesMap = 'likedRecipesMap';
  static const _userFeed = 'userFeed';



  final Box<dynamic> _box;

  InternalStorageService._(this._box);

  static Future<void> init() async {
    await Hive.openBox<dynamic>(_storageBox);
  }

  static InternalStorageService getInstance() {
    final box =  Hive.box(_storageBox);
    return InternalStorageService._(box);
  }

  T _getValue<T>(dynamic key, {T? defaultValue}) => _box.get(key, defaultValue: defaultValue) as T;


  Future<void> clearBox() async => await _box.clear();

  //private setter method to help hide the keys
  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);


  // String? getCurrentNotificationToken() => _getValue(_currentNotificationToken, defaultValue: null);
  // Future<void> setCurrentNotificationToken(String value) => _setValue(_currentNotificationToken, value);
  //
  // String? getCurrentUserId() => _getValue(_currentUserId, defaultValue: null);
  // Future<void> setCurrentUserId(String value) => _setValue(_currentUserId, value);
  //
  List<String>? getFollowings() => _getValue(_followings, defaultValue: []);
  Future<void> setFollowings(List<String> value) => _setValue(_followings, value);


  List<String>? getCommunities() => _getValue(_communities, defaultValue: []);
  Future<void> setCommunities(List<String> value) => _setValue(_communities, value);


  ///gets the recipes that the current user has liked
  List<String>? getLikedRecipes() => _getValue(_likedRecipes, defaultValue: []);
  Future<void> setLikedRecipes(List<String> value) => _setValue(_likedRecipes, value);

  List<String>? getLikedSkibs() => _getValue(_likedSkibs, defaultValue: []);
  Future<void> setLikedSkibs(List<String> value) => _setValue(_likedSkibs, value);


  ///gets the recipes that the current user has liked but stored in key value pairs
  Map<String, List<String>> getLikedRecipesMap() => _box.get(_likedRecipesMap, defaultValue: Map<String, List<String>>()).cast<String, List<String>>();
      //_getValue(_likedRecipesMap, defaultValue: Map<String, List<String>>());
  Future<void> setLikedRecipesMap(Map<String, List<String>?> value) => _setValue(_likedRecipesMap, value);

  Map<String, List<String>> getLikedSkibsMap() =>_box.get(_likedSkibsMap, defaultValue: Map<String, List<String>>()).cast<String, List<String>>();
      //_getValue(_likedSkibsMap, defaultValue: Map<String, List<String>>());
  Future<void> setLikedSkibsMap(Map<String, List<String>?> value) => _setValue(_likedSkibsMap, value);


  List<Map<String, dynamic>> getUserFeed() => (_box.get(_userFeed, defaultValue: []) as List).map((e) => Map<String, dynamic>.from(e)).toList();



  Future<void> setUserFeed(List<Map<String, dynamic>> value) => _setValue(_userFeed, value);


  List<String>? getBlockedUsers() => _getValue(_blockedUsers, defaultValue: []);
  Future<void> setBlockedUsers(List<String> value) => _setValue(_blockedUsers, value);


  Future<bool> storeUserFeedInInternalStorage(List<FeedPost> feedPostsList, context) async {
    try {
      await InternalStorageService.getInstance().setUserFeed(feedPostsList.map((e) { return e.toMap();}).toList());

      Provider.of<FeedData>(context, listen: false).initialiseUserFeed(feedPostsList);

      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<List<FeedPost>> getFeed(context) async {

    try {
     var listMap = await InternalStorageService.getInstance().getUserFeed();

     var listFeed = listMap.map((e) => FeedPost.fromMap(e)).toList();

     Provider.of<FeedData>(context, listen: false).initialiseUserFeed(listFeed);

     return listFeed;

    }
    catch(e) {

      return [];
    }
  }
}