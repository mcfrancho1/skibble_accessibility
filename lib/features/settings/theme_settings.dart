import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skibble/services/preferences/preferences.dart';
import 'package:skibble/shared/custom_app_bar.dart';
import 'package:skibble/utils/constants.dart';

import '../../localization/app_translation.dart';
import '../../services/preferences/theme_preferences.dart';


class ThemeSettingsView extends StatefulWidget {
  const ThemeSettingsView({Key? key}) : super(key: key);

  @override
  State<ThemeSettingsView> createState() => _ThemeSettingsViewState();
}

class _ThemeSettingsViewState extends State<ThemeSettingsView> {

  String? choice;
  late final Preferences preferences;

  @override
  void initState() {
    preferences = Preferences.getInstance();
    choice = preferences.getThemeKey(defaultValue: 'light');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final themeController = ThemeController.getThemeController();

    return Scaffold(
      appBar: CustomAppBar(
        title: tr.theme,

      ),

      body: Column(
        children: [
          RadioListTile<String>(
            value: 'light',
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: kPrimaryColor,
              groupValue: choice,

            title: Text(tr.lightTheme),
            onChanged:(value) async{
              if(value != choice) {
                setState(() {
                  choice = value;
                });

                themeController.changeThemeMode('light', context);
              }
          }),

          // RadioListTile<String>(
          //     value: 'dark',
          //     controlAffinity: ListTileControlAffinity.trailing,
          //     activeColor: kPrimaryColor,
          //
          //     groupValue: choice,
          //
          //     title: Text('darkTheme'.tr),
          //     onChanged:(value) {
          //       if(value != choice) {
          //         setState(() {
          //           choice = value;
          //         });
          //
          //         themeController.changeThemeMode('dark', context);
          //       }
          //
          //     }),
          //
          //
          //
          // RadioListTile<String>(
          //     value: 'system',
          //     activeColor: kPrimaryColor,
          //     controlAffinity: ListTileControlAffinity.trailing,
          //
          //     groupValue: choice,
          //
          //     title: Text('sameAsSystem'.tr),
          //     onChanged:(value) {
          //       if(value != choice) {
          //         setState(() {
          //           choice = value;
          //         });
          //
          //         themeController.changeThemeMode('system', context);
          //       }
          //     })
        ],
      ),
    );
  }
}
