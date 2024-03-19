import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skibble/models/chat_models/chat_message.dart';
import 'package:skibble/features/communities/models/community.dart';
import 'package:skibble/models/friend_request.dart';
import 'package:skibble/models/home_page_model.dart';
import 'package:skibble/models/menu_models/menu.dart';
import 'package:skibble/models/menu_models/food_menu_item.dart';
import 'package:skibble/models/notification_model/notification.dart';
import 'package:skibble/models/skibble_place.dart';
import 'package:skibble/models/skibble_user.dart';

import '../../models/address.dart';
import '../../models/blocked_model.dart';
import '../../models/certificationsController.dart';
import '../../models/recipe.dart';
import '../../models/shopping_list.dart';
import '../../models/moment.dart';
import '../../models/work_experience_controller_model.dart';


class AppData extends ChangeNotifier {
  SkibbleUser? skibbleUser;
  BuildContext? globalContext;
  late GlobalKey<NavigatorState> navigatorKey;


  // void setContext(BuildContext newContext) {
  //   globalContext = newContext;
  //   // notifyListeners();
  // }


  late AsyncSnapshot<SkibbleUser?> userSnapshot;

  late ImageProvider welcomePageImage;

  // AppData();

  List<Menu> menuList = [];
  List<CustomNotification> notificationsList = [];
  String isThemeChanged = 'light';
  bool isChefProfileScrolled = false;
 // List<IngredientInputField> ingredientsFormList = [];
  List<String> ingredientsList = [];

  Address? locationAddress;
  bool redrawMap = false;

  List<SkibbleUser>? friendsList;
  List? foodTags = [];

  //Contains friends who have stories
  List<dynamic>? friendMoments = [];



  Map<String, SkibbleUser> friendsMap = {};
  Map<String, SkibbleUser> usersMap = {};



  //this holds data for the registration of a chef
  SkibbleUser? currentUserChef;
  Address? userCurrentLocation;

  List<FriendRequest> friendRequestList = [];
  String currentConvoId = '';

  DiscoverPageModel discoverPageModel = DiscoverPageModel();

  String result = '';
  ChatMessage? swipedMessage;

  bool isSendingMediaMessage = false;

  SkibbleUser? editingUser;


  late String _darkMapStyle;
  late String _lightMapStyle;

  int currentStep = 1;
  bool isBackButtonPressed = false;
  bool isContinueButtonPressed = false;

  File? profileImageFile;
  List<File?>? galleryFiles = List.filled(6, null);

  List<WorkExperienceControllerModel> workExperienceListControllers = [];
  List<CertificationsController> certificationsListControllers = [];


  void updateNavigatorKey() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  void updateUserIsVerified(bool isVerified) {
    skibbleUser!.isUserVerified = isVerified;
    notifyListeners();
  }

  void reset() async{
    menuList = [];
    notificationsList = [];
    isThemeChanged = 'light';
    isChefProfileScrolled = false;
    // List<IngredientInputField> ingredientsFormList = [];
    ingredientsList = [];

    locationAddress = null;
    redrawMap = false;

    friendsList;
    foodTags = [];

    //Contains friends who have stories
    friendMoments = [];


    friendsMap = {};
    usersMap = {};



    //this holds data for the registration of a chef
    currentUserChef = null;
    userCurrentLocation = null;

    friendRequestList = [];
    currentConvoId = '';

    discoverPageModel = DiscoverPageModel();

    result = '';
    swipedMessage = null;

    isSendingMediaMessage = false;

    skibbleUser = null;

    editingUser = null;


    _darkMapStyle = '';
    _lightMapStyle = '';

    currentStep = 1;
    isBackButtonPressed = false;
    isContinueButtonPressed = false;

    profileImageFile = null;
    galleryFiles = List.filled(6, null);

    workExperienceListControllers = [];
    certificationsListControllers = [];


  }
  void updateIsChefProfileScrolled(bool value) {
    isChefProfileScrolled = value;
    notifyListeners();
  }

  void markNotificationAsSeen(String notificationID) {
    var found = notificationsList.firstWhere((element) => element.notificationId == notificationID, orElse: () => CustomNotification());

    if(found.notificationId != null && !found.isSeen) {
      found.isSeen = true;
      notifyListeners();
    }
  }

