
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/features/notifications/views/notifications_view.dart';

import '../features/authentication/views/auth_widget.dart';
//
// var rootHandler = Handler(
//     handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       var user = params["user"]?.first != null ? SkibbleUser.fromJsonString(params["user"]!.first) :  null;
//       return AuthWidget(user: user,);
//     });
//
//
// var notificationsHandler = Handler(
//     handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       return const NotificationsView();
//     });
