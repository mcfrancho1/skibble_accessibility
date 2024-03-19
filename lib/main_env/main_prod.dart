
import 'package:flutter/material.dart';
import 'package:skibble/skibble_app.dart';
import 'package:skibble/utils/app_config.dart';

void main() async{
  var configuredApp = AppConfig(
      appTitle: 'Skibble',
      buildFlavor: 'Production', child: NewSkibbleApp()
  );

  runApp(
      configuredApp
  );
}
