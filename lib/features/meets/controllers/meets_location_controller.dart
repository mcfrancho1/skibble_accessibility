import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/kitchen_controller.dart';
import 'package:skibble/models/kitchen.dart';
import 'package:skibble/models/skibble_place.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/services/maps_services/geo_locator_service.dart';
import 'package:skibble/features/meets/controllers/meets_loading_controller.dart';
import 'package:skibble/features/meets/services/requests/yelp_services.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/custom_pickers/location_picker_view.dart';
import 'package:uuid/uuid.dart';
import '../../../models/address.dart';
import '../../../models/suggestion.dart';
import '../../../services/maps_services/map_requests.dart';
import '../../../utils/constants.dart';
import '../../kitchens/controllers/kitchen_controller.dart';

class MeetsLocationController with ChangeNotifier {

  Address? _pickedLocation;
  TextEditingController? _controller;
  String? _session;
  List<Suggestion>? _placeSuggestions;
  Suggestion? _selectedSuggestion;
  List<String> skibbleChefCountries = ['Canada', 'Nigeria'];

  int _selectedButtonIndex = 0;
  // int? _finalSelectedListIndex;
  String? _finalSelectedBusinessId;
  int? _finalSelectedButtonIndex;
  String _searchString = '';

  Address? get pickedLocation => _pickedLocation;
  Suggestion? get selectedSuggestion => _selectedSuggestion;
  int get selectedButtonIndex => _selectedButtonIndex;
  // int? get finalSelectedListIndex => _finalSelectedListIndex;
  String? get finalSelectedBusinessId => _finalSelectedBusinessId;

  int? get finalSelectedButtonIndex => _finalSelectedButtonIndex;

  String get searchString => _searchString;



  PagingController<int, SkibbleFoodBusiness> foodBusinessesPagingController = PagingController(firstPageKey: 0);
  Map<String, List<SkibbleFoodBusiness>> foodBusinesses = {};
  Map<String, List<bool>> expandedBusinessMap = {};

  TextEditingController? get textController => _controller;
  List<Suggestion>? get placeSuggestions => _placeSuggestions;

  int prevButtonIndex = -1;
  int prevIndexInList = -1;

  set searchString(String value) {
    _searchString = value;
    notifyListeners();
  }

  void reset() {
    // _finalSelectedListIndex = null;
    _finalSelectedBusinessId = null;

    _finalSelectedButtonIndex = null;
    _selectedButtonIndex = 0;
    _pickedLocation = null;
    _searchString = '';
    // _controller?.dispose();
    _placeSuggestions = [];
    notifyListeners();
  }

  init() {
    _controller = TextEditingController(text: _selectedSuggestion != null ? '${_selectedSuggestion!.title}, ${_selectedSuggestion!.subTitle}' : '');
    _session = Uuid().v4();
    _placeSuggestions = [];

    if(foodBusinesses['restaurants'] == null) {
      foodBusinesses['restaurants'] = [];

    }
    if( foodBusinesses['cafes'] == null) {
      foodBusinesses['cafes'] = [];


    }
    if(foodBusinesses['bars'] == null) {
      foodBusinesses['bars'] = [];

    }
    if(foodBusinesses['food'] == null) {
      foodBusinesses['food'] = [];
    }
  }

  String yelpImagePath(double rating) {
    if(rating == 0) {
      return 'assets/images/yelp_assets/large_0@3x.png';
    }
    else if(rating == 1.0) {
      return 'assets/images/yelp_assets/large_1@3x.png';
    }
    else if(rating == 1.5) {
      return 'assets/images/yelp_assets/large_1_half@3x.png';
    }
    else if(rating == 2.0) {
      return 'assets/images/yelp_assets/large_2@3x.png';
    }
    else if(rating == 2.5) {
      return 'assets/images/yelp_assets/large_2_half@3x.png';
    }
    else if(rating == 3) {
      return 'assets/images/yelp_assets/large_3@3x.png';
    }
    else if(rating == 3.5) {
      return 'assets/images/yelp_assets/large_3_half@3x.png';
    }

    else if(rating == 4.0) {
      return 'assets/images/yelp_assets/large_4@3x.png';
    }

    else if(rating == 4.5) {
      return 'assets/images/yelp_assets/large_4_half@3x.png';
    }

    else {
      return 'assets/images/yelp_assets/large_5@3x.png';
    }


  }
  void collapseTile(int buttonIndex, int indexInList) {
    var entriesList = expandedBusinessMap.entries.toList();

    if(prevButtonIndex != -1) {
      entriesList[buttonIndex].value[indexInList] = false;
      prevButtonIndex = buttonIndex;
      prevIndexInList = indexInList;
    }
    notifyListeners();
  }

