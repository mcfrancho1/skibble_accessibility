
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../../models/skibble_user.dart';
import '../../../../services/change_data_notifiers/feed_data.dart';
import '../../../../services/firebase/auth_services/skibble_auth_service.dart';
import '../../../../services/firebase/database/user_database.dart';
import '../../../../services/internal_storage.dart';
import '../../../../services/preferences/preferences.dart';

class UserSetupController {

  final SkibbleAuthService authService;

  UserSetupController(this.authService);
  InternalStorageService storageService = InternalStorageService.getInstance();



  Future<SkibbleUser?> getCurrentUserDataUsingContext({bool hasUri = false}) async{
    try {
      User? currentUser =  FirebaseAuth.instance.currentUser;
      SkibbleUser user = SkibbleUser(userId: currentUser!.uid);
      user.isEmailVerified = currentUser.emailVerified;
      await Preferences.getInstance().setCurrentUserIdKey(currentUser.uid);
      var token = Preferences.getInstance().getCurrentNotificationToken();
      // print('Hehe: $token');
      if(token != null) {
        await UserDatabaseService().storeUserCloudMessagingTokens(user.userId!, token);
      }
      var result = await UserDatabaseService().getCurrentUserDoc(user.userId!);
      user = result!;

      if(currentUser.emailVerified && !user.isEmailVerified!) {
        user.isEmailVerified = currentUser.emailVerified;
        await UserDatabaseService().updateUserIsEmailVerified(user.userId);
      }

      //get this current user stories
      // user.userMomentList =
      // await FeedDatabaseService().getMomentsFromIDList(user.recentMoments!);

      var data = {};

      user.memberCommunities = data['communities'];
      //await UserDatabaseService().getUserMemberCommunities(user);


      //get all the people the user is following
      var followings = data['followings'];

      //await FriendRequestsDatabaseService().getAllUserFollowing(result.userId!);
      var blockedUsers = data['blockedUsers'];
      // await UserDatabaseService().getUserBlockedUsers(user);
      // user.blockedUsers = blockedUsers;

      // await InternalStorageService.getInstance().getFeed(context);
      // FeedDatabaseService().getUserFeed(followings!, context, user);


      ///This two are not assigned but their internal code is calling provider
      //await UserDatabaseService().getCurrentUserAllLikedRecipes(user.userId!, context);
      // await UserDatabaseService().getCurrentUserAllLikedSkibs(user.userId!, context);

      // await FeedDatabaseService().getUserFeedMoments(followings, context);

      // user.userFeed = feed;
      //
      // context.read<AppData>().updateUser(user);

      return user;
    }
    catch(e) {
      print(e);
      return null;
    }

  }


  Future<Map<String, List<String>?>> getCurrentUserRequiredData(SkibbleUser currentUser, context) async {
    try {

      Map<String, List<String>> mapData = {};



      //likedSkibs
      if((await storageService.getLikedSkibs())!.isEmpty) {
        var likedSkibsAsMap = await UserDatabaseService().getCurrentUserAllLikedSkibs(currentUser.userId!, context);
        await storageService.setLikedSkibsMap(likedSkibsAsMap['likesMap']);
        await storageService.setLikedSkibs(likedSkibsAsMap['likesList']);


        mapData['likedSkibs'] = likedSkibsAsMap['likesList'];

        Provider.of<FeedData>(context, listen:  false).updateLikedSkibsMap(likedSkibsAsMap['likesMap']);
        Provider.of<FeedData>(context, listen:  false).updateLikedSkibsList(likedSkibsAsMap['likesList']);


      }
      else {

        var likedSkibs = (await storageService.getLikedSkibs())!;
        var likedSkibsMap = (await storageService.getLikedSkibsMap());


        //print(likedSkibs);
        mapData['likedSkibs'] = likedSkibs;
        Provider.of<FeedData>(context, listen:  false).updateLikedSkibsMap(likedSkibsMap);
        Provider.of<FeedData>(context, listen:  false).updateLikedSkibsList(likedSkibs);
      }



      // var feed = await storageService.getFeed();
      // Provider.of<FeedData>(context, listen: false).updateUserFeed(feed);
      return mapData;
    }
    catch(e) {
      return {};
    }
  }

}