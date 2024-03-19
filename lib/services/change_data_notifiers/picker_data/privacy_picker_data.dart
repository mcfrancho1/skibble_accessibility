import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/models/food_spot.dart';

class PrivacyPickerData  with ChangeNotifier {
  List<String> privacyPickerList = ['Friends', 'Everyone'];
  List<String> privacyPickerListDescription = ['Your friends on Skibble', 'Anyone on Skibble'];

  List<IconData> privacyListIcons = [Iconsax.people, Iconsax.global];

  FoodSpotPrivacyStatus spotPrivacyStatus = FoodSpotPrivacyStatus.everyone;


  int _userPrivacyChoiceIndex = 1;

  int get userPrivacyChoiceIndex => _userPrivacyChoiceIndex;


  void reset() {
    _userPrivacyChoiceIndex = 1;
    notifyListeners();
  }

  void set userPrivacyChoiceIndex(int newIndex) {
    _userPrivacyChoiceIndex = newIndex;
    spotPrivacyStatus = FoodSpotPrivacyStatus.values.firstWhere((element) => element.name == privacyPickerList[_userPrivacyChoiceIndex].toLowerCase());
    notifyListeners();


  }

}