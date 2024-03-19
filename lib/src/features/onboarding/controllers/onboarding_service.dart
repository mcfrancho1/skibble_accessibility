import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';


///WE are using hive for our shared preferences
class OnboardingService with ChangeNotifier{
  OnboardingService(this._box);
  final Box<dynamic> _box;

  static const onboardingCompleteKey = 'onboardingComplete';

  Future<void> setOnboardingComplete() async {
    await _box.put(onboardingCompleteKey, true);
  }

  bool isOnboardingComplete() => _box.get(onboardingCompleteKey, defaultValue: false);
}
