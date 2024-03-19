import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/food_preferences_data.dart';

class FoodOptionsPickerData with ChangeNotifier {
  List<String> _cuisines = [];
  List<String> _mealSpecific = [];
  List<String> _cookingStyle = [];
  List<String> _dietPrescriptions = [];
  List<String> _custom = [];

  List<String> _newUserChoices = [];
  List<String> _userChoices = [];


  FoodOptionsPickerData() {
    _cuisines.addAll(FoodPreferencesData.cuisines);
    _cuisines.sort((a, b) => a.compareTo(b));

    _mealSpecific.addAll(FoodPreferencesData.mealSpecific);
    _mealSpecific.sort((a, b) => a.compareTo(b));

    _cookingStyle.addAll(FoodPreferencesData.cookingStyle);
    _cookingStyle.sort((a, b) => a.compareTo(b));

    _dietPrescriptions.addAll(FoodPreferencesData.dietPrescriptions);
    _dietPrescriptions.sort((a, b) => a.compareTo(b));

    _custom.addAll(FoodPreferencesData.custom);
    _custom.sort((a, b) => a.compareTo(b));
  }


  List<String> get cuisines => _cuisines;
  List<String> get mealSpecific => _mealSpecific;
  List<String> get cookingStyle => _cookingStyle;
  List<String> get dietPrescriptions => _dietPrescriptions;
  List<String> get custom => _custom;


  List<String> get newUserChoices => _newUserChoices;
  List<String> get userChoices => _userChoices;


  bool get didChoicesChange => _userChoices.length != _newUserChoices.length ? true : _newUserChoices.toSet().difference(_userChoices.toSet()).length > 0;

  List<String> get newChoicesAdded => _newUserChoices.toSet().difference(_userChoices.toSet()).toList();

  void initNewChoices() {
    _newUserChoices = [];
    _newUserChoices.addAll(userChoices);
    // notifyListeners();
  }

  String getTagEmoji(String key) => FoodPreferencesData.foodMap[key] ?? '🍽️';

  void set userChoices(List<String> choices) {
    _userChoices = choices;
  }

  void saveFinalChoices() {
    _userChoices.clear();
    _userChoices.addAll(_newUserChoices.toSet());

    _newUserChoices.clear();
    notifyListeners();
  }

  void reset() {
    _userChoices.clear();
    _newUserChoices.clear();
    notifyListeners();
  }


  void addToUserChoice(String choice) {
    HapticFeedback.lightImpact();

    _newUserChoices.insert(0, choice);
    notifyListeners();
  }


  void removeFromUserChoice(String choice) {
    _newUserChoices.remove(choice);
    notifyListeners();
  }

  void removeFromUserChoiceAtIndex(int index) {
    _userChoices.removeAt(index);
    notifyListeners();
  }

  void removeFromNewUserChoiceAtIndex(int index) {
    _newUserChoices.removeAt(index);
    notifyListeners();
  }


}