import 'package:skibble/models/address.dart';
import 'package:skibble/models/business_models/yelp_business_details.dart';
import 'package:skibble/models/skibble_place.dart';

import '../../../../services/dio_service.dart';

class YelpService {

  final String businessSearchUrl = 'https://api.yelp.com/v3/businesses/search?';
  final String businessDetailsUrl = 'https://api.yelp.com/v3/businesses';

  final String yelpApiKey = 'Bearer z987YB2UQFv2zsEB3tmtuMJX7Zt1m95GKxAdI4QpWv-nkpMjUOnmxthcrG8ure7yMvJmBh1MDQkzGWToqNNKKgybXKD9_dfdXdaUnPPv_P37DW562xaPw0B7sAR9ZHYx';

  final String searchTerm = 'restaurants';
  final String sort_by = 'best_match';
  final int radius = 40000;


  Future<List<SkibbleFoodBusiness>?> getAllYelpFoodBusinesses(Address currentLocation, String term, {int? offset}) async {
    try {
      var businesses = await DioService.getRequestWithAPIKey(businessSearchUrl, yelpApiKey ,
          {
            'latitude': currentLocation.latitude,
            'longitude': currentLocation.longitude,
            'sort_by': '$sort_by',
            'term': '$term',
            'radius': radius,
            'offset': offset
          });

      return (businesses['businesses'] as List).map((e) => SkibbleFoodBusiness(
          address: Address.fromYelpBusinessDetails(YelpBusinessDetails.fromJson(e)),
          skibbleBusinessType: SkibbleBusinessType.yelp,
          yelpBusinessDetails:  YelpBusinessDetails.fromJson(e))).toList();
    }
    catch(e) {
      print(e);
      return null;
    }
  }


  Future<SkibbleFoodBusiness?> getYelpFoodBusinessesDetails(SkibbleFoodBusiness foodBusiness) async {
    try {
      var business = await DioService.getRequestWithAPIKey('$businessDetailsUrl/${foodBusiness.yelpBusinessDetails!.yelpBusinessId!}', yelpApiKey, {});
      foodBusiness.yelpBusinessDetails!.placeImages = business['photos'];
      foodBusiness.isFullYelpDetailsFetched = true;

      return foodBusiness;
    }
    catch(e) {
      print(e);
      return null;
    }
  }
}