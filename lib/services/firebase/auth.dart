import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/services/firebase/database/feed_database.dart';
import 'package:skibble/services/firebase/database/friend_requests_database.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/services/firebase/skibble_functions_handler.dart';
import 'package:skibble/services/internal_storage.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/features/authentication/controllers/auth_controller.dart';
import 'package:skibble/utils/helper_methods.dart';

import '../../navigator_provider.dart';
import '../../shared/dialogs.dart';
import '../change_data_notifiers/app_data.dart';
import '../change_data_notifiers/feed_data.dart';
import '../preferences/preferences.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Stream<SkibbleUser?> authStateChanges;

  FirebaseAuth getAuthInstance() {
    return _auth;
  }


  Stream<User?> userAuthChanges () {
    return _auth.userChanges();

  }

  Future<String?> refreshAuthToken() async{
   try {
     return await _auth.currentUser?.getIdToken(true);
   }
   catch(e) {return null;}
  }



  User? getCurrentUser() {
    User? currentUser =  _auth.currentUser;
    return currentUser;
  }

  // create user obj based on Firebase user
  User? _userFromFirebaseUser (User? firebaseUser) {

    if(firebaseUser != null ) {
      return firebaseUser;
    }
    else {
      return null;
    }
  }

  Future<SkibbleUser?> getCurrentUserDataUsingContext(BuildContext context, {bool hasUri = false}) async{
    try {
      User? currentUser =  _auth.currentUser;
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
        if(user.mapImageUrl == null) {
          var mapImageData = await HelperMethods().captureWidget(user, context);

          var images = await UserDatabaseService().updateUserData(user, mapImageData: mapImageData);
          user.mapImageUrl = images?.mapImageUrl;
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
      // user.followingsList = followings;
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

  ///Returns a list of all the users the current user is following
  Future<Map<String, List<String>?>> getCurrentUserRequiredData(SkibbleUser currentUser, context) async {
   try {
     InternalStorageService storageService = InternalStorageService.getInstance();
     Map<String, List<String>> mapData = {};

     //followings
     if((await storageService.getFollowings())!.isEmpty) {
       var followings = await FriendRequestsDatabaseService().getAllUserFollowing(currentUser, context);
       await storageService.setFollowings(followings ?? []);

       mapData['followings'] = followings!;
     }
     else {

       mapData['followings'] = (await storageService.getFollowings())!;

     }


     //communities
     if((await storageService.getCommunities())!.isEmpty) {
       var communities = await UserDatabaseService().getUserMemberCommunities(currentUser);
       await storageService.setCommunities(communities);

       mapData['communities'] = communities;
     }
     else {
       mapData['communities'] = (await storageService.getCommunities())!;
     }

     //blocked users
     if((await storageService.getBlockedUsers())!.isEmpty) {
       var blockedUsers = await UserDatabaseService().getUserBlockedUsers(currentUser);
       await storageService.setBlockedUsers(blockedUsers);

       mapData['blockedUsers'] = blockedUsers;

     }
     else {
       mapData['blockedUsers'] = (await storageService.getBlockedUsers())!;
     }


     //likedRecipes
     if((await storageService.getLikedRecipes())!.isEmpty) {
       var likedRecipesAsMap = await UserDatabaseService().getCurrentUserAllLikedRecipes(currentUser.userId!, context);
       await storageService.setLikedRecipesMap(likedRecipesAsMap['likesMap']);
       await storageService.setLikedRecipes(likedRecipesAsMap['likesList']);

       mapData['likedRecipes'] = likedRecipesAsMap['likesList'];

       Provider.of<FeedData>(context, listen:  false).updateLikedRecipesMap(likedRecipesAsMap['likesMap']);
       Provider.of<FeedData>(context, listen:  false).updateLikedRecipesList(likedRecipesAsMap['likesList']);
     }
     else {

       var likedRecipes = (await storageService.getLikedRecipes())!;
       var likedRecipesMap = Map<String, List<String>>.from(await storageService.getLikedRecipesMap());

       mapData['likedRecipes'] = likedRecipes;
       Provider.of<FeedData>(context, listen:  false).updateLikedRecipesMap(likedRecipesMap);
       Provider.of<FeedData>(context, listen:  false).updateLikedRecipesList(likedRecipes);
     }

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

  Future<bool> sendEmailVerification() async {
    try {
      var result = await SkibbleFirebaseFunctions().callFunction('generateVerifyEmail');

      if(result['error'] == null) {
        return true;
      }
      else  {
        return false;
      }
      // await _auth.currentUser!.sendEmailVerification();
    }
    catch(e) {
      return false;
    }
  }


  Future registerUserWithEmailAndPassword(SkibbleUser skibbleUser) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(email: skibbleUser.userEmailAddress!, password: skibbleUser.userPassword!);
      User? firebaseUser = result.user;

      // SkibbleUser newUser = SkibbleUser(fullName: skibbleUser.fullName, userName: skibbleUser.userName, userEmailAddress: skibbleUser.userEmailAddress, userId: firebaseUser!.uid);

      skibbleUser.userId = firebaseUser!.uid;
      skibbleUser.userName = skibbleUser.userName?.trim().toLowerCase();

      await UserDatabaseService().setUserData(skibbleUser);

      return  _userFromFirebaseUser(firebaseUser);
    }on FirebaseAuthException catch (e){

      if(e.code == 'email-already-in-use') {
        return 'Email-Already-In-Use';
      }
      else {
        return null;
      }
    }
     catch(e) {
       print(e);

       return null;
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async{
    try {

      /// The scopes required by this application.
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      final GoogleSignIn googleSignIn =  GoogleSignIn(
          // clientId: '477071581496-f3ca6ltan685qpu6520hagjr06riqasb.apps.googleusercontent.com'
        // scopes: scopes,

      );


      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();


      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount!.authentication;




      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // AppNavigator.instance.resetKey();

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      // print('loly');

      // final User? user = authResult.user;


      if(authResult.additionalUserInfo!.isNewUser) {
          //You can set data for user in Fire store

          int timestamp = DateTime.now().millisecondsSinceEpoch;

          SkibbleUser newSkibbleUser = SkibbleUser(

              fullName: authResult.user != null ? authResult.user!.displayName ?? '' : '',
              userName: null,
              userEmailAddress: authResult.user != null ? authResult.user!.email : '',
              isActive: true,
              userId: authResult.user != null ? authResult.user!.uid : '',
              timeLastActive: timestamp,
              accountCreatedAt: timestamp,
              isEmailVerified: true,
              lastLoginTimeStamp: timestamp,
              userCustomColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
          );
          CustomBottomSheetDialog.showProgressSheet(context,);

          //this is called just in case the user does not complete the sign up and exits
          var result = await UserDatabaseService().setUserData(newSkibbleUser);

          if(result) {
             // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (context) =>
            //         SetFullNameUserNameView(
            //           // credential: authResult,
            //           currentUser: newSkibbleUser,
            //         )));
          }

          else {
            Navigator.pop(context);
            CustomDialog(context).showErrorDialog('Oops!', 'Something went wrong.\n\nTry again later or contact us at hello@skibble.app.');
          }
      }
      else {

        await UserDatabaseService().updateUserActiveStatus(authResult.user!.uid, true);

        await Preferences.getInstance().setCurrentUserIdKey(authResult.user!.uid);

        // await Phoenix.rebirth(context);
      }

      return authResult;

    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }


  ///Apple sign in
  // @override
  Future<UserCredential?> signInWithApple(BuildContext context) async {
     try {
        final appleProvider = AppleAuthProvider()..addScope('email')..addScope('name');

        final UserCredential authResult = await _auth.signInWithProvider(appleProvider);


        if(authResult.additionalUserInfo!.isNewUser) {
          //You can set data for user in Fire store

          int timestamp = DateTime.now().millisecondsSinceEpoch;

          SkibbleUser newSkibbleUser = SkibbleUser(

              fullName: authResult.user != null ? authResult.user!.displayName ?? '' : '',
              userName: null,
              userEmailAddress: authResult.user != null ? authResult.user!.email : '',
              isActive: true,
              userId: authResult.user != null ? authResult.user!.uid : '',
              timeLastActive: timestamp,
              accountCreatedAt: timestamp,
              isEmailVerified: true,
              lastLoginTimeStamp: timestamp,
              userCustomColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
          );
          CustomBottomSheetDialog.showProgressSheet(context,);

          //this is called just in case the user does not complete the sign up and exits
          var result = await UserDatabaseService().setUserData(newSkibbleUser);

          if(result) {
            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (context) =>
            //         SetFullNameUserNameView(
            //           // credential: authResult,
            //           currentUser: newSkibbleUser,
            //         )));

          }

          else {
            Navigator.pop(context);
            CustomDialog(context).showErrorDialog('Oops!', 'Something went wrong.\n\nTry again later or contact us at hello@skibble.app.');
          }
        }
        else {

          await UserDatabaseService().updateUserActiveStatus(authResult.user!.uid, true);

          await Preferences.getInstance().setCurrentUserIdKey(authResult.user!.uid);

          // await Phoenix.rebirth(context);
        }

        return authResult;

      }

      catch(e) {
        print('Error: $e');
        return null;
     }
  }

  Future signInWithEmailAndPassword(String email, String password,) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      await UserDatabaseService().updateUserActiveStatus(user!.uid, true);

      return user;
    }
    catch(e) {
      FirebaseAuthException err = e as FirebaseAuthException;

      print(e);
      if(e.code == 'user-not-found') {
        return 'Not-Found';
        //return 'No user found for that email.';
      }
      else if(e.code == 'wrong-password') {
        return 'Wrong-Password';
      }

      else {
        return null;
      }
      //return 'Wrong password provided for that user.';

    }
  }
  
  Future<String?> updateUserEmail(String newEmail) async{
    try {

      var result = await _auth.currentUser?.updateEmail(newEmail);

      await UserDatabaseService().updateUserEmail(_auth.currentUser?.uid, newEmail);
      return 'success';
    }
    catch(e) {
      FirebaseAuthException err = e as FirebaseAuthException;

      if(e.code == 'email-already-in-use') {
        return 'This email is already being used by another skibbler.';
      }
      else if(e.code == 'invalid-email') {
        return 'Your email is invalid.';
      }

      else if(e.code == 'requires-recent-login') {
        return e.code;
      }
      else {
        return null;
      }
    }
  }

  Future<String?> sendPasswordResetEmail(String newEmail) async{
    try {
      var result = await SkibbleFirebaseFunctions().callFunction('generatePasswordResetEmail', data: {'email': newEmail});
      // var result = await _auth.sendPasswordResetEmail(email: newEmail);

      print(result);
      if(result['error'] == null) {
        return 'success';
      }

      else {

        if(result['error']['errorInfo']['code'] == 'auth/email-not-found') {
          return 'This user was not found in our database.';
        }
        else if(result['error']['errorInfo']['code'] == 'auth/invalid-email') {
          return 'This email is invalid';
        }
        else if(result['error']['errorInfo']['code'] == 'auth/requires-recent-login') {
          return 'Your account requires a recent login.';
        }
        else {
          return null;
        }
      }
    }
    catch(e) {
      print(e);
        return null;
    }
  }

  Future signOut() async {
    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      if(_auth.currentUser != null) {
        await UserDatabaseService().updateUserActiveStatus(
            _auth.currentUser!.uid, false, timeLastActive: timestamp);
      }
      return await _auth.signOut();
    }
    catch(e) {
      return null;
    }
  }
}