import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'lang/en_US.dart';
import 'lang/fr_FR.dart';

class LocalizationService extends Translations{
  static final defaultLocale = Locale('en', 'US');
  static final fallBackLocale = Locale('en', 'US');

  static final langs = ['English', 'French', ];
  static final locales = [
    Locale('en', 'US'),
    Locale('fr', 'FR'),
  ];

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'fr_FR': frFR
  };

  void changeLocale(String lang) {
    final locale = getLocaleFromLanguage(lang)!;
    final languageStorage = GetStorage();
    
    languageStorage.write('language', lang);
    Get.updateLocale(locale);
  }

  Locale? getLocaleFromLanguage(String? language) {
    for(int index = 0; index < langs.length; index++) {
      if(langs[index] == language) {
        return locales[index];
      }
    }

    return Get.locale;
  }

  Locale? getCurrentLocale() {
    final storage = GetStorage();

    Locale? defaultLocale;

    if(storage.read('language') != null) {
      final locale = getLocaleFromLanguage(storage.read('language'));

      defaultLocale = locale;
    }
    else {
      defaultLocale = Locale('en', 'US');
    }

    return defaultLocale;
  }

  String? getCurrentLanguage() {
    final storage = GetStorage();

    return storage.read('language') != null ? storage.read('language') : 'English';
  }

}