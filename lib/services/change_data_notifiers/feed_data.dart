import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:skibble/features/communities/models/community_group.dart';
import 'package:skibble/models/explore_feed.dart';
import 'package:skibble/models/feed_post.dart';
import 'package:skibble/models/skibble_post.dart';

import '../../models/chat_models/chat_message.dart';
import '../../models/chef_group.dart';
import '../../features/communities/models/community.dart';
import '../../models/place_group.dart';
import '../../models/recipe.dart';
import '../../models/recipe_group.dart';
import '../../models/skibble_post_comment.dart';
import '../../models/skibble_user.dart';
import '../../models/moment.dart';

class FeedData extends PropertyChangeNotifier<String> {
  List<FeedPost> userFeed = [];
  ExploreFeed exploreFeed = ExploreFeed(exploreData: []);
  String? exploreFeedLastDocId;
  List userRecentSkibblePostsMaps = [];
  List userRecentRecipesMaps = [];
  SkibblePost? currentUserRecentPost;


  int lastExploreFeedLongCard = 0;

  PagingController<int, FeedPost>? pagingController;

  Set<String> likedSkibsList = {};
  Set<String> likedRecipesList = {} ;

  Map<String, List<String>> likedRecipeMap = {};
  Map<String, List<String>> likedSkibsMap = {};

  //stores the current user posts and recipes
  bool isCurrentUserPostsFetchedBefore = false;
  List<SkibblePost> currentUserPosts = [];

  bool isCurrentUserRecipesFetchedBefore = false;
  List<Recipe> currentUserRecipes = [];

  List<CommunityGroup> homePageCommunities = [];
  List<RecipeGroup> discoverPageRecipes = [];
  List<ChefGroup> discoverPageChefs = [];
  List<PlaceGroup> discoverPagePlaces = [];


  List<SkibbleUser> userFeedMoments = [];
  List userMomentsMap = [];

  void reset() {
    userFeed = [];
    exploreFeed = ExploreFeed(exploreData: []);
    exploreFeedLastDocId = null;
    userRecentSkibblePostsMaps = [];
    userRecentRecipesMaps = [];
    currentUserRecentPost;


    lastExploreFeedLongCard = 0;

    pagingController = null;

    likedSkibsList = {};
    likedRecipesList = {} ;

    likedRecipeMap = {};
    likedSkibsMap = {};

    //stores the current user posts and recipes
    isCurrentUserPostsFetchedBefore = false;
    currentUserPosts = [];

    isCurrentUserRecipesFetchedBefore = false;
    currentUserRecipes = [];
    homePageCommunities = [];
    discoverPageRecipes = [];
    discoverPageChefs = [];
    discoverPagePlaces = [];


    userFeedMoments = [];
    userMomentsMap = [];
  }

  void initFeedPageController() {
    pagingController = PagingController(firstPageKey: 0);
  }


  void updateIsCurrentUserPostFetchedBefore(bool value) {
    isCurrentUserPostsFetchedBefore = value;
    notifyListeners();
  }

  void updateIsCurrentUserRecipesFetchedBefore(bool value) {
    isCurrentUserRecipesFetchedBefore = value;
    notifyListeners();
  }


  void updateLastExploreFeedLongCard(int value) {

    lastExploreFeedLongCard = value;
    notifyListeners();
  }
  void updateHomePageCommunities(List<CommunityGroup> group, {String? groupTitle, List<Community>? communities}) {
    if(homePageCommunities.isEmpty) {
      homePageCommunities = group;
    }

    else {
      var found = homePageCommunities.firstWhere((element) => element.groupTitle == groupTitle, orElse: () => CommunityGroup(groupTitle: '', communities: []));

      if(found.groupTitle.isNotEmpty) {
        found.communities.addAll(communities!);
      }
      else {
        homePageCommunities.add(CommunityGroup(communities: communities!, groupTitle: groupTitle!));
      }
    }
    notifyListeners();
  }

  void updateDiscoverPageRecipes(List<RecipeGroup> group, {String? groupTitle, List<Recipe>? recipes}) {
    if(discoverPageRecipes.isEmpty) {
      discoverPageRecipes = group;
    }

    else {
      var found = discoverPageRecipes.firstWhere((element) => element.groupTitle == groupTitle, orElse: () => RecipeGroup(groupTitle: '', recipes: []));

      if(found.groupTitle.isNotEmpty) {
        found.recipes.addAll(recipes!);
      }
      else {
        discoverPageRecipes.add(RecipeGroup(recipes: recipes!, groupTitle: groupTitle!));
      }
    }

    notifyListeners();
  }