  void expandBusinessTile(BuildContext context, int buttonIndex, int indexInList) async{
    var entriesList = expandedBusinessMap.entries.toList();

    //make sure to close the previous expanded tile
    if(prevButtonIndex != -1) {
       if((prevButtonIndex != buttonIndex && prevIndexInList != indexInList) || (prevButtonIndex == buttonIndex && prevIndexInList != indexInList)) {
         entriesList[prevButtonIndex].value[prevIndexInList] = false;
         prevButtonIndex = buttonIndex;
         prevIndexInList = indexInList;
       }
    }
    else {
      prevButtonIndex = buttonIndex;
      prevIndexInList = indexInList;
    }
    notifyListeners();


    entriesList[buttonIndex].value[indexInList] = true;


    var categoriesList = foodBusinesses.entries.toList();
    if(!categoriesList[buttonIndex].value[indexInList].isFullYelpDetailsFetched) {
      context.read<MeetsLoadingController>().isLoadingSecond = true;
      //fetch the data here
      var details = await getYelpFoodBusinessDetails(context, categoriesList[buttonIndex].value[indexInList]);
      categoriesList[buttonIndex].value[indexInList] = details ?? SkibbleFoodBusiness(
          address: Address.fromYelpBusinessDetails(
              categoriesList[buttonIndex].value[indexInList].yelpBusinessDetails!),
          skibbleBusinessType: SkibbleBusinessType.yelp,
          skibblePlaceId: categoriesList[buttonIndex].value[indexInList].yelpBusinessDetails!.yelpBusinessId!,
          yelpBusinessDetails: categoriesList[buttonIndex].value[indexInList].yelpBusinessDetails
      );
      context.read<MeetsLoadingController>().isLoadingSecond = false;

    }

    notifyListeners();

  }

  Future<SkibbleFoodBusiness?> fetchGoogleDetails(BuildContext context, int buttonIndex,
      {String? googlePlaceId, int? indexInList}) async{

    if(indexInList != null) {
      var categoriesList = foodBusinesses.entries.toList();
      if(!categoriesList[buttonIndex].value[indexInList].isFullGoogleDetailsFetched) {
        //fetch the data here
        var details = await KitchenController().getGoogleFoodBusinessDetailsWithPlaceId(context, categoriesList[buttonIndex].value[indexInList].googlePlaceDetails!.googlePlaceId!);
        categoriesList[buttonIndex].value[indexInList] = details ?? SkibbleFoodBusiness(
            address: Address.fromGooglePlaceDetails(
                categoriesList[buttonIndex].value[indexInList].googlePlaceDetails!),
            skibbleBusinessType: SkibbleBusinessType.google,
            skibblePlaceId: categoriesList[buttonIndex].value[indexInList].googlePlaceDetails!.googlePlaceId!,
            googlePlaceDetails: categoriesList[buttonIndex].value[indexInList].googlePlaceDetails
        );

      }
      notifyListeners();
      return categoriesList[buttonIndex].value[indexInList];
    }
    else if(googlePlaceId != null) {
      var details = await KitchenController().getGoogleFoodBusinessDetailsWithPlaceId(context, googlePlaceId);
      notifyListeners();

      return details!;
    }
    else {
      return null;
    }

  }


  ///FetchDetails with Yelp
  // Future<SkibbleFoodBusiness> fetchGoogleDetails(BuildContext context, int buttonIndex, int indexInList) async{
  //   var categoriesList = foodBusinesses.entries.toList();
  //   if(!categoriesList[buttonIndex].value[indexInList].isFullGoogleDetailsFetched) {
  //     //fetch the data here
  //     var details = await getGoogleFoodBusinessDetailsFromYelp(context, categoriesList[buttonIndex].value[indexInList]);
  //     categoriesList[buttonIndex].value[indexInList] = details ?? SkibbleFoodBusiness(
  //         address: Address.fromYelpBusinessDetails(
  //             categoriesList[buttonIndex].value[indexInList].yelpBusinessDetails!),
  //         skibbleBusinessType: SkibbleBusinessType.yelp,
  //         skibblePlaceId: categoriesList[buttonIndex].value[indexInList].yelpBusinessDetails!.yelpBusinessId!,
  //         yelpBusinessDetails: categoriesList[buttonIndex].value[indexInList].yelpBusinessDetails
  //     );
  //
  //   }
  //
  //   notifyListeners();
  //   return categoriesList[buttonIndex].value[indexInList];
  // }


