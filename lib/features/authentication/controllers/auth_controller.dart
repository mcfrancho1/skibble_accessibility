import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/features/authentication/views/chef_auth/components/set_fullname_username_view.dart';
import 'package:skibble/features/authentication/views/shared_screens/user_food_preferences.dart';

import 'package:flutter/material.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/features/authentication/views/kitchen_auth/kitchen/kitchen_register_page.dart';
import 'package:skibble/features/authentication/views/shared_screens/location_permission_view.dart';
import 'package:skibble/features/authentication/views/shared_screens/verify_user_email.dart';
import 'package:skibble/features/authentication/views/shared_screens/welcome_page.dart';
import 'package:skibble/features/notifications/views/notifications_permissions_view.dart';
import 'package:skibble/features/recommendations/controllers/friend_recommendation_controller.dart';

import '../../../../controllers/feed_controller.dart';
import '../../../../localization/app_translation.dart';
import '../../../../main_page_parent.dart';
import '../../../../models/address.dart';
import '../../../../navigator_provider.dart';
import '../../../../features/notifications/services/notifications_service.dart';
import '../../../../controllers/loading_controller.dart';
import '../../../../services/change_data_notifiers/feed_data.dart';
import '../../../../services/firebase/auth.dart';
import '../../../../services/firebase/database/user_database.dart';
import '../../../../services/firebase/skibble_functions_handler.dart';
import '../../../../services/internal_storage.dart';
import '../../../../services/preferences/preferences.dart';
import '../../../../shared/dialogs.dart';
import '../../../services/stream_chat_service.dart';
import '../../../utils/constants.dart';
import '../views/auth_widget.dart';
import '../views/chef_auth/chef/chef_register_page.dart';
import 'auth_provider.dart';
import 'email_secure_storage.dart';

class AuthController {

  List<Widget> authFlow = [];


  createUserAccountWithEmailAndPassword(SkibbleUser newSwiftMenuUser, BuildContext context,
      {FormState? formState}) async{
      // CustomDialog(context).showProgressDialog('Creating your New Account');
      context.read<LoadingController>().isLoading = true;

      //checking if the username exists
      // bool result = false;

      bool result = await UserDatabaseService().checkIfThereIsAnExistingUserName( context.read<SkibbleAuthProvider>().userName!);

      if(result) {
        // Navigator.pop(context);
        context.read<LoadingController>().isLoading = false;

        context.read<SkibbleAuthProvider>().userNameErrorText = 'Username has already been taken. Try another name.';
        // CustomDialog(context).showErrorDialog('Username Exists', 'This username has already been taken.');
      }
      else {
        var emailSecureStore = Provider.of<EmailSecureStore>(context, listen: false);
        await emailSecureStore.setEmail(context.read<SkibbleAuthProvider>().email!);
        dynamic result = await AuthService().registerUserWithEmailAndPassword(newSwiftMenuUser);

        if(result == 'Email-Already-In-Use') {
          // Navigator.of(context).pop();
          context.read<LoadingController>().isLoading = false;

          CustomDialog(context).showErrorDialog('Error Creating Account', 'The email you provided has already been used to create an account.');

        }

        else if(result == null) {
          // Navigator.of(context).pop();
          context.read<LoadingController>().isLoading = false;

          CustomDialog(context).showErrorDialog('Unable to Create Account', 'Unable to create an account at the moment. Try again later.');
        }

        else {
          // Navigator.of(context).pop();
          // context.read<LoadingController>().isLoading = false;

          var preferences = await Preferences.getInstance();
          await preferences.setFirstTimeEmailVerifiedKey(false);
          await preferences.setCurrentUserIdKey(result.uid);


          try{
            //start auth flow
            context.read<SkibbleAuthProvider>().resetAuthFlow();
          }catch(e) {}

        }
      }


  }




