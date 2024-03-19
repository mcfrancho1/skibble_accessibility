import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.isPressed = false
  }) : super(key: key);
  final String? text;
  final bool? isPressed;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          primary: Colors.white,
          backgroundColor: kPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 8)
        ),
        onPressed: press as void Function()?,
        child: isPressed! ? Center(child: SpinKitCircle(size: getProportionateScreenHeight(40) / 1.4, color: kLightSecondaryColor,)) : Text(
          text!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}