  void updateDiscoverPageChefs(List<ChefGroup> group, {String? groupTitle, List<SkibbleUser>? users}) {

    if(discoverPageChefs.isEmpty) {
      discoverPageChefs = group;
    }

    else {
      var found = discoverPageChefs.firstWhere((element) => element.groupTitle == groupTitle, orElse: () => ChefGroup(groupTitle: '', chefs: []));

      if(found.groupTitle.isNotEmpty) {
        found.chefs.addAll(users!);
      }
      else {
        discoverPageChefs.add(ChefGroup(chefs: users!, groupTitle: groupTitle!));
      }
    }
    notifyListeners();
  }

  void updateDiscoverPagePlaces(List<PlaceGroup> group) {
    discoverPagePlaces = group;
    notifyListeners();
  }

  ///This updates a community in the home page community
  ///This method is also used to add a new community to the home page community if the community that is about to be updated is not found
  // void updateOrAddCommunityInHomePage(CommunityGroup group) {
  //   var foundIndex = homePageCommunities.indexWhere((element) => element.communityId == community.communityId,);
  //
  //   if(foundIndex != -1) {
  //     homePageCommunities[foundIndex]. = community;
  //   }
  //   else {
  //     homePageCommunities.insert(0, community);
  //   }
  //
  //   notifyListeners();
  // }


  void updateExploreFeedLastDocId(String lastDoc) {
    exploreFeedLastDocId = lastDoc;
  }

  void updateLikedSkibsMap(Map<String, List<String>> likesMap) {
    likedSkibsMap = likesMap;
    notifyListeners();
  }

  void addToLikedSkibsMap(String key, String value) {
    if(likedSkibsMap.containsKey(key)) {
      likedSkibsMap[key]!.add(value);
    }
    else {
      likedSkibsMap.putIfAbsent(key, () => [value]);
    }
    notifyListeners();
  }

  void removeFromLikedSkibsMap(String key, String value) {
    if(likedSkibsMap.containsKey(key)) {
      likedSkibsMap[key]!.remove(value);
    }
    notifyListeners();
  }

  void updateLikedRecipesMap(Map<String, List<String>> likesMap) {
    likedRecipeMap = likesMap;
    notifyListeners();
  }

  void addToLikedRecipesMap(String key, String value) {
    if(likedRecipeMap.containsKey(key)) {
      likedRecipeMap[key]!.add(value);
    }
    else {
      likedRecipeMap.putIfAbsent(key, () => [value]);
    }
    notifyListeners();
  }

  void removeFromLikedRecipesMap(String key, String value) {
    if(likedRecipeMap.containsKey(key)) {
      likedRecipeMap[key]!.remove(value);
    }
    notifyListeners();
  }

  void updateLikedSkibsList(List<String> newLikedSkibsList ) {
    likedSkibsList.addAll(newLikedSkibsList);
    notifyListeners();
  }

  void addToLikedSkibsList( String value) {
    likedSkibsList.add(value);
    notifyListeners();
  }

  void deleteFromLikedSkibsList(String value ) {
    likedSkibsList.remove(value);
    notifyListeners();
  }



  void updateLikedRecipesList(List<String> newLikedRecipesList) {
    likedRecipesList.addAll(newLikedRecipesList);
    notifyListeners();
  }

  void addToLikedRecipesList( String value) {
    likedRecipesList.add(value);
    notifyListeners();
  }

  void deleteFromLikedRecipesList(String value) {
    likedRecipesList.remove(value);
    notifyListeners();
  }

  void updateRecipeInUserFeed(Recipe recipe) {
    var foundRecipe =  userFeed.where((element) => element.feedPostType == FeedPostType.recipe).firstWhere((element) => element.recipe!.recipeId == recipe.recipeId, orElse: () => FeedPost(feedPostType: FeedPostType.recipe, feedPostId: ''));


    if(foundRecipe.recipe != null) {
      foundRecipe.recipe = recipe;

      notifyListeners();
    }
  }

  /**
   * Updates a skib that is currently in the user feed
   */
  void updateSkibInUserFeed(SkibblePost post) {
    var foundSkib = userFeed.where((element) => element.feedPostType == FeedPostType.skib).firstWhere((element) => element.post!.postId == post.postId, orElse: () => FeedPost(feedPostType: FeedPostType.skib, feedPostId: ''));

    if(foundSkib.post != null) {
      foundSkib.post = post;

      notifyListeners();
    }
  }

