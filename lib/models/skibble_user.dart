import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/models/shopping_list.dart';
import 'package:skibble/models/skibble_file.dart';
import 'package:skibble/models/skibble_post.dart';
import 'package:skibble/models/moment.dart';
import 'package:skibble/services/firebase/custom_collections_references.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/helper_methods.dart';

import 'blocked_model.dart';
import 'chef.dart';
import 'kitchen.dart';
import 'notification_model/user_notification_settings.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as streamchat;

// part 'skibble_user.g.dart';


enum SkibbleUserStatus {deleted, active}
enum AccountType {user, chef, kitchen, restaurant}

// @HiveType(typeId: 3)
class SkibbleUser {
  // @HiveField(0)
  String? fullName;

  // @HiveField(1)
  String? userName;

  num meetScore;
  String? aboutMe;

  // @HiveField(2)
  int? skibbleTokens;

  // @HiveField(3)
  String? profileImageUrl;
  List<SkibbleFile>? profileMediaList;

  String? mapImageUrl;
  bool isLocationServicesEnabled;
  bool isLocationPermissionEnabled;
  bool isNotificationPermissionEnabled;

  // @HiveField(4)
  String? userId;
  String? docRef;

  // @HiveField(5)
  String? userEmailAddress;

  // @HiveField(6)
  String? userPhoneNumber;

  // @HiveField(7)
  String? userPassword;

  // @HiveField(8)
  bool? isEmailVerified;

  // @HiveField(9)
  bool isUserVerified;
  bool isAgeVerified;


  // @HiveField(10)
  String? notificationToken;

  // @HiveField(11)
  Address? userAddress;
  Address? userCurrentLocation;

  // @HiveField(12)
  bool? isActive;

  // @HiveField(13)
  bool isASkibbleRegisteredChef;

  // @HiveField(14)
  Chef? chef;
  Kitchen? kitchen;


  // @HiveField(15)
  SkibbleUserStatus status;

  // @HiveField(16)
  bool? sendFriendRequestNotifications;

  // @HiveField(17)
  int? timeLastActive;

  // @HiveField(18)
  int? accountCreatedAt;

  // @HiveField(19)
  int? lastLoginTimeStamp;

  // @HiveField(20)
  List<Moment>? userMomentList = [];

  // @HiveField(21)
  List<SkibblePost>? userSkibblePostList = [];

  // @HiveField(22)
  List<SkibblePost>? userFeed = [];

  //keeps track of user recent posts in their doc
  // @HiveField(23)
  List? recentPosts;

  // @HiveField(24)
  List? recentMoments;

  // @HiveField(25)
  List? recentRecipes;

  // @HiveField(26)
  num? totalFollowers;

  // @HiveField(27)
  num? totalFollowings;

  // @HiveField(28)
  num? totalFriends;

  // @HiveField(29)
  Set<String>? friendsSet;
  AccountType accountType;

  // @HiveField(30)
  List<String>? followersList;

  // @HiveField(31)
  List<String>? followingsList;

  // // @HiveField(32)
  // List<String>? blockedUsers;
  //
  // // @HiveField(33)
  // List<BlockedModel>? usersWhoBlockedMe;

  // @HiveField(34)
  Map<String, List<String>>? followingsDocMap;

  // @HiveField(35)
  Map<String, List<String>>? followersDocMap;

  // @HiveField(36)
  Map<String, int>? followersCountDocMap;

  // @HiveField(37)
  Map<String, int>? followingsCountDocMap;

  // @HiveField(38)
  Map<String, int>? likedSkibsCountDocMap;

  // @HiveField(39)
  Map<String, int>? likedRecipesCountDocMap;


  // @HiveField(40)
  List<ShoppingList>? shoppingLists;

  // @HiveField(41)
  List<String>? contentPreferences;

  List<String>? accessibilityPreferences;

  //this is fetched from its collection of user communities
  // @HiveField(42)
  List<String>? memberCommunities;

  // @HiveField(43)
  Color? userCustomColor;

