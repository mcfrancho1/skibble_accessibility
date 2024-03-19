import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Preferences {
  static const _preferencesBox = '_preferencesBox';
  static const _theme = 'themeKey';
  static const _chatsNotificationKey = 'chats_notification_mode';
  static const _communityMessagesNotificationMode = 'community_messages_notification_mode';
  static const _followersNotificationMode = 'followers_notification_mode';
  static const _recipesNotificationMode = 'recipes_notification_mode';
  static const _skibsNotificationMode = 'skibs_notification_mode';
  static const _storiesNotificationMode = 'stories_notification_mode';
  static const _currentConvoId = 'conversationIdKey';
  static const _currentUserId = 'userIdKey';
  static const _currentNotificationToken = 'currentNotificationToken';
  static const _firstTimeStart = 'firstTimeStartKey';

  static const _localeKey = 'localKey';

  static const _isChefServiceNotifyMeButtonClicked = 'isChefServiceNotifyMeButtonClicked';

  static const _firstTimeEmailVerifiedKey = '_firstTimeEmailVerifiedKey';
  static const _firstTimeChefMenuKey = '_firstTimeChefMenuKey';


  final Box<dynamic> _box;

  Preferences._(this._box);



  // Make sure the box is open
  static Future<dynamic> init() async {

    if (!kIsWeb && !Hive.isBoxOpen(_preferencesBox))
      Hive.init((await getApplicationDocumentsDirectory()).path);

    return await Hive.openBox<dynamic>(_preferencesBox);
  }

  static Preferences getInstance() {


    final box =  Hive.box(_preferencesBox);
    return Preferences._(box);
  }

  bool get isOpen => Hive.isBoxOpen(_preferencesBox);

  //private getter method to help hide the keys
  T _getValue<T>(dynamic key, {T? defaultValue}) => _box.get(key, defaultValue: defaultValue) as T;

  //private setter method to help hide the keys
  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);


  /// public getter and setter methods
  ///

  static String getPreferencesBox() => _preferencesBox;


  bool? getFirstTimeEmailVerifiedKey() => _getValue(_firstTimeEmailVerifiedKey, defaultValue: false);
  Future<void> setFirstTimeEmailVerifiedKey(bool value) => _setValue(_firstTimeEmailVerifiedKey, value);

  ///theme getters and setters
  String? getThemeKey({String? defaultValue}) => _getValue(_theme, defaultValue: defaultValue);
  Future<void> setThemeKey(String value) => _setValue(_theme, value);

  String? getLocaleKey({String? defaultValue}) => _getValue(_localeKey, defaultValue: defaultValue);
  Future<void> setLocaleKey(String value) => _setValue(_localeKey, value);

  bool? getFirstTimeStartKey({bool? defaultValue}) => _getValue(_firstTimeStart, defaultValue: defaultValue ?? true);
  Future<void> setFirstTimeStartKey(bool value) => _setValue(_firstTimeStart, value);


  String? getConvoIdKey({String? defaultValue}) => _getValue(_currentConvoId, defaultValue: '');
  Future<void> setConvoIdKey(String value) => _setValue(_currentConvoId, value);


  String? getCurrentUserIdKey({String? defaultValue}) => _getValue(_currentUserId, );
  Future<void> setCurrentUserIdKey(String? value) => _setValue(_currentUserId, value);

  String? getCurrentNotificationToken() => _getValue(_currentNotificationToken);
  Future<void> setCurrentNotificationToken(String value) => _setValue(_currentNotificationToken, value);


  bool? getIsChefServiceNotifyMeButtonClicked({bool? defaultValue}) => _getValue(_isChefServiceNotifyMeButtonClicked, defaultValue: defaultValue);
  Future<void> setIsChefServiceNotifyMeButtonClicked(bool value) => _setValue(_isChefServiceNotifyMeButtonClicked, value);


  ///Notification getters and setters
  ///

  //chats
  bool? getChatNotificationKey({bool? defaultValue}) => _getValue(_chatsNotificationKey, defaultValue: defaultValue);
  Future<void> setChatNotificationKey(bool value) => _setValue(_chatsNotificationKey, value);

  //community messages
  bool? getCommunityMessagesNotificationKey({bool? defaultValue}) => _getValue(_communityMessagesNotificationMode, defaultValue: defaultValue);
  Future<void> setCommunityMessagesNotificationKey(bool value) => _setValue(_communityMessagesNotificationMode, value);

  //followers
  bool? getFollowersNotificationKey({bool? defaultValue}) => _getValue(_followersNotificationMode, defaultValue: defaultValue);
  Future<void> setFollowersNotificationKey(bool value) => _setValue(_followersNotificationMode, value);

  //recipes
  bool? getRecipesNotificationKey({bool? defaultValue}) => _getValue(_recipesNotificationMode, defaultValue: defaultValue);
  Future<void> setRecipesNotificationKey(bool value) => _setValue(_recipesNotificationMode, value);

  //skibs
  bool? getSkibsNotificationKey({bool? defaultValue}) => _getValue(_skibsNotificationMode, defaultValue: defaultValue);
  Future<void> setSkibsNotificationKey(bool value) => _setValue(_skibsNotificationMode, value);

  //stories
  bool? getStoriesNotificationKey({bool? defaultValue}) => _getValue(_storiesNotificationMode, defaultValue: defaultValue);
  Future<void> setStoriesNotificationKey(bool value) => _setValue(_storiesNotificationMode, value);

}