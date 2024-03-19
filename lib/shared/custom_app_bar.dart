import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/current_theme.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({Key? key, required this.title, this.actions, this.onBackPressed, this.centerTitle = false, this.titleFontSize}) : super(key: key);
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
      IconButton(
          splashRadius: 20,
          onPressed: () {
            if(onBackPressed != null) {
              onBackPressed!();
            }
            else {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_rounded,
            color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,)),

      title: Text(title, style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: titleFontSize),),
      centerTitle: Platform.isIOS ? true : centerTitle ,
      actions: actions,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