  /**
   * Initialises the user feed
   */
  void initialiseUserFeed(List<FeedPost> newFeed) {
    userFeed = newFeed;
    notifyListeners('userFeed');
  }

  /**
   * Inserts a new post to the user feed
   */
  void addNewPostsToUserFeed(List<FeedPost> newFeed) {
    userFeed.insertAll(0, newFeed);
    notifyListeners('userFeed');
  }

  /**
   * Adds old posts to the user feed
   */
  void addOldPostsToUserFeed(List<FeedPost> newFeed) {
    userFeed.addAll(newFeed);
    notifyListeners('userFeed');
  }

  void updateUserMomentMap(List newMomentsMap) {
    userMomentsMap = newMomentsMap;
    notifyListeners();
  }

  ///deletes a skib from user feed and explore page
  void deleteSkibPost(SkibblePost post) {
    userFeed.removeWhere((element) => element.feedPostId == post.postId);
    if(exploreFeed.exploreData != null) {
      exploreFeed.exploreData!.removeWhere((element) => element.post != null && element.post!.postId! == post.postId);
    }

    notifyListeners();
  }

  ///deletes a recipe from user feed and explore page
  void deleteRecipe(Recipe recipe) {
    userFeed.removeWhere((element) => element.recipe != null && element.recipe!.recipeId == recipe.recipeId);
    if(exploreFeed.exploreData != null) {
      exploreFeed.exploreData!.removeWhere((element) => element.recipe != null && element.recipe!.recipeId! == recipe.recipeId);
    }

    notifyListeners();
  }

  void updateUserFeedMoments(List<SkibbleUser> newFeedMoments) {
    userFeedMoments = newFeedMoments;
    notifyListeners();
  }

  void updateAllViewedMoments(Map<String, List<String>> viewedMoments, String currentUserId) {

    viewedMoments.forEach((key, value) {
     var user = userFeedMoments.where((user) => user.userId == key).first;

     viewedMoments[key]!.forEach((momentId) {
       user.userMomentList!.where((moment) => moment.momentId == momentId).first.viewedMomentUsers!.add(currentUserId);
     });
    });

    notifyListeners();
  }

  void viewUserMoment(String momentAuthorId, Moment viewedMoment, String currentUserId) {
    userFeedMoments
        .where((user) => user.userId == momentAuthorId).first.userMomentList!
        .where((moment) => moment.momentId == viewedMoment.momentId).first.viewedMomentUsers!
        .add(currentUserId);
    notifyListeners();
  }

  void updateUserRecentSkibblePostsMaps(List newFeedMap) {
    userRecentSkibblePostsMaps = newFeedMap;
    notifyListeners();
  }

  void updateUserRecentRecipesMaps(List newFeedMap) {
    userRecentRecipesMaps = newFeedMap;
    notifyListeners();
  }

  void addNewToUserRecentSkibblePostsMaps(List<SkibblePost> newFeedMap) {
    userRecentSkibblePostsMaps.insertAll(0, newFeedMap);
    notifyListeners();
  }

  void addOldToUserRecentSkibblePostsMaps(List newFeed) {
    userRecentSkibblePostsMaps.addAll(newFeed);
    notifyListeners();
  }



  void updateExploreFeed(ExploreFeed newFeed) {
    //exploreFeed.exploreData = [];
    exploreFeed.exploreData!.addAll(newFeed.exploreData!);
    exploreFeed.lastRecipeDoc = newFeed.lastRecipeDoc ?? exploreFeed.lastRecipeDoc;
    exploreFeed.lastSkibDoc = newFeed.lastSkibDoc ?? exploreFeed.lastSkibDoc;
    notifyListeners();
  }

  void resetExploreFeed() {
    exploreFeed = ExploreFeed(exploreData: []);
    notifyListeners();
  }

  void resetHomePageCommunities() {
    homePageCommunities = [];
    notifyListeners();
  }

  void addNewToExploreFeed(List<FeedPost> newFeed) {
    exploreFeed.exploreData!.insertAll(0, newFeed);
    notifyListeners();
  }

  void addOldToExploreFeed(List<FeedPost> newFeed) {
    exploreFeed.exploreData!.addAll(newFeed);
    notifyListeners();
  }

