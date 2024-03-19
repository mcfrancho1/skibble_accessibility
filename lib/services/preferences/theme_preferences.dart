import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/preferences/preferences.dart';
import 'package:skibble/utils/current_theme.dart';

import '../change_data_notifiers/app_data.dart';

class ThemeController extends GetxController{
  late bool isDarkTheme;
  static String? themeHiveSetting;
 // BuildContext context;


  static var preferences = Preferences.getInstance();


  ThemeController._();

  static ThemeController getThemeController() {
    themeHiveSetting = preferences.getThemeKey(defaultValue: 'light');

    return ThemeController._();
  }


  ThemeMode get themeStateFromHiveSettingBox{

    if(themeHiveSetting == 'light') {
      return ThemeMode.light;
    }
    else if(themeHiveSetting == 'dark'){
      return ThemeMode.dark;
    }

    else {
      return ThemeMode.system;

    }
  }



  // private Method to Get HiveBox Storage theme Setting value adn Return it
  // String? _getThemeFromHiveBox() {
  //    themeHiveSetting = preferences.getThemeKey(defaultValue: 'light');
  //  // print(themeHiveSetting);
  //   if(themeHiveSetting == 'light') {
  //     return false;
  //   }
  //   else if(themeHiveSetting == 'dark'){
  //     return true;
  //   }
  //
  //   else {
  //     return null;
  //
  //   }
  // }


  // private Method to update HiveBox Storage theme Setting value
  void _updateHiveThemeSetting(String themeString) async{
    await preferences.setThemeKey(themeString);
  }

  // Method to change the Theme State when the user call it via Theme Change Button
  void changeTheme({
    required RxBool isDarkMode,
    required Rx<String> modeName,
  }) {
    if (Get.isDarkMode) {
      modeName.value = 'light';
      isDarkMode.value = false;
      isDarkTheme = false;
      _updateHiveThemeSetting('light');
      _changeThemeMode(ThemeMode.light);
    } else {
      modeName.value = 'dark';
      isDarkMode.value = true;
      isDarkTheme = true;
      _updateHiveThemeSetting('dark');
      _changeThemeMode(ThemeMode.dark);
    }
  }

  //Private Method to change theme
  void _changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);

  void changeThemeMode(String themeType, context) async{

    themeHiveSetting = themeType;

    if(themeHiveSetting == 'light') {
      _changeThemeMode(ThemeMode.light);
    }
    else if(themeType == 'dark'){

      _changeThemeMode(ThemeMode.dark);
    }

    else {
      _changeThemeMode(ThemeMode.system);

    }

    _updateHiveThemeSetting(themeType);

    Provider.of<AppData>(context, listen: false).updateIsThemeChanged(themeType);

  }

}