  //temporarily Using this as a test to know friends who have deleted or blocked you
  // @HiveField(44)
  String? friendStatus;

  //Recording audio, Typing, or none
  //but the enum style will be {recording, typing, none"
  // @HiveField(45)
  String? chatStatus;

  // @HiveField(46)
  bool isStripeConnectSetup;

  //keeps track of the total posts for a particular user
  // @HiveField(47)
  int? totalNumberOfPosts;

  // @HiveField(48)
  int? totalNumberOfMoments;

  // @HiveField(49)
  int? totalNumberOfRecipes;

  //keeps track of the number of recent posts for a user
  // @HiveField(50)
  int? numberOfRecentPosts;

  // @HiveField(51)
  int? numberOfRecentMoments;

  // @HiveField(52)
  int? numberOfRecentRecipes;


  //keeps track of the current array of the user member community
  // @HiveField(53)
  String? currentMemberCommunitiesDocId;

  bool hasASkibbleKitchen;

  // @HiveField(54)
  final UserNotificationSettings? userNotificationSettings;


  SkibbleUser({
    this.fullName,
    this.userName,
    this.aboutMe,
    this.skibbleTokens,
    this.profileImageUrl,
    this.profileMediaList,
    this.mapImageUrl,
    this.accountType = AccountType.user,
    this.userId,
    this.docRef,
    this.userEmailAddress,
    this.userPassword,
    this.userPhoneNumber,
    this.isEmailVerified = false,
    this.userAddress,
    this.isActive = false,
    this.isASkibbleRegisteredChef = false,
    this.hasASkibbleKitchen = false,
    this.chef,
    this.kitchen,
    this.status = SkibbleUserStatus.active,
    this.timeLastActive,
    this.accountCreatedAt,
    this.lastLoginTimeStamp,
    this.chatStatus = 'none',
    this.sendFriendRequestNotifications = true,
    this.friendStatus = 'none',
    this.meetScore = 10,
    this.userMomentList,
    this.userSkibblePostList,
    this.userCustomColor = kPrimaryColor,
    this.totalNumberOfPosts = 0,
    this.numberOfRecentPosts = 0,
    this.totalFollowers = 0,
    this.totalFollowings = 0,
    this.isUserVerified = false,
    this.isAgeVerified = false,
    this.isLocationServicesEnabled = false,
    this.isLocationPermissionEnabled = false,
    this.isNotificationPermissionEnabled = false,
    // this.totalFriends = 0,
    this.friendsSet,
    this.followersList,
    this.followingsList,
    this.userFeed,
    // this.blockedUsers,
    // this.usersWhoBlockedMe,
    this.recentMoments,
    this.recentRecipes,
    this.recentPosts,
    this.numberOfRecentMoments = 0,
    this.numberOfRecentRecipes = 0,
    this.totalNumberOfMoments = 0,
    this.totalNumberOfRecipes = 0,
    this.followersDocMap,
    this.followingsDocMap,
    this.followersCountDocMap,
    this.followingsCountDocMap,
    this.shoppingLists,
    this.memberCommunities,
    this.notificationToken,
    this.userNotificationSettings,
    this.contentPreferences,
    this.accessibilityPreferences,
    this.isStripeConnectSetup = false,
    this.currentMemberCommunitiesDocId = 'member_community_1',
    this.likedRecipesCountDocMap,
    this.likedSkibsCountDocMap,
    this.userCurrentLocation
  });
      // :
      // this.userNotificationSettings = userNotificationSettings != null ? userNotificationSettings :  UserNotificationSettings(isMomentsEnabled: false, isSkibsEnabled: false, isRecipeEnabled: false, isFollowRequestEnabled: true, isChatMessageEnabled: true, isCommunityMessageEnabled: false);

  SkibbleUser copyWith({String? fullName, String? userName, String? email, String? userId, bool? isEmailVerified, AccountType? accountType}){
      this.fullName = fullName ?? this.fullName;
      this.userName = userName ?? this.userName;
      userEmailAddress = email ?? userEmailAddress;
      this.isEmailVerified = isEmailVerified ?? this.isEmailVerified;
      this.accountType = accountType ?? this.accountType;

      return this;

    //   SkibbleUser(
    //   fullName: fullName ,
    //   userName: userName,
    //   userId: userId,
    //   userEmailAddress: email,
    //   isEmailVerified:  isEmailVerified,
    //   accountType: accountType,
    // );
  }