  void commentOnPostInUserFeed(SkibblePost post, SkibblePostComment comment) {
    try {
      var foundPost = userFeed.where((element) => element.feedPostType == FeedPostType.skib).where((element) => element.post!.postId == post.postId).first;
      // foundPost.post!.commentsList!.add(comment);
      foundPost.post!.totalComments += 1;
      notifyListeners();
    } catch(e) {}
  }

  ///Handlers for current user posts
  void addOldPostsToCurrentUserPosts(List<SkibblePost> newPosts) {
    currentUserPosts.addAll(newPosts);
    notifyListeners();
  }

  void initialiseCurrentUserPosts(List<SkibblePost> newPosts) {
    currentUserPosts = newPosts;
    notifyListeners();
  }

  void addNewPostsToUserPosts(SkibblePost newPost) {
    currentUserPosts.insert(0, newPost);
    notifyListeners();
  }

  void deleteCurrentUserSkibPost(SkibblePost post) {
    currentUserPosts.removeWhere((element) => element.postId == post.postId);
    notifyListeners();
  }

  void updatePostInCurrentUserPosts(SkibblePost post) {
    var foundPostIndex = currentUserPosts.indexWhere((element) => element.postId == post.postId);

    if(foundPostIndex != -1) {
      currentUserPosts[foundPostIndex] = post;
      notifyListeners();
    }

  }

  void deleteRecipeFromCurrentUserRecipes(Recipe recipe) {
    currentUserRecipes.removeWhere((element) => element.recipeId == recipe.recipeId);
    notifyListeners();
  }


  ///Handlers for current user posts
  void addOldRecipesToCurrentUserRecipes(List<Recipe> newRecipes) {
    currentUserRecipes.addAll(newRecipes);
    notifyListeners();
  }

  void initialiseCurrentUserRecipes(List<Recipe> newRecipes) {
    currentUserRecipes = newRecipes;
    notifyListeners();
  }

  void addNewRecipeToCurrentUserRecipes(Recipe recipe) {
    currentUserRecipes.insert(0, recipe);
    notifyListeners();
  }

  void updateRecipeInCurrentUserRecipes(Recipe recipe) {
    var foundRecipeIndex = currentUserRecipes.indexWhere((element) => element.recipeId == recipe.recipeId);

    if(foundRecipeIndex != -1) {

      currentUserRecipes[foundRecipeIndex] = recipe;
      notifyListeners();
    }
  }

  bool likePostInUserPosts(SkibblePost newPost, String userId) {
    try {
      var foundPost = userFeed.where((element) => element.feedPostType == FeedPostType.skib).where((post) => post.post!.postId == newPost.postId).first;
      if(!foundPost.post!.likesList!.contains(userId)) {
        foundPost.post!.likesList!.add(userId);
        foundPost.post!.totalLikes += 1;
        notifyListeners();
      }

      return true;

    }
    catch(e) {
      return false;
    }
  }

  bool dislikePostInUserPosts(SkibblePost newPost, String userId) {
    try {
      var foundPost = userFeed.where((element) => element.feedPostType == FeedPostType.skib).where((post) => post.post!.postId == newPost.postId).first;
      if(foundPost.post!.likesList!.contains(userId)) {
        foundPost.post!.likesList!.remove(userId);
        foundPost.post!.totalLikes -= 1;
        notifyListeners();
      }
      return true;
    }
    catch(e) {
      return false;
    }
  }

  void commentOnPostInUserPosts(SkibblePost newPost, SkibblePostComment comment) {
    try {
      var foundPost = userFeed.where((element) => element.feedPostType == FeedPostType.skib).where((post) => post.post!.postId == newPost.postId).first;
      // foundPost.post!.commentsList!.add(comment);
      foundPost.post!.totalComments += 1;
      notifyListeners();
    } catch(e){}
  }


  void commentOnRecipeInUserRecipes(Recipe newRecipe, ChatMessage comment) {
   try {
     var foundRecipe = userFeed.where((element) => element.feedPostType == FeedPostType.recipe).where((recipe) => recipe.recipe!.recipeId == newRecipe.recipeId).first;
     // foundRecipe.recipe!.commentsList!.add(comment);
     foundRecipe.recipe!.totalComments += 1;
     notifyListeners();
   }
   catch(e) {

   }
  }

  bool getIfUserLikedRecipe(Recipe newRecipe, String userId) {
    var foundRecipe = userFeed.where((element) => element.feedPostType == FeedPostType.recipe).where((recipe) => recipe.recipe!.recipeId == newRecipe.recipeId).first;
    return foundRecipe.recipe!.likesList!.contains(userId);
  }