  void set selectedButtonIndex(int value) {
    _selectedButtonIndex = value;
    notifyListeners();

  }

  void set finalSelectedButtonIndex(int? value) {
    _finalSelectedButtonIndex = value;
    notifyListeners();

  }

  // void set finalSelectedListIndex(int? value) {
  //   _finalSelectedListIndex = value;
  //   notifyListeners();
  //
  // }

  void set finalSelectedBusinessId(String? value) {
    _finalSelectedBusinessId = value;
    notifyListeners();

  }
  // _finalSelectedButtonIndex


  ///Yelp API to fetch food businesses
  // Future<void> fetchYelpFoodBusinesses(BuildContext context, int value) async{
  //   selectedButtonIndex = value;
  //   context.read<MeetsLoadingController>().isLoading = true;
  //   switch(selectedButtonIndex) {
  //     case 0:
  //       if(foodBusinesses['restaurants'] == null) {
  //         var restaurants = await getAllNearbyYelpFoodBusinesses(context, 'restaurants');
  //         foodBusinesses['restaurants'] = [];
  //         foodBusinesses['restaurants']!.addAll(restaurants);
  //         expandedBusinessMap['restaurants'] = List.generate(restaurants.length, (index) => false);
  //       }
  //
  //       break;
  //     case 1:
  //       if(foodBusinesses['cafes'] == null) {
  //         var cafes = await getAllNearbyYelpFoodBusinesses(context, 'cafes');
  //         foodBusinesses['cafes'] = [];
  //         foodBusinesses['cafes']!.addAll(cafes);
  //         expandedBusinessMap['cafes'] = List.generate(cafes.length, (index) => false);
  //       }
  //       break;
  //     case 2:
  //       if(foodBusinesses['bars'] == null) {
  //         var bars = await getAllNearbyYelpFoodBusinesses(context, 'bars');
  //         foodBusinesses['bars'] = [];
  //         foodBusinesses['bars']!.addAll(bars);
  //         expandedBusinessMap['bars'] = List.generate(bars.length, (index) => false);
  //
  //       }
  //       break;
  //     case 3:
  //       if(foodBusinesses['food'] == null) {
  //         var food = await getAllNearbyYelpFoodBusinesses(context, 'fast food');
  //         foodBusinesses['food'] = [];
  //         foodBusinesses['food']!.addAll(food);
  //         expandedBusinessMap['food'] = List.generate(food.length, (index) => false);
  //
  //       }
  //       break;
  //   }
  //
  //   context.read<MeetsLoadingController>().isLoading = false;
  //
  //   notifyListeners();
  // }


  ///Google API to fetch food businesses
  Future<void> fetchGoogleFoodBusinesses(BuildContext context, int value) async{
    selectedButtonIndex = value;
    context.read<MeetsLoadingController>().isLoading = true;
    switch(selectedButtonIndex) {
      case 0:
        if(foodBusinesses['restaurants']!.isEmpty) {
          var restaurants = await getAllNearbyGoogleFoodBusinesses(context, 'restaurant');
          foodBusinesses['restaurants'] = [];
          foodBusinesses['restaurants']!.addAll(restaurants);
          expandedBusinessMap['restaurants'] = List.generate(restaurants.length, (index) => false);
        }

        break;
      case 1:
        if(foodBusinesses['cafes']!.isEmpty) {
          var cafes = await getAllNearbyGoogleFoodBusinesses(context, 'cafe');
          foodBusinesses['cafes'] = [];
          foodBusinesses['cafes']!.addAll(cafes);
          expandedBusinessMap['cafes'] = List.generate(cafes.length, (index) => false);
        }
        break;
      case 2:
        if(foodBusinesses['bars']!.isEmpty) {
          var bars = await getAllNearbyGoogleFoodBusinesses(context, 'bar');
          foodBusinesses['bars'] = [];
          foodBusinesses['bars']!.addAll(bars);
          expandedBusinessMap['bars'] = List.generate(bars.length, (index) => false);
        }
        break;
      case 3:
        if(foodBusinesses['food']!.isEmpty) {
          var food = await getAllNearbyGoogleFoodBusinesses(context, 'fast food');
          foodBusinesses['food'] = [];
          foodBusinesses['food']!.addAll(food);
          expandedBusinessMap['food'] = List.generate(food.length, (index) => false);
        }
        break;
    }

    context.read<MeetsLoadingController>().isLoading = false;

    notifyListeners();
  }


