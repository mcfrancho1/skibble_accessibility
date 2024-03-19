

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'en_US.dart';
import 'fr_FR.dart';

class AppLocalization {
  static final defaultLocale = Locale('en', 'US');
  static final fallBackLocale = Locale('en', 'US');

  static final langs = ['English', 'French', ];
  static final locales = [
    Locale('en', 'US'),
    Locale('fr', 'FR'),
  ];

  late final Locale _locale;
  AppLocalization(this._locale);


  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'fr_FR': frFR
  };

  late Map<String, String> _localizedValues;

  // This function will load requested language `.json` file and will assign it to the `_localizedValues` map
  Future loadLanguage() async {
    String jsonStringValues = await rootBundle.loadString(
        "assets/languages/${_locale.languageCode}.json");

    Map<String, dynamic> mappedValues = json.decode(jsonStringValues);

    _localizedValues =
        mappedValues.map((key, value) => MapEntry(key, value.toString())); // converting `dynamic` value to `String`, because `_localizedValues` is of type Map<String,String>
  }

  String? getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  // void changeLocale(String lang) {
  //   final locale = getLocaleFromLanguage(lang)!;
  //   final languageStorage = GetStorage();
  //
  //   languageStorage.write('language', lang);
  //   Get.updateLocale(locale);
  // }

  // Locale? getLocaleFromLanguage(String? language) {
  //   for(int index = 0; index < langs.length; index++) {
  //     if(langs[index] == language) {
  //       return locales[index];
  //     }
  //   }
  //
  //   return Get.locale;
  // }

  // Locale? getCurrentLocale() {
  //   final storage = GetStorage();
  //
  //   Locale? defaultLocale;
  //
  //   if(storage.read('language') != null) {
  //     final locale = getLocaleFromLanguage(storage.read('language'));
  //
  //     defaultLocale = locale;
  //   }
  //   else {
  //     defaultLocale = Locale('en', 'US');
  //   }
  //
  //   return defaultLocale;
  // }

  // String? getCurrentLanguage() {
  //   final storage = GetStorage();
  //
  //   return storage.read('language') != null ? storage.read('language') : 'English';
  // }

  static const LocalizationsDelegate<AppLocalization> delegate = _AppLocalizationDelegate();

}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

// It will check if the user's locale is supported by our App or not
  @override
  bool isSupported(Locale locale) {
    return ["en", "fr"].contains(locale.languageCode);
  }

// // It will load the equivalent json file requested by the user
//   @override
//   Future<AppLocalization> load(Locale locale) async {
//     AppLocalization appLocalization = AppLocalization(locale);
//     await appLocalization.loadLanguage();
//     return appLocalization;
//   }

  @override
  Future<AppLocalization> load(Locale locale) async{
    // AppLocalization appLocalization = AppLocalization(locale);
    // await appLocalization.loadLanguage();
    return SynchronousFuture<AppLocalization>(AppLocalization(locale)).then((value) {value.loadLanguage(); return value;});
    // return appLocalization;
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
