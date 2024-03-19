import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollectionReferences {

  static CollectionReference get usersCollection => FirebaseFirestore.instance.collection('Users');
  //old
  static CollectionReference get chatsCollection => FirebaseFirestore.instance.collection('Chats');

  //new
  static CollectionReference get conversationsCollection => FirebaseFirestore.instance.collection('Conversations');

  static CollectionReference get postsCollection => FirebaseFirestore.instance.collection('Posts');

  static CollectionReference get foodTagsCollection => FirebaseFirestore.instance.collection('FoodTags');
  static CollectionReference get restaurantsCollection => FirebaseFirestore.instance.collection('Restaurants');
  static CollectionReference get liveStreamsCollection => FirebaseFirestore.instance.collection('LiveStreams');
  static CollectionReference get momentsCollection => FirebaseFirestore.instance.collection('Moments');
  static CollectionReference get recipesCollection => FirebaseFirestore.instance.collection('Recipes');
  static CollectionReference get communitiesCollection => FirebaseFirestore.instance.collection('Communities');
  static CollectionReference get featureRequestsCollection => FirebaseFirestore.instance.collection('FeatureRequests');
  static CollectionReference get suggestionsCollection => FirebaseFirestore.instance.collection('Suggestions');
  static CollectionReference get helpRequestsCollection => FirebaseFirestore.instance.collection('HelpRequests');
  static CollectionReference get feedbackCollection => FirebaseFirestore.instance.collection('Feedback');
  static CollectionReference get customerSupportCollection => FirebaseFirestore.instance.collection('CustomerSupport');

  static CollectionReference get discoveredProblemCollection => FirebaseFirestore.instance.collection('DiscoveredProblems');
  static CollectionReference get privacyQuestionsCollection => FirebaseFirestore.instance.collection('PrivacyQuestions');
  static CollectionReference get flaggedPostsCollection => FirebaseFirestore.instance.collection('FlaggedPosts');
  static CollectionReference get flaggedCommunitiesCollection => FirebaseFirestore.instance.collection('FlaggedCommunities');
  static CollectionReference get reportedUsersCollection => FirebaseFirestore.instance.collection('ReportedUsers');
  static CollectionReference get foodSpotsCollection => FirebaseFirestore.instance.collection('FoodSpots');
  static CollectionReference get meetsCollection => FirebaseFirestore.instance.collection('Meets');
  static CollectionReference get meetsImagesCollection => FirebaseFirestore.instance.collection('MeetsImages');
  static CollectionReference get integrationsCollection => FirebaseFirestore.instance.collection('Integrations');
  static CollectionReference get pollsCollection => FirebaseFirestore.instance.collection('Polls');



  static CollectionReference get ChefServicesWaitListUsersCollection => FirebaseFirestore.instance.collection('ChefServicesWaitListUsers');

  static CollectionReference get skibbleRegionsMetaDataCollection => FirebaseFirestore.instance.collection('SkibbleRegionsMetaData');

  static CollectionReference get placesCollection => FirebaseFirestore.instance.collection('Places');



  //firestore subcollections
  static const String FollowingsSubCollectionName = 'followings';
  static const String FollowersSubCollectionName = 'followers';
  static const String notificationSubCollection = 'notifications';
  static const String FriendsSubCollectionName = 'friends';
  static const String momentViewsSubCollection = 'moment_views';
  static const String likesSubCollection = 'likes';
  static const String commentsSubCollection = 'comments';
  static const String ratingsReviewsSubCollection = 'ratings_reviews';
  static const String menuItemsSubCollection = 'menu_items';
  static const String menuSubCollection = 'menus';
  static const String shoppingListSubCollection = 'shopping_lists';
  static const String wishlistSubCollection = 'wishlist';
  static const String savedSubCollection = 'saved';

  static const String bookingDaysSubCollection = 'booking_days';
  static const String bookingsSubCollection = 'bookings';
  static const String blockedUsersSubCollection = 'blocked_users';
  static const String usersWhoBlockedMeSubCollection = 'blocked_by';
  static const String transactionsSubCollection = 'transactions';
  static const String conversationsSubCollection = 'conversations';
  static const String interestedUsersSubCollection = 'interested_users';
  static const String invitedUsersSubCollection = 'invited_users';


  //attending users are users who have clicked on the start meet button
  static const String ongoingMeetUsersSubCollection = 'ongoing_meet_users';

  //canceled meet users are users who have canceled the meet
  static const String canceledMeetUsersSubCollection = 'canceled_meet_users';

  //completed meet users are users who have been confirmed to completed the meet
  static const String completedMeetUsersSubCollection = 'completed_meet_users';


  static const String meetPalsSubCollection = 'meet_pals';
  static const String meetCircleSubCollection = 'meet_circle';
  static const String conversationMessagesSubCollection = 'conversation_messages';



  //
  // static const String interestedMeetsSubCollection = 'interested_meets';
  // static const String invitedMeetsSubCollection = 'invited_meets';
  // static const String completedMeetsSubCollection = 'completed_meets';

  static const String interestedSpotsSubCollection = 'interested_spots';


  /**
   * Fan outs
   */
  //used to keep track of where the data was duplicated
  static const String userFanOutCollection = 'users_fan_out';
  static const String postFanOutCollection = 'posts_fan_out';
  static const String recipesFanOutCollection = 'recipes_fan_out';
  static const String foodSpotsFanOutCollection = 'food_spots_fan_out';


  static const String communityMessagesSubCollection = 'community_messages';
  static const String communityMessageRepliesSubCollection = 'community_message_replies';

  static const String communityMessagesViewsSubCollection = 'community_messages_views';


  static const String likedSkibsSubCollection = 'liked_skibs';
  static const String likedRecipesSubCollection = 'liked_recipes';
  static const String userFeedSubCollection = 'user_feed';

  /// User Feed
  /// This is used as a subcollection to populate the feed for the users
  static const String postsFeedSubCollection = 'posts_feed';
  static const String recipesFeedSubCollection = 'recipes_feed';
  static const String chefsFeedSubCollection = 'chefs_feed';
  static const String kitchensFeedSubCollection = 'kitchens_feed';
  static const String communitiesFeedSubCollection = 'communities_feed';
  static const String allFriendsRecommendationsSubCollectionName = 'friend_recommendations_all';
  static const String friendPlaceRecommendationsSubCollectionName = 'friend_recommendations_location';
  static const String friendInterestRecommendationsSubCollectionName = 'friend_recommendations_interests';


/**
 * New Subcollections with data
 */

  static const String followingsDataSubCollectionName = 'followings_data';
  static const String followersDataSubCollectionName = 'followers_data';
  static const String likedSkibsDataSubCollection = 'liked_skibs_data';
  static const String likedCommunityMessagesDataSubCollection = 'liked_community_messages_data';
  static const String likedCommunityMessageRepliesDataSubCollection = 'liked_community_message_replies_data';


  static const String commentedSkibsDataDataSubCollection = 'commented_skibs_data';

  static const String blockedByDataSubCollectionName = 'blocked_by_data';
  static const String blockedUsersDataSubCollection = 'blocked_users_data';
  static const String notificationDataSubCollection = 'notifications_data';
  static const String friendsDataSubCollectionName = 'friends';
  static const String momentViewsDataSubCollection = 'moment_views';
  static const String likesDataSubCollection = 'likes_data';
  static const String commentsDataSubCollection = 'comments_data';
  // static const String membersDataSubCollection = 'members_data';


  //communities subcollection
  static const String communityMembersSubCollection = 'community_members';
  // static const String memberCommunitiesDataSubCollection = 'member_communities_data';
  static const String memberCommunitiesSubCollection = 'member_communities';

  //community channels
  static const String memberCommunitiesChannelsSubCollection = 'member_communities_channels';
  static const String communityChannelsSubCollection = 'community_channels';
  static const String communityChannelMembersSubCollection = 'community_channel_members';
  static const String communityChannelMessagesSubCollection = 'community_channel_messages';



  //meets subcollection
  static const String upcomingMeetsSubCollectionName = 'upcoming_meets';
  static const String ongoingMeetsSubCollection = 'ongoing_meets';
  static const String pendingMeetsSubCollection = 'pending_meets';
  static const String nearbyMeetsSubCollection = 'nearby_meets';

  static const String createdMeetsSubCollection = 'created_meets';
  static const String canceledMeetSubCollection = 'canceled_meets';
  static const String completedMeetsSubCollection = 'completed_meets';


  //polls subcollection
  static const String pollVotesSubCollection = 'poll_votes';

  // static const String interestedMeetsSubCollection = 'interested_meets';
  // static const String invitedMeetsSubCollection = 'invited_meets';
}