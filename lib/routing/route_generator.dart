
import 'package:flutter/material.dart';
import 'package:skibble/main_page.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/splash_screen.dart';
import 'package:skibble/features/authentication/views/auth_widget.dart';
import 'package:skibble/features/notifications/views/notifications_view.dart';
import 'package:skibble/features/walkthrough/walkthrough_screen.dart';

///Route generator class
class RouteGenerator {
  static const String homePage = '/';
  static const String notificationsPage = '/notification-page';

  static const String splash = '/splash';
  static const String login = '/login';
  static const String landing = '/landing';
  static const String walkthrough = '/walkthrough';
  static const String verifyEmail = '/verifyEmail';


  RouteGenerator._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {
      case homePage:
        var snapshot = settings.arguments as AsyncSnapshot<SkibbleUser?>;
        return MaterialPageRoute(builder: (_) =>  AuthWidget(userSnapshot: snapshot,), settings: settings);
      case notificationsPage:
        return MaterialPageRoute(builder: (_) => const NotificationsView(), settings: settings);
      case landing:
        return MaterialPageRoute(builder: (_) => const LoadingPage(), settings: settings);

      default:
        throw const FormatException('Route not found');
    }
  }

  // static Route<dynamic>? Function(String initialRouteName, Object? arguments)? customInitialRouteGenerator = (route, args) {
  //   if (route == 'your_initial_route') {
  //     // Create and return the initial route with the specified parameters
  //     return MaterialPageRoute(
  //       builder: (context) => AuthWidget(user: args as SkibbleUser?,),);
  //   }
  //   return null; // Return null for routes you don't handle
  // };
}