  ///handle likes/dislike recipes in user feed
  void likeRecipeInUserFeedRecipes(Recipe newRecipe, String userId) {
    try {
      var foundRecipeList = userFeed.where((element) => element.feedPostType == FeedPostType.recipe).where((recipe) => recipe.recipe!.recipeId == newRecipe.recipeId);

      if(foundRecipeList.isNotEmpty) {
        if(!foundRecipeList.first.recipe!.likesList!.contains(userId)) {
          foundRecipeList.first.recipe!.likesList!.add(userId);
          foundRecipeList.first.recipe!.totalLikes += 1;
          notifyListeners();
        }
      }

    } catch(e) {}
  }
  void dislikeRecipeInUserFeedRecipes(Recipe newRecipe, String userId) {
    try {
      var foundRecipeList = userFeed.where((element) => element.feedPostType == FeedPostType.recipe).where((recipe) => recipe.recipe!.recipeId == newRecipe.recipeId);
      if(foundRecipeList.isNotEmpty) {
        // print('kk');
        if(foundRecipeList.first.recipe!.likesList!.contains(userId)) {
          foundRecipeList.first.recipe!.likesList!.remove(userId);
          foundRecipeList.first.recipe!.totalLikes -= 1;
          notifyListeners();
        }
      }
    }
    catch (e) {}
  }

  ///handle likes/dislike recipes in current user explore page
  bool likeRecipeInUserExploreFeed(Recipe recipe, String userId) {
    try {
      var foundRecipeList = exploreFeed.exploreData!.where((element) => element.feedPostType == FeedPostType.recipe).where((element) => element.recipe!.recipeId! == recipe.recipeId);
      if(foundRecipeList.isNotEmpty) {
        if(!foundRecipeList.first.recipe!.likesList!.contains(userId)) {
          foundRecipeList.first.recipe!.likesList!.add(userId);
          foundRecipeList.first.recipe!.totalLikes += 1;
          notifyListeners();
        }

      }
      return true;
    } catch(e) {
      return false;
    }
  }
  bool dislikeRecipeInUserExploreFeed(Recipe recipe, String userId) {
    try {
      var foundRecipeList = exploreFeed.exploreData!.where((element) => element.feedPostType == FeedPostType.recipe).where((element) => element.recipe!.recipeId == recipe.recipeId);

      if(foundRecipeList.isNotEmpty) {
        if(foundRecipeList.first.recipe!.likesList!.contains(userId)) {
          foundRecipeList.first.recipe!.likesList!.remove(userId);
          foundRecipeList.first.recipe!.totalLikes -= 1;
          notifyListeners();
        }
      }

      return true;
    } catch(e) { return false;}
  }


  ///handle likes/dislike recipes in current user explore page
  bool likeRecipeInCurrentUserRecipes(Recipe recipe, String userId) {
    try {
      var foundRecipeList = currentUserRecipes.where((element) => element.recipeId! == recipe.recipeId);
      if(foundRecipeList.isNotEmpty) {
        if(!foundRecipeList.first.likesList!.contains(userId)) {
          foundRecipeList.first.likesList!.add(userId);
          foundRecipeList.first.totalLikes += 1;
          notifyListeners();
        }
      }
      return true;
    } catch(e) {
      return false;
    }
  }
  bool dislikeRecipeInCurrentUserRecipes(Recipe recipe, String userId) {
    try {
      var foundRecipeList = currentUserRecipes.where((element) => element.recipeId == recipe.recipeId);

      if(foundRecipeList.isNotEmpty) {
        if(foundRecipeList.first.likesList!.contains(userId)) {
          foundRecipeList.first.likesList!.remove(userId);
          foundRecipeList.first.totalLikes -= 1;
          notifyListeners();
        }
      }

      return true;
    } catch(e) { return false;}
  }