  factory SkibbleUser.fromJsonString(String userString) {
    return SkibbleUser.fromMap(jsonDecode(userString));
  }

  factory SkibbleUser.fromStreamChatUser(streamchat.User user) {
    return SkibbleUser(
      fullName: user.name,
      userId: user.id,
      profileImageUrl: user.image,
      profileMediaList: user.image != null ? [SkibbleFile(fileType: SkibbleFileType.image, isContentSafetyVerified: true, mediaUrl: user.image)] : [],
      accountCreatedAt: user.createdAt != null ? user.createdAt?.millisecondsSinceEpoch : null,
      userName: user.extraData['userName'] != null ? (user.extraData['userName'] as String) : null
    );
  }

  String toJsonString() {
    return jsonEncode(toMap());
  }

  factory SkibbleUser.fromFirebaseUser(User firebaseUser) {
    return SkibbleUser(
      fullName: null,
      userId: firebaseUser.uid,
      docRef: '${FirebaseCollectionReferences.usersCollection.path}/${firebaseUser.uid}',
      isEmailVerified: firebaseUser.emailVerified ?? false,
      userName: null,
      accountType: AccountType.user,
      userEmailAddress: firebaseUser.email,
      userPhoneNumber: firebaseUser.phoneNumber,
      profileImageUrl: firebaseUser.photoURL,
      // profileMediaList: firebaseUser.photoURL != null ? [firebaseUser.photoURL!] : null
      profileMediaList: firebaseUser.photoURL != null ? [SkibbleFile(fileType: SkibbleFileType.image, isContentSafetyVerified: true, mediaUrl: firebaseUser.photoURL!)] : [],

    );
  }
  factory SkibbleUser.fromMap(Map<String, dynamic> data) {
    return SkibbleUser(
      fullName: data['fullName'],
      userId: data['userId'],
      docRef: data['docRef'] ?? 'Users/${data['userId']}',
      userName: data['userName'],
      accountType: data['accountType'] !=  null ? AccountType.values.firstWhere((e) => e.name == (data['accountType']).toString(), orElse: () => AccountType.user) : AccountType.user,
      userEmailAddress: data['userEmailAddress'],
      userPhoneNumber: data['userPhoneNumber'],
      aboutMe: data['aboutMe'],
      profileImageUrl: data['profileImageUrl'],
      profileMediaList: data['profileMediaList'] != null ? List.from(data['profileMediaList']).map((e) => SkibbleFile.fromMap(e as Map<String, dynamic>)).toList() : data['profileImageUrl'] != null ? [SkibbleFile(fileType: SkibbleFileType.image, isContentSafetyVerified: true, mediaUrl: data['profileImageUrl'])] : [],

      // profileMediaList: data['profileMediaList'],
      mapImageUrl: data['mapImageUrl'],
      skibbleTokens: data['skibbleTokens'],
      isLocationServicesEnabled: data['isLocationServicesEnabled'] ?? false,
      isLocationPermissionEnabled: data['isLocationPermissionEnabled'] ?? false,
      isNotificationPermissionEnabled: data['isNotificationPermissionEnabled'] ?? false,
      meetScore: data['meetScore']  ?? 10,
      isEmailVerified: data['isEmailVerified'] ?? false,
      isActive: data['isActive'] ?? false,
      isStripeConnectSetup: data['isStripeConnectSetup'] ?? false,
      timeLastActive: data['timeLastActive'] != null ? DateTime.fromMillisecondsSinceEpoch(data['timeLastActive']).toLocal().millisecondsSinceEpoch : null,
      accountCreatedAt: data['accountCreatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(data['accountCreatedAt']).toLocal().millisecondsSinceEpoch : null,
      lastLoginTimeStamp: data['lastLoginTimeStamp'] != null ? DateTime.fromMillisecondsSinceEpoch(data['lastLoginTimeStamp']).toLocal().millisecondsSinceEpoch : null,
      userAddress:data['userAddress'] != null ?  Address.fromMap(data['userAddress']) : null,
      isASkibbleRegisteredChef: data["isASkibbleRegisteredChef"] ?? false,
      hasASkibbleKitchen: data["hasASkibbleKitchen"] ?? false,
      chef: data["isASkibbleRegisteredChef"] == true ? data["chefDetails"] != null ? Chef.fromMap(data['chefDetails']) : null : null,
      kitchen: data["hasASkibbleKitchen"] == true ? data["kitchenDetails"] != null ? Kitchen.fromMap(data['kitchenDetails']) : null : null,
      chatStatus: data['chatStatus'] ?? 'none',
      friendStatus: data['friendStatus'],
      sendFriendRequestNotifications: data['sendFriendRequestNotifications'] ?? false,
      userMomentList: List<Moment>.from(data['userMomentList']  ?? []),
      userCustomColor: data['userCustomColor'] != null ? HelperMethods().getColorFromInt(data['userCustomColor']) : kPrimaryColor,
      totalNumberOfPosts: data['totalNumberOfPosts'] ?? 0,
      totalNumberOfRecipes: data['totalNumberOfRecipes'] ?? 0,
      numberOfRecentPosts: data['numberOfRecentPosts'] ?? 0,
      numberOfRecentRecipes: data['numberOfRecentRecipes'] ?? 0,
      numberOfRecentMoments: data['numberOfRecentMoments'] ?? 0,
      followersDocMap: {},
      followingsDocMap: {},
      userCurrentLocation: data['userCurrentLocation'] != null ? Address.fromMap(data['userCurrentLocation']) : null,
      // accountStatus: data['accountStatus'] ?? 'active',
      isUserVerified: data['isUserVerified'] ?? false,
      isAgeVerified: data['isAgeVerified'] ?? false,

      contentPreferences: data['contentPreferences'] != null ?  List<String>.from(data['contentPreferences']) : [] ,
      accessibilityPreferences: data['accessibilityPreferences'] != null ?  List<String>.from(data['accessibilityPreferences']) : [] ,

      followersCountDocMap: data['followersCountDocMap'] != null ? (( Map<String, dynamic>.from(data['followersCountDocMap'])).map((key, value) => MapEntry(key, value))) : {'followers_1': 0},
      followingsCountDocMap: data['followingsCountDocMap'] != null ? (( Map<String, dynamic>.from(data['followingsCountDocMap'])).map((key, value) => MapEntry(key, value))) : {'followings_1': 0},
      likedSkibsCountDocMap: data['likedSkibsCountDocMap'] != null ? ((Map<String, dynamic>.from(data['likedSkibsCountDocMap'])).map((key, value) => MapEntry(key, value))) : {'liked_skibs_1': 0},
      likedRecipesCountDocMap: data['likedRecipesCountDocMap'] != null ? (( Map<String, dynamic>.from(data['likedRecipesCountDocMap'])).map((key, value) => MapEntry(key, value))) : {'liked_recipes_1': 0},
      //note: we're not fetching this data directly from the map, this is just a cover
      followersList: data['followersList'] ?? [],
      followingsList: data['followingsList'] ?? [],
      totalFollowings: data['totalFollowings'] ?? 0,
      // totalFriends: data['totalFriends'] ?? 0,
      totalFollowers: data['totalFollowers'] ?? 0,
      totalNumberOfMoments: data['totalNumberOfMoments'] ?? 0,
      recentMoments: data['recentMoments'] ?? [],
      recentPosts:  data['recentPosts'] ?? [],
      recentRecipes:  data['recentRecipes'] ?? [],
      currentMemberCommunitiesDocId: data['currentMemberCommunitiesDocId'],
      memberCommunities: [],
      notificationToken: data['token'] ?? null,
      // blockedUsers: data['blockedUsers'] ?? [],
      // usersWhoBlockedMe: [],
      userNotificationSettings:  data['userNotificationSettings'] != null ? UserNotificationSettings.fromMap(Map<String, dynamic>.from(data['userNotificationSettings'])) : null,

    );
  }

  ///This is data that will be duplicated in our backend for places like posts, recipes etc.
  Map<String, dynamic> toPublicProfileMap() {
    Map<String, dynamic> map = {
      'fullName': fullName,
      'userId': userId,
      'docRef': docRef ?? '${FirebaseCollectionReferences.usersCollection.path}/${userId}',
      'userName': userName,
      'aboutMe': aboutMe,
      'userCustomColor': HelperMethods().getIntFromColor(userCustomColor!),
      'profileImageUrl': profileImageUrl,
      "profileMediaList": profileMediaList?.map((skibbleFile) => skibbleFile.toMap()).toList(),
      'mapImageUrl': mapImageUrl,
      'isUserVerified': isUserVerified,
      'isAgeVerified': isAgeVerified,

      'accountType': accountType.name,
      'timeLastActive': timeLastActive,
      'isASkibbleRegisteredChef': isASkibbleRegisteredChef,
      'hasASkibbleKitchen': hasASkibbleKitchen,
      'meetScore': meetScore
      // 'timeLastActive': timeLastActive != null ? DateTime.fromMillisecondsSinceEpoch(timeLastActive!).toUtc().millisecondsSinceEpoch : null,
      // 'isActive': this.isActive,
    };

    return map;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'fullName': fullName,
      'userId': userId,
      'userName': userName,
      'aboutMe': aboutMe,
      'docRef': docRef ?? '${FirebaseCollectionReferences.usersCollection.path}/${userId}',
      'accountType': accountType.name,
      'userEmailAddress': userEmailAddress,
      'userPhoneNumber': userPhoneNumber,
      'profileImageUrl': profileImageUrl,
      "profileMediaList": profileMediaList?.map((skibbleFile) => skibbleFile.toMap()).toList(),
      'mapImageUrl': mapImageUrl,
      'skibbleTokens': skibbleTokens,
      'isEmailVerified': isEmailVerified,
      'isUserVerified': isUserVerified,
      'isAgeVerified': isAgeVerified,
      'isActive': isActive,
      'timeLastActive': timeLastActive != null ? DateTime.fromMillisecondsSinceEpoch(timeLastActive!).toUtc().millisecondsSinceEpoch : null,
      'accountCreatedAt': accountCreatedAt != null ? DateTime.fromMillisecondsSinceEpoch(accountCreatedAt!).toUtc().millisecondsSinceEpoch : null,
      'lastLoginTimeStamp': lastLoginTimeStamp != null ? DateTime.fromMillisecondsSinceEpoch(lastLoginTimeStamp!).toUtc().millisecondsSinceEpoch : null,
      'chatStatus': chatStatus,
      'friendStatus': friendStatus,
      'sendFriendRequestNotifications': sendFriendRequestNotifications,
      'userMomentList': userMomentList,
      'hasASkibbleKitchen': hasASkibbleKitchen,
      'isASkibbleRegisteredChef': isASkibbleRegisteredChef,
      'userCustomColor': HelperMethods().getIntFromColor(userCustomColor!),
      'recentPosts': recentPosts,
      // 'accountStatus': this.accountStatus,
      'recentRecipes': recentRecipes,
      'recentMoments': recentMoments,
      'totalNumberOfPosts': totalNumberOfPosts,
      'totalNumberOfRecipes': totalNumberOfRecipes,
      'totalNumberOfMoments': totalNumberOfMoments,
      'numberOfRecentPosts': numberOfRecentPosts,
      'numberOfRecentMoments': numberOfRecentMoments,
      'numberOfRecentRecipes': numberOfRecentRecipes,
      'followersCountDocMap': followersCountDocMap ?? {'followers_1': 0},
      'followingsCountDocMap': followingsCountDocMap ?? {'followings_1': 0},
      'likedRecipesCountDocMap': likedRecipesCountDocMap ?? {'liked_recipes_1': 0},
      'likedSkibsCountDocMap': likedSkibsCountDocMap ?? {'liked_skibs_1': 0},
      'totalFollowers': totalFollowers,
      // 'totalFriends': this.totalFriends,
      'totalFollowings': totalFollowings,
      'token': notificationToken,
      'meetScore': meetScore,
      'contentPreferences': contentPreferences,
      "accessibilityPreferences": accessibilityPreferences,
      'isStripeConnectSetup': isStripeConnectSetup,
      'userNotificationSettings': UserNotificationSettings(isMomentsEnabled: false, isSkibsEnabled: false, isRecipeEnabled: false, isFollowRequestEnabled: true, isChatMessageEnabled: true, isCommunityMessageEnabled: false, isMeetsEnabled: true).toMap(),
      'currentMemberCommunitiesDocId': currentMemberCommunitiesDocId
      // 'userLocation': skibbleUser.userLocation!.toMap(skibbleUser.userLocation!)
    };

    if(userAddress != null) {
      map['userAddress'] = userAddress!.toMap();
    }
    else {
      map['userAddress'] = null;
    }

    if(userCurrentLocation != null) {
      map['userCurrentLocation'] = userCurrentLocation!.toMap();
    }
    else {
      map['userCurrentLocation'] = null;
    }

    if(chef != null) {
      map['chefDetails'] = chef!.toMap();
    }
    else {
      map['chefDetails'] = null;

    }

    if(kitchen != null) {
      map['kitchenDetails'] = kitchen!.toMap();
    }
    else {
      map['kitchenDetails'] = null;

    }
    return map;
  }


