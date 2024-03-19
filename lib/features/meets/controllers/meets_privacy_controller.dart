import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/models/food_spot.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/utils/constants.dart';

import '../models/nearby_meets_stream.dart';
import '../models/skibble_meet.dart';
import '../services/database/meets_database.dart';

class MeetsPrivacyController  with ChangeNotifier {
  List<String> privacyPickerList = ['Friends', 'Private', 'Public'];

  List<String> meetPalPrivateMeetChoiceList = ['Going', 'Not going'];

  List<String> privacyPickerListDescription = ['Only your friends on Skibble can see and ask to join.', "You get to choose your meet pals and send out a meet link to them.", 'Anyone on Skibble can see and ask to join. Based on your current location, '];

  List<SkibbleUser> selectedPrivateUsers = [];
  List<IconData> privacyListIcons = [Iconsax.people, Iconsax.security, Iconsax.global];

  List<IconData> meetPalPrivateMeetChoiceListSelectedIcons = [CupertinoIcons.hand_thumbsup_fill, CupertinoIcons.hand_thumbsdown_fill];
  List<IconData> meetPalPrivateMeetChoiceListUnSelectedIcons = [CupertinoIcons.hand_thumbsup, CupertinoIcons.hand_thumbsdown];


  SkibbleMeetPrivacyStatus meetPrivacyStatus = SkibbleMeetPrivacyStatus.public;
  SkibbleMeetMeetPalPrivateMeetChoice meetPalPrivateMeetChoice = SkibbleMeetMeetPalPrivateMeetChoice.going;


  int _userPrivacyChoiceIndex = 2;

  int get userPrivacyChoiceIndex => _userPrivacyChoiceIndex;


  int _meetPalPrivateMeetChoiceIndex = 0;

  int get meetPalPrivateMeetChoiceIndex => _meetPalPrivateMeetChoiceIndex;




  void reset() {
    _userPrivacyChoiceIndex = 2;
    meetPrivacyStatus = SkibbleMeetPrivacyStatus.public;
    _meetPalPrivateMeetChoiceIndex = 0;
    selectedPrivateUsers = [];
    notifyListeners();
  }

  initEdit(SkibbleMeet meet, SkibbleUser currentUser) async{
    _userPrivacyChoiceIndex = SkibbleMeetPrivacyStatus.values.indexWhere((element) => element.name.toLowerCase() == meet.meetPrivacyStatus.name.toLowerCase());
    meetPrivacyStatus = meet.meetPrivacyStatus;
    if(meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private) {
      selectedPrivateUsers = await MeetsDatabase().getSkibbleMeetPrivateMeetPals(meet, currentUser);
    }
  }

  void addPrivateUserToList(SkibbleUser user, BuildContext context) {
    if(selectedPrivateUsers.length < 3) {
      selectedPrivateUsers.insert(0, user);
      notifyListeners();

    }
    else {
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'Max. meet pals reached!', backgroundColor: kPrimaryColor,);
    }
  }

  void removePrivateUserFromList(SkibbleUser user) {

    var foundUserIndex = selectedPrivateUsers.indexWhere((element) => element.userId == user.userId);

    if(foundUserIndex != -1) {
      selectedPrivateUsers.removeAt(foundUserIndex);
      notifyListeners();
    }

  }

  set userPrivacyChoiceIndex(int newIndex) {
    _userPrivacyChoiceIndex = newIndex;
    meetPrivacyStatus = SkibbleMeetPrivacyStatus.values.firstWhere((element) => element.name == privacyPickerList[_userPrivacyChoiceIndex].toLowerCase());
    notifyListeners();
  }

  initMeetChoice(SkibbleMeetMeetPalPrivateMeetChoice choice) {
    _meetPalPrivateMeetChoiceIndex = choice == SkibbleMeetMeetPalPrivateMeetChoice.going ? 0 : 1;
    meetPalPrivateMeetChoice = choice;
    notifyListeners();
  }

  set meetPalPrivateMeetChoiceIndex(int newIndex) {
    _meetPalPrivateMeetChoiceIndex = newIndex;
    meetPalPrivateMeetChoice = _meetPalPrivateMeetChoiceIndex == 0 ? SkibbleMeetMeetPalPrivateMeetChoice.going : SkibbleMeetMeetPalPrivateMeetChoice.notGoing;
    notifyListeners();
  }

}