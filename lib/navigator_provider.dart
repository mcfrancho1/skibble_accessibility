import 'package:flutter/material.dart';

import 'models/skibble_user.dart';

class AppNavigator  {

  static final AppNavigator _instance = AppNavigator._();
  AppNavigator._();

  static AppNavigator get instance => _instance;

  int count = 0;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late BuildContext context;
  Future<dynamic>? navigateTo(String routeName) => navigatorKey.currentState?.pushNamed(routeName);


  resetKey(SkibbleUser? user) {
    // navigatorKey.currentState?.dispose();


    if(user == null) {
      count = 0;
      navigatorKey = GlobalKey<NavigatorState>();

    }
    else {
      if(count <= 1) {
        navigatorKey = GlobalKey<NavigatorState>();

      }
    }
    count += 1;

  }

  setContext(BuildContext newContext) {
    context = newContext;
  }
}