  ///Yelp API to fetch food businesses
  // void loadMoreFoodBusinesses(BuildContext context,) async{
  //   context.read<MeetsLoadingController>().isLoadingThird = true;
  //
  //   switch(selectedButtonIndex) {
  //     case 0:
  //       var restaurants = await getAllNearbyYelpFoodBusinesses(context, 'restaurants', offset: foodBusinesses['restaurants']!.length);
  //       foodBusinesses['restaurants']!.addAll(restaurants);
  //       expandedBusinessMap['restaurants']?.addAll(List.generate(restaurants.length, (index) => false));
  //       break;
  //     case 1:
  //       var cafes = await getAllNearbyYelpFoodBusinesses(context, 'cafes', offset: foodBusinesses['cafes']!.length);
  //       foodBusinesses['cafes']!.addAll(cafes);
  //       expandedBusinessMap['cafes']?.addAll(List.generate(cafes.length, (index) => false));
  //       break;
  //     case 2:
  //       var bars = await getAllNearbyYelpFoodBusinesses(context, 'bars', offset: foodBusinesses['bars']!.length);
  //       foodBusinesses['bars']!.addAll(bars);
  //       expandedBusinessMap['bars']?.addAll(List.generate(bars.length, (index) => false));
  //
  //       break;
  //     case 3:
  //       var food = await getAllNearbyYelpFoodBusinesses(context, 'fast food', offset: foodBusinesses['food']!.length);
  //       foodBusinesses['food']!.addAll(food);
  //       expandedBusinessMap['food']?.addAll(List.generate(food.length, (index) => false));
  //
  //       break;
  //   }
  //   context.read<MeetsLoadingController>().isLoadingThird = false;
  //
  //   notifyListeners();
  // }


  ///Google API to fetch food businesses
  void loadMoreGoogleFoodBusinesses(BuildContext context,) async{
    context.read<MeetsLoadingController>().isLoadingThird = true;

    switch(selectedButtonIndex) {
      case 0:
        var restaurants = await getMoreNearbyGoogleFoodBusinesses(context, 'restaurant', nextToken: foodBusinesses['restaurants']!.isNotEmpty ? foodBusinesses['restaurants']!.last.nextPageGoogleToken : null);
        foodBusinesses['restaurants']!.addAll(restaurants);
        expandedBusinessMap['restaurants']?.addAll(List.generate(restaurants.length, (index) => false));
        break;
      case 1:
        var cafes = await getMoreNearbyGoogleFoodBusinesses(context, 'cafe', nextToken: foodBusinesses['cafes']!.isNotEmpty ? foodBusinesses['cafes']!.last.nextPageGoogleToken : null);
        foodBusinesses['cafes']!.addAll(cafes);
        expandedBusinessMap['cafes']?.addAll(List.generate(cafes.length, (index) => false));
        break;
      case 2:
        var bars = await getMoreNearbyGoogleFoodBusinesses(context, 'bar', nextToken: foodBusinesses['bars']!.isNotEmpty ? foodBusinesses['bars']!.last.nextPageGoogleToken: null);
        foodBusinesses['bars']!.addAll(bars);
        expandedBusinessMap['bars']?.addAll(List.generate(bars.length, (index) => false));

        break;
      case 3:
        var food = await getMoreNearbyGoogleFoodBusinesses(context, 'fast food', nextToken: foodBusinesses['food']!.isNotEmpty ? foodBusinesses['food']!.last.nextPageGoogleToken: null);
        foodBusinesses['food']!.addAll(food);
        expandedBusinessMap['food']?.addAll(List.generate(food.length, (index) => false));

        break;
    }
    context.read<MeetsLoadingController>().isLoadingThird = false;

    notifyListeners();
  }

  void set pickedLocation(Address? address) {
    _pickedLocation = address;
    notifyListeners();
  }

  void set pickedLocationWithoutNotify(Address? address) {
    _pickedLocation = address;
  }

  void set selectedSuggestion(Suggestion? placeSuggestion) {
    _selectedSuggestion = placeSuggestion;
    notifyListeners();
  }

  Future<List<SkibbleFoodBusiness>> getAllNearbyYelpFoodBusinesses(BuildContext context, String businessSearchTerm, {int? offset}) async {
    try {
      var currentUserLocation = await GeoLocatorService().getCurrentPositionAddress(context);

      // print(currentUserLocation?.latitude);
      // print(currentUserLocation?.longitude);
      //
      // print(await GeoLocatorService().getDistance(currentUserLocation!.latitude!, currentUserLocation.longitude!, 46.23393, -63.1221356));

      if(currentUserLocation != null) {
        var result = await YelpService().getAllYelpFoodBusinesses(currentUserLocation, businessSearchTerm, offset: offset);
        return result ?? [];
      }
      return [];
    }
    catch(e) {
      
      return [];
    }
  }


