import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:skibble/utils/accessibility_preferences_data.dart';


class AccessibilityOptionsPickerData with ChangeNotifier {
  List<String> _parking = [];
  List<String> _seating = [];
  List<String> _entrance = [];

  List<String> _restroom = [];

  List<String> _menu = [];

  List<String> _newUserChoices = [];
  List<String> _userChoices = [];


  AccessibilityOptionsPickerData() {
    _parking.addAll(AccessibilityPreferenceData.parking);
    _parking.sort((a, b) => a.compareTo(b));

    _seating.addAll(AccessibilityPreferenceData.seating);
    _seating.sort((a, b) => a.compareTo(b));

    _entrance.addAll(AccessibilityPreferenceData.entrance);
    _entrance.sort((a, b) => a.compareTo(b));

    _restroom.addAll(AccessibilityPreferenceData.restroom);
    _restroom.sort((a, b) => a.compareTo(b));

    _menu.addAll(AccessibilityPreferenceData.menu);
    _menu.sort((a, b) => a.compareTo(b));


  }


  List<String> get parking => _parking;
  List<String> get seating => _seating;
  List<String> get entrance => _entrance;
  List<String> get restroom => _restroom;
  List<String> get menu => _menu;


  List<String> get newUserChoices => _newUserChoices;
  List<String> get userChoices => _userChoices;


  bool get didChoicesChange => _userChoices.length != _newUserChoices.length ? true : _newUserChoices.toSet().difference(_userChoices.toSet()).length > 0;

  List<String> get newChoicesAdded => _newUserChoices.toSet().difference(_userChoices.toSet()).toList();

  void initNewChoices() {
    _newUserChoices = [];
    _newUserChoices.addAll(userChoices);
    // notifyListeners();
  }

  String getTagEmoji(String key) => AccessibilityPreferenceData.accessMap[key] ?? '♿️';

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