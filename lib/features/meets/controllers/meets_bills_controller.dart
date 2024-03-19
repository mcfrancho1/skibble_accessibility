import 'package:flutter/cupertino.dart' as cu;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';

class MeetsBillsController with ChangeNotifier {
  List<String> billsHandlerPickerList = ['My Treat', 'Meet Pals Treat', 'Split Bills', "On the Table", "Random"];
  List<String> billsHandlerPickerListDescription = [
    'You will handle the bills for the meet',
    'They will handle the bills',
    'You and your meet pal(s) will split the bills',
    "You and your meet pal(s) will decide later after the meet",
    "Let Skibble pick randomly who handles the bills"
  ];

  List<IconData> billsHandlerPickerListIcons = [Iconsax.heart, Iconsax.gift, Iconsax.bill, Iconsax.timer, Iconsax.share];

  SkibbleMeetBillsType skibbleMeetBillsType = SkibbleMeetBillsType.split;


  int _userBillsTypeChoiceIndex = 2;

  int get userBillsTypeChoiceIndex => _userBillsTypeChoiceIndex;


  void reset() {
    _userBillsTypeChoiceIndex = 2;
    notifyListeners();
  }

  initEdit(SkibbleMeet meet)  {
    _userBillsTypeChoiceIndex = SkibbleMeetBillsType.values.indexWhere((element) => element.name.toLowerCase() == meet.meetBillsType.name.toLowerCase());
    skibbleMeetBillsType = meet.meetBillsType;
  }

  void set userBillsTypeChoiceIndex(int newIndex) {
    _userBillsTypeChoiceIndex = newIndex;
    skibbleMeetBillsType = SkibbleMeetBillsType.values[_userBillsTypeChoiceIndex];
        // .firstWhere((element) => element.name == billsHandlerPickerList[_userBillsTypeChoiceIndex].toLowerCase());
    notifyListeners();
  }


}