  Future<List<SkibbleFoodBusiness>> getAllNearbyGoogleFoodBusinesses(BuildContext context, String businessSearchTerm,) async {
    try {
      var currentUserLocation = await GeoLocatorService().getCurrentPositionAddress(context);


      if(currentUserLocation != null) {
        var result = await GoogleMapsService().getNearbyFoodBusinesses('${currentUserLocation.stateOrProvince ?? 'food'}', '40000', businessSearchTerm, currentUserLocation);
        return result ?? [];
      }
      return [];
    }
    catch(e) {
      
      return [];
    }
  }

  Future<List<SkibbleFoodBusiness>> getMoreNearbyGoogleFoodBusinesses(BuildContext context, String businessSearchTerm, {String? nextToken}) async {
    try {
      var currentUserLocation = await GeoLocatorService().getCurrentPositionAddress(context);


      if(nextToken == null) return [];

      if(currentUserLocation != null) {
        var result = await GoogleMapsService().getMoreNearbyFoodBusinesses('${currentUserLocation.stateOrProvince ?? 'food'}', '40000', businessSearchTerm, currentUserLocation, nextToken: nextToken);
        return result ?? [];
      }
      return [];
    }
    catch(e) {

      return [];
    }
  }

  Future<SkibbleFoodBusiness?> getYelpFoodBusinessDetails(BuildContext context, SkibbleFoodBusiness business) async {
    try {
        return await YelpService().getYelpFoodBusinessesDetails(business);
    }
    catch(e) {
      return null;
    }
  }



  Future<SkibbleFoodBusiness?> getGoogleFoodBusinessDetails(BuildContext context, String query, SkibbleFoodBusiness business) async {
    try {

      var googlePlaceTextSearch = await GoogleMapsService().getPlacesWithTextSearch(query, business.address);
      if(googlePlaceTextSearch != null && googlePlaceTextSearch.isNotEmpty) {
        var googlePlace = await GoogleMapsService().getPlaceDetails(googlePlaceTextSearch[0].googlePlaceId!);

        return SkibbleFoodBusiness(
          address: Address.fromGooglePlaceDetails(googlePlace!),
          skibbleBusinessType: SkibbleBusinessType.google,
          skibblePlaceId: googlePlaceTextSearch[0].googlePlaceId!,
          googlePlaceDetails: googlePlace
        );
      }
      else {return null;}

    }
    catch(e) {
      
      return null;
    }
  }


  Future<SkibbleFoodBusiness?> getGoogleFoodBusinessDetailsFromYelp(BuildContext context, SkibbleFoodBusiness business) async {
    try {

      var googlePlaceTextSearch = await GoogleMapsService().getPlacesWithTextSearch(business.yelpBusinessDetails!.name!, business.address);

      if(googlePlaceTextSearch != null && googlePlaceTextSearch.isNotEmpty) {
        var googlePlace = await GoogleMapsService().getPlaceDetails(googlePlaceTextSearch[0].googlePlaceId!);

        return SkibbleFoodBusiness(
          address: Address.fromGooglePlaceDetails(googlePlace!),
          skibbleBusinessType: SkibbleBusinessType.yelpGoogle,
          googlePlaceDetails: googlePlace,
          skibblePlaceId: '${googlePlace.googlePlaceId}_${business.yelpBusinessDetails}',
          yelpBusinessDetails: business.yelpBusinessDetails,
          isFullYelpDetailsFetched: business.isFullYelpDetailsFetched,
          isFullGoogleDetailsFetched: true,
        );

      }
      else {return null;}

    }
    catch(e) {
      
      return null;
    }
  }

  void getGooglePlaceSuggestions(BuildContext context, String pattern) async {
    try {
      if(pattern.trim().length > 1) {
        if(context.read<AppData>().userCurrentLocation == null)
          var currentUserLocation = await GeoLocatorService().getCurrentPositionAddress(context);



        var result = await GoogleMapsService().getPlaceSuggestions(pattern, _session!, type: ['restaurant', 'bar', 'cafe'], address: context.read<AppData>().userCurrentLocation);
        _placeSuggestions = result;
        notifyListeners();
      }
    }
    catch(e) {}
  }

  Future<void> showLocationPickerSheet(context, {List<String>? restrictedCountries}) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return LocationPickerView(restrictedCountries: restrictedCountries,);
        });
  }

}