  void addToUserSkib(String skibId, int timeCreated) {
    if(skibbleUser!.recentPosts != null) {
      skibbleUser!.recentPosts!.add({
        'createdAt': timeCreated,
        'postId': skibId
      });
    }
    else {
      skibbleUser!.recentPosts = [];
      skibbleUser!.recentPosts!.add({
        'createdAt': timeCreated,
        'postId': skibId
      });
    }
    notifyListeners();
  }

  void addToUserRecipes(String recipeId, int timeCreated) {
    if(skibbleUser!.recentRecipes != null) {
      skibbleUser!.recentRecipes!.add({
        'createdAt': timeCreated,
        'recipeId': recipeId
      });
    }
    else {
      skibbleUser!.recentRecipes = [];
      skibbleUser!.recentRecipes!.add({
        'createdAt': timeCreated,
        'recipeId': recipeId
      });
    }
    notifyListeners();
  }

  void deleteFromUserRecentSkibs(String skibId) {
    if(skibbleUser!.recentPosts != null) {
      skibbleUser!.recentPosts!.removeWhere((element) => element['postId'] == skibId);
    }
    notifyListeners();
  }

  void deleteFromUserRecentRecipes(String skibId) {
    if(skibbleUser!.recentRecipes != null) {
      skibbleUser!.recentRecipes!.removeWhere((element) => element['recipeId'] == skibId);
    }
    notifyListeners();
  }


  void addUserToMap(SkibbleUser user, ) {

    if(usersMap[user.userId!] == null) {
      usersMap.putIfAbsent(user.userId!, () => user);
    }
    else {
      usersMap[user.userId!] = user;
    }
    notifyListeners();
  }

  SkibbleUser? getUserFromMap(String userId) {
    return usersMap[userId];
  }

  void updateUserInMap(SkibbleUser user) {
     if(usersMap[user.userId] != null) {
       usersMap[user.userId!] = user;
     }
  }

  void addFriendToMap(SkibbleUser friend, ) {
    if(friendsMap[friend.userId!] == null) {
      friendsMap.putIfAbsent(friend.userId!, () => friend);
    }
    else {
      friendsMap[friend.userId!] = friend;
    }

    notifyListeners();
  }

  void removeFriendFromMap(SkibbleUser friend, ) {

    friendsMap.remove(friend.userId);

    notifyListeners();
  }
  void updateLocationAddress(Address? address) {
    locationAddress = address;
    notifyListeners();
  }


  void updateRedrawMap(bool value) {
    redrawMap = value;
    notifyListeners();
  }

  void updateIsThemeChanged(String value) {

    isThemeChanged = value;
    notifyListeners();
  }

  void updateIsStripeComplete(bool value) {

    skibbleUser!.isStripeConnectSetup = value;
    notifyListeners();
  }

  void joinCommunity(String communityId) {

    skibbleUser!.memberCommunities!.add(communityId);
    notifyListeners();
  }

  void updateIsSendingMediaMessage(bool value) {

    isSendingMediaMessage = value;
    notifyListeners();
  }

  void updateNotificationsList(List<CustomNotification> value) {

    notificationsList = value;
    notifyListeners();
  }

  void leaveCommunity(String communityId) {
    skibbleUser!.memberCommunities!.remove(communityId);
    notifyListeners();
  }

  void updateEditingUser(SkibbleUser? user) {
    editingUser = user;
    notifyListeners();
  }

  void createUserShoppingList(List<ShoppingList> list) {
    skibbleUser!.shoppingLists = list;
    notifyListeners();
  }

  void addShoppingListToUserShoppingList(ShoppingList list) {
    skibbleUser!.shoppingLists!.insert(0, list);
    notifyListeners();
  }

  void updateShoppingListInUserShoppingList(ShoppingList list) {
    int value = skibbleUser!.shoppingLists!.indexOf(skibbleUser!.shoppingLists!.where((element) => element.shoppingListId == list.shoppingListId).first);
    skibbleUser!.shoppingLists![value] = list;
    notifyListeners();
  }

