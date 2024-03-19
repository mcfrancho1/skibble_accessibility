import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/user_controller.dart';
import 'package:skibble/models/report_user.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/models/stream_models/users_i_blocked_stream.dart';
import 'package:skibble/services/firebase/database/chats_database.dart';
import 'package:skibble/services/firebase/database/friend_requests_database.dart';
import 'package:skibble/services/firebase/storage.dart';

import '../../../models/address.dart';
import '../../../models/feed_post.dart';
import '../../../models/skibble_file.dart';
import '../../../models/stream_models/followings_stream.dart';
import '../../../models/user_images.dart';
import '../../../models/stream_models/users_who_blocked_me_stream.dart';
import '../../change_data_notifiers/app_data.dart';
import '../../internal_storage.dart';
import '../custom_collections_references.dart';


class UserDatabaseService {

  // final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
  // final CollectionReference FirebaseCollectionReferences.chatsCollection = FirebaseFirestore.instance.collection('Chats');

  static const String _FriendsCollectionName = 'friends';
  // static const String _BlockedCollectionName = 'blocked';



  ///Used to read a particular user data
  ///isCurrentUser shows if we are getting data for a current user


  Future<SkibbleUser?> getCurrentUserDoc(String userId) async{

    try{

      DocumentSnapshot snapshot = await FirebaseCollectionReferences.usersCollection.doc(userId).get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      SkibbleUser user = SkibbleUser.fromMap(data);

      // user.memberCommunities = await getUserMemberCommunities(user);
      // user.blockedUsers = await getUserBlockedUsers(user);

      return user;
    }
    catch(e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> getCurrentUserAllLikedSkibs(String userId, context) async {
    try {
      QuerySnapshot snapshot = await FirebaseCollectionReferences.usersCollection.doc(userId).collection(FirebaseCollectionReferences.likedSkibsSubCollection).get();

      Map<String, dynamic> likesData = {};

      Map<String, List<String>> likesMap = {};
      List<String> likesList = [];

      snapshot.docs.forEach((likeDoc) {
        var data = likeDoc.data() as Map<String, dynamic>;
        List<String> newList = List<String>.from(data['likes'] ?? []);
        likesMap.putIfAbsent(likeDoc.id, () => newList);

        likesList.addAll(newList);
      });

      likesData['likesMap'] = likesMap;
      likesData['likesList'] = likesList;

      return likesData;
    }
    catch(e) {
      return {};
    }
  }

  Future<String> updateChefKitchenDetails(String userId, Map<String, dynamic> kitchenDetails ) async {
    try {
      var docsWithSameKitchenName = await FirebaseCollectionReferences.usersCollection.where('userName', isNotEqualTo: null).where('userName', isEqualTo: kitchenDetails['kitchenUserName']).get();

      if(docsWithSameKitchenName.size == 0) {
        await FirebaseCollectionReferences.usersCollection.doc(userId).set(
            {
              'kitchenDetails': kitchenDetails,
              'fullName': kitchenDetails['kitchenName'],
              'userName': kitchenDetails['kitchenUserName']
            },
            SetOptions(merge: true));
        return 'success';
      }

      else {

        ///The same user is still trying to update their data
        if(docsWithSameKitchenName.docs.first.id == userId) {
          await FirebaseCollectionReferences.usersCollection.doc(userId).set(
              {
                'kitchenDetails': kitchenDetails,
                'fullName': kitchenDetails['kitchenName'],
                'userName': kitchenDetails['kitchenUserName']
              },
              SetOptions(merge: true));
          return 'success';
        }
        else {
          return 'kitchen-username-exists';
        }
      }
    }
    catch(e) {
      print(e);
      return 'error';
    }
  }


  Future<String> updateChefAccountDetails(String userId, Map<String, dynamic> accountDetails ) async {
    try {
        await FirebaseCollectionReferences.usersCollection.doc(userId).set(
            {'kitchenDetails': accountDetails},
            SetOptions(merge: true));
        return 'success';
    }
    catch(e) {
      return 'error';
    }
  }

  Future<String> updateUserIsLocationServiceEnabled(String userId, bool value ) async {
    try {
      await FirebaseCollectionReferences.usersCollection.doc(userId).set(
          {'isLocationServicesEnabled': value},
          SetOptions(merge: true));
      return 'success';
    }
    catch(e) {
      return 'error';
    }
  }

  Future<String> updateUserIsLocationPermissionEnabled(String userId, bool value ) async {
    try {
      await FirebaseCollectionReferences.usersCollection.doc(userId).set(
          {'isLocationPermissionEnabled': value},
          SetOptions(merge: true));
      return 'success';
    }
    catch(e) {
      return 'error';
    }
  }

    Future<Map<String, dynamic>?> updateChefQualificationDocuments(String userId, Map<String, List<PlatformFile>?> files ) async {
    try {
      Map<String, dynamic> downloadUrlsMap = {};

      var foodHandlerCertificateFile = files['foodHandlerCertificate']?.first != null ? File(files['foodHandlerCertificate']!.first.path!) : null;
      var foodLicense = files['foodLicense']?.first != null ? File(files['foodLicense']!.first.path!) : null;

      if(foodHandlerCertificateFile != null) {
        downloadUrlsMap['foodHandlerCertificate'] = await StorageService().uploadFoodHandlerCertificate(foodHandlerCertificateFile, userId);
      }

      if(foodLicense != null) {
        downloadUrlsMap['foodLicense'] = await StorageService().uploadFoodLicense(foodLicense, userId);
      }

      await FirebaseCollectionReferences.usersCollection.doc(userId).set(
          {
            'kitchenDetails': {
              'foodHandlerCertificationDocUrl': downloadUrlsMap['foodHandlerCertificate'],
              'foodLicenseOrPermitDocUrl': downloadUrlsMap['foodLicense']
            }
          },
          SetOptions(merge: true));
      return downloadUrlsMap;
    }
    catch(e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> getCurrentUserAllLikedRecipes(String userId, context) async {
    try {
      QuerySnapshot snapshot = await FirebaseCollectionReferences.usersCollection.doc(userId).collection(FirebaseCollectionReferences.likedRecipesSubCollection).get();

      Map<String, dynamic> likesData = {};


      Map<String, List<String>> likesMap = {};
      List<String> likesList = [];

      snapshot.docs.forEach((likeDoc) {
        var data = likeDoc.data() as Map<String, dynamic>;
        List<String> newList = List<String>.from(data['likes'] ?? []);

        likesMap.putIfAbsent(likeDoc.id, () => newList);
        likesList.addAll(newList);

      });



      likesData['likesMap'] = likesMap;
      likesData['likesList'] = likesList;

      return likesData;
    }
    catch(e) {
      return {};
    }
  }


  Future<Map<String, dynamic>?> getChefStripeId(String userId, context) async {
    try {
      var doc = await FirebaseCollectionReferences.usersCollection.doc(userId).get();

      var data = doc.data() as Map<String, dynamic>;

      if(data['stripe_account_id'] != null) {

        if(data['isStripeConnectSetup'] != null) {
          Provider.of<AppData>(context, listen: false).updateIsStripeComplete(data['isStripeConnectSetup']);
        }
        else {
          Provider.of<AppData>(context, listen: false).updateIsStripeComplete(false);
        }

        return {'account_id': data['stripe_account_id'], 'isStripeConnectSetup': data['isStripeConnectSetup'] ?? false};
      }
      else {
        return null;
      }
    }
    catch(e) {
      return null;
    }
  }

  Future<bool> setStripeAccountReady(String userId) async {
    try {
      await FirebaseCollectionReferences.usersCollection.doc(userId).set({'isStripeConnectSetup': true}, SetOptions(merge: true));

      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<SkibbleUser?> getUser(String userId, context) async {
    try {
      var user = Provider.of<AppData>(context,listen: false).getUserFromMap(userId);
      var currentUser = Provider.of<AppData>(context,listen: false).skibbleUser!;

      if(currentUser.userId == userId) {
       return currentUser;
      }

      else {
        if(user != null) {
          return user;
        }
        else {
          return await getUserDoc(userId, context);
        }
      }
    }
    catch(e) {
      return null;
    }
  }

  Future<List<SkibbleUser>> getUsersInfoWithCollectionRef(CollectionReference reference, int limit) async {
    try {
      return await reference.limit(limit).get().then((value) => _usersListFromSnapshot(value));
    }
    catch(e) {
      return [];
    }
  }

  Future<List<SkibbleUser>> getOlderUsersInfoWithCollectionRef(CollectionReference reference, String lastId, int limit) async {
    try {
      var lastDoc = await reference.doc(lastId).get();
      return await reference.startAfterDocument(lastDoc).limit(limit).get().then((value) => _usersListFromSnapshot(value));
    }
    catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<SkibbleUser>> getListOfUsers(List<String> userIds, SkibbleUser skibbleUser, String type, context,{int? lastIndex = 0} ) async {
    try {
      List<SkibbleUser> users = [];

      for(int index = lastIndex!;( index < userIds.length && users.length <= 10); index ++) {
        SkibbleUser? user = await getUserDoc(userIds[index], context);

        if(user != null) {
          users.add(user);
        }

        ///delete the user from the
        else {
          switch(type) {
            //call the controller for handling the follow/unfollow logic
            case 'follow':

              //added a total followers count to avoid the error in the method call
             await UserController().deleteUserFromFollowingsFollowers(skibbleUser, userIds[index], context,);
            break;

          }
        }
      }

      return users;
    }
    catch(e) {
      return [];
    }
  }

  Future<SkibbleUser?> getUserDoc(String userId, context) async{

    try{
      var user = Provider.of<AppData>(context,listen: false).getUserFromMap(userId);

      if(user != null) {
        return user;
      }
      DocumentSnapshot snapshot = await FirebaseCollectionReferences.usersCollection.doc(userId).get();

      //TODO: check if the user data still exists and see if you can add remove it from the current users followings list

      if(snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        SkibbleUser user = SkibbleUser.fromMap(data);

        user.memberCommunities = await getUserMemberCommunities(user);

        Provider.of<AppData>(context, listen: false).addUserToMap(user);

        return user;

      }
      else {

        //TODO: perform a call to delete all instances of this user in the current user collection
        //followings
        //followers
        return null;
      }

      // user.blockedUsers = await getUserBlockedUsers(user);

    }
    catch(e) {
      // print(e);
      return null;
    }
  }

  Future<bool> reportUser(ReportUser reportUser) async {
    try {
      var docRef =  FirebaseCollectionReferences.reportedUsersCollection.doc();

      reportUser.reportId = docRef.id;
      await docRef.set(reportUser.toMap());
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> blockUser(SkibbleUser currentUser, SkibbleUser blockedUser, BuildContext context) async {
    try {
      var batch = FirebaseFirestore.instance.batch();
      var blockerUserRef =  FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.blockedUsersSubCollection).doc(blockedUser.userId);
      var blockedUserRef =  FirebaseCollectionReferences.usersCollection.doc(blockedUser.userId).collection(FirebaseCollectionReferences.blockedByDataSubCollectionName).doc(currentUser.userId);

      var followings = Provider.of<FollowingsStream>(context, listen: false);
      if(followings.getIds().contains(blockedUser.userId)) {
        //unfollow this user first if you are following;
        var result = await FriendRequestsDatabaseService().unFollowUser(currentUser, blockedUser);
      }

      batch.set(blockerUserRef, blockedUser.toPublicProfileMap(), SetOptions(merge: true));
      batch.set(blockedUserRef, blockedUser.toPublicProfileMap(), SetOptions(merge: true));


      var storage = InternalStorageService.getInstance();
      var blocked = await storage.getBlockedUsers();
      (blocked ?? []).add(blockedUser.userId!);
      await storage.setBlockedUsers(blocked ?? []);

      await batch.commit();
      return true;
    }
    catch (e) {
      return false;
    }
  }
  Future<bool> unBlockUser(SkibbleUser currentUser, SkibbleUser unBlockedUser, BuildContext context) async {
    try {
      var batch = FirebaseFirestore.instance.batch();
      var unBlockerUserRef =  FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.blockedUsersSubCollection).doc(unBlockedUser.userId);
      var unBlockedUserRef =  FirebaseCollectionReferences.usersCollection.doc(unBlockedUser.userId).collection(FirebaseCollectionReferences.blockedByDataSubCollectionName).doc(currentUser.userId);


      batch.delete(unBlockerUserRef);
      batch.delete(unBlockedUserRef);

      var storage = InternalStorageService.getInstance();
      var blocked = await storage.getBlockedUsers();
      (blocked ?? []).add(unBlockedUser.userId!);
      await storage.setBlockedUsers(blocked ?? []);

      await batch.commit();
      return true;
    }
    catch (e) {
      return false;
    }
  }
  Stream<UsersWhoBlockedMeStream?>? streamUsersWhoBlockedMe(String currentUserId, context) {
    try {

      return FirebaseCollectionReferences.usersCollection.doc(currentUserId).collection(FirebaseCollectionReferences.blockedByDataSubCollectionName)

      //TODO: change this later when we start storing the users data in firebase
      .snapshots().map((snapshot) => UsersWhoBlockedMeStream(_usersListFromSnapshot(snapshot, context: context)));
    }
    catch(e) {
      return null;
    }
  }

  Stream<UsersIBlockedStream?>? streamUsersIBlocked(String currentUserId, context) {
    try {

      return FirebaseCollectionReferences.usersCollection.doc(currentUserId).collection(FirebaseCollectionReferences.blockedByDataSubCollectionName)

      //TODO: change this later when we start storing the users data in firebase
          .snapshots().map((snapshot) => UsersIBlockedStream(_usersListFromSnapshot(snapshot, context: context)));
    }
    catch(e) {
      return null;
    }
  }

  List<String> _blockedUserListFromSnapshot(DocumentSnapshot snapshot, context) {

    try {
      List<String> users = [];
      if(snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        return  List<String>.from(data['blockedBy'] ?? []);
        // users.addAll(list);
        // Provider.of<AppData>(context, listen: false).updateUsersWhoBlockedMe(users);
      }

      return users;
    }
    catch(e) {
      return [];
    }
  }


  Future<List<String>> getUserBlockedUsers(SkibbleUser currentUser) async {
    try {
      var query = await FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.blockedUsersSubCollection).get();

      List<String> blockedIdList = [];
      for(var doc in query.docs) {
        var data = doc.data();
        blockedIdList.addAll(List<String>.from(data['blockedUsers']));
      }
      return blockedIdList;
    }
    catch (e) {
      return [];
    }
  }

  Future<bool> saveUserPreferences(List<String> contentPreferences, String userId) async{

    try{
      var docRef = await FirebaseCollectionReferences.usersCollection.doc(userId);

      await docRef.set({'contentPreferences': contentPreferences}, SetOptions(merge: true));
      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<bool> saveUserAccessibilityPreferences(List<String> preferences, String userId) async{

    try{
      var docRef = await FirebaseCollectionReferences.usersCollection.doc(userId);

      await docRef.set({'accessibilityPreferences': preferences}, SetOptions(merge: true));
      return true;
    }
    catch(e) {
      return false;
    }
  }



  Future<List<String>> getUserMemberCommunities(SkibbleUser currentUser) async {
    try {
      var query = await FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.memberCommunitiesSubCollection).get();

      List<String> communitiesIdList = [];
      for(var doc in query.docs) {
        var data = doc.data();
        communitiesIdList.addAll(List<String>.from(data['member_communities']));
      }
      return communitiesIdList;
    }
    catch (e) {
      return [];
    }
  }



  Future<void> storeUserCloudMessagingTokens(String userId, String token) async{
    try {
      return await FirebaseCollectionReferences.usersCollection.doc(userId).set({
        'token': token,
        'tokens': FieldValue.arrayUnion([token])
      }, SetOptions(merge: true));
    }
    catch(e) {
    }
  }

  Future<bool> checkIfThereIsAnExistingUserName(String userName) async{

      try {
        QuerySnapshot query = await FirebaseCollectionReferences.usersCollection.where('userName', isEqualTo: userName).get();
        if(query.size > 0) {
          return true;
        }
        else {
          return false;
        }
      }
      catch(e) {
        return false;
      }
  }


  Future<bool> updateUserIsEmailVerified(String? userId) async {
    try {
      await FirebaseCollectionReferences.usersCollection.doc(userId).update({
        'isEmailVerified': true
      });

      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<bool> updateUserIsVerified(String userId) async {
    try {
      await FirebaseCollectionReferences.usersCollection.doc(userId).update({
        'isUserVerified': true
      });

      return true;
    }

    catch(e) {
      return false;
    }
  }

  Future updateUserEmail(String? userId, String newEmail) async {
    return await FirebaseCollectionReferences.usersCollection.doc(userId).update({
      'userEmailAddress': newEmail
    });
  }

  Future<bool> setUserData(SkibbleUser skibbleUser) async {
    try {
      await FirebaseCollectionReferences.usersCollection.doc(skibbleUser.userId).set(skibbleUser.toMap());

      return true;
    }
    catch(e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  /// This method fetches user suggestions but as feed to be shown on the feed page
  Future<List<FeedPost>> fetchUserFeedFriendSuggestionsBasedOnInterests(String userId, {String? lastDocId})  async{
    try {

      if(lastDocId != null) {
        var lastDoc = await FirebaseCollectionReferences.usersCollection.doc(userId)
            .collection(FirebaseCollectionReferences.friendInterestRecommendationsSubCollectionName).doc(lastDocId).get();

        var olderDocs = await FirebaseCollectionReferences.usersCollection.doc(userId)
            .collection(FirebaseCollectionReferences.friendInterestRecommendationsSubCollectionName)
            .startAfterDocument(lastDoc)
            .limit(10).get();

        var olderFeed = olderDocs.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return FeedPost(feedPostType: FeedPostType.friendRecommendationsInterest, user: SkibbleUser.fromMap(data['user']), feedPostId: data['user']['userId']);

        }).toList();


        return olderFeed;
      }

      else {
        var feed = await FirebaseCollectionReferences.usersCollection.doc(userId)
            .collection(FirebaseCollectionReferences.friendInterestRecommendationsSubCollectionName)
            .limit(10).get();

        var feedList =  feed.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return FeedPost(feedPostType: FeedPostType.friendRecommendationsInterest, user: SkibbleUser.fromMap(data['user']), feedPostId: data['user']['userId']);

        }).toList();

        // print('feedList: $feedList');
        return feedList;
      }
    }
    catch(e) {
      print('error: $e');
      return [];
    }
  }



  ///This method fetches friend suggestions but not as a feed
  Future<List<SkibbleUser>> fetchFriendSuggestionsBasedOnInterests(String userId, {String? lastDocId})  async{
    try {

      if(lastDocId != null) {
        var lastDoc = await FirebaseCollectionReferences.usersCollection.doc(userId)
            .collection(FirebaseCollectionReferences.friendInterestRecommendationsSubCollectionName).doc(lastDocId).get();

        var olderDocs = await FirebaseCollectionReferences.usersCollection.doc(userId)
            .collection(FirebaseCollectionReferences.friendInterestRecommendationsSubCollectionName)
            .startAfterDocument(lastDoc)
            .limit(20).get();

        var olderFeed = olderDocs.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return SkibbleUser.fromMap(data['user']);

        }).toList();


        return olderFeed;
      }

      else {
        var feed = await FirebaseCollectionReferences.usersCollection.doc(userId)
            .collection(FirebaseCollectionReferences.friendInterestRecommendationsSubCollectionName)
            .limit(20).get();

        var feedList =  feed.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return SkibbleUser.fromMap(data['user']);

        }).toList();

        return feedList;
      }
    }
    catch(e) {
      print('error: $e');
      return [];
    }
  }



  Future<UserImages?> updateUserData(SkibbleUser skibbleUser, {File? profileImageFile, List<SkibbleFile>? profileMedia, Uint8List? mapImageData}) async {
    UserImages userImages = UserImages(profileImageUrl: skibbleUser.profileImageUrl, mapImageUrl: skibbleUser.mapImageUrl, profileMedia: profileMedia);

    List<int> filesIndex = [];
    try {

      if(profileMedia != null) {
        //get the ones that hav files to upload
        List<SkibbleFile> newFiles = [];
        for(var i = 0; i < profileMedia.length; i++) {

          if(profileMedia[i].file != null) {
            newFiles.add(profileMedia[i]);
            filesIndex.add(i);
          }

        }
        List<SkibbleFile>? finalResult = [];

        if(newFiles.isEmpty) {
          userImages.profileMedia = profileMedia;

        }

        else {
          finalResult = await StorageService().uploadProfileMedia(newFiles, skibbleUser.userId!);

          if(finalResult != null) {
            for(var i = 0; i < filesIndex.length; i++) {

              //replace the file at profile media with the new file using the index saved
              profileMedia[filesIndex[i]] = finalResult[i];

            }
          }
          userImages.profileMedia = profileMedia;

        }
      }

      // if(profileImageFile != null) {
      //   String? downloadUrl = await StorageService().uploadProfileImage(profileImageFile, skibbleUser.userId!);
      //   userImages.profileImageUrl = downloadUrl ?? userImages.profileImageUrl;
      //   // if(downloadUrl != null) {
      //   //   skibbleUser.profileImageUrl = downloadUrl;
      //   //   await FirebaseCollectionReferences.usersCollection.doc(skibbleUser.userId).set(skibbleUser.updateToMap(skibbleUser), SetOptions(merge: true));
      //   //
      //   //   return downloadUrl;
      //   // }
      //   // else {
      //   //   return null;
      //   // }
      // }

      if(mapImageData != null) {
        String? downloadUrl = await StorageService().uploadMapImage(mapImageData, skibbleUser.userId!);
        userImages.mapImageUrl = downloadUrl ?? userImages.mapImageUrl;
        // if(downloadUrl != null) {
        //   skibbleUser.mapImageUrl = downloadUrl;
        //   await FirebaseCollectionReferences.usersCollection.doc(skibbleUser.userId).set(skibbleUser.updateToMap(skibbleUser), SetOptions(merge: true));
        //
        //   return downloadUrl;
        // }
        // else {
        //   return null;
        // }
      }

      skibbleUser.profileImageUrl = userImages.profileImageUrl;
      skibbleUser.profileMediaList = userImages.profileMedia;
      skibbleUser.mapImageUrl = userImages.mapImageUrl;

      await FirebaseCollectionReferences.usersCollection.doc(skibbleUser.userId).set(skibbleUser.updateToMap(skibbleUser), SetOptions(merge: true));
      return userImages;
    }
    catch(e) {
      debugPrint('Error: ' + e.toString());
      return null;
    }
  }

  Future<UserImages?> updateUserChefData(SkibbleUser skibbleUser, List<Map<String, dynamic>> workExperience, List<Map<String, dynamic>> certifications, {File? profileImageFile, File? coverImageFile, Uint8List? mapImageData}) async {
    UserImages userImages = UserImages(profileImageUrl: skibbleUser.profileImageUrl, mapImageUrl: skibbleUser.mapImageUrl, coverImageUrl: skibbleUser.chef!.coverImageUrl, profileMedia: []);

    try {
      //TODO:
      // Map<String, dynamic> imageUrls = {'profileImageUrl' : skibbleUser.profileImageUrl, 'coverImageUrl' : skibbleUser.chef!.coverImageUrl};

      if(profileImageFile != null) {
        String? downloadUrl = await StorageService().uploadProfileImage(profileImageFile, skibbleUser.userId!);
        userImages.mapImageUrl = downloadUrl ?? userImages.profileImageUrl;

      }

      if(coverImageFile != null) {
        String? downloadUrl = await StorageService().uploadCoverImage(coverImageFile, skibbleUser.userId!);
        userImages.mapImageUrl = downloadUrl ?? userImages.coverImageUrl;

      }

      if(mapImageData != null) {
        String? downloadUrl = await StorageService().uploadMapImage(mapImageData, skibbleUser.userId!);
        userImages.mapImageUrl = downloadUrl ?? userImages.mapImageUrl;
      }

      skibbleUser.profileImageUrl = userImages.profileImageUrl;
      skibbleUser.mapImageUrl = userImages.mapImageUrl;
      skibbleUser.chef!.coverImageUrl = userImages.coverImageUrl;
      await FirebaseCollectionReferences.usersCollection.doc(skibbleUser.userId).update(skibbleUser.updateUserChefToMap(skibbleUser, workExperience, certifications));

      return userImages;

    }
    catch(e) {
      debugPrint('Error: ' + e.toString());
      return null;
    }
  }


  Future updateUserActiveStatus(String userId, bool isActive, {int? timeLastActive}) async {
    try {
      return await FirebaseCollectionReferences.usersCollection.doc(userId).set({
        'isActive': isActive,
        'timeLastActive': timeLastActive != null ? timeLastActive : FieldValue.increment(0)
      }, SetOptions(merge: true));
    }
    catch(e) {
      debugPrint('Error' + e.toString());
      return null;
    }
  }

  Future updateUserCurrentLocation(String userId, Address address) async {
    try {

      // print('save');
      return await FirebaseCollectionReferences.usersCollection.doc(userId).set({
        'userCurrentLocation': address.toMap(),
        'updateUserIsLocationServiceEnabled': true,
        // 'updateUserIsLocationPermissionsEnabled': true
      }, SetOptions(merge: true));
    }
    catch(e) {
      debugPrint('Error' + e.toString());
      return null;
    }
  }

  Future updateUserNotificationPermission(String userId, ) async {
    try {
      return await FirebaseCollectionReferences.usersCollection.doc(userId).set({
        'isNotificationPermissionEnabled': true
      }, SetOptions(merge: true));
    }
    catch(e) {
      debugPrint('Error' + e.toString());
      return null;
    }
  }


  ///not used
  Future deleteFriend(String userId, String friendId) async{
    try {
      var batch = FirebaseFirestore.instance.batch();

      DocumentReference userReference = FirebaseCollectionReferences.usersCollection.doc(userId).collection(_FriendsCollectionName).doc(friendId);
      DocumentSnapshot friendSnapshot = await FirebaseCollectionReferences.usersCollection.doc(friendId).collection(_FriendsCollectionName).doc(userId).get();
      DocumentSnapshot chatSnapshot = await  FirebaseCollectionReferences.chatsCollection.doc(ChatsDatabaseService(userId: userId).getConversationID(userId, friendId)).get();

      //three operations occur once you delete a friend:
      //you delete their reference in your friends collection
      //you update their friends collection to show that you have been deleted
      //you remove your id from the conversations array=>users if you already have a conversation
      if(friendSnapshot.exists) {
        DocumentReference friendReference = FirebaseCollectionReferences.usersCollection.doc(friendId).collection(_FriendsCollectionName).doc(userId);

        batch.update(friendReference, {'friendStatus': 'deleted'});
      }
      if(chatSnapshot.exists) {
        DocumentReference chatReference = FirebaseCollectionReferences.chatsCollection.doc(ChatsDatabaseService(userId: userId).getConversationID(userId, friendId));
        batch.update(chatReference, {'users': FieldValue.arrayRemove([userId])});

      }

      batch.delete(userReference);

      return await batch.commit();
    }
    catch(e) {
      return null;
    }
  }

  // Future blockFriend(String userId, String friendId) async{
  //   try {
  //     int timeStamp = DateTime.now().millisecondsSinceEpoch;
  //     return await FirebaseCollectionReferences.usersCollection.doc(userId).collection(FirebaseCollectionReferences.blockedUsersSubCollection).doc(friendId).set({
  //       'userId': friendId,
  //       'timeStamp': timeStamp
  //     });
  //   }
  //   catch(e) {
  //     return null;
  //   }
  // }

  List<SkibbleUser> _usersListFromSnapshot(QuerySnapshot snapshot, {BuildContext? context}) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return SkibbleUser.fromMap(data);
    }).toList();
  }