  ///updates
  Map<String, dynamic> updateToMap(SkibbleUser skibbleUser) {
    return {
      'fullName': fullName,
      'profileImageUrl': profileImageUrl,
      "profileMediaList": profileMediaList?.map((skibbleFile) => skibbleFile.toMap()).toList(),
      'mapImageUrl': mapImageUrl,
      'userName': userName,
      'aboutMe': aboutMe,
      'contentPreferences': contentPreferences,
      'meetScore': meetScore
    };
  }

  Map<String, dynamic> updateUserChefToMap(SkibbleUser skibbleUser, List<Map<String, dynamic>> workExperience, List<Map<String, dynamic>> certifications, ) {
    Map<String, dynamic> map = {
      'fullName': fullName,
      'userName': userName,
      'userPhoneNumber': userPhoneNumber,
      'profileImageUrl': profileImageUrl,
      "profileMediaList": profileMediaList?.map((skibbleFile) => skibbleFile.toMap()).toList(),
      'mapImageUrl': mapImageUrl,
      'aboutMe': aboutMe,
      'meetScore': meetScore,
      'sendFriendRequestNotifications': sendFriendRequestNotifications,
      // 'reviewsList': this.reviewsList,
      'chefDetails.chargeRate': chef!.chargeRate,
      'chefDetails.chargeRateString': chef!.chargeRateString,
      'chefDetails.chargeRateType': chef!.chargeRateType,
      'chefDetails.certificationsList': chef!.certificationsList,
      'chefDetails.workExperienceList': chef!.workExperienceList,
      // 'chefDetails.kitchenSkillsRating': this.chef!.kitchenSkillsRating,
      'chefDetails.foodSpecialtyList': chef!.foodSpecialtyList,
      'chefDetails.description': chef!.description,
      'chefDetails.coverImageUrl': chef!.coverImageUrl,
      'chefDetails.isChargeNegotiable': chef!.isChargeNegotiable,
      'chefDetails.receivePrivateMessages': chef!.receivePrivateMessages,
      // 'userLocation': skibbleUser.userLocation!.toMap(skibbleUser.userLocation!)
    };

    // if(skibbleUser.chef != null) {
    //   map['chefDetails'] = skibbleUser.chef!.updateChefToMap(workExperience, certifications);
    // }
    // else {
    //   map['chefDetails'] = null;
    //
    // }
    return map;
  }

}