import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../models/address.dart';
import '../../../models/skibble_place.dart';
import '../../../services/maps_services/map_requests.dart';
import '../../../shared/bottom_sheet_dialogs.dart';
import '../../meets/controllers/meets_location_controller.dart';
import '../../meets/utils/meets_bottom_sheets.dart';

class KitchenController {



  Future<void> fetchKitchenFromGoogle(BuildContext context, String googlePlaceId) async {
    CustomBottomSheetDialog.showProgressSheetWithMessage(context, 'Fetching this business...', '');
    //TODO: Start from here tomorrow
    var result = await getGoogleFoodBusinessDetailsWithPlaceId(context, googlePlaceId);

    Navigator.pop(context);

    if(result != null) {
      await MeetsBottomSheets().showMeetsBusinessDetailsSheet(context, result, false);
    }
  }

  Future<SkibbleFoodBusiness?> getGoogleFoodBusinessDetailsWithPlaceId(BuildContext context, String googlePlaceId) async {
    try {

      var googlePlace = await GoogleMapsService().getPlaceDetails(googlePlaceId);
      if(googlePlace != null) {

        return SkibbleFoodBusiness(
            address: Address.fromGooglePlaceDetails(googlePlace),
            skibbleBusinessType: SkibbleBusinessType.google,
            skibblePlaceId: googlePlaceId,
            googlePlaceDetails: googlePlace
        );
      }
      else {return null;}

    }
    catch(e) {

      return null;
    }
  }
}