  void deleteShoppingListInUserShoppingList(ShoppingList list) {
    skibbleUser!.shoppingLists!.removeWhere((element) => element.shoppingListId == list.shoppingListId);
    notifyListeners();
  }

  void updateFoodTags(List newFoodTags) {
    foodTags = newFoodTags;
    notifyListeners();
  }

  ///******* Menu Handlers ******
  void updateCurrentUserChefMenu(List<Menu> menuList) {
    skibbleUser!.chef!.menusList = menuList;
    notifyListeners();
  }

  ///This is called first when all menu items are fetched from the database
  void updateCurrentUserChefFoodMenuItems(String menuID, List<FoodMenuItem> menuItemsList) {
    skibbleUser!.chef!.menusList!.where((menu) => menu.menuId == menuID).first.menuItems.addAll(menuItemsList);
    notifyListeners();
  }

  ///This adds new items to a menu
  ///It also updates an existing menu item
  void updateCurrentUserChefFoodMenuItem(String menuID, FoodMenuItem menuItem) {

    var index = skibbleUser!.chef!.menusList!.where((menu) => menu.menuId == menuID).first.menuItems.indexWhere((item) => item.menuItemId == menuItem.menuItemId);

    if(index != -1) {
      skibbleUser!.chef!.menusList!.where((menu) => menu.menuId == menuID).first.menuItems[index] = menuItem;
    }
    else {
      skibbleUser!.chef!.menusList!.where((menu) => menu.menuId == menuID).first.menuItems.add(menuItem);
      skibbleUser!.chef!.menusList!.where((menu) => menu.menuId == menuID).first.totalItems = skibbleUser!.chef!.menusList!.where((menu) => menu.menuId == menuID).first.totalItems + 1;
    }
    notifyListeners();
  }

  void addMenuToCurrentChef(Menu menu) {
    skibbleUser!.chef!.menusList!.add(menu);
    notifyListeners();
  }

  void editMenuTitle(String value, Menu menu) {
    skibbleUser!.chef!.menusList!.where((element) => menu.menuId == element.menuId).first.menuTitle = value;
    notifyListeners();
  }

  void removeMenuAtIndex(int index) {
    skibbleUser!.chef!.menusList!.removeAt(index);
    notifyListeners();
  }

  void blockUser(String userId) {
    // skibbleUser!.blockedUsers!.add(userId);
    notifyListeners();
  }

  void unBlockUser(String userId) {
    // skibbleUser!.blockedUsers!.remove(userId);
    notifyListeners();
  }

  void removeFoodMenuItemAtIndex(int index, String menuId) {
    skibbleUser!.chef!.menusList!.where((menu) => menu.menuId == menuId).first.menuItems.removeAt(index);
    notifyListeners();
  }

  ///**** End of Menu Handlers ****

  // void addWorkExperienceControllersList(WorkExperienceControllerModel newWorkExperienceController) {
  //   workExperienceListControllers.add(newWorkExperienceController);
  //   // notifyListeners();
  // }

  // void removeWorkExperienceControllersList(WorkExperienceControllerModel newWorkExperienceController) {
  //   workExperienceListControllers.remove(newWorkExperienceController);
  //   // notifyListeners();
  // }
  //
  // void addCertificationsControllersList(CertificationsController newCertificationsController) {
  //   certificationsListControllers.add(newCertificationsController);
  //   // notifyListeners();
  // }
  //
  // void removeCertificationsControllersList(CertificationsController newCertificationsController) {
  //   certificationsListControllers.remove(newCertificationsController);
  //   // notifyListeners();
  // }
  void updateWorkExperienceControllersList(List<WorkExperienceControllerModel> newWorkExperienceListControllers) {
    workExperienceListControllers = newWorkExperienceListControllers;
    // notifyListeners();
  }

  void updateCertificationsControllersList(List<CertificationsController> newCertificationsListControllers) {
    certificationsListControllers = newCertificationsListControllers;
    // notifyListeners();
  }

  void addToUserFollowing(String userID) {
    skibbleUser!.totalFollowings = skibbleUser!.totalFollowings! + 1;
    // skibbleUser!.followingsList!.add(userID);
    notifyListeners();
  }

