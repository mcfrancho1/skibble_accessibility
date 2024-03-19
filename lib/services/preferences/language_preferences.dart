import 'package:flutter/material.dart';
import 'package:skibble/services/preferences/preferences.dart';

import '../../lang/language_constants.dart';

class LanguagePreferences  {
  Preferences _preferences = Preferences.getInstance();

  Future<Locale> setLocale(String languageCode) async {
    await _preferences.setLocaleKey(languageCode);
    return _locale(languageCode);
  }

  Future<Locale> getLocale() async {
    String languageCode = _preferences.getLocaleKey() ?? ENGLISH;
    return _locale(languageCode);
  }

  Locale _locale(String languageCode) {
    Locale _tempLocale;
    switch (languageCode) {
      case ENGLISH:
        _tempLocale = Locale(languageCode, "US");
        break;
      case FRENCH:
        _tempLocale = Locale(languageCode, "FR");
        break;
      case HINDI:
        _tempLocale = Locale(languageCode, "IN");
        break;
      case SPANISH:
        _tempLocale = Locale(languageCode, "AR");
        break;
      case CHINESE:
        _tempLocale = Locale(languageCode, "CN");
        break;
      default:
        _tempLocale = Locale(languageCode, "US");
    }
    return _tempLocale;
}
}