  ///handle likes/dislike skibs in current user explore page
  bool likeSkibInUserExploreFeed(SkibblePost post, String userId) {
    try {
      var foundPostList = exploreFeed.exploreData!.where((element) => element.feedPostType == FeedPostType.skib).where((element) => element.post!.postId! == post.postId);
      if(foundPostList.isNotEmpty) {
        if(!foundPostList.first.post!.likesList!.contains(userId)) {
          foundPostList.first.post!.likesList!.add(userId);
          foundPostList.first.post!.totalLikes += 1;
          notifyListeners();
        }

      }
      return true;
    } catch(e) {
      return false;
    }
  }
  bool dislikeSkibInUserExploreFeed(SkibblePost post, String userId) {
    try {
      var foundPostList = exploreFeed.exploreData!.where((element) => element.feedPostType == FeedPostType.skib).where((element) => element.post!.postId == post.postId);
      if(foundPostList.isNotEmpty) {
        if(foundPostList.first.post!.likesList!.contains(userId)) {
          foundPostList.first.post!.likesList!.remove(userId);
          foundPostList.first.post!.totalLikes -= 1;
          notifyListeners();
        }

      }

      return true;
    } catch(e) {
      return false;
    }
  }


  ///current user feed likes and dislike
  bool likeSkibInUserFeed(SkibblePost post, String userId) {
    try {
      var foundPostList = userFeed.where((element) => element.feedPostType == FeedPostType.skib).where((element) => element.post!.postId! == post.postId);
      if(foundPostList.isNotEmpty) {
        if(!foundPostList.first.post!.likesList!.contains(userId)) {
          // print('kkk');
          foundPostList.first.post!.likesList!.add(userId);
          foundPostList.first.post!.totalLikes += 1;
          notifyListeners();
        }

      }
      return true;
    } catch(e) {
      return false;
    }
  }


  bool dislikeSkibInUserFeed(SkibblePost post, String userId) {
    try {
      var foundPostList = userFeed.where((element) => element.feedPostType == FeedPostType.skib).where((element) => element.post!.postId == post.postId);
      if(foundPostList.isNotEmpty) {
        if(foundPostList.first.post!.likesList!.contains(userId)) {
          foundPostList.first.post!.likesList!.remove(userId);
          // print('lololo');
          foundPostList.first.post!.totalLikes -= 1;
          notifyListeners();
        }
      }

      return true;
    } catch(e) {
      return false;
    }
  }

  ///current user posts likes and dislike
  bool likeSkibInCurrentUserPosts(SkibblePost post, String userId) {
    try {
      var foundPostList = currentUserPosts.where((element) => element.postId! == post.postId);

      if(foundPostList.isNotEmpty) {
        if(!foundPostList.first.likesList!.contains(userId)) {
          foundPostList.first.likesList!.add(userId);
          foundPostList.first.totalLikes += 1;
          notifyListeners();
        }

      }
      return true;
    } catch(e) {
      return false;
    }
  }
  bool dislikeSkibInCurrentUserPosts(SkibblePost post, String userId) {
    try {
      var foundPostList = currentUserPosts.where((element) => element.postId! == post.postId);
      if(foundPostList.isNotEmpty) {

        if(foundPostList.first.likesList!.contains(userId)) {

          foundPostList.first.likesList!.remove(userId);
          foundPostList.first.totalLikes -= 1;
          notifyListeners();
        }
      }

      return true;
    } catch(e) {
      return false;}
  }


  void addLikesToPost(String postId, Map<String,List<String>> likesMap) {
    try {
      //current User Post

      var foundPostListInCurrentUserPosts = currentUserPosts.where((element) => element.postId! == postId);
      if(foundPostListInCurrentUserPosts.isNotEmpty) {

        foundPostListInCurrentUserPosts.first.likesDocMap = likesMap;
        likesMap.values.forEach((list) {foundPostListInCurrentUserPosts.first.likesList!.addAll(list.toSet()); });

      }


      //user feed
      var foundPostListInUserFeed = userFeed.where((element) => element.feedPostType == FeedPostType.skib).where((element) => element.post!.postId! == postId);
      if(foundPostListInUserFeed.isNotEmpty) {
        foundPostListInUserFeed.first.post!.likesDocMap = likesMap;
        likesMap.values.forEach((list) {foundPostListInUserFeed.first.post!.likesList!.addAll(list.toSet()); });

      }


      //explore feed
      var foundPostListInExploreFeed = exploreFeed.exploreData!.where((element) => element.feedPostType == FeedPostType.skib).where((element) => element.post!.postId! == postId);
      if(foundPostListInExploreFeed.isNotEmpty) {
        foundPostListInExploreFeed.first.post!.likesDocMap = likesMap;
        likesMap.values.forEach((list) {foundPostListInExploreFeed.first.post!.likesList!.addAll(list.toSet()); });


      }

      notifyListeners();
    }
    catch(e) {

    }
  }

}