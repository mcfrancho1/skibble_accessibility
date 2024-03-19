import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/firebase/database/notification_database.dart';
import 'package:skibble/services/preferences/preferences.dart';
import 'package:skibble/shared/custom_app_bar.dart';
import 'package:skibble/shared/option_switch.dart';

import '../../localization/app_translation.dart';
import '../../services/change_data_notifiers/app_data.dart';

class NotificationsSettingsView extends StatefulWidget {
  const NotificationsSettingsView({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsView> createState() => _NotificationsSettingsViewState();
}

class _NotificationsSettingsViewState extends State<NotificationsSettingsView> {

  late final Preferences preferences;

  @override
  initState() {
    preferences = Preferences.getInstance();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.notifications,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            OptionSwitch(
              title: 'Messages',
              subtitle: 'Receive notifications for new messages.',
              icon: Iconsax.message,
              id: "chats_notification_mode",
              defaultBool: preferences.getChatNotificationKey(defaultValue: true)!,
              onSwitched: (value) async {
                await preferences.setChatNotificationKey(value);
                await NotificationsDatabaseService().setUserNotificationSetting(currentUser.userId!, 'isChatMessageEnabled', value);
                setState(() {});
              },
            ),

            //TODO: Activate this later
            // OptionSwitch(
            //   title: 'Community Messages',
            //   subtitle: 'Receive notifications for new messages from communities you joined.',
            //   icon: Iconsax.people,
            //   id: "community_messages_notification_mode",
            //   defaultBool: preferences.getCommunityMessagesNotificationKey(defaultValue: false)!,
            //   onSwitched: (value) async {
            //     await preferences.setCommunityMessagesNotificationKey(value);
            //     await NotificationsDatabaseService().setUserNotificationSetting(currentUser.userId!, 'isCommunityMessageEnabled', value);
            //
            //     setState(() {});
            //   },
            // ),


            OptionSwitch(
              title: 'New followers',
              subtitle: 'Receive notifications for new followers.',
              icon: Iconsax.user,
              id: "followers_notification_mode",
              defaultBool: preferences.getFollowersNotificationKey(defaultValue: true)!,
              onSwitched: (value) async {
                await preferences.setFollowersNotificationKey(value);
                await NotificationsDatabaseService().setUserNotificationSetting(currentUser.userId!, 'isFollowRequestEnabled', value);

                setState(() {});
              },
            ),


            // currentUser.isASkibbleRegisteredChef ? OptionSwitch(
            //   title: 'Booking Requests',
            //   subtitle: 'Receive notifications for new messages from communities you joined.',
            //   icon: Iconsax.people,
            //   id: "community_messages_notification_mode",
            //   defaultBool: preferences.getCommunityMessagesNotificationKey(defaultValue: false)!,
            //   onSwitched: (value) async {
            //     await preferences.setCommunityMessagesNotificationKey(value);
            //     await NotificationsDatabaseService().setUserNotificationSetting(currentUser.userId!, 'isCommunityMessageEnabled', value);
            //
            //     setState(() {});
            //   },
            // ),


            // OptionSwitch(
            //   title: 'Recipes',
            //   subtitle: 'Receive notifications for new recipes created by your friends.',
            //   icon: Iconsax.book_1,
            //   id: "recipes_notification_mode",
            //   defaultBool: preferences.getRecipesNotificationKey(defaultValue: false)!,
            //   onSwitched: (value) async {
            //     await preferences.setRecipesNotificationKey(value);
            //     await NotificationsDatabaseService().setUserNotificationSetting(currentUser.userId!, 'isRecipeEnabled', value);
            //
            //     setState(() {});
            //   },
            // ),

            // OptionSwitch(
            //   title: 'Skibs',
            //   subtitle: 'Receive notifications for new skibs posted by your friends.',
            //   icon: Iconsax.reserve,
            //   id: "skibs_notification_mode",
            //   defaultBool: preferences.getSkibsNotificationKey(defaultValue: false)!,
            //   onSwitched: (value) async {
            //     await preferences.setSkibsNotificationKey(value);
            //     await NotificationsDatabaseService().setUserNotificationSetting(currentUser.userId!, 'isSkibsEnabled', value);
            //
            //     setState(() {
            //       currentUser.userNotificationSettings!.isSkibsEnabled = value;
            //     });
            //   },
            // ),

            // OptionSwitch(
            //   title: 'Stories',
            //   subtitle: 'Receive notifications for new stories from your friends.',
            //   icon: Iconsax.story,
            //   id: "stories_notification_mode",
            //   defaultBool: preferences.getStoriesNotificationKey(defaultValue: false)!,
            //   onSwitched: (value) async {
            //     await preferences.setStoriesNotificationKey(value);
            //     await NotificationsDatabaseService().setUserNotificationSetting(currentUser.userId!, 'isStoriesEnabled', value);
            //
            //     setState(() {});
            //   },
            // ),

          ],
        ),
      ),
    );
  }
}
