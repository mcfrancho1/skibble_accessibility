import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final IconData? iconData;
  final String text;
  final Function onPressed;
  final bool isSolid;
  final double? elevation;
  final double? borderRadius;
  final double? borderWidth;

  CustomElevatedButton({
    this.iconData,
    required this.text,
    required this.onPressed,
    this.isSolid = true,
    this.elevation,
    this.borderRadius,
    this.borderWidth
  });


  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30),
          onPrimary: isSolid? kPrimaryColor : Theme.of(context).canvasColor,
          primary: isSolid? kPrimaryColor: darkModeOn ? kBackgroundColorDarkTheme : Colors.white,
          elevation: elevation != null ? elevation : 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius != null ? borderRadius!: 20),
              side: BorderSide(
                  width: borderWidth != null ? borderWidth! : 2,
                  color: kPrimaryColor
              )
            // ),
          )
      ),
      child: iconData != null ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: isSolid ? Colors.white : kPrimaryColor,
          ),
          SizedBox(width: 3,),
          Text(
            text,
            style: TextStyle(
                fontFamily: 'Nunito Regular',
                color: isSolid ? Colors.white : kPrimaryColor,
                fontSize: 16
            ),
          ),
        ],
      )
      :
      Text(
        text,
        style: TextStyle(
            fontFamily: 'Nunito Regular',
            color: isSolid ? Colors.white : kPrimaryColor,
            fontSize: 16
        ),
      ),
    );
  }
}
