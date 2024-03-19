// import 'package:apple_sign_in/apple_sign_in.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../../models/skibble_user.dart';
import '../../../../services/change_data_notifiers/feed_data.dart';
import '../../../../services/firebase/database/user_database.dart';
import '../../../../services/internal_storage.dart';
import '../../../../services/preferences/preferences.dart';
import '../../../navigator_provider.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/firebase/auth_services/skibble_auth_service.dart';
import 'auth_provider.dart';

class CustomAuthService implements SkibbleAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final InternalStorageService storageService = InternalStorageService.getInstance();

  final StreamController<SkibbleUser?> streamController = StreamController.broadcast();

  ///stream listener for the user that also updates provider
  @override
  Stream<SkibbleUser?>  onAuthStateChanged(BuildContext context) {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      return await fetUserDataFromCurrentUser(user).then((skibbleUser) async{
        //
        AppNavigator.instance.resetKey(skibbleUser);

        // AppNavigator.instance.setContext(context);

        Provider.of<AppData>(context, listen: false).updateUser(skibbleUser, shouldNotifyListeners: false);

        streamController.sink.add(skibbleUser);
        return skibbleUser;
      });
    });
  }


  // @override
  // Stream<SkibbleUser?>  listenToAuthChanges(BuildContext context) {
    // return _firebaseAuth.authStateChanges().asyncMap((user) async {
    //   return await fetUserDataFromCurrentUser(user).then((skibbleUser) async{
    //     //
    //     AppNavigator.instance.resetKey(skibbleUser);
    //
    //     // AppNavigator.instance.setContext(context);
    //
    //     Provider.of<AppData>(context, listen: false).updateUser(skibbleUser, shouldNotifyListeners: true);
    //
    //     streamController.sink.add(skibbleUser);
    //     return skibbleUser;
    //   });
    // });
  // }


  Future<SkibbleUser?> fetUserDataFromCurrentUser(User? user) async {
    if(user == null) {
      return null;
    }
    else {
      return await getCurrentUserData(user);
    }
  }


  Future<SkibbleUser?> getCurrentUserData(User user,) async{
    try {
      Preferences.getInstance().setCurrentUserIdKey(user.uid);
      // var token = Preferences.getInstance().getCurrentNotificationToken();
      // if(token != null) {
      //   print('hi');
      //   await UserDatabaseService().storeUserCloudMessagingTokens(user.uid, token);
      // }
      var userData = await UserDatabaseService().getCurrentUserDoc(user.uid);


      if(userData != null) {
        // print('pop');
        await StreamChatService().initStreamChat( userData);
        userData.isEmailVerified = user.emailVerified;


        // if(user.emailVerified && !userData.isEmailVerified!) {
        //   await UserDatabaseService().updateUserIsEmailVerified(user.uid);
        // }

      }


      //get this current user stories
      // user.userMomentList =
      // await FeedDatabaseService().getMomentsFromIDList(user.recentMoments!);

      var data = {};

      userData!.memberCommunities = data['communities'];
      //await UserDatabaseService().getUserMemberCommunities(user);


      //get all the people the user is following
      var followings = data['followings'];

      //await FriendRequestsDatabaseService().getAllUserFollowing(result.userId!);
      var blockedUsers = data['blockedUsers'];
      // await UserDatabaseService().getUserBlockedUsers(user);

      return userData;
    }
    catch(e) {
      debugPrint(e.toString());
      return null;
    }

  }

  // Future<Map<String, List<String>?>> getCurrentUserRequiredData(SkibbleUser currentUser) async {
  //   try {
  //
  //     Map<String, List<String>> mapData = {};
  //
  //     //followings
  //     if((await storageService.getFollowings())!.isEmpty) {
  //       var followings = await FriendRequestsDatabaseService().getAllUserFollowing(currentUser, context);
  //       await storageService.setFollowings(followings ?? []);
  //
  //       mapData['followings'] = followings!;
  //     }
  //     else {
  //
  //       mapData['followings'] = (await storageService.getFollowings())!;
  //
  //     }
  //
  //
  //     //communities
  //     if((await storageService.getCommunities())!.isEmpty) {
  //       var communities = await UserDatabaseService().getUserMemberCommunities(currentUser);
  //       await storageService.setCommunities(communities);
  //
  //       mapData['communities'] = communities;
  //     }
  //     else {
  //       mapData['communities'] = (await storageService.getCommunities())!;
  //     }
  //
  //     //blocked users
  //     if((await storageService.getBlockedUsers())!.isEmpty) {
  //       var blockedUsers = await UserDatabaseService().getUserBlockedUsers(currentUser);
  //       await storageService.setBlockedUsers(blockedUsers);
  //
  //       mapData['blockedUsers'] = blockedUsers;
  //
  //     }
  //     else {
  //       mapData['blockedUsers'] = (await storageService.getBlockedUsers())!;
  //     }
  //
  //
  //     //likedRecipes
  //     if((await storageService.getLikedRecipes())!.isEmpty) {
  //       var likedRecipesAsMap = await UserDatabaseService().getCurrentUserAllLikedRecipes(currentUser.userId!, context);
  //       await storageService.setLikedRecipesMap(likedRecipesAsMap['likesMap']);
  //       await storageService.setLikedRecipes(likedRecipesAsMap['likesList']);
  //
  //       mapData['likedRecipes'] = likedRecipesAsMap['likesList'];
  //
  //       Provider.of<FeedData>(context, listen:  false).updateLikedRecipesMap(likedRecipesAsMap['likesMap']);
  //       // Provider.of<FeedData>(context, listen:  false).updateLikedRecipesList(likedRecipesAsMap['likesList']);
  //     }
  //     else {
  //
  //       var likedRecipes = (await storageService.getLikedRecipes())!;
  //       var likedRecipesMap = Map<String, List<String>>.from(await storageService.getLikedRecipesMap());
  //
  //       mapData['likedRecipes'] = likedRecipes;
  //       // Provider.of<FeedData>(context, listen:  false).updateLikedRecipesMap(likedRecipesMap);
  //       // Provider.of<FeedData>(context, listen:  false).updateLikedRecipesList(likedRecipes);
  //     }
  //
  //     //likedSkibs
  //     if((await storageService.getLikedSkibs())!.isEmpty) {
  //       var likedSkibsAsMap = await UserDatabaseService().getCurrentUserAllLikedSkibs(currentUser.userId!, context);
  //       await storageService.setLikedSkibsMap(likedSkibsAsMap['likesMap']);
  //       await storageService.setLikedSkibs(likedSkibsAsMap['likesList']);
  //
  //
  //       mapData['likedSkibs'] = likedSkibsAsMap['likesList'];
  //
  //       // Provider.of<FeedData>(context, listen:  false).updateLikedSkibsMap(likedSkibsAsMap['likesMap']);
  //       // Provider.of<FeedData>(context, listen:  false).updateLikedSkibsList(likedSkibsAsMap['likesList']);
  //
  //
  //     }
  //     else {
  //
  //       var likedSkibs = (await storageService.getLikedSkibs())!;
  //       var likedSkibsMap = (await storageService.getLikedSkibsMap());
  //
  //
  //       //print(likedSkibs);
  //       mapData['likedSkibs'] = likedSkibs;
  //
  //       // Provider.of<FeedData>(context, listen:  false).updateLikedSkibsMap(likedSkibsMap);
  //       // Provider.of<FeedData>(context, listen:  false).updateLikedSkibsList(likedSkibs);
  //     }
  //
  //
  //
  //     // var feed = await storageService.getFeed();
  //     // Provider.of<FeedData>(context, listen: false).updateUserFeed(feed);
  //     return mapData;
  //   }
  //   catch(e) {
  //     return {};
  //   }
  // }



  @override
  Future<SkibbleUser?> signInAnonymously() async {
    final UserCredential userCredential =
    await _firebaseAuth.signInAnonymously();
    return SkibbleUser.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<SkibbleUser?> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential =
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return SkibbleUser.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<SkibbleUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return SkibbleUser.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<SkibbleUser?> signInWithEmailAndLink(String email, String link) async {
    final UserCredential userCredential = await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
    return SkibbleUser.fromFirebaseUser(userCredential.user!);
  }

  @override
  bool isSignInWithEmailLink(String link) {
    return _firebaseAuth.isSignInWithEmailLink(link);
  }

  @override
  Future<void> sendSignInWithEmailLink({
    required String email,
    required String url,
    required bool handleCodeInApp,
    required String iOSBundleId,
    required String androidPackageName,
    required bool androidInstallApp,
    required String androidMinimumVersion,
  }) async {
    return await _firebaseAuth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: url,
        handleCodeInApp: handleCodeInApp,
        iOSBundleId: iOSBundleId,
        androidPackageName: androidPackageName,
        androidInstallApp: androidInstallApp,
        androidMinimumVersion: androidMinimumVersion,
      ),
    );
  }

  @override
  Future<SkibbleUser?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));

        return SkibbleUser.fromFirebaseUser(userCredential.user!);
      }
      else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }


  ///Facebook SignIn
  // @override
  // Future<SkibbleUser> signInWithFacebook() async {
  //   final fb = FacebookLogin();
  //   final response = await fb.logIn(permissions: [
  //     FacebookPermission.publicProfile,
  //     FacebookPermission.email,
  //   ]);
  //   switch (response.status) {
  //     case FacebookLoginStatus.success:
  //       final accessToken = response.accessToken;
  //       final userCredential = await _firebaseAuth.signInWithCredential(
  //         FacebookAuthProvider.credential(accessToken.token),
  //       );
  //       return _userFromFirebase(userCredential.user);
  //     case FacebookLoginStatus.cancel:
  //       throw FirebaseAuthException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Login cancelado pelo usuário.',
  //       );
  //     case FacebookLoginStatus.error:
  //       throw FirebaseAuthException(
  //         code: 'ERROR_FACEBOOK_LOGIN_FAILED',
  //         message: response.error.developerMessage,
  //       );
  //     default:
  //       throw UnimplementedError();
  //   }
  // }



  ///Apple sign in
  // @override
  // Future<SkibbleUser?> signInWithApple({List<Scope> scopes = const []}) async {
    // final AuthorizationResult result = await AppleSignIn.performRequests(
    //     [AppleIdRequest(requestedScopes: scopes)]);
    // switch (result.status) {
    //   case AuthorizationStatus.authorized:
    //     final appleIdCredential = result.credential;
    //     final oAuthProvider = OAuthProvider('apple.com');
    //     final credential = oAuthProvider.credential(
    //       idToken: String.fromCharCodes(appleIdCredential.identityToken),
    //       accessToken:
    //       String.fromCharCodes(appleIdCredential.authorizationCode),
    //     );
    //
    //     final authResult = await _firebaseAuth.signInWithCredential(credential);
    //     final firebaseUser = authResult.user;
    //     if (scopes.contains(Scope.fullName)) {
    //       final String displayName =
    //           '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
    //       await firebaseUser.updateProfile(displayName: displayName);
    //     }
    //     return _userFromFirebase(firebaseUser);
    //   case AuthorizationStatus.error:
    //     throw PlatformException(
    //       code: 'ERROR_AUTHORIZATION_DENIED',
    //       message: result.error.toString(),
    //     );
    //   case AuthorizationStatus.cancelled:
    //     throw PlatformException(
    //       code: 'ERROR_ABORTED_BY_USER',
    //       message: 'Sign in aborted by user',
    //     );
    // }
  //   return null;
  // }

  @override
  Future<SkibbleUser?> currentUser() async {

    // if(_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser != null ? await fetUserDataFromCurrentUser(_firebaseAuth.currentUser) : null;
    // }
    // return SkibbleUser.fromFirebaseUser(_firebaseAuth.currentUser!);
  }

  @override
  Future<void> signOut() async {
    //TODO: Uncomment this later
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    // final FacebookLogin facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();

    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {streamController.close();}

  @override
  Future<SkibbleUser> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<void> reload(BuildContext context) async{
    // TODO: implement reload
    // streamController.addStream(_firebaseAuth.authStateChanges().asyncMap((user) => fetUserDataFromCurrentUser(user)));
    if(_firebaseAuth.currentUser != null) {
      _firebaseAuth.currentUser!.reload();

      if(_firebaseAuth.currentUser!.emailVerified) {
        await fetUserDataFromCurrentUser(_firebaseAuth.currentUser!).then((value) async{
          Provider.of<AppData>(context, listen: false).updateUser(value);
          streamController.sink.add(value);
          return value;
        });
        // streamController.sink.add(await fetUserDataFromCurrentUser(_firebaseAuth.currentUser!));
      }

    }

    return Future.value();
  }

  @override
  Future<void> triggerUserChange(BuildContext context) async{
    // TODO: implement triggerUserChange
    await fetUserDataFromCurrentUser(_firebaseAuth.currentUser!).then((value) {
      Provider.of<AppData>(context, listen: false).updateUser(value);
      streamController.sink.add(value);
      return value;
    });

    return Future.value();
  }
}