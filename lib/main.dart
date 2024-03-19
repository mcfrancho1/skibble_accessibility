import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:skibble_accessibility/services/change_data_notifiers/app_data.dart';
import 'package:skibble_accessibility/services/preferences/preferences.dart';
import 'package:skibble_accessibility/skibble_app.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'main_env/main_common.dart';



/// To verify that your messages are being received, you ought to see a notification appear on your device/emulator via the flutter_local_notifications plugin.
/// Define a top-level named handler which background/terminated messages will
/// call. Be sure to annotate the handler with `@pragma('vm:entry-point')` above the function declaration.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  await Preferences.init();
  var userId = await Preferences.getInstance().getCurrentUserIdKey();
  // await setupFlutterNotifications();
  showFlutterNotification(message, userId!);

  // final chatClient = await StreamChatController().initStreamChat( SkibbleUser(userId: userId)).then((value) => StreamChatController().streamChatClient);


  // handleNotification(message, chatClient);
  // debugPrint('Handling a background message ${message.messageId} - $id');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
// late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;


void showFlutterNotification(RemoteMessage message, String currentUserId) {
  // RemoteNotification? notification = message.notification;
  // AndroidNotification? android = message.notification?.android;
  //
  // print(notification);
  // NotificationController.processNotifications(message, currentUserId, isAppInBackground: true);
}




/// Initialize the [FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// GetIt locator = GetIt.instance;
// final AppLo i10n = locator<I10n>();
//
// void setupLocator() {
//   locator.registerLazySingleton(() => I10n());
// }

void main() async{
  await setupInitializations();

  // setUpServiceLocator();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  //     statusBarColor: Colors.white, // Color for Android
  //     statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
  // ));

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.grey[200],
  //   systemNavigationBarIconBrightness: Brightness.dark,
  //   systemNavigationBarDividerColor: Colors.black,
  // ));
  runApp(
      ChangeNotifierProvider(
          create: (context) => AppData(),
          child: const NewSkibbleApp()
      )
  );
}