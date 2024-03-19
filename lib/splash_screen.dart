//
import 'package:flutter/material.dart';
import 'package:skibble_accessibility/utils/constants.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  kPrimaryColor,
        body: Center(
          child: Icon(SkibbleIcons.skibble_letter_light, color: kLightSecondaryColor, size: 143,),
        )
    );
  }
}
//
