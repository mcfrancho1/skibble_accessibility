import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';

import '../../../models/skibble_user.dart';
import '../models/meet_filter.dart';
import '../models/nearby_meets_stream.dart';

class MeetsFilterController with ChangeNotifier {

  SkibbleMeetsFilter? _tempMeetFilter;
  SkibbleMeetsFilter? _meetFilter;

  List<String> billsHandlerPickerList = ['Meet Pals Treat', 'Split Bills', "Decide Later", "Random"];
  List<SkibbleMeetBillsType> billsTypePickerList = [SkibbleMeetBillsType.meetPalsTreat, SkibbleMeetBillsType.split, SkibbleMeetBillsType.decideLater, SkibbleMeetBillsType.random];

  List<IconData> billsHandlerPickerListIcons = [Iconsax.gift, Iconsax.bill, Iconsax.timer, Iconsax.share];

  SkibbleMeetsFilter? get tempMeetFilter => _tempMeetFilter;
  SkibbleMeetsFilter? get meetFilter => _meetFilter;



  void set tempMeetFilter(SkibbleMeetsFilter? filter) {
    _tempMeetFilter = filter;
    notifyListeners();
  }

  initMeetFilter() {
    _meetFilter = _tempMeetFilter;
  }

  setMeetFilter(SkibbleMeetsFilter? filter, BuildContext context, SkibbleUser currentUser) {
    _meetFilter = filter;

    if(filter != null) {
      context.read<MeetsController>().filterAllMeets(filter, currentUser);
    }

    notifyListeners();
  }

  addBillTypeFilter(int index) {
    _tempMeetFilter ??= SkibbleMeetsFilter(meetBillsType: [],);

    switch(index) {
      case 0:
        _tempMeetFilter!.meetBillsType!.add(SkibbleMeetBillsType.meetPalsTreat);
        break;
      case 1:
        _tempMeetFilter!.meetBillsType!.add(SkibbleMeetBillsType.split);

        break;
      case 2:
        _tempMeetFilter!.meetBillsType!.add(SkibbleMeetBillsType.decideLater);

        break;
      case 3:
        _tempMeetFilter!.meetBillsType!.add(SkibbleMeetBillsType.random);

        break;
    }

    notifyListeners();
  }


  removeBillTypeFilter(int index) {
    switch(index) {
      case 0:
        _tempMeetFilter!.meetBillsType!.remove(SkibbleMeetBillsType.meetPalsTreat);
        break;
      case 1:
        _tempMeetFilter!.meetBillsType!.remove(SkibbleMeetBillsType.split);

        break;
      case 2:
        _tempMeetFilter!.meetBillsType!.remove(SkibbleMeetBillsType.decideLater);

        break;
      case 3:
        _tempMeetFilter!.meetBillsType!.remove(SkibbleMeetBillsType.random);

        break;
    }
    notifyListeners();
  }
  resetFilter() {
    _tempMeetFilter = null;
    _meetFilter = null;
    //TODO: Fetch the original data
    notifyListeners();
  }

  chooseMaxMeetPals(int value) {
    if(_tempMeetFilter == null) {
      _tempMeetFilter = SkibbleMeetsFilter(meetBillsType: [],);
    }

    _tempMeetFilter!.maxNumberOfPeopleMeeting = value;
    notifyListeners();
  }

  chooseDates(List<DateTime?> dates) {
    if(_tempMeetFilter == null) {
      _tempMeetFilter = SkibbleMeetsFilter(meetBillsType: [],);
    }

    if(dates.length == 2) {
      _tempMeetFilter!.filterFromDateTime = dates[0];
      _tempMeetFilter!.filterToDateTime = dates[1];
    }
    else if(dates.length == 1) {
      _tempMeetFilter!.filterFromDateTime = dates[0];
      _tempMeetFilter!.filterToDateTime = null;

    }
    else {
      _tempMeetFilter!.filterFromDateTime = null;
      _tempMeetFilter!.filterToDateTime = null;

    }
    notifyListeners();
  }

  setNewFinalFilter() {
    _meetFilter = _tempMeetFilter;
    notifyListeners();
    // = SkibbleMeetsFilter(meetBillsType: [],);
  }

}