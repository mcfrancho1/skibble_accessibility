import 'package:flutter/material.dart';

class SlideBottomRoute extends PageRouteBuilder {
  final Widget widget;
  SlideBottomRoute({required this.widget})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
        // transitionDuration:Duration(seconds: 1);
      }

  );
}