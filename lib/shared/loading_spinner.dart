import 'dart:io';
import 'package:flutter/cupertino.dart' as cu;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/constants.dart';
import '../utils/size_config.dart';


class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key, this.size, this.color = kLightSecondaryColor}) : super(key: key);
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Platform.isAndroid ?SpinKitCircle(
          size: size != null ? size! : getProportionateScreenHeight(40) / 1.4,
          color: color,
        )
            :
        cu.CupertinoActivityIndicator(
          radius: size != null ? size! / 2 : getProportionateScreenHeight(40) / 1.4,
          color: color,
        )
    ) ;
  }
}


class LoadingFallingDot extends StatelessWidget {
  const LoadingFallingDot({Key? key, this.size, this.color = kLightSecondaryColor}) : super(key: key);
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid ? LoadingAnimationWidget.fallingDot(
        size: size != null ? size! : getProportionateScreenHeight(40) / 1.4,
        color: color!,
      )  :
        cu.CupertinoActivityIndicator(
          radius: size != null ? size! / 2 : getProportionateScreenHeight(40) / 1.4,
          color: color,
        )
      // SpinKitCircle(
      //   size: size != null ? size! : getProportionateScreenHeight(40) / 1.4,
      //   color: color,
      // )
    );
  }
}
