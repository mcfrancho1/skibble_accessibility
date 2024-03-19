// import 'package:fluro/fluro.dart';
// import 'package:flutter/material.dart';
//
// // Configure the router
// final router = FluroRouter();
//
// var usersHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//   return UsersScreen(params["id"][0]);
// });
//
// void defineRoutes(FluroRouter router) {
//   router.define("/users/:id", handler: usersHandler);
//
//   // it is also possible to define the route transition to use
//   // router.define("users/:id", handler: usersHandler, transitionType: TransitionType.inFromLeft);
// }
//
// // Define routes
// router.define('/home', handler: Handler(handlerFunc: (_, __) => HomeScreen()));
// router.define('/profile', handler: Handler(handlerFunc: (_, __) => ProfileScreen()));
//
// // Handle navigation from notifications
// void handleNotificationNavigation(String routeName) {
// // Use the router to navigate to the desired page
// router.navigateTo(navigatorKey.currentContext, routeName, replace: true);
// }




//
//
// import 'package:flutter/material.dart';
// import 'package:skibble/splash_screen.dart';
// import 'package:skibble/src/features/authentication/views/auth_widget.dart';
//
// const String PAGE_HOME = '/';
// const String PAGE_NOTIFICATION_DETAILS = '/notification-details';
// const String PAGE_FIREBASE_TEST = '/firebase-test-page';
//
// Map<String, WidgetBuilder> materialRoutes = {
//   PAGE_HOME: (context) => const AuthWidget(),
//   // PAGE_NOTIFICATION_DETAILS: (context) => NotificationDetailsPage(
//   //   ModalRoute.of(context)!.settings.arguments as ReceivedNotification,
//   // ),
//   // PAGE_FIREBASE_TEST: (context) => FirebaseBackendPage(
//   //   ModalRoute.of(context)!.settings.arguments as String,
//   // ),
// };
//
// Map get routes {
//   return {
//     // '/userTileInfoCard': UserTileInfoCard()
//   };
// }
