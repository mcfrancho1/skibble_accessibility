// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:skibble/controllers/custom_search_controller.dart';
// import 'package:skibble/controllers/feed_controller.dart';
// import 'package:skibble/controllers/photo_view_controller.dart';
// import 'package:skibble/models/skibble_user.dart';
// import 'package:skibble/models/stream_models/followers_stream.dart';
// import 'package:skibble/models/stream_models/liked_community_messages.dart';
// import 'package:skibble/models/stream_models/liked_community_messages_replies_stream.dart';
// import 'package:skibble/models/stream_models/liked_recipes_stream.dart';
// import 'package:skibble/models/stream_models/liked_skibs_stream.dart';
// import 'package:skibble/models/stream_models/member_communities.dart';
// import 'package:skibble/models/stream_models/users_i_blocked_stream.dart';
// import 'package:skibble/models/stream_models/users_who_blocked_me_stream.dart';
// import 'package:skibble/providers/app_localization_provider.dart';
// import 'package:skibble/services/change_data_notifiers/kitchens_data/kitchen_data.dart';
// import 'package:skibble/services/change_data_notifiers/skibs_data.dart';
// import 'package:skibble/services/change_data_notifiers/users_data.dart';
// import 'package:skibble/services/firebase/auth_services/skibble_auth_service.dart';
// import 'package:skibble/services/firebase/database/community_database.dart';
// import 'package:skibble/services/firebase/database/feed_database.dart';
// import 'package:skibble/services/firebase/database/recipe_database.dart';
// import 'package:skibble/src/features/authentication/controllers/auth_provider.dart';
// import 'package:skibble/features/meets/controllers/meets_loading_controller.dart';
//
// import '../../../../controllers/chat_controller.dart';
// import '../../../../controllers/chat_controllers/audio_recorder_controller.dart';
// import '../../../../controllers/chat_controllers/voice_message_controller.dart';
// import '../../../../main.dart';
// import '../../../../features/communities/controllers/community_controller.dart';
// import '../../../../controllers/file_controller.dart';
// import '../../../../controllers/loading_controller.dart';
// import '../../../../controllers/recipe_controller.dart';
// import '../../../../controllers/skib_controller.dart';
// import '../../../../controllers/skib_data_controller.dart';
// import '../../../../models/notification_model/notification.dart';
// import '../../../../models/stream_models/followings_stream.dart';
// import '../../../../services/change_data_notifiers/app_data.dart';
// import '../../../../services/change_data_notifiers/cart_data.dart';
// import '../../../../services/change_data_notifiers/chat_data.dart';
// import '../../../../services/change_data_notifiers/feed_data.dart';
// import '../../../../services/change_data_notifiers/firebase_data.dart';
// import '../../../../services/change_data_notifiers/food_spots_data/meal_invite.dart';
// import '../../../../services/change_data_notifiers/food_spots_data/spots_data.dart';
// import '../../../../services/change_data_notifiers/map_data/gmap_connect_data.dart';
// import '../../../../services/change_data_notifiers/map_data/mapbox_connect_data.dart';
// import '../../../../services/change_data_notifiers/picker_data/date_time_picker_data.dart';
// import '../../../../services/change_data_notifiers/picker_data/food_options_picker_data.dart';
// import '../../../../services/change_data_notifiers/picker_data/location_picker_data.dart';
// import '../../../../services/change_data_notifiers/picker_data/privacy_picker_data.dart';
// import '../../../../services/firebase/database/friend_requests_database.dart';
// import '../../../../services/firebase/database/notification_database.dart';
// import '../../../../services/firebase/database/user_database.dart';
// import '../../../../features/communities/controllers/community_loading_controller.dart';
// import '../../../../features/identity_verification/controllers/step_controller.dart';
// import '../../../../features/identity_verification/controllers/verification_controller.dart';
// import '../../../../features/meets/controllers/create_edit_meets_controller.dart';
// import '../../../../features/meets/controllers/meets_bills_controller.dart';
// import '../../../../features/meets/controllers/meets_controller.dart';
// import '../../../../features/meets/controllers/meets_date_time_controller.dart';
// import '../../../../features/meets/controllers/meets_filter_controller.dart';
// import '../../../../features/meets/controllers/meets_location_controller.dart';
// import '../../../../features/meets/controllers/meets_navigation_controller.dart';
// import '../../../../features/meets/controllers/meets_privacy_controller.dart';
// import '../../../../features/new_chat/controllers/stream_chat_service.dart';
// import '../../../../features/notifications/controllers/notifications_controller.dart';
// import '../../../../features/profile/controllers/profile_controller.dart';
//
// class SkibbleMultiProviderWrapper extends StatelessWidget {
//   const SkibbleMultiProviderWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         providers: [
//             // // Provider<AppleSignInAvailable>.value(value: appleSignInAvailable),
//             // Provider<SkibbleAuthService>(
//             //     create: (_) => AuthServiceAdapter(initialAuthServiceType: AuthServiceType.firebase),
//             //     dispose: (_, SkibbleAuthService authService) => authService.dispose()
//             // ),
//             // Provider<EmailSecureStore>(
//             //   create: (_) => EmailSecureStore(
//             //     flutterSecureStorage: FlutterSecureStorage(),
//             //   ),
//             // ),
//             // ProxyProvider2<SkibbleAuthService, EmailSecureStore, FirebaseEmailLinkHandler>(
//             //   update: (_, SkibbleAuthService authService, EmailSecureStore storage, __) =>
//             //   FirebaseEmailLinkHandler(
//             //     auth: authService,
//             //     emailStore: storage,
//             //     firebaseDynamicLinks: FirebaseDynamicLinks.instance,
//             //   )..init(),
//             //   dispose: (_, linkHandler) => linkHandler.dispose(),
//             // ),
//             // // ChangeNotifierProvider(create: (context) => AppData(),),
//
//             // Provider<SkibbleUser>.value(value: user),
//             ChangeNotifierProvider(create: (context) => AuthProvider(authService),),
//             ChangeNotifierProvider(create: (context) => SkibsData(),),
//             ChangeNotifierProvider(create: (context) => UsersDataController(),),
//             ChangeNotifierProvider(create: (context) => FeedController(ScrollController()),),
//             ChangeNotifierProvider( create: (context) => SkibController(),),
//             // ChangeNotifierProvider( create: (context) => StreamChatController()..initStreamChatClient(),),
//             ChangeNotifierProvider( create: (context) => RecipeController(),),
//             ChangeNotifierProvider(create: (context) => LocaleNotifier(),),
//             ChangeNotifierProvider(create: (context) => CartData(),),
//             ChangeNotifierProvider(create: (context) => FeedData(),),
//             ChangeNotifierProvider(create: (context) => KitchensData(),),
//             ChangeNotifierProvider(create: (context) => CommunityController(),),
//             ChangeNotifierProvider(create: (context) => CustomSearchController(),),
//             ChangeNotifierProvider(create: (context) => ChatController(),),
//             ChangeNotifierProvider(create: (context) => AudioRecorderController(),),
//             ChangeNotifierProvider(create: (context) => ProfileController(),),
//             ChangeNotifierProvider(create: (context) => VerificationStepController(),),
//
//             ChangeNotifierProvider(
//               create: (context) => VoiceMessageController(),
//             ),
//
//             // ChangeNotifierProvider(create: (context) => MapboxConnectData(),),
//             ChangeNotifierProvider<FilePickerController>(create: (context) => FilePickerController(),),
//             ChangeNotifierProvider<LoadingController>(create: (context) => LoadingController(),),
//             ChangeNotifierProvider(create: (context) => MeetsFilterController(),),
//             ChangeNotifierProvider(create: (context) => MeetsNavigationController(),),
//
//             ChangeNotifierProvider<MeetsLoadingController>(create: (context) => MeetsLoadingController(),),
//             ChangeNotifierProvider<PhotoViewController>(create: (context) => PhotoViewController(),),
//
//             ChangeNotifierProvider<CommunityLoadingController>(create: (context) => CommunityLoadingController(),),
//
//
//             ChangeNotifierProvider(create: (context) => GMapConnectData(),),
//             ChangeNotifierProvider(create: (context) => SpotsData(),),
//             ChangeNotifierProvider(create: (context) => MealInviteData(),),
//             ChangeNotifierProvider(create: (context) => LocationPickerData(),),
//             ChangeNotifierProvider(create: (context) => DateTimePickerData(),),
//             ChangeNotifierProvider(create: (context) => PrivacyPickerData(),),
//             ChangeNotifierProvider(create: (context) => FoodOptionsPickerData(),),
//             // ChangeNotifierProvider(create: (context) => CustomFeedData(),),
//             ChangeNotifierProvider(create: (context) => ChatData(),),
//             ChangeNotifierProvider(create: (context) => FirebaseData(),),
//
//
//             //Skibble Meets
//             ChangeNotifierProvider<CreateEditMeetsController>(
//               create:(context) => CreateEditMeetsController(),
//             ),
//             ChangeNotifierProvider<MeetsDateTimeController>(
//               create:(context) => MeetsDateTimeController(),
//             ),
//             ChangeNotifierProvider<MeetsLocationController>(
//               create:(context) => MeetsLocationController(),
//             ),
//
//             ChangeNotifierProvider<MeetsPrivacyController>(
//               create:(context) => MeetsPrivacyController(),
//             ),
//             ChangeNotifierProvider<MeetsBillsController>(
//               create:(context) => MeetsBillsController(),
//             ),
//
//
//             if(user?.userId != null)
//               ChangeNotifierProvider<MeetsController>(create: (context) => MeetsController()..listenForNearbyMeets(context, user!),),
//
//             //streaming followers
//             if(user?.userId != null)
//               StreamProvider<FollowersStream?>.value(
//                 initialData: FollowersStream([]),
//                 value: FriendRequestsDatabaseService().streamFollowersData(user!.userId!, context: context),),
//
//             //streaming followings
//             if(user?.userId != null)
//               StreamProvider<FollowingsStream?>.value(
//                 initialData: FollowingsStream([]),
//                 value: FriendRequestsDatabaseService().streamFollowingsData(user!.userId!),
//               ),
//
//             //streaming users who blocked me
//             if(user?.userId != null)
//               StreamProvider<UsersWhoBlockedMeStream?>.value(
//                 initialData: UsersWhoBlockedMeStream([]),
//                 value: UserDatabaseService().streamUsersWhoBlockedMe(user!.userId!, context),),
//
//             //users I blocked
//             if(user?.userId != null)
//               StreamProvider<UsersIBlockedStream?>.value(
//                 initialData: UsersIBlockedStream([]),
//                 value: UserDatabaseService().streamUsersIBlocked(user!.userId!, context),),
//
//
//             if(user?.userId != null)
//               StreamProvider<LikedSkibsStream?>.value(
//                 initialData: LikedSkibsStream([]),
//                 value: FeedDatabaseService().streamLikedSkibsData(user!.userId!),),
//
//             if(user?.userId != null)
//               StreamProvider<MemberCommunitiesStream?>.value(
//                 initialData: MemberCommunitiesStream([]),
//                 lazy: false,
//                 value: CommunityDatabase().streamMemberCommunitiesData(user!.userId!),
//               ),
//
//             if(user?.userId != null)
//               StreamProvider<LikedCommunityMessagesStream?>.value(
//                 initialData: LikedCommunityMessagesStream([]),
//                 lazy: false,
//                 value: CommunityDatabase().streamLikedCommunityMessagesData(user!.userId!),
//               ),
//
//             if(user?.userId != null)
//               StreamProvider<LikedCommunityMessagesRepliesStream?>.value(
//                 initialData: LikedCommunityMessagesRepliesStream([]),
//                 lazy: false,
//                 value: CommunityDatabase().streamLikedCommunityMessagesRepliesData(user!.userId!),
//               ),
//
//             if(user?.userId != null)
//               StreamProvider<LikedRecipesStream?>.value(
//                 initialData: LikedRecipesStream([]),
//                 value: RecipeDatabaseService().streamLikedRecipesStream(user!.userId!),
//
//               ),
//
//
//             if(user?.userId != null)
//               StreamProvider<List<CustomNotification>>.value(
//                 initialData: [],
//                 value: NotificationsDatabaseService().userNotificationsStream(user!.userId!, context),
//               ),
//             // NOTE: Any other user-bound providers here can be added here
//
//           ],
//
//     );
//   }
// }