  ///Adds current user to his/her list of current moment viewers
  void addCurrentUserToMomentViews(String currentUserId, List<String> momentList) {
    // skibbleUser!.userMomentList.

    momentList.forEach((momentId) {
      skibbleUser!.userMomentList!.where((moment) => moment.momentId == momentId).first.viewedMomentUsers!.add(currentUserId);
    });
    notifyListeners();
  }

  void addMomentToUserMoments(Moment moment) {
    moment.viewedMomentUsers = [];
    skibbleUser!.numberOfRecentMoments = skibbleUser!.numberOfRecentMoments! + 1;
    skibbleUser!.totalNumberOfMoments = skibbleUser!.totalNumberOfMoments! + 1;
    skibbleUser!.recentMoments!.add({'createdAt': moment.timePosted, 'momentId': moment.momentId});
    skibbleUser!.userMomentList!.add(moment);
    notifyListeners();
  }

  void deleteMomentFromUserMoments(Moment moment) {
    moment.viewedMomentUsers = [];
    skibbleUser!.numberOfRecentMoments = skibbleUser!.numberOfRecentMoments! - 1;
    skibbleUser!.totalNumberOfMoments = skibbleUser!.totalNumberOfMoments! - 1;
    skibbleUser!.recentMoments!.removeWhere((element) => element['momentId'] == moment.momentId);
    skibbleUser!.userMomentList!.removeWhere((element) => element.momentId == moment.momentId);
    notifyListeners();
  }

  void removeFromUserFollowing(String userID) {
    skibbleUser!.totalFollowings = skibbleUser!.totalFollowings! - 1;
    // skibbleUser!.followingsList!.remove(userID);
    notifyListeners();
  }

  void updateUserFollowers(List<String> followers) {
    // skibbleUser!.followersList = followers;
    notifyListeners();
  }

  void updateUsersWhoBlockedMe(List<BlockedModel> users) {
    // skibbleUser!.usersWhoBlockedMe = users;
    notifyListeners();
  }

  void updateIsBackButtonPressed(bool value) {
    isBackButtonPressed = value;
    notifyListeners();
  }

  void updateDiscoverModelTopRatedChefs(List<SkibbleUser> topRatedList) {
    if(discoverPageModel.topRatedChefsList == null) {
      discoverPageModel.topRatedChefsList = topRatedList;
    }
    else {
      discoverPageModel.topRatedChefsList!.addAll(topRatedList);
    }
    notifyListeners();
  }

  void updateDiscoverModelTopRatedKitchens(List<SkibbleUser> topRatedList) {
    if(discoverPageModel.topRatedKitchensList == null) {
      discoverPageModel.topRatedKitchensList = topRatedList;
    }
    else {
      discoverPageModel.topRatedKitchensList!.addAll(topRatedList);
    }
    notifyListeners();
  }

  void updateDiscoverModelNearbyChefs(List<SkibbleUser> nearbyList) {
    discoverPageModel.nearbyChefsList = nearbyList;
    notifyListeners();
  }

  void updateDiscoverModelNearbyKitchens(List<SkibbleUser> nearbyList) {
    discoverPageModel.nearbyKitchensList = nearbyList;
    notifyListeners();
  }

  void updateDiscoverModelSuggestedRecipes(List<Recipe> suggestedRecipes) {
    discoverPageModel.suggestedRecipes = suggestedRecipes;
    notifyListeners();
  }

  void updateDiscoverModelMostLikedRecipes(List<Recipe> mostLikedRecipes) {
    discoverPageModel.mostLikedRecipes = mostLikedRecipes;
    notifyListeners();
  }

  void updateDiscoverModelSuggestedPlaces(List<SkibbleFoodBusiness> suggestedPlaces) {
    discoverPageModel.suggestedPlaces = suggestedPlaces;
    notifyListeners();
  }

  void updateDiscoverModelNearbyPlaces(List<SkibbleFoodBusiness> nearbyPlaces) {
    discoverPageModel.nearbyPlaces = nearbyPlaces;
    notifyListeners();
  }

  void updateDiscoverModelSuggestedCommunities(List<Community> suggestedCommunities) {
    discoverPageModel.suggestedCommunities = suggestedCommunities;
    notifyListeners();
  }

