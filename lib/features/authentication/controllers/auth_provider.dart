import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../models/skibble_user.dart';
import '../../../navigator_provider.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/firebase/auth_services/skibble_auth_service.dart';
import '../../../services/firebase/database/user_database.dart';
import '../../../services/location_service_controller.dart';
import '../../../services/maps_services/geo_locator_service.dart';
import '../../../services/preferences/preferences.dart';
import '../../../shared/bottom_sheet_dialogs.dart';
import '../../../shared/dialogs.dart';
import '../../../utils/constants.dart';
import '../views/chef_auth/components/set_fullname_username_view.dart';
import '../views/shared_screens/user_food_preferences.dart';
import 'auth_controller.dart';

class SkibbleAuthProvider with ChangeNotifier {


  String? email;
  String? fullName;
  String? userName;
  String? password;
  String? phoneNumber;
  String? confirmPassword;
  String? _userNameErrorText;

  SkibbleUser? _signUpChef;
  SkibbleUser? _signUpUserKitchen;

  int _currentSignUpStep = 0;
  Timer? verifyEmailTimer;

  final SkibbleAuthService authService;
  SkibbleAuthProvider(this.authService);

  bool _isLoading = false;
  bool _isOnSignUpPage = false;
  bool _isPasswordObscured = true;

  SkibbleUser? get signUpChef => _signUpChef;
  SkibbleUser? get signUpUserKitchen => _signUpUserKitchen;

  int get currentSignUpStep => _currentSignUpStep;

  bool get isLoading => _isLoading;
  bool get isOnSignUpPage => _isOnSignUpPage;
  bool get isPasswordObscured => _isPasswordObscured;
  String? get userNameErrorText => _userNameErrorText;

  GlobalKey<FormState>? setFullNameUsernameFormKey;


  Map<Widget, Function>? authFlowFunctions;
  int currentPage = 0;




  resetAuthFlow() {
    currentPage = 0;
  }

  Future<bool> callChooseFoodPreferencesFunction(BuildContext context, SkibbleUser currentUser) async{
    context.read<FoodOptionsPickerData>().saveFinalChoices();

    var choices = context.read<FoodOptionsPickerData>().userChoices;
    var result = await AuthController().saveUserContentPreferences(choices, currentUser.userId!, context);

    if(result) {
      // Navigator.pop(context);

      nextPage();
      return true;

    }
    return false;
  }


  Future<bool> callChooseAccessibilityPreferencesFunction(BuildContext context, SkibbleUser currentUser) async{
    context.read<AccessibilityOptionsPickerData>().saveFinalChoices();

    var choices = context.read<AccessibilityOptionsPickerData>().userChoices;
    var result = await AuthController().saveUserAccessibilityPreferences(choices, currentUser.userId!, context);

    if(result) {
      // Navigator.pop(context);

      nextPage();
      return true;

    }
    return false;
  }



  Future<bool> callActivateLocationPermissionsFunction(BuildContext context, SkibbleUser currentUser) async{

    var locationRes = await updateLocationPermission(context, currentUser);
    return locationRes;
  }

