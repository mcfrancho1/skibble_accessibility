import 'package:flutter/material.dart';

import '../services/preferences/theme_preferences.dart';

class CurrentTheme extends ChangeNotifier{
  BuildContext context;

  CurrentTheme(this.context);

  bool get isDarkMode {
     ThemeController controller = ThemeController.getThemeController();

     if(controller.themeStateFromHiveSettingBox == ThemeMode.light) {
       return false;
     }

     else if(controller.themeStateFromHiveSettingBox == ThemeMode.dark) {
       return true;
     }
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }
}