import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor: kLightSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor: kDarkSecondaryColor,
            fontFamily: 'Brand Regular'
          //fontSize: 10.0
        ),
      ),
      children: [
        Center(child: Text('Please wait...', style: TextStyle(color: Colors.grey),)),

        SizedBox(height: 20,),
        Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),)),
      ],

    );
  }
}