  ///Used in the friends page to stream your new friends
  ///Future builder is then used to read and load each user's data
  Stream<List<SkibbleUser>>? getFriendsStream(String userId, context) {
    return  FirebaseCollectionReferences.usersCollection.doc(userId).collection('friends').snapshots()
        .map((snapshot) => _friendsListFromSnapshot(snapshot, context));

  }

  List<SkibbleUser> _friendsListFromSnapshot(QuerySnapshot snapshot, context) {
    List<SkibbleUser> friendsList = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


      return SkibbleUser.fromMap(data);
    }).toList();

    Provider.of<AppData>(context, listen: false).updateFriendsList(friendsList);
    return friendsList;
  }


  ///Get all the friends as well as their data as once
  ///Used in the Create group view
  Future<List<dynamic>?> getAllFriendsData(String userId, context) async{

    try{
      var friendsDataList = [];
      var friendsList = await FirebaseCollectionReferences.usersCollection.doc(userId).collection(_FriendsCollectionName).get();
      // return friendsDataList;

      for(var doc in friendsList.docs) {
        Map<String, dynamic> data = doc.data();

        var user = Provider.of<AppData>(context,listen: false).getUserFromMap(doc.id);

        if(user != null) {
          friendsDataList.add(user);
        }
        else {
          var friend = await getUserDoc(doc.id, context);
          // friend!.friendStatus = data['friendStatus'];
          // print(data['friendStatus']);
          friendsDataList.add(friend);
        }
      }

      return friendsDataList;
      // friendsList.docs.forEach((doc) async{
      //   var friend = await getFriendData(doc.id);
      //   friendsDataList.add(friend);
      // });


    }
    catch(e) {
      return null;
    }
  }


  SkibbleUser _userFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return SkibbleUser.fromMap(data);
  }

  ///Method to stream a user data and listen for changes in the data
  Stream<SkibbleUser> streamUser(String userId) {
    return FirebaseCollectionReferences.usersCollection.doc(userId).snapshots().map(_userFromSnapshot);
  }


  Future updateUserChatStatus(String userId, String status) async {
    try {
      return await FirebaseCollectionReferences.usersCollection.doc(userId).update({
        'chatStatus': status,
      });
    }
    catch(e) {
      debugPrint('Error' + e.toString());
      return null;
    }
  }



  Stream<List<SkibbleUser>> getUsersByList(List<String> userIds) {
    final List<Stream<SkibbleUser>> streams = [];
    for (String id in userIds) {
      streams.add(
          FirebaseCollectionReferences.usersCollection
              .doc(id)
              .snapshots()
              .map((DocumentSnapshot documentSnapshot) => SkibbleUser.fromMap(documentSnapshot.data as Map<String, dynamic>)));
    }
    return StreamZip<SkibbleUser>(streams).asBroadcastStream();
  }


  Stream<List<SkibbleUser>> streamUsersByPattern(String pattern) {
    return FirebaseCollectionReferences.usersCollection
        .where('fieldName', isGreaterThanOrEqualTo: pattern)
        .where('fieldName', isLessThan: pattern +'z')
        .snapshots().map((_usersListFromSnapshot));
  }



}