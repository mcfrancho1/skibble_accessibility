import 'package:flutter/material.dart';
import 'package:skibble/models/kitchen_group.dart';

import '../../../models/chef_group.dart';
import '../../../models/home_page_model.dart';
import '../../../models/skibble_user.dart';

class KitchensData with ChangeNotifier {
  List<KitchenGroup> discoverPageKitchens = [];

  DiscoverPageModel discoverPageModel = DiscoverPageModel();


  void updateDiscoverModelTopRatedChefs(List<SkibbleUser> topRatedList) {
    if(discoverPageModel.topRatedChefsList == null) {
      discoverPageModel.topRatedChefsList = topRatedList;
    }
    else {
      discoverPageModel.topRatedChefsList!.addAll(topRatedList);
    }
    notifyListeners();
  }

  void updateDiscoverModelNearbyChefs(List<SkibbleUser> nearbyList) {
    discoverPageModel.nearbyChefsList = nearbyList;
    notifyListeners();
  }

  void updateDiscoverPageKitchens(List<KitchenGroup> group, {String? groupTitle, List<SkibbleUser>? users}) {

    if(discoverPageKitchens.isEmpty) {
      discoverPageKitchens = group;
    }

    else {
      var found = discoverPageKitchens.firstWhere((element) => element.groupTitle == groupTitle, orElse: () => KitchenGroup(groupTitle: '', userKitchens: []));

      if(found.groupTitle.isNotEmpty) {
        found.userKitchens.addAll(users!);
      }
      else {
        discoverPageKitchens.add(KitchenGroup(userKitchens: users!, groupTitle: groupTitle!));
      }
    }
    notifyListeners();
  }
}