  bool callVerifyEmailFunction(SkibbleUser currentUser) {

    if(currentUser.isEmailVerified == false) {
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'Verify your email address', backgroundColor: Colors.grey.shade200, textColor: kDarkSecondaryColor);
      return false;

    }
    return true;
  }


  Future<bool> callSetFullNameUsernameFunction(BuildContext context, SkibbleUser currentUser) async{

    return await setFullNameUsername(context, currentUser);
    // return true;
  }

  Future<bool> callActivateNotificationsFunction(BuildContext context) async{
    // if((channelName ?? '').isEmpty) {
    //   HapticFeedback.lightImpact();
    //   Fluttertoast.showToast(msg: 'Please enter a community name', backgroundColor: Colors.grey.shade200, textColor: kDarkSecondaryColor);
    //   return false;
    //
    // }

    try {
      context.read<LoadingController>().isLoadingSecond = true;
      var user = Provider.of<AppData>(context, listen: false).skibbleUser!;

      if(user.userId != null) {
        await NotificationController.requestNotificationPermissions(user, context);
        await AuthController().updateUserIsNotificationsEnabled(user.userId!, context );
      }

      context.read<LoadingController>().isLoadingSecond = false;

      nextPage();
      return true;
    }

    catch(e) {
      print(e);

      return false;
    }
  }


  void initAuthFlow(BuildContext context, SkibbleUser currentUser) {
    resetAll(shouldNotify: false);
    authFlowFunctions = {};
    if(currentUser.isEmailVerified == false) {
      authFlowFunctions?.putIfAbsent(const VerifyUserEmailView(), () => (() => callVerifyEmailFunction(currentUser)));
    }

    if(currentUser.userName == null || currentUser.fullName == null) {
      fullName = currentUser.fullName;
      userName = currentUser.userName;
      authFlowFunctions?.putIfAbsent(SetFullNameUserNameView(), () => (() => callSetFullNameUsernameFunction(context, currentUser)));
    }

    if(currentUser.contentPreferences == null || (currentUser.contentPreferences ?? []).isEmpty) {
      authFlowFunctions?.putIfAbsent(UserFoodPreferencesView(), () => (() => callChooseFoodPreferencesFunction(context, currentUser)));
    }

    // if(currentUser.accessibilityPreferences == null || (currentUser.accessibilityPreferences ?? []).isEmpty) {
    //   authFlowFunctions?.putIfAbsent(AccessibilityPreferencesView(), () => (() => callChooseAccessibilityPreferencesFunction(context, currentUser)));
    // }

    if(!currentUser.isLocationServicesEnabled) {
      authFlowFunctions?.putIfAbsent(LocationPermissionView(), () => (() => callActivateLocationPermissionsFunction(context, currentUser)));

    }

    if(!currentUser.isNotificationPermissionEnabled) {
      authFlowFunctions?.putIfAbsent(NotificationsPermissionView(), () => (() => callActivateNotificationsFunction(context)));

    }

    //helps us move to the main page
    if(authFlowFunctions!.isEmpty) {
      currentPage = -1;
    }

  }

  initVerifyEmailTimer(BuildContext context) {
    verifyEmailTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkIfUserEmailIsVerified(context);
    });
  }

  cancelVerifyEmailTimer(context) {
    verifyEmailTimer?.cancel();
  }

  Future<void> checkIfUserEmailIsVerified(BuildContext context) async {

    if(context.read<LoadingController>().isLoading == true) {
      Provider.of<LoadingController>(context, listen: false).isLoading = false;

    }

    await authService.reload(context);

    var user = await authService.currentUser();

    if(user!.isEmailVerified!) {
      //TODO:Save user to Stripe Connect
      await AuthController().updateIsUserEmailVerified(user.userId!, context, true);
      // await UserDatabaseService().updateUserIsEmailVerified(user.userId!);
      //TODO:Save user to Stripe Connect
      verifyEmailTimer!.cancel();
        nextPage();
    }
  }


  Future<bool> setFullNameUsername(BuildContext context, SkibbleUser currentUser) async {
    if (setFullNameUsernameFormKey!.currentState!.validate()) {
      setFullNameUsernameFormKey!.currentState!.save();

      // CustomDialog(context).showProgressDialog(context,'Processing');
      CustomBottomSheetDialog.showProgressSheet(context,);

      int timestamp = DateTime.now().millisecondsSinceEpoch;

      userName = userName!.trim().toLowerCase();

      bool checkUserName = await UserDatabaseService().checkIfThereIsAnExistingUserName(userName!);

      if(checkUserName) {
        Navigator.pop(context);
          userNameErrorText = 'Username has already been taken. Try another name.';
          notifyListeners();
        // CustomDialog(context).showErrorDialog('Username Exists', 'This username has already been taken.');

        return false;
      }

      else {
        currentUser.fullName = fullName;
        currentUser.userName = userName;
        var result = await UserDatabaseService().updateUserData(currentUser);
        Navigator.pop(context);

        if(result != null) {
          // AppNavigator.instance.navigatorKey.currentState?.pop();

          var preferences = await Preferences.getInstance();
          await preferences.setFirstTimeEmailVerifiedKey(false);
          await preferences.setCurrentUserIdKey(currentUser.userId);

          nextPage();

          return true;
          // Provider.of<AppData>(context, listen: false).updateUser(widget.currentUser);
          // var authProvider = Provider.of<AuthProvider>(context, listen: false);
          // await authProvider.authService.reload(context);

          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserFoodPreferencesView( user: widget.currentUser,)));

        }
        else {
          // Navigator.pop(context);
          // AppNavigator.instance.navigatorKey.currentState?.pop();

          CustomBottomSheetDialog.showErrorSheet(context, 'We\'re unable to store your information.\n\nTry again later or contact us at hello@skibble.app.', onButtonPressed: () {  });

          return false;
        }
      }

    }

    return false;

  }


  Future<bool> updateLocationPermission(BuildContext context, SkibbleUser user) async{
    try {
      LocationServiceController locationService = LocationServiceController();

      await locationService.requestLocationService(context);
      await locationService.requestLocationPermission(context);

      context.read<LoadingController>().isLoadingSecond = true;
      await GeoLocatorService().getCurrentPositionAddress(context).then((value) async{
        if(value != null) {
          SkibbleFirebaseFunctions().callFunction(
              'onCreateNewUserGenerateMeets',
              data: {'userId': user.userId, 'lat': value.latitude, 'lng': value.longitude}
          );


          //generate friend suggestions
          SkibbleFirebaseFunctions().callFunction(
              'onCreateNewUserGenerateFriendRecommendations',
              data: {'userId': user.userId, 'lat': value.latitude, 'lng': value.longitude, 'preferences': user.contentPreferences}
          );
          await AuthController().updateUserIsLocationEnabled(value, user.userId!, context);
        }
      });
      context.read<LoadingController>().isLoadingSecond = false;

      // var authService = Provider.of<AuthProvider>(context, listen: false).authService;
      // await authService.reload(context);

      // AuthController().navigateDuringSignUp( context);

      return true;
    }
    catch(e) {
      return false;
    }
  }

  updateNotificationPermission(BuildContext context, SkibbleUser currentUser) async {
    context.read<LoadingController>().isLoadingSecond = true;

    if(currentUser.userId != null) {
      await AuthController().updateUserIsNotificationsEnabled(currentUser.userId!, context );
    }


    context.read<LoadingController>().isLoadingSecond = false;

    // AuthController().navigateDuringSignUp( context);

  }


  void nextPage() {

    if(currentPage + 1 < authFlowFunctions!.length) {
      currentPage += 1;
    }

    else {
      currentPage = -1;
    }


    notifyListeners();
  }


  void previousPage() {
    if(currentPage != 0) {
      currentPage -= 1;
      notifyListeners();
    }
  }


  void set signUpChef(SkibbleUser? signUpChef) {
    _signUpChef = signUpChef;
    notifyListeners();
  }

  void set signUpChefWithoutNotify(SkibbleUser? signUpChef) {
    _signUpChef = signUpChef;
  }

  void set signUpUserKitchen(SkibbleUser? signUpUserKitchen) {
    _signUpUserKitchen = signUpUserKitchen;
    notifyListeners();
  }

  void set signUpUserKitchenWithoutNotify(SkibbleUser? signUpUserKitchen) {
    _signUpUserKitchen = signUpUserKitchen;
  }

  void resetAll({bool shouldNotify = true}) {
    _isLoading = false;
    _userNameErrorText = null;
    fullName = null;
    email = null;
    password = null;
    phoneNumber = null;
    userName = null;
    _signUpChef = null;
    _currentSignUpStep = 0;
    _isOnSignUpPage = false;
    _isPasswordObscured = true;
    currentPage = 0;

    if(shouldNotify)
      notifyListeners();
  }

  void set currentSignUpStep(int value) {
    _currentSignUpStep = value;
    notifyListeners();
  }

  void set isLoading(bool isLoggingIn) {
    _isLoading = isLoggingIn;
    notifyListeners();
  }

  void set isOnSignUpPage(bool isOnSignUpPage) {
    _isOnSignUpPage = isOnSignUpPage;
    notifyListeners();
  }

  void set isPasswordObscured(bool isPasswordObscured) {
    _isPasswordObscured = isPasswordObscured;
    notifyListeners();
  }

  void set userNameErrorText(String? userNameErrorText) {
    _userNameErrorText = userNameErrorText;
    notifyListeners();
  }

}