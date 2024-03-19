// import 'package:fluro/fluro.dart';
// import 'package:flutter/material.dart';
// import 'package:skibble/routing/route_handlers.dart';
//
// class Routes {
//   static const String homePage = '/';
//   static const String notificationsPage = '/notification-page';
//
//   static const String splash = '/splash';
//   static const String login = '/login';
//   static const String landing = '/landing';
//   static const String walkthrough = '/walkthrough';
//   static const String verifyEmail = '/verifyEmail';
//
//   static void configureRoutes(FluroRouter router) {
//     router.notFoundHandler = Handler(
//         handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//           print("ROUTE WAS NOT FOUND !!!");
//           return;
//         });
//     router.define(homePage, handler: rootHandler);
//     router.define(notificationsPage, handler: notificationsHandler);
//     // router.define(demoSimpleFixedTrans,
//     //     handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
//     // router.define(demoFunc, handler: demoFunctionHandler);
//     // router.define(deepLink, handler: deepLinkHandler);
//   }
// }