  void updateDiscoverModelTrendingCommunities(List<Community> trendingCommunity) {
    discoverPageModel.trendingCommunities = trendingCommunity;
    notifyListeners();
  }

  void updateDiscoverModelMostVisitedCommunities(List<Community> mostVisitedCommunities) {
    discoverPageModel.mostVisitedCommunities = mostVisitedCommunities;
    notifyListeners();
  }

  void updateDiscoverModelLatestCommunities(List<Community> latestCommunities) {
    discoverPageModel.latestCommunities = latestCommunities;
    notifyListeners();
  }

  void updateUserCurrentLocation(Address? address) {
    userCurrentLocation = address;
    notifyListeners();
  }

  void updateProfileImageFileUrl(File newValue) {
    profileImageFile = newValue;
    notifyListeners();
  }

  void updateGalleryFilesUrls(File newValue, int index) {
    galleryFiles![index] = newValue;
    notifyListeners();
  }

  void updateCurrentStep(int value) {
    currentStep = value;
    notifyListeners();
  }

  void updateIsContinueButtonPressed(bool value) {
    isContinueButtonPressed = value;
    notifyListeners();
  }

  void updateCurrentUserChef(SkibbleUser? user) {
    currentUserChef = user;
    notifyListeners();
  }

  void updateCurrentConvoId(String newConvoId) {
    currentConvoId = newConvoId;
    notifyListeners();
  }

  void updateCurrentUserMoments(List<Moment> newMomentList) {
    skibbleUser!.userMomentList = newMomentList;
    notifyListeners();
  }


  void updateFriendMoments(List newFriendMoments) {
    friendMoments = newFriendMoments;
    notifyListeners();
  }

  void addUserWhoViewedMoment(String userId, String viewerId, int momentIndex) {

    //Check if the user viewed his or her own moment
    if(userId == viewerId) {
      skibbleUser!.userMomentList![momentIndex].viewedMomentUsers!.add(userId);
    }
    else {
      friendMoments?.where((element) => element.userId == userId).first.userMomentList[momentIndex].viewedMomentUsers!.add(viewerId);
    }
    notifyListeners();
  }

  void updateDiscoverPageModel(DiscoverPageModel newDiscoverPageModel) {
    discoverPageModel = newDiscoverPageModel;
    notifyListeners();
  }

  void updateFriendsList(List<SkibbleUser> newFriendsList) {
    friendsList = [];
    friendsList = newFriendsList;
    notifyListeners();
  }

  void updateFriendRequestList(List<FriendRequest> newFriendRequestList) {
    friendRequestList = newFriendRequestList;
    notifyListeners();
  }

  void addNewFriendRequest(FriendRequest newFriendRequest) {
    friendRequestList.add(newFriendRequest);
    // notifyListeners();
  }

  void updateSwipedMessage(ChatMessage? chatMessage) {
    swipedMessage = chatMessage;
    notifyListeners();
  }

  void updateUser(SkibbleUser? value, {bool shouldNotifyListeners = true}) {
    skibbleUser = value;
    if(shouldNotifyListeners) {
      notifyListeners();
    }
  }


  void updateQRCodeResult(String newResult) {
    result = newResult;
    notifyListeners();
  }
  void updateMenuList(List<Menu> newMenuList) {
    menuList = newMenuList;
    notifyListeners();
  }

  // void updateIngredientsFormList(List<IngredientInputField> formList) {
  //   ingredientsFormList = formList;
  //   notifyListeners();
  // }

  void updateIngredientsList(List<String> newList) {
    ingredientsList = newList;
    notifyListeners();
  }

  void addToIngredientsList(String newIngredient) {
    ingredientsList.add(newIngredient);
    notifyListeners();
  }

  void addToIngredientListWithIndex(int index, String newValue) {
    ingredientsList[index] = newValue;
    notifyListeners();
  }

  void deleteFromIngredientsList(int index) {
    ingredientsList.removeAt(index);
    notifyListeners();
  }

  // void deleteFromIngredientFormList(int index) {
  //   ingredientsFormList.removeAt(index);
  //   notifyListeners();
  // }
}