  // navigateDuringSignUp(BuildContext context) {
  //   var user = Provider.of<AppData>(context, listen: false).skibbleUser!;
  //
  //   if(Navigator.canPop(context))
  //     Navigator.pop(context);
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthWidget( userSnapshot: null,)));
  // }


  Future<bool> saveUserContentPreferences(List<String> contentPreferences, String userId, BuildContext context) async{

    try{
      context.read<LoadingController>().isLoading = true;

      // var result = await Future.delayed(Duration(seconds: 3), () => true);
      var result = await UserDatabaseService().saveUserPreferences(contentPreferences, userId);
      Provider.of<AppData>(context, listen: false).skibbleUser!.contentPreferences = contentPreferences;

      context.read<LoadingController>().isLoading = false;

      return result;
    }
    catch(e) {
      print(e);
      return false;
    }
  }



  Future<bool> saveUserAccessibilityPreferences(List<String> preferences, String userId, BuildContext context) async{

    try{
      context.read<LoadingController>().isLoading = true;

      // var result = await Future.delayed(Duration(seconds: 3), () => true);
      var result = await UserDatabaseService().saveUserAccessibilityPreferences(preferences, userId);
      Provider.of<AppData>(context, listen: false).skibbleUser!.accessibilityPreferences = preferences;

      context.read<LoadingController>().isLoading = false;

      return result;
    }
    catch(e) {
      print(e);
      return false;
    }
  }

  Future<String?> updateUserEmailAddress(String emailAddress, BuildContext context) async{

    try{
      // CustomDialog(context).showProgressDialog(context, 'Processing');
      CustomBottomSheetDialog.showProgressSheet(context,);

      var authService = AuthService();
      var result = await authService.updateUserEmail(emailAddress);

      if(result == 'success') {
        Provider.of<AppData>(context, listen: false).skibbleUser!.userEmailAddress = emailAddress;
        var boolValue = await authService.sendEmailVerification();

        if(boolValue) {
          Navigator.pop(context);

          Navigator.of(context).pop(emailAddress);
        }

        else {
          Navigator.pop(context);

          CustomDialog(context).showErrorDialog('Error', 'Unable to send you a verification link');
        }
      }

      else if(result == 'requires-recent-login') {
        Navigator.pop(context);
        CustomBottomSheetDialog.showLoginAgainMessageDuringSignUpSheet(context,
            'You need to restart the sign up process to change your email address',
            onButtonPressed: () async {

          await deleteUser(context);
        });
      }

      else if(result != null) {
        Navigator.pop(context);

        CustomDialog(context).showErrorDialog('Error', result);
      }

      else {
        Navigator.pop(context);
        CustomDialog(context).showErrorDialog('Error', 'Unable to update your email address. Try again later.');

      }


      return result;
    }
    catch(e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateUserIsLocationEnabled(Address address, String userId, BuildContext context) async{

    try{

      var result = await UserDatabaseService().updateUserCurrentLocation(userId, address);
      // Provider.of<AppData>(context, listen: false).skibbleUser.isLocationPermissionEnabled = true;
      Provider.of<AppData>(context, listen: false).skibbleUser!.isLocationServicesEnabled = true;


      return true;
    }
    catch(e) {
      print(e);
      return false;
    }
  }


  Future<void> signOutUser(BuildContext context) async {
    try {
      // CustomDialog(context).showProgressDialog(context, 'Signing out');
      CustomBottomSheetDialog.showProgressSheet(context,);

      await Preferences.getInstance().setCurrentUserIdKey(null);
      Provider.of<AppData>(context, listen: false).updateUserCurrentLocation(null);
      await StreamChatService().disconnectUser();
      await InternalStorageService.getInstance().clearBox();
      // AppNavigator.instance.resetKey();

      dynamic result = await AuthService().signOut();

      Navigator.of(context).pop();
      Provider.of<FeedData>(context, listen: false).reset();
      Provider.of<FriendRecommendationController>(context, listen: false).reset();
      Provider.of<AppData>(context, listen: false).reset();
      Provider.of<SkibbleAuthProvider>(context, listen: false).resetAll();
      Provider.of<LoadingController>(context, listen: false).reset();
      Provider.of<FeedController>(context, listen: false).reset();


      var emailSecureStore = Provider.of<EmailSecureStore>(context, listen: false);
      await emailSecureStore.clearEmail();

      // await Future.delayed(Duration(seconds: 1), ()=> Navigator.of(context, rootNavigator: true).pop());



    }
    catch(e) {

      print(e);
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    try {
      // Navigator.pop(context);

      CustomBottomSheetDialog.showProgressSheet(context);
      var result = await SkibbleFirebaseFunctions().callFunction('deleteUser');

      // dynamic result = await AuthService().signOut().then((value) async{
      //
      //   return res;
      // });

      if(result == 'success') {

        await Preferences.getInstance().setCurrentUserIdKey(null);
        await InternalStorageService.getInstance().clearBox();

        Provider.of<AppData>(context, listen: false).updateUserCurrentLocation(null);
        await AuthService().refreshAuthToken();

        Navigator.of(context).pop();
        Provider.of<FeedData>(context, listen: false).reset();
        Provider.of<FriendRecommendationController>(context, listen: false).reset();

        Provider.of<AppData>(context, listen: false).reset();
        Provider.of<SkibbleAuthProvider>(context, listen: false).resetAll();
        Provider.of<LoadingController>(context, listen: false).reset();
        Provider.of<FeedController>(context, listen: false).reset();

        var emailSecureStore = Provider.of<EmailSecureStore>(context, listen: false);
        await emailSecureStore.clearEmail();
        // resetAll(context);

      }
      else {
        CustomDialog(context).showErrorDialog(tr.error, tr.unableToDeleteYourAccount);
      }
    }

    catch(e) {

      print(e);

    }
  }


  resetAll(BuildContext context) async {

  }

  Future<bool> updateUserIsNotificationsEnabled(String userId, BuildContext context) async{

    try{

      var result = await UserDatabaseService().updateUserNotificationPermission(userId);
      Provider.of<AppData>(context, listen: false).skibbleUser!.isNotificationPermissionEnabled = true;


      return true;
    }
    catch(e) {
      print(e);
      return false;
    }
  }


  Future<bool> updateIsUserEmailVerified(String userId, BuildContext context, bool isEmailVerified) async{

    try{

      var result = await UserDatabaseService().updateUserIsEmailVerified(userId);
      Provider.of<AppData>(context, listen: false).skibbleUser!.isEmailVerified = isEmailVerified;

      return result;
    }
    catch(e) {
      print(e);
      return false;
    }
  }


  Widget navigateUserOnStart(BuildContext context, {SkibbleUser? user}) {

    // print(user);
    if(user != null) {
      if(user.isEmailVerified!) {

        ///Accounts that are chefs should be routed here
        if(user.accountType == AccountType.chef ) {
          if(user.chef!.kitchenName == null || user.chef!.serviceLocation == null) {

            // print(user.chef!.serviceLocation);

            // WidgetsBinding.instance.addPostFrameCallback((_) => loadChef(context));
            return const ChefRegisterPage();
          }
          else {
            return const MainPageParent(tab: 'feed',);
          }
        }

        else if(user.accountType == AccountType.kitchen) {
          if(user.kitchen!.kitchenName == null || user.kitchen!.serviceLocation == null) {

            // print(user.chef!.serviceLocation);

            // WidgetsBinding.instance.addPostFrameCallback((_) => loadChef(context));
            return const UserKitchenRegisterPage();
          }
          else {
            return const MainPageParent(tab: 'feed',);
          }
        }

        else {
          if(user.userName != null) {
            if(user.contentPreferences!.isNotEmpty) {
              if(!user.isLocationServicesEnabled) {
                return const LocationPermissionView();
              }

              if(!user.isNotificationPermissionEnabled) {
                return const NotificationsPermissionView();
              }

              return const MainPageParent(tab: 'feed',);
            }
            else {
              return UserFoodPreferencesView();
            }
          }
          else {
            return SetFullNameUserNameView();
          }
        }

      }
      else {
        return VerifyUserEmailView();
      }
    }

    else {
      // return ChefAccountDetails();
      // return ChefKitchenDetailsView();

      // return ChefQualificationsDetailsView();
      // return UserAuthPage();
      return const WelcomePage();

    }
  }
}