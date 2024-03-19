import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  LoadingWidget({this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text(message == null? '': message!, style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)),
                SpinKitFadingCircle(
                  color: kPrimaryColor,
                  size: 50.0,
                ),
              ],
            )
        ),
      ),
    );
  }
}
